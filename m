Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 73C7D21107182
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 03:44:17 -0700 (PDT)
Date: Fri, 31 Aug 2018 03:23:13 +0800
From: Yi Zhang <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH V4 4/4] kvm: add a check if pfn is from NVDIMM pmem.
Message-ID: <20180830192312.GA84758@tiger-server>
References: <cover.1534934405.git.yi.z.zhang@linux.intel.com>
 <a4183c0f0adfb6d123599dd306062fd193e83f5a.1534934405.git.yi.z.zhang@linux.intel.com>
 <380594559.7598107.1535537748154.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <380594559.7598107.1535537748154.JavaMail.zimbra@redhat.com>
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
To: Pankaj Gupta <pagupta@redhat.com>
Cc: jglisse@redhat.com, yu c zhang <yu.c.zhang@intel.com>, kvm@vger.kernel.org, linux-nvdimm@lists.01.org, jack@suse.cz, david@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, rkrcmar@redhat.com, pbonzini@redhat.com, hch@lst.de, yi z zhang <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 2018-08-29 at 06:15:48 -0400, Pankaj Gupta wrote:
> 
> > 
> > For device specific memory space, when we move these area of pfn to
> > memory zone, we will set the page reserved flag at that time, some of
> > these reserved for device mmio, and some of these are not, such as
> > NVDIMM pmem.
> > 
> > Now, we map these dev_dax or fs_dax pages to kvm for DIMM/NVDIMM
> > backend, since these pages are reserved, the check of
> > kvm_is_reserved_pfn() misconceives those pages as MMIO. Therefor, we
> > introduce 2 page map types, MEMORY_DEVICE_FS_DAX/MEMORY_DEVICE_DEV_DAX,
> > to identify these pages are from NVDIMM pmem and let kvm treat these
> > as normal pages.
> > 
> > Without this patch, many operations will be missed due to this
> > mistreatment to pmem pages, for example, a page may not have chance to
> > be unpinned for KVM guest(in kvm_release_pfn_clean), not able to be
> > marked as dirty/accessed(in kvm_set_pfn_dirty/accessed) etc.
> > 
> > Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> > ---
> >  virt/kvm/kvm_main.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index c44c406..969b6ca 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -147,8 +147,12 @@ __weak void
> > kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> >  
> >  bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
> >  {
> > -	if (pfn_valid(pfn))
> > -		return PageReserved(pfn_to_page(pfn));
> > +	struct page *page;
> > +
> > +	if (pfn_valid(pfn)) {
> > +		page = pfn_to_page(pfn);
> > +		return PageReserved(page) && !is_dax_page(page);
> > +	}
> >  
> >  	return true;
> >  }
> 
> Acked-by: Pankaj Gupta <pagupta@redhat.com>

Thanks for your kindly review, Pankaj, as all the patch [1,2,3,4]/4 got
the reviewed[acked]-by, can we Queue this by now?

> 
> > --
> > 2.7.4
> > 
> > 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
