Received: from mail-ed2-f43.google.com (mail-ed2-f43.google.com [74.125.228.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8C3404882
	for <nvdimm@lists.linux.dev>; Thu,  1 Oct 2026 16:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790872363; cv=pass; b=OBm+iB3DawnsatPbbYSKJCWUX7awljR43oJC6gfdW5dGKgArjcZymmdVU/W6kO6eII2qR4m7wozEZn5YD3I+ex6FjYRZ3v8p2omWaW0U4RaHd4kH5hECQhDmYDjAVj0hZ2FZ3LXf/HeQhLkLXiM0hxyKTxZLtb5ddgE9S0lGJXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790872363; c=relaxed/simple;
	bh=Hmrg1utwy1UsI/La0jCaZph+V7N3+1dJzQKkRO9nMBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q3qztvFcqIabArmy9uiw5qi6cBq7qhLKUPWz65WBG6drZAam7/Z5zSMbholYW8+X1wQoM9ejPWYCXV0g9ssrkq7EWOkatnwYm58YjwLN7mP0sWVD2h9yPFgluoJ6A7oANesPNRBu/KcFjTRWIAMol2CXqLzY3IkIVDQ8nex5sLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H/TGA78T; arc=pass smtp.client-ip=74.125.228.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/TGA78T"
Received: by mail-ed2-f43.google.com with SMTP id 4fb4d7f45d1cf-6ae19319854so3103846a12.3
        for <nvdimm@lists.linux.dev>; Thu, 01 Oct 2026 09:32:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790872359; cv=none;
        d=google.com; s=arc-20260327;
        b=O2TY+D8wtta/TOrsYBXc0JF4W3Y+haGv2baUD0M5uQKUKCAXBcW8DwwrPxg88/5XOP
         ZGhox+jhFWRacQBWvcLaBplhCNIWLmDU6gIPKk2Vtrua8FEXoaBAJkD7pHsTdTX/1sXu
         0QKwpOqvmt5p1B69kbyoEB7mY9Mmxx/5inNbRjNlffQt7ZcNPg3Yq2fc+hJee6gPJsap
         gyFTjUVonUat/ZqDdxnkMwjyB3i57sILzFUm9VtLVryK5v7GkaMhskdJyelPpHsAbjxK
         ALr38lb0HiA+ryBR0p/RoEQhWigyn8tUg8yDT2uRiZZ8bwVWdqDUy/yVgJhT6pXFs6P/
         tcWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TznGzYFAbbkKA0AdCMYN+GaZPqVPOXxDGKW1f5n1Xes=;
        fh=/MrGjtuDQ5tLzJ//pwDNfa74tGJqXPX+zeAf3up52x4=;
        b=gRYnvaTbt4MIwd7B67SxW3n74/JRMIPk9nqa9IhjSBHkg3IB+Fn6+G99abYs0kJRNT
         os96Arapeb/e2/5LcVfAxTyA4GZoGAJqIdKxHHdAAy70GKB94XjG2AHFZ7Ub69IbRjqr
         0qIBOUgR1ZiwdGHKhtEb8Xe+2TbXbOsAqx/LbnWKXNtEVStp7jW39hDG4JHeYM1XDg+f
         WxGstIn8A5hwFJbzvFhROqHptt5ly6RkZmEfMiv7yM/+o1FnomtueKEWdyAEcdjBNXT2
         gQvQ+hOVLCy3bx8JLaY7PKssFV0WqhnHGgyaQbf9TJa+cpWoDJLaBVNqKlZGaRZ+lAtj
         iJBQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790872359; x=1791477159; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TznGzYFAbbkKA0AdCMYN+GaZPqVPOXxDGKW1f5n1Xes=;
        b=H/TGA78TVo4I7d71601xS+/ISrkT+m59XDBDEoHX8K4LuTQFYnBYG8xkRpLBaRPwfc
         yflVe5HfLy/t3a47vCg/rNYLln0WouJbxlOFAxnaOlwLXtLhjD8sETjAr7A8T/RBoQIg
         KFQQ59TeX6tznmh2/yIP+bVHEnK0ZiOAxF+AUznEy3FFfRyQrFyblcvsGCbB85IDzELv
         GdanEXHjUUzwMwmWFccdqNLGbwGxRCLnUneEd2XWdbiK11qyWCisM/RhvNWhN+AjFzUu
         FjtsChMAT1VuPfSgg7BSddlo+fX8oCoynxx+5mZvHDzhKQmU9yeG1gXTU2lQtoqLAAaI
         9sqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790872359; x=1791477159;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TznGzYFAbbkKA0AdCMYN+GaZPqVPOXxDGKW1f5n1Xes=;
        b=bbOJebffRcpgcnFUXTzhuA/owVDTzG5NuQt0yAa/v4faq7GVbbNRLaeWUOZFCmZr81
         H0Ph3CrWotTc/3d5xg+AyMOzK8pP4F/8qNPbFxxoMLNdmr0EIGOnBsTnAB2cTzri48M8
         SFMOPIgW7XnMcm5P5NQ/yBua9mnKD+2yc+qbQkJeJSHAgB7uz/f+xIGd6l7DdjC/ZPGs
         Q0DDz++IzBOGSgiRFmSZG1HMBZJDcu/jpO2zu+Wjvb4OoL4qN/w5/ZxhZ0fMrp8WpwH/
         9MrKgtM0F1hL1IoC2mZn/hWIzftcxuHPVSpQy5gxe7Uj/AgOioKUMZI5cHyoSdP4qYDp
         f8gw==
X-Forwarded-Encrypted: i=1; AKwUvByfsaxGvvOXuAbyRjorJk0wMXo+AvMD821rE0guWOZrh+r0aQR9YCyY3BK8S5xX3MOQzFqfBEI=@lists.linux.dev
X-Gm-Message-State: AFq9FYLmTo75oOJx7Zgzfcz/19C9X46NtsGqhJ856xQfbBskw49G/0Gn
	MK+vJrA1uNY4pGy7dsZ8cI5kL/EjRJgwNNN/v8D0bPbijeh9YcK49+51Zs94NA5qt+FN2FScZGW
	F3GcqC3trLWN93PrN7by3uTWJhWVneU5WWgPvZ40=
X-Gm-Gg: AYBFou1nyXqUMDixgMLEPW0dcEqAayFo436A40PWcjuquKkgbSHxtqGkgbU83cDSRFr
	bXaePudn7dBhFEKky2vK1Kh7vwkW2Q5lJFBg4eAXnIn/kpzAnpYXzJ7S0xlZkAk/AaHiY9jt4Ci
	62v42OJt7DOUR1CfWIBet3J0Eyz6tcpymzRjS2Ut0MIwLzZ1q7a1rFLcMoHI3zBhMcNLUXEVzzs
	yXy9s8KnpvvhfHACHHdZW1opRUFMBh+zg5a6th4vsa8AEEL5GfYh28NRCu5qlm0VwDppdZDUAhc
	obOS7pM7nQze/ARNHEzjMyg+k28k5of7QgrJ3YizxY/oKS/0r+XcSvtnGApoyLjEMnA=
X-Received: by 2002:a05:6402:2348:b0:6ac:813a:a1ef with SMTP id
 4fb4d7f45d1cf-6ae1993bcd1mr4364855a12.26.1790872358679; Thu, 01 Oct 2026
 09:32:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001150935.655979-1-mszeredi@redhat.com> <20261001150935.655979-3-mszeredi@redhat.com>
In-Reply-To: <20261001150935.655979-3-mszeredi@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 1 Oct 2026 18:32:27 +0200
X-Gm-Features: AclHuK8eTEc6STnpBDxfmRuKYDGoODXckCxazjNwWIfmWODp6sxlTPHn37GRHY0
Message-ID: <CAOQ4uxjQYaFUG=VT1LoKbs3QUTbTeEy3tTY=_FMujMiWGRR_=A@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] fuse: add helpers for EIO return value with kernel message
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
> Additionally change the return value of fuse_inode_uncached_io_start() an=
d
> fuse_file_cached_io_open() from an error value to a bool (true on success=
)
> as the error value is translated anyway.
>
> Currently these use the pr_notice_once() variant.  Possibly should be
> changed to a ratelimit of e.g. once per minute.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/fuse/file.c        |  8 ++---
>  fs/fuse/fuse_i.h      |  6 ++--
>  fs/fuse/iomode.c      | 74 ++++++++++++++++---------------------------
>  fs/fuse/passthrough.c | 19 ++++-------
>  4 files changed, 42 insertions(+), 65 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 6d707f2b3bff..92976906ab05 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1478,7 +1478,7 @@ static void fuse_dio_lock(struct kiocb *iocb, struc=
t iov_iter *from,
>                  * have raced, so check it again.
>                  */
>                 if (fuse_io_past_eof(iocb, from) ||
> -                   fuse_inode_uncached_io_start(fi, NULL) !=3D 0) {
> +                   !fuse_inode_uncached_io_start(fi, NULL)) {
>                         inode_unlock_shared(inode);
>                         inode_lock(inode);
>                         *exclusive =3D true;
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
> index 8546855386b5..3dd4dff24c50 100644
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
> @@ -1251,8 +1253,8 @@ int fuse_fileattr_set(struct mnt_idmap *idmap,
>                       struct dentry *dentry, struct file_kattr *fa);
>
>  /* iomode.c */
> -int fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff);
> -int fuse_inode_uncached_io_start(struct fuse_inode *fi,
> +bool fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff)=
;
> +bool fuse_inode_uncached_io_start(struct fuse_inode *fi,
>                                  struct fuse_backing *fb);
>  void fuse_inode_uncached_io_end(struct fuse_inode *fi);
>
> diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
> index 79637c09e883..1a10bc65fb31 100644
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
> @@ -82,22 +80,19 @@ static void fuse_file_cached_io_release(struct fuse_f=
ile *ff,
>  }
>
>  /* Start strictly uncached io mode where cache access is not allowed */
> -int fuse_inode_uncached_io_start(struct fuse_inode *fi, struct fuse_back=
ing *fb)
> +bool fuse_inode_uncached_io_start(struct fuse_inode *fi, struct fuse_bac=
king *fb)
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
> +               return false;
> +
> +       if (fi->iocachectr > 0)
> +               return false;
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
> +       return true;
>  }
>
>  /* Takes uncached_io inode mode reference to be dropped on file release =
*/
> @@ -118,11 +111,9 @@ static int fuse_file_uncached_io_open(struct inode *=
inode,
>                                       struct fuse_backing *fb)
>  {
>         struct fuse_inode *fi =3D get_fuse_inode(inode);
> -       int err;
>
> -       err =3D fuse_inode_uncached_io_start(fi, fb);
> -       if (err)
> -               return err;
> +       if (!fuse_inode_uncached_io_start(fi, fb))
> +               return fuse_EIO("failed to start uncached I/O");

Why lose the internal error code?
If server implementation is wrong that is a good hint of what went wrong.
ETXTBSY is trying to mix cache mode and passthrough mode.
EBUSY is trying to passthrough to two different backing inodes.
I am not claiming this is a good API but at least we (or LLM) could do
something useful with this lost information.

>
>         WARN_ON(ff->iomode !=3D IOM_NONE);
>         ff->iomode =3D IOM_UNCACHED;
> @@ -173,9 +164,11 @@ static int fuse_file_passthrough_open(struct inode *=
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
> @@ -208,11 +201,12 @@ int fuse_file_io_open(struct file *file, struct ino=
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
> @@ -234,22 +228,10 @@ int fuse_file_io_open(struct file *file, struct ino=
de *inode)
>
>         if (ff->open_flags & FOPEN_PASSTHROUGH)
>                 err =3D fuse_file_passthrough_open(inode, file);
> -       else
> -               err =3D fuse_file_cached_io_open(inode, ff);
> -       if (err)
> -               goto fail;
> +       else if (!fuse_file_cached_io_open(inode, ff))
> +               err =3D fuse_EIO("conflicting passthrough open");

Same here.
If we can keep this bit of information and print it - it is helpful IMO,
even if we don't go all the way to annotate every error case with
a pretty log.

Thanks,
Amir.
