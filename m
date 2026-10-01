Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F573BA236
	for <nvdimm@lists.linux.dev>; Thu,  1 Oct 2026 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790871114; cv=pass; b=J4+xgBWZ0Uqqitz6AO+mz1HytkAl1TL3cH6gSIT2WCCSgaq8vP1pYK/FBELQLFNEm1+l7L3uFhocj1s0MSeEMcOEoTUsiMMRqvKQgHY+p9zUD3SziCF6uRIVsJBwz3WZG1025QS/yo+pBmMXmWdHxF00ldgLAlUQX3bKQ3yrR3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790871114; c=relaxed/simple;
	bh=RnJD6eS8XhUNgQI87SaH7EPzqS3RH0xSFSay/AO7c30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G9sl3VnoGH55Aw4zjUTWAsd1mSngsGBqx0pJNYfOtiOKpKsmLABXYnzDuRC7MyN16iotcmxBb9h3xRny3ctl8ReWoRFn0gAvyay/IzBZOl1QoPSon3QmPlKcf6VJZkmflsk1D0g90Pb73bxgv0SjTvaRpxNCHO3IGRz3G0+yg0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QGw63zf0; arc=pass smtp.client-ip=74.125.228.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QGw63zf0"
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6aeeccb7d59so1327301a12.2
        for <nvdimm@lists.linux.dev>; Thu, 01 Oct 2026 09:11:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790871110; cv=none;
        d=google.com; s=arc-20260327;
        b=cWWKYvqDF5uG55gcdeT5tyuOiUE9qpxkc7l4C+F7gGA11XNrW9f9eBN7/PihsQQQV6
         rgnMysgwmzGDGe7upEDK+sxDpKjKLpsXhX9u9S2MLsrsSiswTOITgsnkbC5bZkwU9Nsd
         0fK8mc7YEfCsilVR4wKGKJt71oeC2PURqnV3kTl3sej/8ADBPAZBeqN+E4jaTcB76dku
         En5Vqh3iOw8Z1RDS53yjSVjuL+GxAnK+lOPlzm5pVh0r2sLWw1LvFgtPClcxaAB23O3h
         NTYib7/1d7CIHl0TjUXlYos/eXj9pEuyYCIsN7UvcGWRd+BjldeEafGVIFbQvjB5Pm6L
         bnoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t2krZwLIwYGJE5U3XdTQIjiXgKMvrnnRcjkpDn+DbLk=;
        fh=aFBsQv+oOoGxwBDFBK1QZAR/aC5S0YKSoftwGbnhlOA=;
        b=A2T4HrhnH3CQdmO3qbj7zxd4p4V4RNtJJ5uoSdANHkiojaVQ6aTdMdK6dcwYVbEUR7
         EPZOVVxhf+MZduybELEwvjrALdXceYslTntx3zilE9SM9l0XzrnQcT9wLSJphBe9G/zf
         cmoDEgDsF4aPWeFMcjloizohyKlXUeNOxUvDytH8GVZ3kYah84CcDOySxQbob8K1y3wm
         /ratW8T2FJVGYFoMh0rJkL4h06XN0AD5pnohKl/lctnaW3Ff8m1knry9bWzaWVB7KKQ6
         6qb3LzeOGDwS9FzCHI9B7I6pJh4mmdIWPqB/GF3ld8KVHBHy9EoVVFj1xAwz+HS3nBU4
         kg2Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790871110; x=1791475910; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t2krZwLIwYGJE5U3XdTQIjiXgKMvrnnRcjkpDn+DbLk=;
        b=QGw63zf0AX7s5DY3si6j2Nqy0tFN646K5dtDxOmesFhZRlNkNjUM3craU/ghmeIU0n
         jwmjNDSj5r2v4jbzWfVw+VzezMvjFukgcbKVS83enXq3Vkbai630tp2nUknJ0JBZnt+O
         lu0Al4Q8pNEJZRkl/KPA256Cc/jKpClNMQ9RRPRF5m+LiBXHBP49xs8zKMrMkq9cyUyg
         7Aanqb7UwdlnuWfCpGCyyTE6/e6DrPgfGSuFtmOc/hHTAbHqD3NPIGbb+8rcFked885E
         hRbi0PqmKcJFfC12n1maWZOD67+D1kQ2Zf0qi8O5rDd/rHW7Z596yG0mBX/oOP7E2Lxs
         J38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790871110; x=1791475910;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t2krZwLIwYGJE5U3XdTQIjiXgKMvrnnRcjkpDn+DbLk=;
        b=hXxGYkSFWTKU5Xx4iZ7jNU6YSa2uUyqYC7GtsfsbcxZSzWxtsjZ6V+p9PfIfDyID2O
         HpiV8iVJEGMuUH4KcGAMKOZWOyYgU8IL5dLqqFYowDqjokbuF3WMYyXB1VqpFelVAR06
         idsBFgt8qwpol8l7tKlkNRCRS7Avkx0xeHwWbXoVUPysKTyTVaRjtGnws0SRWPsEKeCZ
         kOeVtPKrnHXc4OnVliaR4Y9MKP00MVLU4eiZGnklE5ZYlQnJBgXHNuW8xnzyPfKsYalZ
         IqBv7f5cJL02c1h0lvfVP8JLrvLTXCwNOob1Bgb3u2uNqADy/fXk82Uft9tHf6hJVTak
         NrQA==
X-Forwarded-Encrypted: i=1; AKwUvBzxe9GQZ1egFxc1MTh7WzkMUwL6yHVIF+obS7xDmrHEFLZCOhbhDXeOD7imJwzq/uQF4gx6K+0=@lists.linux.dev
X-Gm-Message-State: AFq9FYKf4D0bdPwGuljGzWbVo2Fko3VUE8s53smIPvHh3elrckk23oug
	SlLLIB32Mc2ATPQA4Dc6OJYem3KEqxa43Z9bcxAQjRBzp+REBSKzbzkAZccrkdlaA56VaWvzpIt
	v3ay4ELn7VuhJiO97HemqWBdaR1NBirI=
X-Gm-Gg: AYBFou0QKwo49jIGNIXkIPBlhm7QfDQuL3Dph16gPd/+mQZLNHsFQ3iNPiD29MrPA3p
	0vGBFFDV9j2isIbw8uj7Cykw/UP9gAwvRihIjIeKSqOpti9+AFrxf2SZw6DS9xUzKn+BH1aALMm
	63ujMXN8LnLkHtTOKakNeit9KHVA60xDO3OXsTHcvnXtREUy4Cf79k+p+ab7Wc5gb8UyfDMSIB7
	R9gt25rYfoHrQgNoOwMn3WSPO9niCPpF4ZX8ojfu4cpEuVwYkqnXUn1IJ4oGpJmHUdOTsYU3hp9
	Sn4TyhNHAUJKjiUjJplD97eicmcjN08/y6sb/p2Q/LWbuNflkGN8ENmI
X-Received: by 2002:a05:6402:21c5:b0:6a7:ee56:6168 with SMTP id
 4fb4d7f45d1cf-6ae19956e9bmr3679037a12.42.1790871109734; Thu, 01 Oct 2026
 09:11:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001150935.655979-1-mszeredi@redhat.com> <20261001150935.655979-8-mszeredi@redhat.com>
In-Reply-To: <20261001150935.655979-8-mszeredi@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 1 Oct 2026 18:11:37 +0200
X-Gm-Features: AclHuK95hCeJqZ6ANKlcuwgyJOtdQ0wioPnTHpC-CdtBy7ar_Jy4pzw2G-Arouw
Message-ID: <CAOQ4uxj=PKC1MDDLLejtY+m2CcZStDkwuTCcbt-ft+h0gLdO6Q@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] fuse: add extent map I/O support
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: fuse-devel@lists.linux.dev, John Groves <john@groves.net>, 
	"Darrick J . Wong" <djwong@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 1, 2026 at 5:09=E2=80=AFPM Miklos Szeredi <mszeredi@redhat.com>=
 wrote:
>
> Wire up read, write, splice and mmap operations for extent-mapped
> files through the iomap/DAX infrastructure.
>
> When a passthrough file is opened with an EXTMAP backing, I/O is
> dispatched to the dax devices referenced by the extent map.
>
> If an address is not mapped, EIO is returned on the I/O operation.
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/fuse/backing.c     |  15 +++++
>  fs/fuse/ext_map.c     | 149 ++++++++++++++++++++++++++++++++++++++++++
>  fs/fuse/fuse_i.h      |   4 ++
>  fs/fuse/notify.c      |   3 +
>  fs/fuse/passthrough.c |  29 ++++++--
>  5 files changed, 194 insertions(+), 6 deletions(-)
>
> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index e954391d696d..2708f140b94f 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
> @@ -278,6 +278,21 @@ int fuse_backing_close(struct fuse_conn *fc, int bac=
king_id)
>         return err;
>  }
>
> +bool fuse_backing_is_dax(struct fuse_backing *fb)
> +{
> +       switch (fb->type) {
> +       case FUSE_BACKING_PATH:
> +               return false;
> +       case FUSE_BACKING_DAXDEV:
> +               return true;
> +       case FUSE_BACKING_EXTMAP:
> +               return fuse_ext_map_is_dax(fb);
> +       default:
> +               WARN_ON(1);
> +               return false;
> +       }
> +}
> +
>  struct fuse_backing *fuse_backing_lookup(struct fuse_conn *fc, u64 backi=
ng_id)
>  {
>         struct fuse_backing *fb;
> diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
> index ab01d678d08e..61cb22e821b6 100644
> --- a/fs/fuse/ext_map.c
> +++ b/fs/fuse/ext_map.c
> @@ -3,6 +3,8 @@
>  #include "fuse_i.h"
>  #include <linux/rbtree.h>
>  #include <linux/pagemap.h>
> +#include <linux/iomap.h>
> +#include <linux/dax.h>
>
>  struct fuse_iext {
>         struct rb_node rb;
> @@ -22,6 +24,24 @@ void fuse_ext_map_destroy(struct rb_root *extents)
>         }
>  }
>
> +static struct fuse_iext *fuse_find_extent(struct rb_root *extents, u64 o=
ffset)
> +{
> +       struct rb_node *node =3D extents->rb_node;
> +
> +       while (node) {
> +               struct fuse_iext *fie =3D rb_entry(node, typeof(*fie), rb=
);
> +
> +               if (offset < fie->start)
> +                       node =3D node->rb_left;
> +               else if (offset >=3D fie->end)
> +                       node =3D node->rb_right;
> +               else
> +                       return fie;
> +       }
> +
> +       return NULL;
> +}
> +
>  static int fuse_add_extent(struct fuse_conn *fc, struct rb_root *extents=
,
>                            struct fuse_extent *ext)
>  {
> @@ -76,6 +96,135 @@ static int fuse_add_extent(struct fuse_conn *fc, stru=
ct rb_root *extents,
>         return 0;
>  }
>
> +static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, =
loff_t length,
> +                                   unsigned int flags, struct iomap *iom=
ap, struct iomap *srcmap)
> +{
> +       struct fuse_backing *fb =3D fuse_inode_backing(get_fuse_inode(ino=
de));
> +       struct fuse_iext *fie;
> +       loff_t ext_len;
> +
> +       if (!fb || fb->type !=3D FUSE_BACKING_EXTMAP)
> +               return fuse_EIO("missing or wrong type backing");
> +
> +       fie =3D fuse_find_extent(&fb->extents, offset);
> +       if (!fie)
> +               return fuse_EIO("missing mapping");
> +
> +       if (WARN_ON(fie->backing->type !=3D FUSE_BACKING_DAXDEV))
> +               return fuse_EIO("wrong type backing for extent");
> +
> +       if (fie->backing->dax_error) {
> +               fuse_make_bad(inode);
> +               return fuse_EIO("dax error");
> +       }
> +
> +       ext_len =3D fie->end - fie->start;
> +
> +       iomap->offset =3D fie->start;
> +       iomap->addr =3D fie->backing_offset;
> +       iomap->length =3D ext_len;
> +       iomap->dax_dev =3D fie->backing->dax_dev;
> +       iomap->type =3D IOMAP_MAPPED;
> +       iomap->flags =3D 0;
> +
> +       return 0;
> +}
> +
> +static const struct iomap_ops fuse_ext_map_iomap_ops =3D {
> +       .iomap_begin            =3D fuse_ext_map_iomap_begin,
> +};
> +
> +static vm_fault_t fuse_ext_map_huge_fault(struct vm_fault *vmf, unsigned=
 int order)
> +{
> +       struct inode *inode =3D file_inode(vmf->vma->vm_file);
> +       bool write_fault =3D (vmf->flags & FAULT_FLAG_WRITE) && (vmf->vma=
->vm_flags & VM_SHARED);
> +       vm_fault_t ret;
> +       unsigned long pfn;
> +
> +       if (WARN_ON_ONCE(!IS_DAX(inode)))
> +               return VM_FAULT_SIGBUS;
> +
> +       if (write_fault) {
> +               sb_start_pagefault(inode->i_sb);
> +               file_update_time(vmf->vma->vm_file);
> +       }
> +
> +       filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +       ret =3D dax_iomap_fault(vmf, order, &pfn, NULL, &fuse_ext_map_iom=
ap_ops);
> +       if (ret & VM_FAULT_NEEDDSYNC)
> +               ret =3D dax_finish_sync_fault(vmf, order, pfn);
> +
> +       filemap_invalidate_unlock_shared(inode->i_mapping);
> +
> +       if (write_fault)
> +               sb_end_pagefault(inode->i_sb);
> +
> +       return ret;
> +}
> +
> +static vm_fault_t fuse_ext_map_fault(struct vm_fault *vmf)
> +{
> +       return fuse_ext_map_huge_fault(vmf, 0);
> +}
> +
> +static const struct vm_operations_struct fuse_ext_map_vm_ops =3D {
> +       .fault          =3D fuse_ext_map_fault,
> +       .huge_fault     =3D fuse_ext_map_huge_fault,
> +       .page_mkwrite   =3D fuse_ext_map_fault,
> +       .pfn_mkwrite    =3D fuse_ext_map_fault,
> +};
> +
> +static void fuse_rw_clamp(struct kiocb *iocb, struct iov_iter *ubuf)
> +{
> +       struct inode *inode =3D iocb->ki_filp->f_mapping->host;
> +       loff_t i_size =3D i_size_read(inode);
> +       loff_t max_count =3D iocb->ki_pos >=3D i_size ? 0 : i_size - iocb=
->ki_pos;
> +
> +       if (iov_iter_count(ubuf) > max_count)
> +               iov_iter_truncate(ubuf, max_count);
> +}
> +
> +ssize_t fuse_ext_map_read_iter(struct kiocb *iocb, struct iov_iter *to)
> +{
> +       ssize_t res;
> +
> +       fuse_rw_clamp(iocb, to);
> +
> +       if (!iov_iter_count(to))
> +               return 0;
> +
> +       res =3D dax_iomap_rw(iocb, to, &fuse_ext_map_iomap_ops);

These fail link without CONFIG_FS_DAX
Because this file build does not depend on CONFIG_FUSE_DAX
Probably simplest to #define dax_iomap_rw() (-EIO)
locally in this case

> +
> +       file_accessed(iocb->ki_filp);
> +       return res;
> +}
> +
> +ssize_t fuse_ext_map_write_iter(struct kiocb *iocb, struct iov_iter *fro=
m)
> +{
> +       ssize_t res;
> +
> +       fuse_rw_clamp(iocb, from);
> +
> +       res =3D generic_write_checks(iocb, from);
> +       if (res <=3D 0)
> +               return res;
> +
> +       res =3D kiocb_modified(iocb);
> +       if (res)
> +               return res;
> +
> +       return dax_iomap_rw(iocb, from, &fuse_ext_map_iomap_ops);
> +}
> +
> +int fuse_ext_map_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       file_accessed(file);
> +       vma->vm_ops =3D &fuse_ext_map_vm_ops;
> +       vm_flags_set(vma, VM_HUGEPAGE);
> +       return 0;
> +}
> +
>  bool fuse_ext_map_is_dax(struct fuse_backing *fb)
>  {
>         struct fuse_iext *fie;
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 5a20f3863ee2..7248588b45c4 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1316,6 +1316,7 @@ static inline void fuse_backing_put(struct fuse_bac=
king *fb)
>
>  struct fuse_backing *fuse_backing_lookup(struct fuse_conn *fc, u64 backi=
ng_id);
>  int fuse_backing_add_64(struct fuse_conn *fc, struct fuse_backing *fb);
> +bool fuse_backing_is_dax(struct fuse_backing *fb);
>  void fuse_backing_files_init(struct fuse_conn *fc);
>  void fuse_backing_files_init_64(struct fuse_conn *fc);
>  void fuse_backing_files_free(struct fuse_conn *fc);
> @@ -1369,6 +1370,9 @@ extern void fuse_sysctl_unregister(void);
>  /* ext_map.c */
>
>  void fuse_ext_map_destroy(struct rb_root *extents);
> +ssize_t fuse_ext_map_write_iter(struct kiocb *iocb, struct iov_iter *fro=
m);
> +ssize_t fuse_ext_map_read_iter(struct kiocb *iocb, struct iov_iter *to);
> +int fuse_ext_map_mmap(struct file *file, struct vm_area_struct *vma);
>  bool fuse_ext_map_is_dax(struct fuse_backing *fb);
>  int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backi=
ng_map_out *arg,
>                           struct fuse_extent *ext);
> diff --git a/fs/fuse/notify.c b/fs/fuse/notify.c
> index 7c427f88bbc5..3bfedd0cdbdd 100644
> --- a/fs/fuse/notify.c
> +++ b/fs/fuse/notify.c
> @@ -448,6 +448,9 @@ static int fuse_notify_map(struct fuse_conn *fc, unsi=
gned int size,
>         if (err)
>                 return err;
>
> +       if (!fc->backing_id_64)
> +               return -EINVAL;
> +
>         if (outarg.num_extents > FUSE_MAX_EXTENTS)
>                 return -EINVAL;
>
> diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> index e9ab1aea34e2..040817ad76e9 100644
> --- a/fs/fuse/passthrough.c
> +++ b/fs/fuse/passthrough.c
> @@ -35,7 +35,6 @@ ssize_t fuse_passthrough_read_iter(struct kiocb *iocb, =
struct iov_iter *iter)
>         struct fuse_file *ff =3D file->private_data;
>         struct file *backing_file =3D fuse_file_passthrough(ff);
>         size_t count =3D iov_iter_count(iter);
> -       ssize_t ret;
>         struct backing_file_ctx ctx =3D {
>                 .cred =3D ff->cred,
>                 .accessed =3D fuse_file_accessed,
> @@ -48,10 +47,10 @@ ssize_t fuse_passthrough_read_iter(struct kiocb *iocb=
, struct iov_iter *iter)
>         if (!count)
>                 return 0;
>
> -       ret =3D backing_file_read_iter(backing_file, iter, iocb, iocb->ki=
_flags,
> -                                    &ctx);
> +       if (!backing_file)
> +               return fuse_ext_map_read_iter(iocb, iter);
>
> -       return ret;
> +       return backing_file_read_iter(backing_file, iter, iocb, iocb->ki_=
flags, &ctx);
>  }
>
>  ssize_t fuse_passthrough_write_iter(struct kiocb *iocb,
> @@ -74,10 +73,13 @@ ssize_t fuse_passthrough_write_iter(struct kiocb *ioc=
b,
>         if (!count)
>                 return 0;
>
> -       inode_lock(inode);
> +       guard(rwsem_write)(&inode->i_rwsem);
> +
> +       if (!backing_file)
> +               return fuse_ext_map_write_iter(iocb, iter);
> +
>         ret =3D backing_file_write_iter(backing_file, iter, iocb, iocb->k=
i_flags,
>                                       &ctx);
> -       inode_unlock(inode);
>
>         return ret;
>  }
> @@ -98,6 +100,9 @@ ssize_t fuse_passthrough_splice_read(struct file *in, =
loff_t *ppos,
>         pr_debug("%s: backing_file=3D0x%p, pos=3D%lld, len=3D%zu, flags=
=3D0x%x\n", __func__,
>                  backing_file, *ppos, len, flags);
>
> +       if (!backing_file)
> +               return copy_splice_read(in, ppos, pipe, len, flags);
> +
>         init_sync_kiocb(&iocb, in);
>         iocb.ki_pos =3D *ppos;
>         ret =3D backing_file_splice_read(backing_file, &iocb, pipe, len, =
flags, &ctx);
> @@ -123,6 +128,9 @@ ssize_t fuse_passthrough_splice_write(struct pipe_ino=
de_info *pipe,
>         pr_debug("%s: backing_file=3D0x%p, pos=3D%lld, len=3D%zu, flags=
=3D0x%x\n", __func__,
>                  backing_file, *ppos, len, flags);
>
> +       if (!backing_file)
> +               return iter_file_splice_write(pipe, out, ppos, len, flags=
);
> +
>         inode_lock(inode);
>         init_sync_kiocb(&iocb, out);
>         iocb.ki_pos =3D *ppos;
> @@ -145,6 +153,9 @@ ssize_t fuse_passthrough_mmap(struct file *file, stru=
ct vm_area_struct *vma)
>         pr_debug("%s: backing_file=3D0x%p, start=3D%lu, end=3D%lu\n", __f=
unc__,
>                  backing_file, vma->vm_start, vma->vm_end);
>
> +       if (!backing_file)
> +               return fuse_ext_map_mmap(file, vma);
> +
>         return backing_file_mmap(backing_file, vma, &ctx);
>  }
>
> @@ -156,6 +167,12 @@ int fuse_passthrough_open(struct file *file, struct =
fuse_backing *fb)
>         struct fuse_file *ff =3D file->private_data;
>         struct file *backing_file;
>
> +       if (fb->type =3D=3D FUSE_BACKING_EXTMAP) {
> +               if (fuse_backing_is_dax(fb) !=3D !!IS_DAX(file_inode(file=
)))
> +                       return fuse_EIO("dax mode mismatch");
> +               return 0;
> +       }
> +
>         if (fb->type !=3D FUSE_BACKING_PATH)
>                 return fuse_EIO("invalid backing type");
>
> --
> 2.54.0
>
