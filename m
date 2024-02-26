Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113041E878
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 22:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708988017; cv=none; b=jd3OSi9mh5oRI2L4euHDelDxW8YwQkcBehaSeDtBXooVxMRKxwNmWee740gQAZhQwNlg+dPKMYKnaVL3IoF4eBisT/f7OIrMgkF3O/6AsevxKetlYkLOlwF6I1TOHTI7O1eTif9COdsfstWeqrWjWqea6MkfzVlTlPGNN63A164=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708988017; c=relaxed/simple;
	bh=qc6/kWwCeJ2zBAC7vHmzTHh2RSqjWP/cx7+XqEMP8g8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jIdeyWI9Suuk+6WEo98Ybe/bBLn4S6cMPXbqqUm3boxleWSxCcRptHG4SYmDeuBQqSxMYUsheXxi4WBUyvHP3Mnm31C7VUGt0Ytmai55Sw6AzJ2U/v5iR6ya6ndfuWAlnCSiz8RXPxaKkH8jhqz7ELWRb6T+To257WQQtuyO4Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WVK4ifY7; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WVK4ifY7"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6e4881bccc9so1264650a34.2
        for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 14:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708988015; x=1709592815; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7zN0OR/mlolK5LRVInnaqgpRx22tp3sDJkLFymn99qk=;
        b=WVK4ifY7e4JHYbUGLQi2/ww2KQoaO2vypQ56c6W9YBD1wL0lzYRs1BxSqN/7S6SRTr
         v7isyncRuL4txoCAgkBAWIxfX0azJmqzl82b2SrSNb+1LxGLtKXoEPHDV70aRGPkukBy
         LAb9Ua170I35peYmd/9TIqVaNIvCXks6ByZ2N6XPJijkGgtFrsLr9rmNvwIaI1qc/a5Q
         Rob1gnefWkUbPd2d7bqbWgwJoVO0wAGzBmBX/xO2Ta53viuOT2EmMSDTqJ4nOJMDuoK4
         TjQ1x2stL+AJKU1C3+BScDeCWyEpRF43cJCDg21ADsGMXVoqECdzhmQVOjUXmPfS+sKX
         YrFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708988015; x=1709592815;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7zN0OR/mlolK5LRVInnaqgpRx22tp3sDJkLFymn99qk=;
        b=p/+ITtcrT3uScnsqN6buvd2DWpPlplwwGeKM0L4pTur7RdvONzE9OQX3/D6xvKe3Wb
         5kOOaTPzXvnV8SBPS9PV2nSyVhzPW6HdF575dP8/TY6U75TpWmeQpFXWftgL8MGMb1dy
         xW1XjWxC3Z0kOnaV4x9JiNbkDWpTtXNUFWXwFzEFPE76mbv6lxu6b1D1LDJkpeGppn9h
         ew+c99QGJwYN5x0QhN595WeBCCaBmNAQLXiuZDeNOOHvdurhblZKVGgPD2TwXLQwnvt5
         xqf9XcRKzJKyR+K4CJK5Sm0PCp9BuGzofjDC4y93UvpK5aWDU8pbN/1iWNH+OeyEbgcc
         vOzw==
X-Forwarded-Encrypted: i=1; AJvYcCVUg5EEhub5HW3NRb9HIfn5zhjzhqlDJx6erXSW6IHMg2Zbo5zLMIzZ1jswGM41Gb3psBELvzVzoHyc4vMs0pDLAJfl6ebi
X-Gm-Message-State: AOJu0YwjJJMla1TmzIXyZtK8BCX82zUvJD+z1r1yWL6B/UlOV08ygYzI
	7sGGDJ1/IoVnUb0e5UZHlCSduzfTy9MylSBYdwV3XUmMsByH/zWS
X-Google-Smtp-Source: AGHT+IGNiY0ss00qXAdNeXV/IX6WNTAo08NL3ZTs9+ivtKEpNIZyMkNtt5FwvTaf1qB7nMYJFpaJBQ==
X-Received: by 2002:a05:6830:14:b0:6e4:756a:4f5d with SMTP id c20-20020a056830001400b006e4756a4f5dmr8414227otp.32.1708988015161;
        Mon, 26 Feb 2024 14:53:35 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id x15-20020a056830114f00b006e4a33b1e00sm350600otq.53.2024.02.26.14.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 14:53:34 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 26 Feb 2024 16:53:33 -0600
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
Subject: Re: [RFC PATCH 12/20] famfs: Add inode_operations and
 file_system_type
Message-ID: <y2ps2uhwp46x73hnlqz6hjik34kmw7qc2gkzyfcccfnp2f23em@254i2r3wm4eh>
References: <cover.1708709155.git.john@groves.net>
 <bd2bbdd7523d1c74ca559d8912984e7facabe5c6.1708709155.git.john@groves.net>
 <20240226132538.00002656@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226132538.00002656@Huawei.com>

On 24/02/26 01:25PM, Jonathan Cameron wrote:
> On Fri, 23 Feb 2024 11:41:56 -0600
> John Groves <John@Groves.net> wrote:
> 
> > This commit introduces the famfs inode_operations. There is nothing really
> > unique to famfs here in the inode_operations..
> > 
> > This commit also introduces the famfs_file_system_type struct and the
> > famfs_kill_sb() function.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> 
> Trivial comments only.
> 
> > +
> > +/*
> > + * File creation. Allocate an inode, and we're done..
> > + */
> > +/* SMP-safe */
> > +static int
> > +famfs_mknod(
> > +	struct mnt_idmap *idmap,
> > +	struct inode     *dir,
> > +	struct dentry    *dentry,
> > +	umode_t           mode,
> > +	dev_t             dev)
> > +{
> > +	struct inode *inode = famfs_get_inode(dir->i_sb, dir, mode, dev);
> > +	int error           = -ENOSPC;
> > +
> > +	if (inode) {
> 
> As below. I would flip it for cleaner code/ shorter indent etc.

Nice - done.

> 
> > +		struct timespec64       tv;
> > +
> > +		d_instantiate(dentry, inode);
> > +		dget(dentry);	/* Extra count - pin the dentry in core */
> > +		error = 0;
> > +		tv = inode_set_ctime_current(inode);
> > +		inode_set_mtime_to_ts(inode, tv);
> > +		inode_set_atime_to_ts(inode, tv);
> > +	}
> > +	return error;
> > +}
> > +
> > +static int famfs_mkdir(
> > +	struct mnt_idmap *idmap,
> > +	struct inode     *dir,
> > +	struct dentry    *dentry,
> > +	umode_t           mode)
> > +{
> > +	int retval = famfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFDIR, 0);
> > +
> > +	if (!retval)
> > +		inc_nlink(dir);
> 
> Copy local style, so fine if this is common pattern, otherwise I'd go for
> consistent error cases out of line as easier for us sleepy caffeine 
> deprived reviewers.
> 
> 
> 	if (retval)
> 		return retval;
> 
> 	inc_nlink(dir);
> 
> 	return 0;

Agree, done.

> > +
> > +	return retval;
> > +}
> > +
> > +static int famfs_create(
> > +	struct mnt_idmap *idmap,
> > +	struct inode     *dir,
> > +	struct dentry    *dentry,
> > +	umode_t           mode,
> > +	bool              excl)
> > +{
> > +	return famfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFREG, 0);
> > +}
> > +
> > +static int famfs_symlink(
> > +	struct mnt_idmap *idmap,
> > +	struct inode     *dir,
> > +	struct dentry    *dentry,
> > +	const char       *symname)
> > +{
> > +	struct inode *inode;
> > +	int error = -ENOSPC;
> > +
> > +	inode = famfs_get_inode(dir->i_sb, dir, S_IFLNK | 0777, 0);
> 	if (!inode)
> 		return -ENOSPC;
> 
> > +	if (inode) {
> > +		int l = strlen(symname)+1;
> > +
> > +		error = page_symlink(inode, symname, l);
> 	if (error) {
> 		iput(inode);
> 		return error;
> 	}
> 	
> 	...
> 

Right, I like it. This was some tortured conditioning, which came from
somewhere. I deny responsibility :D

Thanks,
John

