Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E788C46BF
	for <nvdimm@lists.linux.dev>; Mon, 26 Jan 2026 22:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769467726; cv=none; b=KW0GxgQTQG68FvJKOfVNwSs+pscKzEHZCIH/TcK8KY+1yrQRvBcApDbYF/RTMvwuSHgHF3JztD/9dJ3Xw0RyLueXv9jnlWnFXataWS0E8th1Jq26M6wejejo6lkhhO5fKz0J6pFTD8vbzu4S8MpDEBhr8dHU38td0va1XkKDK0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769467726; c=relaxed/simple;
	bh=D8KoksDH8T9tKTn6AyX4Y0Vy+UpCqxH18qiKv7pw+OU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bp58/HSAfwSokglwS21VoyTzlfh6KbaEWH4odfjr+zDdtlFBL0+nHF9H3iIz5E7h+EiTaJ9E04PF/Fq39v4oENhZGw0k9WbDnbMF5MofAtMW9YZoy5ywfilWMXP2b7jOuG8R2gwEVceokFGi1yGaP74HpmqZTpq7MNRP93gwsg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C+kg4HLZ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C+kg4HLZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769467724; x=1801003724;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D8KoksDH8T9tKTn6AyX4Y0Vy+UpCqxH18qiKv7pw+OU=;
  b=C+kg4HLZznPdllxMGmOVicn2f/owTnONUxtL0WQkqyUs5h6wCL09vsdv
   IH/tQUr+alsEkegwjOmlW3W5YIEOhcGz7BdpTkjlJjn00zxWS6mODkYyd
   DSqJ8VRZROQCwH5sFZe1++BgUjxf/GOosoPCR2Dz7d6cG5deZSuEZKFcO
   rRxSBqm5CFIkL4Oz6nYFlwjKhkiKKgmm3jxCQygreSEeXcNst05N8hj/C
   tJnjbKVPs9vgXYg9t80/cdvuW5P1OVEF/JcCXJRdJ+xt/x7p1pJwMsSwB
   eHiSXg9GpuP8CW9P4lzIktQyvoWnVTA/xe4lIM3zFH9HEnn9yYXqNqvjH
   g==;
X-CSE-ConnectionGUID: D/jiBRbFSuqmCv08F5xK1g==
X-CSE-MsgGUID: rX0ayGrfReCS4KSniMleTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="88230334"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="88230334"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 14:48:43 -0800
X-CSE-ConnectionGUID: 1ZAj0LP6QzOFqF8d3px4pA==
X-CSE-MsgGUID: b1ftwxwQTuOE00cYeTbSCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="207413402"
Received: from cjhill-mobl.amr.corp.intel.com (HELO [10.125.109.74]) ([10.125.109.74])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 14:48:42 -0800
Message-ID: <ff946a84-11bb-4956-beba-bf7bfbfecd7a@intel.com>
Date: Mon, 26 Jan 2026 15:48:41 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 10/18] cxl/mem: Refactor cxl pmem region
 auto-assembling
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
 <CGME20260123113138epcas5p4bc54ae41192dbc9c958c43ad8a80b5c6@epcas5p4.samsung.com>
 <20260123113112.3488381-11-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260123113112.3488381-11-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/23/26 4:31 AM, Neeraj Kumar wrote:
> In 84ec985944ef3, devm_cxl_add_nvdimm() sequence was changed and called
> before devm_cxl_add_endpoint(). It's because cxl pmem region auto-assembly
> used to get called at last in cxl_endpoint_port_probe(), which requires
> cxl_nvd presence.
> 
> For cxl region persistency, region creation happens during nvdimm_probe
> which need the completion of endpoint probe.
> 
> In order to accommodate both cxl pmem region auto-assembly and cxl region
> persistency, refactored following
> 
> 1. Re-Sequence devm_cxl_add_nvdimm() after devm_cxl_add_endpoint(). This
>    will be called only after successful completion of endpoint probe.
> 
> 2. Create cxl_region_discovery() which performs pmem region
>    auto-assembly and remove cxl pmem region auto-assembly from
>    cxl_endpoint_port_probe()
> 
> 3. Register cxl_region_discovery() with devm_cxl_add_memdev() which gets
>    called during cxl_pci_probe() in context of cxl_mem_probe()
> 
> 4. As cxlmd->attach->probe() calls registered cxl_region_discovery(), so
>    move devm_cxl_add_nvdimm() before cxlmd->attach->probe(). It guarantees
>    both the completion of endpoint probe and cxl_nvd presence before
>    calling cxlmd->attach->probe().
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Hi Neeraj,
Just FYI this is the patch that breaks the auto-region assemble in cxl_test.

DJ

> ---
>  drivers/cxl/core/region.c | 37 +++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h         |  5 +++++
>  drivers/cxl/mem.c         | 18 +++++++++---------
>  drivers/cxl/pci.c         |  4 +++-
>  drivers/cxl/port.c        | 39 +--------------------------------------
>  5 files changed, 55 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index ae899f68551f..26238fb5e8cf 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -3727,6 +3727,43 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_add_to_region, "CXL");
>  
> +static int discover_region(struct device *dev, void *unused)
> +{
> +	struct cxl_endpoint_decoder *cxled;
> +	int rc;
> +
> +	if (!is_endpoint_decoder(dev))
> +		return 0;
> +
> +	cxled = to_cxl_endpoint_decoder(dev);
> +	if ((cxled->cxld.flags & CXL_DECODER_F_ENABLE) == 0)
> +		return 0;
> +
> +	if (cxled->state != CXL_DECODER_STATE_AUTO)
> +		return 0;
> +
> +	/*
> +	 * Region enumeration is opportunistic, if this add-event fails,
> +	 * continue to the next endpoint decoder.
> +	 */
> +	rc = cxl_add_to_region(cxled);
> +	if (rc)
> +		dev_dbg(dev, "failed to add to region: %#llx-%#llx\n",
> +			cxled->cxld.hpa_range.start, cxled->cxld.hpa_range.end);
> +
> +	return 0;
> +}
> +
> +int cxl_region_discovery(struct cxl_memdev *cxlmd)
> +{
> +	struct cxl_port *port = cxlmd->endpoint;
> +
> +	device_for_each_child(&port->dev, NULL, discover_region);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_region_discovery, "CXL");
> +
>  u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa)
>  {
>  	struct cxl_region_ref *iter;
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index c796c3db36e0..86efcc4fb963 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -906,6 +906,7 @@ struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
>  int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
>  struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
>  u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
> +int cxl_region_discovery(struct cxl_memdev *cxlmd);
>  #else
>  static inline bool is_cxl_pmem_region(struct device *dev)
>  {
> @@ -928,6 +929,10 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
>  {
>  	return 0;
>  }
> +static inline int cxl_region_discovery(struct cxl_memdev *cxlmd)
> +{
> +	return 0;
> +}
>  #endif
>  
>  void cxl_endpoint_parse_cdat(struct cxl_port *port);
> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> index 333c366b69e7..7d19528d9b55 100644
> --- a/drivers/cxl/mem.c
> +++ b/drivers/cxl/mem.c
> @@ -114,15 +114,6 @@ static int cxl_mem_probe(struct device *dev)
>  		return -ENXIO;
>  	}
>  
> -	if (cxl_pmem_size(cxlds) && IS_ENABLED(CONFIG_CXL_PMEM)) {
> -		rc = devm_cxl_add_nvdimm(parent_port, cxlmd);
> -		if (rc) {
> -			if (rc == -ENODEV)
> -				dev_info(dev, "PMEM disabled by platform\n");
> -			return rc;
> -		}
> -	}
> -
>  	if (dport->rch)
>  		endpoint_parent = parent_port->uport_dev;
>  	else
> @@ -142,6 +133,15 @@ static int cxl_mem_probe(struct device *dev)
>  			return rc;
>  	}
>  
> +	if (cxl_pmem_size(cxlds) && IS_ENABLED(CONFIG_CXL_PMEM)) {
> +		rc = devm_cxl_add_nvdimm(parent_port, cxlmd);
> +		if (rc) {
> +			if (rc == -ENODEV)
> +				dev_info(dev, "PMEM disabled by platform\n");
> +			return rc;
> +		}
> +	}
> +
>  	if (cxlmd->attach) {
>  		rc = cxlmd->attach->probe(cxlmd);
>  		if (rc)
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 549368a9c868..70b40a10be7a 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -903,6 +903,7 @@ __ATTRIBUTE_GROUPS(cxl_rcd);
>  static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>  	struct pci_host_bridge *host_bridge = pci_find_host_bridge(pdev->bus);
> +	struct cxl_memdev_attach memdev_attach = { 0 };
>  	struct cxl_dpa_info range_info = { 0 };
>  	struct cxl_memdev_state *mds;
>  	struct cxl_dev_state *cxlds;
> @@ -1006,7 +1007,8 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (rc)
>  		dev_dbg(&pdev->dev, "No CXL Features discovered\n");
>  
> -	cxlmd = devm_cxl_add_memdev(cxlds, NULL);
> +	memdev_attach.probe = cxl_region_discovery;
> +	cxlmd = devm_cxl_add_memdev(cxlds, &memdev_attach);
>  	if (IS_ERR(cxlmd))
>  		return PTR_ERR(cxlmd);
>  
> diff --git a/drivers/cxl/port.c b/drivers/cxl/port.c
> index 7937e7e53797..fbeff1978bfb 100644
> --- a/drivers/cxl/port.c
> +++ b/drivers/cxl/port.c
> @@ -30,33 +30,6 @@ static void schedule_detach(void *cxlmd)
>  	schedule_cxl_memdev_detach(cxlmd);
>  }
>  
> -static int discover_region(struct device *dev, void *unused)
> -{
> -	struct cxl_endpoint_decoder *cxled;
> -	int rc;
> -
> -	if (!is_endpoint_decoder(dev))
> -		return 0;
> -
> -	cxled = to_cxl_endpoint_decoder(dev);
> -	if ((cxled->cxld.flags & CXL_DECODER_F_ENABLE) == 0)
> -		return 0;
> -
> -	if (cxled->state != CXL_DECODER_STATE_AUTO)
> -		return 0;
> -
> -	/*
> -	 * Region enumeration is opportunistic, if this add-event fails,
> -	 * continue to the next endpoint decoder.
> -	 */
> -	rc = cxl_add_to_region(cxled);
> -	if (rc)
> -		dev_dbg(dev, "failed to add to region: %#llx-%#llx\n",
> -			cxled->cxld.hpa_range.start, cxled->cxld.hpa_range.end);
> -
> -	return 0;
> -}
> -
>  static int cxl_switch_port_probe(struct cxl_port *port)
>  {
>  	/* Reset nr_dports for rebind of driver */
> @@ -82,17 +55,7 @@ static int cxl_endpoint_port_probe(struct cxl_port *port)
>  	if (rc)
>  		return rc;
>  
> -	rc = devm_cxl_endpoint_decoders_setup(port);
> -	if (rc)
> -		return rc;
> -
> -	/*
> -	 * Now that all endpoint decoders are successfully enumerated, try to
> -	 * assemble regions from committed decoders
> -	 */
> -	device_for_each_child(&port->dev, NULL, discover_region);
> -
> -	return 0;
> +	return devm_cxl_endpoint_decoders_setup(port);
>  }
>  
>  static int cxl_port_probe(struct device *dev)

