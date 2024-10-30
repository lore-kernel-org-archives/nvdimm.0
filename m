Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24491BD9F4
	for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 18:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730313161; cv=none; b=AOdeIL5lI6gA6soAF1fFm62b6vE7Z3iN6WOgGJZSBa8mwMj+a2JaKpICYAfxydXiTpk1EsX9AdMyHIoahNhrChhPYdQRHffd+OdI0kQwmJJ9mAfqz827hTg3gHv+PWL7rsAGCN4Iz8qVOLu86jDHLvU4I5HdK1f6Eawi+bdC1as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730313161; c=relaxed/simple;
	bh=uKySPkrqXDPgs4yTMKdKB4kcwXEilJC0jwyaMkNRQAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RnZ8nfQMtQUwSutNOHJMe4Ag0tfpdiKitNCchmLutQIMsIkH/Nf69xO/h3e7gL2r9ZS32G4/+LtYGcqyTLT173g0px3BpG6LQ2km4R/M0Jnb4V1ESDnpIqgbEB4e/AlPX6uBJDGs1sOW2FwIBDdrzqmzHnP+rzuuPmfLYzNK0sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X9Ca4nDo; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X9Ca4nDo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730313159; x=1761849159;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uKySPkrqXDPgs4yTMKdKB4kcwXEilJC0jwyaMkNRQAU=;
  b=X9Ca4nDorTllTaqjPwiqhs4WgK7+AJFmxvhDYovEPmJKbE0uFTXTqleM
   Y5GDSd1aEes0QLCEjKhbvQFhi+zwJLlmWNUAi1Txaxvpl7nwCVmBoaZMC
   4oJuerRRwJri8Z7pDuo/Sl95Lm9KTebyxDQXV0RTCGjWlJNdOEdDYpm/L
   2jpG8Ol2XVh6nAlf96cK7W4/u1OVtxl8oB6b1949XVsopZ5xqv1lHOLSL
   smeq1PGQX/EsItI2HDbKqWcr4sjyrDTpiPV9rIfLYTn1ZtGkow8Zs90nZ
   JJZI9q50/tOhH8wtt2rMbjjMOjnNn3MjCoI5tVcEfsmzD2vnoiI2Se/FQ
   A==;
X-CSE-ConnectionGUID: 2GHE4z7QTn2a6fcToVQ8DQ==
X-CSE-MsgGUID: RauSTEahQOaKQnw+GC7oJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="33961094"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="33961094"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 11:32:38 -0700
X-CSE-ConnectionGUID: uudTCmFsSOyE84T1m6xWag==
X-CSE-MsgGUID: t/KE/7CBSrqMJdAtcmEXnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82711049"
Received: from nnlnb-sb-019.ccr.corp.intel.com (HELO [10.125.108.160]) ([10.125.108.160])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 11:32:37 -0700
Message-ID: <64b7b0f9-d9e1-4458-8149-9ccbf78e1c27@intel.com>
Date: Wed, 30 Oct 2024 11:32:35 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/27] cxl/cdat: Gather DSMAS data for DCD regions
To: Ira Weiny <ira.weiny@intel.com>, Fan Ni <fan.ni@samsung.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
 linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
 <20241029-dcd-type2-upstream-v5-12-8739cb67c374@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20241029-dcd-type2-upstream-v5-12-8739cb67c374@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/29/24 1:34 PM, Ira Weiny wrote:
> Additional DCD region (partition) information is contained in the DSMAS
> CDAT tables, including performance, read only, and shareable attributes.
> 
> Match DCD partitions with DSMAS tables and store the meta data.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> Changes:
> [Fan: remove unwanted blank line]
> [Rafael: Split out acpi change]
> [iweiny: remove %pra use]
> [Jonathan: s/cdat/CDAT/]
> ---
>  drivers/cxl/core/cdat.c | 39 +++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/core/mbox.c |  2 ++
>  drivers/cxl/cxlmem.h    |  3 +++
>  3 files changed, 44 insertions(+)
> 
> diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
> index b5d30c5bf1e20725d13b4397a7ba90662bcd8766..7cd7734a3b0f0b742ee6e63973d12fb3e83ac332 100644
> --- a/drivers/cxl/core/cdat.c
> +++ b/drivers/cxl/core/cdat.c
> @@ -17,6 +17,8 @@ struct dsmas_entry {
>  	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
>  	int entries;
>  	int qos_class;
> +	bool shareable;
> +	bool read_only;
>  };
>  
>  static u32 cdat_normalize(u16 entry, u64 base, u8 type)
> @@ -74,6 +76,8 @@ static int cdat_dsmas_handler(union acpi_subtable_headers *header, void *arg,
>  		return -ENOMEM;
>  
>  	dent->handle = dsmas->dsmad_handle;
> +	dent->shareable = dsmas->flags & ACPI_CDAT_DSMAS_SHAREABLE;
> +	dent->read_only = dsmas->flags & ACPI_CDAT_DSMAS_READ_ONLY;
>  	dent->dpa_range.start = le64_to_cpu((__force __le64)dsmas->dpa_base_address);
>  	dent->dpa_range.end = le64_to_cpu((__force __le64)dsmas->dpa_base_address) +
>  			      le64_to_cpu((__force __le64)dsmas->dpa_length) - 1;
> @@ -255,6 +259,39 @@ static void update_perf_entry(struct device *dev, struct dsmas_entry *dent,
>  		dent->coord[ACCESS_COORDINATE_CPU].write_latency);
>  }
>  
> +static void update_dcd_perf(struct cxl_dev_state *cxlds,
> +			    struct dsmas_entry *dent)
> +{
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
> +	struct device *dev = cxlds->dev;
> +
> +	for (int i = 0; i < mds->nr_dc_region; i++) {
> +		/* CXL defines a u32 handle while CDAT defines u8, ignore upper bits */
> +		u8 dc_handle = mds->dc_region[i].dsmad_handle & 0xff;
> +
> +		if (resource_size(&cxlds->dc_res[i])) {
> +			struct range dc_range = {
> +				.start = cxlds->dc_res[i].start,
> +				.end = cxlds->dc_res[i].end,
> +			};
> +
> +			if (range_contains(&dent->dpa_range, &dc_range)) {
> +				if (dent->handle != dc_handle)
> +					dev_warn(dev, "DC Region/DSMAS mis-matched handle/range; region [range 0x%016llx-0x%016llx] (%u); dsmas [range 0x%016llx-0x%016llx] (%u)\n"
> +						      "   setting DC region attributes regardless\n",
> +						dent->dpa_range.start, dent->dpa_range.end,
> +						dent->handle,
> +						dc_range.start, dc_range.end,
> +						dc_handle);
> +
> +				mds->dc_region[i].shareable = dent->shareable;
> +				mds->dc_region[i].read_only = dent->read_only;
> +				update_perf_entry(dev, dent, &mds->dc_perf[i]);
> +			}
> +		}
> +	}
> +}
> +
>  static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
>  				     struct xarray *dsmas_xa)
>  {
> @@ -278,6 +315,8 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
>  		else if (resource_size(&cxlds->pmem_res) &&
>  			 range_contains(&pmem_range, &dent->dpa_range))
>  			update_perf_entry(dev, dent, &mds->pmem_perf);
> +		else if (cxl_dcd_supported(mds))
> +			update_dcd_perf(cxlds, dent);
>  		else
>  			dev_dbg(dev, "no partition for dsmas dpa: %#llx\n",
>  				dent->dpa_range.start);
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 2c9a9af3dde3a294cde628880066b514b870029f..a4b5cb61b4e6f9b17e3e3e0cce356b0ac9f960d0 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1649,6 +1649,8 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev)
>  	mds->cxlds.type = CXL_DEVTYPE_CLASSMEM;
>  	mds->ram_perf.qos_class = CXL_QOS_CLASS_INVALID;
>  	mds->pmem_perf.qos_class = CXL_QOS_CLASS_INVALID;
> +	for (int i = 0; i < CXL_MAX_DC_REGION; i++)
> +		mds->dc_perf[i].qos_class = CXL_QOS_CLASS_INVALID;
>  
>  	return mds;
>  }
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 2fb93269ab4359dd12dfb912ded30654e2340be0..204f7bd9197bd1a02de44ef56a345811d2107ab4 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -466,6 +466,8 @@ struct cxl_dc_region_info {
>  	u64 blk_size;
>  	u32 dsmad_handle;
>  	u8 flags;
> +	bool shareable;
> +	bool read_only;
>  	u8 name[CXL_DC_REGION_STRLEN];
>  };
>  
> @@ -533,6 +535,7 @@ struct cxl_memdev_state {
>  
>  	u8 nr_dc_region;
>  	struct cxl_dc_region_info dc_region[CXL_MAX_DC_REGION];
> +	struct cxl_dpa_perf dc_perf[CXL_MAX_DC_REGION];
>  
>  	struct cxl_event_state event;
>  	struct cxl_poison_state poison;
> 

