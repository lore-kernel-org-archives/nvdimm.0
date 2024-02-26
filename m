Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171FF5FEF0
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 12:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708949142; cv=none; b=mm3Fz4dv1UKgM0joL3N4yLFQSLCXYf2ynu6VJTpzubGPWj8Lq6yYzlpTBW3Vk88ftYb3kAFof7FLn5bWSKdqfU6SKPIqoNPqT8UI+xKCXSrGA0TXwf2PO3gTV0Lu2UoA9j5w2CYedkkxd91dEP137IN70iCJs0zeEPEqv15nDRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708949142; c=relaxed/simple;
	bh=X6Bosa0A2A1es99TJJ26f3cbulaCTZndrqN6NEOItkU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+7e/6XYHSXoRgDbQfj2eLeZ4Asi37gGoEoVvAAyTy2OLM+glWLtUSTDOCRYRbtsHgm1D1f6ird3SB/0IRc8QRm5lM9CJ9BZD6ReZVjFd/D6Gn+oG4wlY47/iBfCUpUs3jIrlBWHQToCvPvtWzaZi9SQpbNmpTTcr7j6F/X+iZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TjzjC6Ckfz6JBM0;
	Mon, 26 Feb 2024 20:01:03 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 74AA21410C8;
	Mon, 26 Feb 2024 20:05:37 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Mon, 26 Feb
 2024 12:05:36 +0000
Date: Mon, 26 Feb 2024 12:05:35 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: John Groves <John@Groves.net>
CC: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Jan
 Kara" <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
	<linux-cxl@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <john@jagalactic.com>, Dave Chinner
	<david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
	<dave.hansen@linux.intel.com>, <gregory.price@memverge.com>
Subject: Re: [RFC PATCH 02/20] dev_dax_iomap: Add fs_dax_get() func to
 prepare dax for fs-dax usage
Message-ID: <20240226120535.00007a36@Huawei.com>
In-Reply-To: <69ed4a3064bd9b48fd0593941038dd111fcfb8f3.1708709155.git.john@groves.net>
References: <cover.1708709155.git.john@groves.net>
	<69ed4a3064bd9b48fd0593941038dd111fcfb8f3.1708709155.git.john@groves.net>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri, 23 Feb 2024 11:41:46 -0600
John Groves <John@Groves.net> wrote:

> This function should be called by fs-dax file systems after opening the
> devdax device. This adds holder_operations.
> 
> This function serves the same role as fs_dax_get_by_bdev(), which dax
> file systems call after opening the pmem block device.
> 
> Signed-off-by: John Groves <john@groves.net>

A few trivial comments form a first read to get my head around this.

Yeah, it is only an RFC, but who doesn't like tidy code? :)


> ---
>  drivers/dax/super.c | 38 ++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h |  5 +++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index f4b635526345..fc96362de237 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -121,6 +121,44 @@ void fs_put_dax(struct dax_device *dax_dev, void *holder)
>  EXPORT_SYMBOL_GPL(fs_put_dax);
>  #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
>  
> +#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
> +
> +/**
> + * fs_dax_get()

Smells like kernel doc but fairly sure it needs a short description.
Have you sanity checked for warnings when running scripts/kerneldoc on it?

> + *
> + * fs-dax file systems call this function to prepare to use a devdax device for fsdax.
Trivial but lines too long. Keep under 80 chars unless there is a strong
readability arguement for not doing so.


> + * This is like fs_dax_get_by_bdev(), but the caller already has struct dev_dax (and there
> + * is no bdev). The holder makes this exclusive.

Not familiar with this area: what does exclusive mean here?

> + *
> + * @dax_dev: dev to be prepared for fs-dax usage
> + * @holder: filesystem or mapped device inside the dax_device
> + * @hops: operations for the inner holder
> + *
> + * Returns: 0 on success, -1 on failure

Why not return < 0 and use somewhat useful return values?

> + */
> +int fs_dax_get(
> +	struct dax_device *dax_dev,
> +	void *holder,
> +	const struct dax_holder_operations *hops)

Match local style for indents - it's a bit inconsistent but probably...

int fs_dax_get(struct dad_device *dev_dax, void *holder,
	       const struct dax_holder_operations *hops)

> +{
> +	/* dax_dev->ops should have been populated by devm_create_dev_dax() */
> +	if (WARN_ON(!dax_dev->ops))
> +		return -1;
> +
> +	if (!dax_dev || !dax_alive(dax_dev) || !igrab(&dax_dev->inode))

You dereferenced dax_dev on the line above so check is too late or
unnecessary

> +		return -1;
> +
> +	if (cmpxchg(&dax_dev->holder_data, NULL, holder)) {
> +		pr_warn("%s: holder_data already set\n", __func__);

Perhaps nicer to use a pr_fmt() deal with the func name if you need it.
or make it pr_debug and let dynamic debug control formatting if anyone
wants the function name.

> +		return -1;
> +	}
> +	dax_dev->holder_ops = hops;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fs_dax_get);
> +#endif /* DEV_DAX_IOMAP */
> +
>  enum dax_device_flags {
>  	/* !alive + rcu grace period == no new operations / mappings */
>  	DAXDEV_ALIVE,
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index b463502b16e1..e973289bfde3 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -57,7 +57,12 @@ struct dax_holder_operations {
>  
>  #if IS_ENABLED(CONFIG_DAX)
>  struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
> +
> +#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
> +int fs_dax_get(struct dax_device *dax_dev, void *holder, const struct dax_holder_operations *hops);
line wrap < 80 chars

> +#endif
>  void *dax_holder(struct dax_device *dax_dev);
> +struct dax_device *inode_dax(struct inode *inode);

Unrelated change?

>  void put_dax(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);

