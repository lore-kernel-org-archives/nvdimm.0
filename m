Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03F62F7CE8
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 07:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751615714; cv=none; b=gYH8w84vMLkSySMzkA11Q/o5U60VzKJZG68Q7qgR8cB46qNYwAhA89Dc3ZXqdqVeL3LhQZX4OpGclfGmi0eNoSh1S98iGPxUxT9YSTAhiOIqwzuPqf3ofiLw4sEBaONI6GCEWlK5WvMbqqn3RUdR/rLbfkYS5TccVO+pxEofw/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751615714; c=relaxed/simple;
	bh=g5Qwv3E6Y5AzhAoHAIoso2lcbLsyKVgZSLviisDZlBk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jATNYNTAgNfmLAWaduQMLSEE3x27cT/5Wzo/tDBkz9OF4e3oE775Hr6S1oyFJ/6ytmJp+sd92JfKRYtUadnxmI0H11MbxI/rgD1B2TYIrYKpIgjB5PgiH+qOVJpEaSakOgYd8ySBbwUrMXg30fuEU61V7lywe3S+ZlPb5Xwx68s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MghbLrbh; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MghbLrbh"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ae04d3d63e6so110045966b.2
        for <nvdimm@lists.linux.dev>; Fri, 04 Jul 2025 00:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751615709; x=1752220509; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KqTjHtFUDnwHiahJgAdrD1pVSqjrxzaMh3NEMJveZz8=;
        b=MghbLrbhF876LQpFE+vDqaVQ86kEofgRLzGwlThPMqPpy1Mv0alifQ5zF13esFPPgF
         AsAYK6gO8rHDz9YQ3CmLYbBWPMeo9v67Ws8AuZAHRlDf0xfGobui0IcJ8OmAyV57pqLi
         Tuqcyh8LoS08kWjHXI8MQmKWVWf9cmdUqpLuSv3Rz6ivaHOechl0QcGz+0i1cCxgxMN+
         TvZWDpeWq1X/JFjpNL2aKmlNArjNicVkPt8YxHTSeXEkSw/INGp2YLKRQgjp6D0Ji6sy
         91SFRfBnm53KoJZLfj5Fdli0gU2Ub0PZ0ECF/sOus/zs1/5crQD0Fr9K04UGFgpboIWW
         bryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751615709; x=1752220509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KqTjHtFUDnwHiahJgAdrD1pVSqjrxzaMh3NEMJveZz8=;
        b=wYittycP4GL0zyQv8XlnQgzpdqgfu14rNZmNqBj9IIWnNwJIInK4/oLKn1i0GDleBq
         NTMs1muwsP+D8yyQ5mfFHIZHrNY1/pd9JsBodb2LWFmDLkbd3KA9QjUHeetKmxooL2/n
         I+PFAtur5Bw/xTAtoaaodxEiZZt7VGGy+4QVKRsi+q1YQQgfZDwVAnzthKexnWy5j04v
         BolDgR9tK0J+tqO26ymjk5gaYZsGx6PZPrmv15RnQxYUJGPdWowspSqmZ4nAIvPDMUrq
         TQ47mTZBwBrXDukRQvIWbiqKJS4v8+16zvOFmgLSfCp725SC7MludndOs2B9O6Gy4Ecv
         Cu8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVLqAyvWsic3v7QgVHf+Xvh16rS1h0pdeJYcnfS5hQx1ZF93EKsjVADBnM3DBgAY+xzmf21DCs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwadZ6i6tK7Fcn51BDyWYqbx3QbjSCag3EAYEtbJc/jjXzZu6dT
	4e2ja0I69RLvW+9OvACpTFIsPgmhbf8PFAaGRRjDMhriBnlYaJP2/gQCpt9H1ivUyL7SHYdcuAO
	2os+ZChn6zR4EFg2KKpPNTb68mU6LjbQ=
X-Gm-Gg: ASbGncs1asmAFhwdGaElnRB85cq9BM79WXsVVz84CxCwfIqlY+QZ8aoGi04KjKryGt8
	leoc8Z+KJVkxWKPi5YT9oY7cspfxrwIGI6RhmV5qlHmncSzyFSuV+e6lK8JZ9SDkzF8ZiCzPcUV
	zEOWYDH8cm8dBqQOyt0qdzmgAWp6EMwIHz9qTFM4/Iw+DHfvSrcBUbWw==
X-Google-Smtp-Source: AGHT+IHbu/7trC65/DeYLqxtEkSBbngCiJCl8lGS3daoUK+l03S1ER+X1QI0bHRXSoe9V0uZOz3GBHDUIYUYwFgLXPA=
X-Received: by 2002:a17:906:681a:b0:ad2:417b:2ab5 with SMTP id
 a640c23a62f3a-ae3fbde92a2mr99463566b.60.1751615708510; Fri, 04 Jul 2025
 00:55:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703185032.46568-1-john@groves.net> <20250703185032.46568-11-john@groves.net>
In-Reply-To: <20250703185032.46568-11-john@groves.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 4 Jul 2025 09:54:57 +0200
X-Gm-Features: Ac12FXx2fL6cg_25gbv1TfaaBei9pa2nMH_xl-QIp40xf5dKMB13gicr8ctumWk
Message-ID: <CAOQ4uxi7fvMgYqe1M3_vD3+YXm7x1c4YjA=eKSGLuCz2Dsk0TQ@mail.gmail.com>
Subject: Re: [RFC V2 10/18] famfs_fuse: Basic fuse kernel ABI enablement for famfs
To: John Groves <John@groves.net>, "Darrick J . Wong" <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Miklos Szeredi <miklos@szeredb.hu>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 3, 2025 at 8:51=E2=80=AFPM John Groves <John@groves.net> wrote:
>
> * FUSE_DAX_FMAP flag in INIT request/reply
>
> * fuse_conn->famfs_iomap (enable famfs-mapped files) to denote a
>   famfs-enabled connection
>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/fuse/fuse_i.h          |  3 +++
>  fs/fuse/inode.c           | 14 ++++++++++++++
>  include/uapi/linux/fuse.h |  4 ++++
>  3 files changed, 21 insertions(+)
>
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 9d87ac48d724..a592c1002861 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -873,6 +873,9 @@ struct fuse_conn {
>         /* Use io_uring for communication */
>         unsigned int io_uring;
>
> +       /* dev_dax_iomap support for famfs */
> +       unsigned int famfs_iomap:1;
> +

pls move up to the bit fields members.

>         /** Maximum stack depth for passthrough backing files */
>         int max_stack_depth;
>
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 29147657a99f..e48e11c3f9f3 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1392,6 +1392,18 @@ static void process_init_reply(struct fuse_mount *=
fm, struct fuse_args *args,
>                         }
>                         if (flags & FUSE_OVER_IO_URING && fuse_uring_enab=
led())
>                                 fc->io_uring =3D 1;
> +                       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
> +                           flags & FUSE_DAX_FMAP) {
> +                               /* XXX: Should also check that fuse serve=
r
> +                                * has CAP_SYS_RAWIO and/or CAP_SYS_ADMIN=
,
> +                                * since it is directing the kernel to ac=
cess
> +                                * dax memory directly - but this functio=
n
> +                                * appears not to be called in fuse serve=
r
> +                                * process context (b/c even if it drops
> +                                * those capabilities, they are held here=
).
> +                                */
> +                               fc->famfs_iomap =3D 1;
> +                       }

1. As long as the mapping requests are checking capabilities we should be o=
k
    Right?
2. What's the deal with capable(CAP_SYS_ADMIN) in process_init_limits then?
3. Darrick mentioned the need for a synchronic INIT variant for his work on
    blockdev iomap support [1]

I also wonder how much of your patches and Darrick's patches end up
being an overlap?

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20250613174413.GM6138@frogsfrogsf=
rogs/
