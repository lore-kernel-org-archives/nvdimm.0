Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E93E121A16ECF
 for <linux-nvdimm@lists.01.org>; Tue, 13 Jun 2017 14:32:49 -0700 (PDT)
Date: Tue, 13 Jun 2017 15:34:01 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/2] mm: improve readability of
 transparent_hugepage_enabled()
Message-ID: <20170613213401.GA17972@linux.intel.com>
References: <149713136649.17377.3742583729924020371.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149713137177.17377.6712234218256825718.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170613210630.GA5135@linux.intel.com>
 <CAPcyv4jjx3QpAMgpRx0h+8bUkcKC0DhW-3Bds0T8K1Z8kgw=xA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jjx3QpAMgpRx0h+8bUkcKC0DhW-3Bds0T8K1Z8kgw=xA@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@lst.de>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 13, 2017 at 02:16:49PM -0700, Dan Williams wrote:
> On Tue, Jun 13, 2017 at 2:06 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > So, if the VM_NOHUGEPAGE flag is set or if the vma is for a temporary stack,
> > we always bail.  Also, we only care about the VM_HUGEPAGE flag in the presence
> > of TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG.
> >
> > I think this static inline is logically equivalent (untested):
> >
> > static inline bool transparent_hugepage_enabled(struct vm_area_struct *vma)
> > {
> >         if ((vma->vm_flags & VM_NOHUGEPAGE) || is_vma_temporary_stack(vma))
> >                 return false;
> >
> >         if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
> >                 return true;
> >
> >         if ((transparent_hugepage_flags &
> >                                 (1 << TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
> >                         && vma->vm_flags & VM_HUGEPAGE)
> >                 return true;
> 
> We can clean this up a bit and do:
> 
>    return !!(vma->vm_flags & VM_HUGEPAGE)
> 
> ...to drop the &&

Sure, that'll read better.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
