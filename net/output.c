#include "ns.h"
#include <inc/ns.h>

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
//void
//umain(int argc, char **argv)
{

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
	uint32_t req, whom;
	int perm, ret;
	void *pg;

	binaryname = "ns_output";
	//cprintf("output is running\n");

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, &nsipcbuf, &perm);

		cprintf("%s req %d from %08x size %u\n", __func__, req, whom, nsipcbuf.pkt.jp_len);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) 
		{
			cprintf("Invalid request from %08x: no argument page\n",whom);
			continue;
		}

		if(whom != ns_envid)
			panic("%s get message from wrong environments",__func__);

		do 
		{ret = sys_net_send(nsipcbuf.pkt.jp_data,nsipcbuf.pkt.jp_len);}
		while(ret == -E_NO_TXDESC);

		if(ret)panic("output error %e\n",ret);
	}
	
}
