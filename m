Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB65429C35B
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 08:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619276; cv=none; b=E9fCWvRvgXYMLXZEMzHZGx5zW3P5KHbIrR52rVPRAGEll3cXah7rKODxPI+SbhMkgxTDMcHprfwIV2HXtfiXTLDApuJgx4jmw3A1aJ4gOVC6TheMU/2jU/fuBtKTDV0yTLPH8zVJNKI7kT5ewP46S7YH31BTZ9p9FQIwyrz9w6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619276; c=relaxed/simple;
	bh=ZSABudlhTKUDPWbW8XSdcuCu3VaJtavRmMqHjdpwlnQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WVR/D+x89SHQ6rjY1FKfM2O5VLXUMSIcBXMoMCqTDracqrJvwhn2M73Mv7pXJqicjjqIFv1RzEWPl34/5uQaWqq+MxfAkyVQuX/AqNRB/+BBVcrRHArKM2h/4VVq7hkbfRpsjcCcLwJXdBB6X2g0QcGvA/+M8fNMsBNUtg1cyLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AaRsRQFw; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AaRsRQFw"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ae3be3eabd8so148049266b.1
        for <nvdimm@lists.linux.dev>; Fri, 04 Jul 2025 01:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751619271; x=1752224071; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYYb4psIPvpliyRichfelE7dhl+X+oSKUx+ZDfgpqiU=;
        b=AaRsRQFwdFC3DzY4G3M7Fiz7IsD9IRdlrXwdXZbrOYS7Qc93Wzm+ZSje+3ZhSJWRf5
         Ji3SWM/No+NCHLqJ4Kzjc9Cw8wKg7L3IctARpo6H1llXNoA4RXPmK8ZZDVmobAqhjltU
         GVVqyT81WXIORmNUpYVErvZYrRPCGNsWVESs4oZaMWMcijytuV1jNi9g2EUzMCstAKa0
         gVdkyQZ09ifkSm0Pb+XZLUT2039b2UNmT/jBkm1WCMpmoNCTRaM/YJsTnHVdtRcJ1Hv5
         f4w8k5SiIb2DreoA05aXAtHtKM/L/M0SVK8Jrs68wAgEZfMTTC4/Rkxu/+aCF+b1MxOE
         xIvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751619271; x=1752224071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IYYb4psIPvpliyRichfelE7dhl+X+oSKUx+ZDfgpqiU=;
        b=cfq6CsOxms1ydZCQGTkE5GTXkTr9FaUZZDSOmEYAA0DAnMMnYzY8s3wl/qvd2v2+y3
         ER2sQ1W9j83/LFg3I5ADT7W5GgtXQGFKFw8nHlAAN2vjTzN8dzHTHyh0pWZJYhCRdzV1
         BHWsCCIQ66999LWFT0idszozYGImj/G1upbtw2scpxvXAGpCTozFPu3yRwYUpcUVU1s6
         XJ+52OOC26vXt29FNRQpSYwpEBuYQ5kxdMXp27yTdf3KygLBLO6oUNApvY6g/pO2/6qY
         vvRk1R8JtWd8kzj3ydUgvicMQHIgRYvV3OybMkVu5OKoOMMN4wuplt+3fAKLXfR8T6ap
         dI/w==
X-Forwarded-Encrypted: i=1; AJvYcCVUBAl/z01eepRSMUJ3HyxAsm+D5fhkXkDA+DhAU9YilsN0XkLH/NjXKXUiDlclE4TLtyAx9Ts=@lists.linux.dev
X-Gm-Message-State: AOJu0YxvRgOnnh7V83srDGmp0R3D6KyAvF9TfHQx/5vvAs34OONnWN0M
	dC4DDlnFIUpwQIMXs7eJ4hfl3EdWVY9fCCWTaPqhqDG0hPVX5aPSwbeL9QrgUX6RWRJG9bGcpTm
	0lPh+PhCfC8EQxCdCkgqtZjjTLNAmMRJp514JT58p7A==
X-Gm-Gg: ASbGncszPQKj6Apd3O6b2kRNHSSxYKRwbwVpA8HyIsO054x9fsg09yJT2OckFHUyjYJ
	Y2sDS2FSEE/oy1S+1JkRWnn0EEE5CsJ8tKan+kUPIP0/G3lXOfHHySr1RHmq5R0RllWKDARDrMG
	K8MysP1tsU4d55+NebTtPmnvU7rQrnuTGnDjdXZsA3LbQ=
X-Google-Smtp-Source: AGHT+IHcZMlcvKWkDRCTTYHYBlE/yVUzdpyQxoMzu23LPxRAf01JGJK4vdjZG8u8oHAxRui/6pv6vPPsfcA2UUkTzBY=
X-Received: by 2002:a17:907:9408:b0:ae3:bb0a:1ce9 with SMTP id
 a640c23a62f3a-ae3f9c07333mr186513866b.12.1751619270770; Fri, 04 Jul 2025
 01:54:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703185032.46568-1-john@groves.net> <20250703185032.46568-13-john@groves.net>
In-Reply-To: <20250703185032.46568-13-john@groves.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 4 Jul 2025 10:54:18 +0200
X-Gm-Features: Ac12FXxdD0dKmEKz1SXgkNvAKENkLT1knuiKkxdeBvqe6tEEHXxQtEYAzYhPTaA
Message-ID: <CAOQ4uxh-qDahaEpdn2Xs9Q7iBTT0Qx577RK-PrZwzOST_AQqUA@mail.gmail.com>
Subject: Re: [RFC V2 12/18] famfs_fuse: Plumb the GET_FMAP message/response
To: John Groves <John@groves.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Miklos Szeredi <miklos@szeredb.hu>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 3, 2025 at 8:51=E2=80=AFPM John Groves <John@groves.net> wrote:
>
> Upon completion of an OPEN, if we're in famfs-mode we do a GET_FMAP to
> retrieve and cache up the file-to-dax map in the kernel. If this
> succeeds, read/write/mmap are resolved direct-to-dax with no upcalls.
>
> GET_FMAP has a variable-size response payload, and the allocated size
> is sent in the in_args[0].size field. If the fmap would overflow the
> message, the fuse server sends a reply of size 'sizeof(uint32_t)' which
> specifies the size of the fmap message. Then the kernel can realloc a
> large enough buffer and try again.
>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/fuse/file.c            | 84 +++++++++++++++++++++++++++++++++++++++
>  fs/fuse/fuse_i.h          | 36 ++++++++++++++++-
>  fs/fuse/inode.c           | 19 +++++++--
>  fs/fuse/iomode.c          |  2 +-
>  include/uapi/linux/fuse.h | 18 +++++++++
>  5 files changed, 154 insertions(+), 5 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 93b82660f0c8..8616fb0a6d61 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -230,6 +230,77 @@ static void fuse_truncate_update_attr(struct inode *=
inode, struct file *file)
>         fuse_invalidate_attr_mask(inode, FUSE_STATX_MODSIZE);
>  }
>
> +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)

We generally try to avoid #ifdef blocks in c files
keep them mostly in h files and use in c files
   if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))

also #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
it a bit strange for a bool Kconfig because it looks too
much like the c code, so I prefer
#ifdef CONFIG_FUSE_FAMFS_DAX
when you have to use it

If you need entire functions compiled out, why not put them in famfs.c?

> +
> +#define FMAP_BUFSIZE 4096
> +
> +static int
> +fuse_get_fmap(struct fuse_mount *fm, struct inode *inode, u64 nodeid)
> +{
> +       struct fuse_get_fmap_in inarg =3D { 0 };
> +       size_t fmap_bufsize =3D FMAP_BUFSIZE;
> +       ssize_t fmap_size;
> +       int retries =3D 1;
> +       void *fmap_buf;
> +       int rc;
> +
> +       FUSE_ARGS(args);
> +
> +       fmap_buf =3D kcalloc(1, FMAP_BUFSIZE, GFP_KERNEL);
> +       if (!fmap_buf)
> +               return -EIO;
> +
> + retry_once:
> +       inarg.size =3D fmap_bufsize;
> +
> +       args.opcode =3D FUSE_GET_FMAP;
> +       args.nodeid =3D nodeid;
> +
> +       args.in_numargs =3D 1;
> +       args.in_args[0].size =3D sizeof(inarg);
> +       args.in_args[0].value =3D &inarg;
> +
> +       /* Variable-sized output buffer
> +        * this causes fuse_simple_request() to return the size of the
> +        * output payload
> +        */
> +       args.out_argvar =3D true;
> +       args.out_numargs =3D 1;
> +       args.out_args[0].size =3D fmap_bufsize;
> +       args.out_args[0].value =3D fmap_buf;
> +
> +       /* Send GET_FMAP command */
> +       rc =3D fuse_simple_request(fm, &args);
> +       if (rc < 0) {
> +               pr_err("%s: err=3D%d from fuse_simple_request()\n",
> +                      __func__, rc);
> +               return rc;
> +       }
> +       fmap_size =3D rc;
> +
> +       if (retries && fmap_size =3D=3D sizeof(uint32_t)) {
> +               /* fmap size exceeded fmap_bufsize;
> +                * actual fmap size returned in fmap_buf;
> +                * realloc and retry once
> +                */
> +               fmap_bufsize =3D *((uint32_t *)fmap_buf);
> +
> +               --retries;
> +               kfree(fmap_buf);
> +               fmap_buf =3D kcalloc(1, fmap_bufsize, GFP_KERNEL);
> +               if (!fmap_buf)
> +                       return -EIO;
> +
> +               goto retry_once;
> +       }
> +
> +       /* Will call famfs_file_init_dax() when that gets added */
> +
> +       kfree(fmap_buf);
> +       return 0;
> +}
> +#endif
> +
>  static int fuse_open(struct inode *inode, struct file *file)
>  {
>         struct fuse_mount *fm =3D get_fuse_mount(inode);
> @@ -263,6 +334,19 @@ static int fuse_open(struct inode *inode, struct fil=
e *file)
>
>         err =3D fuse_do_open(fm, get_node_id(inode), file, false);
>         if (!err) {
> +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> +               if (fm->fc->famfs_iomap) {

That should be
> +               if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
> +                   fm->fc->famfs_iomap) {

> +                       if (S_ISREG(inode->i_mode)) {
> +                               int rc;
> +                               /* Get the famfs fmap */
> +                               rc =3D fuse_get_fmap(fm, inode,
> +                                                  get_node_id(inode));
> +                               if (rc)
> +                                       pr_err("%s: fuse_get_fmap err=3D%=
d\n",
> +                                              __func__, rc);
> +                       }
> +               }
> +#endif
>                 ff =3D file->private_data;
>                 err =3D fuse_finish_open(inode, file);
>                 if (err)
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index f4ee61046578..e01d6e5c6e93 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -193,6 +193,10 @@ struct fuse_inode {
>         /** Reference to backing file in passthrough mode */
>         struct fuse_backing *fb;
>  #endif
> +
> +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> +       void *famfs_meta;
> +#endif
>  };
>
>  /** FUSE inode state bits */
> @@ -945,6 +949,8 @@ struct fuse_conn {
>  #endif
>
>  #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> +       struct rw_semaphore famfs_devlist_sem;
> +       struct famfs_dax_devlist *dax_devlist;
>         char *shadow;
>  #endif
>  };
> @@ -1435,11 +1441,14 @@ void fuse_free_conn(struct fuse_conn *fc);
>
>  /* dax.c */
>
> +static inline int fuse_file_famfs(struct fuse_inode *fi); /* forward */
> +
>  /* This macro is used by virtio_fs, but now it also needs to filter for
>   * "not famfs"
>   */
>  #define FUSE_IS_VIRTIO_DAX(fuse_inode) (IS_ENABLED(CONFIG_FUSE_DAX)    \
> -                                       && IS_DAX(&fuse_inode->inode))
> +                                       && IS_DAX(&fuse_inode->inode)   \
> +                                       && !fuse_file_famfs(fuse_inode))
>
>  ssize_t fuse_dax_read_iter(struct kiocb *iocb, struct iov_iter *to);
>  ssize_t fuse_dax_write_iter(struct kiocb *iocb, struct iov_iter *from);
> @@ -1550,4 +1559,29 @@ extern void fuse_sysctl_unregister(void);
>  #define fuse_sysctl_unregister()       do { } while (0)
>  #endif /* CONFIG_SYSCTL */
>
> +/* famfs.c */
> +static inline struct fuse_backing *famfs_meta_set(struct fuse_inode *fi,
> +                                                      void *meta)
> +{
> +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> +       return xchg(&fi->famfs_meta, meta);
> +#else
> +       return NULL;
> +#endif
> +}
> +
> +static inline void famfs_meta_free(struct fuse_inode *fi)
> +{
> +       /* Stub wil be connected in a subsequent commit */
> +}
> +
> +static inline int fuse_file_famfs(struct fuse_inode *fi)
> +{
> +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> +       return (READ_ONCE(fi->famfs_meta) !=3D NULL);
> +#else
> +       return 0;
> +#endif
> +}
> +
>  #endif /* _FS_FUSE_I_H */
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index a7e1cf8257b0..b071d16f7d04 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -117,6 +117,9 @@ static struct inode *fuse_alloc_inode(struct super_bl=
ock *sb)
>         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
>                 fuse_inode_backing_set(fi, NULL);
>
> +       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> +               famfs_meta_set(fi, NULL);
> +
>         return &fi->inode;
>
>  out_free_forget:
> @@ -138,6 +141,13 @@ static void fuse_free_inode(struct inode *inode)
>         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
>                 fuse_backing_put(fuse_inode_backing(fi));
>
> +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> +       if (S_ISREG(inode->i_mode) && fi->famfs_meta) {
> +               famfs_meta_free(fi);
> +               famfs_meta_set(fi, NULL);
> +       }
> +#endif
> +
>         kmem_cache_free(fuse_inode_cachep, fi);
>  }
>
> @@ -1002,6 +1012,9 @@ void fuse_conn_init(struct fuse_conn *fc, struct fu=
se_mount *fm,
>         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
>                 fuse_backing_files_init(fc);
>
> +       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> +               pr_notice("%s: Kernel is FUSE_FAMFS_DAX capable\n", __fun=
c__);
> +
>         INIT_LIST_HEAD(&fc->mounts);
>         list_add(&fm->fc_entry, &fc->mounts);
>         fm->fc =3D fc;
> @@ -1036,9 +1049,8 @@ void fuse_conn_put(struct fuse_conn *fc)
>                 }
>                 if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
>                         fuse_backing_files_free(fc);
> -#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> -               kfree(fc->shadow);
> -#endif
> +               if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> +                       kfree(fc->shadow);
>                 call_rcu(&fc->rcu, delayed_release);
>         }
>  }
> @@ -1425,6 +1437,7 @@ static void process_init_reply(struct fuse_mount *f=
m, struct fuse_args *args,
>                                  * those capabilities, they are held here=
).
>                                  */
>                                 fc->famfs_iomap =3D 1;
> +                               init_rwsem(&fc->famfs_devlist_sem);
>                         }
>                 } else {
>                         ra_pages =3D fc->max_read / PAGE_SIZE;
> diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
> index aec4aecb5d79..443b337b0c05 100644
> --- a/fs/fuse/iomode.c
> +++ b/fs/fuse/iomode.c
> @@ -204,7 +204,7 @@ int fuse_file_io_open(struct file *file, struct inode=
 *inode)
>          * io modes are not relevant with DAX and with server that does n=
ot
>          * implement open.
>          */
> -       if (FUSE_IS_VIRTIO_DAX(fi) || !ff->args)
> +       if (FUSE_IS_VIRTIO_DAX(fi) || fuse_file_famfs(fi) || !ff->args)
>                 return 0;

This is where fuse_is_dax() helper would be handy.

Thanks,
Amir.
