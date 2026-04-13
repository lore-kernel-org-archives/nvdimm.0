Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7988718BBAE
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 15:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776093491; cv=none; b=Iy1YcztaNGd4JYi7OgAxoRQ4QRbO5lH/h/B9frMe9dN0u5Gobv7Szib7EurnUNWqYVuaPYFJKWpmAhskFPca4erIbsYRKSlS6wzRiCF9T7iUfuGbuIZHGA7XCBTu/mZ+Jx+9CmFsL1II2UbyQJi8ajQfElqHPbhha0C+kYGPvRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776093491; c=relaxed/simple;
	bh=olMDejFIfnSvDs8YiRdGkEeIW1DYheSHAl5Sc3lW4nU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cGRw5lgWRAbkcjiic4iZRuO//9LgVK4ueOBNP0FW9NglG4BmPNp/8O4FnbLcAorjeGwnVlATucKo1LiI4y2gWl7veNqpsY5AU0V4S7Sf6KurQgDdWJEnSNoUioq2j9JCAbpN9pWoeh+OqrggGyNRMUFsypmJhMecOJ2p35yv+34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YP4d8I+7; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YP4d8I+7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776093489; x=1807629489;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=olMDejFIfnSvDs8YiRdGkEeIW1DYheSHAl5Sc3lW4nU=;
  b=YP4d8I+7uYZ/KSJuWsxDld1rb8R9fGkIk/pbpBF4VnOUCXJmiCydrdu+
   v1M+5EmBqdxHatXya9PpS9E+36sY7+XUecKRd3MMjyuKrQ8onPUEGWZ6/
   ZTkmTamorFqO3GGd6xrMPIfPApYrob8J+qmimv/KeGo0PcVLQGj+7XEKz
   EPP8DqOoFx8yfHaJpKbF+JxDKaet8SLivvolL7I4hZ9ARRt3peXDieZ78
   P9qXO7zZueIQLXYJ8W5htr/pfO5KKZ5KHaLxxcZNvcZEIcR/1Euyhcpuh
   NOvmJmV4YvUF6ZZfU4Om5bbvmcX6VmkYPqM5mpOcNIPGQGvOAVSYCqOvY
   w==;
X-CSE-ConnectionGUID: MsM7ML1fSrqRvv9MlDH31Q==
X-CSE-MsgGUID: qIGRLgdRS2GIT6g3P8NVDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11758"; a="80620137"
X-IronPort-AV: E=Sophos;i="6.23,177,1770624000"; 
   d="scan'208";a="80620137"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 08:18:09 -0700
X-CSE-ConnectionGUID: ynE/ymUmTyyPCmp/BcNZmA==
X-CSE-MsgGUID: QUo8LmX7Qby/qW/vaZ/OTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,177,1770624000"; 
   d="scan'208";a="231536012"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.109.175]) ([10.125.109.175])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 08:18:08 -0700
Message-ID: <765dfd20-5a4d-44d6-9007-22fddc395b42@intel.com>
Date: Mon, 13 Apr 2026 08:18:07 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] cxl/list: apply bus and port filters to anonymous
 memdevs
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <20260411011358.3133190-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260411011358.3133190-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/10/26 6:13 PM, Alison Schofield wrote:
> Anonymous memdevs are disabled memdevs that do not nest in the
> topology output and are reported separately in the "anon memdevs"
> array.
> 
> A user reports that cxl list -M -i with a port filter may return
> anonymous memdevs that are not part of the selected port. In this
> case, QEMU-defined disabled memdevs were returned in a query of a
> cxl_test bus port.
> 
> The issue has two parts. First, util_cxl_memdev_filter_by_port() does 
> not properly constrain bus-filtered queries. It treats the bus name
> as a port identifier, allowing memdevs from other buses to match.
> 
> Second, cxl_filter_walk() collects anonymous memdevs in a global
> pre-pass without applying decoder, bus, or port filters, so disabled
> memdevs outside the requested scope are included.
> 
> Update util_cxl_memdev_filter_by_port() to limit the search to the
> selected bus and match ports only within that bus. Apply decoder and
> bus/port filtering to anonymous memdevs so they follow the same rules
> as other memdev listings.
> 
> Found with CXL unit test cxl-topology.sh
> 
> Reported-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Thanks for the quick fix.

> ---
>  cxl/filter.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/cxl/filter.c b/cxl/filter.c
> index 8c7dc6e31701..5d634d3b2512 100644
> --- a/cxl/filter.c
> +++ b/cxl/filter.c
> @@ -615,12 +615,12 @@ util_cxl_memdev_filter_by_port(struct cxl_memdev *memdev, const char *bus_ident,
>  		struct cxl_port *port, *top;
>  
>  		port = cxl_bus_get_port(bus);
> -		if (util_cxl_bus_filter(bus, bus_ident))
> -			if (__memdev_filter_by_port(memdev, port,
> -						    cxl_bus_get_devname(bus)))
> -				return memdev;
> +
> +		if (!util_cxl_bus_filter(bus, bus_ident))
> +			continue;
>  		if (__memdev_filter_by_port(memdev, port, port_ident))
> -				return memdev;
> +			return memdev;
> +
>  		top = port;
>  		cxl_port_foreach_all(top, port)
>  			if (__memdev_filter_by_port(memdev, port, port_ident))
> @@ -1125,6 +1125,12 @@ struct json_object *cxl_filter_walk(struct cxl_ctx *ctx,
>  		if (!util_cxl_memdev_filter(memdev, p->memdev_filter,
>  					    p->serial_filter))
>  			continue;
> +		if (!util_cxl_memdev_filter_by_decoder(memdev,
> +						       p->decoder_filter))
> +			continue;
> +		if (!util_cxl_memdev_filter_by_port(memdev, p->bus_filter,
> +						    p->port_filter))
> +			continue;
>  		if (cxl_memdev_is_enabled(memdev))
>  			continue;
>  		if (!p->idle)

