Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C90541A227E
 for <linux-nvdimm@lists.01.org>; Tue, 19 Apr 2016 07:33:50 -0700 (PDT)
Date: Tue, 19 Apr 2016 16:33:43 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 17/18] dax: Use radix tree entry lock to protect cow faults
Message-ID: <20160419143343.GC22413@quack2.suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <1461015341-20153-18-git-send-email-jack@suse.cz>
 <20160419114609.GA13932@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160419114609.GA13932@gmail.com>
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
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 19-04-16 07:46:09, Jerome Glisse wrote:
> On Mon, Apr 18, 2016 at 11:35:40PM +0200, Jan Kara wrote:
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 93897f23cc11..f09cdb8d48fa 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -63,6 +63,7 @@
> >  #include <linux/dma-debug.h>
> >  #include <linux/debugfs.h>
> >  #include <linux/userfaultfd_k.h>
> > +#include <linux/dax.h>
> >  
> >  #include <asm/io.h>
> >  #include <asm/mmu_context.h>
> > @@ -2785,7 +2786,8 @@ oom:
> >   */
> >  static int __do_fault(struct vm_area_struct *vma, unsigned long address,
> >  			pgoff_t pgoff, unsigned int flags,
> > -			struct page *cow_page, struct page **page)
> > +			struct page *cow_page, struct page **page,
> > +			void **entry)
> >  {
> >  	struct vm_fault vmf;
> >  	int ret;
> > @@ -2800,8 +2802,10 @@ static int __do_fault(struct vm_area_struct *vma, unsigned long address,
> >  	ret = vma->vm_ops->fault(vma, &vmf);
> >  	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
> >  		return ret;
> > -	if (!vmf.page)
> > -		goto out;
> 
> Removing the above sounds seriously bogus to me as it means that below
> if (unlikely(PageHWPoison(vmf.page))) could dereference a NULL pointer.

If you do not return a valid page, you must return appropriate return code
from the ->fault handler. That being VM_FAULT_NOPAGE, VM_FAULT_DAX_LOCKED,
or some error. That has always been the case except for DAX abuse which was
added by commit 2e4cdab0584f "mm: allow page fault handlers to perform the
COW" about an year ago. And my patch fixes this abuse.

I'm not aware of any other code that would start abusing the return value
from the ->fault handler. If some such code indeed got merged during the
last year, it should be fixed as well.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
