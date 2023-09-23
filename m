Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E730D261;
	Sat, 23 Sep 2023 09:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47033C433C7;
	Sat, 23 Sep 2023 09:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695459663;
	bh=Ph0YP5DcW/CkJHTyGd1Be/WwWTvyOrrGqJl4wtXJD3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iB8e5nSvvBiJq8VhkGefgcb25VbcHO1iGHcMp2qDARNG/vnMcRpkf1kYddrCrpYWB
	 qNWC/pMJRFLTGSIES0iYLTBnONTJgImkeer8e8zBL8rz981TPYJ608vCSVR9p6EFwr
	 KvLVsC/rejjgcfLT69qHEJLYCErQO1sOMqzstnWTcHbePkfBLELetOPTV0ldRSqAgH
	 6EnqEO+sa0WtMBF9NR846+7w2qFgYzdWUSBeknPMrUF5XuLYdxpqcuAMdl9M0ynMYr
	 DlBg5Rv/T32L6j78jMBzWZijWjJh7V/6+3K6Y/Q39IKEzsB9g+Lgy7vn4F1PtW/GtS
	 bflAvqWfqyyQg==
Date: Sat, 23 Sep 2023 11:02:05 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] libnvdimm: Annotate struct nd_region with __counted_by
Message-ID: <ZQ8aDS3PUvidk9VV@work>
References: <20230922175238.work.116-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922175238.work.116-kees@kernel.org>

On Fri, Sep 22, 2023 at 10:52:39AM -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct nd_region.
> Additionally, since the element count member must be set before accessing
> the annotated flexible array member, move its initialization earlier.
> 
> [1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: nvdimm@lists.linux.dev
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>  drivers/nvdimm/nd.h          | 2 +-
>  drivers/nvdimm/region_devs.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index e8b9d27dbb3c..ae2078eb6a62 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -422,7 +422,7 @@ struct nd_region {
>  	struct nd_interleave_set *nd_set;
>  	struct nd_percpu_lane __percpu *lane;
>  	int (*flush)(struct nd_region *nd_region, struct bio *bio);
> -	struct nd_mapping mapping[];
> +	struct nd_mapping mapping[] __counted_by(ndr_mappings);
>  };
>  
>  static inline bool nsl_validate_nlabel(struct nd_region *nd_region,
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index 0a81f87f6f6c..5be65fce85cf 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -1028,6 +1028,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
>  
>  	if (!nd_region)
>  		return NULL;
> +	nd_region->ndr_mappings = ndr_desc->num_mappings;
>  	/* CXL pre-assigns memregion ids before creating nvdimm regions */
>  	if (test_bit(ND_REGION_CXL, &ndr_desc->flags)) {
>  		nd_region->id = ndr_desc->memregion;
> @@ -1062,7 +1063,6 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
>  
>  		get_device(&nvdimm->dev);
>  	}
> -	nd_region->ndr_mappings = ndr_desc->num_mappings;
>  	nd_region->provider_data = ndr_desc->provider_data;
>  	nd_region->nd_set = ndr_desc->nd_set;
>  	nd_region->num_lanes = ndr_desc->num_lanes;
> -- 
> 2.34.1
> 
> 
