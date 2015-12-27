Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <20151221054433.34542.73933.stgit@dwillia2-desk3.jf.intel.com>
References: <20151221054406.34542.64393.stgit@dwillia2-desk3.jf.intel.com>
	<20151221054433.34542.73933.stgit@dwillia2-desk3.jf.intel.com>
Date: Sun, 27 Dec 2015 16:40:08 +0800
Message-ID: <CAA_GA1e8-MaekpLSya8YJJy-uu9izkH3g69c3q2OPut=YhioKA@mail.gmail.com>
Subject: Re: [-mm PATCH v4 05/18] x86, mm: introduce vmem_altmap to augment vmemmap_populate()
From: Bob Liu <lliubbo@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Linux-MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 21, 2015 at 1:44 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> In support of providing struct page for large persistent memory
> capacities, use struct vmem_altmap to change the default policy for
> allocating memory for the memmap array.  The default vmemmap_populate()
> allocates page table storage area from the page allocator.  Given

Nitpick, I think you mean 'memmap storage area' here?  Page table
storage area still allocated from DRAM even after vmem_altmap
introduced.

Regards,
Bob

> persistent memory capacities relative to DRAM it may not be feasible to
> store the memmap in 'System Memory'.  Instead vmem_altmap represents
> pre-allocated "device pages" to satisfy vmemmap_alloc_block_buf()
> requests.
>
> Cc: x86@kernel.org
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/mm/init_64.c          |   33 ++++++++++++++---
>  drivers/nvdimm/pmem.c          |    6 ++-
>  include/linux/memory_hotplug.h |    3 +-
>  include/linux/memremap.h       |   39 ++++++++++++++++++---
>  include/linux/mm.h             |    9 ++++-
>  kernel/memremap.c              |   72 +++++++++++++++++++++++++++++++++++++-
>  mm/memory_hotplug.c            |   67 +++++++++++++++++++++++++----------
>  mm/page_alloc.c                |   11 +++++-
>  mm/sparse-vmemmap.c            |   76 +++++++++++++++++++++++++++++++++++++++-
>  mm/sparse.c                    |    8 +++-
>  10 files changed, 282 insertions(+), 42 deletions(-)
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
