Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BAD3451DA
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 22:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767996947; cv=none; b=Fl7stWxd+PSV+HqRBZl/VGL9dnywU/kig7vdAzo9I4lMC1YKoSOKYsBD+qUjJR0aqhfRx2SdBPpjEo9OJwL1Ty5hE9YgLHHK5BrLW34Q/HoVFMazWCkLYq8mQVlrlyOV8uxDu5v8eQnKFKTPIN2DyvTyI2nIfSKfKej1JxiiMgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767996947; c=relaxed/simple;
	bh=ItWZAUGEh6tnK87R9qTzUtVy5c9G5IfgZOB7PdDx76w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JxDyXWXe26Jdh2EdYueAmyx+Rt6fuVMc+bEaECF4gGpl4n86mB0s7wgE1Hss8XxU6p4vCNXn58Ti+kGUjWLYq2Dt1RBNaNclDt4eu965HhGhpmXtlDp9ex3seKikGuo5NOeDyeObXuClTzs+Esicvq/tjl8uObh1CJGVFgLDnJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NoYq4Xg/; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NoYq4Xg/"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-3f0d1a39cabso3264867fac.3
        for <nvdimm@lists.linux.dev>; Fri, 09 Jan 2026 14:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767996943; x=1768601743; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gsInap0TYjUJhuIYgyTfNATp9iw0wN/wAynfp2rVoTg=;
        b=NoYq4Xg/729IJ6xf6QsImwE8I568bUyKboNsntV63lZ+vUgwzYiTvyIJwNXHtFcalG
         ZPbok9cOnwhRzavDYoeE3NGT6XEXXn38URv2tQbp+cpZ21/SYRT5NW3FqB+SrROOdVZC
         HtyQujF4KIFJGkn+Z1lNz2/YSZui1or8o20rHOPq22hh4BXsBHnHwfNcrmlOq7B9npun
         Yg7g4VCfZCqOJ67Nw3BZuGT35sFyHK9lVLdHoglGiI/Cg9futLIFvOgNYYX2aW7anlV8
         3YLCcUxmgqTKmg7VHQxgNQsHLj+A9lEHoaFGslBDR7dgCpI+NnCzo6c/YESjZAN6sHCt
         xCKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767996943; x=1768601743;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gsInap0TYjUJhuIYgyTfNATp9iw0wN/wAynfp2rVoTg=;
        b=GNrny09pZStKFl+INEmqvLKHYpC7v5by9CXQLX6eq9l/pVEotTb7qVGDj+wpJk1Rv6
         LSUj1x8zN2FV0vpba8euYr3geNQMHH2A2d4bT0uFWsZ7qHPEAUW9La+U4V2MA7Qkk9k2
         YqDOvCOoFJrDq+EKZgmzoHWkXzzc18IK+GxGmUNqGcQ2pNpmBktyoswshpnaIaZQsccn
         YgV4w4UGqXolJ2+SWuZImtgnXM452ofSjRgXdmbcl0VoMSyE6yQ/QbGp7xdrCDTzLApJ
         UIUFJVUm1bEE3MBfX55AoZZdt/2IL6G0RLHjjBB1nNld4Zf11gAbHTyp633JT7Oedex4
         +19g==
X-Forwarded-Encrypted: i=1; AJvYcCWfX8kDSk0qoQ6Z9JaXUH4BUA94oovti9/Bi30uupXwTQftbk1TTbZ2IXi6Y7xatTr4/olIuB4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzUANx6N3z5jUMzK+nsL5Fzhzz4wFGptMC0GqtBCAfqf76W2cXd
	G80+r6Z9Ic5oY2dGvjumy9oqDJkJnqUVbVkn0PtySxNv6Rf9e/p3o5lY
X-Gm-Gg: AY/fxX5xTWNQC/hUosE80qIv6E8KC+NyPJBA7vuuIGdIaG+G9BFWmcaxmaSjjIGwWHb
	WYjKBtWoxn1PgwB33wTgfIR8SgtBeVjbG8ElClXUSKgr2KUlaglrnBmoFUjonoOtW6humoYi17z
	gCD+PvJqicKjgWEEAQSRWPx9hjyD8cXxGavgr7ydVdMVkWyvh1sXD3nM7YWWMziNC6nIfy5+qKA
	Fj1QLGmHURRjSU3XYZdSkPoI6ogYougs2KZkYQZF66LkaghoKa/mPLW76Y+dz4UH5xJ5whF9ef6
	+86WzyPOcQOQqreSKU74TpaP2lXS8J4mii+pUnindxuvB/mFjydDtL5JbN2oSxsnTpopVNZAywO
	EE7QhrnXjNNCGID5oO+seHmaMnKBxIZjP+IW8Ue2xexh5PowWxkFt4TSbSDISJZwfE/hhUIJ48X
	qVnI90nvbd5xJ+5AveXNG1JKNFwLuN5g==
X-Google-Smtp-Source: AGHT+IGeIXb/5HKhuPRt53VlHxR5e7TkKbTUESMzGZMkoiJYjOXEnJCEIvTH/DLOMpN4vbxz+vu/YA==
X-Received: by 2002:a05:6870:708c:b0:3ec:41eb:6e38 with SMTP id 586e51a60fabf-3ffc0b18aeemr5749038fac.38.1767996943253;
        Fri, 09 Jan 2026 14:15:43 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:184d:823f:1f40:e229])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4e3af4csm7798614fac.7.2026.01.09.14.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 14:15:42 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 9 Jan 2026 16:15:40 -0600
From: John Groves <John@groves.net>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V3 11/21] famfs_fuse: Update macro
 s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX
Message-ID: <mqfmngk6qjxhmxrbbpluzfbhhf2pkvzaintdiyy2kjy2ezgtnv@pascmnqloczj>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-12-john@groves.net>
 <CAJnrk1ZxmryZQJhvesJET12xK8Hemir0uk6wojTty0NDvu1Xng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1ZxmryZQJhvesJET12xK8Hemir0uk6wojTty0NDvu1Xng@mail.gmail.com>

On 26/01/09 10:16AM, Joanne Koong wrote:
> On Wed, Jan 7, 2026 at 7:34 AM John Groves <John@groves.net> wrote:
> >
> > Virtio_fs now needs to determine if an inode is DAX && not famfs.
> 
> nit: it was unclear to me why this patch changed the macro to take in
> a struct fuse_inode until I looked at patch 14. it might be useful
> here to add a line about that

Thanks Joanne; I beefed up the comment, and also added a dummy
fuse_file_famfs() macro so the new FUSE_IS_VIRTIO_DAX() macro shows
what it's gonna do. I should have done a better commit message...
Next rev will have a better one.

> 
> >
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/fuse/dir.c    |  2 +-
> >  fs/fuse/file.c   | 13 ++++++++-----
> >  fs/fuse/fuse_i.h |  6 +++++-
> >  fs/fuse/inode.c  |  4 ++--
> >  fs/fuse/iomode.c |  2 +-
> >  5 files changed, 17 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > index 4b6b3d2758ff..1400c9d733ba 100644
> > --- a/fs/fuse/dir.c
> > +++ b/fs/fuse/dir.c
> > @@ -2153,7 +2153,7 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> >                 is_truncate = true;
> >         }
> >
> > -       if (FUSE_IS_DAX(inode) && is_truncate) {
> > +       if (FUSE_IS_VIRTIO_DAX(fi) && is_truncate) {
> >                 filemap_invalidate_lock(mapping);
> >                 fault_blocked = true;
> >                 err = fuse_dax_break_layouts(inode, 0, -1);
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index 01bc894e9c2b..093569033ed1 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -252,7 +252,7 @@ static int fuse_open(struct inode *inode, struct file *file)
> >         int err;
> >         bool is_truncate = (file->f_flags & O_TRUNC) && fc->atomic_o_trunc;
> >         bool is_wb_truncate = is_truncate && fc->writeback_cache;
> > -       bool dax_truncate = is_truncate && FUSE_IS_DAX(inode);
> > +       bool dax_truncate = is_truncate && FUSE_IS_VIRTIO_DAX(fi);
> >
> >         if (fuse_is_bad(inode))
> >                 return -EIO;
> > @@ -1812,11 +1812,12 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
> >         struct file *file = iocb->ki_filp;
> >         struct fuse_file *ff = file->private_data;
> >         struct inode *inode = file_inode(file);
> > +       struct fuse_inode *fi = get_fuse_inode(inode);
> >
> >         if (fuse_is_bad(inode))
> >                 return -EIO;
> >
> > -       if (FUSE_IS_DAX(inode))
> > +       if (FUSE_IS_VIRTIO_DAX(fi))
> >                 return fuse_dax_read_iter(iocb, to);
> >
> >         /* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
> > @@ -1833,11 +1834,12 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >         struct file *file = iocb->ki_filp;
> >         struct fuse_file *ff = file->private_data;
> >         struct inode *inode = file_inode(file);
> > +       struct fuse_inode *fi = get_fuse_inode(inode);
> >
> >         if (fuse_is_bad(inode))
> >                 return -EIO;
> >
> > -       if (FUSE_IS_DAX(inode))
> > +       if (FUSE_IS_VIRTIO_DAX(fi))
> >                 return fuse_dax_write_iter(iocb, from);
> >
> >         /* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
> > @@ -2370,10 +2372,11 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
> >         struct fuse_file *ff = file->private_data;
> >         struct fuse_conn *fc = ff->fm->fc;
> >         struct inode *inode = file_inode(file);
> > +       struct fuse_inode *fi = get_fuse_inode(inode);
> >         int rc;
> >
> >         /* DAX mmap is superior to direct_io mmap */
> > -       if (FUSE_IS_DAX(inode))
> > +       if (FUSE_IS_VIRTIO_DAX(fi))
> >                 return fuse_dax_mmap(file, vma);
> >
> >         /*
> > @@ -2934,7 +2937,7 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
> >                 .mode = mode
> >         };
> >         int err;
> > -       bool block_faults = FUSE_IS_DAX(inode) &&
> > +       bool block_faults = FUSE_IS_VIRTIO_DAX(fi) &&
> >                 (!(mode & FALLOC_FL_KEEP_SIZE) ||
> >                  (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)));
> >
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 7f16049387d1..17736c0a6d2f 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -1508,7 +1508,11 @@ void fuse_free_conn(struct fuse_conn *fc);
> >
> >  /* dax.c */
> >
> > -#define FUSE_IS_DAX(inode) (IS_ENABLED(CONFIG_FUSE_DAX) && IS_DAX(inode))
> > +/* This macro is used by virtio_fs, but now it also needs to filter for
> > + * "not famfs"
> > + */
> 
> Did you mean to add this comment to "patch 14/21: famfs_fuse: Plumb
> the GET_FMAP message/response" instead? it seems like that's the patch
> that adds the "&& !fuse_file_famfs(fuse_inode))" part to this.

The idea I was going for is for this commit to substitute the new macro name
(FUSE_IS_VIRTIO_DAX()) without otherwise changing functionality - and then
to plumb the famfs test later. 

The revised version of this commit adds a dummy test (fuse_file_famfs(inode)), so
it's more apparent what this commit is trying to do. So I hope it will make
more sense ;)
> 
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> 
> Thanks,
> Joanne

Thanks Joanne!

John
