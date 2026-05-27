Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA05327453
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 00:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779841733; cv=none; b=TkiU+N3Job6ywcR36dNsdLG+DOqWyh/U2OXkXMjta9kL6MA5KDOaQy7635dTxmaWu+vyB4FDX3JDTOr364lw6MUdsZnuIL1W3fnYWfOpHwY1bfADpSRo0THO/SxL/ON+ZI8CkVob6wCt/ise+Zlcf72/mGTrgNaizzsNSl96Jig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779841733; c=relaxed/simple;
	bh=3gXWNxNB8VP6Ff2XMIG5SMf2eN1KNTcgsTeMdZkfKro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uuxCFQRlW0XcfJ5uS+qXVZr4HvyiIcF3EUIA11ditaQ7khppvbjBsMrOc44nYJ00fQuhxbtMWN+X7uqC/e2wWpqQkUdJZQIr0+26sosnO5SZiH6qTqRaxb20+ViCADJZ0f8/sUDDnr+VROpldgGEgR/fncNJI4PaevipWa+n6HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E/qPSzR8; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E/qPSzR8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779841732; x=1811377732;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3gXWNxNB8VP6Ff2XMIG5SMf2eN1KNTcgsTeMdZkfKro=;
  b=E/qPSzR8oTWyuSyXHxlvxX0k0MYp9I9KXyUCjR20g1tlSr+itH0/MP/M
   JUoI4x3YOz9y3cYc1TzRu24YfCjwVoL7WK7249CQ20QxEZSzGToxLvI91
   3DNlMz2XLEe0wnIUBVFCKtezVWkv0dEE3FmZsECkq9NAvGDNgc5E56jUk
   gXVoE4aXGO7czN5KzWjgpl1Axw8RjVew93E6Fb3+4nFVtl32flSULojI2
   Z+WyEXIrSPfk41zANEdO9qhcZa34NlTQ15Gg8wE0TEYoS8Eq4Z5msLVqb
   NJ/E5szFeUUi2kw81l5JIrJxIeP2+byoW1Ab5hlG0P9tPgk1rPA6Yl2zF
   Q==;
X-CSE-ConnectionGUID: Z2mv7za/Sh+bmHHCH5iT7g==
X-CSE-MsgGUID: crlxGWVFRKK1ekMkoJQrwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="91357818"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="91357818"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 17:28:51 -0700
X-CSE-ConnectionGUID: nzFADZe7T1OkJAEa+OgaDQ==
X-CSE-MsgGUID: QkIoZaUZTgiAtrQJakHGDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="246335810"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.110.201]) ([10.125.110.201])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 17:28:50 -0700
Message-ID: <a7ea31ac-8aca-4ff5-adf1-7b3941eba5b4@intel.com>
Date: Tue, 26 May 2026 17:28:48 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 6/7] dax: replace exported dax_dev_get() with
 non-allocating dax_dev_find()
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Dan Williams <djbw@kernel.org>
Cc: John Groves <jgroves@micron.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
 <20260522191925.79227-1-john@jagalactic.com>
 <0100019e5120f45c-f2183035-0304-4601-87bc-85d933ce51e7-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e5120f45c-f2183035-0304-4601-87bc-85d933ce51e7-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/22/26 12:19 PM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> This fix is in response to a Sashiko review, and some subsequent
> analysis.
> 
> dax_dev_get() uses iget5_locked() which creates a new inode if no
> matching one exists. This is correct for the internal caller
> (alloc_dax), but dangerous for external callers that look up devices
> from user-supplied or metadata-supplied dev_t values:
> 
> 1. A new inode is created with DAXDEV_ALIVE set but no backing driver,
>    no ops, and no IDA-allocated minor number.
> 
> 2. On teardown, dax_destroy_inode() warns because kill_dax() was never
>    called, and dax_free_inode() calls ida_free() for a minor that was
>    never ida_alloc'd — potentially freeing the minor of a real device.
> 
> Add dax_dev_find() which uses ilookup5() for lookup-only semantics:
> it returns an existing dax_device with an elevated inode reference, or
> NULL if no device with the given dev_t exists. It never creates inodes.
> 
> Make dax_dev_get() static again (internal to super.c for alloc_dax),
> export dax_dev_find() instead, and update the two external callers
> (famfs_inode.c, famfs.c). Also add the missing CONFIG_DAX=n stub.
> 
> Fixes: 2ae624d5a555d ("dax: export dax_dev_get()")
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/super.c | 27 +++++++++++++++++++++++++--
>  include/linux/dax.h |  6 +++++-
>  2 files changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index fa1d2a6eb2408..79e5823d1010d 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -541,7 +541,7 @@ static int dax_set(struct inode *inode, void *data)
>  	return 0;
>  }
>  
> -struct dax_device *dax_dev_get(dev_t devt)
> +static struct dax_device *dax_dev_get(dev_t devt)
>  {
>  	struct dax_device *dax_dev;
>  	struct inode *inode;
> @@ -564,7 +564,30 @@ struct dax_device *dax_dev_get(dev_t devt)
>  
>  	return dax_dev;
>  }
> -EXPORT_SYMBOL_GPL(dax_dev_get);
> +
> +/**
> + * dax_dev_find - look up an existing dax_device by dev_t
> + * @devt: the device number to find
> + *
> + * Returns a dax_device with an elevated inode reference, or NULL if no
> + * device with the given dev_t exists. Unlike dax_dev_get(), this never
> + * allocates a new inode — it is safe for external callers that are looking
> + * up devices from user-supplied or metadata-supplied dev_t values.
> + *
> + * Caller must put_dax() the returned device when done.
> + */
> +struct dax_device *dax_dev_find(dev_t devt)
> +{
> +	struct inode *inode;
> +
> +	inode = ilookup5(dax_superblock, hash_32(devt + DAXFS_MAGIC, 31),
> +			 dax_test, &devt);
> +	if (!inode)
> +		return NULL;
> +

Claude mentions that dax_alive() check may be a good idea after grabbing the inode ref. Otherwise famfs may get a dax_dev that may be racing with a teardown. Do something similar that fs_dax_get_by_dev() or fs_dax_get() do WRT dax_alive() check perhaps.

DJ


> +	return to_dax_dev(inode);
> +}
> +EXPORT_SYMBOL_GPL(dax_dev_find);
>  
>  struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
>  {
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index fe6c3ded1b50f..29113eb95e72d 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -54,7 +54,7 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
>  void *dax_holder(struct dax_device *dax_dev);
>  void put_dax(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
> -struct dax_device *dax_dev_get(dev_t devt);
> +struct dax_device *dax_dev_find(dev_t devt);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);
>  bool dax_write_cache_enabled(struct dax_device *dax_dev);
>  bool dax_synchronous(struct dax_device *dax_dev);
> @@ -92,6 +92,10 @@ static inline void put_dax(struct dax_device *dax_dev)
>  static inline void kill_dax(struct dax_device *dax_dev)
>  {
>  }
> +static inline struct dax_device *dax_dev_find(dev_t devt)
> +{
> +	return NULL;
> +}
>  static inline void dax_write_cache(struct dax_device *dax_dev, bool wc)
>  {
>  }

