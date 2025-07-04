Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDF92E36F3
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 20:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751661022; cv=none; b=OEsSDwpJv/6/4uNFsnWR4iUWV9sQ1U8aYOpYXHFavPVJ5VXvkkRyzizKvTcmFYq0TDhhiT4aGb0xBzwMOt07hOs+nFItSQJGyPUcLrox8y6XV5I/QPj63vxhv7mkZ6jJQZ5wSOGRNiPzsv4Bgd93IKue0Lz46PyKY08xOjwtkyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751661022; c=relaxed/simple;
	bh=Zcg7C8etxkORbFbsODhyXuwacspx3JdsG1VeowoZE1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jy65xU93HG9O+GupimadkmC8pD+WFetZKM1mjFo7CNyKhv5koKGLNd2Fb7wxPQKmyuWkffCJRlh0mMhoAKL35SCsyz6s3YFef8ntSaBhEOvhEFq25OFdRPNiw0Sj4Ia4O9gCQuxA3IIOo4JVlgRh8Kxg5AhaDrUYRzzC+F1zGek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CtaKwEMy; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CtaKwEMy"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-2eb5cbe41e1so1057703fac.0
        for <nvdimm@lists.linux.dev>; Fri, 04 Jul 2025 13:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751661020; x=1752265820; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tPAin/IEdC/UkZIK4T5axHqc+EmdWgCWoXoVQPCK2u8=;
        b=CtaKwEMyM4EDr3nMdU5HP+2XqyLiu4Ammrk4yj3QkXzPPBJpJw3PVHeln3ex1CiyNq
         bFp8TRVEYTy+GQCadKo+/0iJ01mQLjRCk2cP75pJwKUlIpP9R10hUSfROfnmlEa7n7iz
         mdN+GKAyMivJ89iQIoyyUGwyrnZ6Q+nIu24wWzN9jJqu6RKZn1iw6l/cxq2bwcVETuSd
         6FHhwExn2GsP9P8PmSrmyeNQx7RIqFCn+A2dZb75al8+r42HVglvo0V19RSdYeccplyJ
         fAk/b8EHCppxi22Vysr7ZRAV6pyFdraxwFn/L3O0lj8iP0AiFyBnhwqiTel7bVPeX30z
         zIlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751661020; x=1752265820;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tPAin/IEdC/UkZIK4T5axHqc+EmdWgCWoXoVQPCK2u8=;
        b=dT9eN0j1N/I/UnP1I44t1c2rr7IF3ghYRnz7yB3/oINoWYldqdXYVAhve3AwAKXVkC
         Vkvu4saYIsbjqMl2KeqiqlcSHEXbvYwhkaoNtO7SQTu5KSc2iRlglNQ0aHSqHcYKX/7H
         ruQbbvDtjgJKYwMpWEd61fdLEZioXyvX4/Pvkt2wGr4RCISYwrIzdy5+uog+JypHghNd
         pG4pokFiX9AKBf0aYQMNHzwfDEOLM0yRSym6jYfjJWLwXJsZ7OMMwECWndUR58z4vRQN
         pzmENt4yqsi3Q17gidM41jfeWmJAqWiSeh4w+D4zM+kLE17ZN+RgEsSZtUz2aeA+lsKJ
         gP2A==
X-Forwarded-Encrypted: i=1; AJvYcCVTLWMPrJ7Bl6MtB1r+IytsvbEYdKZgSxLoj09KxCzMljidVYWz1cLplpXyIdOEsBPrsEYz+co=@lists.linux.dev
X-Gm-Message-State: AOJu0YzUpGE0mupHo+50ZsJkkOpg0eRDKZ/vsAmMEgXvmY/6gEcU4WdZ
	GSMIVE5LOQM/q+PSLoXbLeOOX1suVeE+LSHwGzN0CXjeJ/pvY/gbAJcs
X-Gm-Gg: ASbGncsf0ZyNRgi8hSX09xAyd42dLMHCxFh8gOgEuO9XhE+X+CrB+Fi93pkZLG0jPCq
	rOwxpS0qTQn7eN8j/GYFvs0MdlBTWYeq8IWRvmnjECVX62A69eyOPzE2AwdegGeWvVFu+WUIDQR
	tbAY6cK4WsU8LY8/KtL1GMoq9e7bGmcoN4budTM0JpfjasdWn8zQruSNb9xHxFQ2Q2V62yQvQ6R
	eS+En2AIfteq6NkNMhsqwkug43nW9LGtDslAXbSJ3oZ9EE15ynjUuM4SIZp6PshXV3KKlcc1Y50
	bqqxb5VZDeT0zAnc+Tx0aKDLaJ8BC/+/ljftwKptWrprX7Hpz4i4No3+DgoYWLV4H3TukGQ14p0
	M
X-Google-Smtp-Source: AGHT+IHfVo2RRJKpEjcwTkzhiyarVNyfoUap6wXD2grBzViICrcWEba2hT6pKOWdau3L/m8Ze/dQ/w==
X-Received: by 2002:a05:6870:797:b0:2c1:e9a3:3ab3 with SMTP id 586e51a60fabf-2f7b01a5bc7mr85101fac.33.1751661019493;
        Fri, 04 Jul 2025 13:30:19 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:ac65:f81e:baf2:f4b9])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2f78ff04660sm699194fac.6.2025.07.04.13.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 13:30:18 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 4 Jul 2025 15:30:16 -0500
From: John Groves <John@groves.net>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 12/18] famfs_fuse: Plumb the GET_FMAP message/response
Message-ID: <c73wbrsbijzlcfoptr4d6ryuf2mliectblna2hek5pxcuxfgla@7dbxympec26j>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-13-john@groves.net>
 <CAOQ4uxh-qDahaEpdn2Xs9Q7iBTT0Qx577RK-PrZwzOST_AQqUA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxh-qDahaEpdn2Xs9Q7iBTT0Qx577RK-PrZwzOST_AQqUA@mail.gmail.com>

On 25/07/04 10:54AM, Amir Goldstein wrote:
> On Thu, Jul 3, 2025 at 8:51 PM John Groves <John@groves.net> wrote:
> >
> > Upon completion of an OPEN, if we're in famfs-mode we do a GET_FMAP to
> > retrieve and cache up the file-to-dax map in the kernel. If this
> > succeeds, read/write/mmap are resolved direct-to-dax with no upcalls.
> >
> > GET_FMAP has a variable-size response payload, and the allocated size
> > is sent in the in_args[0].size field. If the fmap would overflow the
> > message, the fuse server sends a reply of size 'sizeof(uint32_t)' which
> > specifies the size of the fmap message. Then the kernel can realloc a
> > large enough buffer and try again.
> >
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/fuse/file.c            | 84 +++++++++++++++++++++++++++++++++++++++
> >  fs/fuse/fuse_i.h          | 36 ++++++++++++++++-
> >  fs/fuse/inode.c           | 19 +++++++--
> >  fs/fuse/iomode.c          |  2 +-
> >  include/uapi/linux/fuse.h | 18 +++++++++
> >  5 files changed, 154 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index 93b82660f0c8..8616fb0a6d61 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -230,6 +230,77 @@ static void fuse_truncate_update_attr(struct inode *inode, struct file *file)
> >         fuse_invalidate_attr_mask(inode, FUSE_STATX_MODSIZE);
> >  }
> >
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> 
> We generally try to avoid #ifdef blocks in c files
> keep them mostly in h files and use in c files
>    if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> 
> also #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> it a bit strange for a bool Kconfig because it looks too
> much like the c code, so I prefer
> #ifdef CONFIG_FUSE_FAMFS_DAX
> when you have to use it
> 
> If you need entire functions compiled out, why not put them in famfs.c?

Perhaps moving fuse_get_fmap() to famfs.c is the best approach. Will try that
first.

Regarding '#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)', vs.
'#ifdef CONFIG_FUSE_FAMFS_DAX' vs. '#if CONFIG_FUSE_FAMFS_DAX'...

I've learned to be cautious there because the latter two are undefined if
CONFIG_FUSE_FAMFS_DAX=m. I've been burned by this.

My original thinking was that famfs made sense as a module, but I'm leaning
the other way now - and in this series fs/fuse/Kconfig makes it a bool - 
meaning all three macro tests will work because a bool can't be set to 'm'. 

So to the extent that I need conditional compilation macros I can switch
to '#ifdef...'.


> 
> > +
> > +#define FMAP_BUFSIZE 4096
> > +
> > +static int
> > +fuse_get_fmap(struct fuse_mount *fm, struct inode *inode, u64 nodeid)
> > +{
> > +       struct fuse_get_fmap_in inarg = { 0 };
> > +       size_t fmap_bufsize = FMAP_BUFSIZE;
> > +       ssize_t fmap_size;
> > +       int retries = 1;
> > +       void *fmap_buf;
> > +       int rc;
> > +
> > +       FUSE_ARGS(args);
> > +
> > +       fmap_buf = kcalloc(1, FMAP_BUFSIZE, GFP_KERNEL);
> > +       if (!fmap_buf)
> > +               return -EIO;
> > +
> > + retry_once:
> > +       inarg.size = fmap_bufsize;
> > +
> > +       args.opcode = FUSE_GET_FMAP;
> > +       args.nodeid = nodeid;
> > +
> > +       args.in_numargs = 1;
> > +       args.in_args[0].size = sizeof(inarg);
> > +       args.in_args[0].value = &inarg;
> > +
> > +       /* Variable-sized output buffer
> > +        * this causes fuse_simple_request() to return the size of the
> > +        * output payload
> > +        */
> > +       args.out_argvar = true;
> > +       args.out_numargs = 1;
> > +       args.out_args[0].size = fmap_bufsize;
> > +       args.out_args[0].value = fmap_buf;
> > +
> > +       /* Send GET_FMAP command */
> > +       rc = fuse_simple_request(fm, &args);
> > +       if (rc < 0) {
> > +               pr_err("%s: err=%d from fuse_simple_request()\n",
> > +                      __func__, rc);
> > +               return rc;
> > +       }
> > +       fmap_size = rc;
> > +
> > +       if (retries && fmap_size == sizeof(uint32_t)) {
> > +               /* fmap size exceeded fmap_bufsize;
> > +                * actual fmap size returned in fmap_buf;
> > +                * realloc and retry once
> > +                */
> > +               fmap_bufsize = *((uint32_t *)fmap_buf);
> > +
> > +               --retries;
> > +               kfree(fmap_buf);
> > +               fmap_buf = kcalloc(1, fmap_bufsize, GFP_KERNEL);
> > +               if (!fmap_buf)
> > +                       return -EIO;
> > +
> > +               goto retry_once;
> > +       }
> > +
> > +       /* Will call famfs_file_init_dax() when that gets added */
> > +
> > +       kfree(fmap_buf);
> > +       return 0;
> > +}
> > +#endif
> > +
> >  static int fuse_open(struct inode *inode, struct file *file)
> >  {
> >         struct fuse_mount *fm = get_fuse_mount(inode);
> > @@ -263,6 +334,19 @@ static int fuse_open(struct inode *inode, struct file *file)
> >
> >         err = fuse_do_open(fm, get_node_id(inode), file, false);
> >         if (!err) {
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +               if (fm->fc->famfs_iomap) {
> 
> That should be
> > +               if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
> > +                   fm->fc->famfs_iomap) {
> 
> > +                       if (S_ISREG(inode->i_mode)) {
> > +                               int rc;
> > +                               /* Get the famfs fmap */
> > +                               rc = fuse_get_fmap(fm, inode,
> > +                                                  get_node_id(inode));
> > +                               if (rc)
> > +                                       pr_err("%s: fuse_get_fmap err=%d\n",
> > +                                              __func__, rc);
> > +                       }
> > +               }
> > +#endif
> >                 ff = file->private_data;
> >                 err = fuse_finish_open(inode, file);
> >                 if (err)
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index f4ee61046578..e01d6e5c6e93 100644
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
> > @@ -945,6 +949,8 @@ struct fuse_conn {
> >  #endif
> >
> >  #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       struct rw_semaphore famfs_devlist_sem;
> > +       struct famfs_dax_devlist *dax_devlist;
> >         char *shadow;
> >  #endif
> >  };
> > @@ -1435,11 +1441,14 @@ void fuse_free_conn(struct fuse_conn *fc);
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
> > @@ -1550,4 +1559,29 @@ extern void fuse_sysctl_unregister(void);
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
> > +       return (READ_ONCE(fi->famfs_meta) != NULL);
> > +#else
> > +       return 0;
> > +#endif
> > +}
> > +
> >  #endif /* _FS_FUSE_I_H */
> > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > index a7e1cf8257b0..b071d16f7d04 100644
> > --- a/fs/fuse/inode.c
> > +++ b/fs/fuse/inode.c
> > @@ -117,6 +117,9 @@ static struct inode *fuse_alloc_inode(struct super_block *sb)
> >         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> >                 fuse_inode_backing_set(fi, NULL);
> >
> > +       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> > +               famfs_meta_set(fi, NULL);
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
> > @@ -1002,6 +1012,9 @@ void fuse_conn_init(struct fuse_conn *fc, struct fuse_mount *fm,
> >         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> >                 fuse_backing_files_init(fc);
> >
> > +       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> > +               pr_notice("%s: Kernel is FUSE_FAMFS_DAX capable\n", __func__);
> > +
> >         INIT_LIST_HEAD(&fc->mounts);
> >         list_add(&fm->fc_entry, &fc->mounts);
> >         fm->fc = fc;
> > @@ -1036,9 +1049,8 @@ void fuse_conn_put(struct fuse_conn *fc)
> >                 }
> >                 if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> >                         fuse_backing_files_free(fc);
> > -#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > -               kfree(fc->shadow);
> > -#endif
> > +               if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> > +                       kfree(fc->shadow);
> >                 call_rcu(&fc->rcu, delayed_release);
> >         }
> >  }
> > @@ -1425,6 +1437,7 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
> >                                  * those capabilities, they are held here).
> >                                  */
> >                                 fc->famfs_iomap = 1;
> > +                               init_rwsem(&fc->famfs_devlist_sem);
> >                         }
> >                 } else {
> >                         ra_pages = fc->max_read / PAGE_SIZE;
> > diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
> > index aec4aecb5d79..443b337b0c05 100644
> > --- a/fs/fuse/iomode.c
> > +++ b/fs/fuse/iomode.c
> > @@ -204,7 +204,7 @@ int fuse_file_io_open(struct file *file, struct inode *inode)
> >          * io modes are not relevant with DAX and with server that does not
> >          * implement open.
> >          */
> > -       if (FUSE_IS_VIRTIO_DAX(fi) || !ff->args)
> > +       if (FUSE_IS_VIRTIO_DAX(fi) || fuse_file_famfs(fi) || !ff->args)
> >                 return 0;
> 
> This is where fuse_is_dax() helper would be handy.

Roger that. Thinking through it...

> 
> Thanks,
> Amir.

Thank you,
John

