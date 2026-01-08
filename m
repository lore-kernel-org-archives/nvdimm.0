Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D0E2DA769
	for <nvdimm@lists.linux.dev>; Thu,  8 Jan 2026 16:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767890746; cv=none; b=q10lyWAZ5Ni8rrmJl+Jdzzhtjs9W0DNnlsnhIW/iKgihSeSQWmm0s/v170p1h7vV+6aDpMoCt6aP6hsM4kJfyYPytewYug6FzYzPvQZKb0lbBu0tZnkV6zfz+YLl6OQ+E03LZk5G5MWCf3enJqTM1F7Fj0Fj1wYo1Uu+OKYmaGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767890746; c=relaxed/simple;
	bh=2IJIu49nVqGBoQe42aNWJnOAR4vdbhAJ7Wrm1X/fPT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zr6ONCi8W64S+V6a0saAuRzSJmEnI/h0NRPIWvBbqzGTXVU3VAUOm/JXOqQlUWHK3k7ftNnFF2QpFg7y2mmzVYx+zP9/zKcO7fitVjeGna0hwXQk1uHIO2fnm/vWzuo1ga0A4M8p7qCMC6FGwe4KflDpo3vk3CHZt6qNdoFkbno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZdYIU5YQ; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZdYIU5YQ"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7c75a5cb752so2468528a34.2
        for <nvdimm@lists.linux.dev>; Thu, 08 Jan 2026 08:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767890740; x=1768495540; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YcX6Nsb5jsPLQqNF+fUqFlMwldCLm2ep3AodwpvYvao=;
        b=ZdYIU5YQp+3lGZYK3+dUFsNpZbpdDY/IBBmuaoYIkP+E1qo7BSau2PDEDiCKYCVUxq
         sdJmGL2vmSa5fvG9fEIun/b2VJm4HpeyWYetpoYwPERRwZC/7BptudUMe6Wctrtnj7sD
         cMcoLM7IdZaMBeyUsNEhM28rqMbgMQdDz99VR46bJPFqeEGR4DS6Tz4Re9J7CKvd92Q2
         7jo+wYnIPEXlVjcfrLqDSICBrFBn+ICU6cTbDjlF76ngNTlTQ4vUC0ySNqbhe/16VGiM
         ZLJ1mmzkO8gJCcyb1HOQwyVFXd+jKJ5Ilz9GekRU+ympeodF+2HPYYJiSlLzNpzfTgA4
         UeMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767890740; x=1768495540;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YcX6Nsb5jsPLQqNF+fUqFlMwldCLm2ep3AodwpvYvao=;
        b=nPQC+TaORbdjHno99U8P3Y3G/uAB22weTl3oFFYnic+m0xxGczhpKeizQNhqdy5aIO
         wh7nr350gEwx9tetvujfADVa2zVCTQqFYDjTtH3ThFFb/3S5tHl/oIJHfURlTHYDHXgB
         kEQdcmv3WGed+UZh4txYwo1TRNx7StnYOcUHfESadZ9GjukXLhU5SuFBlpbpUCEKxCq9
         Gmsym9iZwYUeqcGVaKpagPSSH+Udz8s6NhG/ycq4WwiYw45bFIKRmIqLMfb0B+yG5Nlj
         XQfc0pQ8CpLtON/OSQOVRXlvdFyIiSfn1hkANpIwpPv0X5YfDE2qnA4CNRjZkdbGSOfZ
         L6wA==
X-Forwarded-Encrypted: i=1; AJvYcCUFbIis5L2PYLIBpnAGvNhhZLkJHkK4VkJf+sVXuMKf3ThUYhIx2boNLDZq+jrBx4n70e2pvjI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmaJQKzGUgrxtXIZ/mfevz5mkkdFJn7hEzpxfNU6aFEMYDDwhu
	frCki5y4VOVznMlF2skmMpVz6ozePxzVaTzL8poUi0qdEEU551ll8A2S
X-Gm-Gg: AY/fxX6+qh4ZELWOcbAU7pWgpeyukjd45ZJ6RhNs0Vs1+oc1xNvj6gshw5wfFc1vtHY
	c6kFHPonaO4kr9SSO+hoeO3RdB2E3MmHTKBhgZVo6K/nvE7xw/YDD854zh/ZxVbdprRv4+Jjaih
	tfKsyC/xq7+y4ws1zrAdSlI8A4LIsWBDqcng1S45xAbehFqfxYadeJ5/TwlpUClle7ty88TA7nD
	KXU0RHV9ndGB1YiL4hr8j+WN9hKZcW+eqiURLEZ9rQ1+mtTxHWi9a8+cLXtsNC+DG6qc5DgWSAC
	BXI9LIQG0QIZL72AxaViyeb5GcJCK2hjdPesWjXeEMEs0wACyLPiOA32g8ErZq71nefByKBWbtI
	uDKSIOAYZF/P4wSYYLAUM+JICoO9FTIVu9XrieRLqj43MgVvJI+7FhfxK/NKcdchRre07fTlftp
	OmmJmcXIk7aaXY72hRaV2stVi4VPh7Mw==
X-Google-Smtp-Source: AGHT+IGTUMnCiBC6iUnPHjbRq87vRaF81pdxH2sKruM8zWd2J2yHLKrwGBkVk06TI+Ws/ufWC2Ll+A==
X-Received: by 2002:a05:6830:230c:b0:7ca:ea23:f851 with SMTP id 46e09a7af769-7ce508ceb6cmr4713986a34.13.1767890739689;
        Thu, 08 Jan 2026 08:45:39 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:902b:954a:a912:b0f5])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478029a6sm5683506a34.3.2026.01.08.08.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 08:45:39 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 8 Jan 2026 10:45:37 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V3 06/21] dax: Add fs_dax_get() func to prepare dax for
 fs-dax usage
Message-ID: <d7blicnyehixccalrrmw4wschyngqkjt5jdleesjqcjtwcav4a@wblo3f53shkh>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-7-john@groves.net>
 <20260108122713.00007e54@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108122713.00007e54@huawei.com>

On 26/01/08 12:27PM, Jonathan Cameron wrote:
> On Wed,  7 Jan 2026 09:33:15 -0600
> John Groves <John@Groves.net> wrote:
> 
> > The fs_dax_get() function should be called by fs-dax file systems after
> > opening a fsdev dax device. This adds holder_operations, which provides
> > a memory failure callback path and effects exclusivity between callers
> > of fs_dax_get().
> > 
> > fs_dax_get() is specific to fsdev_dax, so it checks the driver type
> > (which required touching bus.[ch]). fs_dax_get() fails if fsdev_dax is
> > not bound to the memory.
> > 
> > This function serves the same role as fs_dax_get_by_bdev(), which dax
> > file systems call after opening the pmem block device.
> > 
> > This can't be located in fsdev.c because struct dax_device is opaque
> > there.
> > 
> > This will be called by fs/fuse/famfs.c in a subsequent commit.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> Hi John,
> 
> A few passing comments on this one.
> 
> Jonathan
> 
> > ---
> 
> >  #define dax_driver_register(driver) \
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index ba0b4cd18a77..68c45b918cff 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/fs.h>
> >  #include <linux/cacheinfo.h>
> >  #include "dax-private.h"
> > +#include "bus.h"
> >  
> >  /**
> >   * struct dax_device - anchor object for dax services
> > @@ -121,6 +122,59 @@ void fs_put_dax(struct dax_device *dax_dev, void *holder)
> >  EXPORT_SYMBOL_GPL(fs_put_dax);
> >  #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
> >  
> > +#if IS_ENABLED(CONFIG_DEV_DAX_FS)
> > +/**
> > + * fs_dax_get() - get ownership of a devdax via holder/holder_ops
> > + *
> > + * fs-dax file systems call this function to prepare to use a devdax device for
> > + * fsdax. This is like fs_dax_get_by_bdev(), but the caller already has struct
> > + * dev_dax (and there is no bdev). The holder makes this exclusive.
> > + *
> > + * @dax_dev: dev to be prepared for fs-dax usage
> > + * @holder: filesystem or mapped device inside the dax_device
> > + * @hops: operations for the inner holder
> > + *
> > + * Returns: 0 on success, <0 on failure
> > + */
> > +int fs_dax_get(struct dax_device *dax_dev, void *holder,
> > +	const struct dax_holder_operations *hops)
> > +{
> > +	struct dev_dax *dev_dax;
> > +	struct dax_device_driver *dax_drv;
> > +	int id;
> > +
> > +	id = dax_read_lock();
> 
> Given this is an srcu_read_lock under the hood you could do similar
> to the DEFINE_LOCK_GUARD_1 for the srcu (srcu.h) (though here it's a
> DEFINE_LOCK_GUARD_0 given the lock itself isn't a parameter and then
> use scoped_guard() here.  Might not be worth the hassle and would need
> a wrapper macro to poke &dax_srcu in which means exposing that at least
> a little in a header.
> 
> DEFINE_LOCK_GUARD_0(_T->idx = dax_read_lock, dax_read_lock(_T->idx), idx);
> Based loosely on the irqflags.h irqsave one. 

I'm getting more comfortable with scoped_guard(), but this feels like
a good leanup patch addressing all call sites of dax_read_lock() - after
the famfs dust settles.

If feelings are strong about this I'm open...

> 
> > +	if (!dax_dev || !dax_alive(dax_dev) || !igrab(&dax_dev->inode)) {
> > +		dax_read_unlock(id);
> > +		return -ENODEV;
> > +	}
> > +	dax_read_unlock(id);
> > +
> > +	/* Verify the device is bound to fsdev_dax driver */
> > +	dev_dax = dax_get_private(dax_dev);
> > +	if (!dev_dax || !dev_dax->dev.driver) {
> > +		iput(&dax_dev->inode);
> > +		return -ENODEV;
> > +	}
> > +
> > +	dax_drv = to_dax_drv(dev_dax->dev.driver);
> > +	if (dax_drv->type != DAXDRV_FSDEV_TYPE) {
> > +		iput(&dax_dev->inode);
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	if (cmpxchg(&dax_dev->holder_data, NULL, holder)) {
> > +		iput(&dax_dev->inode);
> > +		return -EBUSY;
> > +	}
> > +
> > +	dax_dev->holder_ops = hops;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(fs_dax_get);
> > +#endif /* DEV_DAX_FS */
> > +
> >  enum dax_device_flags {
> >  	/* !alive + rcu grace period == no new operations / mappings */
> >  	DAXDEV_ALIVE,
> > diff --git a/include/linux/dax.h b/include/linux/dax.h
> > index 3fcd8562b72b..76f2a75f3144 100644
> > --- a/include/linux/dax.h
> > +++ b/include/linux/dax.h
> > @@ -53,6 +53,7 @@ struct dax_holder_operations {
> >  struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
> >  
> >  #if IS_ENABLED(CONFIG_DEV_DAX_FS)
> > +int fs_dax_get(struct dax_device *dax_dev, void *holder, const struct dax_holder_operations *hops);
> I'd wrap this.  It's rather long and there isn't a huge readability benefit in keeping
> it on one line.

Done, thanks!

John

