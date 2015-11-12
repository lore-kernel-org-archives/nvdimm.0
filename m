Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <56449AF3.70606@plexistor.com>
Date: Thu, 12 Nov 2015 15:58:11 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH] nvdimm: proper NID in e820_pmem_probe
References: <5643B043.3010103@plexistor.com> <CAPcyv4jCg58-Je4hW=O4TT9ESeJTV-GFEUidLD9n60-z9w9V2Q@mail.gmail.com> <5643BB8D.4080202@plexistor.com> <56448FDE.4020404@plexistor.com>
In-Reply-To: <56448FDE.4020404@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Stable Tree <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 11/12/2015 03:10 PM, Boaz Harrosh wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> [Boaz]
> What I see is that in the call to arch_add_memory() nid==0 regardless of the
> real NID the memory is actually on.
> 
> [Dan]
> In the case of NFIT numa node should already be set, and in the
> case of the memmap=ss!nn or e820-type-12 we can set the numa node
> like this:
> 
> [Needed for v4.3]
> CC: Stable Tree <stable@vger.kernel.org>
> Tested-by: Boaz Harrosh <boaz@plexistor.com>

Dan thanks, of course it works perfectly well. I'm not sure if you also need my:
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>

So I'm happy to say that with this small fix.

And a big struggle to enable CONFIG_EXPERT so to disable ZONE_DMA and enable
ZONE_DEVICE. Would you support reverting the completely dead code ZONE_DMA
for x86_64 "on" by default so to allow an easier ZONE_DEVICE to be turned on?
(We currently have a script sent to clients to manipulate their .config before
 compiling their 4.3 based Kernel)

So as I said I'm happy to announce that with the 4.3 Kernel (+ fix) I'm able
to run my all system, same as with my old system, but without any Kernel patching.
(Almost, just one optimization for write page-faults).

Including:
- Direct IO of pmem-pages to slower SSD / harddisk / iscai block devices
- RDMA from pmem-pages directly.
- pmem direct RDMA target machine.
- Cluster wide unified pmem access
- VM access to pmem

We still carry a few of our own persistent assembly calls, but just because
the Kernel's ones are a bit of a mixed mess.

The only complain I have with 4.3 is the wrong and scary message in my logs
on my perfectly healthy and thriving ADR system with NvDIMMs that says:

	"d_pmem namespace0.0: unable to guarantee persistence of writes"

As I told you in our talk, (Ever so gently and with full respect), you guys
made a bit of mess with the none-existent PCOMMIT instruction and NvDIMM persistency.
With a complete ADR system, even CPUs without PCOMMIT instruction are persistence
safe because of system support in flushing of MEM/IO buffers on a power loss.

So you see the Kernel can not really say if the system is actually
"guarantee persistence". I'd send a fix for this all mess, once I have a bit
of time. (The mess I mean the all PCOMMIT thing that not a single CPU in existence
has support off, and actually it was put on hold for any real hardware. And some
missing corner cases of wrongness with persistency, as we found in testing)

So Cheers Sir Dan. 4.3 rocks and we are able to work without any Kernel patches.
4.4 stuff I have not touched yet at all. Will do ASAP and report once I tested it.

[And we are still waiting for any NFIT system which is currently a complete
 vaporware. Intel said it will not upgrade any of our ADR systems BIOS/EUFI
 to NFIT. And there is no date yet for any new NFIT systems.
 You need to please send me instructions on how to compile my own QEMU with
 NFIT support, because I do not have any means currently to test my code with
 NFIT]

Thanks
Boaz

> ---
>  drivers/nvdimm/e820.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
> index 8282db2..e40df8f 100644
> --- a/drivers/nvdimm/e820.c
> +++ b/drivers/nvdimm/e820.c
> @@ -48,7 +48,7 @@ static int e820_pmem_probe(struct platform_device *pdev)
>  		memset(&ndr_desc, 0, sizeof(ndr_desc));
>  		ndr_desc.res = p;
>  		ndr_desc.attr_groups = e820_pmem_region_attribute_groups;
> -		ndr_desc.numa_node = NUMA_NO_NODE;
> +		ndr_desc.numa_node = memory_add_physaddr_to_nid(p->start);
>  		set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
>  		if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
>  			goto err;
> 

