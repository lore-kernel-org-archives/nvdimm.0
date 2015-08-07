Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
Date: Fri, 7 Aug 2015 09:47:03 -0700
Message-ID: <CAPcyv4gJM1RRp3ShDf239g_gkcmkz8dN_f0GBOPeXc65YH4+EQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] pmem, dax: I/O path enhancements
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juergen Gross <jgross@suse.com>, Len Brown <lenb@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@suse.com>, Matthew Wilcox <willy@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>, X86 ML <x86@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 6, 2015 at 10:43 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Patch 5 adds support for the "read flush" _DSM flag, allowing us to change the
> ND BLK aperture mapping from write-combining to write-back via memremap_pmem().
>
> Patch 6 updates the DAX I/O path so that all operations that store data (I/O
> writes, zeroing blocks, punching holes, etc.) properly synchronize the stores
> to media using the PMEM API.  This ensures that the data DAX is writing is
> durable on media before the operation completes.
>
> Patches 1-4 are cleanup patches and additions to the PMEM API that make
> patches 5 and 6 possible.
>
> Regarding the choice to add both flush_cache_pmem() and wb_cache_pmem() to the
> PMEM API, I had initially implemented flush_cache_pmem() as a generic function
> flush_io_cache_range() in the spirit of flush_cache_range(), etc., in
> cacheflush.h.  I eventually moved it into the PMEM API because a) it has a
> common and consistent use of the __pmem annotation, b) it has a clear fallback
> method for architectures that don't support it, as opposed to APIs in
> cacheflush.h which would need to be added individually to all other
> architectures.  It can be argued that the flush API could apply to other uses
> beyond PMEM such as flushing cache lines associated with other types of
> sliding MMIO windows.  At this point I'm inclined to have it as part of the
> PMEM API, and then take on the effort of making it a general cache flusing API
> if other users come along.

I'm not convinced.  There are already existing users for invalidating
a cpu cache and they currently jump through hoops to have cross-arch
flushing, see drm_clflush_pages().  What the NFIT-BLK driver brings to
the table is just one more instance where the cpu cache needs to be
invalidated, and for something so fundamental it is time we had a
cross arch generic helper.

The cache-writeback case is different.  To date we've only used
writeback for i/o-incoherent archs.  x86 now for the first time needs
(potentially) a writeback api specifically for guaranteeing
persistence.  I say "potentially" because all the cases where we need
to guarantee persistence could be handled with non-temporal stores.

The __pmem annotation is a separate issue that we need to tackle.  I
think Christoph is already on team "__pmem is a mistake", but I think
we should walk through what carrying it forward would look like.  The
__pfn_t patches allow for flags to be attached to the pfn(s) returned
from ->direct_access().  We could add a PFN_PMEM flag and teach
kmap_atomic_pfn_t() to only operate on !PFN_PMEM pfns.  A new
"kmap_atomic_pmem()" would be needed to map pfns from the pmem
driver's ->direct_access() and that would return "void __pmem *".  I
think this would force DAX to always be "__pmem clean" regardless of
whether we got the pfns from BRD or PMEM.  It becomes messy when we
consider carrying __pfn_t in a bio_vec.  But, I think it becomes messy
in precisely the right way in that drivers that want to setup
DMA-to-pmem should consciously be handling the __pmem annotation and
the resulting side effects.
