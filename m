Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE7C2F5B
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 22:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763591073; cv=none; b=L1mVjOz0Vw8eUDw0DBVs0vmlwDI9DAsZszsnmeIqCRgYp0/IDGIgJQuv9iAeistXB0Uox2MLLsIZ42CU/OHojVxl8abKkWjqLc2+Ux8BB29u1TTDkFYqTiRwBEa5Za2svAMxIzXgOCFwhzXe6d12K6iWItm1t7G+yYygp/mvyHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763591073; c=relaxed/simple;
	bh=O7VLxpaiyBZT0QDbO2gyUlXF2NSO8KqMV93LJDv/qOI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GXjsNFDj6T6341M4LX95rDVblmwPYB9LluurheQT5MsUZ5rwGfRDq9rZpKn84zwQiR34eVx3r5oEEp1XmqmP2MlTOLgYCIrwB4ZlnbZvFvEbZwO2dVnEwxv/aeDz2eNGzMjONv7lJGnUPpKFJIkZwNWxIhoq/tFLgyPNz2WpaIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nMSlugML; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nMSlugML"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763591071; x=1795127071;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O7VLxpaiyBZT0QDbO2gyUlXF2NSO8KqMV93LJDv/qOI=;
  b=nMSlugMLtkkb6lq11+6hI9v68AOek1XEcaQhBDxzawNKd5znFZwTaqaT
   WBJGBG16Wn0cHcrJJLis4jlaJ3RFbeLnHhQLltBmWxPXircFb1o7qrCWL
   BsC3IFqJJESNuVyIHTrNCIN1YQ5RowOvjKQ4kd9OeeV1E2OcvWv/eExiY
   tAMnZpNQqtGISEmeiX/VINnFuKuRu6pqKG6C5uUlXCa33XRtUt8nlMOfr
   LBY1+jccBDrxHpKf8VmjvFd9pP41ZafcRztnYC1hkDrBbAJ45BHSZgJwJ
   kNhK5dO3vFY0dpjkExOquZ7C5yaRYns25iyxxILqDX5OmfvikSarc8LRg
   Q==;
X-CSE-ConnectionGUID: p9RK+aiITp+z5O/D6KPDlQ==
X-CSE-MsgGUID: X4TQGeDSQ2GE7voIfC6u3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="69266058"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="69266058"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 14:24:30 -0800
X-CSE-ConnectionGUID: WBHotaZ3R/W+klziL6NZlA==
X-CSE-MsgGUID: tpixlAaPRtW6+MfSR63oPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="196139649"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 14:24:29 -0800
Message-ID: <baa9b670-fbfe-4050-bceb-cccc42efad88@intel.com>
Date: Wed, 19 Nov 2025 15:24:28 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 14/17] cxl/pmem_region: Introduce
 CONFIG_CXL_PMEM_REGION for core/pmem_region.c
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
 <CGME20251119075335epcas5p3a8fdc68301233f899d9041a300309fa2@epcas5p3.samsung.com>
 <20251119075255.2637388-15-s.neeraj@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251119075255.2637388-15-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 12:52 AM, Neeraj Kumar wrote:
> As pmem region label update/delete has hard dependency on libnvdimm.
> It is therefore put core/pmem_region.c under CONFIG_CXL_PMEM_REGION
> control. It handles the dependency by selecting CONFIG_LIBNVDIMM
> if not enabled.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/cxl/Kconfig       | 15 +++++++++++++++
>  drivers/cxl/core/Makefile |  3 ++-
>  drivers/cxl/core/core.h   | 17 +++++++++++------
>  drivers/cxl/core/region.c |  2 ++
>  drivers/cxl/cxl.h         | 24 ++++++++++++++----------
>  tools/testing/cxl/Kbuild  |  3 ++-
>  6 files changed, 46 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
> index f1361ed6a0d4..307fed8f1f56 100644
> --- a/drivers/cxl/Kconfig
> +++ b/drivers/cxl/Kconfig
> @@ -211,6 +211,21 @@ config CXL_REGION
>  
>  	  If unsure say 'y'
>  
> +config CXL_PMEM_REGION
> +	bool "CXL: Pmem Region Support"
> +	default CXL_BUS
> +	depends on CXL_REGION
> +	depends on ARCH_HAS_PMEM_API
> +	depends on PHYS_ADDR_T_64BIT
> +	depends on BLK_DEV
> +	select LIBNVDIMM
> +	help
> +	   Enable the CXL core to enumerate and provision CXL pmem regions.
> +	   A CXL pmem region need to update region label into LSA. For LSA
> +	   update/delete libnvdimm is required.
> +
> +	   If unsure say 'y'
> +
>  config CXL_REGION_INVALIDATION_TEST
>  	bool "CXL: Region Cache Management Bypass (TEST)"
>  	depends on CXL_REGION
> diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
> index fe0fcab6d730..399157beb917 100644
> --- a/drivers/cxl/core/Makefile
> +++ b/drivers/cxl/core/Makefile
> @@ -16,7 +16,8 @@ cxl_core-y += pmu.o
>  cxl_core-y += cdat.o
>  cxl_core-y += ras.o
>  cxl_core-$(CONFIG_TRACING) += trace.o
> -cxl_core-$(CONFIG_CXL_REGION) += region.o pmem_region.o
> +cxl_core-$(CONFIG_CXL_REGION) += region.o
> +cxl_core-$(CONFIG_CXL_PMEM_REGION) += pmem_region.o
>  cxl_core-$(CONFIG_CXL_MCE) += mce.o
>  cxl_core-$(CONFIG_CXL_FEATURES) += features.o
>  cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += edac.o
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 5ebbc3d3dde5..beeb9b7527b8 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -34,7 +34,6 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
>  #define CXL_REGION_ATTR(x) (&dev_attr_##x.attr)
>  #define CXL_REGION_TYPE(x) (&cxl_region_type)
>  #define SET_CXL_REGION_ATTR(x) (&dev_attr_##x.attr),
> -#define CXL_PMEM_REGION_TYPE(x) (&cxl_pmem_region_type)
>  #define CXL_DAX_REGION_TYPE(x) (&cxl_dax_region_type)
>  int cxl_region_init(void);
>  void cxl_region_exit(void);
> @@ -89,17 +88,23 @@ static inline struct cxl_region *to_cxl_region(struct device *dev)
>  {
>  	return NULL;
>  }
> -static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
> -{
> -	return 0;
> -}
>  #define CXL_REGION_ATTR(x) NULL
>  #define CXL_REGION_TYPE(x) NULL
>  #define SET_CXL_REGION_ATTR(x)
> -#define CXL_PMEM_REGION_TYPE(x) NULL
>  #define CXL_DAX_REGION_TYPE(x) NULL
>  #endif
>  
> +#ifdef CONFIG_CXL_PMEM_REGION
> +#define CXL_PMEM_REGION_TYPE(x) (&cxl_pmem_region_type)
> +int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
> +#else
> +#define CXL_PMEM_REGION_TYPE(x) NULL
> +static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
> +{
> +	return 0;
> +}
> +#endif
> +
>  struct cxl_send_command;
>  struct cxl_mem_query_commands;
>  int cxl_query_cmd(struct cxl_mailbox *cxl_mbox,
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 9798120b208e..408e139718f1 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -3918,6 +3918,8 @@ static int cxl_region_probe(struct device *dev)
>  			dev_dbg(&cxlr->dev, "CXL EDAC registration for region_id=%d failed\n",
>  				cxlr->id);
>  
> +		if (!IS_ENABLED(CONFIG_CXL_PMEM_REGION))
> +			return -EINVAL;
>  		return devm_cxl_add_pmem_region(cxlr);
>  	case CXL_PARTMODE_RAM:
>  		rc = devm_cxl_region_edac_register(cxlr);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 684a0d1b441a..6ac3b40cb5ff 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -899,21 +899,11 @@ int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
>  struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port);
>  
>  #ifdef CONFIG_CXL_REGION
> -bool is_cxl_pmem_region(struct device *dev);
> -struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
>  int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
>  struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
>  u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
>  int cxl_region_discovery(struct cxl_memdev *cxlmd);
>  #else
> -static inline bool is_cxl_pmem_region(struct device *dev)
> -{
> -	return false;
> -}
> -static inline struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
> -{
> -	return NULL;
> -}
>  static inline int cxl_add_to_region(struct cxl_endpoint_decoder *cxled)
>  {
>  	return 0;
> @@ -933,6 +923,20 @@ static inline int cxl_region_discovery(struct cxl_memdev *cxlmd)
>  }
>  #endif
>  
> +#ifdef CONFIG_CXL_PMEM_REGION
> +bool is_cxl_pmem_region(struct device *dev);
> +struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
> +#else
> +static inline bool is_cxl_pmem_region(struct device *dev)
> +{
> +	return false;
> +}
> +static inline struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
> +{
> +	return NULL;
> +}
> +#endif
> +
>  void cxl_endpoint_parse_cdat(struct cxl_port *port);
>  void cxl_switch_parse_cdat(struct cxl_dport *dport);
>  
> diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
> index ad2496b38fdd..024922326a6b 100644
> --- a/tools/testing/cxl/Kbuild
> +++ b/tools/testing/cxl/Kbuild
> @@ -59,7 +59,8 @@ cxl_core-y += $(CXL_CORE_SRC)/pmu.o
>  cxl_core-y += $(CXL_CORE_SRC)/cdat.o
>  cxl_core-y += $(CXL_CORE_SRC)/ras.o
>  cxl_core-$(CONFIG_TRACING) += $(CXL_CORE_SRC)/trace.o
> -cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o $(CXL_CORE_SRC)/pmem_region.o
> +cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o
> +cxl_core-$(CONFIG_CXL_PMEM_REGION) += $(CXL_CORE_SRC)/pmem_region.o
>  cxl_core-$(CONFIG_CXL_MCE) += $(CXL_CORE_SRC)/mce.o
>  cxl_core-$(CONFIG_CXL_FEATURES) += $(CXL_CORE_SRC)/features.o
>  cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += $(CXL_CORE_SRC)/edac.o

