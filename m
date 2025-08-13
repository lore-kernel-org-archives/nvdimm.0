Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE052E4252
	for <nvdimm@lists.linux.dev>; Wed, 13 Aug 2025 13:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755090428; cv=none; b=CMoyt4ZIXiJiMS/UsURrUgs1igTz+67fLXc0WKuv2F+gP2a8tgUifIzDRIFUNAyrOc+qttmB7bYfIkKaR1ok/QHSLECBFZgWEyaW50FXz25vimWktf7CFuhp5grGm/Zb0UljqI+DFi6J38lVI7o7aui1Q43N0tU46QQK7vU4fgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755090428; c=relaxed/simple;
	bh=xNQyMQhgRS/pQv6n/1m5097qSZXjptp0FiHi+pt1qKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zy+0uIWAYcQU6X39tZ51kEMzdK4ei5FRF+pgDh+RYh/z/7u9p/ni/ilPJUyjt/t10F+n6wOqHOcBmZDyyHj8caJNoN2Bj88iPra+3tTCICswVW3UE/dZqAe/pTougL+PgD5Z2G65Sc0i85l7nMIDdZKW+ir2AjQpZiaTmgMjEDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gCaPtR5E; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gCaPtR5E"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-741518e14d4so1810048a34.3
        for <nvdimm@lists.linux.dev>; Wed, 13 Aug 2025 06:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755090425; x=1755695225; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n1YudBw7MAQTXi6TXZdwDXGn3+WTymY6q/wDnBxH1+I=;
        b=gCaPtR5Ej1V1q5ig5DylZ3+qpGKoaNdkipoyKkHXSf86i4GEL7cDVXV5Dja7YeyO1B
         AnTJlIgJ9UpWtWieCtApzShsRbbt9Kb1EDljpW8Q1k+UlfsJGfXi8IIqIhT6GKjczmZy
         8KXvzqjm+bKcZWwpR3qmyPY9mYK+qqoc0kk2kuq8NJ8dK54vzyMqbxfpzjRIt1NtSHzu
         muMdmJE2An8ekNrDD/XR5T9WMEwWiUeQadEZ2GP3sfvzmNrKmScaYPmG+SlpI/JNvbn6
         Gb1zRsJv7+I2ch2JlTaDe2rCxLjzRuYoW1o8zqOC06C96Srv/zHGy+OaD9lphFN7eSKO
         bZQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755090425; x=1755695225;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n1YudBw7MAQTXi6TXZdwDXGn3+WTymY6q/wDnBxH1+I=;
        b=CT76lM/Ot2pfPemZy/y94/wWfkb9jvzrQUTi/ILsNcgB+yfWpfHP2TibZqhnJ9+u4S
         esQbeg6MYjHeawCSNYQhencTzYUXfdMjEXDku93iEa+pwQCorfZaTwdmMLr+ChwTT9Hy
         jxxtmGEhxtaaoJzdvUq9Q5vom/CSrJM7q1l5RKhp/4QjgrZAdrIxCchzHiuDsjcYJFKq
         oI5sXBS8GNnxTW+yYRBSyuFGNmzMx7aTJVXTiDegmOKkmceBos00Lx4jD5ByCoy4r+ZM
         dE2bXh3TfR0M/nsZ7i8Zg5adcNgztykCL7rBNnQl75cJbLbhdQddcHoVNh3ACZaNw1f5
         wsXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyFtEn28Q3IySvP4L7C2PXIEoYOWVq/jte8NZ24ZGggT6rjzemx6i8Qqb8bbzeztP/T1qZ12w=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKNn5Zic+o9B7ZYrAa6mh2pwe3XO3VD9vcWCJA8r5PK98dDaL8
	iXPadfFIVBLYBB8aQgR3N9Jk26dn4lXa1B0ikd9SguiUlsk8ccDDj/xy
X-Gm-Gg: ASbGnctWxufM9VUfLtioHW7IXqaBY1lnHl3XLFeXNeyngrpDxvL90l0op2eNtokxfsi
	fV0p/O4tWMLbIfHEEhOv6wzla7U/gVA91a94umegCDB/RHDnQ/G/uzjl3Ek8ZxigguzFlGgf65g
	4kAaQ6ssu4CQCweLp5+9dj4p2LkBtVYyojCNiRu9K/wpT0Y9KT0BunXadQwllkjNW4bsbT5Rkhq
	SiRdf4OZdcyAS8oF2KO5AQ4HqB+FLVd8CvhAhw2N6Cm7GJiiTX+W+kTWu9bK9Wxv2wu/TGgQEMS
	0IFrRMqTRlpfyhnJvNlXwlaHLO+nULuYHwKh2RaE/ohMBynFuHx6oFhag8DPIBQQy2eXWpE++gG
	nGOssNWosbXGJqwTKTAqDgMeX+h0a9m3jffT4
X-Google-Smtp-Source: AGHT+IFv30iQu2EjwFvGj4tST22eOwRpygmljio/eFQP244BeJM8t7/xZHQY4INgg8wGK62SBpnI5w==
X-Received: by 2002:a05:6830:65c4:20b0:73e:93dd:1f56 with SMTP id 46e09a7af769-74375498502mr1373565a34.13.1755090424285;
        Wed, 13 Aug 2025 06:07:04 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:39e1:a7d8:41fa:d365])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7436f9900ddsm850526a34.46.2025.08.13.06.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:07:03 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Wed, 13 Aug 2025 08:07:00 -0500
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
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 10/18] famfs_fuse: Basic fuse kernel ABI enablement for
 famfs
Message-ID: <ewnlhaur3un32iq25zfvwqwju2pku5i56cuiijs572uige5z3z@d66k24dep4fi>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-11-john@groves.net>
 <CAOQ4uxi7fvMgYqe1M3_vD3+YXm7x1c4YjA=eKSGLuCz2Dsk0TQ@mail.gmail.com>
 <yhso6jddzt6c7glqadrztrswpisxmuvg7yopc6lp4gn44cxd4m@my4ajaw47q7d>
 <20250707173942.GC2672029@frogsfrogsfrogs>
 <ueepqz3oqeqzwiidk2wlf3f7enxxte4ws27gtxhakfmdiq4t26@cvfmozym5rme>
 <20250709015348.GD2672029@frogsfrogsfrogs>
 <wam2qo5r7tbpf4ork5qcdqnw4olhfpkvlqpnbuqpwfhrymf3dq@hw3frnbadhk7>
 <z2yuwgzsbbirtfmr2rkgbq3yhjtvihumdxp4bvwgkybikubhgp@lfjfhlvtckmr>
 <20250812163733.GF7942@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250812163733.GF7942@frogsfrogsfrogs>

On 25/08/12 09:37AM, Darrick J. Wong wrote:
> On Mon, Aug 11, 2025 at 01:30:53PM -0500, John Groves wrote:
> > On 25/07/10 08:32PM, John Groves wrote:
> > > On 25/07/08 06:53PM, Darrick J. Wong wrote:
> > > > On Tue, Jul 08, 2025 at 07:02:03AM -0500, John Groves wrote:
> > > > > On 25/07/07 10:39AM, Darrick J. Wong wrote:
> > > > > > On Fri, Jul 04, 2025 at 08:39:59AM -0500, John Groves wrote:
> > > > > > > On 25/07/04 09:54AM, Amir Goldstein wrote:
> > > > > > > > On Thu, Jul 3, 2025 at 8:51 PM John Groves <John@groves.net> wrote:
> > > > > > > > >
> > > > > > > > > * FUSE_DAX_FMAP flag in INIT request/reply
> > > > > > > > >
> > > > > > > > > * fuse_conn->famfs_iomap (enable famfs-mapped files) to denote a
> > > > > > > > >   famfs-enabled connection
> > > > > > > > >
> > > > > > > > > Signed-off-by: John Groves <john@groves.net>
> > > > > > > > > ---
> > > > > > > > >  fs/fuse/fuse_i.h          |  3 +++
> > > > > > > > >  fs/fuse/inode.c           | 14 ++++++++++++++
> > > > > > > > >  include/uapi/linux/fuse.h |  4 ++++
> > > > > > > > >  3 files changed, 21 insertions(+)
> > > > > > > > >
> > > > > > > > > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > > > > > > > > index 9d87ac48d724..a592c1002861 100644
> > > > > > > > > --- a/fs/fuse/fuse_i.h
> > > > > > > > > +++ b/fs/fuse/fuse_i.h
> > > > > > > > > @@ -873,6 +873,9 @@ struct fuse_conn {
> > > > > > > > >         /* Use io_uring for communication */
> > > > > > > > >         unsigned int io_uring;
> > > > > > > > >
> > > > > > > > > +       /* dev_dax_iomap support for famfs */
> > > > > > > > > +       unsigned int famfs_iomap:1;
> > > > > > > > > +
> > > > > > > > 
> > > > > > > > pls move up to the bit fields members.
> > > > > > > 
> > > > > > > Oops, done, thanks.
> > > > > > > 
> > > > > > > > 
> > > > > > > > >         /** Maximum stack depth for passthrough backing files */
> > > > > > > > >         int max_stack_depth;
> > > > > > > > >
> > > > > > > > > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > > > > > > > > index 29147657a99f..e48e11c3f9f3 100644
> > > > > > > > > --- a/fs/fuse/inode.c
> > > > > > > > > +++ b/fs/fuse/inode.c
> > > > > > > > > @@ -1392,6 +1392,18 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
> > > > > > > > >                         }
> > > > > > > > >                         if (flags & FUSE_OVER_IO_URING && fuse_uring_enabled())
> > > > > > > > >                                 fc->io_uring = 1;
> > > > > > > > > +                       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
> > > > > > > > > +                           flags & FUSE_DAX_FMAP) {
> > > > > > > > > +                               /* XXX: Should also check that fuse server
> > > > > > > > > +                                * has CAP_SYS_RAWIO and/or CAP_SYS_ADMIN,
> > > > > > > > > +                                * since it is directing the kernel to access
> > > > > > > > > +                                * dax memory directly - but this function
> > > > > > > > > +                                * appears not to be called in fuse server
> > > > > > > > > +                                * process context (b/c even if it drops
> > > > > > > > > +                                * those capabilities, they are held here).
> > > > > > > > > +                                */
> > > > > > > > > +                               fc->famfs_iomap = 1;
> > > > > > > > > +                       }
> > > > > > > > 
> > > > > > > > 1. As long as the mapping requests are checking capabilities we should be ok
> > > > > > > >     Right?
> > > > > > > 
> > > > > > > It depends on the definition of "are", or maybe of "mapping requests" ;)
> > > > > > > 
> > > > > > > Forgive me if this *is* obvious, but the fuse server capabilities are what
> > > > > > > I think need to be checked here - not the app that it accessing a file.
> > > > > > > 
> > > > > > > An app accessing a regular file doesn't need permission to do raw access to
> > > > > > > the underlying block dev, but the fuse server does - becuase it is directing
> > > > > > > the kernel to access that for apps.
> > > > > > > 
> > > > > > > > 2. What's the deal with capable(CAP_SYS_ADMIN) in process_init_limits then?
> > > > > > > 
> > > > > > > I *think* that's checking the capabilities of the app that is accessing the
> > > > > > > file, and not the fuse server. But I might be wrong - I have not pulled very
> > > > > > > hard on that thread yet.
> > > > > > 
> > > > > > The init reply should be processed in the context of the fuse server.
> > > > > > At that point the kernel hasn't exposed the fs to user programs, so
> > > > > > (AFAICT) there won't be any other programs accessing that fuse mount.
> > > > > 
> > > > > Hmm. It would be good if you're right about that. My fuse server *is* running
> > > > > as root, and when I check those capabilities in process_init_reply(), I
> > > > > find those capabilities. So far so good.
> > > > > 
> > > > > Then I added code to my fuse server to drop those capabilities prior to
> > > > > starting the fuse session (prctl(PR_CAPBSET_DROP, CAP_SYS_RAWIO) and 
> > > > > prctl(PR_CAPBSET_DROP, CAP_SYS_ADMIN). I expected (hoped?) to see those 
> > > > > capabilities disappear in process_init_reply() - but they did not disappear.
> > > > > 
> > > > > I'm all ears if somebody can see a flaw in my logic here. Otherwise, the
> > > > > capabilities need to be stashed away before the reply is processsed, when 
> > > > > fs/fuse *is* running in fuse server context.
> > > > > 
> > > > > I'm somewhat surprised if that isn't already happening somewhere...
> > > > 
> > > > Hrm.  I *thought* that since FUSE_INIT isn't queued as a background
> > > > command, it should still execute in the same process context as the fuse
> > > > server.
> > > > 
> > > > OTOH it also occurs to me that I have this code in fuse_send_init:
> > > > 
> > > > 	if (has_capability_noaudit(current, CAP_SYS_RAWIO))
> > > > 		flags |= FUSE_IOMAP | FUSE_IOMAP_DIRECTIO | FUSE_IOMAP_PAGECACHE;
> > > > 	...
> > > > 	ia->in.flags = flags;
> > > > 	ia->in.flags2 = flags >> 32;
> > > > 
> > > > which means that we only advertise iomap support in FUSE_INIT if the
> > > > process running fuse_fill_super (which you hope is the fuse server)
> > > > actually has CAP_SYS_RAWIO.  Would that work for you?  Or are you
> > > > dropping privileges before you even open /dev/fuse?
> > > 
> > > Ah - that might be the answer. I will check if dropped capabilities 
> > > disappear in fuse_send_init. If so, I can work with that - not advertising 
> > > the famfs capability unless the capability is present at that point looks 
> > > like a perfectly good option. Thanks for that idea!
> > 
> > Review: the famfs fuse server directs the kernel to provide access to raw
> > (memory) devices, so it should should be required to have have the
> > CAP_SYS_RAWIO capability. fs/fuse needs to detect this at init time,
> > and fail the connection/mount if the capability is missing.
> > 
> > I initially attempted to do this verification in process_init_reply(), but
> > that doesn't run in the fuse server process context.
> > 
> > I am now checking the capability in fuse_send_init(), and not advertising
> > the FUSE_DAX_FMAP capability (in in_args->flags[2]) unless the server has 
> > CAP_SYS_RAWIO.
> > 
> > That requires that process_init_reply() reject FUSE_DAX_FMAP from a server
> > if FUSE_DAX_FMAP was not set in in_args->flags[2]. process_init_reply() was
> > not previously checking the in_args, but no big deal - this works.
> > 
> > This leads to an apparent dilemma in libfuse. In fuse_lowlevel_ops->init(),
> > I should check for (flags & FUSE_DAX_IOMAP), and fail the connection if
> > that capability is not on offer. But fuse_lowlevel_ops->init() doesn't
> > have an obvious way to fail the connection. 
> 
> Yeah, I really wish it did.  I particularly wish that it had a way to
> negotiate all the FUSE_INIT stuff before libfuse daemonizes and starts
> up the event loop.  Well, not all of it -- by the time we get to
> FUSE_INIT we've basically decided to commit to mounting.
> 
> For fuseblk servers this is horrible, because the kernel needs to be
> able to open the block device with O_EXCL during the mount() process,
> which means you actually have to be able to (re)open the block device
> from op_init, which can fail.  Unless there's a way to drop O_EXCL from
> an open fd?
> 
> The awful way that I handle failure in FUSE_INIT is to call
> fuse_session_exit, but that grossly leaves a dead mount in its place.
> 
> Hey wait, is this what Mikulas was talking about when he mentioned
> synchronous initialization?
> 
> For iomap I created a discovery ioctl so that you can open /dev/fuse and
> ask the kernel about the iomap functionality that it supports, and you
> can exit(1) without creating a fuse session.  The one goofy problem with
> that is that there's a TOCTOU race if someone else does echo N >
> /sys/module/fuse/parameters/enable_iomap, though fuse4fs can always
> fall back to non-iomap mode.
> 
> --D

Thanks Darrick.

Hmm - synchronous init would be nice.

I tried calling fuse_session_exit(), but the broken mount was not an
improvement over a can't-do-I/O mount - which I get if the kernel rejects 
the capability currently known as FUSE_DAX_FMAP due to lack of CAP_SYS_RAWIO.

In my case, I think letting the mount complete with FUSE_DAX_FMAP rejected
is easier to detect and cleanup than a fuse_session_exit() aborted mount.

Famfs mount is a cli operation that does a sequence of stuff before and after
the fork/exec of the famfs fuse server. That fork/exec can't really return 
an error in the conventional sense, so I'm stuck diagnosing whether the 
mount is good (which I already do, but it's a WIP). 

I already have to poll for the .meta files to appear (superblock and log), 
and that can be adapted pretty easily to check whether they can be read 
correctly (which they can't if famfs doesn't have daxdev access).

If mount was synchronous, I'd still need to give the fork/exec enough time
to fail and then detect that. That would probably be cleaner, but not by
a huge amount.

Thanks,
John

<snip>

