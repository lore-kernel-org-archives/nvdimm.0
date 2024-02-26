Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174D412AAF0
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 15:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708959639; cv=none; b=s4Ak7OywHAQNAttck1byFeYSeUzOnIlVrcgypj/HBXn+jf9vdWjHTy1sUEOwHPsaNNorpwvFghvOKcUv9hV0JB6JC0VUVan7IRIf0REJ6KbSknwjgFePLruhuLj3g0Vl5m5XaZWwIfy/FLl2hRSk6C2So6B7mh5xu6xD9MUo0tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708959639; c=relaxed/simple;
	bh=pDJ+S710TU3tYtsI7/uIBNbjN3ZFzSKvc9q9SE7JkjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hAxypBRHLMZmeILJPa35ne2ROSGMCJFsFB7WrM2uM9rJHDopxRkvn2dQPu1QfX+ckRmBg0gYx5kDbsmkHMhR51mCBYV2CLGtiLenlXzK/2d0HrcZdENfQrPTAnh8qoraRZ+Z7v7xPtBrfiqerjG8XZq3F5h/TpnkWBiBM6zUJZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZNPqoxxZ; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZNPqoxxZ"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3c1a1e1e539so1112420b6e.1
        for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 07:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708959636; x=1709564436; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H53FQFuV0tEvJqPL0XJbu4yTTLUCR5gSsoYwOTRibBQ=;
        b=ZNPqoxxZtISk7DlUycP9iMOL9O2uXGrCoIOF4BtMQlf/nNnueuWQ7/tLuUi/vs7FEw
         UvMNICeV5srSogm4R3nB8px2K0abJY5cYH5bXODBj2iVAhAkEbs5iDPoJjF/y05sgfVU
         lTAjy396cLL2Xq6QOsG274opAlkVD/WJJ2x7y594+K5vDdXB4edKdehucHlh/g6ECWn2
         yVk1TnaM0s44quIWffCroqLSwPDPQKX2suGlROR3d6BxWtp2Af1BiWhojCCaySpxU7Ph
         M1D9bxZnkP4JeWk10/CF2DGb91aY4yCzJO0+KYHBvRqDfqB1dVtS8vrtLQQV47vfE3t9
         KZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708959636; x=1709564436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H53FQFuV0tEvJqPL0XJbu4yTTLUCR5gSsoYwOTRibBQ=;
        b=mJyGDQaz/17GcQOr8df+x/uEsISq64eljGiShnoJcnEe57W/XHFk98Ab/Oe8nx/5rD
         kT+ncm54mjWZyt7TZdMeT8sBZEckhH9x43TxOhOW5UOdxfvASbl6z6teH992a9penaFs
         XbUpQq9aQGp2kDotlBjevtpxmn+cfW5BOK/PlGtMa03CNXe2p1gFYfarfYlej662S5NN
         UZFiYDazZkpHR7rWNsV7fj+arcVP037MO0RQ6vneCORJrWxy/L2Ec0KJuecPuWnd3uO3
         E03gsToJxD9LXr3lkPOMgIsxOGHMcbkY0CiNh9dKTMALhZYiCZzyrN03hQSsG0YxYE9k
         jEJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkWnGyzr0cJqZvMTwbJOkBVC0QcaDwgjIrBGRm/nZrPe8whpTUhOWgUllCfRkz7E37WhJ3nxiug4I6o+1lVpAnazHc98Hd
X-Gm-Message-State: AOJu0YyBF/EhTCPasam+by+i84LWBDYIGPNXRgoyQKT+a96/uHc3P84n
	+HfeO6FI6vAcbHmZcLPMKx3ZnrEW8G/KVTUj8BwBg5kiujFvx6Aq
X-Google-Smtp-Source: AGHT+IG3Fep9vB9m/AS0yL5tfec4E03KG7h5aS3ZZXhDql7c01JJ95Pj439VYSHJQzyLahhR1xXnIw==
X-Received: by 2002:a05:6808:10ce:b0:3c1:3215:1881 with SMTP id s14-20020a05680810ce00b003c132151881mr9820277ois.7.1708959635473;
        Mon, 26 Feb 2024 07:00:35 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id ca22-20020a056808331600b003c1a9ed75casm59821oib.18.2024.02.26.07.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 07:00:34 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 26 Feb 2024 09:00:31 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 02/20] dev_dax_iomap: Add fs_dax_get() func to
 prepare dax for fs-dax usage
Message-ID: <7t6n6c4cycu2hqh4ajsl4egtu2womq54unj4ikqeu3rehmxwzw@64ydmjh5x2ga>
References: <cover.1708709155.git.john@groves.net>
 <69ed4a3064bd9b48fd0593941038dd111fcfb8f3.1708709155.git.john@groves.net>
 <20240226120535.00007a36@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226120535.00007a36@Huawei.com>

On 24/02/26 12:05PM, Jonathan Cameron wrote:
> On Fri, 23 Feb 2024 11:41:46 -0600
> John Groves <John@Groves.net> wrote:
> 
> > This function should be called by fs-dax file systems after opening the
> > devdax device. This adds holder_operations.
> > 
> > This function serves the same role as fs_dax_get_by_bdev(), which dax
> > file systems call after opening the pmem block device.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> 
> A few trivial comments form a first read to get my head around this.
> 
> Yeah, it is only an RFC, but who doesn't like tidy code? :)

Hope your eyes don't burn too much ;)
> 
> 
> > ---
> >  drivers/dax/super.c | 38 ++++++++++++++++++++++++++++++++++++++
> >  include/linux/dax.h |  5 +++++
> >  2 files changed, 43 insertions(+)
> > 
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index f4b635526345..fc96362de237 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -121,6 +121,44 @@ void fs_put_dax(struct dax_device *dax_dev, void *holder)
> >  EXPORT_SYMBOL_GPL(fs_put_dax);
> >  #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
> >  
> > +#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
> > +
> > +/**
> > + * fs_dax_get()
> 
> Smells like kernel doc but fairly sure it needs a short description.
> Have you sanity checked for warnings when running scripts/kerneldoc on it?

Right, and there were other cases. Randy pointed one out, and I've already
gone through and "fixed" them.

> 
> > + *
> > + * fs-dax file systems call this function to prepare to use a devdax device for fsdax.
> Trivial but lines too long. Keep under 80 chars unless there is a strong
> readability arguement for not doing so.

I was under the impression the "kids these days" have a 100 column standard.
But I will go through and limit line to 80 except where it gets too awkward.

> 
> 
> > + * This is like fs_dax_get_by_bdev(), but the caller already has struct dev_dax (and there
> > + * is no bdev). The holder makes this exclusive.
> 
> Not familiar with this area: what does exclusive mean here?

The holder_ops are set via cmpxchg, in such a way that if there are already
holder_ops, the call to fs_dax_get() will fail. (as it should)

> 
> > + *
> > + * @dax_dev: dev to be prepared for fs-dax usage
> > + * @holder: filesystem or mapped device inside the dax_device
> > + * @hops: operations for the inner holder
> > + *
> > + * Returns: 0 on success, -1 on failure
> 
> Why not return < 0 and use somewhat useful return values?

Good idea, will do.

> 
> > + */
> > +int fs_dax_get(
> > +	struct dax_device *dax_dev,
> > +	void *holder,
> > +	const struct dax_holder_operations *hops)
> 
> Match local style for indents - it's a bit inconsistent but probably...
> 
> int fs_dax_get(struct dad_device *dev_dax, void *holder,
> 	       const struct dax_holder_operations *hops)

Done

> 
> > +{
> > +	/* dax_dev->ops should have been populated by devm_create_dev_dax() */
> > +	if (WARN_ON(!dax_dev->ops))
> > +		return -1;
> > +
> > +	if (!dax_dev || !dax_alive(dax_dev) || !igrab(&dax_dev->inode))
> 
> You dereferenced dax_dev on the line above so check is too late or
> unnecessary

Good catch, thank you!

> 
> > +		return -1;
> > +
> > +	if (cmpxchg(&dax_dev->holder_data, NULL, holder)) {
> > +		pr_warn("%s: holder_data already set\n", __func__);
> 
> Perhaps nicer to use a pr_fmt() deal with the func name if you need it.
> or make it pr_debug and let dynamic debug control formatting if anyone
> wants the function name.

Sounds good.

> 
> > +		return -1;
> > +	}
> > +	dax_dev->holder_ops = hops;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(fs_dax_get);
> > +#endif /* DEV_DAX_IOMAP */
> > +
> >  enum dax_device_flags {
> >  	/* !alive + rcu grace period == no new operations / mappings */
> >  	DAXDEV_ALIVE,
> > diff --git a/include/linux/dax.h b/include/linux/dax.h
> > index b463502b16e1..e973289bfde3 100644
> > --- a/include/linux/dax.h
> > +++ b/include/linux/dax.h
> > @@ -57,7 +57,12 @@ struct dax_holder_operations {
> >  
> >  #if IS_ENABLED(CONFIG_DAX)
> >  struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
> > +
> > +#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
> > +int fs_dax_get(struct dax_device *dax_dev, void *holder, const struct dax_holder_operations *hops);
> line wrap < 80 chars

Roger that

> 
> > +#endif
> >  void *dax_holder(struct dax_device *dax_dev);
> > +struct dax_device *inode_dax(struct inode *inode);
> 
> Unrelated change?

Kinda, but I'm not sure there is a better home for this one. Patch 18,
which is a famfs patch, calls inode_dax(). It was already exported but not
prototyped in dax.h.

Mixing it in with other dev_dax_iomap content seems better than mixing it
with famfs content. Could make it a separate patch, but I was trying to
some old docs that said keep patch sets <=15 - which I deemed impossible here.

What say others?

> 
> >  void put_dax(struct dax_device *dax_dev);
> >  void kill_dax(struct dax_device *dax_dev);
> >  void dax_write_cache(struct dax_device *dax_dev, bool wc);
> 

Thanks Jonathan!

