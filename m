Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E2861A1E10
 for <linux-nvdimm@lists.01.org>; Tue, 18 Oct 2016 03:37:15 -0700 (PDT)
Date: Tue, 18 Oct 2016 12:37:12 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/20] mm: Remove unnecessary vma->vm_ops check
Message-ID: <20161018103712.GP3359@quack2.suse.cz>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-12-git-send-email-jack@suse.cz>
 <20161017194041.GB21002@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161017194041.GB21002@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 17-10-16 13:40:41, Ross Zwisler wrote:
> On Tue, Sep 27, 2016 at 06:08:15PM +0200, Jan Kara wrote:
> > We don't check whether vma->vm_ops is NULL in do_shared_fault() so
> > there's hardly any point in checking it in wp_page_shared() which gets
> > called only for shared file mappings as well.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  mm/memory.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index a4522e8999b2..63d9c1a54caf 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2301,7 +2301,7 @@ static int wp_page_shared(struct vm_fault *vmf, struct page *old_page)
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
> 
> Does this apply equally to the check in wp_pfn_shared()?  Both
> wp_page_shared() and wp_pfn_shared() are called for shared file mappings via
> do_wp_page().

Yes, it does apply there as well. Added to the commit. There are actually
more places with these checks which don't seem necessary but I didn't want
to do more cleanups than I need... But at least these two come logically
together.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
