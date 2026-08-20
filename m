Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DFD442FB9;
	Thu, 20 Aug 2026 12:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229440; cv=none; b=GHDzJaZBrd7yiRc0RAXaHf5Hi9/5rx6OVoog+AhwtKbrtEdI1nwZWlrZ6DVeO93XCWnx2RcJH+mFKxqvg4bJSQW+BzObra3xEnfCIWEQBYc8z4zWubkBveAXKkuRDkvks4eo88jmMIp+OFZUf56vYU7CuDYeXPCZKOJeSp5nupY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229440; c=relaxed/simple;
	bh=Xo5H0uKvYwj+XAKUm2yiMtUKonkVDS/xrj/m6w9z0SI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sw+ig+79zZrv3UHBOt7V8zF6yvuaSWCB+zR34keP2kcZbVrx085TN2z/vqreRq+oImLagUQZ5ooSoZHRCqcpGvzJR7ezLN2fkRYRDSYDhDZIp5v6ER3SvCfqMZJmz0N1ti/o80yDsxZuCWF59ULjEkYhqIQduHm39MdtYqFXvd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUbHW4aL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUbHW4aL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE1E1F000E9;
	Thu, 20 Aug 2026 12:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787229438;
	bh=OQpLOvB54LuGw8DzYe60oPZGDZAiKE8dvH2B4xQo3I4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GUbHW4aLYVRspV94M1rzQdL4joanhEC4j6cAyaqhy870zFoAEh4BFZg9S1XTqvfRu
	 8liJ9S9xzTOo5vwTTbIw90lgo5WfXD8Zrvyme19y1dz8VPKnn9g8+pGzopSQGdD9zN
	 34ZQI35a9gEE6ZkGxGJnmGQUCfDYGmrFJ9Y8/cTPE5wD3xn1tz30hDr9qvJ/ySNCiw
	 6boTc+/NT3GWrA9R1UhE9aAAj05ZBzVB5AXNQ6viYu8+c2U9oraZRNk+QoVqXwMsKq
	 Nug+g1AmtNKOCmqzlsJ+g09AAGTZ7bDOi0ODQCq4yGjYzG3UMysKtegJuO0x7i4Qug
	 CdDy4CAwUCO9g==
Message-ID: <1f218de3db5bb7a89e56bb100fd4a4b87e5dc536.camel@kernel.org>
Subject: Re: [PATCH v13 00/12] famfs: the Fabric-Attached Memory File System
 (standalone)
From: Jeff Layton <jlayton@kernel.org>
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>, Miklos
 Szeredi <miklos@szeredi.hu>, Dan Williams <djbw@kernel.org>, Bernd Schubert
 <bschubert@ddn.com>,  Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Jake
 Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma	
 <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Matthew
 Wilcox	 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Alexander Viro	
 <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, Christian
 Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, Randy
 Dunlap	 <rdunlap@infradead.org>, Amir Goldstein <amir73il@gmail.com>,
 Jonathan Cameron	 <jic23@kernel.org>, Stefan Hajnoczi
 <shajnocz@redhat.com>, Joanne Koong	 <joannelkoong@gmail.com>, Josef Bacik
 <josef@toxicpanda.com>, Bagas Sanjaya	 <bagasdotme@gmail.com>, Chen Linxuan
 <chenlinxuan@uniontech.com>, James Morse	 <james.morse@arm.com>, Fuad Tabba
 <tabba@google.com>, Sean Christopherson	 <seanjc@google.com>, Shivank Garg
 <shivankg@amd.com>, Ackerley Tng	 <ackerleytng@google.com>, Gregory Price
 <gourry@gourry.net>, Andrew Morton	 <akpm@linux-foundation.org>, Namjae
 Jeon <linkinjeon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Ira Weiny	 <iweiny@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Haren Myneni	
 <haren@linux.ibm.com>, Pratyush Yadav <pratyush@kernel.org>, Giovanni
 Cabiddu	 <giovanni.cabiddu@intel.com>, Jiri Slaby <jirislaby@kernel.org>,
 Ethan Nelson-Moore <enelsonmoore@gmail.com>, Gabriel Whigham
 <gabewhigham@gmail.com>, Aravind Ramesh	 <arramesh@micron.com>, Ajay Joshi
 <ajayjoshi@micron.com>,  "venkataravis@micron.com"	
 <venkataravis@micron.com>, "linux-doc@vger.kernel.org"	
 <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"	
 <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev"	
 <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"	
 <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"	
 <linux-fsdevel@vger.kernel.org>, "fuse-devel@lists.linux.dev"	
 <fuse-devel@lists.linux.dev>
Date: Thu, 20 Aug 2026 08:37:13 -0400
In-Reply-To: <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
References: <20260810202325.96202-1-john@jagalactic.com>
	 <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2026-08-10 at 20:23 +0000, John Groves wrote:
> From: John Groves <john@groves.net>
>=20
> This is v13 of famfs, as a standalone file system. v12 is at [7].
>=20
> Most of this cover letter repeats v12. If you have read it, skip to "Chan=
ges
> since v12" below and to the per-patch changelogs under the "---" line of =
each
> patch. The history goes back to 2023, and is briefly covered in the v12
> cover.
>=20
> The most important thing to know about famfs is that it CANNOT be used as=
 a
> general purpose file system. It is for enabling file-based byte-level acc=
ess
> (including direct mmap) to very large (e.g. 100TB) shared/disaggregated
> memory appliances - which have become available during this long process,
> and which are in need of Linux support.
>=20
> So famfs cannot be used by anybody who doesn't know why they need it. Mak=
ing
> famfs standalone means it can't affect users who don't use it. Micron, as
> well as other memory companies, need it, and do not intend to abandon it =
-
> but imagine if we did: fs/famfs/ should be removed if the memory companie=
s
> can't be bothered to maintain it.
>=20
> This code base has been in active CI and used globally by early adopters =
and
> testers of disaggregated memory since 2024. I believe it is solid.
>=20
> Why standalone (short version)
>=20
> famfs was introduced at LPC 2023 and LSFMM 2024 [1] as a standalone file
> system, then spent close to a year being ported to fuse/libfuse. After
> maintaining famfs in both forms, I have concluded it makes more sense as =
a
> standalone file system: fuse adds complexity to famfs (more complex, less
> adaptable, less performant - and famfs files are memory, so access must r=
un
> at memory speed), while famfs adds complexity to fuse that is unlikely to=
 see
> constructive re-use. The full history and argument are in the v12 cover
> letter [7].
>=20
> Changes since v12
> -----------------
>=20
> - Patch 01 split, per Alison Schofield: the removal of the now-unused
>   dax_dev_get() export is a standalone DAX cleanup that goes via the DAX =
tree
>   and is posted separately [8]. Patch 01 of this series is reduced to add=
ing
>   the non-allocating lookup helper dax_dev_find().
>=20
> - Darrick Wong's review comments are addressed across the series: the
>   kill_*_super() rationale in the mount patch, the page_mkwrite/pfn_mkwri=
te
>   write-fault comment, dropping the operation flags from iomap->flags in =
the
>   resolver, and more.
>=20
> - A number of findings from the Sashiko review bot are fixed:
>     * mprotect() could bypass the FAMFS_OPT_WRITE gate (the check looked =
at
>       VM_WRITE only, not VM_MAYWRITE);
>     * rename() over an existing target bypassed the FAMFS_OPT_UNLINK /
>       FAMFS_OPT_RMDIR policy that unlink()/rmdir() enforce;
>     * splice()/sendfile() returned zeroes on these DAX files
>       (filemap_splice_read -> copy_splice_read);
>     * create/mkdir/mknod updated the child inode's timestamps instead of =
the
>       parent directory's;
>     * .map_pages (filemap_map_pages) was a no-op on DAX and is removed;
>     * mount-parameter and module-namespace hygiene (reject unknown mount
>       options; prefix the non-static lookup_daxdev()).
>   A few Sashiko findings were considered and declined with rationale - fo=
r
>   example generic_write_sync(), which is inert for a filesystem with no p=
age
>   cache, no writeback, and a noop_fsync ->fsync. Those are noted under th=
e
>   relevant patch.
>=20
> - famfs now accepts 4 KiB extent alignment in addition to 2 MiB: the
>   allocation unit may be 4 KiB or 2 MiB. 2 MiB-aligned extents still map =
with
>   huge pages; 4 KiB-granular extents map with PTEs (the DAX fault path al=
ready
>   falls back PMD -> PTE).
>=20
> - MAP_SYNC is now supported (FOP_MMAP_SYNC). famfs fmap metadata is immut=
able
>   after MAP_CREATE, so the MAP_SYNC durability guarantee is met with no
>   metadata sync required.
>=20
> - famfs is explicitly 64-bit only now (depends on 64BIT); it targets
>   CXL/fabric-attached memory, which does not exist on 32-bit systems.
>=20
> Famfs Overview
>=20
> Famfs exposes sharable disaggregated memory as a file system. Famfs consu=
mes
> shared memory from [usually shared memory] dax devices, and provides
> memory-mappable files that map directly to the memory - no page cache
> involvement. Famfs differs from conventional file systems in fs-dax mode,
> in that it handles in-memory metadata in a sharable way (which begins wit=
h
> never caching dirty shared metadata). So a famfs file system can be mount=
ed
> from multiple nodes, provided they have access to the memory.
>=20
> The key performance requirement is that famfs must resolve mapping faults
> with minimal overhead. This is achieved by fully caching the file-to-devd=
ax
> metadata for all active files.
>=20
> Famfs remains the first fs-dax file system that is backed by devdax rathe=
r
> than pmem in fs-dax mode (hence the need for the new dax mode).
>=20
> Famfs depends on the 'fsdev' dax mode which landed in 7.1 - it will only =
run
> with an fsdev-mode (aka famfs-mode) daxdev as its backing device(s).
>=20
> The famfs user space can be found at [6].
>=20
> [1] https://lwn.net/Articles/983105/ (Famfs at LSFMM 2024)
> [2] https://lwn.net/Articles/1020170/ (Famfs at LSFMM 2025, with patch li=
nk)
> [3] https://lwn.net/Articles/1068686/ (LWN coverage of the patch thread)
> [4] https://lwn.net/Articles/1082687/ (Famfs at LSFMM 2026)
> [5] https://lore.kernel.org/linux-fsdevel/0100019f7d9fbe81-6cb16662-2522-=
47ea-a152-fab0ee3d9b35-000000@email.amazonses.com/#b
> [6] https://famfs.org
> [7] https://lore.kernel.org/linux-fsdevel/20260806053409.GL3560084@frogsf=
rogsfrogs/T/#t (v12)
> [8] https://lore.kernel.org/linux-cxl/0100019fd478eb93-a6bd48e4-b5f1-4871=
-93d4-582802956e6c-000000@email.amazonses.com/T/#u (Partial dax patch)
>=20
>=20
> John Groves (12):
>   dax: replace exported dax_dev_get() with non-allocating dax_dev_find()
>   famfs: Module operations, fs_context, and mount
>   famfs: Add daxdev table and dax notify_failure support
>   famfs: Introduce inode_operations and super_operations
>   famfs: Introduce file_operations read/write
>   famfs: Introduce mmap and VM fault handling
>   famfs: MAP_CREATE ioctl and fmap ingest (ABI 44)
>   famfs: iomap_begin and file-to-dax offset resolution
>   famfs: Register secondary daxdevs by path (FAMFSIOC_DAXDEV_OPEN)
>   famfs: Add runtime operation-permission (opts) framework
>   famfs: Report device capacity via statfs so df works
>   famfs: Add documentation
>=20
>  Documentation/filesystems/famfs.rst           |  142 +++
>  Documentation/filesystems/index.rst           |    1 +
>  .../userspace-api/ioctl/ioctl-number.rst      |    1 +
>  MAINTAINERS                                   |    8 +
>  drivers/dax/fsdev.c                           |   19 +
>  drivers/dax/super.c                           |   38 +-
>  fs/Kconfig                                    |    2 +
>  fs/Makefile                                   |    1 +
>  fs/famfs/Kconfig                              |   12 +
>  fs/famfs/Makefile                             |    5 +
>  fs/famfs/famfs_file.c                         | 1007 +++++++++++++++++
>  fs/famfs/famfs_inode.c                        |  869 ++++++++++++++
>  fs/famfs/famfs_internal.h                     |  162 +++
>  fs/namei.c                                    |    1 +
>  fs/super.c                                    |    7 +
>  include/linux/dax.h                           |    7 +-
>  include/linux/fs.h                            |    1 +
>  include/uapi/linux/famfs_ioctl.h              |  160 +++
>  include/uapi/linux/magic.h                    |    1 +
>  19 files changed, 2441 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/filesystems/famfs.rst
>  create mode 100644 fs/famfs/Kconfig
>  create mode 100644 fs/famfs/Makefile
>  create mode 100644 fs/famfs/famfs_file.c
>  create mode 100644 fs/famfs/famfs_inode.c
>  create mode 100644 fs/famfs/famfs_internal.h
>  create mode 100644 include/uapi/linux/famfs_ioctl.h
>=20
> --=20
> 2.53.0
>=20

I looked over the series and while I don't have the greatest grasp of
DAX/CXL, the fs bits all look fairly self-contained and reasonable to
me. The changes outside of fs/famfs are extremely minimal, so I'm not
worried much about this breaking anything unrelated.

At this point, I think just taking this as a standalone fs is the right
thing to do. This already has field deployments, so it's fairly well
tested. If it turns out that the FUSE approach becomes more palatable
later, we can just move to deprecate the standalone version then.

You and Richard discussed some (minimal) changes in patch #7. Assuming
you resolve those, you can add:

    Reviewed-by: Jeff Layton <jlayton@kernel.org>

(but figure that's mostly for the fs and not mm parts).

It's a little late for v7.3 given that the merge window is open now.
Should we aim to get this into v7.4? That would give this a full cycle
in linux-next too.
