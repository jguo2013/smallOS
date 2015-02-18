#ifndef JOS_KERN_E1000_H
#define JOS_KERN_E1000_H

#include <inc/types.h>

#define TDESC_ARRAY_SIZE   128
#define RDESC_ARRAY_SIZE   128

#define L32_MAC_ADDR	   0x12005452
#define H16_MAC_ADDR	   0x00005634

#define D82540EM_DEVICE_ID	0x100E			//destop
#define M82540EM_DEVICE_ID 	0x1015			//mobile
#define E1000_VENDOR_ID  	0x8086

#define E1000_CTRL_REG		(0x00000000/4)	//Device Control Register
#define E1000_SET_CTRL_REG(v,rst)	(v|(rst<<26))

#define E1000_STATUS_REG	(0x00000008/4)	//Device Status Register

#define E1000_TDBAL_REG		(0x00003800/4)	//low Transmit Descriptr Base Register	
#define E1000_TDBAH_REG		(0x00003804/4)	//high Transmit Descriptr Base Register

#define E1000_TDLEN_REG		(0x00003808/4)	//Transmit Descriptor Length Register
#define E1000_TDH_REG		(0x00003810/4)		
#define E1000_TDT_REG		(0x00003818/4)	//Transmit Descriptor Head and Tail	:	write after TCTL.RST and before TCTL.EN

#define E1000_TCTRL_REG		(0x00000400/4)	//Transmit Control Register
#define E1000_TCTRL_EN		 0x00000002		//Enable bit 1
#define E1000_TCTRL_PSP		 0x00000008		//Pad Short Packets	bit 3
#define E1000_TCTRL_CT		 0x000000F0		//Collision Threshold	 bit 11:4 recommended value : 0xF
#define E1000_TCTRL_COLD	 0x00040000		//Collision Distance	bit 21:12	full duplex	: 0x40

#define E1000_TIPG_REG		(0x00000410/4)	//Transmit IPG
#define E1000_TIPG_IPGT		 0x00000010		//Transmit IPG bit 9:0 : 10
#define E1000_TIPG_IPGR1	 0x00004000		//Transmit IPGR1 bit 19:10 : 10
#define E1000_TIPG_IPGR2	 0x01000000		//Transmit IPGR2 bit 29:20 : 10

#define E1000_TDESC_IFCS	 0x2			//E1000_TDESC_CMD
#define E1000_TDESC_IC		 0x4
#define E1000_TDESC_RS		 0x8

#define E1000_SET_TDESC_EOP(v,f)	(v|f)
#define E1000_GET_TDESC_DD(v)	(v&0x1)		//E1000_TDESC_STA

#define E1000_RDAL_REG		(0x00005400/4)	//Receive Address Low	
#define E1000_RDAH_REG		(0x00005404/4)	//Receive Address High
#define E1000_RDAH_AS		 0x00000000		//Address Select : 00 for normal op
#define E1000_RDAH_AV		 0x80000000		//Address Valid

#define E1000_MTA_START_REG	(0x00005200/4)	//Multicast Table Array
#define E1000_MTA_END_REG	(0x000053FC/4)

#define E1000_IMS_REG		(0x000000D0/4)	//Interrupt Mask Set/Read (IMS) register check RXT, RXO, RXDMT, RXSEQ, and LSC if enabled

#define E1000_RDBAL_REG		(0x00002800/4)	//low Receive Descriptr Base Register	
#define E1000_RDBAH_REG		(0x00002804/4)	//high Receive Descriptr Base Register

#define E1000_RDLEN_REG		(0x00002808/4)	//Receive Descriptor Length Register
#define E1000_RDH_REG		(0x00002810/4)	//Receive Descriptor Head
#define E1000_RDT_REG		(0x00002818/4)	//Receive Descriptor Tail

#define E1000_RCTRL_REG		(0x00000100/4)	//Transmit Control Register
#define E1000_RCTRL_EN		 0x00000002		//Receiver Enable : bit 1 = 1
#define E1000_RCTRL_SBP		 0x00000000		//Store Bad Packets	: bit 2 = 0 not store by default
#define E1000_RCTRL_UPE		 0x00000000		//Unicast Promiscuous Enabled	: bit 3 = 0 disable by default
#define E1000_RCTRL_UPE		 0x00000000		//Multicast Promiscuous Enabled: bit 4 = 0 disable by default
#define E1000_RCTRL_LPE		 0x00000000		//Long Packets	Enable : bit 5 : 0
#define E1000_RCTRL_LBM		 0x00000000		//Loopback : bit 6:7 : 0
#define E1000_RCTRL_RDMTS	 0x00000200		//Receive Descriptor Minimum Threshold Size : bit 9:8 : 10 = 1/8 RDLEN
#define E1000_RCTRL_MO		 0x00000000		//Multicast Offset	: bit 13:12	 try 0
#define E1000_RCTRL_BAM		 0x00000000		//Broadcast Accept Mode	: bit 15 not accept broadcast try 0
#define E1000_RCTRL_BSIZE	 0x00000000		//Receive Buffer Size	 : bit 17:16 00 = 2048 by default
#define E1000_RCTRL_BSE		 0x00000000		//Buffer Size Extension : bit 25 0 = 2048 max 2048
#define E1000_RCTRL_SECRC	 0x04000000		//Strip Ethernet CRC 	: bit 26 = 1 skip

#define E1000_GET_RDESC_DD(v)	(v&0x1)		//E1000_RDESC_STATUS

struct tx_desc
{
	uint64_t	addr;
	uint16_t	length;
	uint8_t		cso;
	uint8_t		cmd;
	uint8_t		status;
	uint8_t		css;
	uint16_t	special;
};

struct rx_desc
{
	uint64_t	addr;
	uint16_t	length;
	uint16_t	checksum;
	uint8_t		status;
	uint8_t		err;
	uint16_t	special;
};

void e1000w(int index, int value);

uint32_t e1000r(int index);

void e1000_init(physaddr_t pa, size_t size);

int e1000_tx_queue_full();

int e1000_tx_packet(void * buf, uint32_t size);

int e1000_rx_queue_empty();

int e1000_rx_packet(void * buf, uint32_t * size);

//extern uint32_t *e1000;

#endif	// JOS_KERN_E1000_H
