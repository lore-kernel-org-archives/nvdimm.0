Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x242.google.com (mail-wm0-x242.google.com
 [IPv6:2a00:1450:400c:c09::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8530D21A0480E
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 23:44:34 -0700 (PDT)
Received: by mail-wm0-x242.google.com with SMTP id o81so12721912wmb.0
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 23:44:34 -0700 (PDT)
Date: Tue, 18 Apr 2017 08:44:27 +0200
From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 05/22] drm/i915: Make use of the new sg_map helper function
Message-ID: <20170418064427.r5ewu3p66p2zwdru@phenom.ffwll.local>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-6-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1492121135-4437-6-git-send-email-logang@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Steve Wise <swise@opengridcomputing.com>, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, devel@driverdev.osuosl.org, rds-devel@oss.oracle.com, linux-scsi@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, Ming Lin <ming.l@ssi.samsung.com>, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, dri-devel@lists.freedesktop.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, linaro-mm-sig@lists.linaro.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-nvdimm@lists.01.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 13, 2017 at 04:05:18PM -0600, Logan Gunthorpe wrote:
> This is a single straightforward conversion from kmap to sg_map.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Probably makes sense to merge through some other tree, but please be aware
of the considerable churn rate in i915 (i.e. make sure your tree is in
linux-next before you send a pull request for this). Plane B would be to
get the prep patch in first and then merge the i915 conversion one kernel
release later.
-Daniel

> ---
>  drivers/gpu/drm/i915/i915_gem.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 67b1fc5..1b1b91a 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -2188,6 +2188,15 @@ static void __i915_gem_object_reset_page_iter(struct drm_i915_gem_object *obj)
>  		radix_tree_delete(&obj->mm.get_page.radix, iter.index);
>  }
>  
> +static void i915_gem_object_unmap(const struct drm_i915_gem_object *obj,
> +				  void *ptr)
> +{
> +	if (is_vmalloc_addr(ptr))
> +		vunmap(ptr);
> +	else
> +		sg_unmap(obj->mm.pages->sgl, ptr, SG_KMAP);
> +}
> +
>  void __i915_gem_object_put_pages(struct drm_i915_gem_object *obj,
>  				 enum i915_mm_subclass subclass)
>  {
> @@ -2215,10 +2224,7 @@ void __i915_gem_object_put_pages(struct drm_i915_gem_object *obj,
>  		void *ptr;
>  
>  		ptr = ptr_mask_bits(obj->mm.mapping);
> -		if (is_vmalloc_addr(ptr))
> -			vunmap(ptr);
> -		else
> -			kunmap(kmap_to_page(ptr));
> +		i915_gem_object_unmap(obj, ptr);
>  
>  		obj->mm.mapping = NULL;
>  	}
> @@ -2475,8 +2481,11 @@ static void *i915_gem_object_map(const struct drm_i915_gem_object *obj,
>  	void *addr;
>  
>  	/* A single page can always be kmapped */
> -	if (n_pages == 1 && type == I915_MAP_WB)
> -		return kmap(sg_page(sgt->sgl));
> +	if (n_pages == 1 && type == I915_MAP_WB) {
> +		addr = sg_map(sgt->sgl, SG_KMAP);
> +		if (IS_ERR(addr))
> +			return NULL;
> +	}
>  
>  	if (n_pages > ARRAY_SIZE(stack_pages)) {
>  		/* Too big for stack -- allocate temporary array instead */
> @@ -2543,11 +2552,7 @@ void *i915_gem_object_pin_map(struct drm_i915_gem_object *obj,
>  			goto err_unpin;
>  		}
>  
> -		if (is_vmalloc_addr(ptr))
> -			vunmap(ptr);
> -		else
> -			kunmap(kmap_to_page(ptr));
> -
> +		i915_gem_object_unmap(obj, ptr);
>  		ptr = obj->mm.mapping = NULL;
>  	}
>  
> -- 
> 2.1.4
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
