Received: from a48-183.smtp-out.amazonses.com (a48-183.smtp-out.amazonses.com [54.240.48.183])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F88238C0D
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312636; cv=none; b=XVBK/MXzv++HNirfQrc340BbW8RE47Nlgv/4D67ggA+HM8NMGqOWeGo1n6sslrrFdCHLC9g1y3dQrNcqRghuPS/SwWc5db2DfPCHeZXUb8dr0Wz7V8FacNPaK9exMeCMgfaGGL8bkVzXVkhHmC8W++YCb0a4618+p/1bem7EPh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312636; c=relaxed/simple;
	bh=6L23y0N6VbqBLxr65kB86rdP/h3RR8icTbt82ruphUw=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=YznID7HOJv+dvZv4Lc4ISoeY06GdNZYthk1Cox06xqVYpVJ+rxTE8IrLBLfVSmu5OPHh2BNThApE0FdLw/E5AYsNfWu3MPDgmORVelyCMHEZ0u1PUIYxbZMah9KVZj54bCl5GXNHMyMrLiEspmDsvOOm/csWYiB+QHVW/8fUKvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=trHEa66X; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=uHsz1KfM; arc=none smtp.client-ip=54.240.48.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="trHEa66X";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="uHsz1KfM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312633;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=6L23y0N6VbqBLxr65kB86rdP/h3RR8icTbt82ruphUw=;
	b=trHEa66XGFELnXUSvGNbymamJ3J57BZ++lfhf/XbvnK0DsuElTspgN3QgRzX84YZ
	PZ0/H5Z+Yz2SnImzs2gjVQjWEf9wv/S3NJUqQwA3J0FfoA2P6ywy+2i3jChQf2MXQyl
	R9jDU3XYTnAaJ3x9+h7NxMc4PerDgx0w+81IvFCY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312633;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=6L23y0N6VbqBLxr65kB86rdP/h3RR8icTbt82ruphUw=;
	b=uHsz1KfMEbwWMIWi7pisz57yB+NoD4v10gfw583/0+puLN1jU/JAtR6EfLHfEZX1
	bkEeDF1f7XYKDl5m2ZAOFLhR8Ah0hwBW7Bk/FvVQ2KI6ehKzvgIJ+7IjwRM8TtoW/w7
	GyQUQwWjd/KuSPtOyopVuexA2c11w43mhuEKIZJU=
Subject: [PATCH V9 0/8] dax: prepare for famfs
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <dan.j.williams@intel.com>, 
	=?UTF-8?Q?Bernd_Schubert?= <bschubert@ddn.com>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Jonathan_Corbe?= =?UTF-8?Q?t?= <corbet@lwn.net>, 
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
	=?UTF-8?Q?Jonathan_Cameron?= <Jonathan.Cameron@huawei.com>, 
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
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40micron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Tue, 24 Mar 2026 00:37:13 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d1d45a702-37d7aa37-4b46-4c21-86db-bf9bd3d914bb-000000@email.amazonses.com>
References: 
 <0100019d1d45a702-37d7aa37-4b46-4c21-86db-bf9bd3d914bb-000000@email.amazonses.com> 
 <20260324003702.4952-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuyZaWHh+UO9QTWGFyy3KkBL3iQ==
Thread-Topic: [PATCH V9 0/8] dax: prepare for famfs
X-Wm-Sent-Timestamp: 1774312632
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.48.183

From: John Groves <john@groves.net>=0D=0A=0D=0AThis patch series along wi=
th the bundled patches to fuse are available=0D=0Aas a git tag at [0].=0D=
=0A=0D=0AChanges v8 -> v9=0D=0A- Big clarifying comments in fs/dax.c:dax_=
folio_reset_order() in response=0D=0A  to Jonathan's comments/questions=0D=
=0A- Added drivers/dax/Kconfig:CONFIG_DEV_DAX_FSDEV to control inclusion =
of the=0D=0A  new famfs dax mode (which is in drivers/dax/fsdev.c - bind =
that to a daxdev=0D=0A  and you have famfs mode)=0D=0A- Some trivial refa=
ctoring, mostly per Jonathan's comments=0D=0A=0D=0ADescription:=0D=0A=0D=0A=
This patch series introduces the required dax support for famfs.=0D=0APre=
vious versions of the famfs series included both dax and fuse patches.=0D=
=0AThis series separates them into separate patch series' (and the fuse=0D=
=0Aseries dependends on this dax series).=0D=0A=0D=0AThe famfs user space=
 code can be found at [1]=0D=0A=0D=0ADax Overview:=0D=0A=0D=0AThis series=
 introduces a new "famfs mode" of devdax, whose driver is=0D=0Adrivers/da=
x/fsdev.c. This driver supports dax_iomap_rw() and=0D=0Adax_iomap_fault()=
 calls against a character dax instance. A dax device=0D=0Anow can be con=
verted among three modes: 'system-ram', 'devdax' and=0D=0A'famfs' via dax=
ctl or sysfs (e.g. unbind devdax and bind famfs instead).=0D=0A=0D=0AIn f=
amfs mode, a dax device initializes its pages consistent with the=0D=0Afs=
daxmode of pmem. Raw read/write/mmap are not supported in this mode,=0D=0A=
but famfs is happy in this mode - using dax_iomap_rw() for read/write and=
=0D=0Adax_iomap_fault() for mmap faults.=0D=0A=0D=0A=0D=0AChanges v7 -> v=
8=0D=0A- dax: Added a devm action to clear folio state when unbinding fsd=
ev.c=0D=0A  (thanks Allison)=0D=0A- Added a missing device_lock() in fs_d=
ax_get() (thanks Dave)=0D=0A- Re-factored some __free blocks for inline d=
eclaration=0D=0A- Used FIELD_PREP where appropriate=0D=0A- Minor doc edit=
s=0D=0A=0D=0AChanges v6 -> v7=0D=0A- Fixed a regression in famfs_interlea=
ve_fileofs_to_daxofs() that=0D=0A  was reported by Intel's kernel test ro=
bot=0D=0A- Added a check in __fsdev_dax_direct_access() for negative retu=
rn=0D=0A  from pgoff_to_phys(), which would indicate an out-of-range offs=
et=0D=0A- Fixed a bug in __famfs_meta_free(), where not all interleaved=0D=
=0A  extents were freed=0D=0A- Added chunksize alignment checks in famfs_=
fuse_meta_alloc() and=0D=0A  famfs_interleave_fileofs_to_daxofs() as inte=
rleaved chunks must=0D=0A  be PTE or PMD aligned=0D=0A- Simplified famfs_=
file_init_dax() a bit=0D=0A- Re-ran CM's kernel code review prompts on th=
e entire series and=0D=0A  fixed several minor issues=0D=0A=0D=0AChanges =
v4 -> v5 -> v6=0D=0A- None. Re-sending due to technical difficulties=0D=0A=
=0D=0AChanges v3 [9] -> v4=0D=0A- The patch "dax: prevent driver unbind w=
hile filesystem holds device"=0D=0A  has been dropped. Dan Williams indic=
ated that the favored behavior is=0D=0A  for a file system to stop workin=
g if an underlying driver is unbound,=0D=0A  rather than preventing the u=
nbind.=0D=0A- The patch "famfs_fuse: Famfs mount opt: -o shadow=3D<shadow=
path>" has=0D=0A  been dropped. Found a way for the famfs user space to d=
o without the=0D=0A  -o opt (via getxattr).=0D=0A- Squashed the fs/fuse/K=
config patch into the first subsequent patch=0D=0A  that needed the chang=
e=0D=0A  ("famfs_fuse: Basic fuse kernel ABI enablement for famfs")=0D=0A=
- Many review comments addressed.=0D=0A- Addressed minor kerneldoc infrac=
tions reported by test robot.=0D=0A=0D=0AChanges v2 [7] -> v3=0D=0A- Dax:=
 Completely new fsdev driver (drivers/dax/fsdev.c) replaces the=0D=0A  de=
v_dax_iomap modifications to bus.c/device.c. Devdax devices can now=0D=0A=
  be switched among 'devdax', 'famfs' and 'system-ram' modes via daxctl=0D=
=0A  or sysfs.=0D=0A- Dax: fsdev uses MEMORY_DEVICE_FS_DAX type and leave=
s folios at order-0=0D=0A  (no vmemmap_shift), allowing fs-dax to manage =
folio lifecycles=0D=0A  dynamically like pmem does.=0D=0A- Dax: The "pois=
oned page" problem is properly fixed via=0D=0A  fsdev_clear_folio_state()=
, which clears stale mapping/compound state=0D=0A  when fsdev binds. The =
temporary WARN_ON_ONCE workaround in fs/dax.c=0D=0A  has been removed.=0D=
=0A- Dax: Added dax_set_ops() so fsdev can set dax_operations at bind tim=
e=0D=0A  (and clear them on unbind), since the dax_device is created befo=
re we=0D=0A  know which driver will bind.=0D=0A- Dax: Added custom bind/u=
nbind sysfs handlers; unbind return -EBUSY if a=0D=0A  filesystem holds t=
he device, preventing unbind while famfs is mounted.=0D=0A- Fuse: Famfs m=
ounts now require that the fuse server/daemon has=0D=0A  CAP_SYS_RAWIO be=
cause they expose raw memory devices.=0D=0A- Fuse: Added DAX address_spac=
e_operations with noop_dirty_folio since=0D=0A  famfs is memory-backed wi=
th no writeback required.=0D=0A- Rebased to latest kernels, fully compati=
ble with Alistair Popple=0D=0A  et. al's recent dax refactoring.=0D=0A- R=
an this series through Chris Mason's code review AI prompts to check=0D=0A=
  for issues - several subtle problems found and fixed.=0D=0A- Dropped RF=
C status - this version is intended to be mergeable.=0D=0A=0D=0AChanges v=
1 [8] -> v2:=0D=0A=0D=0A- The GET_FMAP message/response has been moved fr=
om LOOKUP to OPEN, as=0D=0A  was the pretty much unanimous consensus.=0D=0A=
- Made the response payload to GET_FMAP variable sized (patch 12)=0D=0A- =
Dodgy kerneldoc comments cleaned up or removed.=0D=0A- Fixed memory leak =
of fc->shadow in patch 11 (thanks Joanne)=0D=0A- Dropped many pr_debug an=
d pr_notice calls=0D=0A=0D=0A=0D=0AReferences=0D=0A=0D=0A[0] - https://gi=
thub.com/jagalactic/linux/tree/famfs-v9 (this patch set)=0D=0A[1] - https=
://famfs.org (famfs user space)=0D=0A[2] - https://lore.kernel.org/linux-=
cxl/cover.1708709155.git.john@groves.net/=0D=0A[3] - https://lore.kernel.=
org/linux-cxl/cover.1714409084.git.john@groves.net/=0D=0A[4] - https://lw=
n.net/Articles/983105/ (lsfmm 2024)=0D=0A[5] - https://lwn.net/Articles/1=
020170/ (lsfmm 2025)=0D=0A[6] - https://lore.kernel.org/linux-cxl/cover.8=
068ad144a7eea4a813670301f4d2a86a8e68ec4.1740713401.git-series.apopple@nvi=
dia.com/=0D=0A[7] - https://lore.kernel.org/linux-fsdevel/20250703185032.=
46568-1-john@groves.net/ (famfs fuse v2)=0D=0A[8] - https://lore.kernel.o=
rg/linux-fsdevel/20250421013346.32530-1-john@groves.net/ (famfs fuse v1)=0D=
=0A[9] - https://lore.kernel.org/linux-fsdevel/20260107153244.64703-1-joh=
n@groves.net/T/#mb2c868801be16eca82dab239a1d201628534aea7 (famfs fuse v3)=
=0D=0A=0D=0A=0D=0AJohn Groves (8):=0D=0A  dax: move dax_pgoff_to_phys fro=
m [drivers/dax/] device.c to bus.c=0D=0A  dax: Factor out dax_folio_reset=
_order() helper=0D=0A  dax: add fsdev.c driver for fs-dax on character da=
x=0D=0A  dax: Save the kva from memremap=0D=0A  dax: Add dax_operations f=
or use by fs-dax on fsdev dax=0D=0A  dax: Add dax_set_ops() for setting d=
ax_operations at bind time=0D=0A  dax: Add fs_dax_get() func to prepare d=
ax for fs-dax usage=0D=0A  dax: export dax_dev_get()=0D=0A=0D=0A MAINTAIN=
ERS               |   8 +=0D=0A drivers/dax/Kconfig       |  11 ++=0D=0A =
drivers/dax/Makefile      |   2 +=0D=0A drivers/dax/bus.c         |  30 +=
++-=0D=0A drivers/dax/bus.h         |   3 +=0D=0A drivers/dax/dax-private=
=2Eh |   3 +=0D=0A drivers/dax/device.c      |  23 ---=0D=0A drivers/dax/=
fsdev.c       | 346 ++++++++++++++++++++++++++++++++++++++=0D=0A drivers/=
dax/super.c       | 107 +++++++++++-=0D=0A fs/dax.c                  |  7=
5 +++++++--=0D=0A include/linux/dax.h       |  20 ++-=0D=0A 11 files chan=
ged, 578 insertions(+), 50 deletions(-)=0D=0A create mode 100644 drivers/=
dax/fsdev.c=0D=0A=0D=0A=0D=0Abase-commit: c369299895a591d96745d6492d48882=
59b004a9e=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
