#include "ns.h"
#include <inc/lib.h>
#include <inc/mmu.h>

extern union Nsipc nsipcbuf;
extern union Nsipc nsipcbuf_1;

#define INPUT_PKTMAP 0x10000000

void
input(envid_t ns_envid)
//void
//umain(int argc, char **argv)
{
	uint32_t req, whom, size;
	int perm, ret, even_odd = 0;
	envid_t to_env;

	binaryname = "ns_input";

	// LAB 6: Your code here:
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.

	while (1) 
	{
		ret = sys_net_receive((void *)INPUT_PKTMAP,&size);
		if( ret == -E_NO_RDESC ) 
		  {sys_yield(); continue;}
		cprintf("%s get an input packet size %u\n",__func__,size);

		if(even_odd)
		{
			nsipcbuf.pkt.jp_len = size;
			memmove(nsipcbuf.pkt.jp_data,(void *)INPUT_PKTMAP,nsipcbuf.pkt.jp_len);
			ipc_send(ns_envid,NSREQ_INPUT,&nsipcbuf,PTE_P|PTE_W|PTE_U);

		}
		else
		{
			nsipcbuf_1.pkt.jp_len = size;
			memmove(nsipcbuf_1.pkt.jp_data,(void *)INPUT_PKTMAP,nsipcbuf_1.pkt.jp_len);
			ipc_send(ns_envid,NSREQ_INPUT,&nsipcbuf_1,PTE_P|PTE_W|PTE_U);
		}
		even_odd = (even_odd+1)%2;
		sys_yield();
		//if(ret)panic("send input error %e\n",ret);*/
	}	
}

