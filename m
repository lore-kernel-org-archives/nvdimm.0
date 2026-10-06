Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775481AC44D
	for <nvdimm@lists.linux.dev>; Tue,  6 Oct 2026 21:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320629; cv=pass; b=sewdweQZpHXJJoMcNKD/WEek0LseXdkeaEJJ4T5uLr1g9WNx/ewUt7fwTaW3NAptoh+LHV99OMCtrw+XhF17/o+RJu1yATsSS/T2zfAN6YiOTVUAP2Z9A6E67dVTj/JRgCNxbJtG+0u9MBl5F4dmtcj78vZpV0DYwr06d8udL2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320629; c=relaxed/simple;
	bh=b2W34P/urqYsA5joKgQX5pjyd0oiOSmqRBrDn5op+bM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JqdOggmqA9eF6S7ANSKMCkoz7kSJL3NO7szxUj2HLyBiTlLM8n/w3Zi2VspGldd7HRdG86lEkwLLlJ43T4Z8G0HNDKVHSNmY7XHEZDL2QNxXvCrEngkiuUUm/r8gOuQ9f80MPWObo0Q8i8kpfeJDGAgArS6cVRu4t2A/DfngabE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EE2dKVFr; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EE2dKVFr"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6afa651700eso1965209a12.2
        for <nvdimm@lists.linux.dev>; Tue, 06 Oct 2026 14:03:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791320625; cv=none;
        d=google.com; s=arc-20260327;
        b=FcgtxbGDdiai4l5QsMj9pFDKL84qyUN6iw3xInTV94+Km+XaQHW9tcVbKs7LU8rqIX
         oT+NCcEbMA5XEPmqMKdKZKCgQ3pgdjPll39XzzpRYH36dvFPBDAYIt7vBzyJMzmnYhJk
         +FUbgixO9VGgnnMvYTRGlIdATj8lestk+Kzi5iBIr9E7yszipB9gJSmLURBhoKB2wK8F
         F2pNWMrHzJftmlUN0vZYL34f7sIuYbGZCSKC1S0LKbcwHEhElr4w28i6AwpDFwTSYN/s
         plPQGU0arYIarK8DKZZC2D9ewmHHSb9LOOSSisftek8irEKXhp3AvcBvXiTHTPyrJo6p
         gqcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dLRok0n9UnxaSR+lfr4s0WqVEVY4M/HLtc9+zuOT7oA=;
        fh=/mG4K5ppSzwDdhCqplyH3di7cb0TyFai6NlJHSL1sDY=;
        b=TBMQAzbqyeHKlLwkT6FNuW3TkZ61zNtknnfo9zqoIblIULXre7NEw/J1JMjwiyuIaK
         qkb7qPLZe7ydl11d7sed4RZachkfn850Ez2Ofo0g8p7f8QVQPFh+GJcLTO8zVdqabnUO
         rWJG9a/sRGROhUGr2C64kZBYKXwOxNZN0MjnuP+SFS8KPNDMSbvfLPKvCJezwQoG/T9j
         RHVTayFrnZAw5ODQHaetIH9nzSVhqpKiWo44xD+Mx40ynLqwWrtFVWejeCHZSatC2vFh
         wIq5zVg75bDGTOO0h/IgOx6JXxlZF2JtROK1ReYxcZp3F549Ch743Zu77UNaa4MM8aaL
         FsXg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791320625; x=1791925425; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dLRok0n9UnxaSR+lfr4s0WqVEVY4M/HLtc9+zuOT7oA=;
        b=EE2dKVFrFqe97nYdGsF1QCKMfxAKbZQsr8x8LPJiuCUsAwBIJ7C7iJqoGGfLXHDCnx
         sotOOWX0ruE6jkcnxkx1z+kUJeHDhpl6btmhhcNWOKnnNYcdhNQg3rijsVbpGwVDXp3b
         aTCqeV8rnoXBV8NH5BJ78JEDTBYiNOyx79KHO4JYfFIKmdAMGMXO1jhPaEErOKfJ5sGn
         6vAXeCihPejTx8HDyzkVwgTs8kuXFTHpiei+fk0hAklkg1C0udk6ksUlzt4ZvBigZ+KE
         DBZxmarxESKX5x2cIVDYXXV3aO/yovgskoF8tocGj8zhUiUYcLxIyL7OOusJXLQHoD2+
         CXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791320625; x=1791925425;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dLRok0n9UnxaSR+lfr4s0WqVEVY4M/HLtc9+zuOT7oA=;
        b=vAC3E9h5ENHdOF2+YhYA4WJX9LmGdv/jCPZAaHLeWZDRf4iTQ1c2Vnp5ZINpcL74xJ
         HsAHRgmH6ax2EiAVLMGIppzLh7knsj62J46Dht99+f/WNxId7Qosg2UWx7LkQZAuUZRq
         vdu/iLBWghJwIQvSVjTY5gmjf1R6xbQZjf0V/J1kpDbTcLnosK/dg3uo+MlWXIlNjJsf
         GNJg8y953/c+v3sBkEMnmRJZ2KELoAhygPL6Xf+gfl1HLxbkk10s/4He0ABRvNW5+j2y
         SX5d60Yhy6GwnRCHVPDQyCMBiRr8cF3Acie9GV3ACix2EqK+h8xcFno/wqZr7856Xgw7
         KfVA==
X-Forwarded-Encrypted: i=1; AKwUvBzNDpXkitHJHw+s1Te0pql5MJ4Z2KwUDWe7SGucQY5suSWx7j77N/3VB5Td6Lf1398/iyG3TC8=@lists.linux.dev
X-Gm-Message-State: AFq9FYKl3JLo9cYVXH9A88/deUrCgYuMbL3dhRAPw4m9syZ+v596eloN
	qsdELKznYZlP89bki5gIMZ0km16wIyNySCSt37nTJ4eL/NOcHtZuhD7As+67w2LlohAWaw44o7S
	HXXuIANyvxU6ERZhn9+vFV2gaMP3pzqw=
X-Gm-Gg: AYBFou1abk2lZ+mZTALjFDDiCAk6/wzhl6cLnyF6775drpiambdpILqO5Ws5SrUJVAG
	vH9XaAB0ZG+X7Vxc8hH9dIdTFJj5tcu07xmEMP4UkCiMiXruuO1HlhxEEMWR7d9yUTk75KFfN7I
	0KJVlV5BhxdLTEilFcmSS3WuHgFUNfUUYmch+jG36w75RO/dz73pa1pSE9Wxp1UUSvaVvHmlweU
	Z9EJ/vjnwmsWOxjM0VcIYJE1ejSJnftFCmbL23Y6aLBgUXpGtB/2XwBaAGflyER+HnFQq5FPOEF
	wz+IUZ8S4V+n6b0rmNCuyQnSm0LUUlWopmMg4whnxwILz4qQBt8DgJZ5fWjA+FMJ52Vr/0fxVdC
	l0hPgesZI3Pk=
X-Received: by 2002:a05:6402:52d9:b0:6ab:6e:a8e4 with SMTP id
 4fb4d7f45d1cf-6aff45977b7mr186880a12.44.1791320624200; Tue, 06 Oct 2026
 14:03:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261006180115.1425232-1-mszeredi@redhat.com> <20261006180115.1425232-4-mszeredi@redhat.com>
In-Reply-To: <20261006180115.1425232-4-mszeredi@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 6 Oct 2026 23:03:32 +0200
X-Gm-Features: AclHuK8PYGjthWGD-uqyqrq3itYp173voPWzpkl2f7Ec_jhlpbwglDyFnI7Ntw0
Message-ID: <CAOQ4uxg4gC0BB0UZz3bOhWm0-qXhoHDLbrQc3gC3WL+05=4Cwg@mail.gmail.com>
Subject: Re: [PATCH v3 3/9] fuse: add helpers for EIO return value with kernel message
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: fuse-devel@lists.linux.dev, John Groves <john@groves.net>, 
	"Darrick J . Wong" <djwong@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 6, 2026 at 8:01=E2=80=AFPM Miklos Szeredi <mszeredi@redhat.com>=
 wrote:
>
> Conditions are triggered by a buggy fuse server will result in -EIO which
> is hard to interpret without any context.
>
> Add helpers that print a short message to the kernel log as well as
> returning the error value.  This serves a dual purpose:
>
>  - documents the error condition inside the code
>
>  - allows the implementor of the fuse server to get the context for the
>    error
>
> Some debug messages are removed in favor of this.
>
> This also changes the mmap return value from -ETXTBSY to -ENODEV if a
> passthrough open raced with the prior check.  This makes both cases retur=
n
> -ENODEV if the file is in passthrough mode.
>
> Additionally change the return value of fuse_file_cached_io_open() from a=
n
> error value to a bool (true on success) as the error value is translated
> anyway.
>
> Currently these use the pr_notice_once() variant.  Possibly should be
> changed to a ratelimit of e.g. once per minute.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/fuse/file.c        |  6 ++--
>  fs/fuse/fuse_i.h      |  4 ++-
>  fs/fuse/iomode.c      | 75 ++++++++++++++++++-------------------------
>  fs/fuse/passthrough.c | 19 ++++-------
>  4 files changed, 43 insertions(+), 61 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 6d707f2b3bff..bde07948d1f0 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -2415,7 +2415,6 @@ static int fuse_file_mmap(struct file *file, struct=
 vm_area_struct *vma)
>         struct fuse_file *ff =3D file->private_data;
>         struct fuse_conn *fc =3D ff->fm->fc;
>         struct inode *inode =3D file_inode(file);
> -       int rc;
>
>         /* DAX mmap is superior to direct_io mmap */
>         if (FUSE_IS_VDAX(inode))
> @@ -2457,9 +2456,8 @@ static int fuse_file_mmap(struct file *file, struct=
 vm_area_struct *vma)
>                  * After first mmap, the inode stays in caching io mode u=
ntil
>                  * the direct_io file release.
>                  */
> -               rc =3D fuse_file_cached_io_open(inode, ff);
> -               if (rc)
> -                       return rc;
> +               if (!fuse_file_cached_io_open(inode, ff))
> +                       return -ENODEV;
>         }
>
>         if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 8546855386b5..d9ec88028d7b 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -11,6 +11,8 @@
>  # define pr_fmt(fmt) "fuse: " fmt
>  #endif
>
> +#define fuse_EIO(fmt, ...) (pr_notice_once("%s: " fmt "\n", __func__, ##=
__VA_ARGS__), -EIO)
> +
>  #include "args.h"
>  #include <linux/fuse.h>
>  #include <linux/fs.h>
> @@ -1251,7 +1253,7 @@ int fuse_fileattr_set(struct mnt_idmap *idmap,
>                       struct dentry *dentry, struct file_kattr *fa);
>
>  /* iomode.c */
> -int fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff);
> +bool fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff)=
;
>  int fuse_inode_uncached_io_start(struct fuse_inode *fi,
>                                  struct fuse_backing *fb);
>  void fuse_inode_uncached_io_end(struct fuse_inode *fi);
> diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
> index 79637c09e883..1b8b267d0c0d 100644
> --- a/fs/fuse/iomode.c
> +++ b/fs/fuse/iomode.c
> @@ -27,15 +27,15 @@ static inline bool fuse_is_io_cache_wait(struct fuse_=
inode *fi)
>   * Blocks new parallel dio writes and waits for the in-progress parallel=
 dio
>   * writes to complete.
>   */
> -int fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff)
> +bool fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff)
>  {
>         struct fuse_inode *fi =3D get_fuse_inode(inode);
>
>         /* There are no io modes if server does not implement open */
>         if (!ff->args)
> -               return 0;
> +               return true;
>
> -       spin_lock(&fi->lock);
> +       guard(spinlock)(&fi->lock);
>         /*
>          * Setting the bit advises new direct-io writes to use an exclusi=
ve
>          * lock - without it the wait below might be forever.
> @@ -53,8 +53,7 @@ int fuse_file_cached_io_open(struct inode *inode, struc=
t fuse_file *ff)
>          */
>         if (fuse_inode_backing(fi)) {
>                 clear_bit(FUSE_I_CACHE_IO_MODE, &fi->state);
> -               spin_unlock(&fi->lock);
> -               return -ETXTBSY;
> +               return false;
>         }
>
>         WARN_ON(ff->iomode =3D=3D IOM_UNCACHED);
> @@ -64,8 +63,7 @@ int fuse_file_cached_io_open(struct inode *inode, struc=
t fuse_file *ff)
>                         set_bit(FUSE_I_CACHE_IO_MODE, &fi->state);
>                 fi->iocachectr++;
>         }
> -       spin_unlock(&fi->lock);
> -       return 0;
> +       return true;
>  }
>
>  static void fuse_file_cached_io_release(struct fuse_file *ff,
> @@ -85,19 +83,16 @@ static void fuse_file_cached_io_release(struct fuse_f=
ile *ff,
>  int fuse_inode_uncached_io_start(struct fuse_inode *fi, struct fuse_back=
ing *fb)
>  {
>         struct fuse_backing *oldfb;
> -       int err =3D 0;
>
> -       spin_lock(&fi->lock);
> +       guard(spinlock)(&fi->lock);
>         /* deny conflicting backing files on same fuse inode */
>         oldfb =3D fuse_inode_backing(fi);
> -       if (fb && oldfb && oldfb !=3D fb) {
> -               err =3D -EBUSY;
> -               goto unlock;
> -       }
> -       if (fi->iocachectr > 0) {
> -               err =3D -ETXTBSY;
> -               goto unlock;
> -       }
> +       if (fb && oldfb && oldfb !=3D fb)
> +               return -EBUSY;
> +
> +       if (fi->iocachectr > 0)
> +               return -ETXTBSY;
> +
>         fi->iocachectr--;
>
>         /* fuse inode holds a single refcount of backing file */
> @@ -107,9 +102,7 @@ int fuse_inode_uncached_io_start(struct fuse_inode *f=
i, struct fuse_backing *fb)
>         } else {
>                 fuse_backing_put(fb);
>         }
> -unlock:
> -       spin_unlock(&fi->lock);
> -       return err;
> +       return 0;
>  }
>
>  /* Takes uncached_io inode mode reference to be dropped on file release =
*/
> @@ -121,8 +114,11 @@ static int fuse_file_uncached_io_open(struct inode *=
inode,
>         int err;
>
>         err =3D fuse_inode_uncached_io_start(fi, fb);
> -       if (err)
> -               return err;
> +       if (err) {
> +               if (err =3D=3D -EBUSY)
> +                       return fuse_EIO("mismatched backing");
> +               return fuse_EIO("conflicting caching mode");
> +       }
>
>         WARN_ON(ff->iomode !=3D IOM_NONE);
>         ff->iomode =3D IOM_UNCACHED;
> @@ -173,9 +169,11 @@ static int fuse_file_passthrough_open(struct inode *=
inode, struct file *file)
>         int err;
>
>         /* Check allowed conditions for file open in passthrough mode */
> -       if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH) || !fc->passthrough ||
> -           (ff->open_flags & ~FOPEN_PASSTHROUGH_MASK))
> -               return -EINVAL;
> +       if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH) || !fc->passthrough)
> +               return fuse_EIO("passthrough not enabled");
> +
> +       if (ff->open_flags & ~FOPEN_PASSTHROUGH_MASK)
> +               return fuse_EIO("conflicting open flags");
>
>         fb =3D fuse_passthrough_open(file, ff->args->open_outarg.backing_=
id);
>         if (IS_ERR(fb))
> @@ -197,7 +195,6 @@ int fuse_file_io_open(struct file *file, struct inode=
 *inode)
>  {
>         struct fuse_file *ff =3D file->private_data;
>         struct fuse_inode *fi =3D get_fuse_inode(inode);
> -       int err;
>
>         /*
>          * io modes are not relevant with virtiofs DAX and with server th=
at does not
> @@ -208,11 +205,12 @@ int fuse_file_io_open(struct file *file, struct ino=
de *inode)
>
>         /*
>          * Server is expected to use FOPEN_PASSTHROUGH for all opens of a=
n inode
> -        * which is already open for passthrough.
> +        * which is already open for passthrough.  Using incorrect open m=
ode is
> +        * a server mistake, which results in user visible failure of ope=
n()
> +        * with EIO error.
>          */
> -       err =3D -EINVAL;
>         if (fuse_inode_backing(fi) && !(ff->open_flags & FOPEN_PASSTHROUG=
H))
> -               goto fail;
> +               return fuse_EIO("FOPEN_PASSTHROUGH expected");
>
>         /*
>          * FOPEN_PARALLEL_DIRECT_WRITES requires FOPEN_DIRECT_IO.
> @@ -233,23 +231,12 @@ int fuse_file_io_open(struct file *file, struct ino=
de *inode)
>                 return 0;
>
>         if (ff->open_flags & FOPEN_PASSTHROUGH)
> -               err =3D fuse_file_passthrough_open(inode, file);
> -       else
> -               err =3D fuse_file_cached_io_open(inode, ff);
> -       if (err)
> -               goto fail;
> +               return fuse_file_passthrough_open(inode, file);
>
> -       return 0;
> +       if (!fuse_file_cached_io_open(inode, ff))
> +               return fuse_EIO("conflicting passthrough open");
>
> -fail:
> -       pr_debug("failed to open file in requested io mode (open_flags=3D=
0x%x, err=3D%i).\n",
> -                ff->open_flags, err);
> -       /*
> -        * The file open mode determines the inode io mode.
> -        * Using incorrect open mode is a server mistake, which results i=
n
> -        * user visible failure of open() with EIO error.
> -        */
> -       return -EIO;
> +       return 0;
>  }
>
>  /* No more pending io and no new io possible to inode via open/mmapped f=
ile */
> diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> index b43d3e0f7081..489838462d1e 100644
> --- a/fs/fuse/passthrough.c
> +++ b/fs/fuse/passthrough.c
> @@ -159,34 +159,29 @@ struct fuse_backing *fuse_passthrough_open(struct f=
ile *file, int backing_id)
>         struct fuse_conn *fc =3D ff->fm->fc;
>         struct fuse_backing *fb =3D NULL;
>         struct file *backing_file;
> -       int err;
>
> -       err =3D -EINVAL;
>         if (backing_id <=3D 0)
> -               goto out;
> +               return ERR_PTR(fuse_EIO("invalid backing_id"));
>
> -       err =3D -ENOENT;
>         fb =3D fuse_backing_lookup(fc, backing_id);
>         if (!fb)
> -               goto out;
> +               return ERR_PTR(fuse_EIO("backing not found"));
>
>         /* Allocate backing file per fuse file to store fuse path */
>         backing_file =3D backing_file_open(file, file->f_flags,
>                                          &fb->file->f_path, fb->cred);
> -       err =3D PTR_ERR(backing_file);
>         if (IS_ERR(backing_file)) {
>                 fuse_backing_put(fb);
> -               goto out;
> +               return ERR_PTR(fuse_EIO("failed to open backing file (%ld=
)", PTR_ERR(backing_file)));
>         }
>
> -       err =3D 0;
>         ff->passthrough =3D backing_file;
>         ff->cred =3D get_cred(fb->cred);
> -out:
> -       pr_debug("%s: backing_id=3D%d, fb=3D0x%p, backing_file=3D0x%p, er=
r=3D%i\n", __func__,
> -                backing_id, fb, ff->passthrough, err);
>
> -       return err ? ERR_PTR(err) : fb;
> +       pr_debug("%s: backing_id=3D%d, fb=3D0x%p, backing_file=3D0x%p\n",=
 __func__,
> +                backing_id, fb, ff->passthrough);
> +
> +       return fb;
>  }
>
>  void fuse_passthrough_release(struct fuse_file *ff, struct fuse_backing =
*fb)
> --
> 2.54.0
>
