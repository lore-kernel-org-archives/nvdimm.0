Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <56449AF3.70606@plexistor.com>
References: <5643B043.3010103@plexistor.com>
	<CAPcyv4jCg58-Je4hW=O4TT9ESeJTV-GFEUidLD9n60-z9w9V2Q@mail.gmail.com>
	<5643BB8D.4080202@plexistor.com>
	<56448FDE.4020404@plexistor.com>
	<56449AF3.70606@plexistor.com>
Date: Thu, 12 Nov 2015 09:13:47 -0800
Message-ID: <CAPcyv4gabAY-8vuK+DZv0o9OdMCpY+ayC4bXqz7PWw-C5NTs2Q@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: proper NID in e820_pmem_probe
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Stable Tree <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 12, 2015 at 5:58 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
> On 11/12/2015 03:10 PM, Boaz Harrosh wrote:
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> [Boaz]
>> What I see is that in the call to arch_add_memory() nid==0 regardless of the
>> real NID the memory is actually on.
>>
>> [Dan]
>> In the case of NFIT numa node should already be set, and in the
>> case of the memmap=ss!nn or e820-type-12 we can set the numa node
>> like this:
>>
>> [Needed for v4.3]
>> CC: Stable Tree <stable@vger.kernel.org>
>> Tested-by: Boaz Harrosh <boaz@plexistor.com>
>
> Dan thanks, of course it works perfectly well. I'm not sure if you also need my:
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
>
> So I'm happy to say that with this small fix.

Thanks for the test!  There's a small compile fix I need to add that
0day discovered, but I'll get this into a pull request before the end
of the week.

> And a big struggle to enable CONFIG_EXPERT so to disable ZONE_DMA and enable
> ZONE_DEVICE. Would you support reverting the completely dead code ZONE_DMA
> for x86_64 "on" by default so to allow an easier ZONE_DEVICE to be turned on?
> (We currently have a script sent to clients to manipulate their .config before
>  compiling their 4.3 based Kernel)

Changing that default would be a question to the x86 maintainers.  I
agree that ZONE_DMA should be opt-in rather than opt-out on modern
systems.

> So as I said I'm happy to announce that with the 4.3 Kernel (+ fix) I'm able
> to run my all system, same as with my old system, but without any Kernel patching.
> (Almost, just one optimization for write page-faults).
>
> Including:
> - Direct IO of pmem-pages to slower SSD / harddisk / iscai block devices
> - RDMA from pmem-pages directly.
> - pmem direct RDMA target machine.

Really?  How do you achieve these 3 features without get_user_pages()
for DAX mappings?  Do you have a custom driver in the kernel that is
just going pfn_to_page()?

> - Cluster wide unified pmem access
> - VM access to pmem
>
> We still carry a few of our own persistent assembly calls, but just because
> the Kernel's ones are a bit of a mixed mess.

Would be interested to see them.  We're currently looking at
performance enhancements in this area.

>
> The only complain I have with 4.3 is the wrong and scary message in my logs
> on my perfectly healthy and thriving ADR system with NvDIMMs that says:
>
>         "d_pmem namespace0.0: unable to guarantee persistence of writes"
>
> As I told you in our talk, (Ever so gently and with full respect), you guys
> made a bit of mess with the none-existent PCOMMIT instruction and NvDIMM persistency.
> With a complete ADR system, even CPUs without PCOMMIT instruction are persistence
> safe because of system support in flushing of MEM/IO buffers on a power loss.
>
> So you see the Kernel can not really say if the system is actually
> "guarantee persistence". I'd send a fix for this all mess, once I have a bit
> of time. (The mess I mean the all PCOMMIT thing that not a single CPU in existence
> has support off, and actually it was put on hold for any real hardware. And some
> missing corner cases of wrongness with persistency, as we found in testing)

I agree that the ADR situation is a bit of a mess since ACPI provides
no mechanism to tell you that it is available.  I wouldn't be opposed
to whitelisting certain platforms or use a sideband mechanism to check
for ADR.  It's just not clear to me how to reliably determine if ADR
is available and functional.

How about a kernel parameter like "libnvdimm.adr=1" to tell the kernel
to ignore the absence of pcommit?

> 4.4 stuff I have not touched yet at all. Will do ASAP and report once I tested it.

Appreciate it.

> [And we are still waiting for any NFIT system which is currently a complete
>  vaporware. Intel said it will not upgrade any of our ADR systems BIOS/EUFI
>  to NFIT. And there is no date yet for any new NFIT systems.
>  You need to please send me instructions on how to compile my own QEMU with
>  NFIT support, because I do not have any means currently to test my code with
>  NFIT]

The QEMU NFIT enabling is progressing, but not yet merged it seems.

http://marc.info/?l=qemu-devel&m=144645659908290&w=2
