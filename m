Received: from a11-174.smtp-out.amazonses.com (a11-174.smtp-out.amazonses.com [54.240.11.174])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5126A37F300;
	Mon, 10 Aug 2026 20:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393419; cv=none; b=R403LhmiJlydcOX/I306PNdhoyC4j8JeBk713PB9lzuKAMR7A9b0e4zxskAy/ToTmYZAqqg5Fbpt7xtHGZmhu6zQ0dJ6uNsyHZlGUGxED94pNSIVIe41s1+5y9p1cxNpxu7ReBnzE11LgE6uvXxp2DI5trIGaF9MQkDQO/Sbwn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393419; c=relaxed/simple;
	bh=d0CSqObjb+GjkcI5dizLFpN48hdd5rA81MwgT6rZ0vc=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=nZ7pGi7OdDyHxGo4ypuQKPyMBDPlUQykphCAYW8rdHFOAfFgBD5CAXiekoaPUPg3lfmFW4FjzOTBEtZCGV6zV5VpN1CKAVV9vNWONcgD/hCiKROT9veLAKDD2CDk1R9PQ9AL2H2i8d6BSY+sDhi4U2LdQZny3XBondb1K074vKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=eirgdkVh; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=h9CA2PyW; arc=none smtp.client-ip=54.240.11.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="eirgdkVh";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="h9CA2PyW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1786393416;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=d0CSqObjb+GjkcI5dizLFpN48hdd5rA81MwgT6rZ0vc=;
	b=eirgdkVhzV02zmGcDo4sIrJLcwIIqDYqT9NJMGRYTo243Y7zOpAktRPfag090CwU
	75jiKR51c5deXEtQWLrXa7zMAIOJCapdNNdua4dJr/tylY76fVgsOWTZdo/XWd3lmfV
	ijh3wcRdncrT3ZtivnV7hS4HSfw8HWDeP+T+t/5g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1786393416;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=d0CSqObjb+GjkcI5dizLFpN48hdd5rA81MwgT6rZ0vc=;
	b=h9CA2PyWFhNhMx/r9sCMopNezJjOBEmv7vkCZqB7tDnjyCypoSep6bXSmCbhLzHV
	hMHPxT3ip226B8WM1kmBSvIkdcrHOmm6w8jJHasQtD7TaUPkUy8cipbWxb45mhwKj0N
	blIaPPFVlPX10vh8iPeo6IwJdDJjU9kHqcULrlFM=
Subject: [PATCH v13 00/12] famfs: the Fabric-Attached Memory File System
 (standalone)
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>, 
	=?UTF-8?Q?Bernd_Schubert?= <bschubert@ddn.com>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Jonathan_Corbe?= =?UTF-8?Q?t?= <corbet@lwn.net>, 
	=?UTF-8?Q?Jake_Edge?= <jake@lwn.net>, 
	=?UTF-8?Q?Shuah_Khan?= <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?David_Hildenbrand?= <david@kernel.org>, 
	=?UTF-8?Q?Christian_Bra?= =?UTF-8?Q?uner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Darrick_J_=2E_Wong?= <djwong@kernel.org>, 
	=?UTF-8?Q?Randy_Dunlap?= <rdunlap@infradead.org>, 
	=?UTF-8?Q?Jeff_Layton?= <jlayton@kernel.org>, 
	=?UTF-8?Q?Amir_Goldstein?= <amir73il@gmail.com>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
	=?UTF-8?Q?Stefan_Hajnoczi?= <shajnocz@redhat.com>, 
	=?UTF-8?Q?Joanne_Koong?= <joannelkoong@gmail.com>, 
	=?UTF-8?Q?Josef_Bacik?= <josef@toxicpanda.com>, 
	=?UTF-8?Q?Bagas_Sanjaya?= <bagasdotme@gmail.com>, 
	=?UTF-8?Q?Chen_Linxuan?= <chenlinxuan@uniontech.com>, 
	=?UTF-8?Q?James_Morse?= <james.morse@arm.com>, 
	=?UTF-8?Q?Fuad_Tabba?= <tabba@google.com>, 
	=?UTF-8?Q?Sean_Christopherson?= <seanjc@google.com>, 
	=?UTF-8?Q?Shivank_Garg?= <shivankg@amd.com>, 
	=?UTF-8?Q?Ackerley_Tng?= <ackerleytng@google.com>, 
	=?UTF-8?Q?Gregory_Pric?= =?UTF-8?Q?e?= <gourry@gourry.net>, 
	=?UTF-8?Q?Andrew_Morton?= <akpm@linux-foundation.org>, 
	=?UTF-8?Q?Namjae_Jeon?= <linkinjeon@kernel.org>, 
	=?UTF-8?Q?Lorenzo_Stoakes?= <ljs@kernel.org>, 
	=?UTF-8?Q?Greg_Kroah-Hartman?= <gregkh@linuxfoundation.org>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Pasha_Tatashin?= <pasha.tatashin@soleen.com>, 
	=?UTF-8?Q?Haren_Myneni?= <haren@linux.ibm.com>, 
	=?UTF-8?Q?Pratyush_Yadav?= <pratyush@kernel.org>, 
	=?UTF-8?Q?Giovanni_Cabiddu?= <giovanni.cabiddu@intel.com>, 
	=?UTF-8?Q?Jiri_Slaby?= <jirislaby@kernel.org>, 
	=?UTF-8?Q?Ethan_Nelson-Moo?= =?UTF-8?Q?re?= <enelsonmoore@gmail.com>, 
	=?UTF-8?Q?Gabriel_Whigham?= <gabewhigham@gmail.com>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40m?= =?UTF-8?Q?icron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40?= =?UTF-8?Q?vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?fuse-devel=40lists=2Elinux=2E?= =?UTF-8?Q?dev?= <fuse-devel@lists.linux.dev>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Mon, 10 Aug 2026 20:23:35 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20260810202325.96202-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdKQYd8BhJGjNjSyqPwMCz2Vr35A==
Thread-Topic: [PATCH v13 00/12] famfs: the Fabric-Attached Memory File System
 (standalone)
X-Wm-Sent-Timestamp: 1786393414
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.10-54.240.11.174

From: John Groves <john@groves.net>=0D=0A=0D=0AThis is v13 of famfs, as a=
 standalone file system. v12 is at [7].=0D=0A=0D=0AMost of this cover let=
ter repeats v12. If you have read it, skip to "Changes=0D=0Asince v12" be=
low and to the per-patch changelogs under the "---" line of each=0D=0Apat=
ch. The history goes back to 2023, and is briefly covered in the v12=0D=0A=
cover.=0D=0A=0D=0AThe most important thing to know about famfs is that it=
 CANNOT be used as a=0D=0Ageneral purpose file system. It is for enabling=
 file-based byte-level access=0D=0A(including direct mmap) to very large =
(e.g. 100TB) shared/disaggregated=0D=0Amemory appliances - which have bec=
ome available during this long process,=0D=0Aand which are in need of Lin=
ux support.=0D=0A=0D=0ASo famfs cannot be used by anybody who doesn't kno=
w why they need it. Making=0D=0Afamfs standalone means it can't affect us=
ers who don't use it. Micron, as=0D=0Awell as other memory companies, nee=
d it, and do not intend to abandon it -=0D=0Abut imagine if we did: fs/fa=
mfs/ should be removed if the memory companies=0D=0Acan't be bothered to =
maintain it.=0D=0A=0D=0AThis code base has been in active CI and used glo=
bally by early adopters and=0D=0Atesters of disaggregated memory since 20=
24. I believe it is solid.=0D=0A=0D=0AWhy standalone (short version)=0D=0A=
=0D=0Afamfs was introduced at LPC 2023 and LSFMM 2024 [1] as a standalone=
 file=0D=0Asystem, then spent close to a year being ported to fuse/libfus=
e. After=0D=0Amaintaining famfs in both forms, I have concluded it makes =
more sense as a=0D=0Astandalone file system: fuse adds complexity to famf=
s (more complex, less=0D=0Aadaptable, less performant - and famfs files a=
re memory, so access must run=0D=0Aat memory speed), while famfs adds com=
plexity to fuse that is unlikely to see=0D=0Aconstructive re-use. The ful=
l history and argument are in the v12 cover=0D=0Aletter [7].=0D=0A=0D=0AC=
hanges since v12=0D=0A-----------------=0D=0A=0D=0A- Patch 01 split, per =
Alison Schofield: the removal of the now-unused=0D=0A  dax_dev_get() expo=
rt is a standalone DAX cleanup that goes via the DAX tree=0D=0A  and is p=
osted separately [8]. Patch 01 of this series is reduced to adding=0D=0A =
 the non-allocating lookup helper dax_dev_find().=0D=0A=0D=0A- Darrick Wo=
ng's review comments are addressed across the series: the=0D=0A  kill_*_s=
uper() rationale in the mount patch, the page_mkwrite/pfn_mkwrite=0D=0A  =
write-fault comment, dropping the operation flags from iomap->flags in th=
e=0D=0A  resolver, and more.=0D=0A=0D=0A- A number of findings from the S=
ashiko review bot are fixed:=0D=0A    * mprotect() could bypass the FAMFS=
_OPT_WRITE gate (the check looked at=0D=0A      VM_WRITE only, not VM_MAY=
WRITE);=0D=0A    * rename() over an existing target bypassed the FAMFS_OP=
T_UNLINK /=0D=0A      FAMFS_OPT_RMDIR policy that unlink()/rmdir() enforc=
e;=0D=0A    * splice()/sendfile() returned zeroes on these DAX files=0D=0A=
      (filemap_splice_read -> copy_splice_read);=0D=0A    * create/mkdir/=
mknod updated the child inode's timestamps instead of the=0D=0A      pare=
nt directory's;=0D=0A    * .map_pages (filemap_map_pages) was a no-op on =
DAX and is removed;=0D=0A    * mount-parameter and module-namespace hygie=
ne (reject unknown mount=0D=0A      options; prefix the non-static lookup=
_daxdev()).=0D=0A  A few Sashiko findings were considered and declined wi=
th rationale - for=0D=0A  example generic_write_sync(), which is inert fo=
r a filesystem with no page=0D=0A  cache, no writeback, and a noop_fsync =
->fsync. Those are noted under the=0D=0A  relevant patch.=0D=0A=0D=0A- fa=
mfs now accepts 4 KiB extent alignment in addition to 2 MiB: the=0D=0A  a=
llocation unit may be 4 KiB or 2 MiB. 2 MiB-aligned extents still map wit=
h=0D=0A  huge pages; 4 KiB-granular extents map with PTEs (the DAX fault =
path already=0D=0A  falls back PMD -> PTE).=0D=0A=0D=0A- MAP_SYNC is now =
supported (FOP_MMAP_SYNC). famfs fmap metadata is immutable=0D=0A  after =
MAP_CREATE, so the MAP_SYNC durability guarantee is met with no=0D=0A  me=
tadata sync required.=0D=0A=0D=0A- famfs is explicitly 64-bit only now (d=
epends on 64BIT); it targets=0D=0A  CXL/fabric-attached memory, which doe=
s not exist on 32-bit systems.=0D=0A=0D=0AFamfs Overview=0D=0A=0D=0AFamfs=
 exposes sharable disaggregated memory as a file system. Famfs consumes=0D=
=0Ashared memory from [usually shared memory] dax devices, and provides=0D=
=0Amemory-mappable files that map directly to the memory - no page cache=0D=
=0Ainvolvement. Famfs differs from conventional file systems in fs-dax mo=
de,=0D=0Ain that it handles in-memory metadata in a sharable way (which b=
egins with=0D=0Anever caching dirty shared metadata). So a famfs file sys=
tem can be mounted=0D=0Afrom multiple nodes, provided they have access to=
 the memory.=0D=0A=0D=0AThe key performance requirement is that famfs mus=
t resolve mapping faults=0D=0Awith minimal overhead. This is achieved by =
fully caching the file-to-devdax=0D=0Ametadata for all active files.=0D=0A=
=0D=0AFamfs remains the first fs-dax file system that is backed by devdax=
 rather=0D=0Athan pmem in fs-dax mode (hence the need for the new dax mod=
e).=0D=0A=0D=0AFamfs depends on the 'fsdev' dax mode which landed in 7.1 =
- it will only run=0D=0Awith an fsdev-mode (aka famfs-mode) daxdev as its=
 backing device(s).=0D=0A=0D=0AThe famfs user space can be found at [6].=0D=
=0A=0D=0A[1] https://lwn.net/Articles/983105/ (Famfs at LSFMM 2024)=0D=0A=
[2] https://lwn.net/Articles/1020170/ (Famfs at LSFMM 2025, with patch li=
nk)=0D=0A[3] https://lwn.net/Articles/1068686/ (LWN coverage of the patch=
 thread)=0D=0A[4] https://lwn.net/Articles/1082687/ (Famfs at LSFMM 2026)=
=0D=0A[5] https://lore.kernel.org/linux-fsdevel/0100019f7d9fbe81-6cb16662=
-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com/#b=0D=0A[6] https=
://famfs.org=0D=0A[7] https://lore.kernel.org/linux-fsdevel/2026080605340=
9.GL3560084@frogsfrogsfrogs/T/#t (v12)=0D=0A[8] https://lore.kernel.org/l=
inux-cxl/0100019fd478eb93-a6bd48e4-b5f1-4871-93d4-582802956e6c-000000@ema=
il.amazonses.com/T/#u (Partial dax patch)=0D=0A=0D=0A=0D=0AJohn Groves (1=
2):=0D=0A  dax: replace exported dax_dev_get() with non-allocating dax_de=
v_find()=0D=0A  famfs: Module operations, fs_context, and mount=0D=0A  fa=
mfs: Add daxdev table and dax notify_failure support=0D=0A  famfs: Introd=
uce inode_operations and super_operations=0D=0A  famfs: Introduce file_op=
erations read/write=0D=0A  famfs: Introduce mmap and VM fault handling=0D=
=0A  famfs: MAP_CREATE ioctl and fmap ingest (ABI 44)=0D=0A  famfs: iomap=
_begin and file-to-dax offset resolution=0D=0A  famfs: Register secondary=
 daxdevs by path (FAMFSIOC_DAXDEV_OPEN)=0D=0A  famfs: Add runtime operati=
on-permission (opts) framework=0D=0A  famfs: Report device capacity via s=
tatfs so df works=0D=0A  famfs: Add documentation=0D=0A=0D=0A Documentati=
on/filesystems/famfs.rst           |  142 +++=0D=0A Documentation/filesys=
tems/index.rst           |    1 +=0D=0A .../userspace-api/ioctl/ioctl-num=
ber.rst      |    1 +=0D=0A MAINTAINERS                                  =
 |    8 +=0D=0A drivers/dax/fsdev.c                           |   19 +=0D=
=0A drivers/dax/super.c                           |   38 +-=0D=0A fs/Kcon=
fig                                    |    2 +=0D=0A fs/Makefile        =
                           |    1 +=0D=0A fs/famfs/Kconfig               =
               |   12 +=0D=0A fs/famfs/Makefile                          =
   |    5 +=0D=0A fs/famfs/famfs_file.c                         | 1007 ++=
+++++++++++++++=0D=0A fs/famfs/famfs_inode.c                        |  86=
9 ++++++++++++++=0D=0A fs/famfs/famfs_internal.h                     |  1=
62 +++=0D=0A fs/namei.c                                    |    1 +=0D=0A=
 fs/super.c                                    |    7 +=0D=0A include/lin=
ux/dax.h                           |    7 +-=0D=0A include/linux/fs.h    =
                        |    1 +=0D=0A include/uapi/linux/famfs_ioctl.h  =
            |  160 +++=0D=0A include/uapi/linux/magic.h                  =
  |    1 +=0D=0A 19 files changed, 2441 insertions(+), 3 deletions(-)=0D=0A=
 create mode 100644 Documentation/filesystems/famfs.rst=0D=0A create mode=
 100644 fs/famfs/Kconfig=0D=0A create mode 100644 fs/famfs/Makefile=0D=0A=
 create mode 100644 fs/famfs/famfs_file.c=0D=0A create mode 100644 fs/fam=
fs/famfs_inode.c=0D=0A create mode 100644 fs/famfs/famfs_internal.h=0D=0A=
 create mode 100644 include/uapi/linux/famfs_ioctl.h=0D=0A=0D=0A--=20=0D=0A=
2.53.0=0D=0A=0D=0A
