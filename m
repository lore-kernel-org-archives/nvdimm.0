Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 16 Nov 2016 14:29:18 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/21] mm: Remove unnecessary vma->vm_ops check
Message-ID: <20161116132918.GK21785@quack2.suse.cz>
References: <1478233517-3571-1-git-send-email-jack@suse.cz>
 <1478233517-3571-12-git-send-email-jack@suse.cz>
 <20161115222819.GK23021@node>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161115222819.GK23021@node>
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 16-11-16 01:28:19, Kirill A. Shutemov wrote:
> On Fri, Nov 04, 2016 at 05:25:07AM +0100, Jan Kara wrote:
> > We don't check whether vma->vm_ops is NULL in do_shared_fault() so
> > there's hardly any point in checking it in wp_page_shared() or
> > wp_pfn_shared() which get called only for shared file mappings as well.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Well, I'm not sure about this.
> 
> do_shared_fault() doesn't have the check since we checked it upper by
> stack: see vma_is_anonymous() in handle_pte_fault().
> 
> In principal, it should be fine. But random crappy driver has potential to
> blow it up.

Ok, so do you prefer me to keep this patch or discard it? Either is fine with
me. It was just a cleanup I wrote when factoring out the functionality.

								Honza
> 
> > ---
> >  mm/memory.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 7be96a43d5ac..26b2858e6a12 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2275,7 +2275,7 @@ static int wp_pfn_shared(struct vm_fault *vmf)
> >  {
> >  	struct vm_area_struct *vma = vmf->vma;
> >  
> > -	if (vma->vm_ops && vma->vm_ops->pfn_mkwrite) {
> > +	if (vma->vm_ops->pfn_mkwrite) {
> >  		int ret;
> >  
> >  		pte_unmap_unlock(vmf->pte, vmf->ptl);
> > @@ -2305,7 +2305,7 @@ static int wp_page_shared(struct vm_fault *vmf, struct page *old_page)
> >  
> >  	get_page(old_page);
> >  
> > -	if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
> > +	if (vma->vm_ops->page_mkwrite) {
> >  		int tmp;
> >  
> >  		pte_unmap_unlock(vmf->pte, vmf->ptl);
> > -- 
> > 2.6.6
> > 
> > --
> > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > the body to majordomo@kvack.org.  For more info on Linux MM,
> > see: http://www.linux-mm.org/ .
> > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> -- 
>  Kirill A. Shutemov
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
