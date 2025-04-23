Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF8E1A5BA4
	for <nvdimm@lists.linux.dev>; Wed, 23 Apr 2025 01:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745373086; cv=none; b=GnUcGQrfd/RmtTaNumSB3DX9zWRRRse/S8Ys3+aJi/EzZLLIm4wH/NounWC3HFfnsFtlwDlsWDo4nv/dLsLyt/BN1Frcqb+PMXmdNiBtgjqJgWlvz6FZrk2uDLAEqbD7cvnT60uDtbRrROi/RjrLDza6e6zDGpqyLz/bdKjBjCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745373086; c=relaxed/simple;
	bh=f9OSiZEkGRM8hlEdi98DC9VjgWWwvAUcHUnbYzed8hE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tW4eJJosJk1BV8mVMLjdMwKY1xIY3Su50HOmH2Shlc38lum/O1fVJ5+XY0NxSdydWIFdvNtYwWBwwLIm18Rre2pBEJQFeVj3+onWdhitjpZ6/qBMhDJeaLwtiS6HJUjW5iQhy2wB81bUhdwKlY7IP5qlM6Ujkq7O4XAeMnIDALU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cpaC6so4; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cpaC6so4"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4774ce422easo63488161cf.1
        for <nvdimm@lists.linux.dev>; Tue, 22 Apr 2025 18:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745373083; x=1745977883; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z39QQvICDFu+xZrg0TEybs+EUUza3WdIUdzlBs09FsI=;
        b=cpaC6so40Qqu5jdx1MaAlXA+lERDILV4asOkPc+LmDeAb8KMoxf+wnfDgPKvx0kRLY
         bg9js1fota09C2OlBuXi9qC94I7+626KrMnlsJOkgmDbvDoBdbMGi5Eu4KXAFhQwugHv
         Mj/gLgmXFCCtM4aLWqPhrb5tfPCMATBTGqw8TVUUJ+G/wVsSPjcH6ZCmclEqNd8wt1S1
         p37q3JITT91L1oaBO95HElkPwSL9WQVPMICl5XUzpG5tKCrnt0KeGHWuUenls9N57O45
         WPCuQcFd62fAZfzRekBT/OgBbBy4vUFtJjhxdMf4QMMkJnLdQJuFwrCLGO7kaOFZX7GA
         ParQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745373083; x=1745977883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z39QQvICDFu+xZrg0TEybs+EUUza3WdIUdzlBs09FsI=;
        b=j5nns9iJEvx7pz/jjv94HAmZ0mSpFwAexB0zUoays0vILP9cijFdsj/F/ryQNeweSr
         8I6nKbGAPl/odcJb8rGQY6Aoab6mAIebh1mukdjy+XYZwSPJ485r8uCAQ2/dP9AFHfho
         u3GwUk1phclPTrRE0CTxBHZFuQbMLmaLFViiBc7i9M3Z+PuxqDGcrHc1hwz0t/dsqKki
         IndRyO8n274ibOUwI/s55mVc8C5TtMKIx1R80skrilDZIdMm7zWmKsALPYKFL7W7lktI
         QmzVHRQpzH+rJzM70BVoF8D4HwCTawYAqvGCyjfACEf1gBNvcDcKuB4I8fnQsw6xwNbl
         FFbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUT03UvhnwDgtg/aYNeD0wT+IgbE4mrivvU7cy+9OY2PCaTU4uiv1+fC+EiK4RDkbyqxUj/lm8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVXTeVRSmqNlnBmv6G8fxiY0WEK/Fm3an2t8wt5TZIG8ysvtWi
	WaNWWg3jyXS5cOQLQcxRRYMpmAcA0vvYoWJ/U3xilGqGBJBzyVy4/WJNbpQpb6xwhNEdRqKHBF9
	tDB0ZUMViYTmo6OaycyrJhr6+XpI=
X-Gm-Gg: ASbGncu7sEtyrXN2uBpouRe8QWKC6nJsk5WqxfgnhNx5WFjRHb1W9aeUr5l82CaCua/
	tvFgWzlx3yfw7vmysPH6XYjiZYLPAYT0kv5MY0QAmr2VStbqTjxAHLYBcEtFt4h3BxY7ttj1rid
	C4H/b0VrVguvf8m03TaTapulAIR6+AiUCEHNzMdQ==
X-Google-Smtp-Source: AGHT+IGa0a0bVLKb/erjEsreWfYBSqscLweitgoP5Ba4+oUKUug/Cv0Q/3GZtabetwmezZbq4TBf+wcWs/4RZE84VeE=
X-Received: by 2002:a05:622a:1388:b0:474:fc9b:d2a7 with SMTP id
 d75a77b69052e-47aec39a3a6mr276212621cf.6.1745373083515; Tue, 22 Apr 2025
 18:51:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250421013346.32530-1-john@groves.net> <20250421013346.32530-12-john@groves.net>
In-Reply-To: <20250421013346.32530-12-john@groves.net>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 22 Apr 2025 18:51:12 -0700
X-Gm-Features: ATxdqUHH_imdRr9soL9xq2F-DrMbo1uaH4JTwu64XFNIVCAtRJarimtzdncDBPM
Message-ID: <CAJnrk1a40QE+8q-PTTP6GgpDO9d9i_biuN8zk-KSEEiK7S34kA@mail.gmail.com>
Subject: Re: [RFC PATCH 11/19] famfs_fuse: Basic famfs mount opts
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
> * -o shadow=3D<shadowpath>
> * -o daxdev=3D<daxdev>
>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/fuse/fuse_i.h |  8 +++++++-
>  fs/fuse/inode.c  | 25 ++++++++++++++++++++++++-
>  2 files changed, 31 insertions(+), 2 deletions(-)
>
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index b2c563b1a1c8..931613102d32 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -580,9 +580,11 @@ struct fuse_fs_context {
>         unsigned int blksize;
>         const char *subtype;
>
> -       /* DAX device, may be NULL */
> +       /* DAX device for virtiofs, may be NULL */
>         struct dax_device *dax_dev;
>
> +       const char *shadow; /* famfs - null if not famfs */
> +
>         /* fuse_dev pointer to fill in, should contain NULL on entry */
>         void **fudptr;
>  };
> @@ -938,6 +940,10 @@ struct fuse_conn {
>         /**  uring connection information*/
>         struct fuse_ring *ring;
>  #endif
> +
> +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> +       char *shadow;
> +#endif
>  };
>
>  /*
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 5c6947b12503..7f4b73e739cb 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -766,6 +766,9 @@ enum {
>         OPT_ALLOW_OTHER,
>         OPT_MAX_READ,
>         OPT_BLKSIZE,
> +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> +       OPT_SHADOW,
> +#endif
>         OPT_ERR
>  };
>
> @@ -780,6 +783,9 @@ static const struct fs_parameter_spec fuse_fs_paramet=
ers[] =3D {
>         fsparam_u32     ("max_read",            OPT_MAX_READ),
>         fsparam_u32     ("blksize",             OPT_BLKSIZE),
>         fsparam_string  ("subtype",             OPT_SUBTYPE),
> +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> +       fsparam_string("shadow",                OPT_SHADOW),
> +#endif
>         {}
>  };
>
> @@ -875,6 +881,15 @@ static int fuse_parse_param(struct fs_context *fsc, =
struct fs_parameter *param)
>                 ctx->blksize =3D result.uint_32;
>                 break;
>
> +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> +       case OPT_SHADOW:
> +               if (ctx->shadow)
> +                       return invalfc(fsc, "Multiple shadows specified")=
;
> +               ctx->shadow =3D param->string;
> +               param->string =3D NULL;
> +               break;
> +#endif
> +
>         default:
>                 return -EINVAL;
>         }
> @@ -888,6 +903,7 @@ static void fuse_free_fsc(struct fs_context *fsc)
>
>         if (ctx) {
>                 kfree(ctx->subtype);
> +               kfree(ctx->shadow);
>                 kfree(ctx);
>         }
>  }
> @@ -919,7 +935,10 @@ static int fuse_show_options(struct seq_file *m, str=
uct dentry *root)
>         else if (fc->dax_mode =3D=3D FUSE_DAX_INODE_USER)
>                 seq_puts(m, ",dax=3Dinode");
>  #endif
> -
> +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> +       if (fc->shadow)
> +               seq_printf(m, ",shadow=3D%s", fc->shadow);
> +#endif
>         return 0;
>  }
>
> @@ -1825,6 +1844,10 @@ int fuse_fill_super_common(struct super_block *sb,=
 struct fuse_fs_context *ctx)
>         sb->s_root =3D root_dentry;
>         if (ctx->fudptr)
>                 *ctx->fudptr =3D fud;
> +
> +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> +       fc->shadow =3D kstrdup(ctx->shadow, GFP_KERNEL);
> +#endif

Since this is kstrdup-ed, I think you meant to also kfree this in
fuse_conn_put() when the last refcount on fc gets dropped?


Thanks,
Joanne

>         mutex_unlock(&fuse_mutex);
>         return 0;
>
> --
> 2.49.0
>
