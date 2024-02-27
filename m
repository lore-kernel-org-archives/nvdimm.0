Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF436150994
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 22:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709072833; cv=none; b=vFU4OQxM/RdexX9Lqu1eH9Nr3HRl4WSl+WEwDUOo3tmO9jjwTgweQUjvnMP25FvElDhde4fzmsr+Kl9UZiDyonEP/S9XXPYb09kHTXL8vKG8TMkapkRaVDzgK0kc2G0wZQfk1rbZwx2e/y0oxTgEDf++OWqk+w2cvyv7PfYlZqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709072833; c=relaxed/simple;
	bh=DUwlnHLU8UMerEe2jsOFQdmLjtd1zzuOtaTj9wFrXi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0de5BFUdTgdOnlphLN/5vpnqdRV9ww45FTEKpf+bJzVpGYQRYE+5hJrilLQwPashKNqqfkBRhDr/3jaOjgrCasXDuxIv2q59H/vPZt81tOPoQ1Z0HVGFhuslM5n6Xf+uabEjiihYkyjj7JV7pXO0P5Cp8V4P25cpET2bo4BwbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YAlgrnji; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YAlgrnji"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-22007fe465bso1605871fac.1
        for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 14:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709072829; x=1709677629; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=czSfIwYqcAAlEOGZom62daR/kwIkMGAHkEzj8k6AIb8=;
        b=YAlgrnjioGsBL8D3H93DAQzRg9Z5xd1k6JL+oy6PzhYwFHyIL4+ueIOOdjBELckhKk
         mvEo2X2ZvKab7O6rFt1++HL4UkrIdyUgesCYrJr+INJRxZwGTOLbHmwlfU6z6ZxTQ+ZM
         A0fdDg9OoNPzVfU3MgI12DY1pZs0tK6NNLzabxtoekrCX6kJMT7lzwpbZazoJwsDRAEF
         6VtFLlo5y9CVxwRLtHryLs6ovBVAdHwGDz/zCSf0JcROrqSQrTMxF8C0EXYaqNjdQc61
         0bvMusTgsbAj3DqMAThQyQR7c3w++0J3UpkiOpwICHzzhXxJkZ+I0hY6cPBHPZ8jap4h
         Duug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709072829; x=1709677629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=czSfIwYqcAAlEOGZom62daR/kwIkMGAHkEzj8k6AIb8=;
        b=KG6F4fyLSoKy/LASbgqD2HSJmolDbpfcjR5Kfwd+ZqP3SGObsz/0fVZ0LIPqKvNXtL
         DshuM7vSAZyMrr0uzb2X2h1um9TsDgCRqOSTN2/Bq6c6ar28cnJiWdxG30x8yVU8MT66
         gN04rNZncCubdl7z2hh00DoE9bco1CYm6E+tedNFWJOOB9KBTM7DwbnyRvwe88bWOI3r
         HXpAWGFfZU4gvqSiCLP7832xKeM/mtCQc569f2VD5Rj32NgzH/GNgJs847GAqUtlZHYs
         GaUokHHGbDnEGSBWUQZp5VisvUOTIGsl0n1cqx937Xg489DOZVnYQdI+aVGlVCuw7t/p
         /+1A==
X-Forwarded-Encrypted: i=1; AJvYcCV8eudD+5UyA1miuXkftfGeG6mDDO5lARLLoIMM4jF7BmDQ8XG1e6ROT4hj1gX+QclPwVTNVwDQeW+qG1nEuFdzI7x/MPBd
X-Gm-Message-State: AOJu0YwRtqIuYf2OPG/SuMHoW9T1rvDVJf1jtV++zpOM7/Yjgvre4O50
	b2xE636UT2IUlQw7RedLiLsu2CxNkZ0be3tqkN49tIWCjRbp9MEh
X-Google-Smtp-Source: AGHT+IEKbYA01YSpW2OAyT0uYT5pzb31FUNW6KvOwjzPB90Y5misMgivhaltW4TUa9HNsFIdgb0pig==
X-Received: by 2002:a05:6870:e9a8:b0:220:971:ab2e with SMTP id r40-20020a056870e9a800b002200971ab2emr8197913oao.41.1709072828832;
        Tue, 27 Feb 2024 14:27:08 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id c2-20020a05687091c200b0021e88b471f2sm2236413oaf.26.2024.02.27.14.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 14:27:08 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Tue, 27 Feb 2024 16:27:06 -0600
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
Subject: Re: [RFC PATCH 18/20] famfs: Support character dax via the
 dev_dax_iomap patch
Message-ID: <iwcbiag4hrcbbpujd6xqatfq77oxdab7a7eeqbstg64u62edad@5bfru25qxz37>
References: <cover.1708709155.git.john@groves.net>
 <fa06095b6a05a26a0a016768b2e2b70663163eeb.1708709155.git.john@groves.net>
 <20240226135228.00007714@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226135228.00007714@Huawei.com>

On 24/02/26 01:52PM, Jonathan Cameron wrote:
> On Fri, 23 Feb 2024 11:42:02 -0600
> John Groves <John@Groves.net> wrote:
> 
> > This commit introduces the ability to open a character /dev/dax device
> > instead of a block /dev/pmem device. This rests on the dev_dax_iomap
> > patches earlier in this series.
> 
> Not sure the back reference is needed given it's in the series.

Roger that

> 
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/famfs/famfs_inode.c | 97 +++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 87 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> > index 0d659820e8ff..7d65ac497147 100644
> > --- a/fs/famfs/famfs_inode.c
> > +++ b/fs/famfs/famfs_inode.c
> > @@ -215,6 +215,93 @@ static const struct super_operations famfs_ops = {
> >  	.show_options	= famfs_show_options,
> >  };
> >  
> > +/*****************************************************************************/
> > +
> > +#if defined(CONFIG_DEV_DAX_IOMAP)
> > +
> > +/*
> > + * famfs dax_operations  (for char dax)
> > + */
> > +static int
> > +famfs_dax_notify_failure(struct dax_device *dax_dev, u64 offset,
> > +			u64 len, int mf_flags)
> > +{
> > +	pr_err("%s: offset %lld len %llu flags %x\n", __func__,
> > +	       offset, len, mf_flags);
> > +	return -EOPNOTSUPP;
> > +}
> > +
> > +static const struct dax_holder_operations famfs_dax_holder_ops = {
> > +	.notify_failure		= famfs_dax_notify_failure,
> > +};
> > +
> > +/*****************************************************************************/
> > +
> > +/**
> > + * famfs_open_char_device()
> > + *
> > + * Open a /dev/dax device. This only works in kernels with the dev_dax_iomap patch
> 
> That comment you definitely don't need as this won't get merged without
> that patch being in place.

This will be gone from v2. I'm 90% sure there is no reason to keep the block
device backing support (pmem), since devdax is the point AND pmem can be
converted to devdax mode. So famfs will become devdax only...etc.

This was under development for quite a few months, and actually working,
I got the dev_dax_iomap right (er, "right enough" for it to work :D). But now
that dev_dax_iomap looks basically stable, pmem/block support can come out.

> 
> 
> > + */
> > +static int
> > +famfs_open_char_device(
> > +	struct super_block *sb,
> > +	struct fs_context  *fc)
> > +{
> > +	struct famfs_fs_info *fsi = sb->s_fs_info;
> > +	struct dax_device    *dax_devp;
> > +	struct inode         *daxdev_inode;
> > +
> > +	int rc = 0;
> set in all paths where it's used.
> 
> > +
> > +	pr_notice("%s: Opening character dax device %s\n", __func__, fc->source);
> 
> pr_debug

Done

> 
> > +
> > +	fsi->dax_filp = filp_open(fc->source, O_RDWR, 0);
> > +	if (IS_ERR(fsi->dax_filp)) {
> > +		pr_err("%s: failed to open dax device %s\n",
> > +		       __func__, fc->source);
> > +		fsi->dax_filp = NULL;
> Better to use a local variable
> 
> 	fp = filp_open(fc->source, O_RDWR, 0);
> 	if (IS_ERR(fp)) {
> 		pr_err.
> 		return;
> 	}
> 	fsi->dax_filp = fp;
> or similar.

Done, thanks.

> 
> > +		return PTR_ERR(fsi->dax_filp);
> > +	}
> > +
> > +	daxdev_inode = file_inode(fsi->dax_filp);
> > +	dax_devp     = inode_dax(daxdev_inode);
> > +	if (IS_ERR(dax_devp)) {
> > +		pr_err("%s: unable to get daxdev from inode for %s\n",
> > +		       __func__, fc->source);
> > +		rc = -ENODEV;
> > +		goto char_err;
> > +	}
> > +
> > +	rc = fs_dax_get(dax_devp, fsi, &famfs_dax_holder_ops);
> > +	if (rc) {
> > +		pr_info("%s: err attaching famfs_dax_holder_ops\n", __func__);
> > +		goto char_err;
> > +	}
> > +
> > +	fsi->bdev_handle = NULL;
> > +	fsi->dax_devp = dax_devp;
> > +
> > +	return 0;
> > +
> > +char_err:
> > +	filp_close(fsi->dax_filp, NULL);
> 
> You carefully set fsi->dax_filp to null in other other error paths.
> Why there and not here?

Why indeed - done now.

> 
> > +	return rc;
> > +}
> > +
> > +#else /* CONFIG_DEV_DAX_IOMAP */
> > +static int
> > +famfs_open_char_device(
> > +	struct super_block *sb,
> > +	struct fs_context  *fc)
> > +{
> > +	pr_err("%s: Root device is %s, but your kernel does not support famfs on /dev/dax\n",
> > +	       __func__, fc->source);
> > +	return -ENODEV;
> > +}
> > +
> > +
> > +#endif /* CONFIG_DEV_DAX_IOMAP */
> > +
> >  /***************************************************************************************
> >   * dax_holder_operations for block dax
> >   */
> > @@ -236,16 +323,6 @@ const struct dax_holder_operations famfs_blk_dax_holder_ops = {
> >  	.notify_failure		= famfs_blk_dax_notify_failure,
> >  };
> >  
> 
> Put it in right place earlier! Makes this less noisy.

This will be eliminated by the move to /dev/dax-only

Thanks,
John

