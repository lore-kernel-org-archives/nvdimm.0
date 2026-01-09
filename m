Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFC027FB2F
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 02:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767924751; cv=none; b=reQSEnRhyU2vbm3D1iyKadKgAUxHA6nIRtWdnWNlfYuOSR3/llpvS2E19dt/MF5I/UWitUoyM2rGLLZw+FjrEdujeejyEcAr0rHGpGCgDyGY3gOzSHAXIe0dPjwdHHYVHzo4BJvJSAu5AHxXO0/YdJepAR6DmGg6AWLyP/t0i0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767924751; c=relaxed/simple;
	bh=Kv5afgrFaswkFB/JofSHfXQJjDup7xyugon/nrswLug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GfvPstjHNWbceMTV9+9+tR5CnQPKpo+7Gpp/2XWAnqd3kINVYskDFdQ4lx8qCsAYYbvvgjgFTljA3EyIsj0Ebj3vOpQ92oSnRI8XPIaK7LzyQcRphe+/leBZrb5TicXgyihjFn37UX8UFioVgQrJZNcKO7NT6GFN7fnDP6dwBKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ahLZbTm5; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ahLZbTm5"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-45090ef26c6so1400375b6e.2
        for <nvdimm@lists.linux.dev>; Thu, 08 Jan 2026 18:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767924742; x=1768529542; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=joznU88cqz27crMC+lX8vIj+1sa0vrTXaQ0+XLYGNXc=;
        b=ahLZbTm5IUxAdfwqD8EzA2AAQ75s5AegGTF8DROYxpShAHdKGPD7hiuojtArAG5ye4
         6hlhhmA5AwfR9WHhabvUdQrs3bZRRkJgn3k7u+lmjjXTD6Z0d38ggDZZdo1ZvlxanHpc
         fF2CruMCsT1ZbyDzzsxxuHXknVmIm/tVbn3VfNy6PdpKBOMqRF9XQYjQo+Rgygz/u6xw
         RzOdZOCLKvBv3NIuWBuAhMH4P5vmLh9G/g7uXXobIKSy4mo4v6fzD8iHsar9okDNjtoT
         9K7jRz5vNG9HygJStYk7Onfm1YAH4tAXRBLw4ATNHlVecdcU+m7ii+YxvXn4Mo7GH/hM
         q55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767924742; x=1768529542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=joznU88cqz27crMC+lX8vIj+1sa0vrTXaQ0+XLYGNXc=;
        b=alwdO+/YskCmE/wFx9BQBSFoLVItxOcKVVuf1xPiup/TQKBxsVkhfI+jMNytaBdqkH
         78DByVqn+tyGsFMJgL4edhY7u8UEtd6l3ASEdZy3qAKPve5s1+2BFge5HQqDxH4jwjRq
         bNQoA4qrU3HsvT3l3sr5asYN2geHvPJ/TEQt2Dun1hXQY+fB74OaQGnL7U2RCWBN2O9q
         nQUwgvu1vvjAuU2sTefZSpJ3XCkrelq1Od4cDzCUe+I4/Mqg+QmBoVdrEigwK/3YGAgJ
         /l2q444UiGqn7V8o9yK95B9mFzykxJ99t4AgR7kqvfFeNMOVgadY0uqEohe3uEeeZJRf
         yazg==
X-Forwarded-Encrypted: i=1; AJvYcCV5bym7Wt1RRoSw9oaMRly9cLGHUiAUxUipkxAqW6kvPpg4377ok2aLbPjYOuKW4ejQfn4VCxU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yydzbt5hMy3E0Wu+AnhPjRkblnLUQoMgTXffYONmC8+bEL2jg23
	LboIFygpij+CpyjmsSjEWbuaqaDzxf7FSUWr/SJ+beRIWSLdJ9+ltk/3
X-Gm-Gg: AY/fxX7aKTR7zDhbyhGh7aWpRdX4IsBPMhAU29JuVReOQk56kZ9FLbscdP3BdxqWX8e
	IbLPpTbAUQxmx2tCiFCA9YpDq/ryJwijEzP84v7JvrlP4Y+O4k09PitEVOt/o8W+m7m9G31UZGE
	+nJ27HvqQVZF0uZxHaneBzrSB/4b16wzv4E8JW1be43LF6QTyPuRxpuNM64YSpWRFM3SeyaI2wE
	QLqKyzfSXQ7ViM5JwRozfBgh9YG7OWY/akRYrVjQcfM4QfACwbEIjFsGXwzSaDJBnZIj7pLVQxt
	a14Fxg8WWQzUasPek6MtoQ2aAs0gg1URhV4uSV7lO5/Lr+lW4YJbjRpv4Yd0CPTrMl6+BvO1271
	/nXq+Np67iR8PiH0cOWbAKOrL4/NdlS5W+ORjcx0Za8eJmkX1p54vu176wBX57v/1IXwtDl+hij
	hKDQsEss0pz4O3W+CXuYbf+0W9quTWXL6/kgdmKEpw
X-Google-Smtp-Source: AGHT+IGYBJk8OIQjEdZM7RE78nO78sf0DfqkbSdJIlNgjxP4hXdS9RBTVkAdVP+l8SF00cVZqqeJEw==
X-Received: by 2002:a05:6808:23d6:b0:45a:78b:65e1 with SMTP id 5614622812f47-45a6bf113f2mr3395882b6e.48.1767924742171;
        Thu, 08 Jan 2026 18:12:22 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:184d:823f:1f40:e229])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2e8fb1sm4057261b6e.21.2026.01.08.18.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 18:12:21 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 8 Jan 2026 20:12:19 -0600
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
Subject: Re: [PATCH V3 14/21] famfs_fuse: Plumb the GET_FMAP message/response
Message-ID: <rlxxq64rtt6zxywgorii7oj5dhtzbzl2j7xdrlcjn4h32glo75@2r2f2tihd7l6>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-15-john@groves.net>
 <20260108124956.00000e0e@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108124956.00000e0e@huawei.com>

On 26/01/08 12:49PM, Jonathan Cameron wrote:
> On Wed,  7 Jan 2026 09:33:23 -0600
> John Groves <John@Groves.net> wrote:
> 
> > Upon completion of an OPEN, if we're in famfs-mode we do a GET_FMAP to
> > retrieve and cache up the file-to-dax map in the kernel. If this
> > succeeds, read/write/mmap are resolved direct-to-dax with no upcalls.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> A few things inline.
> 
> J
> 
> > diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> > new file mode 100644
> > index 000000000000..0f7e3f00e1e7
> > --- /dev/null
> > +++ b/fs/fuse/famfs.c
> > @@ -0,0 +1,74 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * famfs - dax file system for shared fabric-attached memory
> > + *
> > + * Copyright 2023-2025 Micron Technology, Inc.
> > + *
> > + * This file system, originally based on ramfs the dax support from xfs,
> > + * is intended to allow multiple host systems to mount a common file system
> > + * view of dax files that map to shared memory.
> > + */
> > +
> > +#include <linux/fs.h>
> > +#include <linux/mm.h>
> > +#include <linux/dax.h>
> > +#include <linux/iomap.h>
> > +#include <linux/path.h>
> > +#include <linux/namei.h>
> > +#include <linux/string.h>
> > +
> > +#include "fuse_i.h"
> > +
> > +
> > +#define FMAP_BUFSIZE PAGE_SIZE
> > +
> > +int
> > +fuse_get_fmap(struct fuse_mount *fm, struct inode *inode)
> > +{
> > +	struct fuse_inode *fi = get_fuse_inode(inode);
> > +	size_t fmap_bufsize = FMAP_BUFSIZE;
> > +	u64 nodeid = get_node_id(inode);
> > +	ssize_t fmap_size;
> > +	void *fmap_buf;
> > +	int rc;
> > +
> > +	FUSE_ARGS(args);
> > +
> > +	/* Don't retrieve if we already have the famfs metadata */
> > +	if (fi->famfs_meta)
> > +		return 0;
> > +
> > +	fmap_buf = kcalloc(1, FMAP_BUFSIZE, GFP_KERNEL);
> 
> If there is only ever 1, does kcalloc() make sense over kzalloc()?

Muscle memory? Good call, done.

> 
> > +	if (!fmap_buf)
> > +		return -EIO;
> > +
> > +	args.opcode = FUSE_GET_FMAP;
> > +	args.nodeid = nodeid;
> > +
> > +	/* Variable-sized output buffer
> > +	 * this causes fuse_simple_request() to return the size of the
> > +	 * output payload
> > +	 */
> > +	args.out_argvar = true;
> > +	args.out_numargs = 1;
> > +	args.out_args[0].size = fmap_bufsize;
> > +	args.out_args[0].value = fmap_buf;
> > +
> > +	/* Send GET_FMAP command */
> > +	rc = fuse_simple_request(fm, &args);
> > +	if (rc < 0) {
> > +		pr_err("%s: err=%d from fuse_simple_request()\n",
> > +		       __func__, rc);
> 
> Leaks the fmap_buf?  Maybe use a __free() so no need to keep track of htat.

Another good one - done.

> 
> 
> > +		return rc;
> > +	}
> > +	fmap_size = rc;
> > +
> > +	/* We retrieved the "fmap" (the file's map to memory), but
> > +	 * we haven't used it yet. A call to famfs_file_init_dax() will be added
> > +	 * here in a subsequent patch, when we add the ability to attach
> > +	 * fmaps to files.
> > +	 */
> > +
> > +	kfree(fmap_buf);
> > +	return 0;
> > +}
> 
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 84d0ee2a501d..691c7850cf4e 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -223,6 +223,14 @@ struct fuse_inode {
> 
> >  
> > +static inline struct fuse_backing *famfs_meta_set(struct fuse_inode *fi,
> > +						       void *meta)
> > +{
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +	return xchg(&fi->famfs_meta, meta);
> > +#else
> > +	return NULL;
> > +#endif
> > +}
> > +
> > +static inline void famfs_meta_free(struct fuse_inode *fi)
> > +{
> > +	/* Stub wil be connected in a subsequent commit */
> > +}
> > +
> > +static inline int fuse_file_famfs(struct fuse_inode *fi)
> > +{
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +	return (READ_ONCE(fi->famfs_meta) != NULL);
> > +#else
> > +	return 0;
> > +#endif
> > +}
> > +
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +int fuse_get_fmap(struct fuse_mount *fm, struct inode *inode);
> > +#else
> > +static inline int
> > +fuse_get_fmap(struct fuse_mount *fm, struct inode *inode)
> > +{
> > +	return 0;
> > +}
> > +#endif
> I'd do a single block under one if IS_ENABLED() and then use an else
> for the stubs.   Should end up more readable.

OK, this sounds good, but it's rebase hell (oh, the humanity! :D). Multiple 
additional commits flesh out this stuff, and for now I'm giving up on that
rebase. I tried the flip, but I don't have all night (tonight), so I'm 
leaving it alone. 

I'll happily clean this up after the series is complete.

Thanks!
John

