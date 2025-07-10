Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDF379DA
	for <nvdimm@lists.linux.dev>; Thu, 10 Jul 2025 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752164645; cv=none; b=OY7DDo8eSmUrssmgiYqk5EVKN5jw95ZVD4SgDHZQd4dI/WdRwsmbCd5DuKDNRlnUvBJtIyUDYXx2jgIXwOZz3JYDCDyz0NjgoWQblmprCgZANZuDxxBhRZw/tFxJDi8TcuXYTVmQcaohNKcC80HJv9271K7w3ve+CIW8yBuAjGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752164645; c=relaxed/simple;
	bh=zj5uiNEScsLGvfrxIy5xfLdTdtyZfSoCbqsWmaSGc5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GkjB+VGVNuk/knVMGm/ZQsG0ezQLx1qJlCH96euOgXhGq2l2pwqRhFXONFUDZIuk7dUR3Yi3fMbAe5bWWvHBiO1HY6gVVK0HeJ41kMPz2aI6NDqhdGB6OZPFDfJ7kf4RbTGL5dGcDD1NW9A7fsbW/Cm2JDD/ZTz/p/b5E64xDoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SZnObKtr; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SZnObKtr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752164642; x=1783700642;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zj5uiNEScsLGvfrxIy5xfLdTdtyZfSoCbqsWmaSGc5M=;
  b=SZnObKtrXPCU3zqR+/sCX4xkkDW/NGu7ycYK6dtSUKdZ06kc4UWDvo33
   K2Ztv5UPuM1V5WZUJxbwRTswjgwgfByzCDc1qynCIVRjZLixwiIAfC8wd
   fRTP8fGkyZJP6hFq2ZBAczjO1nxNW53vBqs1KYVdGv+wC3/TGkipN+FtQ
   PEsKor+elv4mXzyD1EXw5KAnsOXGo+JoAVtnC8uyeXJ/IAo+S8gLQnwtU
   SE1lzbW3AKDskaaoVtUOG93MNOBwncwm3xw5xVJoNqPfmd3zKG2bZXGia
   v5ccIRvIYnC5HMRdwjvezGvXmBZh8Y4z+ZS1CwA1yEcfxqzBKeiKX/j3R
   w==;
X-CSE-ConnectionGUID: 7YOBLtS2RueqLrvSEOU45w==
X-CSE-MsgGUID: 02M4TJaqR1yyvgGgTRAgSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54303832"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="54303832"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 09:24:02 -0700
X-CSE-ConnectionGUID: cGOXdp0UT/u2JmhG2pCqkw==
X-CSE-MsgGUID: CPdsE8BTTI6kmCEEFkgSHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="187139562"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.110.242]) ([10.125.110.242])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 09:24:01 -0700
Message-ID: <29487b27-ad1a-4c6d-a1a7-26eb97e77663@intel.com>
Date: Thu, 10 Jul 2025 09:23:59 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 15/20] cxl: Add a routine to find cxl root decoder on
 cxl bus
To: Neeraj Kumar <s.neeraj@samsung.com>, dan.j.williams@intel.com,
 dave@stgolabs.net, jonathan.cameron@huawei.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
 vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
 alok.rathore@samsung.com, neeraj.kernel@gmail.com,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
References: <20250617123944.78345-1-s.neeraj@samsung.com>
 <CGME20250617124049epcas5p1de7eeee3b5ddd12ea221ca3ebf22f6e8@epcas5p1.samsung.com>
 <1295226194.21750165382072.JavaMail.epsvc@epcpadp2new>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <1295226194.21750165382072.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/17/25 5:39 AM, Neeraj Kumar wrote:
> Add cxl_find_root_decoder to find root decoder on cxl bus. It is used to
> find root decoder during region creation
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/core/port.c | 26 ++++++++++++++++++++++++++
>  drivers/cxl/cxl.h       |  1 +
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 2452f7c15b2d..94d9322b8e38 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -513,6 +513,32 @@ struct cxl_switch_decoder *to_cxl_switch_decoder(struct device *dev)
>  }
>  EXPORT_SYMBOL_NS_GPL(to_cxl_switch_decoder, "CXL");
>  
> +static int match_root_decoder(struct device *dev, void *data)
> +{
> +	return is_root_decoder(dev);
> +}
> +
> +/**
> + * cxl_find_root_decoder() - find a cxl root decoder on cxl bus
> + * @port: any descendant port in root-cxl-port topology

s/root-cxl-port/CXL port/

Please add a comment noting that the caller of this function must call put_device() when done as a device ref is taken via device_find_child().

> + */
> +struct cxl_root_decoder *cxl_find_root_decoder(struct cxl_port *port)

cxl_port_find_root_decoder(). There is a cxl_find_root_decoder() already in core/region.c and could cause potential symbol clash.

DJ

> +{
> +	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
> +	struct device *dev;
> +
> +	if (!cxl_root)
> +		return NULL;
> +
> +	dev = device_find_child(&cxl_root->port.dev, NULL, match_root_decoder);
> +
> +	if (!dev)
> +		return NULL;
> +
> +	return to_cxl_root_decoder(dev);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_find_root_decoder, "CXL");
> +
>  static void cxl_ep_release(struct cxl_ep *ep)
>  {
>  	put_device(ep->ep);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 30c80e04cb27..2c6a782d0941 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -871,6 +871,7 @@ bool is_cxl_nvdimm_bridge(struct device *dev);
>  int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
>  struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port);
>  void cxl_region_discovery(struct cxl_port *port);
> +struct cxl_root_decoder *cxl_find_root_decoder(struct cxl_port *port);
>  
>  #ifdef CONFIG_CXL_REGION
>  bool is_cxl_pmem_region(struct device *dev);

