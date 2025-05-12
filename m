Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED7D2505AC
	for <nvdimm@lists.linux.dev>; Mon, 12 May 2025 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747067296; cv=none; b=ZgE9if7NgGqAS4d1YVxFI6STgxrI0RKHnprLyUjqv8gYXWLWr8EGc5DGz4SJMBSPuYqSDASr26bv3AahXXHvA3gSA5Q/l33hSxLO57tJg6EV/I/FemApviwsTrEFxsx08ybM10kXC7dGqD3Ufwj97/1DaXe2eb5Fy2l5m5NzTZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747067296; c=relaxed/simple;
	bh=Jt9oZT6MxQ1c9CUyPBdh6LScXwRFEfayip1vATEJODY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H3OJwU3ENuTMf3nfhY6fuy5AY8RnF5RFoXHBdDytgSW1KZNrno0hW1Tnp63bxA2QcXuoLxJer4HdO6Z1AA6uSHzjFqeD07MKNHOn5nZGVDJ/jXETLNZT19f7BbdOAYhL621B7fJGjW+Fd6545gNYyY1ieTI+xKdKxkdz5xcrbFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U/QLE/F3; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U/QLE/F3"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6063462098eso2917453eaf.0
        for <nvdimm@lists.linux.dev>; Mon, 12 May 2025 09:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747067293; x=1747672093; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yfXYK2WWJp0fMh8eXP5pHHTLg42XHMgL/jeicNVe0gE=;
        b=U/QLE/F38+xxV1JJVUfPObpYPQxbSC7ej/otPh6xhqvI3bYwDmrAMK0EBGuBzxD+TY
         F8yw/sM/1VYax2dgAXPzCFAyWuh/cEC3JY/NJcZcwps5dq1N01GhZB8qYRHbgXVl3syd
         +iubrklG7oafCz5tbY3i20Sfs1HX6/OOZCgiIYBiCN4vpjN2nBK3X54tn4oBHpJhTrd8
         sd8jkdiHFBJeH8UoEp4cvpksUNY/Bg03uE8YXlaExYw7Q+kTe8Q41fglwFmgpkjomRiX
         YtQI2w26MHbDTKXZs+UVaGJKP7dgOKdMYcvNWioCEAA99RaMeCWAAQhn04daZJ0CbWns
         3eyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747067293; x=1747672093;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yfXYK2WWJp0fMh8eXP5pHHTLg42XHMgL/jeicNVe0gE=;
        b=sq9txGvoOtrE2HcaF79LjTQl5YYvcQoRsx01mOdYME9jxkJdQ8L2aQq2K95iVgNjTg
         vntraNglzZKYZuvEUPFFS4JhsCehGrnO+9d1x6NBfWpotQk23f9ThoB+KHX724TbAFQe
         bGZpCNFRxsk4TAJ0fepHqASLg4IJh8CIYrXucVJk6xpMYr8lxaLkSPsQAIhvy7rxbKh+
         cxlpLU8tbgJyfrrONpa8seabDVfGLNZD5s1QLLSAShnK3n38qWSCmSgalAHE1DBJfTSe
         3ntN/zwDrNXyxhHyD6IcJrm9p9cK1+W8Ep+cUxzyBRgkxICV5afvP6G6eaiuVSGeIZ0F
         1ZIg==
X-Forwarded-Encrypted: i=1; AJvYcCVKCuA6gdJkrOKdeY8+JUx78X79v84NG0Ztnb12Ksq8DIYjes68TaT5T263TpUMi/RTXwNBeaY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYXFFWh5toihvEFaC2rcgzDE3Qx+yqs/6jYeaJma9RXGmS/TFb
	UqKGO2jJUhybavZmZp4XJhkxLwzK6Y5iUNO8bOw+hLVWYcLNSsqX
X-Gm-Gg: ASbGncv7uZtmOQmgQ9J4rCPeYA1ZlFOEsSyY9fsl/nxACsjWaHxikouQ+2xR+baMQlr
	Ww8zgyNoFWgBheMmirYpBag4yp6lfTYB1uhLrFo5oPcO33jj3tmjZxukqXX41t5zat/hsO/lj/c
	bZG8OHixXq6N/OXSq+OI90WgQKtrRmp42voznF/yqFOSvtyEv5f9TOP0JWKvoYEv7kZXKEAJnv7
	Npi7mCQkwMqyEJVmeODUWy0MNZIKb2SDe5S3Bhl9akjkNLdogQomPB+m3y6kydxQETVSTwXAM7f
	Mr1Yka+FvAxtJIyZjuZtHxI4OHuHQUZQ69RhKui88TKdQfA7aabt/dK6Q1Dj1qkFBQ==
X-Google-Smtp-Source: AGHT+IEegXMkAWHU26748SkFBCyunApM/AHaeESZwvCaWTrrzbQhiaf7NFfNXS/WZE1r9TkuTiA14A==
X-Received: by 2002:a05:6808:1706:b0:403:3503:6a16 with SMTP id 5614622812f47-4037fde77f3mr9050099b6e.1.1747067292387;
        Mon, 12 May 2025 09:28:12 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:f16b:b065:d67a:e0f7])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-609a8cd7a4fsm985525eaf.10.2025.05.12.09.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 09:28:11 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 12 May 2025 11:28:09 -0500
From: John Groves <John@groves.net>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Luis Henriques <luis@igalia.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Petr Vorel <pvorel@suse.cz>, Brian Foster <bfoster@redhat.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC PATCH 12/19] famfs_fuse: Plumb the GET_FMAP message/response
Message-ID: <xhekfz652u3dla26aj4ge45zr4tk76b2jgkcb22jfo46gvf6ry@zze73cprkx6g>
References: <20250421013346.32530-1-john@groves.net>
 <20250421013346.32530-13-john@groves.net>
 <CAJnrk1ZRSoMN+jan5D9d3UYWnTVxc_5KVaBtP7JV2b+0skrBfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1ZRSoMN+jan5D9d3UYWnTVxc_5KVaBtP7JV2b+0skrBfg@mail.gmail.com>

On 25/05/01 10:48PM, Joanne Koong wrote:
> On Sun, Apr 20, 2025 at 6:34 PM John Groves <John@groves.net> wrote:
> >
> > Upon completion of a LOOKUP, if we're in famfs-mode we do a GET_FMAP to
> > retrieve and cache up the file-to-dax map in the kernel. If this
> > succeeds, read/write/mmap are resolved direct-to-dax with no upcalls.
> >
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/fuse/dir.c             | 69 +++++++++++++++++++++++++++++++++++++++
> >  fs/fuse/fuse_i.h          | 36 +++++++++++++++++++-
> >  fs/fuse/inode.c           | 15 +++++++++
> >  include/uapi/linux/fuse.h |  4 +++
> >  4 files changed, 123 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > index bc29db0117f4..ae135c55b9f6 100644
> > --- a/fs/fuse/dir.c
> > +++ b/fs/fuse/dir.c
> > @@ -359,6 +359,56 @@ bool fuse_invalid_attr(struct fuse_attr *attr)
> >         return !fuse_valid_type(attr->mode) || !fuse_valid_size(attr->size);
> >  }
> >
> > +#define FMAP_BUFSIZE 4096
> > +
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +static void
> > +fuse_get_fmap_init(
> > +       struct fuse_conn *fc,
> > +       struct fuse_args *args,
> > +       u64 nodeid,
> > +       void *outbuf,
> > +       size_t outbuf_size)
> > +{
> > +       memset(outbuf, 0, outbuf_size);
> 
> I think we can skip the memset here since kcalloc will zero out the
> memory automatically when the fmap_buf gets allocated

Good catch, thanks. Queued to -next.

> 
> > +       args->opcode = FUSE_GET_FMAP;
> > +       args->nodeid = nodeid;
> > +
> > +       args->in_numargs = 0;
> > +
> > +       args->out_numargs = 1;
> > +       args->out_args[0].size = FMAP_BUFSIZE;
> > +       args->out_args[0].value = outbuf;
> > +}
> > +
> > +static int
> > +fuse_get_fmap(struct fuse_mount *fm, struct inode *inode, u64 nodeid)
> > +{
> > +       size_t fmap_size;
> > +       void *fmap_buf;
> > +       int err;
> > +
> > +       pr_notice("%s: nodeid=%lld, inode=%llx\n", __func__,
> > +                 nodeid, (u64)inode);
> > +       fmap_buf = kcalloc(1, FMAP_BUFSIZE, GFP_KERNEL);
> > +       FUSE_ARGS(args);
> > +       fuse_get_fmap_init(fm->fc, &args, nodeid, fmap_buf, FMAP_BUFSIZE);
> > +
> > +       /* Send GET_FMAP command */
> > +       err = fuse_simple_request(fm, &args);
> 
> I'm assuming the fmap_buf gets freed in a later patch, but for this
> one we'll probably need a kfree(fmap_buf) here in the meantime?

Nice of you to give me the benefit of the doubt there ;)

At this commit, nothing is done with fmap_buf, and a subsequent
commit adds a call to famfs_file_init_dax(...fmap_buf...). But
the fmap_buf was leaked.

I'm adding a kfree(fmap_buf) to this commit, which will come after the
call to famfs_file_init_dax() when that's added in a subsequent
commit.

Thanks!

> 
> > +       if (err) {
> > +               pr_err("%s: err=%d from fuse_simple_request()\n",
> > +                      __func__, err);
> > +               return err;
> > +       }
> > +
> > +       fmap_size = args.out_args[0].size;
> > +       pr_notice("%s: nodei=%lld fmap_size=%ld\n", __func__, nodeid, fmap_size);
> > +
> > +       return 0;
> > +}
> > +#endif
> > +
> >  int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name,
> >                      struct fuse_entry_out *outarg, struct inode **inode)
> >  {
> > @@ -404,6 +454,25 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name
> >                 fuse_queue_forget(fm->fc, forget, outarg->nodeid, 1);
> >                 goto out;
> >         }
> > +
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       if (fm->fc->famfs_iomap) {
> > +               if (S_ISREG((*inode)->i_mode)) {
> > +                       /* Note Lookup returns the looked-up inode in the attr
> > +                        * struct, but not in outarg->nodeid !
> > +                        */
> > +                       pr_notice("%s: outarg: size=%d nodeid=%lld attr.ino=%lld\n",
> > +                                __func__, args.out_args[0].size, outarg->nodeid,
> > +                                outarg->attr.ino);
> > +                       /* Get the famfs fmap */
> > +                       fuse_get_fmap(fm, *inode, outarg->attr.ino);
> 
> I agree with Darrick's comment about fetching the mappings only if the
> file gets opened. I wonder though if we could bundle the open with the
> get_fmap so that we don't have to do an additional request / incur 2
> extra context switches. This seems feasible to me. When we send the
> open request, we could check if fc->famfs_iomap is set and if so, set
> inarg.open_flags to include FUSE_OPEN_GET_FMAP and set outarg.value to
> an allocated buffer that holds both struct fuse_open_out and the
> fmap_buf and adjust outarg.size accordingly. Then the server could
> send both the open and corresponding fmap data in the reply.

I agree about moving GET_FMAP to open, but I want to be cautious about 
moving it *into* open. Right now fitting an entire fmap into a single
message response looks like a totally acceptable requirement for famfs -
but it might not survive as a permanent requirement, and it seems likely 
not to work out for Darrick's use cases - which I think would lead us back 
to needing GET_FMAP.

Elswhere in this thread, and also 1:1, Darrick and I have discussed the
possibility of partial retrieval of fmaps (in part due to the possibility
that they might not always fit in a single message). If these responses 
can get arbitrarily large, this would become a requirement. GET_FMAP could 
specify an offset, and the reply could also specify its starting  offset; 
I think it has to be in both places because  the current "elegantly simple" 
fmap format doesn't always split easily at arbitrary offsets.

Also, with famfs I think fmaps can be retained in-kernel past close,
making the retrieval-on-open only needed if the fmap isn't already
present. Famfs doesn't currently allow fmaps to change, although there
are reasons we might relax that later.

This can be revisited down the road.

Unless I run into a blocker, the next rev of the series will call
GET_FMAP on open...

BTW I think moving GET_FMAP to open will remove the reasons why famfs
currently needs to avoid READDIRPLUS.

> 
> > +               } else
> > +                       pr_notice("%s: no get_fmap for non-regular file\n",
> > +                                __func__);
> > +       } else
> > +               pr_notice("%s: fc->dax_iomap is not set\n", __func__);
> > +#endif
> > +
> >         err = 0;
> >
> >   out_put_forget:
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 931613102d32..437177c2f092 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -193,6 +193,10 @@ struct fuse_inode {
> >         /** Reference to backing file in passthrough mode */
> >         struct fuse_backing *fb;
> >  #endif
> > +
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       void *famfs_meta;
> > +#endif
> >  };
> >
> >  /** FUSE inode state bits */
> > @@ -942,6 +946,8 @@ struct fuse_conn {
> >  #endif
> >
> >  #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       struct rw_semaphore famfs_devlist_sem;
> > +       struct famfs_dax_devlist *dax_devlist;
> >         char *shadow;
> >  #endif
> >  };
> > @@ -1432,11 +1438,14 @@ void fuse_free_conn(struct fuse_conn *fc);
> >
> >  /* dax.c */
> >
> > +static inline int fuse_file_famfs(struct fuse_inode *fi); /* forward */
> > +
> >  /* This macro is used by virtio_fs, but now it also needs to filter for
> >   * "not famfs"
> >   */
> >  #define FUSE_IS_VIRTIO_DAX(fuse_inode) (IS_ENABLED(CONFIG_FUSE_DAX)    \
> > -                                       && IS_DAX(&fuse_inode->inode))
> > +                                       && IS_DAX(&fuse_inode->inode)   \
> > +                                       && !fuse_file_famfs(fuse_inode))
> >
> >  ssize_t fuse_dax_read_iter(struct kiocb *iocb, struct iov_iter *to);
> >  ssize_t fuse_dax_write_iter(struct kiocb *iocb, struct iov_iter *from);
> > @@ -1547,4 +1556,29 @@ extern void fuse_sysctl_unregister(void);
> >  #define fuse_sysctl_unregister()       do { } while (0)
> >  #endif /* CONFIG_SYSCTL */
> >
> > +/* famfs.c */
> > +static inline struct fuse_backing *famfs_meta_set(struct fuse_inode *fi,
> > +                                                      void *meta)
> > +{
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       return xchg(&fi->famfs_meta, meta);
> > +#else
> > +       return NULL;
> > +#endif
> > +}
> > +
> > +static inline void famfs_meta_free(struct fuse_inode *fi)
> > +{
> > +       /* Stub wil be connected in a subsequent commit */
> > +}
> > +
> > +static inline int fuse_file_famfs(struct fuse_inode *fi)
> > +{
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       return (fi->famfs_meta != NULL);
> 
> Does this need to be "return READ_ONCE(fi->famfs_meta) != NULL"?

I'm not sure, but it can't hurt. Queued...

> 
> > +#else
> > +       return 0;
> > +#endif
> > +}
> > +
> >  #endif /* _FS_FUSE_I_H */
> > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > index 7f4b73e739cb..848c8818e6f7 100644
> > --- a/fs/fuse/inode.c
> > +++ b/fs/fuse/inode.c
> > @@ -117,6 +117,9 @@ static struct inode *fuse_alloc_inode(struct super_block *sb)
> >         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> >                 fuse_inode_backing_set(fi, NULL);
> >
> > +       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> > +               famfs_meta_set(fi, NULL);
> 
> "fi->famfs_meta = NULL;" looks simpler here

I toootally agree here, but I was following the passthrough pattern 
just above.  @miklos or @Amir, got a preference here?

Furthermore, initially I didn't init fi->famfs_meta at all because I 
*assumed* fi (the fuse_inode) would be zeroed upon allocation - but it's 
currently not. @miklos, would you object to zeroing fuse_inodes on 
allocation?  Clearly it's working without that, but it seems like a 
"normal" thing to do, that might someday pre-empt a problem.

> 
> > +
> >         return &fi->inode;
> >
> >  out_free_forget:
> > @@ -138,6 +141,13 @@ static void fuse_free_inode(struct inode *inode)
> >         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> >                 fuse_backing_put(fuse_inode_backing(fi));
> >
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       if (S_ISREG(inode->i_mode) && fi->famfs_meta) {
> > +               famfs_meta_free(fi);
> > +               famfs_meta_set(fi, NULL);
> > +       }
> > +#endif
> > +
> >         kmem_cache_free(fuse_inode_cachep, fi);
> >  }
> >
> > @@ -1002,6 +1012,11 @@ void fuse_conn_init(struct fuse_conn *fc, struct fuse_mount *fm,
> >         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> >                 fuse_backing_files_init(fc);
> >
> > +       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)) {
> > +               pr_notice("%s: Kernel is FUSE_FAMFS_DAX capable\n", __func__);
> > +               init_rwsem(&fc->famfs_devlist_sem);
> > +       }
> 
> Should we only init this if the server chooses to opt into famfs (eg
> if their init reply sets the FUSE_DAX_FMAP flag)? This imo seems to
> belong more in process_init_reply().

Another good catch. Queued - thanks!

> 
> 
> Thanks,
> Joanne

Thank you!

