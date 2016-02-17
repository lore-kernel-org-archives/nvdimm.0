Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1455740121.2925.286.camel@hpe.com>
Subject: Re: [PATCH] x86/mm: Add x86 valid_phys_addr_range() for /dev/mem
From: Toshi Kani <toshi.kani@hpe.com>
Date: Wed, 17 Feb 2016 13:15:21 -0700
In-Reply-To: <CAPcyv4jG2Z08cN17_m96wOApRfToeqDcwu+k6tFzXz3U0beB9w@mail.gmail.com>
References: <1455069975-14291-1-git-send-email-toshi.kani@hpe.com>
	 <CAPcyv4j_TS3BXv0SyJzNg_FDdEB9uOmzTtibkS-Z_jAv_PDZiA@mail.gmail.com>
	 <1455737737.2925.280.camel@hpe.com>
	 <CAPcyv4jG2Z08cN17_m96wOApRfToeqDcwu+k6tFzXz3U0beB9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2016-02-17 at 11:05 -0800, Dan Williams wrote:
> On Wed, Feb 17, 2016 at 11:35 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> > On Wed, 2016-02-17 at 09:58 -0800, Dan Williams wrote:
> > > On Tue, Feb 9, 2016 at 6:06 PM, Toshi Kani <toshi.kani@hpe.com>
> > > wrote:
> > > > x86 does not define ARCH_HAS_VALID_PHYS_ADDR_RANGE, which
> > > > leads /dev/mem to use the default valid_phys_addr_range()
> > > > and valid_mmap_phys_addr_range() in drivers/char/mem.c.
> > > > 
> > > > The default valid_phys_addr_range() allows any range lower
> > > > than __pa(high_memory), which is the end of system RAM, and
> > > > disallows any range higher than it.
> > > > 
> > > > Persistent memory may be located at lower and/or higher
> > > > address of __pa(high_memory) depending on their memory slots.
> > > > When using crash(8) via /dev/mem for analyzing data in
> > > > persistent memory, it can only access to the one lower than
> > > > __pa(high_memory).
> > > > 
> > > > Add x86 valid_phys_addr_range() and valid_mmap_phys_addr_range()
> > > > to provide better checking:
> > > >  - Physical address range is valid when it is fully backed by
> > > >    IORESOURCE_MEM, regardless of __pa(high_memory).
> > > >  - Other ranges, including holes, are invalid.
> > > > 
> > > > This also allows crash(8) to access persistent memory ranges
> > > > via /dev/mem (with a minor change to remove high_memory check
> > > > from crash itself).
> > > 
> > > If we're modifying crash(8) can't we also teach it to mmap /dev/pmemX
> > > directly?  With commit 90a545e98126 "restrict /dev/mem to idle io
> > > memory ranges" /dev/mem should not have access to active pmem ranges.
> > 
> > Yes, I am aware of the commit.  Unloading drivers while using crash(8)
> > to analyze NVDIMM via /dev/mem makes sense.  /dev/mem does not require
> > any other drivers be loaded.
> 
> Ah, ok.  I thought this patch was bypassing that safety check.  If it
> requires the driver to be unloaded first then I'm fine with this.

Yes, crash(8) is used for analyzing static data (such as a crashdump file).
 It does not allow writing data unless user specifically enable it.

> > Using /dev/pmemX, on the other hand, requires the driver to be loaded,
> > which can be problematic.  For instance, when btt_init() fails due to
> > some corruption in arena, it fails to create any pmem device file.  A
> > dev file also restricts access range within the dev file.
> > 
> > Thanks,
> > -Toshi
> > 
> > ps.
> > Looking at iomem_is_exclusive(), it only checks the top-level iomem
> > entries.  I think the pmem/btt driver only marks a child entry busy...
> > 
> 
> It looks to me that next_resource(), via r_next(), walks child ranges.

Oh, sorry, I missed the r_next().

Thanks,
-Toshi
