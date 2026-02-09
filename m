Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612042E9730
	for <nvdimm@lists.linux.dev>; Mon,  9 Feb 2026 18:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770662151; cv=none; b=cf0s1qPKrTx28FSRxiSDGfxuO9naV5ZB27SlNauFY+JhWCfMZ342ANbZ5pBB6GLW1qFxpLvVX8MK0G1odpG5GNZKJ8kKSjrZ9f+3S4vFD3Th7a1FfXApG3DQA0b1P31YfNkQuFMB5qKfwAlDL438Gpqz5lmcuCDgAI00jb3RNzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770662151; c=relaxed/simple;
	bh=23Q+cBaQEfghXjw+2uOqr3PDPxLLEYpXqpdU5HOGkuk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lUNmofLdXHQgyFjThoa691kySBIFSMjtqJcU/HbzYqdnMiGaqt/MDPt7o6WMoi7yzZDRTfXZGiSZ2VIyrcPTz/k6CqNptZZh6KfyqJmBzKqxGX9t5WqNGX3Q2t5BsmRTP1MgYM0nVMNs8DbCc1NgfRKwwdRrX+Fgh9uRkIEXmZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=msKkxVm1; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="msKkxVm1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770662152; x=1802198152;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=23Q+cBaQEfghXjw+2uOqr3PDPxLLEYpXqpdU5HOGkuk=;
  b=msKkxVm1rHUYBwANptUTxVtFk5Yt7U8t8oDrREsBrmz28whXC9PRjX6d
   HPHS4jcrVgY4tJVnQha7+KjsgPjjf5ux22dWIb5RBE7+rHymaNdyFHQwx
   zm7aNTf0CbFSAzJt+fNf66FVKYyobyHaev3HHeOQj5QHXQstVrQR8Jsxw
   hbH+e7RWMDmX9s8osBpa6s8qDdbL8whUfIDN0t/Mv/nb/Fh/oGmafCI9G
   c45xcBotBSbHDJLdnZmkLQ8bkRdBuMFXFFM4Gb4RdNNDIAoPXmYahr3zk
   lQjA5gcJNJ8H6mxLTRLwqEwhMKwbH9W9LNe5CkdT7gCtZQ/s3oQ88rfVh
   g==;
X-CSE-ConnectionGUID: otjiBJ16THq+AgsVbgqTnw==
X-CSE-MsgGUID: PfiHenFVTdeCHc2BUBPjRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="75408246"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="75408246"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 10:35:51 -0800
X-CSE-ConnectionGUID: N3C3daOdRGyYuuD0Wt2AkA==
X-CSE-MsgGUID: IjoBcuT1SH6JstMyi2x3XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="249291946"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.111.252]) ([10.125.111.252])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 10:35:51 -0800
Message-ID: <70b82b52-70a1-4c9d-8ab7-021147d20eb1@intel.com>
Date: Mon, 9 Feb 2026 11:35:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 2/2] util/sysfs: add hint for missing root
 privileges on sysfs access
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
Cc: "Joel C. Chang" <joelcchangg@gmail.com>
References: <b74bfd8623fcfc4cf1078991b22b8c899147f5fb.1768530600.git.alison.schofield@intel.com>
 <4e4ba50b1130c2a76bd2f903aa00644e43faf047.1768530600.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <4e4ba50b1130c2a76bd2f903aa00644e43faf047.1768530600.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/15/26 7:43 PM, Alison Schofield wrote:
> A user reports that when running daxctl they do not get a hint to
> use sudo or root when an action fails. They provided this example:
> 
> 	libdaxctl: daxctl_dev_disable: dax0.0: failed to disable
> 	dax0.0: disable failed: Device or resource busy
> 	error reconfiguring devices: Device or resource busy
> 	reconfigured 0 devices
> 
> and noted that the message is misleading as the problem was a lack
> of privileges, not a busy device.
> 
> Add a helpful hint when a sysfs open or write fails with EACCES or
> EPERM, advising the user to run with root privileges or use sudo.
> 
> Only the log messages are affected and no functional behavior is
> changed. To make the new hints visible without debug enabled, make
> them error level instead of debug.
> 
> Reported-by: Joel C. Chang <joelcchangg@gmail.com>
> Closes: https://lore.kernel.org/all/ZEJkI2i0GBmhtkI8@joel-gram-ubuntu/
> Closes: https://github.com/pmem/ndctl/issues/237
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  util/sysfs.c | 31 ++++++++++++++++++++++++++-----
>  1 file changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/util/sysfs.c b/util/sysfs.c
> index 5a12c639fe4d..e027e387c997 100644
> --- a/util/sysfs.c
> +++ b/util/sysfs.c
> @@ -24,7 +24,14 @@ int __sysfs_read_attr(struct log_ctx *ctx, const char *path, char *buf)
>  	int n, rc;
>  
>  	if (fd < 0) {
> -		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
> +		if (errno == EACCES || errno == EPERM)
> +			log_err(ctx, "failed to open %s: %s "
> +				"hint: try running as root or using sudo\n",
> +				path, strerror(errno));
> +		else
> +			log_dbg(ctx, "failed to open %s: %s\n",
> +				path, strerror(errno));
> +
>  		return -errno;
>  	}
>  	n = read(fd, buf, SYSFS_ATTR_SIZE);
> @@ -49,16 +56,30 @@ static int write_attr(struct log_ctx *ctx, const char *path,
>  
>  	if (fd < 0) {
>  		rc = -errno;
> -		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
> +		if (errno == EACCES || errno == EPERM)
> +			log_err(ctx, "failed to open %s: %s "
> +				"hint: try running as root or using sudo\n",
> +				path, strerror(errno));
> +		else
> +			log_dbg(ctx, "failed to open %s: %s\n",
> +				path, strerror(errno));
>  		return rc;
>  	}
>  	n = write(fd, buf, len);
>  	rc = -errno;
>  	close(fd);
>  	if (n < len) {
> -		if (!quiet)
> -			log_dbg(ctx, "failed to write %s to %s: %s\n", buf, path,
> -					strerror(-rc));
> +		if (quiet)
> +			return rc;
> +
> +		if (rc == -EACCES || rc == -EPERM)
> +			log_err(ctx, "failed to write %s to %s: %s "
> +				"hint: try running as root or using sudo\n",
> +				buf, path, strerror(-rc));
> +		else
> +			log_dbg(ctx, "failed to write %s to %s: %s\n",
> +				buf, path, strerror(-rc));
> +
>  		return rc;
>  	}
>  	return 0;

