Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5837D34C130;
	Fri, 16 Oct 2026 15:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792164049; cv=none; b=fUaRrc3vK0wOjMhPJ4vOIZ3oclsdHjey0hLSV3rK4FmBz2wygQdwO0olvrq5HDnrt5PnKCsVjYXVB8Dw9jipmCnNaHIfG9pThadcpHeoM9vMqq53HkrDVGXAZuwQeGSbjppexx2zZ4hXPFxoxh3bHCozKcgRorDPiqTobXjMMo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792164049; c=relaxed/simple;
	bh=jwuPtwSPRxLLgLs4Bw1aoujtu2qP7pCGzt/oQIflePM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cisd47pGKsHy2IPVMxowPcQuCzThjY7KAvwqoZog8MwmlWMM4oWT+CD6jk55B8dtcm2x3XNilcknNwKyNWzFSBH94S+rGrSu0wplQuRFCcaPpds1LTC7ycSZ/NAt1yMao1U8kMjopJT9SO5DnRU2tlkFvCBQEWp7pn3NXGkFSDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GuO4Eppu; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GuO4Eppu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792164047; x=1823700047;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jwuPtwSPRxLLgLs4Bw1aoujtu2qP7pCGzt/oQIflePM=;
  b=GuO4Eppue2ZaaS0Z3nQymdWhv91DeWgoqLlMX3dl//wMfqwvjzdMEhvp
   MjE3UVfy4qEQaUxNB1HCLbW+WjAEZoEab6j6gyPhJD3Bhy4QRtFjqVzZ7
   tPkCHNGiXDcRk9/Z1BFR44HdshuCMYUBZKlEdk/tpKyA1yO1P2dSGBqGd
   q63FVjsmxQCJkoTL8IyzedaqQbHEE9uDZp9OkmFu5TdOvxLpt+6KeB8Su
   zNZELmwXzqL0qCi4OUfXMNBGv6hU3hFSZzXKSRpahpNElBoXXvrwkgxvu
   /UIgxpbPhL+8fWH4UbSV2iFgOWOzI5MuQT3asTGTMO4YXfqw/I0zwp1JT
   g==;
X-CSE-ConnectionGUID: s7oAbzcgR2SEi0SiNNLLaw==
X-CSE-MsgGUID: VP8jWtUUQYO3rTtNs8+r0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11937"; a="839769"
X-IronPort-AV: E=Sophos;i="6.27,162,1787036400"; 
   d="scan'208";a="839769"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2026 08:20:46 -0700
X-CSE-ConnectionGUID: 21Jy+rSIS8S7dEGejQRUvw==
X-CSE-MsgGUID: e8HfQWk5QTis1PQra48oAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,162,1787036400"; 
   d="scan'208";a="1885372"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.110.167]) ([10.125.110.167])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2026 08:20:44 -0700
Message-ID: <61841d94-a4ff-448b-8699-381c23b18dc2@intel.com>
Date: Fri, 16 Oct 2026 08:20:43 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/10] dax: add fsdev_dax_from_file()
To: Miklos Szeredi <mszeredi@redhat.com>, fuse-devel@lists.linux.dev
Cc: John Groves <John@Groves.net>, Amir Goldstein <amir73il@gmail.com>,
 "Darrick J . Wong" <djwong@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <20261016151638.2962413-1-mszeredi@redhat.com>
 <20261016151638.2962413-2-mszeredi@redhat.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261016151638.2962413-2-mszeredi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/16/26 8:16 AM, Miklos Szeredi wrote:
> From: John Groves <John@Groves.net>
> 
> If the file is a fsdev_dax open, take the dax_dev from the device inode's
> i_cdev.  Return with a reference grabbed on the private dax inode.
> 
> Make dax_dev_get() static again (internal to super.c for alloc_dax), export
> fsdev_dax_from_file() instead.
> 
> This fix is in response to a Sashiko review, and some subsequent analysis.
> 
> About the 'fixes' tag: this removes the export of dax_dev_get(), which was
> flawed, and replaces it with fsdev_dax_from_file(). It feels like the fixes
> tag makes sense for correcting an ABI error.
> 
> Fixes: 2ae624d5a555d ("dax: export dax_dev_get()")
> Originally-by: John Groves <john@groves.net>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/fsdev.c | 23 +++++++++++++++++++++++
>  drivers/dax/super.c |  3 +--
>  include/linux/dax.h |  3 ++-
>  3 files changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 598604bf5ac5..910665c1f492 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -234,6 +234,29 @@ static const struct file_operations fsdev_fops = {
>  	.release = fsdev_release,
>  };
>  
> +/**
> + * fsdev_dax_from_file - get dax_device from an open file
> + * @file: open device file
> + *
> + * Returns a dax_device pointer if @file refers to a fsdev_dax device.
> + * Otherwise return NULL.
> + *
> + * Caller must put_dax() the returned device when done.
> + */
> +struct dax_device *fsdev_dax_from_file(struct file *file)
> +{
> +	struct dax_device *dax_dev;
> +
> +	if (file->f_op != &fsdev_fops)
> +		return NULL;
> +
> +	dax_dev = inode_dax(file_inode(file));
> +	ihold(dax_inode(dax_dev));
> +
> +	return dax_dev;
> +}
> +EXPORT_SYMBOL_GPL(fsdev_dax_from_file);
> +
>  /*
>   * Acquire the dev_pagemap for probe: the static (pre-populated) one if
>   * present, or a devm-allocated one for the dynamic case. Note that
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 45f84b0eb909..25836f389bde 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -565,7 +565,7 @@ static int dax_set(struct inode *inode, void *data)
>  	return 0;
>  }
>  
> -struct dax_device *dax_dev_get(dev_t devt)
> +static struct dax_device *dax_dev_get(dev_t devt)
>  {
>  	struct dax_device *dax_dev;
>  	struct inode *inode;
> @@ -588,7 +588,6 @@ struct dax_device *dax_dev_get(dev_t devt)
>  
>  	return dax_dev;
>  }
> -EXPORT_SYMBOL_GPL(dax_dev_get);
>  
>  struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
>  {
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index fe6c3ded1b50..2c9fc81f031b 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -54,7 +54,6 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
>  void *dax_holder(struct dax_device *dax_dev);
>  void put_dax(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
> -struct dax_device *dax_dev_get(dev_t devt);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);
>  bool dax_write_cache_enabled(struct dax_device *dax_dev);
>  bool dax_synchronous(struct dax_device *dax_dev);
> @@ -323,3 +322,5 @@ typedef int (*walk_hmem_fn)(struct device *dev, int target_nid,
>  			    const struct resource *res);
>  int walk_hmem_resources(struct device *dev, walk_hmem_fn fn);
>  #endif
> +
> +struct dax_device *fsdev_dax_from_file(struct file *file);

