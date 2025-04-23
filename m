Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFA825F7B4
	for <nvdimm@lists.linux.dev>; Wed, 23 Apr 2025 01:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745372183; cv=none; b=OKngHdhsdePmduxAzMByht+b1Wb00HzSn7vLFyMlwzPGgUq3JFwPFN2oQj82PSN/PVPlF25OUHG2gHPtHhrAhqECppmj7OFi+qHbiaDpzpcYexEQrqLH9IUvWIXctZQlzgPkqwUozEHstio8bZ0+slTqhjZGV9NTXQIV502pebM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745372183; c=relaxed/simple;
	bh=UNUzIQyqmwpZ9sBm60WtCTjqwiWikkrXeZHbhkw7c8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fBv59uwduvHfYY+txEAAdlIwZZjr+qo9+5rCzCHodggQsEi2WTRV/VvEALfQA+NkmX4L2ga5fRjAc1rVaCOIB69BW9IeDT9ndSRrD17nBsbws1u3uUIfgAtvRSIk2IggUINdUCOKnYV8wuIjL74Kp+8C3u5rVyxTG2C5PY663zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RSS31uSO; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RSS31uSO"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-47691d82bfbso109904041cf.0
        for <nvdimm@lists.linux.dev>; Tue, 22 Apr 2025 18:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745372179; x=1745976979; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YDT0JiTKLEu56zROMSHzh4vPHYYpIB515ncCYLjb8lQ=;
        b=RSS31uSOpyKZjHs7i7jN39W3v+h8ew1OjUbS70VbG5g7ZGaZxLN9CsGVwB4Vz+dBGI
         HWpbH+UR5mNRFdrXec/4LkhgTtgvYCEx0HDnTEoOquZ2roiMkQuR1JfemxU5RPs2wi2P
         R75ZkqxivOid66u0XVAf0rB8Q/dXMsIGt6WYwEPNMsUuBXEqfeymF3b9O/Z8nOXbmFv4
         CYDX9SWqrD3Obol8QqI7LuM49SklEqFqlgEeTQ01IVCOiys5CgqBriR+nfytf4ofwcmh
         ATphlz/63Cd6E3qZNPLYCDEfnrPpGDYPViXKt/ChY3YOK1M1AeHb58ys063JAyYy+FSy
         0Wwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745372179; x=1745976979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YDT0JiTKLEu56zROMSHzh4vPHYYpIB515ncCYLjb8lQ=;
        b=QIuIJGEn/voSwQ5Bhi2m3MXT8GjAFG6OsU6ljW0p0OZ4uMfR/uVJbeeY+IWICtKl5w
         gVmzc4/rQPKLdwFb1t3OTiqvKibOtlkv2ts41y2YrRT0o2b1bI2UzF1oVggZtvQqKmAf
         coyC7iqCKi9ZMM2gciR1DzpNSq1S8ihYp4iIzztIKN4s9jWZjbpz0ku31WLO3oin5Nrk
         iLLWB0V+XQiFWZxsNAc/TqN4JPMQ6mFt05Ic3xO/Kqp84q7Y252fsJHGvpDH/JU4jyiI
         jeTXaVUsNhTGnaDRz/glx9exUzOsh6KEdEvBWRcDUAErHUps/biC4U2+REFezGMRHVKE
         5Rng==
X-Forwarded-Encrypted: i=1; AJvYcCW4RML5gbOPjiPw7Kc8bJlrT5j7CACtiV8CqNTHiC2FZjNsZs1mphTWMaE5oUCkzXyRCLnC2zo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwvQ956tSLKEUxbajgzKlih97MjTud56Sr8IOD0+w9g+vWawPkL
	hhJ/8GtaWVQIEZ9sjNyCzf/SE5IoN0R8x7Nh9xuWi0XAkKWgUZ7Fu7kRvVti/EuGyznV86pbwa0
	bpYl1UZClayWD2thSmqdwOupbFyw=
X-Gm-Gg: ASbGncvNqEdEaa4HLoL/pCaKOUeILnMLSmkzIvV6H3FTKgGJTeLsat2gbemj4gHNePU
	LlNjXv1XIp3kS4jEoJxyQsWenW4kIuzDUXooE2RXcLDt08nv19Lweo66Rt5yvenVTH2SBEgpJGq
	T9H8zLGRvwFOw1O9X3LCgcUBUrXWoqIUKHRIiPmXxe3Mwww3mu
X-Google-Smtp-Source: AGHT+IHlzbvrCevbApD7jzszD6VGDVewMdGYPbCuvZGd+5reLhfdOJmEbpvrMu7I8oAOdE1MkMv/KOclzr8B5UZ2tug=
X-Received: by 2002:a05:622a:2c1:b0:476:8a1d:f18e with SMTP id
 d75a77b69052e-47aec49fef3mr297955681cf.36.1745372179161; Tue, 22 Apr 2025
 18:36:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250421013346.32530-1-john@groves.net> <20250421013346.32530-11-john@groves.net>
In-Reply-To: <20250421013346.32530-11-john@groves.net>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 22 Apr 2025 18:36:08 -0700
X-Gm-Features: ATxdqUG7M4Ilbi4JBAoLnTSvKlGK4nbtG_HG8a5cZaDG6t4Rd0KpBRJjL7Ttc8I
Message-ID: <CAJnrk1aROUeJY2g8vHtTgVc=mb+1+7jhJE=B3R0qV_=o6jjNTA@mail.gmail.com>
Subject: Re: [RFC PATCH 10/19] famfs_fuse: Basic fuse kernel ABI enablement
 for famfs
To: John Groves <John@groves.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Miklos Szeredi <miklos@szeredb.hu>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Luis Henriques <luis@igalia.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Petr Vorel <pvorel@suse.cz>, 
	Brian Foster <bfoster@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 20, 2025 at 6:34=E2=80=AFPM John Groves <John@groves.net> wrote=
:
>
> * FUSE_DAX_FMAP flag in INIT request/reply
>
> * fuse_conn->famfs_iomap (enable famfs-mapped files) to denote a
>   famfs-enabled connection
>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/fuse/fuse_i.h          | 3 +++
>  fs/fuse/inode.c           | 5 +++++
>  include/uapi/linux/fuse.h | 2 ++
>  3 files changed, 10 insertions(+)
>
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index e04d160fa995..b2c563b1a1c8 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -870,6 +870,9 @@ struct fuse_conn {
>         /* Use io_uring for communication */
>         unsigned int io_uring;
>
> +       /* dev_dax_iomap support for famfs */
> +       unsigned int famfs_iomap:1;
> +
>         /** Maximum stack depth for passthrough backing files */
>         int max_stack_depth;
>
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 29147657a99f..5c6947b12503 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1392,6 +1392,9 @@ static void process_init_reply(struct fuse_mount *f=
m, struct fuse_args *args,
>                         }
>                         if (flags & FUSE_OVER_IO_URING && fuse_uring_enab=
led())
>                                 fc->io_uring =3D 1;
> +                       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
> +                                      flags & FUSE_DAX_FMAP)
> +                               fc->famfs_iomap =3D 1;
>                 } else {
>                         ra_pages =3D fc->max_read / PAGE_SIZE;
>                         fc->no_lock =3D 1;
> @@ -1450,6 +1453,8 @@ void fuse_send_init(struct fuse_mount *fm)
>                 flags |=3D FUSE_SUBMOUNTS;
>         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
>                 flags |=3D FUSE_PASSTHROUGH;
> +       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> +               flags |=3D FUSE_DAX_FMAP;
>
>         /*
>          * This is just an information flag for fuse server. No need to c=
heck
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 5e0eb41d967e..f9e14180367a 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -435,6 +435,7 @@ struct fuse_file_lock {
>   *                 of the request ID indicates resend requests
>   * FUSE_ALLOW_IDMAP: allow creation of idmapped mounts
>   * FUSE_OVER_IO_URING: Indicate that client supports io-uring
> + * FUSE_DAX_FMAP: kernel supports dev_dax_iomap (aka famfs) fmaps
>   */
>  #define FUSE_ASYNC_READ                (1 << 0)
>  #define FUSE_POSIX_LOCKS       (1 << 1)
> @@ -482,6 +483,7 @@ struct fuse_file_lock {
>  #define FUSE_DIRECT_IO_RELAX   FUSE_DIRECT_IO_ALLOW_MMAP
>  #define FUSE_ALLOW_IDMAP       (1ULL << 40)
>  #define FUSE_OVER_IO_URING     (1ULL << 41)
> +#define FUSE_DAX_FMAP          (1ULL << 42)

There's also a protocol changelog at the top of this file that tracks
any updates made to the uapi. We should probably also update that to
include this?


Thanks,
Joanne
>
>  /**
>   * CUSE INIT request/reply flags
> --
> 2.49.0
>
