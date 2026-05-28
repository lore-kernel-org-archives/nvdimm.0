Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245E8330D35
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 21:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780002196; cv=none; b=X+fbJyLdDC0U6B7wBHsr2YwANN87QFlxCx74Mxi5vOVquWxpIOImLUA1l+q4DWTZJPz91pSfrVALYfsOu9ICHxrvwPWkPPgNBEayaEugnajmE3jDf30jHJ5CJlnbx2uM6SDSoTgIWkisA9YTcSUCRcwbotkgRqmD+iX4ToTelj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780002196; c=relaxed/simple;
	bh=wqGZG/DreGm0wyaqRMtagSNe8zgk8RaiQdGXDQQIdcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HF5erwxa49IX2RwMa0qqzdua8qq7DHNOXtf2Z0rqzIbTgq08ioJISq7bU8I9QtU9dDrhqXIwdRjTitzM7mh9K25JF4BHbVOow70rB7bPIzyO2cwkRA5UA470s/nUXaLKCO/506EJJ6nZxBI2P0ht2dDk8Zt4JeTa159aVwx2kAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iySttR0w; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iySttR0w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780002196; x=1811538196;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wqGZG/DreGm0wyaqRMtagSNe8zgk8RaiQdGXDQQIdcc=;
  b=iySttR0wP+GXDU6NskN6lMo9rQ+O6TfLcChHZfKEwSKXODGiR3QiHSEH
   72+4lw6yLkBF+YzcreNbBbyTGu/oyiaS61qWh+59f17UYQe0M5OEz9/3U
   XmJLPrz4ijTOqCRh5lEf600ma7LiVcHOGuoiFWs9oYIdnKVO3HE1uMLzJ
   jMBaIT0ncSz99IvnIVLfBV3Ov4qUyvnYWLoeUcaKCjmaYiqdOp4t8mc9K
   ATJEMzNHOHG4cabCUB741aQaya7242UrdfcpfIexprRzF8SKxqZFDAJa8
   Z7DrH0DA1Le4TCvQ9SflMbElv13n2Uz8da/H0IehT8/LHKGibveb6ZHgu
   Q==;
X-CSE-ConnectionGUID: 4u1Ht0D0Rey8MoJeJLOshg==
X-CSE-MsgGUID: +t0YN7syTPqn/HSadL7xGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="84479951"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="84479951"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 14:03:15 -0700
X-CSE-ConnectionGUID: yJTQxAeMSH2RA8RhMHWo9A==
X-CSE-MsgGUID: 8MIL+Y7aRBeWoUBWqO1BJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="246669822"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.111.91]) ([10.125.111.91])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 14:03:13 -0700
Message-ID: <c09e9ae9-d5b9-48b6-9225-98f53022545d@intel.com>
Date: Thu, 28 May 2026 14:03:12 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 15/31] cxl/mem: Drop misaligned DCD extent groups
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>, Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <60e23199f7ef7dd3008bb3275c40d242334275c9.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <60e23199f7ef7dd3008bb3275c40d242334275c9.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/23/26 2:43 AM, Anisa Su wrote:
> Add an alignment gate to cxl_add_pending(): every extent in a tag group
> must have its start_dpa and length aligned to CXL_DCD_EXTENT_ALIGN (SZ_2M,
> the minimum device-dax mapping granularity on every architecture that
> enables CXL DCD).  A misaligned extent makes the resulting dax device
> unusable, so drop the whole group rather than accept a partial allocation
> that would surface a broken dax_resource.
> 
> Based on patches by John Groves.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Groves <John@Groves.net>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> 
> ---
> Changes:
> [anisa: split out as a separate validation step]
> ---
>  drivers/cxl/core/mbox.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index e5edc3975e8f..421bd716a273 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -7,6 +7,7 @@
>  #include <linux/unaligned.h>
>  #include <linux/list.h>
>  #include <linux/list_sort.h>
> +#include <linux/sizes.h>
>  #include <cxlpci.h>
>  #include <cxlmem.h>
>  #include <cxl.h>
> @@ -1280,6 +1281,24 @@ static int add_to_pending_list(struct list_head *pending_list,
>  	return 0;
>  }
>  
> +/*
> + * Device-dax requires extent boundaries aligned to its mapping granularity.
> + * Use SZ_2M as a conservative default; a tighter check that queries the
> + * cxl_dax_region / cxl_endpoint_decoder for its actual alignment would be
> + * strictly more correct, but SZ_2M is the minimum device-dax supports on
> + * every architecture that enables CXL DCD today.
> + */
> +#define CXL_DCD_EXTENT_ALIGN	SZ_2M

Wonder if this would cause issues in DAX on ARM64 with 64k page size since its PMD size is 512M. 

DJ
> +
> +static bool cxl_extent_dcd_aligned(const struct cxl_extent *extent)
> +{
> +	u64 start = le64_to_cpu(extent->start_dpa);
> +	u64 len = le64_to_cpu(extent->length);
> +
> +	return IS_ALIGNED(start, CXL_DCD_EXTENT_ALIGN) &&
> +	       IS_ALIGNED(len, CXL_DCD_EXTENT_ALIGN);
> +}
> +
>  /*
>   * Compare two extents by shared_extn_seq (ascending).  list_sort is
>   * stable so when shared_extn_seq is 0 for every entry (non-sharable
> @@ -1352,6 +1371,26 @@ static int cxl_add_pending(struct cxl_memdev_state *mds)
>  		extract_tag_group(pending, &tag, &group);
>  		list_sort(NULL, &group, extent_seq_compare);
>  
> +		/* Alignment gate — abort the group if any member fails */
> +		bool aligned = true;

declaring var in middle of code

> +		list_for_each_entry(pos, &group, list) {
> +			if (!cxl_extent_dcd_aligned(pos->extent)) {
> +				dev_warn(dev,
> +					 "Tag %pUb: dropping group, extent DPA:%#llx LEN:%#llx not %u-aligned\n",
> +					 &tag,
> +					 le64_to_cpu(pos->extent->start_dpa),
> +					 le64_to_cpu(pos->extent->length),
> +					 CXL_DCD_EXTENT_ALIGN);
> +				aligned = false;
> +				break;
> +			}
> +		}
> +		if (!aligned) {
> +			list_for_each_entry_safe(pos, tmp, &group, list)
> +				delete_extent_node(pos);
> +			continue;
> +		}
> +
>  		u16 logical_seq = 1;

Looks like this one came from a previous patch.


>  		list_for_each_entry_safe(pos, tmp, &group, list) {
>  			u16 raw = le16_to_cpu(pos->extent->shared_extn_seq);

