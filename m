Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06CD38A739
	for <nvdimm@lists.linux.dev>; Tue,  6 Oct 2026 22:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791324543; cv=pass; b=h3a6hKco6sKhSW7+Thk3yQ+c4SXl+d11dRPibjzpN3y/oCWVAAblQZeGniki360sjieEFWCTIWhf/mM6h+VDCXnqXdh/iIVjgkJvQND0K1xdSRQvOLuiTogK13/6afJwgLs7F/W9g+GpFFw0gY3uT+FJYAXZPzq58xI8lTmp4wU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791324543; c=relaxed/simple;
	bh=FVulpAnYmlaz6ZGBqEF0kXcLNEDT1/mgk/OAXn/LvVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ta7xWxDMkijj4xRJyK08MLAqFHdysmM4OoiSMmEusK4XXDacYS3PTMi2UcyvJOaF00C5fFM9UMM7XHDkZXekix1CfwNcujYfOgBcXwM7RNmgUYa7ZfaQA6QbW8FQREVen9DeSR3Scv7vG3e7VRacvNEofELaG7ZeDs/1e4n2G0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aCAKsNoE; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aCAKsNoE"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6ab006eb282so4979581a12.0
        for <nvdimm@lists.linux.dev>; Tue, 06 Oct 2026 15:09:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791324539; cv=none;
        d=google.com; s=arc-20260327;
        b=IoysjELQczgMKaWwY2xbYs5cgVww6f9kxZhLqFMDf7ZkAd8S81Ij6upvDMjXvy3dss
         UL9TqC1Vc0hLXPhS39bb80CfHYwO61wyJcTPMeXRcrwMuvmAZ7Gcy9a9sCEal9zjjU0S
         NjjT66gfIdvK5nsBcVD3F6JG5ENz1KjV1f6GpJYnl/QJiC18b9zlB+NspzupbAX1ERfQ
         iLdRaLRKhKZnnDhzpfCtbw2Wjkr5XOvL7q7W5Z6b0Ru8nSOHjNBlERWGrigLsAcTxvO4
         ro6KSMpWRFPOHm+cmlv77zCVEi/jLyZ2CJARqrlotTMClnPr24h3T1OQueOy3snexSN/
         Favg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1Vo8bv/Mw9ldCtrjaA+pK24JIKyIXZlS7hf38pMZ204=;
        fh=K9GA38GbRf1wcSpe2eMnZpNTjONzzHu+Ab4vJiobTQs=;
        b=MwYuEzh5jt1S9sEX1gNDiDBcF1KkC19SKNu1LychXaCAxP69NIXJnOXQF6XUU99LNs
         4aTIodcS2AoSZJuqU3p6MpKPRQZoJeo8qWFNZFAi4AuArTywl7LYDm19GFvRXTTGFhlh
         WIk57o/KLbPWYdFoQEnzYNFzDZSO6hPmEkXfKMcdAOBHMP8N5o+J8purxUhyA/NwhuAP
         EcgdpL5z9gThoGYBUvcSejcPzlqEWthkbAKrHc5T2us492c80mwq1WPcuC3NTimeDEZa
         y9Zs9c4gf/6/jnUVZUoMA8RUcnjVgbv7Atp+3lJSso1PlXOv0hbtBRdxzctJm0opxS6s
         MyPQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791324539; x=1791929339; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1Vo8bv/Mw9ldCtrjaA+pK24JIKyIXZlS7hf38pMZ204=;
        b=aCAKsNoEkJ3jN4oRHf14V6igtFlUpMczxJRXeUBBwi4rg+77HVvQEjxMr0EYA9fG0z
         oy3+UQnQS4U4MP2/D/tWgtRHMVzncNSgZXFD+/Q2DHMGErR1Q5cguLBkosRP2K1MRG7l
         vOgjCtGeDfuYU7DgWZ5K+KaexkWj1MLFHYCddy46dEQ0UXoThL7DJM2KkhoLq+PctxbV
         V/lnoJsHvP/lJyDCwONuCm9u1cqtTPixp++gc1wbNJOwOQHGyPK9ypbgBt9B3yzEOrSW
         zJ8igvoxreGkgPU0pUBoaxVaU2C/WbUFl5KkG7Xe2rVZ5VAI7VgUEDOhDQkXSM9nFyRj
         ZQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791324539; x=1791929339;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1Vo8bv/Mw9ldCtrjaA+pK24JIKyIXZlS7hf38pMZ204=;
        b=X9Jl9POB1km7ztYAZP96oJCO4uBxe7SYheJ1+Yl2lN8hR0YWq4IdRu4wsN7AEIvNo+
         YUrnmEiEFU/emoqhCgomHBUbBJfSghrVh5bzxwi++ODZymINtvfPuSaG05gojZYOYYLL
         VBfYi0eOsvxtO8iMQ9UXpwL8K/fcGU3xQ41JxDZfZmehNnyw/KC4nob8C/OmhgQ3A9Tq
         fH4QYYHKsXWSMjoBZNITHPJcZbqzRpROZMKlEyDZneR4sku07fATBnodlWaGKA5FzY5K
         Qyks22y4f0VGra4F/OSNIIPi6/kckoK/DlLrJcyHL0cFandDHCcktTR1wtoQPGll0VLg
         gmMw==
X-Forwarded-Encrypted: i=1; AKwUvBxG0V7yovqJ5USKVMjarFqp9mHXe5p8REihJIpsYannMZxPzWNjsaoe91Ei0OUEWbJjc+EMBec=@lists.linux.dev
X-Gm-Message-State: AFq9FYLK/jIxYwPAMtA5UiwtU4c2zYPzSEvBsW+KJob85EG+T0mriq5o
	dX+3f+5NxD0snMFqej08av8O1r1zL5hPyxg3UToBIR601aCH2e4aQBluBqeTmInqDCgjSGwUm1i
	CJ9LgyeIzFKuAAAtlj7BuNifeWPoyraQ=
X-Gm-Gg: AYBFou0+d+xktttr3BccF8M8dJdvQ8ZK5q5R9C2lUIyP8T5L+8u6BkiFq5w5WDUP4/d
	w8hiFaIrpbm9xe3NJDlP7K47KL9haKi12HsUkIjNVPdvmGyhILl9bp0/QnwFSRiYepS4/mZUg/8
	L8yDgKEvIYU1dE4f7ExihnnfZ1yDdaZ8NVvePMJGulW0TmzVuFh4AYSW+FY7UgkAZRuqY4PSAJ/
	wYf3YkA50BNL9gDJ2hN8myR5vMce3uNnwsYWJi/4es33dnoyBEvLt4x8oWM1zcTx+0DiwERHoc8
	W92VIAr73CLNROlseBhoVpr+D9Mux4POJ6pIaQoRfGlYsdzDsWFpBE/GOmbYVLcgKPhRNn02yR9
	7EH6JmkHlDhM=
X-Received: by 2002:a05:6402:51ce:b0:6af:bd48:4b2c with SMTP id
 4fb4d7f45d1cf-6aff2daf769mr405047a12.5.1791324538890; Tue, 06 Oct 2026
 15:08:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261006180115.1425232-1-mszeredi@redhat.com> <20261006180115.1425232-5-mszeredi@redhat.com>
In-Reply-To: <20261006180115.1425232-5-mszeredi@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 7 Oct 2026 00:08:46 +0200
X-Gm-Features: AclHuK-kNEGr89TsaMC-r6qkBAXhNslF5fmkkNhAIDRFq3AWhso05mVTqiKMWVw
Message-ID: <CAOQ4uxjRAgNKEKOj3yrh0fp_uBdQ-G=5C55G6M8vyjWgp2zvoA@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] fuse: support 64 bit, server allocated backing ID
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
> Add support for server allocated 64-bit backing IDs alongside the
> existing kernel allocated 32-bit IDs.
>
> Opened with FUSE_DEV_IOC_BACKING_CREATE, the backing ID sent via
> fuse_backing_create_in.backing_id.
>
> Closed with FUSE_NOTIFY_BACKING_REMOVE.  Since close only provides the
> backing ID, not the file descriptor, it doesn't have to be done with an
> ioctl.
>
> Backing ID can take any 64 bit value other than zero.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/fuse/backing.c         | 179 ++++++++++++++++++++++++++++----------
>  fs/fuse/dev.c             |  24 +++++
>  fs/fuse/dev.h             |   3 +
>  fs/fuse/fuse_i.h          |  24 ++++-
>  fs/fuse/inode.c           |  15 +++-
>  fs/fuse/notify.c          |  28 ++++++
>  fs/fuse/passthrough.c     |   3 +
>  include/uapi/linux/fuse.h |  22 ++++-
[...]
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index cbb10e19e7e8..b5b51865d59f 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1408,13 +1408,24 @@ static void process_init_reply(struct fuse_args *=
args, int error)
>                          * them together.
>                          */
>                         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH) &&
> -                           (flags & FUSE_PASSTHROUGH) &&
> +                           (flags & (FUSE_PASSTHROUGH | FUSE_PASSTHROUGH=
_V2)) &&
>                             arg->max_stack_depth > 0 &&
>                             arg->max_stack_depth <=3D FILESYSTEM_MAX_STAC=
K_DEPTH &&
>                             !(flags & FUSE_WRITEBACK_CACHE))  {
>                                 fc->passthrough =3D 1;
>                                 fc->max_stack_depth =3D arg->max_stack_de=
pth;
>                                 fm->sb->s_stack_depth =3D arg->max_stack_=
depth;
> +                               if (flags & FUSE_PASSTHROUGH_V2) {

Since I was contemplating myself on whether I should also add an init flag
FUSE_PASSTHROUGH_INO, it occured to me that arg->max_stack_depth
has plenty of spare bits to host FUSE_PASSTHROUGH_* feature flags.

So if we rebrand it as arg->passthrough_params

#define FUSE_PASSTROUGH_PARAMS(max_backing_stack_depth, flags) \
             ((max_backing_stack_depth & 0xff) + 1) | ((flags & 0xff) << 8)

We could use a feature flag  FUSE_PASSTROUGH_SERVER_ID_64
instead of wasting another init flag
It also avoid the unneeded questions/documentation/awkwardness
regarding FUSE_PASSTHROUGH_V2 with/out FUSE_PASSTHROUGH

But mostly, it leaves room for more extensions.

> +                                       /* Prevent race with fuse_backing=
_open() */
> +                                       scoped_guard(spinlock, &fc->lock)=
 {
> +                                               if (fc->backing_id_32)
> +                                                       ok =3D false;
> +                                               else
> +                                                       fc->backing_id_64=
 =3D true;
> +                                       }
> +                                       if (ok)
> +                                               fuse_backing_files_init_6=
4(fc);
> +                               }

See my comments on backing_id_32 gating on the v2 patch.

Thanks,
Amir.
