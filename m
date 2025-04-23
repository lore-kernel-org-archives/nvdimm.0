Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4021ACED5
	for <nvdimm@lists.linux.dev>; Wed, 23 Apr 2025 20:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745439550; cv=none; b=IPVkNQPOZ0t/2pp1tkkAPbFNcwuL21lulLgO0pUYZhZvmYwD6ivADOiitnSjGXJK1zp/DgUxXW3vRX6hE872a1aF5AL4yQge6uViaUnVFvLI9MFZHnZ8pXC4XMq4qe8CDZkBJqAj5OauPf6jEYhSTq/fWYKvbNqzfWe4JmU+nkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745439550; c=relaxed/simple;
	bh=Hjyfm1RDvnrb3r506AIGW33tNSvbha+9sei4TDw4B1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dgI/DYqZyIFDFpK7X06vLQstHGK8Ksuq0ln9Unur1RQ5v60YRV3jP6OMWKCjSrV17cY8aejNnBnaovnEpMSBqZZFE0z6nkiTr2Ry31vSHF6gr8UnqoaR86CQ8HMMv7Qhp+e2UuQGyh52fdIW743mBtaTDLxc3VB/OgClFIsZV+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2zXwknW; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2zXwknW"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3fb3f4bf97aso73769b6e.2
        for <nvdimm@lists.linux.dev>; Wed, 23 Apr 2025 13:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745439546; x=1746044346; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g4Ay+yxjyvrecwm+hKWiGn1hvCte1K1DikL5dI6YUSI=;
        b=R2zXwknW+US1FgXaEpnjNOJb/uxPr7VRKYbpWT3wpASB9kAZIQOWJ55pHeGEgQB2TJ
         4WV2y9+keb1/V0UiBe7vFbuF/HB2DKeNcU4wJqbilOBgDurRANB8ISNQWbJjAP4NJNgm
         hFawQOV/T3+QHnM5yDvk2vAQlYubC2Tb3oypwuWeTi2oYLlYhPa+r6GJv2Lsz5ApE9t0
         Ox6uezbGtIS0TpmLBqgyGrrB+hEhu4jyREQ2ZKFcH1trOFv6sERQk6gRbRHsI2p296r8
         bGX7mO/QJn5jMjhbU7aCmv4YH6MH7pf5TXYpJjxfZMGQaHY+vBRGu/gkd+qWe1YyTfKo
         b4KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745439546; x=1746044346;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g4Ay+yxjyvrecwm+hKWiGn1hvCte1K1DikL5dI6YUSI=;
        b=LQPFEHZuzUneXUPABehfPJfg/TvqWLKZ/k+nY2c+SU/Nnlit4MvhWE4wAkQGkuH6Bx
         5HT87ERMBO7OEJ+6/x6KsSVbFA0ZIxaN5MqNvO39U6N/8BxQQ8HkrROwTiaAbNCUlof6
         pJyO/HFeuskAcdpe4PqK03qcC247bdqgkPYj7CQ4WYekGrH3sBAUB8pbrZQRQSrGDoAl
         kzinW9hXiXnGMgTB/N7KEwVjkqGNyghk3gvhPi5gRFoiFk1FonRsngZEDYdK8dKbxBAD
         7wQZMuSH3cN5kxab8IViQt+AVNW3KZPhvP8Hgsln6JSw1AeDW023+wW1M1/agd9I5pIp
         w7DA==
X-Forwarded-Encrypted: i=1; AJvYcCX6E5VHqAE0fzxiepv+p5Yhyp6K1UPbgwzjUuSHoynBHI+j9raPFxRwbZb9Zkk8bo6ievT+hes=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0k2786n9JSeBccgGmjF/Gt8Qtort+w+rjDuOgQmjC6Yv4brus
	Lq0RYILz4GQhW218SdzUx2i7Vk5ML+N/kR/KZv79JIDbL31tW0I/
X-Gm-Gg: ASbGncuPihJ8WNTZOYc6BmD/NidU/pogykoMFyXO2JZMoyLiChnJR8UGB7ec0VmOD50
	lHNMHkz3/vKDyAwUTI5z2wkqoKyJP/N9f5WQoZtD3UHQxXsYbxdx/iMHeUdIH1cwAcjpmCV4Idk
	VTaNKBjkDpSWyuLxTRYClyGvgBLHDsoueV7r4R24dVzNjOszEMZlEFe5tFcEfO2WQtcIGfvheFN
	PHg0E9taxJcAFRHyBdVdf7WKsHU+vSNcFQLtXLt39LXkZ2XiMfkzajY4zDz2WEImkxdD/1w4MZp
	BtNteTYxsq31rcf65WPxUR3Jm5tQ0Hxye8kHpRpaJDERNfF2H6NOvPRYVv55xPQkUtf3Y7w=
X-Google-Smtp-Source: AGHT+IEoll/IipbPMTUh46dRuaEBH4kvJbYYprGZYgOTzElLJasG3TcogRN8wLTOCXAPApRgQMleOQ==
X-Received: by 2002:a05:6808:1c0a:b0:400:fa6b:5dfb with SMTP id 5614622812f47-401eb3d2997mr176263b6e.36.1745439545564;
        Wed, 23 Apr 2025 13:19:05 -0700 (PDT)
Received: from Borg-550.local ([2603:8080:1500:3d89:44cc:5f45:d31b:d18f])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-401bf09a0a3sm2721677b6e.42.2025.04.23.13.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 13:19:05 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Wed, 23 Apr 2025 15:19:02 -0500
From: John Groves <John@groves.net>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredb.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Luis Henriques <luis@igalia.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Petr Vorel <pvorel@suse.cz>, Brian Foster <bfoster@redhat.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC PATCH 11/19] famfs_fuse: Basic famfs mount opts
Message-ID: <4lknmgdq4d6xlmejrddwumpxuwog3l5iwtmoaet7w6swbtc37i@33xmye5u3g5a>
References: <20250421013346.32530-1-john@groves.net>
 <20250421013346.32530-12-john@groves.net>
 <CAJnrk1a40QE+8q-PTTP6GgpDO9d9i_biuN8zk-KSEEiK7S34kA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1a40QE+8q-PTTP6GgpDO9d9i_biuN8zk-KSEEiK7S34kA@mail.gmail.com>

On 25/04/22 06:51PM, Joanne Koong wrote:
> On Sun, Apr 20, 2025 at 6:34 PM John Groves <John@groves.net> wrote:
> >
> > * -o shadow=<shadowpath>
> > * -o daxdev=<daxdev>
> >
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/fuse/fuse_i.h |  8 +++++++-
> >  fs/fuse/inode.c  | 25 ++++++++++++++++++++++++-
> >  2 files changed, 31 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index b2c563b1a1c8..931613102d32 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -580,9 +580,11 @@ struct fuse_fs_context {
> >         unsigned int blksize;
> >         const char *subtype;
> >
> > -       /* DAX device, may be NULL */
> > +       /* DAX device for virtiofs, may be NULL */
> >         struct dax_device *dax_dev;
> >
> > +       const char *shadow; /* famfs - null if not famfs */
> > +
> >         /* fuse_dev pointer to fill in, should contain NULL on entry */
> >         void **fudptr;
> >  };
> > @@ -938,6 +940,10 @@ struct fuse_conn {
> >         /**  uring connection information*/
> >         struct fuse_ring *ring;
> >  #endif
> > +
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       char *shadow;
> > +#endif
> >  };
> >
> >  /*
> > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > index 5c6947b12503..7f4b73e739cb 100644
> > --- a/fs/fuse/inode.c
> > +++ b/fs/fuse/inode.c
> > @@ -766,6 +766,9 @@ enum {
> >         OPT_ALLOW_OTHER,
> >         OPT_MAX_READ,
> >         OPT_BLKSIZE,
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       OPT_SHADOW,
> > +#endif
> >         OPT_ERR
> >  };
> >
> > @@ -780,6 +783,9 @@ static const struct fs_parameter_spec fuse_fs_parameters[] = {
> >         fsparam_u32     ("max_read",            OPT_MAX_READ),
> >         fsparam_u32     ("blksize",             OPT_BLKSIZE),
> >         fsparam_string  ("subtype",             OPT_SUBTYPE),
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       fsparam_string("shadow",                OPT_SHADOW),
> > +#endif
> >         {}
> >  };
> >
> > @@ -875,6 +881,15 @@ static int fuse_parse_param(struct fs_context *fsc, struct fs_parameter *param)
> >                 ctx->blksize = result.uint_32;
> >                 break;
> >
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       case OPT_SHADOW:
> > +               if (ctx->shadow)
> > +                       return invalfc(fsc, "Multiple shadows specified");
> > +               ctx->shadow = param->string;
> > +               param->string = NULL;
> > +               break;
> > +#endif
> > +
> >         default:
> >                 return -EINVAL;
> >         }
> > @@ -888,6 +903,7 @@ static void fuse_free_fsc(struct fs_context *fsc)
> >
> >         if (ctx) {
> >                 kfree(ctx->subtype);
> > +               kfree(ctx->shadow);
> >                 kfree(ctx);
> >         }
> >  }
> > @@ -919,7 +935,10 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
> >         else if (fc->dax_mode == FUSE_DAX_INODE_USER)
> >                 seq_puts(m, ",dax=inode");
> >  #endif
> > -
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       if (fc->shadow)
> > +               seq_printf(m, ",shadow=%s", fc->shadow);
> > +#endif
> >         return 0;
> >  }
> >
> > @@ -1825,6 +1844,10 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
> >         sb->s_root = root_dentry;
> >         if (ctx->fudptr)
> >                 *ctx->fudptr = fud;
> > +
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       fc->shadow = kstrdup(ctx->shadow, GFP_KERNEL);
> > +#endif
> 
> Since this is kstrdup-ed, I think you meant to also kfree this in
> fuse_conn_put() when the last refcount on fc gets dropped?

Good catch Joanne! That's queued in my "-next" branch.

Thanks,
John

