Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1455728314.2925.236.camel@hpe.com>
Subject: Re: [PATCH] x86/mm: Add x86 valid_phys_addr_range() for /dev/mem
From: Toshi Kani <toshi.kani@hpe.com>
Date: Wed, 17 Feb 2016 09:58:34 -0700
In-Reply-To: <20160217092945.GB19001@gmail.com>
References: <1455069975-14291-1-git-send-email-toshi.kani@hpe.com>
	 <20160217092945.GB19001@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de, linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2016-02-17 at 10:29 +0100, Ingo Molnar wrote:
> * Toshi Kani <toshi.kani@hpe.com> wrote:
> 
> > x86 does not define ARCH_HAS_VALID_PHYS_ADDR_RANGE, which
> > leads /dev/mem to use the default valid_phys_addr_range()
> > and valid_mmap_phys_addr_range() in drivers/char/mem.c.
> > 
> > The default valid_phys_addr_range() allows any range lower
> > than __pa(high_memory), which is the end of system RAM, and
> > disallows any range higher than it.
> > 
> > Persistent memory may be located at lower and/or higher
> > address of __pa(high_memory) depending on their memory slots.
> > When using crash(8) via /dev/mem for analyzing data in
> > persistent memory, it can only access to the one lower than
> > __pa(high_memory).
> > 
> > Add x86 valid_phys_addr_range() and valid_mmap_phys_addr_range()
> > to provide better checking:
> >  - Physical address range is valid when it is fully backed by
> >    IORESOURCE_MEM, regardless of __pa(high_memory).
> >  - Other ranges, including holes, are invalid.
> > 
> > This also allows crash(8) to access persistent memory ranges
> > via /dev/mem (with a minor change to remove high_memory check
> > from crash itself).
> > 
> > Note, /dev/mem makes additional check with devmem_is_allowed()
> > for read/write when CONFIG_STRICT_DEVMEM is set, and does always
> > for mmap.  CONFIG_IO_STRICT_DEVMEM provides further restriction.
 :
> So it's hard to judge the quality of these new APIs without seeing their
> actual usecases. So please Cc: me to whatever work this is used in, and
> I'll have a look in that context.

Great!  The source code of crash(8) is available in the github below.
https://github.com/crash-utility/crash

crash is a tool to analyze memory data via a crashdump file or /dev/mem.  I
am trying to make this tool works on NVDIMM via /dev/mem. (NVDIMM ranges
are not saved to a crashdump file, but are persistent anyway.)  We had BTT
metadata corruptions, and this tool can be helpful to verify such data
until we have better tools.
https://lkml.org/lkml/2016/2/11/674

When /dev/mem is specified as the source, read_dev_mem() is set to pc-
>readmem as the read function to /dev/mem.  read_dev_mem() is at line 2268
of the file blow.
https://github.com/crash-utility/crash/blob/master/memory.c

read_dev_mem() has the same high_memory check (i.e. mirroring the /dev/mem
restriction), which should also be removed after this patch is accepted.
 Falling back to /dev/kmem does not help since read_kmem() in the 
kernel has check to high_memory in the function itself.  With this patch,
read_dev_mem() works on NVDIMM ranges.

Let me know if you have any question.
Thanks,
-Toshi
