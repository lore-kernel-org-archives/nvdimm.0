Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1DC611A1E3E
 for <linux-nvdimm@lists.01.org>; Tue, 18 Oct 2016 10:32:57 -0700 (PDT)
Date: Tue, 18 Oct 2016 11:32:55 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 12/20] mm: Factor out common parts of write fault handling
Message-ID: <20161018173255.GA26584@linux.intel.com>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-13-git-send-email-jack@suse.cz>
 <20161017220851.GA26960@linux.intel.com>
 <20161018105000.GQ3359@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161018105000.GQ3359@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 18, 2016 at 12:50:00PM +0200, Jan Kara wrote:
> On Mon 17-10-16 16:08:51, Ross Zwisler wrote:
> > On Tue, Sep 27, 2016 at 06:08:16PM +0200, Jan Kara wrote:
> > > Currently we duplicate handling of shared write faults in
> > > wp_page_reuse() and do_shared_fault(). Factor them out into a common
> > > function.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > >  mm/memory.c | 78 +++++++++++++++++++++++++++++--------------------------------
> > >  1 file changed, 37 insertions(+), 41 deletions(-)
> > > 
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 63d9c1a54caf..0643b3b5a12a 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -2063,6 +2063,41 @@ static int do_page_mkwrite(struct vm_area_struct *vma, struct page *page,
> > >  }
> > >  
> > >  /*
> > > + * Handle dirtying of a page in shared file mapping on a write fault.
> > > + *
> > > + * The function expects the page to be locked and unlocks it.
> > > + */
> > > +static void fault_dirty_shared_page(struct vm_area_struct *vma,
> > > +				    struct page *page)
> > > +{
> > > +	struct address_space *mapping;
> > > +	bool dirtied;
> > > +	bool page_mkwrite = vma->vm_ops->page_mkwrite;
> > 
> > I think you may need to pass in a 'page_mkwrite' parameter if you don't want
> > to change behavior.  Just checking to see of vma->vm_ops->page_mkwrite is
> > non-NULL works fine for this path:
> > 
> > do_shared_fault()
> > 	fault_dirty_shared_page()
> > 
> > and for
> > 
> > wp_page_shared()
> > 	wp_page_reuse()
> > 		fault_dirty_shared_page()
> > 
> > But for these paths:
> > 
> > wp_pfn_shared()
> > 	wp_page_reuse()
> > 		fault_dirty_shared_page()
> > 
> > and
> > 
> > do_wp_page()
> > 	wp_page_reuse()
> > 		fault_dirty_shared_page()
> > 
> > we unconditionally pass 0 for the 'page_mkwrite' parameter, even though from
> > the logic in wp_pfn_shared() especially you can see that
> > vma->vm_ops->pfn_mkwrite() must be defined some of the time.
> 
> The trick which makes this work is that for fault_dirty_shared_page() to be
> called at all, you have to set 'dirty_shared' argument to wp_page_reuse()
> and that does not happen from wp_pfn_shared() and do_wp_page() paths. So
> things work as they should. If you look somewhat later into the series,
> the patch "mm: Move part of wp_page_reuse() into the single call site"
> cleans this up to make things more obvious.
> 
> 								Honza

Ah, cool, that makes sense.

You can add:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
