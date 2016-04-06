Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 7502D1A1FB3
 for <linux-nvdimm@lists.01.org>; Wed,  6 Apr 2016 09:50:30 -0700 (PDT)
Date: Wed, 6 Apr 2016 12:50:27 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] x86 get_unmapped_area: Add PMD alignment for DAX PMD mmap
Message-ID: <20160406165027.GA2781@linux.intel.com>
References: <1459951089-14911-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459951089-14911-1-git-send-email-toshi.kani@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-mm@kvack.org, hpa@zytor.com, tglx@linutronix.de, bp@suse.de, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 06, 2016 at 07:58:09AM -0600, Toshi Kani wrote:
> When CONFIG_FS_DAX_PMD is set, DAX supports mmap() using PMD page
> size.  This feature relies on both mmap virtual address and FS
> block data (i.e. physical address) to be aligned by the PMD page
> size.  Users can use mkfs options to specify FS to align block
> allocations.  However, aligning mmap() address requires application
> changes to mmap() calls, such as:
> 
>  -  /* let the kernel to assign a mmap addr */
>  -  mptr = mmap(NULL, fsize, PROT_READ|PROT_WRITE, FLAGS, fd, 0);
> 
>  +  /* 1. obtain a PMD-aligned virtual address */
>  +  ret = posix_memalign(&mptr, PMD_SIZE, fsize);
>  +  if (!ret)
>  +    free(mptr);  /* 2. release the virt addr */
>  +
>  +  /* 3. then pass the PMD-aligned virt addr to mmap() */
>  +  mptr = mmap(mptr, fsize, PROT_READ|PROT_WRITE, FLAGS, fd, 0);
> 
> These changes add unnecessary dependency to DAX and PMD page size
> into application code.  The kernel should assign a mmap address
> appropriate for the operation.

I question the need for this patch.  Choosing an appropriate base address
is the least of the changes needed for an application to take advantage of
DAX.  The NVML chooses appropriate addresses and gets a properly aligned
address without any kernel code.

> Change arch_get_unmapped_area() and arch_get_unmapped_area_topdown()
> to request PMD_SIZE alignment when the request is for a DAX file and
> its mapping range is large enough for using a PMD page.

I think this is the wrong place for it, if we decide that this is the
right thing to do.  The filesystem has a get_unmapped_area() which
should be used instead.

> @@ -157,6 +157,13 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
>  		info.align_mask = get_align_mask();
>  		info.align_offset += get_align_bits();
>  	}
> +	if (filp && IS_ENABLED(CONFIG_FS_DAX_PMD) && IS_DAX(file_inode(filp))) {

And there's never a need for the IS_ENABLED.  IS_DAX() compiles to '0' if
CONFIG_FS_DAX is disabled.

And where would this end?  Would you also change this code to look for
1GB entries if CONFIG_FS_DAX_PUD is enabled?  Far better to have this
in the individual filesystem (probably calling a common helper in the DAX code).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
