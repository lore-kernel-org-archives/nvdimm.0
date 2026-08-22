Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6027819C54E;
	Sat, 22 Aug 2026 00:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787357958; cv=none; b=hSPAsiefm1TLXKQpad25N9t6y8622UBc4+DcvlVJdXRd+qwcLzcLJ+M44OXWrsWIowmTYx7UUBugs2UHfzpcLgkRS+cd82goccDbZH+vaZjPXWsqMPkUwLZ6tV6s+xYyoycRC1LGwxbdONiizD28nT6WxgZNMYofEC7eiuPSbKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787357958; c=relaxed/simple;
	bh=xcAEKuPAKnEGPK9IHZJSbmHbwWVMUA0lEwSeZH+J5Io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hP7I4xaq31iP0RuFKHa/UmioYiO54q+djgf0x+hFPyvxv2wUoUb74E0jHqc7CWPtoJ3mk6IyetlVarZMIrsLGtg5NfKYLMKom79UslA2Um+mZohQNAbl+Wf8eBBVT2dcT428BdYoFGmELfOq1NzArjjW/TDK2JUOtVgz4gg39SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SAZXBWZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SAZXBWZS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D6CB41F00A3A;
	Sat, 22 Aug 2026 00:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787357956;
	bh=3ZJYDFJHaezR/2gJAyomKVbnuMeKoOMTqf75a0uVxcE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SAZXBWZSS/mrx2ICxdBEoFI3elgmWHt1X+3gedci1vfn5akcFDj6scJBBdxorjgct
	 IrJzYnQxOcAw+QiX67JHnBN1/z3O87sN5zREvTdUIYaLfWmozvN3bRgwpjPab0V5yV
	 HCgeIefiM2f6DJ7Fbfza+5MU7sil+SeMd+X9AWJa2r/+gJE4qT/Jgfha16D/9+QraP
	 ZbZOPyF+3wNxntXw74dih1b2QMVuVydWLOPKHGxbAYHCSLzV3rI14rngroOi1hUJQb
	 4cQisUXoY4rO/KoJBQbi+EonHYBH6REaKh8eKfEOQ4ALZpgDLQPGXQhIKHG0WfKrGc
	 wFgjAqYBANIvQ==
Date: Fri, 21 Aug 2026 17:19:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: John Groves <john@jagalactic.com>, John Groves <John@groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <djbw@kernel.org>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ira Weiny <iweiny@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Gabriel Whigham <gabewhigham@gmail.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH v13 00/12] famfs: the Fabric-Attached Memory File System
 (standalone)
Message-ID: <20260822001916.GD6047@frogsfrogsfrogs>
References: <20260810202325.96202-1-john@jagalactic.com>
 <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
 <1f218de3db5bb7a89e56bb100fd4a4b87e5dc536.camel@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f218de3db5bb7a89e56bb100fd4a4b87e5dc536.camel@kernel.org>

On Thu, Aug 20, 2026 at 08:37:13AM -0400, Jeff Layton wrote:
> On Mon, 2026-08-10 at 20:23 +0000, John Groves wrote:
> > From: John Groves <john@groves.net>
> > 
> > This is v13 of famfs, as a standalone file system. v12 is at [7].
> > 
> > Most of this cover letter repeats v12. If you have read it, skip to "Changes
> > since v12" below and to the per-patch changelogs under the "---" line of each
> > patch. The history goes back to 2023, and is briefly covered in the v12
> > cover.
> > 
> > The most important thing to know about famfs is that it CANNOT be used as a
> > general purpose file system. It is for enabling file-based byte-level access
> > (including direct mmap) to very large (e.g. 100TB) shared/disaggregated
> > memory appliances - which have become available during this long process,
> > and which are in need of Linux support.
> > 
> > So famfs cannot be used by anybody who doesn't know why they need it. Making
> > famfs standalone means it can't affect users who don't use it. Micron, as
> > well as other memory companies, need it, and do not intend to abandon it -
> > but imagine if we did: fs/famfs/ should be removed if the memory companies
> > can't be bothered to maintain it.
> > 
> > This code base has been in active CI and used globally by early adopters and
> > testers of disaggregated memory since 2024. I believe it is solid.
> > 
> > Why standalone (short version)
> > 
> > famfs was introduced at LPC 2023 and LSFMM 2024 [1] as a standalone file
> > system, then spent close to a year being ported to fuse/libfuse. After
> > maintaining famfs in both forms, I have concluded it makes more sense as a
> > standalone file system: fuse adds complexity to famfs (more complex, less
> > adaptable, less performant - and famfs files are memory, so access must run
> > at memory speed), while famfs adds complexity to fuse that is unlikely to see
> > constructive re-use. The full history and argument are in the v12 cover
> > letter [7].
> > 
> > Changes since v12
> > -----------------
> > 
> > - Patch 01 split, per Alison Schofield: the removal of the now-unused
> >   dax_dev_get() export is a standalone DAX cleanup that goes via the DAX tree
> >   and is posted separately [8]. Patch 01 of this series is reduced to adding
> >   the non-allocating lookup helper dax_dev_find().
> > 
> > - Darrick Wong's review comments are addressed across the series: the
> >   kill_*_super() rationale in the mount patch, the page_mkwrite/pfn_mkwrite
> >   write-fault comment, dropping the operation flags from iomap->flags in the
> >   resolver, and more.
> > 
> > - A number of findings from the Sashiko review bot are fixed:
> >     * mprotect() could bypass the FAMFS_OPT_WRITE gate (the check looked at
> >       VM_WRITE only, not VM_MAYWRITE);
> >     * rename() over an existing target bypassed the FAMFS_OPT_UNLINK /
> >       FAMFS_OPT_RMDIR policy that unlink()/rmdir() enforce;
> >     * splice()/sendfile() returned zeroes on these DAX files
> >       (filemap_splice_read -> copy_splice_read);
> >     * create/mkdir/mknod updated the child inode's timestamps instead of the
> >       parent directory's;
> >     * .map_pages (filemap_map_pages) was a no-op on DAX and is removed;
> >     * mount-parameter and module-namespace hygiene (reject unknown mount
> >       options; prefix the non-static lookup_daxdev()).
> >   A few Sashiko findings were considered and declined with rationale - for
> >   example generic_write_sync(), which is inert for a filesystem with no page
> >   cache, no writeback, and a noop_fsync ->fsync. Those are noted under the
> >   relevant patch.
> > 
> > - famfs now accepts 4 KiB extent alignment in addition to 2 MiB: the
> >   allocation unit may be 4 KiB or 2 MiB. 2 MiB-aligned extents still map with
> >   huge pages; 4 KiB-granular extents map with PTEs (the DAX fault path already
> >   falls back PMD -> PTE).
> > 
> > - MAP_SYNC is now supported (FOP_MMAP_SYNC). famfs fmap metadata is immutable
> >   after MAP_CREATE, so the MAP_SYNC durability guarantee is met with no
> >   metadata sync required.
> > 
> > - famfs is explicitly 64-bit only now (depends on 64BIT); it targets
> >   CXL/fabric-attached memory, which does not exist on 32-bit systems.
> > 
> > Famfs Overview
> > 
> > Famfs exposes sharable disaggregated memory as a file system. Famfs consumes
> > shared memory from [usually shared memory] dax devices, and provides
> > memory-mappable files that map directly to the memory - no page cache
> > involvement. Famfs differs from conventional file systems in fs-dax mode,
> > in that it handles in-memory metadata in a sharable way (which begins with
> > never caching dirty shared metadata). So a famfs file system can be mounted
> > from multiple nodes, provided they have access to the memory.
> > 
> > The key performance requirement is that famfs must resolve mapping faults
> > with minimal overhead. This is achieved by fully caching the file-to-devdax
> > metadata for all active files.
> > 
> > Famfs remains the first fs-dax file system that is backed by devdax rather
> > than pmem in fs-dax mode (hence the need for the new dax mode).
> > 
> > Famfs depends on the 'fsdev' dax mode which landed in 7.1 - it will only run
> > with an fsdev-mode (aka famfs-mode) daxdev as its backing device(s).
> > 
> > The famfs user space can be found at [6].
> > 
> > [1] https://lwn.net/Articles/983105/ (Famfs at LSFMM 2024)
> > [2] https://lwn.net/Articles/1020170/ (Famfs at LSFMM 2025, with patch link)
> > [3] https://lwn.net/Articles/1068686/ (LWN coverage of the patch thread)
> > [4] https://lwn.net/Articles/1082687/ (Famfs at LSFMM 2026)
> > [5] https://lore.kernel.org/linux-fsdevel/0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com/#b
> > [6] https://famfs.org
> > [7] https://lore.kernel.org/linux-fsdevel/20260806053409.GL3560084@frogsfrogsfrogs/T/#t (v12)
> > [8] https://lore.kernel.org/linux-cxl/0100019fd478eb93-a6bd48e4-b5f1-4871-93d4-582802956e6c-000000@email.amazonses.com/T/#u (Partial dax patch)
> > 
> > 
> > John Groves (12):
> >   dax: replace exported dax_dev_get() with non-allocating dax_dev_find()
> >   famfs: Module operations, fs_context, and mount
> >   famfs: Add daxdev table and dax notify_failure support
> >   famfs: Introduce inode_operations and super_operations
> >   famfs: Introduce file_operations read/write
> >   famfs: Introduce mmap and VM fault handling
> >   famfs: MAP_CREATE ioctl and fmap ingest (ABI 44)
> >   famfs: iomap_begin and file-to-dax offset resolution
> >   famfs: Register secondary daxdevs by path (FAMFSIOC_DAXDEV_OPEN)
> >   famfs: Add runtime operation-permission (opts) framework
> >   famfs: Report device capacity via statfs so df works
> >   famfs: Add documentation
> > 
> >  Documentation/filesystems/famfs.rst           |  142 +++
> >  Documentation/filesystems/index.rst           |    1 +
> >  .../userspace-api/ioctl/ioctl-number.rst      |    1 +
> >  MAINTAINERS                                   |    8 +
> >  drivers/dax/fsdev.c                           |   19 +
> >  drivers/dax/super.c                           |   38 +-
> >  fs/Kconfig                                    |    2 +
> >  fs/Makefile                                   |    1 +
> >  fs/famfs/Kconfig                              |   12 +
> >  fs/famfs/Makefile                             |    5 +
> >  fs/famfs/famfs_file.c                         | 1007 +++++++++++++++++
> >  fs/famfs/famfs_inode.c                        |  869 ++++++++++++++
> >  fs/famfs/famfs_internal.h                     |  162 +++
> >  fs/namei.c                                    |    1 +
> >  fs/super.c                                    |    7 +
> >  include/linux/dax.h                           |    7 +-
> >  include/linux/fs.h                            |    1 +
> >  include/uapi/linux/famfs_ioctl.h              |  160 +++
> >  include/uapi/linux/magic.h                    |    1 +
> >  19 files changed, 2441 insertions(+), 3 deletions(-)
> >  create mode 100644 Documentation/filesystems/famfs.rst
> >  create mode 100644 fs/famfs/Kconfig
> >  create mode 100644 fs/famfs/Makefile
> >  create mode 100644 fs/famfs/famfs_file.c
> >  create mode 100644 fs/famfs/famfs_inode.c
> >  create mode 100644 fs/famfs/famfs_internal.h
> >  create mode 100644 include/uapi/linux/famfs_ioctl.h
> > 
> > -- 
> > 2.53.0
> > 
> 
> I looked over the series and while I don't have the greatest grasp of
> DAX/CXL, the fs bits all look fairly self-contained and reasonable to
> me. The changes outside of fs/famfs are extremely minimal, so I'm not
> worried much about this breaking anything unrelated.
> 
> At this point, I think just taking this as a standalone fs is the right
> thing to do. This already has field deployments, so it's fairly well
> tested. If it turns out that the FUSE approach becomes more palatable
> later, we can just move to deprecate the standalone version then.
> 
> You and Richard discussed some (minimal) changes in patch #7. Assuming
> you resolve those, you can add:
> 
>     Reviewed-by: Jeff Layton <jlayton@kernel.org>
> 
> (but figure that's mostly for the fs and not mm parts).
> 

Except for the two patch that I complained about this time, you can add

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

to the rest of the patches.

> It's a little late for v7.3 given that the merge window is open now.
> Should we aim to get this into v7.4? That would give this a full cycle
> in linux-next too.

I think we should aim to merge either this famfs or the fuse famfs for
7.4.  No more delaying, this has been dragging on for too long.

--D
