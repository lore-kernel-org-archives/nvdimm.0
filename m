Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <1435006555.11808.210.camel@misato.fc.hp.com>
Subject: Re: [PATCH] mm: Fix MAP_POPULATE and mlock() for DAX
From: Toshi Kani <toshi.kani@hp.com>
Date: Mon, 22 Jun 2015 14:55:55 -0600
In-Reply-To: <20150620194612.GA5268@node.dhcp.inet.fi>
References: <1434493710-11138-1-git-send-email-toshi.kani@hp.com>
	 <20150620194612.GA5268@node.dhcp.inet.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, willy@linux.intel.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, 2015-06-20 at 22:46 +0300, Kirill A. Shutemov wrote:
> On Tue, Jun 16, 2015 at 04:28:30PM -0600, Toshi Kani wrote:
> > DAX has the following issues in a shared or read-only private
> > mmap'd file.
> >  - mmap(MAP_POPULATE) does not pre-fault
> >  - mlock() fails with -ENOMEM
> > 
> > DAX uses VM_MIXEDMAP for mmap'd files, which do not have struct
> > page associated with the ranges.  Both MAP_POPULATE and mlock()
> > call __mm_populate(), which in turn calls __get_user_pages().
> > Because __get_user_pages() requires a valid page returned from
> > follow_page_mask(), MAP_POPULATE and mlock(), i.e. FOLL_POPULATE,
> > fail in the first page.
> > 
> > Change __get_user_pages() to proceed FOLL_POPULATE when the
> > translation is set but its page does not exist (-EFAULT), and
> > @pages is not requested.  With that, MAP_POPULATE and mlock()
> > set translations to the requested range and complete successfully.
> > 
> > MAP_POPULATE still provides a major performance improvement to
> > DAX as it will avoid page faults during initial access to the
> > pages.
> > 
> > mlock() continues to set VM_LOCKED to vma and populate the range.
> > Since there is no struct page, the range is pinned without marking
> > pages mlocked.
> > 
> > Note, MAP_POPULATE and mlock() already work for a write-able
> > private mmap'd file on DAX since populate_vma_page_range() breaks
> > COW, which allocates page caches.
> 
> I don't think that's true in all cases.
> 
> We would fail to break COW for mlock() if the mapping is populated with
> read-only entries by the mlock() time. In this case follow_page_mask()
> would fail with -EFAULT and faultin_page() will never executed.

No, mlock() always breaks COW as populate_vma_page_range() sets
FOLL_WRITE in case of write-able private mmap.

  /*
   * We want to touch writable mappings with a write fault in order
   * to break COW, except for shared mappings because these don't COW
   * and we would not want to dirty them for nothing.
   */
  if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
           gup_flags |= FOLL_WRITE;

Thanks,
-Toshi


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
