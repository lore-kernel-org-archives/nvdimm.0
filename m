Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A996FC5
	for <nvdimm@lists.linux.dev>; Fri, 11 Jul 2025 01:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752197540; cv=none; b=dmTtJiSE1zx69thpGeUt2omsZragzOVnT8lXKtd9LKoTk7kETzz0WsDONpm6YvTnxGHKLzjNypZ6EZhj2VUMyMeJso1GNoIuytbT+3mpNdcFrPk7o6K1aY/oiSCbaljUv8wrn3fAP2n2/Turk90JOwyOmh9a7tb5VRaIuPGNHL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752197540; c=relaxed/simple;
	bh=CKXvvxaHebrXQfNhSPrEzZD6qgE2lsscG0q1tH5pt/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jR1YPynDZZp32PU7QrCqq0A/sudYvuYOFiV4/wPVs5Qutb+VhQHQQFycWRikBBOF0C6T59qRG4bqyu56tx+FDGT3aA13lL1Zdq8Et78123vl4/ppGJNunlXEtdSjxAJU/0Y69khKPRf6evj4Ylu5ADbdbXTj+JG4+CZSRgSo0uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EIZHnBtL; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EIZHnBtL"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-73caf1152bdso741815a34.3
        for <nvdimm@lists.linux.dev>; Thu, 10 Jul 2025 18:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752197537; x=1752802337; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YiweCKjgFw6vGUv1NePRFx77ntMi7TxsGN2+4y1P0/0=;
        b=EIZHnBtLhGqbtz90snDrll7xDwDOfUzhaFFRfJ8861CUtXBPcKCkPLcO9+vXM4MyER
         lgz8bZmAqO6Gtm3kLojkU7nSGkYdyA53zN4oyNiLadanoYE6GVaDgrkIOT8+Kamt16vg
         Obk1RMNyAyUmBAnXWmZ1dIeqeS1V3O9xWmvsfZb/+Xz6x29bAyzHf/6GUA0CFkaCiue6
         JYPHuEnO8q3a4a5YxUvg1Qi2gRuRcF4qSrrgFw2JEZa+mS5PcpeV+GoGi8M2sYVdyUJ4
         +0nzp8sYPTdEIB+Grcax6oAYm5Vt5UOVRmSik8P+oSKg+UvjsU06OTcmkzFLrSZBR2/Q
         4hsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752197537; x=1752802337;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YiweCKjgFw6vGUv1NePRFx77ntMi7TxsGN2+4y1P0/0=;
        b=qjlnBllbTPJccVttN2spBO9yYaTzlmpzMvBnZzPISqo6Fbvqi/FYK6ccXgYoZwQieB
         3ZXuxlNVyYc2DtLLs3nwGN00ZBwgN92AU7km7JzRV2XUMnSNC3NOdtGsZAx5KOjwAjyX
         NRfjE70jvORTjXdlOov1e/O+BHiZtaXyIiv9fzcTDlF7rveO5EmjF2FG81T3fxOH6P/3
         8bOBI6Ivh846CobsusxYO6C3xv8BemVVv2PwhITK9OPk6iYJppidM6Rz8l+3zuEO3okl
         Mf+HK6c9IGlnG6bWEzLNZ1ILoM34wCZYmA0WfYP4rHEQVop4Ii7yooe1koQ2qfQXXlu4
         afAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSE1LHV9rvgvi2KOR5iVHlLnXB8Qv3inSqzE+JdE6XBOJJkQ6whtbec2u15MjbA1TT/avF3Q4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz03h17LQ63xMT0Q+6ePdpR9/w/Eqg9xlN1M43FHLpfipnv6VVh
	1K7ReRbvSlnND4KnLTYSFDoY/+d5WXGAcaUXol3jOiO6bGZlfkXlv/Za7JnFbGWI
X-Gm-Gg: ASbGncsj8vbnO/gwkIYAg5lwMN3l91S4/EAH1F9OLjAIIiCFxMLGcqF+RajrAjY9XoZ
	H24I0p1VwaoTqBtWmLZ1tIVqorTvrkaplbuXYOKYBD4wKqNzwGtd1Geksr8LoFxPiPeqWQu7Sbc
	NIrazcudfdT6Us6F3Otzlai6imim17OdhWNR6as8I0gUhztDCOxYnLRwVIBZGSn1zuU7xi1QO1Y
	l2YFIvlVNGDY8pSXgqi6GxZ1uzQA7CoQH51qrvizB/Cx7Wr7aaofrZzjz9kNDcvu3PtHjaBnoPy
	VXKhzxhnBf44yBj+M7QV0XDpOR87OSg6F70iIAeD98TKCvPhbg5bcbqwpx93+AwrIIuPKHo9SzD
	BRxz8JCbGX5RfziI3+Ed3uGfXQvUtNrQ+e0UV
X-Google-Smtp-Source: AGHT+IG4OQ4RGKPIQAtxam3MPA3mdWbg+LYWtIDggxBK7DL3lhUQ9aFSO8NNXxdSJZlYCW2Y4xalfQ==
X-Received: by 2002:a05:6830:8107:b0:739:fa45:5918 with SMTP id 46e09a7af769-73cfc4a5334mr208039a34.28.1752197536496;
        Thu, 10 Jul 2025 18:32:16 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:25b0:db8a:a7d3:ffe1])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73cf12a4c21sm393479a34.46.2025.07.10.18.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jul 2025 18:32:15 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 10 Jul 2025 20:32:13 -0500
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
Message-ID: <wam2qo5r7tbpf4ork5qcdqnw4olhfpkvlqpnbuqpwfhrymf3dq@hw3frnbadhk7>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-11-john@groves.net>
 <CAOQ4uxi7fvMgYqe1M3_vD3+YXm7x1c4YjA=eKSGLuCz2Dsk0TQ@mail.gmail.com>
 <yhso6jddzt6c7glqadrztrswpisxmuvg7yopc6lp4gn44cxd4m@my4ajaw47q7d>
 <20250707173942.GC2672029@frogsfrogsfrogs>
 <ueepqz3oqeqzwiidk2wlf3f7enxxte4ws27gtxhakfmdiq4t26@cvfmozym5rme>
 <20250709015348.GD2672029@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250709015348.GD2672029@frogsfrogsfrogs>

On 25/07/08 06:53PM, Darrick J. Wong wrote:
> On Tue, Jul 08, 2025 at 07:02:03AM -0500, John Groves wrote:
> > On 25/07/07 10:39AM, Darrick J. Wong wrote:
> > > On Fri, Jul 04, 2025 at 08:39:59AM -0500, John Groves wrote:
> > > > On 25/07/04 09:54AM, Amir Goldstein wrote:
> > > > > On Thu, Jul 3, 2025 at 8:51 PM John Groves <John@groves.net> wrote:
> > > > > >
> > > > > > * FUSE_DAX_FMAP flag in INIT request/reply
> > > > > >
> > > > > > * fuse_conn->famfs_iomap (enable famfs-mapped files) to denote a
> > > > > >   famfs-enabled connection
> > > > > >
> > > > > > Signed-off-by: John Groves <john@groves.net>
> > > > > > ---
> > > > > >  fs/fuse/fuse_i.h          |  3 +++
> > > > > >  fs/fuse/inode.c           | 14 ++++++++++++++
> > > > > >  include/uapi/linux/fuse.h |  4 ++++
> > > > > >  3 files changed, 21 insertions(+)
> > > > > >
> > > > > > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > > > > > index 9d87ac48d724..a592c1002861 100644
> > > > > > --- a/fs/fuse/fuse_i.h
> > > > > > +++ b/fs/fuse/fuse_i.h
> > > > > > @@ -873,6 +873,9 @@ struct fuse_conn {
> > > > > >         /* Use io_uring for communication */
> > > > > >         unsigned int io_uring;
> > > > > >
> > > > > > +       /* dev_dax_iomap support for famfs */
> > > > > > +       unsigned int famfs_iomap:1;
> > > > > > +
> > > > > 
> > > > > pls move up to the bit fields members.
> > > > 
> > > > Oops, done, thanks.
> > > > 
> > > > > 
> > > > > >         /** Maximum stack depth for passthrough backing files */
> > > > > >         int max_stack_depth;
> > > > > >
> > > > > > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > > > > > index 29147657a99f..e48e11c3f9f3 100644
> > > > > > --- a/fs/fuse/inode.c
> > > > > > +++ b/fs/fuse/inode.c
> > > > > > @@ -1392,6 +1392,18 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
> > > > > >                         }
> > > > > >                         if (flags & FUSE_OVER_IO_URING && fuse_uring_enabled())
> > > > > >                                 fc->io_uring = 1;
> > > > > > +                       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
> > > > > > +                           flags & FUSE_DAX_FMAP) {
> > > > > > +                               /* XXX: Should also check that fuse server
> > > > > > +                                * has CAP_SYS_RAWIO and/or CAP_SYS_ADMIN,
> > > > > > +                                * since it is directing the kernel to access
> > > > > > +                                * dax memory directly - but this function
> > > > > > +                                * appears not to be called in fuse server
> > > > > > +                                * process context (b/c even if it drops
> > > > > > +                                * those capabilities, they are held here).
> > > > > > +                                */
> > > > > > +                               fc->famfs_iomap = 1;
> > > > > > +                       }
> > > > > 
> > > > > 1. As long as the mapping requests are checking capabilities we should be ok
> > > > >     Right?
> > > > 
> > > > It depends on the definition of "are", or maybe of "mapping requests" ;)
> > > > 
> > > > Forgive me if this *is* obvious, but the fuse server capabilities are what
> > > > I think need to be checked here - not the app that it accessing a file.
> > > > 
> > > > An app accessing a regular file doesn't need permission to do raw access to
> > > > the underlying block dev, but the fuse server does - becuase it is directing
> > > > the kernel to access that for apps.
> > > > 
> > > > > 2. What's the deal with capable(CAP_SYS_ADMIN) in process_init_limits then?
> > > > 
> > > > I *think* that's checking the capabilities of the app that is accessing the
> > > > file, and not the fuse server. But I might be wrong - I have not pulled very
> > > > hard on that thread yet.
> > > 
> > > The init reply should be processed in the context of the fuse server.
> > > At that point the kernel hasn't exposed the fs to user programs, so
> > > (AFAICT) there won't be any other programs accessing that fuse mount.
> > 
> > Hmm. It would be good if you're right about that. My fuse server *is* running
> > as root, and when I check those capabilities in process_init_reply(), I
> > find those capabilities. So far so good.
> > 
> > Then I added code to my fuse server to drop those capabilities prior to
> > starting the fuse session (prctl(PR_CAPBSET_DROP, CAP_SYS_RAWIO) and 
> > prctl(PR_CAPBSET_DROP, CAP_SYS_ADMIN). I expected (hoped?) to see those 
> > capabilities disappear in process_init_reply() - but they did not disappear.
> > 
> > I'm all ears if somebody can see a flaw in my logic here. Otherwise, the
> > capabilities need to be stashed away before the reply is processsed, when 
> > fs/fuse *is* running in fuse server context.
> > 
> > I'm somewhat surprised if that isn't already happening somewhere...
> 
> Hrm.  I *thought* that since FUSE_INIT isn't queued as a background
> command, it should still execute in the same process context as the fuse
> server.
> 
> OTOH it also occurs to me that I have this code in fuse_send_init:
> 
> 	if (has_capability_noaudit(current, CAP_SYS_RAWIO))
> 		flags |= FUSE_IOMAP | FUSE_IOMAP_DIRECTIO | FUSE_IOMAP_PAGECACHE;
> 	...
> 	ia->in.flags = flags;
> 	ia->in.flags2 = flags >> 32;
> 
> which means that we only advertise iomap support in FUSE_INIT if the
> process running fuse_fill_super (which you hope is the fuse server)
> actually has CAP_SYS_RAWIO.  Would that work for you?  Or are you
> dropping privileges before you even open /dev/fuse?

Ah - that might be the answer. I will check if dropped capabilities 
disappear in fuse_send_init. If so, I can work with that - not advertising 
the famfs capability unless the capability is present at that point looks 
like a perfectly good option. Thanks for that idea!

> 
> Note: I might decide to relax that approach later on, since iomap
> requires you to have opened a block device ... which implies that the
> process had read/write access to start with; and maybe we're ok with
> unprivileged fuse2fs servers running on a chmod 666 block device?
> 
> <shrug> always easier to /relax/ the privilege checks. :)

My policy on security is that I'm against it...

> 
> > > > > 3. Darrick mentioned the need for a synchronic INIT variant for his work on
> > > > >     blockdev iomap support [1]
> > > > 
> > > > I'm not sure that's the same thing (Darrick?), but I do think Darrick's
> > > > use case probably needs to check capabilities for a server that is sending
> > > > apps (via files) off to access extents of block devices.
> > > 
> > > I don't know either, Miklos hasn't responded to my questions.  I think
> > > the motivation for a synchronous 
> > 
> > ?
> 
> ..."I don't know what his motivations for synchronous FUSE_INIT are."
> 
> I guess I fubard vim. :(

So I'm not alone...

> 
> > > As for fuse/iomap, I just only need to ask the kernel if iomap support
> > > is available before calling ext2fs_open2() because the iomap question
> > > has some implications for how we open the ext4 filesystem.
> > > 
> > > > > I also wonder how much of your patches and Darrick's patches end up
> > > > > being an overlap?
> > > > 
> > > > Darrick and I spent some time hashing through this, and came to the conclusion
> > > > that the actual overlap is slim-to-none. 
> > > 
> > > Yeah.  The neat thing about FMAPs is that you can establish repeating
> > > patterns, which is useful for interleaved DRAM/pmem devices.  Disk
> > > filesystems don't do repeating patterns, so they'd much rather manage
> > > non-repeating mappings.
> > 
> > Right. Interleaving is critical to how we use memory, so fmaps are designed
> > to support it.
> > 
> > Tangent: at some point a broader-than-just-me discussion of how block devices
> > have the device mapper, but memory has no such layout tools, might be good
> > to have. Without such a thing (which might or might not be possible/practical),
> > it's essential that famfs do the interleaving. Lacking a mapper layer also
> > means that we need dax to provide a clean "device abstraction" (meaning
> > a single CXL allocation [which has a uuid/tag] needs to appear as a single
> > dax device whether or not it's HPA-contiguous).
> 
> Well it's not as simple as device-mapper, where we can intercept struct
> bio and remap/split it to our heart's content.  I guess you could do
> that with an iovec...?  Would be sorta amusing if you could software
> RAID10 some DRAM. :P

SW RAID, and mapper in general, has a "store and forward" property (or maybe
"store, transmogrify, and forward") that doesn't really work for memory. 
It's vma's (and files) that can remap memory address regions. Layered vma's 
anyone? I need to think about whether that's utter nonsense, or just mostly 
nonsense.

Continuing to think about this...

Thanks!
John


