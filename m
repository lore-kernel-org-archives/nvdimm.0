Received: from a11-75.smtp-out.amazonses.com (a11-75.smtp-out.amazonses.com [54.240.11.75])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803F634D3B5
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312801; cv=none; b=QvXjp7pI+vfvw+NR+bQR/XiA0r2rNWq9ni8z/Lbpfg6ETV2W0jtvaTI9JvQ6Up1p/64AHBmhXulrk9JJ1VfWsq0MzLlxAnVOjr/KUchMuqXQgpGygRui14u7vJTziJHbUn4U47G5eH8Xn47y4KF60JStZ3zswv7kcWkELIK/7S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312801; c=relaxed/simple;
	bh=ZCaITTi8Md8cEboxnQoKFVeSibU6MFs/nyTNdog7PNU=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=KzeAFH3hAvObpm1IYNaxJB7kp82w1Lf05qvnAaTE2fYit7PiRD3semivnUQMONezF++VY+D3ACgAhfvp/JLCa37MpPIXZHceoxwEjHcUZSgTi/7Xk9el7JgRR25hSJ4cSPLdKDu+q27WCFPjgYqDKIFI5cykllvr98mMvFLw3OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=PcTpk0Lg; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=brwWV/P0; arc=none smtp.client-ip=54.240.11.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="PcTpk0Lg";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="brwWV/P0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312798;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=ZCaITTi8Md8cEboxnQoKFVeSibU6MFs/nyTNdog7PNU=;
	b=PcTpk0Lgrlk29WmiqxcHji6TB+re3Vw740ORta3vnknq15NTm2C7U0yR30HNEDiZ
	GvksY/H1l3zaLI73V1/cEMevd06V/K+Aes8kkJahqXQqGWDrb3d6/PuBRjNY8A83sUq
	vYWptBomn7n6OG5bfHh0h64E3w/3LKxt622e01EI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312798;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=ZCaITTi8Md8cEboxnQoKFVeSibU6MFs/nyTNdog7PNU=;
	b=brwWV/P0/GY8mPL5wMNCE3WxokOoVmIAmb3+XOLdFSFDgoOuKyGyWl7LJbzA3yZk
	zpBAyZG6JPZGRPy9D6r4pZZ49NVvr4XxRmuLqmZohwVgOrKTebLl0ASW3MBlbCQdo3p
	n/2OdAUxLaUsNWRZ4qwfYRI0FKNav09t+dXt7GPs=
Subject: [PATCH V9 00/10] famfs: port into fuse
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
Date: Tue, 24 Mar 2026 00:39:58 +0000
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
 <20260324003946.5148-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuyZEswjXSG92Tn2kGdN5KULUYAAAHi39
Thread-Topic: [PATCH V9 00/10] famfs: port into fuse
X-Wm-Sent-Timestamp: 1774312797
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d48b7e8-4468329f-b446-43f1-87db-3c7e1ff6f28b-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.11.75

From: John Groves <john@groves.net>=0D=0A=0D=0AThis patch series on top o=
f the prerequisite patches to dax are=0D=0Aavailable as a git tag at [0].=
=0D=0A=0D=0ANOTE: this series depends on the famfs dax series=0D=0A(dax: =
prepare for famfs)!!=0D=0A=0D=0AChanges v8 -> v9=0D=0A- Kconfig: fs/fuse/=
Kconfig:CONFIG_FUSE_FAMFS_DAX now depends on the=0D=0A  new CONFIG_DEV_DA=
X_FSDEV (from drivers/dax/Kconfig) rather than=0D=0A  just CONFIG_DEV_DAX=
 and CONFIG_FS_DAX. (CONFIG_FUSE_FAMFS_DAX=0D=0A  depends on those...)=0D=
=0A=0D=0ADescription:=0D=0A=0D=0AThis patch series introduces famfs into =
the fuse file system framework.=0D=0AFamfs depends on the bundled dax pat=
ch set.=0D=0A=0D=0AThe famfs user space code can be found at [1].=0D=0A=0D=
=0AFuse Overview:=0D=0A=0D=0AFamfs started as a standalone file system, b=
ut this series is intended to=0D=0Apermanently supersede that implementat=
ion. At a high level, famfs adds=0D=0Atwo new fuse server messages:=0D=0A=
=0D=0AGET_FMAP   - Retrieves a famfs fmap (the file-to-dax map for a famf=
s=0D=0A=09     file)=0D=0AGET_DAXDEV - Retrieves the details of a particu=
lar daxdev that was=0D=0A=09     referenced by an fmap=0D=0A=0D=0AFamfs O=
verview=0D=0A=0D=0AFamfs exposes shared memory as a file system. Famfs co=
nsumes shared=0D=0Amemory from dax devices, and provides memory-mappable =
files that map=0D=0Adirectly to the memory - no page cache involvement. F=
amfs differs from=0D=0Aconventional file systems in fs-dax mode, in that =
it handles in-memory=0D=0Ametadata in a sharable way (which begins with n=
ever caching dirty shared=0D=0Ametadata).=0D=0A=0D=0AFamfs started as a s=
tandalone file system [2,3], but the consensus at=0D=0ALSFMM was that it =
should be ported into fuse [4,5].=0D=0A=0D=0AThe key performance requirem=
ent is that famfs must resolve mapping faults=0D=0Awithout upcalls. This =
is achieved by fully caching the file-to-devdax=0D=0Ametadata for all act=
ive files. This is done via two fuse client/server=0D=0Amessage/response =
pairs: GET_FMAP and GET_DAXDEV.=0D=0A=0D=0AFamfs remains the first fs-dax=
 file system that is backed by devdax=0D=0Arather than pmem in fs-dax mod=
e (hence the need for the new dax mode).=0D=0A=0D=0ANotes=0D=0A=0D=0A- Wh=
en a file is opened in a famfs mount, the OPEN is followed by a=0D=0A  GE=
T_FMAP message and response. The "fmap" is the full file-to-dax=0D=0A  ma=
pping, allowing the fuse/famfs kernel code to handle=0D=0A  read/write/fa=
ult without any upcalls.=0D=0A=0D=0A- After each GET_FMAP, the fmap is ch=
ecked for extents that reference=0D=0A  previously-unknown daxdevs. Each =
such occurrence is handled with a=0D=0A  GET_DAXDEV message and response.=
=0D=0A=0D=0A- Daxdevs are stored in a table (which might become an xarray=
 at some=0D=0A  point). When entries are added to the table, we acquire e=
xclusive=0D=0A  access to the daxdev via the fs_dax_get() call (modeled a=
fter how=0D=0A  fs-dax handles this with pmem devices). Famfs provides=0D=
=0A  holder_operations to devdax, providing a notification path in the=0D=
=0A  event of memory errors or forced reconfiguration.=0D=0A=0D=0A- If de=
vdax notifies famfs of memory errors on a dax device, famfs=0D=0A  curren=
tly blocks all subsequent accesses to data on that device. The=0D=0A  rec=
overy is to re-initialize the memory and file system. Famfs is=0D=0A  mem=
ory, not storage...=0D=0A=0D=0A- Because famfs uses backing (devdax) devi=
ces, only privileged mounts are=0D=0A  supported (i.e. the fuse server re=
quires CAP_SYS_RAWIO).=0D=0A=0D=0A- The famfs kernel code never accesses =
the memory directly - it only=0D=0A  facilitates read, write and mmap on =
behalf of user processes, using=0D=0A  fmap metadata provided by its priv=
ileged fuse server. As such, the=0D=0A  RAS of the shared memory affects =
applications, but not the kernel.=0D=0A=0D=0A- Famfs has backing device(s=
), but they are devdax (char) rather than=0D=0A  block. Right now there i=
s no way to tell the vfs layer that famfs has a=0D=0A  char backing devic=
e (unless we say it's block, but it's not). Currently=0D=0A  we use the s=
tandard anonymous fuse fs_type - but I'm not sure that's=0D=0A  ultimatel=
y optimal (thoughts=3F)=0D=0A=0D=0AChanges v7 -> v8=0D=0A- Moved to inlin=
e __free declaration in fuse_get_fmap() and=0D=0A  famfs_fuse_meta_alloc(=
), famfs_teardown()=0D=0A- Adopted FIELD_PREP() macro rather than manual =
bitfield manipulation=0D=0A- Minor doc edits=0D=0A- I dropped adding magi=
c numbers to include/uapi/linux/magic.h. That=0D=0A  can be done later if=
 appropriate=0D=0A=0D=0AChanges v6 -> v7=0D=0A- Fixed a regression in fam=
fs_interleave_fileofs_to_daxofs() that=0D=0A  was reported by Intel's ker=
nel test robot=0D=0A- Added a check in __fsdev_dax_direct_access() for ne=
gative return=0D=0A  from pgoff_to_phys(), which would indicate an out-of=
-range offset=0D=0A- Fixed a bug in __famfs_meta_free(), where not all in=
terleaved=0D=0A  extents were freed=0D=0A- Added chunksize alignment chec=
ks in famfs_fuse_meta_alloc() and=0D=0A  famfs_interleave_fileofs_to_daxo=
fs() as interleaved chunks must=0D=0A  be PTE or PMD aligned=0D=0A- Simpl=
ified famfs_file_init_dax() a bit=0D=0A- Re-ran CM's kernel code review p=
rompts on the entire series and=0D=0A  fixed several minor issues=0D=0A=0D=
=0AChanges v4 -> v5 -> v6=0D=0A- None. Re-sending due to technical diffic=
ulties=0D=0A=0D=0AChanges v3 [9] -> v4=0D=0A- The patch "dax: prevent dri=
ver unbind while filesystem holds device"=0D=0A  has been dropped. Dan Wi=
lliams indicated that the favored behavior is=0D=0A  for a file system to=
 stop working if an underlying driver is unbound,=0D=0A  rather than prev=
enting the unbind.=0D=0A- The patch "famfs_fuse: Famfs mount opt: -o shad=
ow=3D<shadowpath>" has=0D=0A  been dropped. Found a way for the famfs use=
r space to do without the=0D=0A  -o opt (via getxattr).=0D=0A- Squashed t=
he fs/fuse/Kconfig patch into the first subsequent patch=0D=0A  that need=
ed the change=0D=0A  ("famfs_fuse: Basic fuse kernel ABI enablement for f=
amfs")=0D=0A- Many review comments addressed.=0D=0A- Addressed minor kern=
eldoc infractions reported by test robot.=0D=0A=0D=0AChanges v2 [7] -> v3=
=0D=0A- Dax: Completely new fsdev driver (drivers/dax/fsdev.c) replaces t=
he=0D=0A  dev_dax_iomap modifications to bus.c/device.c. Devdax devices c=
an now=0D=0A  be switched among 'devdax', 'famfs' and 'system-ram' modes =
via daxctl=0D=0A  or sysfs.=0D=0A- Dax: fsdev uses MEMORY_DEVICE_FS_DAX t=
ype and leaves folios at order-0=0D=0A  (no vmemmap_shift), allowing fs-d=
ax to manage folio lifecycles=0D=0A  dynamically like pmem does.=0D=0A- D=
ax: The "poisoned page" problem is properly fixed via=0D=0A  fsdev_clear_=
folio_state(), which clears stale mapping/compound state=0D=0A  when fsde=
v binds. The temporary WARN_ON_ONCE workaround in fs/dax.c=0D=0A  has bee=
n removed.=0D=0A- Dax: Added dax_set_ops() so fsdev can set dax_operation=
s at bind time=0D=0A  (and clear them on unbind), since the dax_device is=
 created before we=0D=0A  know which driver will bind.=0D=0A- Dax: Added =
custom bind/unbind sysfs handlers; unbind return -EBUSY if a=0D=0A  files=
ystem holds the device, preventing unbind while famfs is mounted.=0D=0A- =
Fuse: Famfs mounts now require that the fuse server/daemon has=0D=0A  CAP=
_SYS_RAWIO because they expose raw memory devices.=0D=0A- Fuse: Added DAX=
 address_space_operations with noop_dirty_folio since=0D=0A  famfs is mem=
ory-backed with no writeback required.=0D=0A- Rebased to latest kernels, =
fully compatible with Alistair Popple=0D=0A  et. al's recent dax refactor=
ing.=0D=0A- Ran this series through Chris Mason's code review AI prompts =
to check=0D=0A  for issues - several subtle problems found and fixed.=0D=0A=
- Dropped RFC status - this version is intended to be mergeable.=0D=0A=0D=
=0AChanges v1 [8] -> v2:=0D=0A=0D=0A- The GET_FMAP message/response has b=
een moved from LOOKUP to OPEN, as=0D=0A  was the pretty much unanimous co=
nsensus.=0D=0A- Made the response payload to GET_FMAP variable sized (pat=
ch 12)=0D=0A- Dodgy kerneldoc comments cleaned up or removed.=0D=0A- Fixe=
d memory leak of fc->shadow in patch 11 (thanks Joanne)=0D=0A- Dropped ma=
ny pr_debug and pr_notice calls=0D=0A=0D=0A=0D=0AReferences=0D=0A=0D=0A[0=
] - https://github.com/jagalactic/linux/tree/famfs-v9 (this patch set)=0D=
=0A[1] - https://famfs.org (famfs user space)=0D=0A[2] - https://lore.ker=
nel.org/linux-cxl/cover.1708709155.git.john@groves.net/=0D=0A[3] - https:=
//lore.kernel.org/linux-cxl/cover.1714409084.git.john@groves.net/=0D=0A[4=
] - https://lwn.net/Articles/983105/ (lsfmm 2024)=0D=0A[5] - https://lwn.=
net/Articles/1020170/ (lsfmm 2025)=0D=0A[6] - https://lore.kernel.org/lin=
ux-cxl/cover.8068ad144a7eea4a813670301f4d2a86a8e68ec4.1740713401.git-seri=
es.apopple@nvidia.com/=0D=0A[7] - https://lore.kernel.org/linux-fsdevel/2=
0250703185032.46568-1-john@groves.net/ (famfs fuse v2)=0D=0A[8] - https:/=
/lore.kernel.org/linux-fsdevel/20250421013346.32530-1-john@groves.net/ (f=
amfs fuse v1)=0D=0A[9] - https://lore.kernel.org/linux-fsdevel/2026010715=
3244.64703-1-john@groves.net/T/#mb2c868801be16eca82dab239a1d201628534aea7=
 (famfs fuse v3)=0D=0A=0D=0A=0D=0AJohn Groves (10):=0D=0A  famfs_fuse: Up=
date macro s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/=0D=0A  famfs_fuse: Basic fus=
e kernel ABI enablement for famfs=0D=0A  famfs_fuse: Plumb the GET_FMAP m=
essage/response=0D=0A  famfs_fuse: Create files with famfs fmaps=0D=0A  f=
amfs_fuse: GET_DAXDEV message and daxdev_table=0D=0A  famfs_fuse: Plumb d=
ax iomap and fuse read/write/mmap=0D=0A  famfs_fuse: Add holder_operation=
s for dax notify_failure()=0D=0A  famfs_fuse: Add DAX address_space_opera=
tions with noop_dirty_folio=0D=0A  famfs_fuse: Add famfs fmap metadata do=
cumentation=0D=0A  famfs_fuse: Add documentation=0D=0A=0D=0A Documentatio=
n/filesystems/famfs.rst |  142 ++++=0D=0A Documentation/filesystems/index=
=2Erst |    1 +=0D=0A MAINTAINERS                         |   10 +=0D=0A =
fs/fuse/Kconfig                     |   13 +=0D=0A fs/fuse/Makefile      =
              |    1 +=0D=0A fs/fuse/dir.c                       |    2 +=
-=0D=0A fs/fuse/famfs.c                     | 1180 ++++++++++++++++++++++=
+++++=0D=0A fs/fuse/famfs_kfmap.h               |  167 ++++=0D=0A fs/fuse=
/file.c                      |   45 +-=0D=0A fs/fuse/fuse_i.h            =
        |  116 ++-=0D=0A fs/fuse/inode.c                     |   35 +-=0D=
=0A fs/fuse/iomode.c                    |    2 +-=0D=0A fs/namei.c       =
                   |    1 +=0D=0A include/uapi/linux/fuse.h           |  =
 88 ++=0D=0A 14 files changed, 1790 insertions(+), 13 deletions(-)=0D=0A =
create mode 100644 Documentation/filesystems/famfs.rst=0D=0A create mode =
100644 fs/fuse/famfs.c=0D=0A create mode 100644 fs/fuse/famfs_kfmap.h=0D=0A=
=0D=0A=0D=0Abase-commit: 1a6b38b1a257ac755e31f518dc82cad472396a1d=0D=0A--=
=20=0D=0A2.53.0=0D=0A=0D=0A
