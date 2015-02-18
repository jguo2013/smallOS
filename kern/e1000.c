#include <kern/e1000.h>
#include <kern/pmap.h>
#include <inc/error.h>
#include <inc/string.h>
#include <kern/env.h>

// LAB 6: Your driver code here

volatile uint32_t *e1000;	//virtual addr of mem reg (bar)
volatile struct tx_desc *tdesc_addr;
volatile struct rx_desc *rdesc_addr;
int tx_head = 0;
int tx_tail = 0;
int rx_head = 0;
int rx_tail = 0;

inline void e1000w(int index, int value)
{
	e1000[index] = value;
	//cprintf("%s set %x to addr %x\n",__func__,value,index);
}

inline uint32_t e1000r(int index)
{
	return e1000[index];
}

void e1000_init(physaddr_t pa, size_t size)
{
	uint32_t ssize,i;	
	struct PageInfo *pp;
	
	e1000 = mmio_map_region(pa,size);
	cprintf("physical addr %x (size %u) mapped to %x\n",pa, size, (uint32_t)e1000);

	//transmit configuration
	//alloc tdesc frame
	ssize = TDESC_ARRAY_SIZE*sizeof(struct tx_desc);
	if(ssize > PGSIZE) panic("tdesc array size overflow\n");
	
	pp = page_alloc(1);
	if(!pp)	panic("tdesc alloc page error\n");
	tdesc_addr = KADDR(page2pa(pp));
	if((uint32_t)tdesc_addr < KERNBASE) panic("test_addr is out of range");
	
	e1000w(E1000_TDBAL_REG,PADDR((void *)tdesc_addr));
	e1000w(E1000_TDBAH_REG,0);
	e1000w(E1000_TDLEN_REG,ssize);
	
	e1000w(E1000_TDH_REG,0);
	e1000w(E1000_TDT_REG,0);

	e1000w(E1000_TIPG_REG,E1000_TIPG_IPGT);
	e1000w(E1000_TCTRL_REG,E1000_TCTRL_EN|E1000_TCTRL_PSP|E1000_TCTRL_CT|E1000_TCTRL_COLD);
	
	//receive configuration
	//alloc rdesc frame
	//init rda and mar
	//alloc rx buf
	e1000w(E1000_RDAL_REG,L32_MAC_ADDR);
	e1000w(E1000_RDAH_REG,H16_MAC_ADDR|E1000_RDAH_AS|E1000_RDAH_AV);

	for(i=E1000_MTA_START_REG;i<E1000_MTA_END_REG;i+=4) e1000w(i,0);
	e1000w(E1000_IMS_REG,0);

	e1000w(E1000_RDH_REG,rx_head);
	e1000w(E1000_RDT_REG,rx_tail);

	ssize = RDESC_ARRAY_SIZE*sizeof(struct rx_desc);
	if(ssize > PGSIZE) panic("rdesc array size overflow\n");
	
	pp = page_alloc(1);
	if(!pp)	panic("rdesc alloc page error\n");
	rdesc_addr = KADDR(page2pa(pp));

	e1000w(E1000_RDBAL_REG,PADDR((void *)rdesc_addr));
	e1000w(E1000_RDBAH_REG,0);
	e1000w(E1000_RDLEN_REG,ssize);

	for(i=0;i<RDESC_ARRAY_SIZE;i++)
	{
		memset((void *)KADDR(rdesc_addr[i].addr),0,sizeof(struct rx_desc));
		pp = page_alloc(1);
		if(!pp) panic("buf alloc page error\n");
		rdesc_addr[i].addr = page2pa(pp);	
	}	

	e1000w(E1000_RCTRL_REG,
		   E1000_RCTRL_EN|E1000_RCTRL_SBP|E1000_RCTRL_UPE|E1000_RCTRL_UPE|E1000_RCTRL_LPE|E1000_RCTRL_LBM|
		   E1000_RCTRL_RDMTS|E1000_RCTRL_MO|E1000_RCTRL_BAM|E1000_RCTRL_BSIZE|E1000_RCTRL_BSE|E1000_RCTRL_SECRC);
}

int e1000_tx_queue_full()
{
	
	if(tx_head==tx_tail && !tdesc_addr[tx_head].cmd) return 0;

	if(!E1000_GET_TDESC_DD(tdesc_addr[tx_head].status)) return -E_NO_TXDESC;

	page_free(pa2page(tdesc_addr[tx_head].addr));
	tdesc_addr[tx_head].addr = 0;
	tdesc_addr[tx_head].cmd = 0;
	tdesc_addr[tx_head].status = 0;
	tdesc_addr[tx_head].length = 0;
	
	tx_head = (tx_head+1)%TDESC_ARRAY_SIZE;

	return 0;
}

//if the tx desc queue is not full, alloc a space and set rs, move tail
//if tx desc queue is full and then head is empty
//if empty, clean and inc head
//if not empty, return -E_NO_TXDESC
int e1000_tx_packet(void * buf, uint32_t size)
{
	struct PageInfo *pp;
	struct tx_desc * curr;
	int i;
	
	if(e1000_tx_queue_full()) return -E_NO_TXDESC;

	if(size>PGSIZE)panic("tx size overflow\n");
	pp = page_alloc(1);
	memmove(page2kva(pp),buf,size);
	
	tdesc_addr[tx_tail].addr = page2pa(pp);
	tdesc_addr[tx_tail].length = size;
	tdesc_addr[tx_tail].cmd = E1000_TDESC_IFCS|E1000_TDESC_IC|E1000_TDESC_RS;
	tdesc_addr[tx_tail].cmd = E1000_SET_TDESC_EOP(tdesc_addr[tx_tail].cmd,1);
	tx_tail = (tx_tail+1)%TDESC_ARRAY_SIZE;	
	e1000w(E1000_TDT_REG,tx_tail);
	return 0;
}

int e1000_rx_queue_empty()
{
	int i;
	int dd = E1000_GET_RDESC_DD(rdesc_addr[rx_tail].status);
	if(!dd) return 1;
	//if(rx_head==rx_tail) return 1;
	else return 0;
}

//if rx queue is empty, return -E_NO_RDESC
//otherwise, return size
int e1000_rx_packet(void * buf, uint32_t * size)
{
	struct PageInfo *pp;
	int ret;
	
	if(e1000_rx_queue_empty()) return -E_NO_RDESC;

	//cprintf("get a message rx_tail %d rx_head %d rx_head status %d rx_tail status %d\n",
	//		rx_tail, rx_head, rdesc_addr[rx_head].status, rdesc_addr[rx_tail].status);
	
	if(rdesc_addr[rx_tail].length>PGSIZE)panic("rx size overflow\n");

	*size = rdesc_addr[rx_tail].length;
	//map the value to 	
	ret = page_insert(curenv->env_pgdir,pa2page(rdesc_addr[rx_tail].addr),buf,PTE_P|PTE_U|PTE_W);
	if(ret) panic("%s page insert error %e",__func__,ret);
	
	rdesc_addr[rx_tail].length = 0;
	rdesc_addr[rx_tail].status = 0;
	rx_tail = (rx_tail+1)%RDESC_ARRAY_SIZE;
	e1000w(E1000_RDT_REG,rx_tail);
	return 0;
}

