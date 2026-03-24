Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67A53FE344
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774365944; cv=none; b=m6eY750YNgYvP7zCiNm39EpskuwTLW+HRztLsQCpS6InZAxz5wbUlii/kNNOLpn8KRfLJ7Kvco9C3QPPlMpjBqY+FMOkYgg7idxwGLnCSOheR/iLszSdEoZKL914XquFhSbxekR4q4Mz++hyd1OflzF90x1htiRBmQFaP9MNIDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774365944; c=relaxed/simple;
	bh=jeQXGWXW5DYZbmlwpZZUSd6Abgx4FfGMTceWU3VAjno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZQVfQ/NXq6GrvAnWoCDAZUE2bCySxO6g76WSZ99EzT+4P9u9WAugOoG8XavOaG/OqJ5y6mrZ9+aLYXt1GLfGAm4sFE+zauLPo13mgjPuVzCHzQZsQLSgwrVxKw4e9zJS+U5BGJ++Lq01BiVat0uYPsd9PiHwtFwqnRB9EiROKao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N647/8W8; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N647/8W8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774365943; x=1805901943;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jeQXGWXW5DYZbmlwpZZUSd6Abgx4FfGMTceWU3VAjno=;
  b=N647/8W8rR423F1qkgVWJ9pmfgnh/C2umvyd5a/6MllWcdU6dx3VW27j
   UXlrISMnnXPbindrmSlWMxndOlxFcX74zObSzoN8RmLBlqxkdYG0YLwC2
   tKOdIPfqWghht7XuzFx8rtpyP91snqBHpNO4oovYL+uUXIocCc3ajET7g
   PWmtounHWfUgriAIHsJj51/DgIloipLH5VOhdK48RfpT4LpOgwR9w37n9
   Zpj7nd6RENGCvXb1uLkFTbArSEnTz9ylJhVuCeTg7UPKZx7OMDV9/LFrz
   XcVvIrZ/0btpdSjp1dihkVziJ7mLK+WJ5J0NUgaPrCj4cBwncrMPbaTBX
   g==;
X-CSE-ConnectionGUID: pVWSjqK+T16cJMdTCYoujw==
X-CSE-MsgGUID: Dy/DDmeESz6tAss93PPaPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="75100991"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="75100991"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 08:25:42 -0700
X-CSE-ConnectionGUID: TKxnMyNnTBKIiJdg/c15Mg==
X-CSE-MsgGUID: D3byFbOkTk+nc7XpEvIq5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="226024176"
Received: from jdoman-mobl3.amr.corp.intel.com (HELO [10.125.110.6]) ([10.125.110.6])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 08:25:38 -0700
Message-ID: <a46671a3-ec70-415f-90a4-04cd2c2e9016@intel.com>
Date: Tue, 24 Mar 2026 08:25:36 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 7/8] dax: Add fs_dax_get() func to prepare dax for
 fs-dax usage
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>,
 Bernd Schubert <bschubert@ddn.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 David Hildenbrand <david@kernel.org>, Christian Brauner
 <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong
 <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>,
 Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>,
 Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>,
 Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>,
 Gregory Price <gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>,
 Ajay Joshi <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003919.5106-1-john@jagalactic.com>
 <0100019d1d484ddc-2487f887-7ecd-49a3-abfe-9dabec28873f-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019d1d484ddc-2487f887-7ecd-49a3-abfe-9dabec28873f-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/23/26 5:39 PM, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> The fs_dax_get() function should be called by fs-dax file systems after
> opening a fsdev dax device. This adds holder_operations, which provides
> a memory failure callback path and effects exclusivity between callers
> of fs_dax_get().
> 
> fs_dax_get() is specific to fsdev_dax, so it checks the driver type
> (which required touching bus.[ch]). fs_dax_get() fails if fsdev_dax is
> not bound to the memory.
> 
> This function serves the same role as fs_dax_get_by_bdev(), which dax
> file systems call after opening the pmem block device.
> 
> This can't be located in fsdev.c because struct dax_device is opaque
> there.
> 
> This will be called by fs/fuse/famfs.c in a subsequent commit.
> 
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/bus.c   |  2 --
>  drivers/dax/bus.h   |  2 ++
>  drivers/dax/super.c | 66 ++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/dax.h | 17 +++++++++---
>  4 files changed, 80 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 562e2b06f61a..8a8710a8234e 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -39,8 +39,6 @@ static int dax_bus_uevent(const struct device *dev, struct kobj_uevent_env *env)
>  	return add_uevent_var(env, "MODALIAS=" DAX_DEVICE_MODALIAS_FMT, 0);
>  }
>  
> -#define to_dax_drv(__drv)	container_of_const(__drv, struct dax_device_driver, drv)
> -
>  static struct dax_id *__dax_match_id(const struct dax_device_driver *dax_drv,
>  		const char *dev_name)
>  {
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index 880bdf7e72d7..dc6f112ac4a4 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -42,6 +42,8 @@ struct dax_device_driver {
>  	void (*remove)(struct dev_dax *dev);
>  };
>  
> +#define to_dax_drv(__drv) container_of_const(__drv, struct dax_device_driver, drv)
> +
>  int __dax_driver_register(struct dax_device_driver *dax_drv,
>  		struct module *module, const char *mod_name);
>  #define dax_driver_register(driver) \
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index ba0b4cd18a77..d4ab60c406bf 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -14,6 +14,7 @@
>  #include <linux/fs.h>
>  #include <linux/cacheinfo.h>
>  #include "dax-private.h"
> +#include "bus.h"
>  
>  /**
>   * struct dax_device - anchor object for dax services
> @@ -111,6 +112,10 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev, u64 *start_off,
>  }
>  EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
>  
> +#endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
> +
> +#if IS_ENABLED(CONFIG_FS_DAX)
> +
>  void fs_put_dax(struct dax_device *dax_dev, void *holder)
>  {
>  	if (dax_dev && holder &&
> @@ -119,7 +124,66 @@ void fs_put_dax(struct dax_device *dax_dev, void *holder)
>  	put_dax(dax_dev);
>  }
>  EXPORT_SYMBOL_GPL(fs_put_dax);
> -#endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
> +
> +/**
> + * fs_dax_get() - get ownership of a devdax via holder/holder_ops
> + *
> + * fs-dax file systems call this function to prepare to use a devdax device for
> + * fsdax. This is like fs_dax_get_by_bdev(), but the caller already has struct
> + * dev_dax (and there is no bdev). The holder makes this exclusive.
> + *
> + * @dax_dev: dev to be prepared for fs-dax usage
> + * @holder: filesystem or mapped device inside the dax_device
> + * @hops: operations for the inner holder
> + *
> + * Returns: 0 on success, <0 on failure
> + */
> +int fs_dax_get(struct dax_device *dax_dev, void *holder,
> +	const struct dax_holder_operations *hops)
> +{
> +	struct dev_dax *dev_dax;
> +	struct dax_device_driver *dax_drv;
> +	int id;
> +
> +	id = dax_read_lock();
> +	if (!dax_dev || !dax_alive(dax_dev) || !igrab(&dax_dev->inode)) {
> +		dax_read_unlock(id);
> +		return -ENODEV;
> +	}
> +	dax_read_unlock(id);
> +
> +	/* Verify the device is bound to fsdev_dax driver */
> +	dev_dax = dax_get_private(dax_dev);
> +	if (!dev_dax) {
> +		iput(&dax_dev->inode);
> +		return -ENODEV;
> +	}
> +
> +	device_lock(&dev_dax->dev);
> +	if (!dev_dax->dev.driver) {
> +		device_unlock(&dev_dax->dev);
> +		iput(&dax_dev->inode);
> +		return -ENODEV;
> +	}
> +	dax_drv = to_dax_drv(dev_dax->dev.driver);
> +	if (dax_drv->type != DAXDRV_FSDEV_TYPE) {
> +		device_unlock(&dev_dax->dev);
> +		iput(&dax_dev->inode);
> +		return -EOPNOTSUPP;
> +	}
> +	device_unlock(&dev_dax->dev);
> +
> +	if (cmpxchg(&dax_dev->holder_data, NULL, holder)) {
> +		iput(&dax_dev->inode);
> +		return -EBUSY;
> +	}
> +
> +	dax_dev->holder_ops = hops;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fs_dax_get);
> +#endif /* CONFIG_FS_DAX */
>  
>  enum dax_device_flags {
>  	/* !alive + rcu grace period == no new operations / mappings */
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index b19bfe0c2fd1..bf37b9a982f3 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -130,7 +130,6 @@ int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk);
>  void dax_remove_host(struct gendisk *disk);
>  struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev, u64 *start_off,
>  		void *holder, const struct dax_holder_operations *ops);
> -void fs_put_dax(struct dax_device *dax_dev, void *holder);
>  #else
>  static inline int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk)
>  {
> @@ -145,12 +144,13 @@ static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev,
>  {
>  	return NULL;
>  }
> -static inline void fs_put_dax(struct dax_device *dax_dev, void *holder)
> -{
> -}
>  #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
>  
>  #if IS_ENABLED(CONFIG_FS_DAX)
> +void fs_put_dax(struct dax_device *dax_dev, void *holder);
> +int fs_dax_get(struct dax_device *dax_dev, void *holder,
> +	       const struct dax_holder_operations *hops);
> +struct dax_device *inode_dax(struct inode *inode);
>  int dax_writeback_mapping_range(struct address_space *mapping,
>  		struct dax_device *dax_dev, struct writeback_control *wbc);
>  int dax_folio_reset_order(struct folio *folio);
> @@ -164,6 +164,15 @@ dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
>  void dax_unlock_mapping_entry(struct address_space *mapping,
>  		unsigned long index, dax_entry_t cookie);
>  #else
> +static inline void fs_put_dax(struct dax_device *dax_dev, void *holder)
> +{
> +}
> +
> +static inline int fs_dax_get(struct dax_device *dax_dev, void *holder,
> +			     const struct dax_holder_operations *hops)
> +{
> +	return -EOPNOTSUPP;
> +}
>  static inline struct page *dax_layout_busy_page(struct address_space *mapping)
>  {
>  	return NULL;

