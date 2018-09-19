Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B282E2114300B
 for <linux-nvdimm@lists.01.org>; Tue, 18 Sep 2018 19:53:45 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id p84-v6so3742087oic.4
 for <linux-nvdimm@lists.01.org>; Tue, 18 Sep 2018 19:53:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1536342881.git.yi.z.zhang@linux.intel.com>
 <4e8c2e0facd46cfaf4ab79e19c9115958ab6f218.1536342881.git.yi.z.zhang@linux.intel.com>
In-Reply-To: <4e8c2e0facd46cfaf4ab79e19c9115958ab6f218.1536342881.git.yi.z.zhang@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 18 Sep 2018 19:53:32 -0700
Message-ID: <CAPcyv4ifg2BZMTNfu6mg0xxtPWs3BVgkfEj51v1CQ6jp2S70fw@mail.gmail.com>
Subject: Re: [PATCH V5 4/4] kvm: add a check if pfn is from NVDIMM pmem.
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
To: Zhang Yi <yi.z.zhang@linux.intel.com>
Cc: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, KVM list <kvm@vger.kernel.org>, "Zhang, Yu C" <yu.c.zhang@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, rkrcmar@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>Zhang,
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 7, 2018 at 2:25 AM Zhang Yi <yi.z.zhang@linux.intel.com> wrote:
>
> For device specific memory space, when we move these area of pfn to
> memory zone, we will set the page reserved flag at that time, some of
> these reserved for device mmio, and some of these are not, such as
> NVDIMM pmem.
>
> Now, we map these dev_dax or fs_dax pages to kvm for DIMM/NVDIMM
> backend, since these pages are reserved, the check of
> kvm_is_reserved_pfn() misconceives those pages as MMIO. Therefor, we
> introduce 2 page map types, MEMORY_DEVICE_FS_DAX/MEMORY_DEVICE_DEV_DAX,
> to identify these pages are from NVDIMM pmem and let kvm treat these
> as normal pages.
>
> Without this patch, many operations will be missed due to this
> mistreatment to pmem pages, for example, a page may not have chance to
> be unpinned for KVM guest(in kvm_release_pfn_clean), not able to be
> marked as dirty/accessed(in kvm_set_pfn_dirty/accessed) etc.
>
> Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> Acked-by: Pankaj Gupta <pagupta@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c44c406..9c49634 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -147,8 +147,20 @@ __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>
>  bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
>  {
> -       if (pfn_valid(pfn))
> -               return PageReserved(pfn_to_page(pfn));
> +       struct page *page;
> +
> +       if (pfn_valid(pfn)) {
> +               page = pfn_to_page(pfn);
> +
> +               /*
> +                * For device specific memory space, there is a case
> +                * which we need pass MEMORY_DEVICE_FS[DEV]_DAX pages
> +                * to kvm, these pages marked reserved flag as it is a
> +                * zone device memory, we need to identify these pages
> +                * and let kvm treat these as normal pages
> +                */
> +               return PageReserved(page) && !is_dax_page(page);

Should we consider just not setting PageReserved for
devm_memremap_pages()? Perhaps kvm is not be the only component making
these assumptions about this flag?

Why is MEMORY_DEVICE_PUBLIC memory specifically excluded?

This has less to do with "dax" pages and more to do with
devm_memremap_pages() established ranges. P2PDMA is another producer
of these pages. If either MEMORY_DEVICE_PUBLIC or P2PDMA pages can be
used in these kvm paths then I think this points to consider clearing
the Reserved flag.

That said I haven't audited all the locations that test PageReserved().

Sorry for not responding sooner I was on extended leave.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
