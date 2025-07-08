Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD39E26B75A
	for <nvdimm@lists.linux.dev>; Tue,  8 Jul 2025 12:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751976131; cv=none; b=IzCRqyPomOeaXGsqTO5HeT9sBuyQmIoYYsj8auBL6yRTJB7iaXa7Jp7lU3ByysQachxsBRbEKjR0X1IygZk4XuTYWY2K7kjrdd3Pp702a9dEeXgPeMCoN/sFsIlR7t1FFmeSzS2MjVv02CsdwVVNBF/VB7dgZS0pEHcTEvuVpRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751976131; c=relaxed/simple;
	bh=Jn8hrsRg86sOLVXHmouC0yMQPqN2iUaDm1mOlavqijo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kivbi2YR+ETVmdZ5FoQAuD8fCZAWY+yAQgtd37A9D7v8wvxRqqykRU0xI5gS5MlQ0xsRoMKEYAltzvww9vc7X1poKFoj85hbPbwgB7aj2vey70dswgA6IXxepBXMux0xF/VWFPqvUc/4QKvtNmnElS1g77L4sYtJCGoTffG0Slk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bj56SdOK; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bj56SdOK"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-72c14138668so1412325a34.2
        for <nvdimm@lists.linux.dev>; Tue, 08 Jul 2025 05:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751976129; x=1752580929; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2uGq9fv0o0kRTxTwHbXLzg/jeWoB7j9lh1A3UENkLmc=;
        b=Bj56SdOKf+5XZtFCx0P3OB1aSOc4WdjChvUItxx5FRGLRe2lRCXET/QTgQcFA2RbkB
         9AH3gvTbQfcdJ+LDEULjQmkozunWv5ZgGoomyj9uP2wQbT2XhdjxZ8qTCCdrVvHBmH2G
         WK0+YjJvrcBZt8DAAZH+ZtaeyUq56fhotAhgWUkTAeQjNPbOJkeas9zXqxpF9DqDLfih
         SU2lEB1rvKumQJR6ajR7JvChJtmkhw9I0lNMeavdrbThwUbynwopZn/4e/ZJzZjDxp7H
         MSOuYeUUS0scQWCSlzct7V9Q4aJ8jZeyrF8GjrHQ93SfEJPcImIW6tn5PB3wgyNwAQxu
         yfRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751976129; x=1752580929;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2uGq9fv0o0kRTxTwHbXLzg/jeWoB7j9lh1A3UENkLmc=;
        b=YzobzcBC2S+BE8kP6xpXKgvM3LjnAuZAd8wZSYoho6Gogbu3rSKMnc2BiYeje9eytv
         lFYEnTJC+uSc8XJVcx4vC40lDmBkvYg1gjsTPF1ql/Q78xsotRB6mNzEik1QCDCTi0T2
         R/kZBAXEGHWgPVpaEpu1ubpTj5dZc445TDDbIuvFxAlFcWhB1bOrdH2a9+WXQRk3zJp2
         EvYWtTu15uqg5CdGIJ+zO7FAnYlXBWFZiOnBHAGSupaFjlKzKx4QQqg2/QHw4cnHuJ9l
         Ohp/0LZ2WJGxBbjKpLIde6gtmv71+p65NRsL3IOWDYxhLIwjoCFrh0Pv/2bfbu7kJskL
         kAEA==
X-Forwarded-Encrypted: i=1; AJvYcCX/RzGI3oQKELXkR3Ctl8yPeHFe/lr822MDvU9yoveKTZTvuJCfbIuzJUTwOyLGQLA7L0DeKJA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyav8fl30vVDXqVB8DJX7yQBZ7ktj76KbOBuyaCUa4RZmABmduX
	Z3EAPgLS0MhRewW7vofWVHYCj9J8b87guckWz7Fjf7OfhuT1d8ssyw5k
X-Gm-Gg: ASbGncsi+s1mwfPusFnck7MrYJpzf9sFf30bxE21ZFxNs+SlmUbt9pg7M2zIWGu8jqu
	WEz/cVrsHF+BkOz3hSPG95HA/n+tAJVs0AlZmg4/yifE+uIey7j2+RVlb42ukjvt2Vp63pJK5yH
	QK8+E/QlZCli/YzxNDYXTT4K++tyePRQys/549gSLGlLZzrQripjQ5KEoZCpd7upTrXHfRNsN7l
	wPndme2aZQm8dK2suv7ONjr/op1mBkmzffXHgBLUyPTJ4GX/RG6mhDKUVYYtIw2h4NO5+P2hiGq
	8HxHDuKgDA1a/ikLG7m6jx5g9+RfuMkDDmERxq9ea/3b794Tay6FlEBqwLM3MjgzWEi2COMAIQx
	d
X-Google-Smtp-Source: AGHT+IE/EwQcJny5luA2L1jmlPqgPI2OAQPJnI9paMkK4frs6m/TZ8wBkc3niX9u+apPS0vL9gnf0g==
X-Received: by 2002:a05:6808:4442:b0:40b:4208:8440 with SMTP id 5614622812f47-4110de96df3mr2403977b6e.3.1751976126686;
        Tue, 08 Jul 2025 05:02:06 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:a416:8b40:fe30:49a3])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-40d02aeed45sm1630594b6e.50.2025.07.08.05.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 05:02:05 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Tue, 8 Jul 2025 07:02:03 -0500
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
Message-ID: <ueepqz3oqeqzwiidk2wlf3f7enxxte4ws27gtxhakfmdiq4t26@cvfmozym5rme>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-11-john@groves.net>
 <CAOQ4uxi7fvMgYqe1M3_vD3+YXm7x1c4YjA=eKSGLuCz2Dsk0TQ@mail.gmail.com>
 <yhso6jddzt6c7glqadrztrswpisxmuvg7yopc6lp4gn44cxd4m@my4ajaw47q7d>
 <20250707173942.GC2672029@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250707173942.GC2672029@frogsfrogsfrogs>

On 25/07/07 10:39AM, Darrick J. Wong wrote:
> On Fri, Jul 04, 2025 at 08:39:59AM -0500, John Groves wrote:
> > On 25/07/04 09:54AM, Amir Goldstein wrote:
> > > On Thu, Jul 3, 2025 at 8:51 PM John Groves <John@groves.net> wrote:
> > > >
> > > > * FUSE_DAX_FMAP flag in INIT request/reply
> > > >
> > > > * fuse_conn->famfs_iomap (enable famfs-mapped files) to denote a
> > > >   famfs-enabled connection
> > > >
> > > > Signed-off-by: John Groves <john@groves.net>
> > > > ---
> > > >  fs/fuse/fuse_i.h          |  3 +++
> > > >  fs/fuse/inode.c           | 14 ++++++++++++++
> > > >  include/uapi/linux/fuse.h |  4 ++++
> > > >  3 files changed, 21 insertions(+)
> > > >
> > > > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > > > index 9d87ac48d724..a592c1002861 100644
> > > > --- a/fs/fuse/fuse_i.h
> > > > +++ b/fs/fuse/fuse_i.h
> > > > @@ -873,6 +873,9 @@ struct fuse_conn {
> > > >         /* Use io_uring for communication */
> > > >         unsigned int io_uring;
> > > >
> > > > +       /* dev_dax_iomap support for famfs */
> > > > +       unsigned int famfs_iomap:1;
> > > > +
> > > 
> > > pls move up to the bit fields members.
> > 
> > Oops, done, thanks.
> > 
> > > 
> > > >         /** Maximum stack depth for passthrough backing files */
> > > >         int max_stack_depth;
> > > >
> > > > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > > > index 29147657a99f..e48e11c3f9f3 100644
> > > > --- a/fs/fuse/inode.c
> > > > +++ b/fs/fuse/inode.c
> > > > @@ -1392,6 +1392,18 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
> > > >                         }
> > > >                         if (flags & FUSE_OVER_IO_URING && fuse_uring_enabled())
> > > >                                 fc->io_uring = 1;
> > > > +                       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
> > > > +                           flags & FUSE_DAX_FMAP) {
> > > > +                               /* XXX: Should also check that fuse server
> > > > +                                * has CAP_SYS_RAWIO and/or CAP_SYS_ADMIN,
> > > > +                                * since it is directing the kernel to access
> > > > +                                * dax memory directly - but this function
> > > > +                                * appears not to be called in fuse server
> > > > +                                * process context (b/c even if it drops
> > > > +                                * those capabilities, they are held here).
> > > > +                                */
> > > > +                               fc->famfs_iomap = 1;
> > > > +                       }
> > > 
> > > 1. As long as the mapping requests are checking capabilities we should be ok
> > >     Right?
> > 
> > It depends on the definition of "are", or maybe of "mapping requests" ;)
> > 
> > Forgive me if this *is* obvious, but the fuse server capabilities are what
> > I think need to be checked here - not the app that it accessing a file.
> > 
> > An app accessing a regular file doesn't need permission to do raw access to
> > the underlying block dev, but the fuse server does - becuase it is directing
> > the kernel to access that for apps.
> > 
> > > 2. What's the deal with capable(CAP_SYS_ADMIN) in process_init_limits then?
> > 
> > I *think* that's checking the capabilities of the app that is accessing the
> > file, and not the fuse server. But I might be wrong - I have not pulled very
> > hard on that thread yet.
> 
> The init reply should be processed in the context of the fuse server.
> At that point the kernel hasn't exposed the fs to user programs, so
> (AFAICT) there won't be any other programs accessing that fuse mount.

Hmm. It would be good if you're right about that. My fuse server *is* running
as root, and when I check those capabilities in process_init_reply(), I
find those capabilities. So far so good.

Then I added code to my fuse server to drop those capabilities prior to
starting the fuse session (prctl(PR_CAPBSET_DROP, CAP_SYS_RAWIO) and 
prctl(PR_CAPBSET_DROP, CAP_SYS_ADMIN). I expected (hoped?) to see those 
capabilities disappear in process_init_reply() - but they did not disappear.

I'm all ears if somebody can see a flaw in my logic here. Otherwise, the
capabilities need to be stashed away before the reply is processsed, when 
fs/fuse *is* running in fuse server context.

I'm somewhat surprised if that isn't already happening somewhere...

> 
> > > 3. Darrick mentioned the need for a synchronic INIT variant for his work on
> > >     blockdev iomap support [1]
> > 
> > I'm not sure that's the same thing (Darrick?), but I do think Darrick's
> > use case probably needs to check capabilities for a server that is sending
> > apps (via files) off to access extents of block devices.
> 
> I don't know either, Miklos hasn't responded to my questions.  I think
> the motivation for a synchronous 

?

> 
> As for fuse/iomap, I just only need to ask the kernel if iomap support
> is available before calling ext2fs_open2() because the iomap question
> has some implications for how we open the ext4 filesystem.
> 
> > > I also wonder how much of your patches and Darrick's patches end up
> > > being an overlap?
> > 
> > Darrick and I spent some time hashing through this, and came to the conclusion
> > that the actual overlap is slim-to-none. 
> 
> Yeah.  The neat thing about FMAPs is that you can establish repeating
> patterns, which is useful for interleaved DRAM/pmem devices.  Disk
> filesystems don't do repeating patterns, so they'd much rather manage
> non-repeating mappings.

Right. Interleaving is critical to how we use memory, so fmaps are designed
to support it.

Tangent: at some point a broader-than-just-me discussion of how block devices
have the device mapper, but memory has no such layout tools, might be good
to have. Without such a thing (which might or might not be possible/practical),
it's essential that famfs do the interleaving. Lacking a mapper layer also
means that we need dax to provide a clean "device abstraction" (meaning
a single CXL allocation [which has a uuid/tag] needs to appear as a single
dax device whether or not it's HPA-contiguous).

Cheers,
John

