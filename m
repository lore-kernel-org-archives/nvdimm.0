Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CE84A3D25
	for <nvdimm@lists.linux.dev>; Thu,  1 Oct 2026 17:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790874591; cv=pass; b=B+qhlzxqF/Ym8rfzB5rywabLx/n3nJvimRQWB0UQS9ugZSRl82c11KI60EkEw0dqlA7IgElNu6qK65I05FvEzG0pqqlxnoIf///JTawSD8+WrsrwS4Xz4RTIyJ2FMWTn2h11K5SUZ+zIh6VMz+sCOvQePFntlIHXZK51uUnYXnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790874591; c=relaxed/simple;
	bh=8GH8/SsNfmtkhdpX79c0aQcCb3/XRb8OtTW5xDOS0oE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F+aLnJqofUKLPvMryjFTVUYdAv/oWT990lMzdbmRSHbrtBPU08ovM0Qy1pLd1YVWJsSCb2g6vA4ImmAMTc/spNUlYS3AuhNXFfuh4WgpDLm5IKY30kqczG3wFac8E69KuX78ZDa0PgRJvQODxR3hjcpn98TTJpjQEtq7aQzoQRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fSW2CM2W; arc=pass smtp.client-ip=74.125.228.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fSW2CM2W"
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6af7d408b51so646570a12.1
        for <nvdimm@lists.linux.dev>; Thu, 01 Oct 2026 10:09:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790874585; cv=none;
        d=google.com; s=arc-20260327;
        b=RmuTwNOINZ4X/tPr5PYHoA4W0M8+7zBl6hIKk3qF1o5XpaUROZRSgZRAhLpMT8Ij6N
         is8GbntgW3ygsbVlyDpadBD9+BdmT+K1HCJBDF5OvviBGFvqBoD/17L4iY9CYnilm56u
         NerTh/nfp27GS6NB7ZgXuiLcVBk6SVqr4tTePXPZOqYthxEoGm/BVJZuYVbHYUFNFXDI
         0m/pUwfO3vNaETRJa9uiXPgt/MBU4ccpa/m3xjsDyg+oFgzDvWAlImg1+uC/oWsT/VP1
         iEWkzWsCajNjxA6AcAzLklGHl2O8tVH/MuowobmL2SPF/Txf1AAb4J2UpNhzsIXncPr3
         R1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aLFtAFtsh0QtLKb/lJ9Aky55k7s033R21zc2oLJYS2s=;
        fh=d4JcH8/iCG+Wq2DAxVzZF8yWkYkRwqom4i06s2eKGF8=;
        b=iTFV590rW7vNxSVoLOablVs+HgpiGPNs936/b8UzS36fa+NSSH8v8YQhZgWQccJXw2
         rJiDgUIUYD6oaLtMAAcJ6DWIZjurncM8YLMgtiUtN6JMjBf3eBPWKbRFdDt3+N0cjFlq
         3h79o/XkwE355mUw4urtQKnQXJnYQNa3sA9dXpZYshEAkeacJafG9u5vxaICOC8Xd5CT
         d850kAa3W/l1xrY5alpEULtfJcOIc28snZ4FaLPJLSbh0/uKuu0BmrGfCetRvNu7g3aI
         /XMDSRnIFc43dpapi/cTpjOti5kAoYw+/NvV6S85YG15F5M2GU+84GzCAnnsYkZvjAqd
         Bm0Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790874585; x=1791479385; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aLFtAFtsh0QtLKb/lJ9Aky55k7s033R21zc2oLJYS2s=;
        b=fSW2CM2WsAyEkr5gB+NwhFerrKh3qCnC8ez6qatvyBc7psXDePo5k9SaCzjHxN0Er6
         3fb0sq56LImGr+R6Zx1Re4O9O2wE0fjctTEYGf67tzxdTXT5mnUbpVz7B9Yk8WvmNjr8
         8bKPPBZQlJEVUkfIgkKD68ZOArup3ICLU+ba3/NsLIPGHogL0+5I1U/nm2gtolYbxldj
         Hv7nDSi8HW3oxVg5eSaNco2BB7A1vV/4zUnx6agJ2tIiQuIyGpyf5mJeb13pus3I2Ozq
         aqBe3JuMYUXV8wnSMzbzt9eO6sPlSVZoS5I2rL6DEouzdfEOk+mVSrzXJvo6DVkkjZ/8
         k9kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790874585; x=1791479385;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aLFtAFtsh0QtLKb/lJ9Aky55k7s033R21zc2oLJYS2s=;
        b=ezqUP+4X+he4Dso1b49121I9WcgYuX1yWBpwRNQcQIfzs6fQY0/dZizqPWelq2EPpH
         P8+WqGIYnHNSdUFpTTDcNz8AFCDE+MiT2nExJ6ejb4WwOgGx9RMvqgir0kLwH+CqH7EB
         3/dRDFNPmjh38Kv2di6U4e9HeZIMc/tqNEvoENKFetE/komVayCxu7IQvEJHuuZ5nJ5V
         UjgeqbAAGOACQBhsYX44athpwFtKMp6ddbVnS0DiL9Eqg/YMTUSuiTrGPmLSsFI0AJRS
         m1APzljh28KDHnjiBXYWnPdDsE+/cFR/intd4+McpOxwFzXYvAo53rF+waTBmo7kp1EZ
         PhkA==
X-Forwarded-Encrypted: i=1; AKwUvByK38bA0ZiUozMRWICmOEUheWViLfa+K9L0n6U6GqgfrT9Pslsbb4KDEs083HObrN10wh669Mc=@lists.linux.dev
X-Gm-Message-State: AFq9FYLRL7stiL7Gj0fvghQURFFD7Fp6gbN/h36guJGMyXzqM489muAK
	mg/Cyasen91/6Asu/LjSubdx/tryxuMFtv4Zb/qVRsuxlmm16ibPfX+Iuu9konH9FlqQIvdIWy4
	r6WyOIEM8UISiUtYkRV69Fi/dRtBQPSYg6oEJUvw=
X-Gm-Gg: AYBFou1icqtzFmLWzfxyFKXZcOc+mgBwjG+FdoOzddrrlimBIJyL030DZlagSDxkcr+
	TymIZ5X2SYl9JhJ7/g073TjzC4njhy770+yaqlhY6gKVIfgqX6INl7pwkdlOVId/Vvc1sI7Vthn
	ZRADSN44ovRYgTU5v7Y1BG42z+c6NyhoaCeWnfeGzYOAaBTzOpmK4uDZy3M1ptT0wtYJ7/MI8lu
	M8bZosMyYr0Xa+pe8gal9kmqBlZE8SxUr7E6LKRv+dnSsn1Ft4k4/9VPWlksuuVF4CXiAOqgeXM
	3GHyJddrLxfZ+5xWy6OlO7dSThuf/iJ83a+nfqVkm6U/1u90lzKQZF3+
X-Received: by 2002:a05:6402:4342:b0:6ac:7d58:dbed with SMTP id
 4fb4d7f45d1cf-6ae3078464amr3051715a12.3.1790874585408; Thu, 01 Oct 2026
 10:09:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001150935.655979-1-mszeredi@redhat.com> <20261001150935.655979-5-mszeredi@redhat.com>
In-Reply-To: <20261001150935.655979-5-mszeredi@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 1 Oct 2026 19:09:32 +0200
X-Gm-Features: AclHuK9nuV0RaVWmbG-anRzzaRQN-OQPaWaI6T2wMRNbUW7396KBL-OwgCATbk4
Message-ID: <CAOQ4uxgyCo0-YAgwqu-3CAo+6hVOtSc9W1qJX5gZAz4YgpLM1Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] fuse: support opening 64 bit backing ID
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
> Add backing_id_64 field to fuse_open_out to allow opening files with
> 64-bit server-allocated backing IDs.
>
> When the server sets FUSE_BACKING_ID_64 in open_out.open_flags, the
> kernel reads the backing ID from open_out.backing_id_64 instead of
> open_out.backing_id.
>
> The open reply is now variable-length for backward compatibility with
> servers that don't send the new backing_id_64 field.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/fuse/dir.c             |  3 ++-
>  fs/fuse/file.c            |  6 +++++-
>  fs/fuse/fuse_i.h          |  2 +-
>  fs/fuse/iomode.c          | 34 ++++++++++++++++++++++++++++------
>  fs/fuse/passthrough.c     | 28 ++++++----------------------
>  include/uapi/linux/fuse.h |  2 ++
>  6 files changed, 44 insertions(+), 31 deletions(-)
>
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index f48fafccce4b..874ec7cfffb1 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -876,6 +876,7 @@ static int fuse_create_open(struct mnt_idmap *idmap, =
struct inode *dir,
>         args.out_args[0].value =3D &outentry;
>         /* Store outarg for fuse_finish_open() */
>         outopenp =3D &ff->args->open_outarg;
> +       args.out_argvar =3D true; /* compat */
>         args.out_args[1].size =3D sizeof(*outopenp);
>         args.out_args[1].value =3D outopenp;
>
> @@ -885,7 +886,7 @@ static int fuse_create_open(struct mnt_idmap *idmap, =
struct inode *dir,
>
>         err =3D fuse_simple_idmap_request(idmap, fm, &args);
>         free_ext_value(&args);
> -       if (err)
> +       if (err < 0)
>                 goto out_free_ff;
>
>         err =3D -EIO;
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 92976906ab05..1036c06fe35a 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -28,6 +28,7 @@ static int fuse_send_open(struct fuse_mount *fm, u64 no=
deid,
>  {
>         struct fuse_open_in inarg;
>         FUSE_ARGS(args);
> +       int res;
>
>         memset(&inarg, 0, sizeof(inarg));
>         inarg.flags =3D open_flags & ~(O_CREAT | O_EXCL | O_NOCTTY);
> @@ -45,10 +46,13 @@ static int fuse_send_open(struct fuse_mount *fm, u64 =
nodeid,
>         args.in_args[0].size =3D sizeof(inarg);
>         args.in_args[0].value =3D &inarg;
>         args.out_numargs =3D 1;
> +       args.out_argvar =3D true; /* compat */
>         args.out_args[0].size =3D sizeof(*outargp);
>         args.out_args[0].value =3D outargp;
>
> -       return fuse_simple_request(fm, &args);
> +       res =3D fuse_simple_request(fm, &args);
> +
> +       return res < 0 ? res : 0;
>  }
>
>  struct fuse_file *fuse_file_alloc(struct fuse_mount *fm, bool release)
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 003ef3c35d7a..59afebc3dd2b 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1314,7 +1314,7 @@ static inline struct fuse_backing *fuse_inode_backi=
ng_set(struct fuse_inode *fi,
>  #endif
>  }
>
> -struct fuse_backing *fuse_passthrough_open(struct file *file, int backin=
g_id);
> +int fuse_passthrough_open(struct file *file, struct fuse_backing *fb);
>  void fuse_passthrough_release(struct fuse_file *ff, struct fuse_backing =
*fb);
>
>  static inline bool fuse_is_passthrough(struct fuse_file *ff)
> diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
> index 1a10bc65fb31..811ea603b776 100644
> --- a/fs/fuse/iomode.c
> +++ b/fs/fuse/iomode.c
> @@ -160,7 +160,9 @@ static int fuse_file_passthrough_open(struct inode *i=
node, struct file *file)
>  {
>         struct fuse_file *ff =3D file->private_data;
>         struct fuse_conn *fc =3D get_fuse_conn(inode);
> +       struct fuse_open_out *outarg =3D &ff->args->open_outarg;
>         struct fuse_backing *fb;
> +       u64 backing_id;
>         int err;
>
>         /* Check allowed conditions for file open in passthrough mode */
> @@ -170,18 +172,38 @@ static int fuse_file_passthrough_open(struct inode =
*inode, struct file *file)
>         if (ff->open_flags & ~FOPEN_PASSTHROUGH_MASK)
>                 return fuse_EIO("conflicting open flags");
>
> -       fb =3D fuse_passthrough_open(file, ff->args->open_outarg.backing_=
id);
> -       if (IS_ERR(fb))
> -               return PTR_ERR(fb);
> +       if (!fc->backing_id_64) {
> +               if (outarg->backing_id_64 !=3D 0)
> +                       return fuse_EIO("64 bit backing ID set");
> +
> +               backing_id =3D outarg->backing_id;
> +               if (backing_id <=3D 0)
> +                       return fuse_EIO("invalid backing ID");
> +       } else {
> +               if (outarg->backing_id !=3D 0)
> +                       return fuse_EIO("32 bit backing ID set");
> +
> +               backing_id =3D outarg->backing_id_64;
> +       }
> +       fb =3D fuse_backing_lookup(fc, backing_id);
> +       if (!fb)
> +               return fuse_EIO("backing not found");
> +
> +       err =3D fuse_passthrough_open(file, fb);
> +       if (err)
> +               goto backing_put;
>
>         /* First passthrough file open denies caching inode io mode */
>         err =3D fuse_file_uncached_io_open(inode, ff, fb);
> -       if (!err)
> -               return 0;
> +       if (err)
> +               goto passthrough_release;
> +
> +       return 0;
>
> +passthrough_release:
>         fuse_passthrough_release(ff, fb);
> +backing_put:
>         fuse_backing_put(fb);
> -
>         return err;
>  }
>
> diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> index 313c8d7ffc09..4894842ad6d0 100644
> --- a/fs/fuse/passthrough.c
> +++ b/fs/fuse/passthrough.c
> @@ -150,41 +150,25 @@ ssize_t fuse_passthrough_mmap(struct file *file, st=
ruct vm_area_struct *vma)
>
>  /*
>   * Setup passthrough to a backing file.
> - *
> - * Returns an fb object with elevated refcount to be stored in fuse inod=
e.
>   */
> -struct fuse_backing *fuse_passthrough_open(struct file *file, int backin=
g_id)
> +int fuse_passthrough_open(struct file *file, struct fuse_backing *fb)
>  {
>         struct fuse_file *ff =3D file->private_data;
> -       struct fuse_conn *fc =3D ff->fm->fc;
> -       struct fuse_backing *fb =3D NULL;
>         struct file *backing_file;
>
> -       if (fc->backing_id_64)
> -               return ERR_PTR(fuse_EIO("incompatible backing version"));
> -
> -       if (backing_id <=3D 0)
> -               return ERR_PTR(fuse_EIO("invalid backing_id"));
> -
> -       fb =3D fuse_backing_lookup(fc, backing_id);
> -       if (!fb)
> -               return ERR_PTR(fuse_EIO("backing not found"));
> -
>         /* Allocate backing file per fuse file to store fuse path */
>         backing_file =3D backing_file_open(file, file->f_flags,
>                                          &fb->file->f_path, fb->cred);
> -       if (IS_ERR(backing_file)) {
> -               fuse_backing_put(fb);
> -               return ERR_PTR(fuse_EIO("failed to open backing file (%ld=
)", PTR_ERR(backing_file)));
> -       }
> +       if (IS_ERR(backing_file))
> +               return fuse_EIO("failed to open backing file (%ld)", PTR_=
ERR(backing_file));
>
>         ff->passthrough =3D backing_file;
>         ff->cred =3D get_cred(fb->cred);
>
> -       pr_debug("%s: backing_id=3D%d, fb=3D0x%p, backing_file=3D0x%p\n",=
 __func__,
> -                backing_id, fb, ff->passthrough);
> +       pr_debug("%s: backing_id=3D%llu, fb=3D0x%p, backing_file=3D0x%p\n=
", __func__,
> +                fb->backing_id, fb, ff->passthrough);
>
> -       return fb;
> +       return 0;
>  }
>
>  void fuse_passthrough_release(struct fuse_file *ff, struct fuse_backing =
*fb)
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index c88d7094af44..60fb2add5e12 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -254,6 +254,7 @@
>   *  - add FUSE_PASSTHROUGH_V2
>   *  - add FUSE_DEV_IOC_BACKING_CREATE, struct fuse_backing_create_in
>   *  - add FUSE_NOTIFY_BACKING_REMOVE, struct fuse_notify_backing_remove_=
out
> + *  - add backing_id_64 to fuse_open_out
>   */
>
>  #ifndef _LINUX_FUSE_H
> @@ -841,6 +842,7 @@ struct fuse_open_out {
>         uint64_t        fh;
>         uint32_t        open_flags;
>         int32_t         backing_id;
> +       uint64_t        backing_id_64;
>  };
>
>  struct fuse_release_in {
> --
> 2.54.0
>
