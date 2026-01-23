Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8397A33985
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 22:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769206798; cv=none; b=MweSjW47KoK5uLSbz/kyY8nLIxIhg2XbFAuwMD3s3tvQhamu5hSIOTHwxtB1itak6P5Iwvze/FCsl4mrJnRjn6KqRprRLX6cnvR280Pv206OXRmbaaEIQY34wYwREigfbmoz7cnB6ZOxnkfKYbvtcEEDrqYFeqLJn2SV7wzozTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769206798; c=relaxed/simple;
	bh=f46HoRAJ85RzL7B/bYHJxpvWHR7YFCKdw9Omy5owrF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OpUALKiUUHNrmIqZL4ul1A4hVdrLTY48ZoRv8+IqhOahfc32YdTx1qkQCze+tNNymBC21okRJGOjnaW+kuvmp7flZaKa8XzE0374h5OBu8NAIx1byq6jZfG3+tpHW8ZHZerhJqzv7agiCXI39QD0icWBTuw+4Pz1QqAyJqi4PWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y4+kwWq2; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y4+kwWq2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769206797; x=1800742797;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f46HoRAJ85RzL7B/bYHJxpvWHR7YFCKdw9Omy5owrF8=;
  b=Y4+kwWq2bWrJl8ZiEKyNCrDcpls/d/rGyxBT8f74leewE92kVkMRLcUK
   k2jR6xP7vqKJQx5SPeGzPWQ+4kgID1o479mqJSN7aQzppoAzuEjCdvYFn
   D6hMkBkU7lW5A9ERqPyhxLMe26N1qaB0WWQu3GxFicFuuNHcv2TUaiLxn
   BhNv9INbadvUJe63B0udPMzh+OVtNSLCBXA4J/vw4KFxOZMafrsDAPF5q
   MjdaSDOGF1v7J9J5kLXYMcmkg8KQ9Pft5kE4/2erBR+jOe+3Ud5oFluYn
   +EeF/eFqhdm2FEbzstwr4hTf8yoJAw0jKp/Y4LNPmd9lEDmU0JMZFBdcI
   A==;
X-CSE-ConnectionGUID: 3HaEf1beRFiNLwEXWvJyxw==
X-CSE-MsgGUID: Xcycyxf+RdGgpINrybQfWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="81904213"
X-IronPort-AV: E=Sophos;i="6.21,249,1763452800"; 
   d="scan'208";a="81904213"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 14:19:57 -0800
X-CSE-ConnectionGUID: bqaYHjEdS0eAhDGIqTJzLA==
X-CSE-MsgGUID: pKCyYRZMT2Ckn4T76bWxqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,249,1763452800"; 
   d="scan'208";a="207476869"
Received: from ldmartin-desk2.corp.intel.com (HELO [10.125.108.225]) ([10.125.108.225])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 14:19:54 -0800
Message-ID: <ee064449-d0a3-41df-a83e-d83ca17b61dd@intel.com>
Date: Fri, 23 Jan 2026 15:19:53 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/7] cxl/region: Add helper to check Soft Reserved
 containment by CXL regions
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Yazen Ghannam <yazen.ghannam@amd.com>, Davidlohr Bueso <dave@stgolabs.net>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown <len.brown@intel.com>,
 Pavel Machek <pavel@kernel.org>, Li Ming <ming.li@zohomail.com>,
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Nathan Fontenot <nathan.fontenot@amd.com>,
 Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>,
 Tomasz Wolski <tomasz.wolski@fujitsu.com>
References: <20260122045543.218194-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260122045543.218194-5-Smita.KoralahalliChannabasappa@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260122045543.218194-5-Smita.KoralahalliChannabasappa@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/21/26 9:55 PM, Smita Koralahalli wrote:
> Add a helper to determine whether a given Soft Reserved memory range is
> fully contained within the committed CXL region.
> 
> This helper provides a primitive for policy decisions in subsequent
> patches such as co-ordination with dax_hmem to determine whether CXL has
> fully claimed ownership of Soft Reserved memory ranges.
> 
> No functional changes are introduced by this patch.
> 
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Just a nit below.

> ---
>  drivers/cxl/core/region.c | 29 +++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h         |  5 +++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 45ee598daf95..9827a6dd3187 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -3875,6 +3875,35 @@ static int cxl_region_debugfs_poison_clear(void *data, u64 offset)
>  DEFINE_DEBUGFS_ATTRIBUTE(cxl_poison_clear_fops, NULL,
>  			 cxl_region_debugfs_poison_clear, "%llx\n");
>  
> +static int cxl_region_contains_sr_cb(struct device *dev, void *data)

Since it's a local helper, maybe just call it region_contains_soft_reserve()?

DJ

> +{
> +	struct resource *res = data;
> +	struct cxl_region *cxlr;
> +	struct cxl_region_params *p;
> +
> +	if (!is_cxl_region(dev))
> +		return 0;
> +
> +	cxlr = to_cxl_region(dev);
> +	p = &cxlr->params;
> +
> +	if (p->state != CXL_CONFIG_COMMIT)
> +		return 0;
> +
> +	if (!p->res)
> +		return 0;
> +
> +	return resource_contains(p->res, res) ? 1 : 0;
> +}
> +
> +bool cxl_region_contains_soft_reserve(const struct resource *res)
> +{
> +	guard(rwsem_read)(&cxl_rwsem.region);
> +	return bus_for_each_dev(&cxl_bus_type, NULL, (void *)res,
> +				cxl_region_contains_sr_cb) != 0;
> +}
> +EXPORT_SYMBOL_GPL(cxl_region_contains_soft_reserve);
> +
>  static int cxl_region_can_probe(struct cxl_region *cxlr)
>  {
>  	struct cxl_region_params *p = &cxlr->params;
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index c796c3db36e0..b0ff6b65ea0b 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -906,6 +906,7 @@ struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
>  int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
>  struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
>  u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
> +bool cxl_region_contains_soft_reserve(const struct resource *res);
>  #else
>  static inline bool is_cxl_pmem_region(struct device *dev)
>  {
> @@ -928,6 +929,10 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
>  {
>  	return 0;
>  }
> +static inline bool cxl_region_contains_soft_reserve(const struct resource *res)
> +{
> +	return false;
> +}
>  #endif
>  
>  void cxl_endpoint_parse_cdat(struct cxl_port *port);

