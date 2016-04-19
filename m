Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pa0-x22d.google.com (mail-pa0-x22d.google.com
 [IPv6:2607:f8b0:400e:c03::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 713121A1F43
 for <linux-nvdimm@lists.01.org>; Tue, 19 Apr 2016 08:19:19 -0700 (PDT)
Received: by mail-pa0-x22d.google.com with SMTP id r5so6930058pag.1
 for <linux-nvdimm@lists.01.org>; Tue, 19 Apr 2016 08:19:19 -0700 (PDT)
Date: Tue, 19 Apr 2016 11:19:04 -0400
From: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: [PATCH 17/18] dax: Use radix tree entry lock to protect cow faults
Message-ID: <20160419151904.GA17318@gmail.com>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <1461015341-20153-18-git-send-email-jack@suse.cz>
 <20160419114609.GA13932@gmail.com>
 <20160419143343.GC22413@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160419143343.GC22413@quack2.suse.cz>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 19, 2016 at 04:33:43PM +0200, Jan Kara wrote:
> On Tue 19-04-16 07:46:09, Jerome Glisse wrote:
> > On Mon, Apr 18, 2016 at 11:35:40PM +0200, Jan Kara wrote:
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 93897f23cc11..f09cdb8d48fa 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -63,6 +63,7 @@
> > >  #include <linux/dma-debug.h>
> > >  #include <linux/debugfs.h>
> > >  #include <linux/userfaultfd_k.h>
> > > +#include <linux/dax.h>
> > >  =

> > >  #include <asm/io.h>
> > >  #include <asm/mmu_context.h>
> > > @@ -2785,7 +2786,8 @@ oom:
> > >   */
> > >  static int __do_fault(struct vm_area_struct *vma, unsigned long addr=
ess,
> > >  			pgoff_t pgoff, unsigned int flags,
> > > -			struct page *cow_page, struct page **page)
> > > +			struct page *cow_page, struct page **page,
> > > +			void **entry)
> > >  {
> > >  	struct vm_fault vmf;
> > >  	int ret;
> > > @@ -2800,8 +2802,10 @@ static int __do_fault(struct vm_area_struct *v=
ma, unsigned long address,
> > >  	ret =3D vma->vm_ops->fault(vma, &vmf);
> > >  	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RET=
RY)))
> > >  		return ret;
> > > -	if (!vmf.page)
> > > -		goto out;
> > =

> > Removing the above sounds seriously bogus to me as it means that below
> > if (unlikely(PageHWPoison(vmf.page))) could dereference a NULL pointer.
> =

> If you do not return a valid page, you must return appropriate return code
> from the ->fault handler. That being VM_FAULT_NOPAGE, VM_FAULT_DAX_LOCKED,
> or some error. That has always been the case except for DAX abuse which w=
as
> added by commit 2e4cdab0584f "mm: allow page fault handlers to perform the
> COW" about an year ago. And my patch fixes this abuse.
> =

> I'm not aware of any other code that would start abusing the return value
> from the ->fault handler. If some such code indeed got merged during the
> last year, it should be fixed as well.
> =


Ok my bad i missed that.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
