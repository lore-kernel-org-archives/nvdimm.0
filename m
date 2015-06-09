Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 9 Jun 2015 08:55:49 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 4/9] dax: fix mapping lifetime handling, convert to
	__pfn_t + kmap_atomic_pfn_t()
Message-ID: <20150609065548.GC10167@lst.de>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com> <20150605211924.20751.434.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150605211924.20751.434.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, arnd@arndb.de, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, hch@lst.de, mingo@kernel.org, tj@kernel.org, paulus@samba.org, hpa@zytor.com, schwidefsky@de.ibm.com, willy@linux.intel.com, ross.zwisler@linux.intel.com, torvalds@linux-foundation.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 05, 2015 at 05:19:24PM -0400, Dan Williams wrote:
> The primary source for non-page-backed page-frames to enter the system
> is via the pmem driver's ->direct_access() method.  The pfns returned by
> the top-level bdev_direct_access() may be passed to any other subsystem
> in the kernel and those sub-systems either need to assume that the pfn
> is page backed (CONFIG_DEV_PFN=n) or be prepared to handle non-page
> backed case (CONFIG_DEV_PFN=y).  Currently the pfns returned by
> ->direct_access() are only ever used by vm_insert_mixed() which does not
> care if the pfn is mapped.  As we go to add more usages of these pfns
> add the type-safety of __pfn_t.
> 
> This also simplifies the calling convention of ->direct_access() by not
> returning the virtual address in the same call.  This annotates cases
> where the kernel is directly accessing pmem outside the driver, and
> makes the valid lifetime of the reference explicit.  This property may
> be useful in the future for invalidating mappings to pmem, but for now
> it provides some protection against the "pmem disable vs still-in-use"
> race.
> 
> Note that axon_ram_direct_access and dcssblk_direct_access were
> previously making potentially incorrect assumptions about the addresses
> they passed to virt_to_phys().

This looks generally good.

The subject line is a little confusing as the main change is that
it moves the responsibility of mapping a PFN returned from 
->direct_access to a kernel virtual address to the caller, so I'd
suggest to reflect this.

Second all the ifdef HAVE_KMAP_PFN is horribly ugly.  I'd suggest
to try hard to offer it on all architectures and select it from
the drivers that need it.

Third it seems like this breaks axonram and dcssblk as powerpc
and s390 don't define HAVE_KMAP_PFN yet unless I missed something.

