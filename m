Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868B0531B10
	for <nvdimm@lists.linux.dev>; Thu,  1 Oct 2026 16:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790870849; cv=pass; b=gJMTgfJxqEhSVrH8S3oZW/FVDAR31ha68g3uEv16Lb8Dym16Gacr+Rz2hZaAKDMiGBSj5mNBiif6HcfzVQp3oVumuiz0f/9oyV96G2r5PQUNs3SjgxeC3AXW0GJdFWKcmq8Vi20Fj3Ml/f6ktpP1OunByQtmNz1VgiVCsSUPo6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790870849; c=relaxed/simple;
	bh=MJy07H7corCZ5CYTQJFpIwM5cBfakhV4u+J3d9Mzcrc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rxRMkN41wIrTekr0Qw+HtT9cXIBNQLjjnnL1HUHMMKGaXdVporfZ94rtd99udKU0oQIYFA+uhv52/ub4W2eX/9AikAej7Fa6+72D6wRNO8Pk57oPtoMNJsxPDHnAv6DVmIr6qFtP0buLCHnoEtxjg0jGGCEm61r7AfdUDgaAWPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s+qmQZoY; arc=pass smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s+qmQZoY"
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2e309aeb38so211019066b.2
        for <nvdimm@lists.linux.dev>; Thu, 01 Oct 2026 09:07:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790870845; cv=none;
        d=google.com; s=arc-20260327;
        b=Xzm5QJ5r0JwVUE/pRjYS+S+hSX6E4teGjKG3fKJQEtVvFgT4kWU39bnd/cVioWJfOf
         5qrE9XyZ5V3i6c++dnWId7GYGprcRjrlwT4By1zAZrULiROPgCkIRsh96fygsYS3+jrj
         HCid+Doxo82GJTklNAWMpbEA67tF/T/SXGVCUpzCbisU5hr2lt03yW1NSjhig6zibRm/
         KY0wOEhogrSBjw8RM4q1t4/xRVilm/3n9PnhHeXEYcxSZFxjVbHJ+YvWr30B0+tURbUv
         SljoFyq4izpAb3alan2lKEB0QoEnugxU7FOXsPNXUX1x/EuLsXrwJMfFYVbbL14pF5RF
         a8pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GS2I4qItkm02Ot621CR2YI8JKxdAde+WXXmCsXrzOIo=;
        fh=KuLAoRmGc6qlhSNcnqujjuTgRod5NxAHswJMmzyRSGo=;
        b=rkTc8ePfAzprwQgmNuo6Gmob/v/Oc5OYWo8Xh5RXFzELeahs2VJuj2H1GRgyTPAuJL
         EbhY0Tc6mk5oHz6IVHOilUpk+LO4ekYRJqmaNm3tMOwIltzCSFD6nRaWpcsvsqnRXwLF
         bYpXeecIBw2OUvV0Hqbxd5tSepmVeThrjUX40qD+JCZQBlJebXUzyC0GpdSj26oMabGS
         RAQVsUqgMgiQWvsEqEqGcsZcrt2znWULFFOjEuS3yQHEEVvtlpc9yxGqinrUT/JsdizR
         /iEZiTjb/Bw1G/bUrlYM7dFVXvbeE13IFAzXrZDx15lEv8yqsUGxevmc750YyMtnd5CA
         rzqw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790870845; x=1791475645; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GS2I4qItkm02Ot621CR2YI8JKxdAde+WXXmCsXrzOIo=;
        b=s+qmQZoYj0YBquaprdMB7QRvc4rb2+6AzAjIdusyBN0tvA8TdAMD4uieqpCXw7Yjd1
         MCua1e9Y8bXUzrfHLQ/dTY6MLG/DNvnSquKhY6HqIdb0rp2HNqHA/b4EYPNNIZCCwr5z
         icImHHQWX+d5lEWSuMf2+RiAhHZ9Iw2xNRBYcc3sT4Krrw/vWWAFfgH1utV871N4dJ99
         nWWi/AHmuMWogWwYSmLSMIOyL4/3gjqgk+EOEvQpuxju7r0Ew27H29D61CrTQoQ5NEF/
         9u7NhSmJs4/uyzyWejHATg723UujlMj6O+WUSeBNO0Vhysz8i4BvkR2ruZLKaKAVguCv
         DgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790870845; x=1791475645;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GS2I4qItkm02Ot621CR2YI8JKxdAde+WXXmCsXrzOIo=;
        b=dqVYGA9BawhgrJ8mi4hh7aioVZLilSsnEkdZW8poslFhSgGoj5j6aQdNzLK81H4agK
         w4B35/rnouJPDDTNQAK80prp4u/q1+3yPNsj2mmZYvnhiy1gDIUEsdzkNu+LlAdftvDa
         rkLgouifozhg3YYMv9UZb6oj8MveBpBNjjReND2vJ3ioWRlevLKgpbjczLjyUFJqPETG
         WhsKtVH6LJM/SfLZneDy7mEM70PNphTWAeOWoCfZ84H9mMJ6htB1tl3tdVccLYBbbwk/
         2O3KVgZjAwoAqIvq9v20MvaaMuXOqEHi2Xa92Xgq5KJGZgGN0uDo/OeJ7ghwhZeUvHGz
         yI/A==
X-Forwarded-Encrypted: i=1; AKwUvByw2vpZWgoapzgaZH5V0F/n/lxcuTDiLx0eVYVribFEqc4C6vwhqSdDacHotha0rfhQI5mylh0=@lists.linux.dev
X-Gm-Message-State: AFuF++mCvyKlVtlP+rJUJPqy5+LYS6yZa4x0D3xn6F3oQO/NkAElQd0A
	RT2ViObCljOo9wun5x/CMsQkwffg2ybKM0FdSCzJJyjyomyZoSgxYXDOzVoDTkBhGhoD+7iv/vp
	3fLdoq1toNyDkRHwegvFaUr/UWbt2zpw=
X-Gm-Gg: AYBFou2qPIwJOWoDr0MQWckEYlrTuDEUfaSqPfMR/eX47DbAlznkHzNEnwly7kFmdTi
	i2K1J/ZnkPWoHg7RoA0nET8Sva4J0DRtHvBGWn75DlDkq4CGrFzP9fap9B8PcoGfkuoEwG6sNSO
	C9+cAFqOCEekAyXsWc6xHHiGwwKjPDryfv/jA1+ouJ0k+cQnAU0A2/mFD0XQmAtRLMjbxDmzA7z
	DFh7TWrHPOShZP04CqEFep5/My7Yvr4n913dqnQZEkzax3SXSnW6T6N4FozZicMJcsrcURbSSoZ
	CcBRB2cvReke7Z1+g2sxWFtdd8CkO1Cjn2XR/saUv+3lAC7UdY3649kk
X-Received: by 2002:a17:907:d2a:b0:c29:ab1d:b5be with SMTP id
 a640c23a62f3a-c2e4ad7a49emr3657366b.27.1790870844627; Thu, 01 Oct 2026
 09:07:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001150935.655979-1-mszeredi@redhat.com> <20261001150935.655979-6-mszeredi@redhat.com>
In-Reply-To: <20261001150935.655979-6-mszeredi@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 1 Oct 2026 18:07:13 +0200
X-Gm-Features: AclHuK9_QkaK6jU3aNZiMd9LpKhrVVzV3GODJDKaniOcHyGqu3kcsfJgEmOBc68
Message-ID: <CAOQ4uxhxSmnEBUckGSpqWnZ-EQ9dDpaBZv6feUDEf4y1uUkyHA@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] fuse: add support for opening dax device as backing
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
> This is only possible with FUSE_PASSTHROUGH_V2 enabled.
>
> Mark the inode with S_DAX if FUSE_LOOKUP returns with FUSE_ATTR_DAX set.
>
> This patch does not yet provide a way actually use the dax dev backing:
> when such a backing ID is provided in reply to FUSE_OPEN with
> FOPEN_PASSTHROUGH flag set, an error will be returned.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/fuse/backing.c     | 121 ++++++++++++++++++++++++++++++------------
>  fs/fuse/file.c        |   2 +-
>  fs/fuse/fuse_i.h      |  28 ++++++++--
>  fs/fuse/inode.c       |  11 +++-
>  fs/fuse/passthrough.c |   6 ++-
>  5 files changed, 126 insertions(+), 42 deletions(-)
>
> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 3c879df7989c..c852f0498961 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
> @@ -9,6 +9,7 @@
>  #include "fuse_i.h"
>
>  #include <linux/file.h>
> +#include <linux/dax.h>
>  #include <linux/rhashtable.h>
>
>  static struct fuse_backing *fuse_backing_get(struct fuse_backing *fb)
> @@ -22,9 +23,16 @@ static void fuse_backing_free(struct fuse_backing *fb)
>  {
>         pr_debug("%s: fb=3D0x%p\n", __func__, fb);
>
> -       if (fb->file)
> -               fput(fb->file);
> -       put_cred(fb->cred);
> +       switch (fb->type) {
> +       case FUSE_BACKING_PATH:
> +               path_put(&fb->path);
> +               put_cred(fb->cred);
> +               break;
> +
> +       case FUSE_BACKING_DAXDEV:
> +               fs_put_dax(fb->dax_dev, fb);
> +               break;
> +       }
>         kfree_rcu(fb, rcu);
>  }
>
> @@ -103,39 +111,83 @@ int fuse_backing_close_64(struct fuse_conn *fc, u64=
 backing_id)
>         return 0;
>  }
>
> -static struct fuse_backing *fuse_backing_new(struct fuse_conn *fc, int f=
d)
> +static int fuse_dax_notify_failure(struct dax_device *daxdev, u64 offset=
, u64 len, int mf_flags)
>  {
> -       struct fuse_backing *fb;
> -       struct super_block *backing_sb;
> -       struct file *file;
> +       struct fuse_backing *fb =3D dax_holder(daxdev);
>
> -       /* TODO: relax CAP_SYS_ADMIN once backing files are visible to ls=
of */
> -       if (!fc->passthrough || !capable(CAP_SYS_ADMIN))
> -               return ERR_PTR(-EPERM);
> +       fb->dax_error =3D true;
>
> -       CLASS(fd_raw, f)(fd);
> -       if (fd_empty(f))
> -               return ERR_PTR(-EBADF);
> +       return 0;
> +}
>
> -       file =3D fd_file(f);
> +static const struct dax_holder_operations fuse_dax_holder_ops =3D {
> +       .notify_failure         =3D fuse_dax_notify_failure,
> +};
> +
> +static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_back=
ing *fb, struct file *file)
> +{
> +       struct inode *inode =3D file_inode(file);
> +       struct dax_device *daxdev;
> +       int err;
>
> -       /* read/write/splice/mmap passthrough only relevant for regular f=
iles */
> -       if (!d_is_reg(file->f_path.dentry))
> -               return d_is_dir(file->f_path.dentry) ? ERR_PTR(-EISDIR) :=
 ERR_PTR(-EINVAL);
> +       switch (inode->i_mode & S_IFMT) {
> +       case S_IFREG:
> +               /* TODO: relax CAP_SYS_ADMIN once backing files are visib=
le to lsof */
> +               if (!fc->passthrough || !capable(CAP_SYS_ADMIN))
> +                       return -EPERM;
> +
> +               if (inode->i_sb->s_stack_depth >=3D fc->max_stack_depth)
> +                       return -ELOOP;
> +
> +               fb->type =3D FUSE_BACKING_PATH;
> +               fb->path =3D file->f_path;
> +               path_get(&fb->path);
> +               fb->cred =3D get_current_cred();
> +               return 0;
> +
> +       case S_IFCHR:
> +               daxdev =3D dax_dev_find(inode->i_rdev);
> +               if (!daxdev)
> +                       return -EINVAL;
> +
> +               err =3D -EPERM;
> +               if (capable(CAP_SYS_RAWIO)) {
> +                       err =3D fs_dax_get(daxdev, fb, &fuse_dax_holder_o=
ps);
> +                       if (!err) {
> +                               fb->type =3D FUSE_BACKING_DAXDEV;
> +                               fb->dax_dev =3D daxdev;
> +                       }
> +               }
> +               put_dax(daxdev);
> +               return err;
>
> -       backing_sb =3D file_inode(file)->i_sb;
> -       if (backing_sb->s_stack_depth >=3D fc->max_stack_depth)
> -               return ERR_PTR(-ELOOP);
> +       case S_IFDIR:
> +               return -EISDIR;
> +
> +       default:
> +               return -EINVAL;
> +       }
> +}
> +
> +static struct fuse_backing *fuse_backing_new(struct fuse_conn *fc, int f=
d)
> +{
> +       struct fuse_backing *fb __free(kfree) =3D kmalloc_obj(*fb);
> +       int err;
>
> -       fb =3D kmalloc_obj(struct fuse_backing);
>         if (!fb)
>                 return ERR_PTR(-ENOMEM);
>
> -       fb->file =3D get_file(file);
> -       fb->cred =3D get_current_cred();
> +       CLASS(fd_raw, f)(fd);
> +       if (fd_empty(f))
> +               return ERR_PTR(-EBADF);
> +
> +       err =3D fuse_backing_open_file(fc, fb, fd_file(f));
> +       if (err)
> +               return ERR_PTR(err);
> +
>         refcount_set(&fb->count, 1);
>
> -       return fb;
> +       return_ptr(fb);
>  }
>
>  int fuse_backing_open_64(struct fuse_conn *fc, struct fuse_backing_creat=
e_in *map)
> @@ -143,22 +195,21 @@ int fuse_backing_open_64(struct fuse_conn *fc, stru=
ct fuse_backing_create_in *ma
>         struct fuse_backing *fb;
>         int res;
>
> -       res =3D -EINVAL;
>         if (map->padding || map->spare[0] || map->spare[1])
> -               goto out;
> +               return -EINVAL;
>
>         if (!fc->backing_id_64)
> -               goto out;
> +               return -EINVAL;
>
>         fb =3D fuse_backing_new(fc, map->fd);
> -       res =3D PTR_ERR(fb);
> -       if (!IS_ERR(fb)) {
> -               fb->backing_id =3D map->backing_id;
> -               res =3D fuse_backing_add_64(fc, fb);
> -               if (res < 0)
> -                       fuse_backing_free(fb);
> -       }
> -out:
> +       if (IS_ERR(fb))
> +               return PTR_ERR(fb);
> +
> +       fb->backing_id =3D map->backing_id;
> +       res =3D fuse_backing_add_64(fc, fb);
> +       if (res < 0)
> +               fuse_backing_free(fb);
> +
>         return res;
>  }
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 1036c06fe35a..fb8e0a9fa4f6 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -297,7 +297,7 @@ static int fuse_open(struct inode *inode, struct file=
 *file)
>         if (!err) {
>                 if (is_truncate)
>                         truncate_pagecache(inode, 0);
> -               else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
> +               else if (!(ff->open_flags & FOPEN_KEEP_CACHE) && !IS_DAX(=
inode))
>                         invalidate_inode_pages2(inode->i_mapping);
>         }
>  out_unlock:
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 59afebc3dd2b..3e7ffb9bb2c3 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -89,10 +89,25 @@ struct fuse_submount_lookup {
>         struct fuse_forget_link *forget;
>  };
>
> +enum fuse_backing_type {
> +       FUSE_BACKING_PATH,
> +       FUSE_BACKING_DAXDEV,
> +};
> +
>  /* Container for data related to mapping to backing file */
>  struct fuse_backing {
> -       struct file *file;
> -       const struct cred *cred;
> +       enum fuse_backing_type type;
> +
> +       union {
> +               struct {
> +                       struct path path;
> +                       const struct cred *cred;
> +               };
> +               struct {
> +                       struct dax_device *dax_dev;
> +                       bool dax_error;
> +               };
> +       };
>         u64 backing_id;
>         struct rhash_head hash_node;
>         /* refcount */
> @@ -1239,7 +1254,14 @@ void fuse_free_conn(struct fuse_conn *fc);
>
>  /* dax.c */
>
> -#define FUSE_IS_VDAX(inode) (IS_ENABLED(CONFIG_FUSE_VDAX) && IS_DAX(inod=
e))
> +static inline bool FUSE_IS_VDAX(struct inode *inode)
> +{
> +#ifdef CONFIG_FUSE_VDAX
> +       return get_fuse_inode(inode)->vdax && IS_DAX(inode);
> +#else
> +       return false;
> +#endif
> +}
>
>  ssize_t fuse_vdax_read_iter(struct kiocb *iocb, struct iov_iter *to);
>  ssize_t fuse_vdax_write_iter(struct kiocb *iocb, struct iov_iter *from);
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index bb76bddfc241..d42c824fd6af 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -148,7 +148,7 @@ static void fuse_evict_inode(struct inode *inode)
>         /* Will write inode on close/munmap and in all other dirtiers */
>         WARN_ON(inode_state_read_once(inode) & I_DIRTY_INODE);
>
> -       if (FUSE_IS_VDAX(inode))
> +       if (IS_DAX(inode))
>                 dax_break_layout_final(inode);
>
>         truncate_inode_pages_final(&inode->i_data);
> @@ -403,6 +403,10 @@ static void fuse_init_submount_lookup(struct fuse_su=
bmount_lookup *sl,
>         refcount_set(&sl->count, 1);
>  }
>
> +static const struct address_space_operations fuse_dax_aops =3D {
> +       .dirty_folio    =3D noop_dirty_folio,
> +};
> +
>  static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr,
>                             struct fuse_conn *fc)
>  {
> @@ -430,6 +434,11 @@ static void fuse_init_inode(struct inode *inode, str=
uct fuse_attr *attr,
>          */
>         if (!fc->posix_acl)
>                 inode->i_acl =3D inode->i_default_acl =3D ACL_DONT_CACHE;
> +
> +       if ((attr->flags & FUSE_ATTR_DAX) && !fc->vdax) {

This (fc->vdax) fails build without CONFIG_FUSE_DAX

> +               inode->i_flags |=3D S_DAX;
> +               inode->i_data.a_ops =3D &fuse_dax_aops;
> +       }
>  }
>
>  static int fuse_inode_eq(struct inode *inode, void *_nodeidp)
> diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> index 4894842ad6d0..e9ab1aea34e2 100644
> --- a/fs/fuse/passthrough.c
> +++ b/fs/fuse/passthrough.c
> @@ -156,9 +156,11 @@ int fuse_passthrough_open(struct file *file, struct =
fuse_backing *fb)
>         struct fuse_file *ff =3D file->private_data;
>         struct file *backing_file;
>
> +       if (fb->type !=3D FUSE_BACKING_PATH)
> +               return fuse_EIO("invalid backing type");
> +
>         /* Allocate backing file per fuse file to store fuse path */
> -       backing_file =3D backing_file_open(file, file->f_flags,
> -                                        &fb->file->f_path, fb->cred);
> +       backing_file =3D backing_file_open(file, file->f_flags, &fb->path=
, fb->cred);
>         if (IS_ERR(backing_file))
>                 return fuse_EIO("failed to open backing file (%ld)", PTR_=
ERR(backing_file));
>
> --
> 2.54.0
>
