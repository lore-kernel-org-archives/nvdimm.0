Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1455069975-14291-1-git-send-email-toshi.kani@hpe.com>
References: <1455069975-14291-1-git-send-email-toshi.kani@hpe.com>
Date: Wed, 17 Feb 2016 09:58:17 -0800
Message-ID: <CAPcyv4j_TS3BXv0SyJzNg_FDdEB9uOmzTtibkS-Z_jAv_PDZiA@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: Add x86 valid_phys_addr_range() for /dev/mem
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 9, 2016 at 6:06 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> x86 does not define ARCH_HAS_VALID_PHYS_ADDR_RANGE, which
> leads /dev/mem to use the default valid_phys_addr_range()
> and valid_mmap_phys_addr_range() in drivers/char/mem.c.
>
> The default valid_phys_addr_range() allows any range lower
> than __pa(high_memory), which is the end of system RAM, and
> disallows any range higher than it.
>
> Persistent memory may be located at lower and/or higher
> address of __pa(high_memory) depending on their memory slots.
> When using crash(8) via /dev/mem for analyzing data in
> persistent memory, it can only access to the one lower than
> __pa(high_memory).
>
> Add x86 valid_phys_addr_range() and valid_mmap_phys_addr_range()
> to provide better checking:
>  - Physical address range is valid when it is fully backed by
>    IORESOURCE_MEM, regardless of __pa(high_memory).
>  - Other ranges, including holes, are invalid.
>
> This also allows crash(8) to access persistent memory ranges
> via /dev/mem (with a minor change to remove high_memory check
> from crash itself).

If we're modifying crash(8) can't we also teach it to mmap /dev/pmemX
directly?  With commit 90a545e98126 "restrict /dev/mem to idle io
memory ranges" /dev/mem should not have access to active pmem ranges.
