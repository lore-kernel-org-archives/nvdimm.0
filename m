Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 12 Sep 2016 13:02:01 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 2/2] shmem: call __thp_get_unmapped_area to alloc a
 pmd-aligned addr
Message-ID: <20160912100201.GB23346@node.shutemov.name>
References: <1473459863-11287-1-git-send-email-toshi.kani@hpe.com>
 <1473459863-11287-3-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473459863-11287-3-git-send-email-toshi.kani@hpe.com>
Sender: owner-linux-mm@kvack.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, mawilcox@microsoft.com, hughd@google.com, kirill.shutemov@linux.intel.com, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 09, 2016 at 04:24:23PM -0600, Toshi Kani wrote:
> shmem_get_unmapped_area() provides a functionality similar
> to __thp_get_unmapped_area() as both allocate a pmd-aligned
> address.
> 
> Change shmem_get_unmapped_area() to do shm-specific checks
> and then call __thp_get_unmapped_area() for allocating
> a pmd-aligned address.
> 
> link: https://lkml.org/lkml/2016/8/29/620
> Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Dan Williams <dan.j.williams@intel.com>

Looks good to me. Thanks.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
