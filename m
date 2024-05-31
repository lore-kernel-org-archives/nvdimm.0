Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FA737700
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 21:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717191170; cv=none; b=dogLn2K4xhE6D+oihbQuNGwMucFjqbUlULBZpgxRhx0kN+jy20MBrn5n/z6TB+DhlZQc/zYZiOXkYRxXXxcPf8icdzxfkq5r3kBq6hRv9asI5q3V/Gn9TDRNjoVeWh6dFVbmUPPxrtkpMuwd3ZMnh3tp+UBuSUCoqwZ2yYf2ePo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717191170; c=relaxed/simple;
	bh=5aKDGy1JNMDswdl6LADEi9NugEGEbk0hhzFjhHONaF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U4kxziDl6Xu6hDnfxxO/PtZfRd6FGm31fHhJwyLIBoiE9emjG6dvySgXIC5lcDbQN+WypHa13W6O/nE5W3cm2qTiOgKA+h4+CKOzW0YOdNM+k35XO4xDmWVQJWK3l561JvppKjIoYYvMMCcwsj4n58QOXdmndHqmoKGRA8K4pAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MzZScKZP; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MzZScKZP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717191169; x=1748727169;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5aKDGy1JNMDswdl6LADEi9NugEGEbk0hhzFjhHONaF4=;
  b=MzZScKZPxkGqPIfxDKgRMUawNCkWQW/AF1jTeXYVr4RRFYTB5AWolElD
   2hIgBXMna21qKLyZUEHq563KljxiBoY0jSrBZTFV1v9DJ7eTxb54+COI9
   qUrsayJbG7LqwFAePpDRmHp9aOGfp0HAJJ9Q8XLHyXAYgr32ejunAjiw6
   4eVUU8sIZH0gBMJRrBPi3OpABPdWDwMof9gZ9FBMo6N3x9IYNpnJxVqrq
   wS1Mf5oYhqa/2cB0UFDGGF9Jz5B9GWCdCTkXJ1M0Shixe2d79FOFR+ATl
   UAHAfkNgFtkFHZywshE5u3uEEOagqmtCz9GTrTaQrFKmUhs+KiBY1azup
   A==;
X-CSE-ConnectionGUID: iUIHic2IQTCySuFmkPO6ng==
X-CSE-MsgGUID: YXQhpwLXSMiEYhWPmOK3bQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="36284770"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36284770"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 14:32:44 -0700
X-CSE-ConnectionGUID: Ysq8esKJTH69HQWxxdY5lg==
X-CSE-MsgGUID: Elj+IaQrS8Sb9rY1Aa/EuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36388990"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.251.21.184])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 14:32:43 -0700
Date: Fri, 31 May 2024 14:32:41 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Fan Ni <fan.ni@samsung.com>
Subject: Re: [ndctl PATCH v2 1/2] daxctl: Fix create-device parameters parsing
Message-ID: <ZlpB+SYykp2gpAcS@aschofie-mobl2>
References: <20240531062959.881772-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531062959.881772-1-lizhijian@fujitsu.com>

On Fri, May 31, 2024 at 02:29:58PM +0800, Li Zhijian wrote:
> Previously, the extra parameters will be ignored quietly, which is a bit
> weird and confusing.

It's just wrong. There is code to catch extra params, but it's being
skipped because of the index setting that you mention below. Suggest
referencing the incorrect index is causing the extra params to be
ignored.

Suggest commit msg of:
daxctl: Fail create-device if extra parameters are present


> $ daxctl create-device region0
> [
>   {
>     "chardev":"dax0.1",
>     "size":268435456,
>     "target_node":1,
>     "align":2097152,
>     "mode":"devdax"
>   }
> ]
> created 1 device
> 
> where above user would want to specify '-r region0'.
> 
> Check extra parameters starting from index 0 to ensure no extra parameters
> are specified for create-device.
> 
> Cc: Fan Ni <fan.ni@samsung.com>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
> V2:
> Remove the external link[0] in case it get disappeared in the future.
> [0] https://github.com/moking/moking.github.io/wiki/cxl%E2%80%90test%E2%80%90tool:-A-tool-to-ease-CXL-test-with-QEMU-setup%E2%80%90%E2%80%90Using-DCD-test-as-an-example#convert-dcd-memory-to-system-ram
> ---
>  daxctl/device.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/daxctl/device.c b/daxctl/device.c
> index 839134301409..ffabd6cf5707 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -363,7 +363,8 @@ static const char *parse_device_options(int argc, const char **argv,
>  		NULL
>  	};
>  	unsigned long long units = 1;
> -	int i, rc = 0;
> +	int rc = 0;
> +	int i = action == ACTION_CREATE ? 0 : 1;

This confuses me because at this point I don't know what 'i' will be
used for.  How about moving the setting near the usage below -

>  	char *device = NULL;
>  
>  	argc = parse_options(argc, argv, options, u, 0);
> @@ -402,7 +403,7 @@ static const char *parse_device_options(int argc, const char **argv,
>  			action_string);
>  		rc = -EINVAL;
>  	}
> -	for (i = 1; i < argc; i++) {
> +	for (; i < argc; i++) {
>  		fprintf(stderr, "unknown extra parameter \"%s\"\n", argv[i]);
>  		rc = -EINVAL;
>  	}

Something like this:

diff --git a/daxctl/device.c b/daxctl/device.c
index 14d62148c58a..6c0758101c4a 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -402,6 +402,8 @@ static const char *parse_device_options(int argc, const char **argv,
                        action_string);
                rc = -EINVAL;
        }
+       /* ACTION_CREATE expects 0 parameters */
+       i = action == ACTION_CREATE ? 0 : 1;
        for (i = 1; i < argc; i++) {
                fprintf(stderr, "unknown extra parameter \"%s\"\n", argv[i]);
                rc = -EINVAL;






> -- 
> 2.29.2
> 
> 
