Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446137460
	for <nvdimm@lists.linux.dev>; Fri, 29 Mar 2024 15:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711726649; cv=none; b=bsJ5ELQ5WatVSXsthLQHwe4SNnfFuoCdcoIDSBPF7dTgoqRvCuuioPr8Xc9IsqyxUwmB34zkVg4aTraFhg+pUJg9eIp3LwFu7JycaNHOsOrOptbH+E6P4OL28+31Dx1bcmjhaBTRG9ROg92Iftugil4wiEf+lPpCkfy2bylRvwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711726649; c=relaxed/simple;
	bh=a8wvGRmI5RqtmEV/gwKk4sFhcknRdSCzNX49NpAH93g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WOgTNq/0hCmmARBRabhm/nsTvyzS2Em61JguPqeuG9Tg6bXMV9Z3HBI0wgSHhZbv1h8RpQ8ihCIOhBvJTa3FkJKV/mqvBaYM/pslNlQB3VRRhR4CYlWHr9N/nba1wgAy/A0uag6C9cAyxsmuwhTVOiu/9ESD/Sur5h3DwylhJzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F/ldvlqR; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F/ldvlqR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711726649; x=1743262649;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=a8wvGRmI5RqtmEV/gwKk4sFhcknRdSCzNX49NpAH93g=;
  b=F/ldvlqRa1WjroW1ODGEXo7DXQ8cJTKt04jMIIJ4f3FBNvq7g/laEd59
   Id4uN0D6BtnXrDreS2VeJ51/HO/hIxncyKlKB16ZBebqcjUrthbNaXfDp
   IsyeOds4uuwccpi4T6I4C0M11jg1b2oLIXmOO6/VSWZ+Q9kC1XcMxt1ly
   0TB3Ts2XS126Xtc+sBdLLcLeTEga0Fvd32svBa1PH4EDmAYQpiSABmeXO
   3fXMbOHPWCv3SFTxiKYcaMbRkZc7ZzGdPw8M6DfQazYmy6W6Bv10V0ZOs
   itF2YaSB8rHdhqS1GHV2bbZaOrBofSo3rmUxnv1HMMrcImR+OanhEoY5V
   Q==;
X-CSE-ConnectionGUID: lxe0NIxiR5SxjBmcD4LoKQ==
X-CSE-MsgGUID: 2TXwBqf0RTWRx8n2ocp23Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11028"; a="10727403"
X-IronPort-AV: E=Sophos;i="6.07,165,1708416000"; 
   d="scan'208";a="10727403"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 08:37:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,165,1708416000"; 
   d="scan'208";a="21713855"
Received: from mjhill-mobl2.amr.corp.intel.com (HELO [10.212.98.214]) ([10.212.98.214])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 08:37:27 -0700
Message-ID: <cdee392e-dd4b-46ea-8821-7469ad75e294@intel.com>
Date: Fri, 29 Mar 2024 08:37:26 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ndtest: Convert to platform remove callback returning
 void
Content-Language: en-US
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Benjamin Tissoires <benjamin.tissoires@redhat.com>,
 Yi Zhang <yi.zhang@redhat.com>, nvdimm@lists.linux.dev, kernel@pengutronix.de
References: <c04bfc941a9f5d249b049572c1ae122fe551ee5d.1709886922.git.u.kleine-koenig@pengutronix.de>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <c04bfc941a9f5d249b049572c1ae122fe551ee5d.1709886922.git.u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 3/8/24 1:51 AM, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
> 
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  tools/testing/nvdimm/test/ndtest.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index b8419f460368..2c6285aae852 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -830,12 +830,11 @@ static int ndtest_bus_register(struct ndtest_priv *p)
>  	return 0;
>  }
>  
> -static int ndtest_remove(struct platform_device *pdev)
> +static void ndtest_remove(struct platform_device *pdev)
>  {
>  	struct ndtest_priv *p = to_ndtest_priv(&pdev->dev);
>  
>  	nvdimm_bus_unregister(p->bus);
> -	return 0;
>  }
>  
>  static int ndtest_probe(struct platform_device *pdev)
> @@ -882,7 +881,7 @@ static const struct platform_device_id ndtest_id[] = {
>  
>  static struct platform_driver ndtest_driver = {
>  	.probe = ndtest_probe,
> -	.remove = ndtest_remove,
> +	.remove_new = ndtest_remove,
>  	.driver = {
>  		.name = KBUILD_MODNAME,
>  	},
> 
> base-commit: 8ffc8b1bbd505e27e2c8439d326b6059c906c9dd
