Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36A4212D7C
	for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 18:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754937060; cv=none; b=r8IMviGfai5JyUeuAY+bxB5ycKq81ajXY8RjXKWwrslVDmA58eTCHQ6ahynjenHBORZnUeiPwDZmhik+T6BWR690eXKVUwEpRUJfKTK4HfPT+TL3NDHCPkNQcFE4TdovKUgMYu1GfrPgZDyVfeW2kcyHLsZmB6d2fvkLiU4drag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754937060; c=relaxed/simple;
	bh=xk8qaiErmfTGhxRgj9XAM40WAN3dsm5MjAETZq/bFWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ewjhR8RwraQ4vT14sbUrle+yxOGADGPk2CkWzABUchcP19eb1hL+RTv5ScRjq76D+QfdQTLdnxGHvNLrOWteJiUcyj9VvW1V7fmHiWdYe7VS6kyWYjO/kmTkLFB+AEJhYuf1prYOyYpvNGSlNJzENMOWbD5XgzHFxSEjEzzZ4BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h44MzF8B; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h44MzF8B"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-30c27db3739so5593342fac.0
        for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 11:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754937057; x=1755541857; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=erUZxz/3YKb6AzciSl87N1qVga0MvtNzwF8QlCkJO6o=;
        b=h44MzF8BF+7LX+qEP/aZCjj62vwvB9Q2QW6CLI0CmVZJYl0nuuFkfwOeJc2VV8ABzK
         XoZ/Sce26a8V7qfYWo4X3eTFh0Fbog2rVdsXqbJg1kFVN/e/3pQG/dxjijiEo820UAn9
         aD6/m76wMn2I5dsuXmTqY4LWtQBHlUgNmFoqHlWixVw41Yik0I8IDQMV5GbWeMz5RdS2
         5rQ1hJZWZ0w2oVAmoRWdf7df/aE+GsNqI/W1e+XZeGF7lEONVXB2jP51a8KnJud4dSmQ
         +sxOjZRdlYFRutL8P5eqrmDfQYcoMJHp1PWr+rSAE27lxJGl+gxPv3tJkQ7jofR2EGv7
         6wig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754937057; x=1755541857;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=erUZxz/3YKb6AzciSl87N1qVga0MvtNzwF8QlCkJO6o=;
        b=JeKQVyksPRttJV7EblG+jHtobNgf8Z9EWn2Z98VU+BrqOYMnJFD/6cv46eW96qx2ta
         jK8Ne6k5hB4R8AoxyQArW6IVSsgzWf6ErXhMXISwF1jkkGqHa8YGALlivFnbhWEZP7eP
         Ebew1J8LHHBhlN4WMkXn6pLYGii09ZV9Q4MtFwG8uelRo0/blDT6b4hsIpTN1d736axu
         rOxEFmWdRCJA/KNt+c7QiC39fP28V+wtgMATyHGQEgD1MUz5Pqr7Lh0yzs0tX1a7ogmZ
         fZoHpcyJz/GYSgyQ2lC4/7cLbEU8UaGbnaEr0BPORz55ZV/2FfEtdAJMUegcIV+866P9
         0NJA==
X-Forwarded-Encrypted: i=1; AJvYcCXN3NRfXMGajCIWPuTT7OuX758oq3IdcGN5w8ELiInBoxLZAmo6xVfo109sANFhzQIXGHxXLq4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwR+Hw639uDjNhRht7+PaQ7KINIEaNIhMtlomZrCKifSNBkDJ/a
	BoCVgCUUHwWQScgy0p1QanrTXkKqumoa4xmyEbmTzEGlA95xqjV4qj5N
X-Gm-Gg: ASbGncslnFeMBax3gimEDTZ54m7PamMmRwmFeXayt51v12DDQXc8GG288OxfY1QmT6L
	XJAR6An7EiLWz/T8WtKIW2Jjn2YbO6TZGqrriSSPCJtytFvr6XTej0JCnbzCWhy1lJZ6TyLoZC4
	X2siUKEFMAzQd9ASw0+efU+Cs00BliQsiS5gFSLTtWxhwHAEJ9LbaxlyX+fzb9tGybgqHcObYN8
	SRAAXUXwGzfV8cT3e6RI9oO64XmQGuSYk++Zr/mYDG9jSsZ8iHtCAPX6jdbundNo9TPMGu1pcwu
	xhv8A3X3Vg/kLcsSSaPzaON7I/NGcyxWtWwzlwXFuTdATIpNPUAThBViViPgMxDcnkpKP8O02Jb
	RUrGKqpHJZ5GBTgpNmEQYDcKxI+/hqTR1bcjB
X-Google-Smtp-Source: AGHT+IFeSQ0skn1obsPdMuUc/I2OxHhwHFM3A2M1joHpdeeawx5gSo3o7y+eUrVN/gXuAHlP6eMhag==
X-Received: by 2002:a05:6870:479b:b0:307:3d5:713f with SMTP id 586e51a60fabf-30c210da176mr9357342fac.19.1754937056701;
        Mon, 11 Aug 2025 11:30:56 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:b420:5f86:575e:74a8])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-307a7390b47sm7916818fac.21.2025.08.11.11.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 11:30:55 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 11 Aug 2025 13:30:53 -0500
From: John Groves <John@groves.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, 
	Dan Williams <dan.j.williams@intel.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, john@groves.net
Subject: Re: [RFC V2 10/18] famfs_fuse: Basic fuse kernel ABI enablement for
 famfs
Message-ID: <z2yuwgzsbbirtfmr2rkgbq3yhjtvihumdxp4bvwgkybikubhgp@lfjfhlvtckmr>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-11-john@groves.net>
 <CAOQ4uxi7fvMgYqe1M3_vD3+YXm7x1c4YjA=eKSGLuCz2Dsk0TQ@mail.gmail.com>
 <yhso6jddzt6c7glqadrztrswpisxmuvg7yopc6lp4gn44cxd4m@my4ajaw47q7d>
 <20250707173942.GC2672029@frogsfrogsfrogs>
 <ueepqz3oqeqzwiidk2wlf3f7enxxte4ws27gtxhakfmdiq4t26@cvfmozym5rme>
 <20250709015348.GD2672029@frogsfrogsfrogs>
 <wam2qo5r7tbpf4ork5qcdqnw4olhfpkvlqpnbuqpwfhrymf3dq@hw3frnbadhk7>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <wam2qo5r7tbpf4ork5qcdqnw4olhfpkvlqpnbuqpwfhrymf3dq@hw3frnbadhk7>

On 25/07/10 08:32PM, John Groves wrote:
> On 25/07/08 06:53PM, Darrick J. Wong wrote:
> > On Tue, Jul 08, 2025 at 07:02:03AM -0500, John Groves wrote:
> > > On 25/07/07 10:39AM, Darrick J. Wong wrote:
> > > > On Fri, Jul 04, 2025 at 08:39:59AM -0500, John Groves wrote:
> > > > > On 25/07/04 09:54AM, Amir Goldstein wrote:
> > > > > > On Thu, Jul 3, 2025 at 8:51 PM John Groves <John@groves.net> wrote:
> > > > > > >
> > > > > > > * FUSE_DAX_FMAP flag in INIT request/reply
> > > > > > >
> > > > > > > * fuse_conn->famfs_iomap (enable famfs-mapped files) to denote a
> > > > > > >   famfs-enabled connection
> > > > > > >
> > > > > > > Signed-off-by: John Groves <john@groves.net>
> > > > > > > ---
> > > > > > >  fs/fuse/fuse_i.h          |  3 +++
> > > > > > >  fs/fuse/inode.c           | 14 ++++++++++++++
> > > > > > >  include/uapi/linux/fuse.h |  4 ++++
> > > > > > >  3 files changed, 21 insertions(+)
> > > > > > >
> > > > > > > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > > > > > > index 9d87ac48d724..a592c1002861 100644
> > > > > > > --- a/fs/fuse/fuse_i.h
> > > > > > > +++ b/fs/fuse/fuse_i.h
> > > > > > > @@ -873,6 +873,9 @@ struct fuse_conn {
> > > > > > >         /* Use io_uring for communication */
> > > > > > >         unsigned int io_uring;
> > > > > > >
> > > > > > > +       /* dev_dax_iomap support for famfs */
> > > > > > > +       unsigned int famfs_iomap:1;
> > > > > > > +
> > > > > > 
> > > > > > pls move up to the bit fields members.
> > > > > 
> > > > > Oops, done, thanks.
> > > > > 
> > > > > > 
> > > > > > >         /** Maximum stack depth for passthrough backing files */
> > > > > > >         int max_stack_depth;
> > > > > > >
> > > > > > > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > > > > > > index 29147657a99f..e48e11c3f9f3 100644
> > > > > > > --- a/fs/fuse/inode.c
> > > > > > > +++ b/fs/fuse/inode.c
> > > > > > > @@ -1392,6 +1392,18 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
> > > > > > >                         }
> > > > > > >                         if (flags & FUSE_OVER_IO_URING && fuse_uring_enabled())
> > > > > > >                                 fc->io_uring = 1;
> > > > > > > +                       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
> > > > > > > +                           flags & FUSE_DAX_FMAP) {
> > > > > > > +                               /* XXX: Should also check that fuse server
> > > > > > > +                                * has CAP_SYS_RAWIO and/or CAP_SYS_ADMIN,
> > > > > > > +                                * since it is directing the kernel to access
> > > > > > > +                                * dax memory directly - but this function
> > > > > > > +                                * appears not to be called in fuse server
> > > > > > > +                                * process context (b/c even if it drops
> > > > > > > +                                * those capabilities, they are held here).
> > > > > > > +                                */
> > > > > > > +                               fc->famfs_iomap = 1;
> > > > > > > +                       }
> > > > > > 
> > > > > > 1. As long as the mapping requests are checking capabilities we should be ok
> > > > > >     Right?
> > > > > 
> > > > > It depends on the definition of "are", or maybe of "mapping requests" ;)
> > > > > 
> > > > > Forgive me if this *is* obvious, but the fuse server capabilities are what
> > > > > I think need to be checked here - not the app that it accessing a file.
> > > > > 
> > > > > An app accessing a regular file doesn't need permission to do raw access to
> > > > > the underlying block dev, but the fuse server does - becuase it is directing
> > > > > the kernel to access that for apps.
> > > > > 
> > > > > > 2. What's the deal with capable(CAP_SYS_ADMIN) in process_init_limits then?
> > > > > 
> > > > > I *think* that's checking the capabilities of the app that is accessing the
> > > > > file, and not the fuse server. But I might be wrong - I have not pulled very
> > > > > hard on that thread yet.
> > > > 
> > > > The init reply should be processed in the context of the fuse server.
> > > > At that point the kernel hasn't exposed the fs to user programs, so
> > > > (AFAICT) there won't be any other programs accessing that fuse mount.
> > > 
> > > Hmm. It would be good if you're right about that. My fuse server *is* running
> > > as root, and when I check those capabilities in process_init_reply(), I
> > > find those capabilities. So far so good.
> > > 
> > > Then I added code to my fuse server to drop those capabilities prior to
> > > starting the fuse session (prctl(PR_CAPBSET_DROP, CAP_SYS_RAWIO) and 
> > > prctl(PR_CAPBSET_DROP, CAP_SYS_ADMIN). I expected (hoped?) to see those 
> > > capabilities disappear in process_init_reply() - but they did not disappear.
> > > 
> > > I'm all ears if somebody can see a flaw in my logic here. Otherwise, the
> > > capabilities need to be stashed away before the reply is processsed, when 
> > > fs/fuse *is* running in fuse server context.
> > > 
> > > I'm somewhat surprised if that isn't already happening somewhere...
> > 
> > Hrm.  I *thought* that since FUSE_INIT isn't queued as a background
> > command, it should still execute in the same process context as the fuse
> > server.
> > 
> > OTOH it also occurs to me that I have this code in fuse_send_init:
> > 
> > 	if (has_capability_noaudit(current, CAP_SYS_RAWIO))
> > 		flags |= FUSE_IOMAP | FUSE_IOMAP_DIRECTIO | FUSE_IOMAP_PAGECACHE;
> > 	...
> > 	ia->in.flags = flags;
> > 	ia->in.flags2 = flags >> 32;
> > 
> > which means that we only advertise iomap support in FUSE_INIT if the
> > process running fuse_fill_super (which you hope is the fuse server)
> > actually has CAP_SYS_RAWIO.  Would that work for you?  Or are you
> > dropping privileges before you even open /dev/fuse?
> 
> Ah - that might be the answer. I will check if dropped capabilities 
> disappear in fuse_send_init. If so, I can work with that - not advertising 
> the famfs capability unless the capability is present at that point looks 
> like a perfectly good option. Thanks for that idea!

Review: the famfs fuse server directs the kernel to provide access to raw
(memory) devices, so it should should be required to have have the
CAP_SYS_RAWIO capability. fs/fuse needs to detect this at init time,
and fail the connection/mount if the capability is missing.

I initially attempted to do this verification in process_init_reply(), but
that doesn't run in the fuse server process context.

I am now checking the capability in fuse_send_init(), and not advertising
the FUSE_DAX_FMAP capability (in in_args->flags[2]) unless the server has 
CAP_SYS_RAWIO.

That requires that process_init_reply() reject FUSE_DAX_FMAP from a server
if FUSE_DAX_FMAP was not set in in_args->flags[2]. process_init_reply() was
not previously checking the in_args, but no big deal - this works.

This leads to an apparent dilemma in libfuse. In fuse_lowlevel_ops->init(),
I should check for (flags & FUSE_DAX_IOMAP), and fail the connection if
that capability is not on offer. But fuse_lowlevel_ops->init() doesn't
have an obvious way to fail the connection. 

How should I do that? Hoping Bernd, Amir or the other libfuse people may 
have "the answer" (tm).

And of course if any of this doesn't sound like the way to go, let me know...

Thanks!
John

