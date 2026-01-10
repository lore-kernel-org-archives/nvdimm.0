Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C836F1C1F02
	for <nvdimm@lists.linux.dev>; Sat, 10 Jan 2026 00:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768005539; cv=none; b=tHnq6Vpip9g52TFDNdK7poeaN7Pe3de+TiB2GoDP+FxSWjuUw4wjWOnIiwyRRnNPpoF3/6T+QhI9PSi/GC7DKGddeKQ7lbr7UYkNmy1km7tZ9hKTIyNcmK/PYegmJ8B9mlxJEexOS521BgQzBKVgIejLDAQR8mLI+2Po0Kr9c10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768005539; c=relaxed/simple;
	bh=Vv/okaYOjZEmxjGKs7gtx68hBZkelsDA4dFyZlvvtVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FCchW6XusXHU6TKUqammALF6WK5N1DRzNzAi7DUYgj7n6PIhN52oFO3ChXxHbigZulbEfdQJJRoem5+CSK7tZ9m/vDzoJp74A4QATv9nAqVnlrXP+Ct8fOOmCE/5wVd1RtIdpJwI2ZFjcaU2Xl9kvPDyorSWwpfjKMDlWPf54Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iwraMwN1; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iwraMwN1"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7c6e9538945so2236227a34.1
        for <nvdimm@lists.linux.dev>; Fri, 09 Jan 2026 16:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768005537; x=1768610337; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HPlS20FXbsN0oW/wvcsl1HExuppxrfezek4Ep7apiYw=;
        b=iwraMwN1Rn0gS1uh8pb1/WYKUPesdHzyr/pxV0SLa1ALHkNHDf+t4LxvJeNAfIpORm
         Fk0jq5l7IfkIKDz1S5vOYEUQuYPXRuibWz1086uUZ7+C71fCGj/HDa0Eg1qNz8D7QPh3
         0kCrx6zZ2RdjkiQMdtWhdC+rRQ2IbuDNbk8p4Q824CxpXhoWh8qKGOfFZc0KejhO4QNM
         EpwtwkLTI43D76L7zrWr9dzcd2qkUwhoHMKbIEK1TxenYygVkRoSZha/K4n3dAiJ4gcg
         ZaN2GHD6zad6l6LjTq7PSW2wqdrvSi42jBmDn3mcEwHt7wetB/5Z9b34rnP23WlYYLg4
         VVWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768005537; x=1768610337;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HPlS20FXbsN0oW/wvcsl1HExuppxrfezek4Ep7apiYw=;
        b=qa98qm4R5GycVw3PJRNvn7G6R1dhA/fDFnRNMrZ/5N4uQlE1XXc0Tnkm6HTP1ukMQG
         IaEIfW11HrvnMyp6Xsa4a1sJGsMzf8GmvmJ6nvd79dMcsjCey7dr5eRhCD9Ui6yvU6vJ
         TsRoUMkq1aamcDqAAp2Sp2KpK8zuZlnNt1zZosZdB4HskJYWZ57VKpYvKtlZud//gwRA
         5LnmQGrU/zVIQvUAdJaKGFck9JmEmUAf6tXJI6nF7WzmquJzg8ppjjK6s204F+vLxeJK
         3mxBcrMZDH+0/AjZkq/h8wDv35u7BABWuRbur2Eqm0ww68ClZ54G8+X4VVijv+SNV4oO
         740A==
X-Forwarded-Encrypted: i=1; AJvYcCXcaqUZKvxgbgxc0qGV59/XRN7gjarzCfvXAjwhNeKN6tEWY/+ZjwJVY2DQ1lD4RhPaSTvwWeY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/vj+XPgEy+kU/JfLJRX5HEzOBkfm+np3+9b+bBqlcLPi8auZ5
	LX4XJ6BqeZiv6Mc3ysxCINU1wbKPLpLNCLoRg75S+YffBetFi4T72wri
X-Gm-Gg: AY/fxX5zSzry0Bu5qN7OCrFyH2gVPF5F0Un6cq//46QZ7evYcdP8k70I/cFN99xxnew
	1szbbwjXs6WKajhmGEWIJwYKIoWvVZ6dcPnGObN4y+sJtaBB9PLtDMMPn9taGD1hLHQVhU9H3S3
	U40hx+L9+UVKOiIng0SQCDgl2FTbURXyleGUtpzhaby1YvwbITe7NbAjwEx2QK0PfnDzYDbkTti
	6tgdKt9i6wn+P3/LMlW9TqBM+FR9HkGdrl+AmYLhPtc016vfSA9ylBoC2f2DDbfxPQ2nH6KmNRJ
	fUOk4Y7BhyG4XIYajTOEPQ4FwHgYM/DDktyyS6zEeq+gA1ybYp8xy7wo3HotvfF7NAjKoFp5MOA
	eI8niTqVfZQ2jaw64CbQ5NzX48UcI6q/wNkz5wONXo7UZWHX/jgrnv9epqMnLDeHZZeiZTNETf1
	4eXo/PWGDV8Ynx26H+b1NmHa0uaBBwbg==
X-Google-Smtp-Source: AGHT+IHP37WFtDa8qLxpH8qc5k2MbMXacjwPxyY2shHTurwLUFdvZ/x8AnFGmtcQkcpVepnV+JBm/w==
X-Received: by 2002:a05:6830:82a7:b0:7c7:5f86:196b with SMTP id 46e09a7af769-7ce46c31764mr9508545a34.3.1768005536612;
        Fri, 09 Jan 2026 16:38:56 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:7d36:1b0c:6e77:5735])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce47801d4dsm8323483a34.5.2026.01.09.16.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 16:38:56 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 9 Jan 2026 18:38:53 -0600
From: John Groves <John@groves.net>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V3 13/21] famfs_fuse: Famfs mount opt: -o
 shadow=<shadowpath>
Message-ID: <zcnuiwujbnme46nwhvlwk7bosvd4r7wzkxcf6zsxoyo6edolf7@ufqfutxq4fcp>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-14-john@groves.net>
 <CAJnrk1bJ3VbZCYJet1eDPy0V=_3cPxz6kDbgcxwtirk2yA9P0w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1bJ3VbZCYJet1eDPy0V=_3cPxz6kDbgcxwtirk2yA9P0w@mail.gmail.com>

On 26/01/09 11:22AM, Joanne Koong wrote:
> On Wed, Jan 7, 2026 at 7:34 AM John Groves <John@groves.net> wrote:
> >
> > The shadow path is a (usually in tmpfs) file system area used by the
> > famfs user space to communicate with the famfs fuse server. There is a
> > minor dilemma that the user space tools must be able to resolve from a
> > mount point path to a shadow path. Passing in the 'shadow=<path>'
> > argument at mount time causes the shadow path to be exposed via
> > /proc/mounts, Solving this dilemma. The shadow path is not otherwise
> > used in the kernel.
> 
> Instead of using mount options to pass the userspace metadata, could
> /sys/fs be used instead? The client is able to get the connection id
> by stat-ing the famfs mount path. There could be a
> /sys/fs/fuse/connections/{id}/metadata file that the server fills out
> with whatever metadata needs to be read by the client. Having
> something like this would be useful to non-famfs servers as well.

The shadow option isn't the only possible way to get what famfs needs,
but I do like it - I find it to be an elegant solution to the problem.

What's the problem? Well, for that you need to know some implementation 
details of the famfs userspace. For the *structure* of a mounted file 
system, famfs is very passthrough-like. The structure that is being 
passed through is the shadow file system, which is an actual file system 
(usually tmpfs).  Directories are just directories, but shadow files 
contain yaml that describes the file-to-dax map of the *actual* file. 
On lookup, the famfs fuse server (famfs_fused), rather than stat the 
file like passthrough, reads the yaml and decodes the stat and fmap info 
from that.

One other detail. The shadow path must be known or created (usually
as a tmpdir, to guarantee it starts empty) at mount time. The kernel
knows about it through "-o shadow=<path>", but otherwise doesn't use
it. The famfs fuse server receives the path as an input from 
'famfs mount'. The problem is that pretty much every famfs-related
user space command needs the shadow path.

In fact the the structure of the mounted file system is at 
<shadow_path>/root.  Also located in <shadow path> (above ./root) is a 
unix domain socket for REST communication with famfs_fused. We have 
plans for other files at <shadow path> and above ./root (mount-specific 
config options, for example).

Playing the famfs metadata log requires finding the shadow path,
parsing the log, and creating (or potentially modifying) shadow files
in the shadow path for the mount.

So to communicate with the fuse server we parse the shadow path from
/proc/mounts and that finds the <shadow_path>/socket that can be used
to communicate with famfs_fused. And we can play the metadata log
(accessed via MPT/.meta/.log) to <shadow_path>/root/...

Having something in sysfs would be fine, but unless we pass it into
the kernel somehow (hey, like -o shadow=<shadow path>), the kernel
won't know it and can't reveal it.

A big no-go, I think, is trying to parse the shadow path from the
famfs fuse server via 'ps -ef' or 'ps -ax'. The famfs cli etc. might
be running in a container that doesn't have access to that.

Happy to discuss further...

> 
> >
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/fuse/fuse_i.h | 25 ++++++++++++++++++++++++-
> >  fs/fuse/inode.c  | 28 +++++++++++++++++++++++++++-
> >  2 files changed, 51 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index ec2446099010..84d0ee2a501d 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -620,9 +620,11 @@ struct fuse_fs_context {
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
> > @@ -998,6 +1000,18 @@ struct fuse_conn {
> >                 /* Request timeout (in jiffies). 0 = no timeout */
> >                 unsigned int req_timeout;
> >         } timeout;
> > +
> > +       /*
> > +        * This is a workaround until fuse uses iomap for reads.
> > +        * For fuseblk servers, this represents the blocksize passed in at
> > +        * mount time and for regular fuse servers, this is equivalent to
> > +        * inode->i_blkbits.
> > +        */
> > +       u8 blkbits;
> > +
> 
> I think you meant to remove these lines?

I was gonna say those are Darrick's lines...but they came in through my patch.
So yes, I will drop them. Oops :D

I'm not sure how this leaked into my patch, but that's one of the reasons why
reviews are good - thanks!

> 
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       char *shadow;
> 
> Should this be const char * too?
> > +#endif
> >  };
> >
> >  /*
> > @@ -1631,4 +1645,13 @@ extern void fuse_sysctl_unregister(void);
> >  #define fuse_sysctl_unregister()       do { } while (0)
> >  #endif /* CONFIG_SYSCTL */
> >
> > +/* famfs.c */
> > +
> > +static inline void famfs_teardown(struct fuse_conn *fc)
> > +{
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       kfree(fc->shadow);
> > +#endif
> > +}
> > +
> >  #endif /* _FS_FUSE_I_H */
> > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > index acabf92a11f8..2e0844aabbae 100644
> > --- a/fs/fuse/inode.c
> > +++ b/fs/fuse/inode.c
> > @@ -783,6 +783,9 @@ enum {
> >         OPT_ALLOW_OTHER,
> >         OPT_MAX_READ,
> >         OPT_BLKSIZE,
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       OPT_SHADOW,
> > +#endif
> >         OPT_ERR
> >  };
> >
> > @@ -797,6 +800,9 @@ static const struct fs_parameter_spec fuse_fs_parameters[] = {
> >         fsparam_u32     ("max_read",            OPT_MAX_READ),
> >         fsparam_u32     ("blksize",             OPT_BLKSIZE),
> >         fsparam_string  ("subtype",             OPT_SUBTYPE),
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       fsparam_string("shadow",                OPT_SHADOW),
> 
> nit: having the spacing for ("shadow", align with the lines above
> would be aesthetically nice

Done, thanks

> 
> > +#endif
> >         {}
> >  };
> >
> > @@ -892,6 +898,15 @@ static int fuse_parse_param(struct fs_context *fsc, struct fs_parameter *param)
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
> > @@ -905,6 +920,7 @@ static void fuse_free_fsc(struct fs_context *fsc)
> >
> >         if (ctx) {
> >                 kfree(ctx->subtype);
> > +               kfree(ctx->shadow);
> >                 kfree(ctx);
> >         }
> >  }
> > @@ -936,7 +952,10 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
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
> > @@ -1041,6 +1060,8 @@ void fuse_conn_put(struct fuse_conn *fc)
> >                 WARN_ON(atomic_read(&bucket->count) != 1);
> >                 kfree(bucket);
> >         }
> > +       famfs_teardown(fc);
> 
> imo it looks a bit cleaner with
> 
> if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
>      famfs_teardown(fc);
> 
> which also matches the pattern the passthrough config below uses

Done

> 
> > +
> >         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> >                 fuse_backing_files_free(fc);
> >         call_rcu(&fc->rcu, delayed_release);
> > @@ -1916,6 +1937,11 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
> >                 *ctx->fudptr = fud;
> >                 wake_up_all(&fuse_dev_waitq);
> >         }
> > +
> > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > +       fc->shadow = kstrdup(ctx->shadow, GFP_KERNEL);
> 
> Is a shadow path a must-have for a famfs mount? if so, then should the
> mount fail if the allocation here fails?

Summarized above...

> 
> Thanks,
> Joanne
> > +#endif
> > +
> >         mutex_unlock(&fuse_mutex);
> >         return 0;
> >
> > --
> > 2.49.0
> >

Thanks Joanne!

John

