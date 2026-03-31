Received: from a11-16.smtp-out.amazonses.com (a11-16.smtp-out.amazonses.com [54.240.11.16])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7303E2744
	for <nvdimm@lists.linux.dev>; Tue, 31 Mar 2026 12:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774960640; cv=none; b=l9KMouG49JxXJzoNa7MvvK3reYZvBW0vHlhi+VkkvK1+PTWRYIfi1AM+oaXEP1s4HOviBaJZq516iKd9S5NCbJwPJ6thofBoyY9oZ1iPlanoX6VeSoy2wkrSljRcf4hwpYGVLy2S2Fkmwkr+e3tqJ84mxbaaN+ghoF0utQrcBPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774960640; c=relaxed/simple;
	bh=1W5xTrg0nLVVOFFvot/Q9eBG4DbgLFq0BsgmZIP7Q2E=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=TqHlaXLbV+jkdyolNs5fN1GSWQ5wGLNsRVOki3BcIGPiDqovj1gCTFeIaZsYDCNlFNF9txRiAm/+Il+w5b+Z1W1CWd9997ZZqlslqVrfK140AQGeXmKfLoSO+ohCcQEsrCTy/rgXUBqGfvGHujtxlwBfWTG3mZN8ESUmvNXGpr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=fhcaMZb4; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=IvRPsSyV; arc=none smtp.client-ip=54.240.11.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="fhcaMZb4";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="IvRPsSyV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774960637;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=1W5xTrg0nLVVOFFvot/Q9eBG4DbgLFq0BsgmZIP7Q2E=;
	b=fhcaMZb4L5nlf+X3kK0iszLNZjTIi9niM0QeeVC/r1IC70vLkHGVmbJ5bGx6juq4
	wOdWwX/TuXQ9FLvi0jckfWDJr/V3A5x+As8TNuQI+Zb5bfKoeo81fweOPLzvVfmtmML
	RdGb2YAvJ0MRTszJ27vWx0K7Myq7Jj2LUhKJKUfw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774960637;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=1W5xTrg0nLVVOFFvot/Q9eBG4DbgLFq0BsgmZIP7Q2E=;
	b=IvRPsSyV5JIQm+2X3R/19dtO6+rEMdwvdGCq5vjC6/eGOcnEJKH9AJrDlS60byiV
	9vijJTrKUWLW8lqSb2+FZ6RjSX5PBKEYrvFcH9HyWTmZsxo3y1YtFftwGonKjzITRE6
	x7OoyZhZguZRk5WSgrPCfQDJZhwVGaBsuxUeyd7Q=
Subject: [PATCH V10 00/10] famfs: port into fuse
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
Date: Tue, 31 Mar 2026 12:37:17 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20260331123702.35052-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcwQsa9c5CQiOAQiO0uvZd0I9uvw==
Thread-Topic: [PATCH V10 00/10] famfs: port into fuse
X-Wm-Sent-Timestamp: 1774960636
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.31-54.240.11.16

From: John Groves <john@groves.net>=0D=0A=0D=0ANOTE: this series depends =
on the famfs dax series in Ira's for-7.1/dax-famfs=0D=0Abranch [0]=0D=0A=0D=
=0AChanges v9 -> v10=0D=0A- Rebased to Ira's for-7.1/dax-famfs branch [0]=
, which contains the required=0D=0A  dax patches=0D=0A- Add parentheses t=
o FUSE_IS_VIRTIO_DAX() macro, in case something bad is=0D=0A  passed in a=
s fuse_inode (thanks Jonathan's AI)=0D=0A=0D=0ADescription:=0D=0A=0D=0ATh=
is patch series introduces famfs into the fuse file system framework.=0D=0A=
Famfs depends on the bundled dax patch set.=0D=0A=0D=0AThe famfs user spa=
ce code can be found at [1].=0D=0A=0D=0AFuse Overview:=0D=0A=0D=0AFamfs s=
tarted as a standalone file system, but this series is intended to=0D=0Ap=
ermanently supersede that implementation. At a high level, famfs adds=0D=0A=
two new fuse server messages:=0D=0A=0D=0AGET_FMAP   - Retrieves a famfs f=
map (the file-to-dax map for a famfs=0D=0A=09     file)=0D=0AGET_DAXDEV -=
 Retrieves the details of a particular daxdev that was=0D=0A=09     refer=
enced by an fmap=0D=0A=0D=0AFamfs Overview=0D=0A=0D=0AFamfs exposes share=
d memory as a file system. Famfs consumes shared=0D=0Amemory from dax dev=
ices, and provides memory-mappable files that map=0D=0Adirectly to the me=
mory - no page cache involvement. Famfs differs from=0D=0Aconventional fi=
le systems in fs-dax mode, in that it handles in-memory=0D=0Ametadata in =
a sharable way (which begins with never caching dirty shared=0D=0Ametadat=
a).=0D=0A=0D=0AFamfs started as a standalone file system [2,3], but the c=
onsensus at=0D=0ALSFMM was that it should be ported into fuse [4,5].=0D=0A=
=0D=0AThe key performance requirement is that famfs must resolve mapping =
faults=0D=0Awithout upcalls. This is achieved by fully caching the file-t=
o-devdax=0D=0Ametadata for all active files. This is done via two fuse cl=
ient/server=0D=0Amessage/response pairs: GET_FMAP and GET_DAXDEV.=0D=0A=0D=
=0AFamfs remains the first fs-dax file system that is backed by devdax=0D=
=0Arather than pmem in fs-dax mode (hence the need for the new dax mode).=
=0D=0A=0D=0ANotes=0D=0A=0D=0A- When a file is opened in a famfs mount, th=
e OPEN is followed by a=0D=0A  GET_FMAP message and response. The "fmap" =
is the full file-to-dax=0D=0A  mapping, allowing the fuse/famfs kernel co=
de to handle=0D=0A  read/write/fault without any upcalls.=0D=0A=0D=0A- Af=
ter each GET_FMAP, the fmap is checked for extents that reference=0D=0A  =
previously-unknown daxdevs. Each such occurrence is handled with a=0D=0A =
 GET_DAXDEV message and response.=0D=0A=0D=0A- Daxdevs are stored in a ta=
ble (which might become an xarray at some=0D=0A  point). When entries are=
 added to the table, we acquire exclusive=0D=0A  access to the daxdev via=
 the fs_dax_get() call (modeled after how=0D=0A  fs-dax handles this with=
 pmem devices). Famfs provides=0D=0A  holder_operations to devdax, provid=
ing a notification path in the=0D=0A  event of memory errors or forced re=
configuration.=0D=0A=0D=0A- If devdax notifies famfs of memory errors on =
a dax device, famfs=0D=0A  currently blocks all subsequent accesses to da=
ta on that device. The=0D=0A  recovery is to re-initialize the memory and=
 file system. Famfs is=0D=0A  memory, not storage...=0D=0A=0D=0A- Because=
 famfs uses backing (devdax) devices, only privileged mounts are=0D=0A  s=
upported (i.e. the fuse server requires CAP_SYS_RAWIO).=0D=0A=0D=0A- The =
famfs kernel code never accesses the memory directly - it only=0D=0A  fac=
ilitates read, write and mmap on behalf of user processes, using=0D=0A  f=
map metadata provided by its privileged fuse server. As such, the=0D=0A  =
RAS of the shared memory affects applications, but not the kernel.=0D=0A=0D=
=0A- Famfs has backing device(s), but they are devdax (char) rather than=0D=
=0A  block. Right now there is no way to tell the vfs layer that famfs ha=
s a=0D=0A  char backing device (unless we say it's block, but it's not). =
Currently=0D=0A  we use the standard anonymous fuse fs_type - but I'm not=
 sure that's=0D=0A  ultimately optimal (thoughts=3F)=0D=0A=0D=0AChanges v=
8 -> v9=0D=0A- Kconfig: fs/fuse/Kconfig:CONFIG_FUSE_FAMFS_DAX now depends=
 on the=0D=0A  new CONFIG_DEV_DAX_FSDEV (from drivers/dax/Kconfig) rather=
 than=0D=0A  just CONFIG_DEV_DAX and CONFIG_FS_DAX. (CONFIG_FUSE_FAMFS_DA=
X=0D=0A  depends on those...)=0D=0A=0D=0AChanges v7 -> v8=0D=0A- Moved to=
 inline __free declaration in fuse_get_fmap() and=0D=0A  famfs_fuse_meta_=
alloc(), famfs_teardown()=0D=0A- Adopted FIELD_PREP() macro rather than m=
anual bitfield manipulation=0D=0A- Minor doc edits=0D=0A- I dropped addin=
g magic numbers to include/uapi/linux/magic.h. That=0D=0A  can be done la=
ter if appropriate=0D=0A=0D=0AChanges v6 -> v7=0D=0A- Fixed a regression =
in famfs_interleave_fileofs_to_daxofs() that=0D=0A  was reported by Intel=
's kernel test robot=0D=0A- Added a check in __fsdev_dax_direct_access() =
for negative return=0D=0A  from pgoff_to_phys(), which would indicate an =
out-of-range offset=0D=0A- Fixed a bug in __famfs_meta_free(), where not =
all interleaved=0D=0A  extents were freed=0D=0A- Added chunksize alignmen=
t checks in famfs_fuse_meta_alloc() and=0D=0A  famfs_interleave_fileofs_t=
o_daxofs() as interleaved chunks must=0D=0A  be PTE or PMD aligned=0D=0A-=
 Simplified famfs_file_init_dax() a bit=0D=0A- Re-ran CM's kernel code re=
view prompts on the entire series and=0D=0A  fixed several minor issues=0D=
=0A=0D=0AChanges v4 -> v5 -> v6=0D=0A- None. Re-sending due to technical =
difficulties=0D=0A=0D=0AChanges v3 [9] -> v4=0D=0A- The patch "dax: preve=
nt driver unbind while filesystem holds device"=0D=0A  has been dropped. =
Dan Williams indicated that the favored behavior is=0D=0A  for a file sys=
tem to stop working if an underlying driver is unbound,=0D=0A  rather tha=
n preventing the unbind.=0D=0A- The patch "famfs_fuse: Famfs mount opt: -=
o shadow=3D<shadowpath>" has=0D=0A  been dropped. Found a way for the fam=
fs user space to do without the=0D=0A  -o opt (via getxattr).=0D=0A- Squa=
shed the fs/fuse/Kconfig patch into the first subsequent patch=0D=0A  tha=
t needed the change=0D=0A  ("famfs_fuse: Basic fuse kernel ABI enablement=
 for famfs")=0D=0A- Many review comments addressed.=0D=0A- Addressed mino=
r kerneldoc infractions reported by test robot.=0D=0A=0D=0AChanges v2 [7]=
 -> v3=0D=0A- Dax: Completely new fsdev driver (drivers/dax/fsdev.c) repl=
aces the=0D=0A  dev_dax_iomap modifications to bus.c/device.c. Devdax dev=
ices can now=0D=0A  be switched among 'devdax', 'famfs' and 'system-ram' =
modes via daxctl=0D=0A  or sysfs.=0D=0A- Dax: fsdev uses MEMORY_DEVICE_FS=
_DAX type and leaves folios at order-0=0D=0A  (no vmemmap_shift), allowin=
g fs-dax to manage folio lifecycles=0D=0A  dynamically like pmem does.=0D=
=0A- Dax: The "poisoned page" problem is properly fixed via=0D=0A  fsdev_=
clear_folio_state(), which clears stale mapping/compound state=0D=0A  whe=
n fsdev binds. The temporary WARN_ON_ONCE workaround in fs/dax.c=0D=0A  h=
as been removed.=0D=0A- Dax: Added dax_set_ops() so fsdev can set dax_ope=
rations at bind time=0D=0A  (and clear them on unbind), since the dax_dev=
ice is created before we=0D=0A  know which driver will bind.=0D=0A- Dax: =
Added custom bind/unbind sysfs handlers; unbind return -EBUSY if a=0D=0A =
 filesystem holds the device, preventing unbind while famfs is mounted.=0D=
=0A- Fuse: Famfs mounts now require that the fuse server/daemon has=0D=0A=
  CAP_SYS_RAWIO because they expose raw memory devices.=0D=0A- Fuse: Adde=
d DAX address_space_operations with noop_dirty_folio since=0D=0A  famfs i=
s memory-backed with no writeback required.=0D=0A- Rebased to latest kern=
els, fully compatible with Alistair Popple=0D=0A  et. al's recent dax ref=
actoring.=0D=0A- Ran this series through Chris Mason's code review AI pro=
mpts to check=0D=0A  for issues - several subtle problems found and fixed=
=2E=0D=0A- Dropped RFC status - this version is intended to be mergeable.=
=0D=0A=0D=0AChanges v1 [8] -> v2:=0D=0A=0D=0A- The GET_FMAP message/respo=
nse has been moved from LOOKUP to OPEN, as=0D=0A  was the pretty much una=
nimous consensus.=0D=0A- Made the response payload to GET_FMAP variable s=
ized (patch 12)=0D=0A- Dodgy kerneldoc comments cleaned up or removed.=0D=
=0A- Fixed memory leak of fc->shadow in patch 11 (thanks Joanne)=0D=0A- D=
ropped many pr_debug and pr_notice calls=0D=0A=0D=0A=0D=0AReferences=0D=0A=
=0D=0A[0] - https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm=
=2Egit/=0D=0A[1] - https://famfs.org (famfs user space)=0D=0A[2] - https:=
//lore.kernel.org/linux-cxl/cover.1708709155.git.john@groves.net/=0D=0A[3=
] - https://lore.kernel.org/linux-cxl/cover.1714409084.git.john@groves.ne=
t/=0D=0A[4] - https://lwn.net/Articles/983105/ (lsfmm 2024)=0D=0A[5] - ht=
tps://lwn.net/Articles/1020170/ (lsfmm 2025)=0D=0A[6] - https://lore.kern=
el.org/linux-cxl/cover.8068ad144a7eea4a813670301f4d2a86a8e68ec4.174071340=
1.git-series.apopple@nvidia.com/=0D=0A[7] - https://lore.kernel.org/linux=
-fsdevel/20250703185032.46568-1-john@groves.net/ (famfs fuse v2)=0D=0A[8]=
 - https://lore.kernel.org/linux-fsdevel/20250421013346.32530-1-john@grov=
es.net/ (famfs fuse v1)=0D=0A[9] - https://lore.kernel.org/linux-fsdevel/=
20260107153244.64703-1-john@groves.net/T/#mb2c868801be16eca82dab239a1d201=
628534aea7 (famfs fuse v3)=0D=0A=0D=0A=0D=0AJohn Groves (10):=0D=0A  famf=
s_fuse: Update macro s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/=0D=0A  famfs_fuse:=
 Basic fuse kernel ABI enablement for famfs=0D=0A  famfs_fuse: Plumb the =
GET_FMAP message/response=0D=0A  famfs_fuse: Create files with famfs fmap=
s=0D=0A  famfs_fuse: GET_DAXDEV message and daxdev_table=0D=0A  famfs_fus=
e: Plumb dax iomap and fuse read/write/mmap=0D=0A  famfs_fuse: Add holder=
_operations for dax notify_failure()=0D=0A  famfs_fuse: Add DAX address_s=
pace_operations with noop_dirty_folio=0D=0A  famfs_fuse: Add famfs fmap m=
etadata documentation=0D=0A  famfs_fuse: Add documentation=0D=0A=0D=0A Do=
cumentation/filesystems/famfs.rst |  142 ++++=0D=0A Documentation/filesys=
tems/index.rst |    1 +=0D=0A MAINTAINERS                         |   10 =
+=0D=0A fs/fuse/Kconfig                     |   13 +=0D=0A fs/fuse/Makefi=
le                    |    1 +=0D=0A fs/fuse/dir.c                       =
|    2 +-=0D=0A fs/fuse/famfs.c                     | 1180 ++++++++++++++=
+++++++++++++=0D=0A fs/fuse/famfs_kfmap.h               |  167 ++++=0D=0A=
 fs/fuse/file.c                      |   45 +-=0D=0A fs/fuse/fuse_i.h    =
                |  116 ++-=0D=0A fs/fuse/inode.c                     |   =
35 +-=0D=0A fs/fuse/iomode.c                    |    2 +-=0D=0A fs/namei.=
c                          |    1 +=0D=0A include/uapi/linux/fuse.h      =
     |   88 ++=0D=0A 14 files changed, 1790 insertions(+), 13 deletions(-=
)=0D=0A create mode 100644 Documentation/filesystems/famfs.rst=0D=0A crea=
te mode 100644 fs/fuse/famfs.c=0D=0A create mode 100644 fs/fuse/famfs_kfm=
ap.h=0D=0A=0D=0A=0D=0Abase-commit: 2ae624d5a555d47a735fb3f4d850402859a4db=
77=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
