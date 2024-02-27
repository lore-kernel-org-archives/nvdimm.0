Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA613D965
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 18:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059100; cv=none; b=kbKjTKqWzLd2RJ4HONo2PJTLZcjWgnP+LxnlG31wkLF0kbcjafEVj3QLMRNZEok8NWrLYvV/dj1CxNsK/3O9zJoYMi3SOp78bhkGOQWXjfd14shxZKIuMVDe5KDGuJSUj//NYpPfU0Y2FiSsVOduWXv0OZj983Z4RSULinqSqYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059100; c=relaxed/simple;
	bh=KD1jGm7vKVoOgTdYtRTFbIEQwpq2vLQ0E1ZK54nuRxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O93fi03ewxo1hl3XMdsWfFnc8cXNeeKMrKgcynOg3nlw2QqZdFaxqNbIQou3iX749hXnPS5X+9thSFvmxOMMs4Lf3T7EQtLQOJkBj8lCc9ugv78Rs897WowQa3fBBMVlOnCAMDivThmhyvBQbWNW/wv3w902nEJdtE4oZczRrto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O7yJrWhh; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O7yJrWhh"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3c1a2f7e302so1118991b6e.0
        for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 10:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709059098; x=1709663898; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SACYrnqIZ8nbOqLr4JZuW46LtAQDPnmcG2NHqWDBIBI=;
        b=O7yJrWhhT5ue7bN1sIYMQX7ITbQCIOf4Jm+acpFwjacXVwf8LFxCxqZZln9rFksb/j
         UoTyhAyi2P4nujuI9jRHNJTAnCsL3tlq0ui8x3YJshzbQN+rRpdxZKY5RIj+K9dIBvHG
         ECnb1zVjobjbNYppM55AorL8GqJ6ZTQGerQVgtL7O9Y185UPa3vMFrowxGj7E2MNfViO
         zBCHrrgfRBzCkmV3qXYbYN5EGmqmiWmvrYrINfmJhH0Ohsadj7m0xHuxqbahbUzg1mtP
         9N7xGETK9It81nRJa/ygYP3HFeLqAlke+EHGMSIaBGHDHnVrS68fKi3f2JTtPoXtf4Qt
         CcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709059098; x=1709663898;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SACYrnqIZ8nbOqLr4JZuW46LtAQDPnmcG2NHqWDBIBI=;
        b=YdXLve+sTeZScCPb1X9JTNyD1NYCQTxNhxuBxcPzuM8Z377iDTdTaSNuvI8AFOeWCz
         gZmgvt82vnOMXqOs5qcrdUyRf/XpRsD6YLtF53YrNJABHTcBW+MDVubCF7bgLgDpgPEO
         sU7mfvQB9RAIsfMgn6kLaBvMFFhE7W224el/uKJKR7NBGiXyqOHzR7D60YxOaQ4MFyRT
         SOh1p1zNSH9mIlxHGJsPZ3f19kYu+GmHtxHvSh8ZMKKHvNpfMvXL3WmxIhphnRy0ZR2w
         aVUEFVIeIIQTrJNYa4yJyDan8ijqXjjp+LuOz0Ckh2nLWqP/p/VrM0GkHnUQ5StjVla0
         mRRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgpgAdnEvIePn8U1Xz1X9zAt9Efz8E1Ct6y5KhM2jGion56U1pDFsZgLoTWmQQxL3dKHs2igx2bcx/jK41qi/iytBOZRsq
X-Gm-Message-State: AOJu0Yykv2yydULO7i6ixxgfIrRLuoLlQh/EzpN69jMpT7jFIoTkaxFS
	deem/04qGKbdj07iTRuEPUw5Dg1nZAo7qlujnCfEVrs1127/CzwI
X-Google-Smtp-Source: AGHT+IGOvteQBz+IDBACbdnQn948atE6oRH0HpzbswyOJvZR99vuzL+t2zUWd+R6Im3I8SlzA+V40w==
X-Received: by 2002:a05:6808:8f3:b0:3c1:7d8d:29b9 with SMTP id d19-20020a05680808f300b003c17d8d29b9mr2670074oic.21.1709059098126;
        Tue, 27 Feb 2024 10:38:18 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id r12-20020a0568080aac00b003c15ac41417sm1522831oij.39.2024.02.27.10.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 10:38:17 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Tue, 27 Feb 2024 12:38:15 -0600
From: John Groves <John@groves.net>
To: Christian Brauner <brauner@kernel.org>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, john@jagalactic.com, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 10/20] famfs: famfs_open_device() &
 dax_holder_operations
Message-ID: <ups6cvjw6bx5m3hotn452brbbcgemnarsasre6ep2lbe4tpjsy@ezp6oh5c72ur>
References: <74359fdc83688fb1aac1cb2c336fbd725590a131.1708709155.git.john@groves.net>
 <20240227-aufhalten-funkspruch-91b2807d93a7@brauner>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227-aufhalten-funkspruch-91b2807d93a7@brauner>

On 24/02/27 02:39PM, Christian Brauner wrote:
> On Fri, Feb 23, 2024 at 11:41:54AM -0600, John Groves wrote:
> > Famfs works on both /dev/pmem and /dev/dax devices. This commit introduces
> > the function that opens a block (pmem) device and the struct
> > dax_holder_operations that are needed for that ABI.
> > 
> > In this commit, support for opening character /dev/dax is stubbed. A
> > later commit introduces this capability.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/famfs/famfs_inode.c | 83 ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 83 insertions(+)
> > 
> > diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> > index 3329aff000d1..82c861998093 100644
> > --- a/fs/famfs/famfs_inode.c
> > +++ b/fs/famfs/famfs_inode.c
> > @@ -68,5 +68,88 @@ static const struct super_operations famfs_ops = {
> >  	.show_options	= famfs_show_options,
> >  };
> >  
> > +/***************************************************************************************
> > + * dax_holder_operations for block dax
> > + */
> > +
> > +static int
> > +famfs_blk_dax_notify_failure(
> > +	struct dax_device	*dax_devp,
> > +	u64			offset,
> > +	u64			len,
> > +	int			mf_flags)
> > +{
> > +
> > +	pr_err("%s: dax_devp %llx offset %llx len %lld mf_flags %x\n",
> > +	       __func__, (u64)dax_devp, (u64)offset, (u64)len, mf_flags);
> > +	return -EOPNOTSUPP;
> > +}
> > +
> > +const struct dax_holder_operations famfs_blk_dax_holder_ops = {
> > +	.notify_failure		= famfs_blk_dax_notify_failure,
> > +};
> > +
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
> > +/**
> > + * famfs_open_device()
> > + *
> > + * Open the memory device. If it looks like /dev/dax, call famfs_open_char_device().
> > + * Otherwise try to open it as a block/pmem device.
> > + */
> > +static int
> > +famfs_open_device(
> 
> I'm confused why that function is added here but it's completely unclear
> in what wider context it's called. This is really hard to follow.

First, thank you for taking the time to do a thoughtful review.

I didn't factor this series correctly. The next one will be
"module-operations-up" unless you or somebody suggests a more sensible
approach.

Some background that might be useful: this work is really targeted for 
/dev/dax, but it started on /dev/pmem because the iomap interface wasn't 
working on /dev/dax. This patch addresses that (the dev_dax_iomap commits), 
although it's likely that code will evolve.

The current famfs code base tries to support both pmem (block) and /dev/dax 
(char), but I'm now thinking it should move to /dev/dax-only (no block 
support).

/dev/pmem devices can converted to /dev/dax mode anyway, so I'm not sure 
there is a reason to support both interfaces. (Need to think a bit more on 
that...).

> 
> > +	struct super_block *sb,
> > +	struct fs_context  *fc)
> > +{
> > +	struct famfs_fs_info *fsi = sb->s_fs_info;
> > +	struct dax_device    *dax_devp;
> > +	u64 start_off = 0;
> > +	struct bdev_handle   *handlep;
> > +
> > +	if (fsi->dax_devp) {
> > +		pr_err("%s: already mounted\n", __func__);
> > +		return -EALREADY;
> > +	}
> > +
> > +	if (strstr(fc->source, "/dev/dax")) /* There is probably a better way to check this */
> > +		return famfs_open_char_device(sb, fc);
> > +
> > +	if (!strstr(fc->source, "/dev/pmem")) { /* There is probably a better way to check this */
> 
> Yeah, this is not just a bit ugly but also likely wrong because:
> 
> sudo mount --bind /dev/pmem /opt/muhaha
> 
> fsconfig(fd_fs, FSCONFIG_SET_STRING, "source", "/opt/muhaha", [...])
> 
> or a simple mknod to create that device somewhere else. You likely want:
> 
> lookup_bdev(fc->source, &dev);
> 
> if (!DEVICE_NUMBER_SOMETHING_SOMETHING_SANE(dev))
> 	return invalfc(fc, "SOMETHING SOMETHING...
> 
> bdev_open_by_dev(dev, ....)
> 
> (This reminds me that I should get back to making it possible to specify
> "source" as a file descriptor instead of a mere string with the new
> mount api...)

All good points - sorry for the flakyness here.

I think the solution is to stop trying to support both pmem and dax. Then 
I don't need to distinguish between different device types.

> 
> > +		pr_err("%s: primary backing dev (%s) is not pmem\n",
> > +		       __func__, fc->source);
> > +		return -EINVAL;
> > +	}
> > +
> > +	handlep = bdev_open_by_path(fc->source, FAMFS_BLKDEV_MODE, fsi, &fs_holder_ops);
> 
> Hm, I suspected that FAMFS_BLKDEV_MODE would be wrong based on:
> https://lore.kernel.org/r/13556dbbd8d0f51bc31e3bdec796283fe85c6baf.1708709155.git.john@groves.net
> 
> It's defined as FMODE_READ | FMODE_WRITE which is wrong. But these
> helpers want BLOCK_OPEN_READ | BLOCK_OPEN_WRITE.

Dropping pmem/block support will also make this go away

> 
> > +	if (IS_ERR(handlep->bdev)) {
> 
> @bdev_handle will be gone as of v6.9 so you might want to wait until
> then to resend.

And this dependency will also disappear...

Thank you!!
John

