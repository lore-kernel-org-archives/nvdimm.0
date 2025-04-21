Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8790221CC44
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 22:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745272842; cv=none; b=Fn+8q8X6G103Pvy0GIjxitT1R0kssxQP6bgFxuPh3DPgAePJAoMbm3AupDutfDFFTencDwP/elN7r2FWfzZwKaET7I05mhrJCZqErKhlJS5TxP4KuuBcZswBWBkD5RqrTAkNOJvaIVYduBcYe/PrR7ql2KYmAiJjhOLDd/AeuQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745272842; c=relaxed/simple;
	bh=6hzwII5miKQuG6SXtRPdqY/6kuFLzBriuYqkXPya9AA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WyRdYApSxEFtso2Zt+N+2CeiAK4zQOKk4AV5R52IKmUiXzELrGDKJ1OmD3Q/uRswPm/yV0AR/U6e6m49mxM5VSZyv0hJZj3t1w0rvC2iXx81Pq1Za3EaMR6+C2I0QLtaPLJnmMIqebu3C0O3X4iLDOgeG8A/tw84R1ft5Qc2r+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hYD4MDWe; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hYD4MDWe"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-72b7a53ceb6so2601117a34.0
        for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 15:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745272838; x=1745877638; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lXpQqv5uH3F8h/08supf4MY46lZuUGYq1TQBRFda+64=;
        b=hYD4MDWeKQvfNZcwE9bSorH6nmD+pOQAgf/wmU0Esc296L9u5ffQJeYAhSHq+fVJ3u
         bJVXkxhBI14Ff2nb1zZPg8Av5ujZt3uc2V77nvGQJzI8gP1OpQPqVtct3aTndM7IKvPr
         UstBcB8+8f4d5Anj5WOtHbXkjFCFw3GQVd5x6mlY5wW1jgJZI1WkU+kz3spvgWDi6MBR
         xbkKgjvjzcrA7qGS97Uh3YBPRTF9Xi4SlhTQc8JiIa7ooH3CZ2e9Qh8nevJCfYsaRUgj
         LdKxIPCRqMKBwjOLHxmEBGWFSWKMxsSMMWREXglygtQM2tU61NJgcCWaUEydZvcSqihB
         Af3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745272838; x=1745877638;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lXpQqv5uH3F8h/08supf4MY46lZuUGYq1TQBRFda+64=;
        b=Ux5NuEgTWeZ+dWS4/uXDh7ONU4d1KXlF0MKwxOMh9TdLzxWoR00uRAN0XIhWrRmJdE
         wXxkhGNkr4fjj5tc39kZzxuTi/UrQHxnt4aUJb9Uci6kkCTHOmUQcc5Uea2wiRoGF/Jk
         OlwM/HkYnXBHm9j1sNf5cmExsjVYsmLjPu7aTeRMOxErky1Um2H8H/Hu3wdz9+36HlDP
         PMWWlmuUE+SQLTyZJnbND/Ej+j8EmUXUXVkSlp+KDcO2pSx8ew40JqP7Vyj78/9IS6cz
         iH7Z1FZe7PNpj7mQCcRsUDhdN5xzcQeoiq7A6it4zVmLmyAB/r2lgW8hWQ9HRVTb+SeR
         pObQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhBvtu3xouZIh/OBkpG3LftnXjRuVBIhgA8hRGZcAI24cXUMc1Mc56VH863ljUN+UzaiJCIDY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjcBwx1U5dot6m1Pp2Ws9t/LTiptRJu96k4gWTP9d9mssnaS7p
	td+UnHjwG2GPAz2yCPSiDbpaJG7ABC6eZzvp9fb4C4XS7EQwnJhP
X-Gm-Gg: ASbGncv5cTgAlt1oTHqXgBLOBX0CfhWfLwADFA6/AfSSDtXgiQf+ySitttlyoUbwHYg
	zp7QoSBpVFYuoej9bOm0lQf/akpntHbu/MH5w2Ulju4QH+L3JU7buhE3U51PS5EIhawoBDKalEC
	ofWtcEsPrJNkCT/a1nAM9Xcn/6rMHWrOP336frwRevR8bnhRB2rzSnSwuqBB5KbzElc/8HR8ti7
	XA3r4qAMysJ3gYEwovYnaxV2txqFBg965nkh3lhvuZj91BPosQyGTDe0xRek5Q8uK9TydXWIamM
	/kTTj+kTh5KXiPSLgpHNu7rrIctAfXcFUqgHBA0hk46KIZPImYRtmSjvUY5G
X-Google-Smtp-Source: AGHT+IEDVc4jFKpog8BpBULIi4CIUTHFtA+7oU94cglSMMNMU/TJsJw7dEoU6QcfZkab31kBcOgZtg==
X-Received: by 2002:a05:6830:4111:b0:72b:974f:de49 with SMTP id 46e09a7af769-73005edb682mr8224337a34.7.1745272838287;
        Mon, 21 Apr 2025 15:00:38 -0700 (PDT)
Received: from Borg-550.local ([2603:8080:1500:3d89:c191:629b:fde5:2f06])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489de9esm1633128a34.63.2025.04.21.15.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Apr 2025 15:00:37 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 21 Apr 2025 17:00:35 -0500
From: John Groves <John@groves.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Luis Henriques <luis@igalia.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Petr Vorel <pvorel@suse.cz>, Brian Foster <bfoster@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC PATCH 00/19] famfs: port into fuse
Message-ID: <37ss7esexgblholq5wc5caeizhcjpjhjxsghqjtkxjqri4uxjp@gixtdlggap5i>
References: <20250421013346.32530-1-john@groves.net>
 <20250421182758.GJ25659@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250421182758.GJ25659@frogsfrogsfrogs>

On 25/04/21 11:27AM, Darrick J. Wong wrote:
> On Sun, Apr 20, 2025 at 08:33:27PM -0500, John Groves wrote:
> > Subject: famfs: port into fuse
> > 
> > This is the initial RFC for the fabric-attached memory file system (famfs)
> > integration into fuse. In order to function, this requires a related patch
> > to libfuse [1] and the famfs user space [2]. 
> > 
> > This RFC is mainly intended to socialize the approach and get feedback from
> > the fuse developers and maintainers. There is some dax work that needs to
> > be done before this should be merged (see the "poisoned page|folio problem"
> > below).
> 
> Note that I'm only looking at the fuse and iomap aspects of this
> patchset.  I don't know the devdax code at all.
> 
> > This patch set fully works with Linux 6.14 -- passing all existing famfs
> > smoke and unit tests -- and I encourage existing famfs users to test it.
> > 
> > This is really two patch sets mashed up:
> > 
> > * The patches with the dev_dax_iomap: prefix fill in missing functionality for
> >   devdax to host an fs-dax file system.
> > * The famfs_fuse: patches add famfs into fs/fuse/. These are effectively
> >   unchanged since last year.
> > 
> > Because this is not ready to merge yet, I have felt free to leave some debug
> > prints in place because we still find them useful; those will be cleaned up
> > in a subsequent revision.
> > 
> > Famfs Overview
> > 
> > Famfs exposes shared memory as a file system. Famfs consumes shared memory
> > from dax devices, and provides memory-mappable files that map directly to
> > the memory - no page cache involvement. Famfs differs from conventional
> > file systems in fs-dax mode, in that it handles in-memory metadata in a
> > sharable way (which begins with never caching dirty shared metadata).
> > 
> > Famfs started as a standalone file system [3,4], but the consensus at LSFMM
> > 2024 [5] was that it should be ported into fuse - and this RFC is the first
> > public evidence that I've been working on that.
> 
> This is very timely, as I just started looking into how I might connect
> iomap to fuse so that most of the hot IO path continues to run in the
> kernel, and userspace block device filesystem drivers merely supply the
> file mappings to the kernel.  In other words, we kick the metadata
> parsing craziness out of the kernel.

Coool!

> 
> > The key performance requirement is that famfs must resolve mapping faults
> > without upcalls. This is achieved by fully caching the file-to-devdax
> > metadata for all active files. This is done via two fuse client/server
> > message/response pairs: GET_FMAP and GET_DAXDEV.
> 
> Heh, just last week I finally got around to laying out how I think I'd
> want to expose iomap through fuse to allow ->iomap_begin/->iomap_end
> upcalls to a fuse server.  Note that I've done zero prototyping but
> "upload all the mappings at open time" seems like a reasonable place for
> me to start looking, especially for a filesystem with static mappings.
> 
> I think what I want to try to build is an in-kernel mapping cache (sort
> of like the one you built), only with upcalls to the fuse server when
> there is no mapping information for a given IO.  I'd probably want to
> have a means for the fuse server to put new mappings into the cache, or
> invalidate existing mappings.
> 
> (famfs obviously is a simple corner-case of that grandiose vision, but I
> still have a long way to get to my larger vision so don't take my words
> as any kind of requirement.)
> 
> > Famfs remains the first fs-dax file system that is backed by devdax rather
> > than pmem in fs-dax mode (hence the need for the dev_dax_iomap fixups).
> > 
> > Notes
> > 
> > * Once the dev_dax_iomap patches land, I suspect it may make sense for
> >   virtiofs to update to use the improved interface.
> > 
> > * I'm currently maintaining compatibility between the famfs user space and
> >   both the standalone famfs kernel file system and this new fuse
> >   implementation. In the near future I'll be running performance comparisons
> >   and sharing them - but there is no reason to expect significant degradation
> >   with fuse, since famfs caches entire "fmaps" in the kernel to resolve
> 
> I'm curious to hear what you find, performance-wise. :)
> 
> >   faults with no upcalls. This patch has a bit too much debug turned on to
> >   to that testing quite yet. A branch 
> 
> A branch ... what?

I trail off sometimes... ;)

> 
> > * Two new fuse messages / responses are added: GET_FMAP and GET_DAXDEV.
> > 
> > * When a file is looked up in a famfs mount, the LOOKUP is followed by a
> >   GET_FMAP message and response. The "fmap" is the full file-to-dax mapping,
> >   allowing the fuse/famfs kernel code to handle read/write/fault without any
> >   upcalls.
> 
> Huh, I'd have thought you'd wait until FUSE_OPEN to start preloading
> mappings into the kernel.

That may be a better approach. Miklos and I discussed it during LPC last year, 
and thought both were options. Having implemented it at LOOKUP time, I think
moving it to open might avoid my READDIRPLUS problem (which is that RDP is a
mashup of READDIR and LOOKUP), therefore might need to add the GET_FMAP
payload. Moving GET_FMAP to open time, would break that connection in a good
way, I think.

> 
> > * After each GET_FMAP, the fmap is checked for extents that reference
> >   previously-unknown daxdevs. Each such occurence is handled with a
> >   GET_DAXDEV message and response.
> 
> I hadn't figured out how this part would work for my silly prototype.
> Just out of curiosity, does the famfs fuse server hold an open fd to the
> storage, in which case the fmap(ping) could just contain the open fd?
> 
> Where are the mappings that are sent from the fuse server?  Is that
> struct fuse_famfs_simple_ext?

See patch 17 or fs/fuse/famfs_kfmap.h for the fmap metadata explanation. 
Famfs currently supports either simple extents (daxdev, offset, length) or 
interleaved ones (which describe each "strip" as a simple extent). I think 
the explanation in famfs_kfmap.h is pretty clear.

A key question is whether any additional basic metadata abstractions would
be needed - because the kernel needs to understand the full scheme.

With disaggregated memory, the interleave approach is nice because it gets
aggregated performance and resolving a file offset to daxdev offset is order
1.

Oh, and there are two fmap formats (ok, more, but the others are legacy ;).
The fmaps-in-messages structs are currently in the famfs section of
include/uapi/linux/fuse.h. And the in-memory version is in 
fs/fuse/famfs_kfmap.h. The former will need to be a versioned interface.
(ugh...)

> 
> > * Daxdevs are stored in a table (which might become an xarray at some point).
> >   When entries are added to the table, we acquire exclusive access to the
> >   daxdev via the fs_dax_get() call (modeled after how fs-dax handles this
> >   with pmem devices). famfs provides holder_operations to devdax, providing
> >   a notification path in the event of memory errors.
> > 
> > * If devdax notifies famfs of memory errors on a dax device, famfs currently
> >   bocks all subsequent accesses to data on that device. The recovery is to
> >   re-initialize the memory and file system. Famfs is memory, not storage...
> 
> Ouch. :)

Cautious initial approach (i.e. I'm trying not to scare people too much ;) 

> 
> > * Because famfs uses backing (devdax) devices, only privileged mounts are
> >   supported.
> > 
> > * The famfs kernel code never accesses the memory directly - it only
> >   facilitates read, write and mmap on behalf of user processes. As such,
> >   the RAS of the shared memory affects applications, but not the kernel.
> > 
> > * Famfs has backing device(s), but they are devdax (char) rather than
> >   block. Right now there is no way to tell the vfs layer that famfs has a
> >   char backing device (unless we say it's block, but it's not). Currently
> >   we use the standard anonymous fuse fs_type - but I'm not sure that's
> >   ultimately optimal (thoughts?)
> 
> Does it work if the fusefs server adds "-o fsname=<devdax cdev>" to the
> fuse_args object?  fuse2fs does that, though I don't recall if that's a
> reasonable thing to do.

The kernel needs to "own" the dax devices. fs-dax on pmem/block calls
fs_dax_get_by_bdev() and passes in holder_operations - which are used for
error upcalls, but also effect exclusive ownership. 

I added fs_dax_get() since the bdev version wasn't really right or char
devdax. But same holder_operations.

I had originally intended to pass in "-o daxdev=<cdev>", but famfs needs to
span multiple daxdevs, in order to interleave for performance. The approach
of retrieving them with GET_DAXDEV handles the generalized case, so "-o"
just amounts to a second way to do the same thing.

"But wait"... I thought. Doesn't the "-o" approach get the primary daxdev
locked up sooner, which might be good? Well, no, because famfs creates a
couple of meta files during mount .meta/.superblock and .meta/.log - and 
those are guaranteed to reference the primary daxdev. So I concluded the -o
approach wasn't worth the trouble (though it's not *much* trouble).

> 
> > The "poisoned page|folio problem"
> > 
> > * Background: before doing a kernel mount, the famfs user space [2] validates
> >   the superblock and log. This is done via raw mmap of the primary devdax
> >   device. If valid, the file system is mounted, and the superblock and log
> >   get exposed through a pair of files (.meta/.superblock and .meta/.log) -
> >   because we can't be using raw device mmap when a file system is mounted
> >   on the device. But this exposes a devdax bug and warning...
> > 
> > * Pages that have been memory mapped via devdax are left in a permanently
> >   problematic state. Devdax sets page|folio->mapping when a page is accessed
> >   via raw devdax mmap (as famfs does before mount), but never cleans it up.
> >   When the pages of the famfs superblock and log are accessed via the "meta"
> >   files after mount, we see a WARN_ONCE() in dax_insert_entry(), which
> >   notices that page|folio->mapping is still set. I intend to address this
> >   prior to asking for the famfs patches to be merged.
> > 
> > * Alistair Popple's recent dax patch series [6], which has been merged
> >   for 6.15, addresses some dax issues, but sadly does not fix the poisoned
> >   page|folio problem - its enhanced refcount checking turns the warning into
> >   an error.
> > 
> > * This 6.14 patch set disables the warning; a proper fix will be required for
> >   famfs to work at all in 6.15. Dan W. and I are actively discussing how to do
> >   this properly...
> > 
> > * In terms of the correct functionality of famfs, the warning can be ignored.
> > 
> > References
> > 
> > [1] - https://github.com/libfuse/libfuse/pull/1200
> > [2] - https://github.com/cxl-micron-reskit/famfs
> 
> Thanks for posting links, I'll have a look there too.
> 
> --D
> 

I'm happy to talk if you wanna kick ideas around.

Cheers,
John

