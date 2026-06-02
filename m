Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EAC282F1A
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 00:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780359205; cv=none; b=GBOk0i9I5P08hATeV7JM/ETOqt+1iFGLJFL/2xjP8r9z9UC9++QeaX4fytppFXgFRCaGdStsABlGzQQ6nODjVvYKjwU3pRV4YLP601cGU2zAmuL1WNoJwtnw+SwZslV1IukSToFgGi0X2fHd4AWy2QKsBHHGpI8YVNvlNtgPhsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780359205; c=relaxed/simple;
	bh=MfuSKIvwZ9zcGWvQRHhhb65OQYqtt3icjo2hcSD/D0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wn82w9XHzb5PV2GaiRHd3Kt5FGddcToT44j+DfTwyaJMj3YeNi3bvKUrtgbF2Bmlvu+DCarLZYD60A6kpmlUkzLbG1jBkepngSLoh5nKPsI5EImMvBi1SfFYajRaQ4dWVSQpv0WnZP8jMZRYEP8nYxG9hSNImu+ZnzNVpuEzB6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VLjD47Gb; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VLjD47Gb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780359202; x=1811895202;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MfuSKIvwZ9zcGWvQRHhhb65OQYqtt3icjo2hcSD/D0g=;
  b=VLjD47Gb5ZMRj+yBMzKa5OLRA0PrcUmvZD9NVe4ca0Dx+Gg7FJXiLv9H
   ggV38P87IRFm5vHoApPrz2fugAApd+iYStunPDr7MD2dSar2QO5JNUWwm
   oZVxO5K5oyDH1r0dERgN8KO4jtwJk/X1S0PEm/wRpbSwXU43clh7wdiIM
   A/XtaaBeObgzFEXbKdSfGQrY8ZXSWak9i2bmMoa3NCurti2I/WZCkEBvp
   bXK4Fu5l03t46tndpbh6gGtxxqTS4uV4FZ90rdUU0p9UXYDN+lyH567BR
   bw1nlcHOf2yLDEb+mP8ZrPK1n3yH/Sm8f1NWLQjMA9ia4rDhI5Kxh7kvV
   Q==;
X-CSE-ConnectionGUID: yrwW4EFfRIqr6P71Nr+vbw==
X-CSE-MsgGUID: YCE1YoClSC+LInmC2Fo/uA==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="92605940"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="92605940"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 17:13:22 -0700
X-CSE-ConnectionGUID: 9/nLObPSSzebJ9FOYge7cg==
X-CSE-MsgGUID: c4HsNaGvSOqiy/Ov+4TjzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="242910586"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.108.24]) ([10.125.108.24])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 17:13:20 -0700
Message-ID: <4b381e73-ef4c-4d73-a60f-7725a678dd35@intel.com>
Date: Mon, 1 Jun 2026 17:13:18 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 8/9] dax: replace exported dax_dev_get() with
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
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165126.6721-1-john@jagalactic.com>
 <0100019e79cc4e0f-26041b0e-3c38-4641-9e36-c8964a7f0e89-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e79cc4e0f-26041b0e-3c38-4641-9e36-c8964a7f0e89-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/30/26 9:51 AM, John Groves wrote:
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
>    never ida_alloc'd -- potentially freeing the minor of a real device.
> 
> Add dax_dev_find() which uses ilookup5() for lookup-only semantics:
> it returns an existing dax_device with an elevated inode reference, or
> NULL if no device with the given dev_t exists. It never creates inodes.
> A dax_alive() check under dax_read_lock() guards against returning a
> device that is concurrently being torn down by kill_dax().
> 
> Make dax_dev_get() static again (internal to super.c for alloc_dax),
> export dax_dev_find() instead, and update the two external callers
> (famfs_inode.c, famfs.c). Also add the missing CONFIG_DAX=n stub.
> 
> Fixes: 2ae624d5a555d ("dax: export dax_dev_get()")

Not sure about the Fixes tag when the caller isn't in tree?

> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/dax/super.c | 38 ++++++++++++++++++++++++++++++++++++--
>  include/linux/dax.h |  6 +++++-
>  2 files changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 4c56ac2faacdb..6cb271e034a70 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -550,7 +550,7 @@ static int dax_set(struct inode *inode, void *data)
>  	return 0;
>  }
>  
> -struct dax_device *dax_dev_get(dev_t devt)
> +static struct dax_device *dax_dev_get(dev_t devt)
>  {
>  	struct dax_device *dax_dev;
>  	struct inode *inode;
> @@ -573,7 +573,41 @@ struct dax_device *dax_dev_get(dev_t devt)
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
> +	struct dax_device *dax_dev;
> +	struct inode *inode;
> +	int id;
> +
> +	inode = ilookup5(dax_superblock, hash_32(devt + DAXFS_MAGIC, 31),
> +			 dax_test, &devt);
> +	if (!inode)
> +		return NULL;
> +
> +	dax_dev = to_dax_dev(inode);
> +	id = dax_read_lock();
> +	if (!dax_alive(dax_dev)) {
> +		dax_read_unlock(id);
> +		iput(inode);
> +		return NULL;
> +	}
> +	dax_read_unlock(id);
> +
> +	return dax_dev;
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

