Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151215021510.37090.35956.stgit@dwillia2-desk3.jf.intel.com>
References: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
	<20151215021510.37090.35956.stgit@dwillia2-desk3.jf.intel.com>
Date: Mon, 14 Dec 2015 23:11:51 -0800
Message-ID: <CAPcyv4gcPn-4WbsudPzuzxKWXLtsyVX2rtLu0PUyYDXFBtS4xg@mail.gmail.com>
Subject: Re: [PATCH 8/9] tools/testing/libnvdimm: cleanup mock resource lookup
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 14, 2015 at 6:15 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Push the locking around get_nfit_res() into get_nfit_res().
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  tools/testing/nvdimm/test/iomap.c |   86 +++++++++++++++++--------------------
>  1 file changed, 39 insertions(+), 47 deletions(-)
>
> diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
> index 802d3a173ccf..d9c6c5af67e8 100644
> --- a/tools/testing/nvdimm/test/iomap.c
> +++ b/tools/testing/nvdimm/test/iomap.c
[..]
> @@ -83,55 +89,55 @@ EXPORT_SYMBOL(__wrap_devm_ioremap_nocache);
>  void *__wrap_devm_memremap(struct device *dev, resource_size_t offset,
>                 size_t size, unsigned long flags)
>  {
> -       struct nfit_test_resource *nfit_res;
> +       struct nfit_test_resource *nfit_res = get_nfit_res(offset);
>
> -       rcu_read_lock();
> -       nfit_res = get_nfit_res(offset);
> -       rcu_read_unlock();
>         if (nfit_res)
>                 return nfit_res->buf + offset - nfit_res->res->start;
>         return devm_memremap(dev, offset, size, flags);
>  }
>  EXPORT_SYMBOL(__wrap_devm_memremap);
>
> -void *__wrap_devm_memremap_pages(struct device *dev, struct resource *res)
> +#ifdef PFN_MAP
> +void *__wrap_devm_memremap_pages(struct device *dev, struct resource *res,
> +               struct percpu_ref *ref, struct vmem_altmap *altmap)
>  {
> -       struct nfit_test_resource *nfit_res;
>         resource_size_t offset = res->start;
> +       struct nfit_test_resource *nfit_res = get_nfit_res(offset);
>
> -       rcu_read_lock();
> -       nfit_res = get_nfit_res(offset);
> -       rcu_read_unlock();
>         if (nfit_res)
>                 return nfit_res->buf + offset - nfit_res->res->start;
> -       return devm_memremap_pages(dev, res);
> +       return devm_memremap_pages(dev, res, ref, altmap);
>  }
>  EXPORT_SYMBOL(__wrap_devm_memremap_pages);
>
> -#ifdef PFN_MAP
>  pfn_t __wrap_phys_to_pfn_t(dma_addr_t addr, unsigned long flags)
>  {
> -       struct nfit_test_resource *nfit_res;
> -
> -       rcu_read_lock();
> -       nfit_res = get_nfit_res(offset);
> -       rcu_read_unlock();
> +       struct nfit_test_resource *nfit_res = get_nfit_res(addr);
>
>         if (nfit_res)
>                 flags &= ~PFN_MAP;
> -        return phys_to_pfn_t(addr >> PAGE_SHIFT, flags);
> +        return phys_to_pfn_t(addr, flags);
>  }
>  EXPORT_SYMBOL(__wrap_phys_to_pfn_t);
> +#else
> +/* to be removed post 4.5-rc1 */
> +void *__wrap_devm_memremap_pages(struct device *dev, struct resource *res)
> +{
> +       resource_size_t offset = res->start;
> +       struct nfit_test_resource *nfit_res = get_nfit_res(offset);
> +
> +       if (nfit_res)
> +               return nfit_res->buf + offset - nfit_res->res->start;
> +       return devm_memremap_pages(dev, res);
> +}
> +EXPORT_SYMBOL(__wrap_devm_memremap_pages);
>  #endif

Whoops, the above hunk was meant to be folded into [PATCH 6/9]
libnvdimm, pfn: enable pfn sysfs interface unit testing
