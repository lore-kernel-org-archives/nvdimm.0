Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
 [150.101.137.131])
 by ml01.01.org (Postfix) with ESMTP id 4D1992219BCAC
 for <linux-nvdimm@lists.01.org>; Wed, 20 Dec 2017 14:10:17 -0800 (PST)
Date: Thu, 21 Dec 2017 09:14:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/15] dax: associate mappings with inodes, and warn if
 dma collides with truncate
Message-ID: <20171220221447.GG4094@dastard>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150949217152.24061.9869502311102659784.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171110090818.GE4895@lst.de>
 <CAPcyv4irj_+pJdX1SO6MjsxURcKm8--i_QvyudgHTZE2w4w-sA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4irj_+pJdX1SO6MjsxURcKm8--i_QvyudgHTZE2w4w-sA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 19, 2017 at 05:11:38PM -0800, Dan Williams wrote:
> On Fri, Nov 10, 2017 at 1:08 AM, Christoph Hellwig <hch@lst.de> wrote:
> >> +             struct {
> >> +                     /*
> >> +                      * ZONE_DEVICE pages are never on an lru or handled by
> >> +                      * a slab allocator, this points to the hosting device
> >> +                      * page map.
> >> +                      */
> >> +                     struct dev_pagemap *pgmap;
> >> +                     /*
> >> +                      * inode association for MEMORY_DEVICE_FS_DAX page-idle
> >> +                      * callbacks. Note that we don't use ->mapping since
> >> +                      * that has hard coded page-cache assumptions in
> >> +                      * several paths.
> >> +                      */
> >
> > What assumptions?  I'd much rather fix those up than having two fields
> > that have the same functionality.
> 
> [ Reviving this old thread where you asked why I introduce page->inode
> instead of reusing page->mapping ]
> 
> For example, xfs_vm_set_page_dirty() assumes that page->mapping being
> non-NULL indicates a typical page cache page, this is a false
> assumption for DAX.

That means every single filesystem has an incorrect assumption for
DAX pages. xfs_vm_set_page_dirty() is derived directly from
__set_page_dirty_buffers(), which is the default function that
set_page_dirty() calls to do it's work. Indeed, ext4 also calls
__set_page_dirty_buffers(), so whatever problem XFS has here with
DAX and racing truncates is going to manifest in ext4 as well.

> My guess at a fix for this is to add
> pagecache_page() checks to locations like this, but I worry about how
> to find them all. Where pagecache_page() is:
> 
> bool pagecache_page(struct page *page)
> {
>         if (!page->mapping)
>                 return false;
>         if (!IS_DAX(page->mapping->host))
>                 return false;
>         return true;
> }

This is likely to be a problem in lots more places if we have to
treat "has page been truncated away" race checks on dax mappings
differently to page cache mappings. This smells of a whack-a-mole
style bandaid to me....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
