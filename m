Received: from a8-40.smtp-out.amazonses.com (a8-40.smtp-out.amazonses.com [54.240.8.40])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCF136B04B
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 21:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774645410; cv=none; b=GCQEmu4bnv5qGBumRK3rV9FJ/lDCOefrn0geaqiIFZokHJrghSowPAitTuEjZfmFrisQbPU02Q1BmoPhkGI+P4kUGq2s1MoksmUIBxWeXCfXbFEOWMG18I7Rm4AMX2rHnWopkL47cE2Y/bYvHypUwmiB+JacklGbV8kVxNOm9iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774645410; c=relaxed/simple;
	bh=A2BrIr6rXnTotQ9XqwAZO2cLL9b65i1MLJaOZrNR9/I=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=M+sbjgi5XQnBTothKbHKrCs8vz3Xfx/QyMf0URhRfU6u0j2/J8N73yM3/OVAKHj6pHVItBkAS78xvrAszdJWK1buGxEw9WZEtqFBdxR8nQzPARUp1XGJtQ4KLiNpV0zXrZcQy74Bro0iLT5lvQW15BPdXv+m8kiXvQRJV9JU8Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=HXODNL2G; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=D42K4U7s; arc=none smtp.client-ip=54.240.8.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="HXODNL2G";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="D42K4U7s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774645407;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=A2BrIr6rXnTotQ9XqwAZO2cLL9b65i1MLJaOZrNR9/I=;
	b=HXODNL2GTIEZb6+v0dkdXog3gVIojgh8dsNR9OncYo/TZ8BZBC9FcSbrEfs7Iwbf
	2q2t5xQZDivtvXtptIs1Nt2z0FgcxQD4iDGm7E4VffWmHUDkyVsz/XGXYDaISdbUrtO
	ZIjBGqfN8sRUkTEBjV9Ln6b6LIDfq7rBn7fs8nz8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774645407;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=A2BrIr6rXnTotQ9XqwAZO2cLL9b65i1MLJaOZrNR9/I=;
	b=D42K4U7sF8QJGDdqg/K8DV0r5vlDTwbVmQ7VuastmMF3QDDVWRxYGtGpEiz/upiI
	+gqCRu0YYipUIj1QVqR66VgmgTqroS9wETBe0KWuoK7YoXtBCPlE1PfvClKetONo9IB
	8bDgA2daVMx7EMnpZpUM8SGclIdJsRTazPHl/WmE=
Subject: [PATCH V10 0/8] dax: prepare for famfs
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
Date: Fri, 27 Mar 2026 21:03:26 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20260327210311.79099-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcvi0mx7x6wp1DRPy3+MfCNqaxsA==
Thread-Topic: [PATCH V10 0/8] dax: prepare for famfs
X-Wm-Sent-Timestamp: 1774645405
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.27-54.240.8.40

From: John Groves <john@groves.net>=0D=0A=0D=0AThis patch series along wi=
th the bundled patches to fuse are available=0D=0Aas a git tag at [0].=0D=
=0A=0D=0ADropped the "bundle" thread. If this submission goes smoothly, I=
'll update=0D=0Athe fuse patches to v10 (very little change there as yet)=
=2E=0D=0A=0D=0AChanges v9 -> v10=0D=0A- Minor modernizations per comments=
 from (mostly) Jonathan=0D=0A- Minor Kconfig simplification=0D=0A- bus.c:=
dax_match_type(): don't make fsdev_dax eligible for automatic binding=0D=0A=
  where devdax would otherwise bind=0D=0A- dax-private.h: add missing ker=
neldoc comment for field cached_size in=0D=0A  struct dev_dax_range (than=
ks Dave)=0D=0A- fsdev_write_dax(): s/pmem_addr/addr/ (thanks Dave)=0D=0A-=
 include/linux/dax.h: remove a spuriously-added declaration of inode_dax(=
)=0D=0A  (thanks Jonathan)=0D=0A=0D=0ADescription:=0D=0A=0D=0AThis patch =
series introduces the required dax support for famfs.=0D=0APrevious versi=
ons of the famfs series included both dax and fuse patches.=0D=0AThis ser=
ies separates them into separate patch series' (and the fuse=0D=0Aseries =
dependends on this dax series).=0D=0A=0D=0AThe famfs user space code can =
be found at [1]=0D=0A=0D=0ADax Overview:=0D=0A=0D=0AThis series introduce=
s a new "famfs mode" of devdax, whose driver is=0D=0Adrivers/dax/fsdev.c.=
 This driver supports dax_iomap_rw() and=0D=0Adax_iomap_fault() calls aga=
inst a character dax instance. A dax device=0D=0Anow can be converted amo=
ng three modes: 'system-ram', 'devdax' and=0D=0A'famfs' via daxctl or sys=
fs (e.g. unbind devdax and bind famfs instead).=0D=0A=0D=0AIn famfs mode,=
 a dax device initializes its pages consistent with the=0D=0Afsdaxmode of=
 pmem. Raw read/write/mmap are not supported in this mode,=0D=0Abut famfs=
 is happy in this mode - using dax_iomap_rw() for read/write and=0D=0Adax=
_iomap_fault() for mmap faults.=0D=0A=0D=0AChanges v8 -> v9=0D=0A- Big cl=
arifying comments in fs/dax.c:dax_folio_reset_order() in response=0D=0A  =
to Jonathan's comments/questions=0D=0A- Added drivers/dax/Kconfig:CONFIG_=
DEV_DAX_FSDEV to control inclusion of the=0D=0A  new famfs dax mode (whic=
h is in drivers/dax/fsdev.c - bind that to a daxdev=0D=0A  and you have f=
amfs mode)=0D=0A- Some trivial refactoring, mostly per Jonathan's comment=
s=0D=0A=0D=0AChanges v7 -> v8=0D=0A- dax: Added a devm action to clear fo=
lio state when unbinding fsdev.c=0D=0A  (thanks Allison)=0D=0A- Added a m=
issing device_lock() in fs_dax_get() (thanks Dave)=0D=0A- Re-factored som=
e __free blocks for inline declaration=0D=0A- Used FIELD_PREP where appro=
priate=0D=0A- Minor doc edits=0D=0A=0D=0AChanges v6 -> v7=0D=0A- Fixed a =
regression in famfs_interleave_fileofs_to_daxofs() that=0D=0A  was report=
ed by Intel's kernel test robot=0D=0A- Added a check in __fsdev_dax_direc=
t_access() for negative return=0D=0A  from pgoff_to_phys(), which would i=
ndicate an out-of-range offset=0D=0A- Fixed a bug in __famfs_meta_free(),=
 where not all interleaved=0D=0A  extents were freed=0D=0A- Added chunksi=
ze alignment checks in famfs_fuse_meta_alloc() and=0D=0A  famfs_interleav=
e_fileofs_to_daxofs() as interleaved chunks must=0D=0A  be PTE or PMD ali=
gned=0D=0A- Simplified famfs_file_init_dax() a bit=0D=0A- Re-ran CM's ker=
nel code review prompts on the entire series and=0D=0A  fixed several min=
or issues=0D=0A=0D=0AChanges v4 -> v5 -> v6=0D=0A- None. Re-sending due t=
o technical difficulties=0D=0A=0D=0AChanges v3 [9] -> v4=0D=0A- The patch=
 "dax: prevent driver unbind while filesystem holds device"=0D=0A  has be=
en dropped. Dan Williams indicated that the favored behavior is=0D=0A  fo=
r a file system to stop working if an underlying driver is unbound,=0D=0A=
  rather than preventing the unbind.=0D=0A- The patch "famfs_fuse: Famfs =
mount opt: -o shadow=3D<shadowpath>" has=0D=0A  been dropped. Found a way=
 for the famfs user space to do without the=0D=0A  -o opt (via getxattr).=
=0D=0A- Squashed the fs/fuse/Kconfig patch into the first subsequent patc=
h=0D=0A  that needed the change=0D=0A  ("famfs_fuse: Basic fuse kernel AB=
I enablement for famfs")=0D=0A- Many review comments addressed.=0D=0A- Ad=
dressed minor kerneldoc infractions reported by test robot.=0D=0A=0D=0ACh=
anges v2 [7] -> v3=0D=0A- Dax: Completely new fsdev driver (drivers/dax/f=
sdev.c) replaces the=0D=0A  dev_dax_iomap modifications to bus.c/device.c=
=2E Devdax devices can now=0D=0A  be switched among 'devdax', 'famfs' and=
 'system-ram' modes via daxctl=0D=0A  or sysfs.=0D=0A- Dax: fsdev uses ME=
MORY_DEVICE_FS_DAX type and leaves folios at order-0=0D=0A  (no vmemmap_s=
hift), allowing fs-dax to manage folio lifecycles=0D=0A  dynamically like=
 pmem does.=0D=0A- Dax: The "poisoned page" problem is properly fixed via=
=0D=0A  fsdev_clear_folio_state(), which clears stale mapping/compound st=
ate=0D=0A  when fsdev binds. The temporary WARN_ON_ONCE workaround in fs/=
dax.c=0D=0A  has been removed.=0D=0A- Dax: Added dax_set_ops() so fsdev c=
an set dax_operations at bind time=0D=0A  (and clear them on unbind), sin=
ce the dax_device is created before we=0D=0A  know which driver will bind=
=2E=0D=0A- Dax: Added custom bind/unbind sysfs handlers; unbind return -E=
BUSY if a=0D=0A  filesystem holds the device, preventing unbind while fam=
fs is mounted.=0D=0A- Fuse: Famfs mounts now require that the fuse server=
/daemon has=0D=0A  CAP_SYS_RAWIO because they expose raw memory devices.=0D=
=0A- Fuse: Added DAX address_space_operations with noop_dirty_folio since=
=0D=0A  famfs is memory-backed with no writeback required.=0D=0A- Rebased=
 to latest kernels, fully compatible with Alistair Popple=0D=0A  et. al's=
 recent dax refactoring.=0D=0A- Ran this series through Chris Mason's cod=
e review AI prompts to check=0D=0A  for issues - several subtle problems =
found and fixed.=0D=0A- Dropped RFC status - this version is intended to =
be mergeable.=0D=0A=0D=0AChanges v1 [8] -> v2:=0D=0A=0D=0A- The GET_FMAP =
message/response has been moved from LOOKUP to OPEN, as=0D=0A  was the pr=
etty much unanimous consensus.=0D=0A- Made the response payload to GET_FM=
AP variable sized (patch 12)=0D=0A- Dodgy kerneldoc comments cleaned up o=
r removed.=0D=0A- Fixed memory leak of fc->shadow in patch 11 (thanks Joa=
nne)=0D=0A- Dropped many pr_debug and pr_notice calls=0D=0A=0D=0A=0D=0ARe=
ferences=0D=0A=0D=0A[0] - https://github.com/jagalactic/linux/tree/famfs-=
v10 (this patch set)=0D=0A[1] - https://famfs.org (famfs user space)=0D=0A=
[2] - https://lore.kernel.org/linux-cxl/cover.1708709155.git.john@groves.=
net/=0D=0A[3] - https://lore.kernel.org/linux-cxl/cover.1714409084.git.jo=
hn@groves.net/=0D=0A[4] - https://lwn.net/Articles/983105/ (lsfmm 2024)=0D=
=0A[5] - https://lwn.net/Articles/1020170/ (lsfmm 2025)=0D=0A[6] - https:=
//lore.kernel.org/linux-cxl/cover.8068ad144a7eea4a813670301f4d2a86a8e68ec=
4.1740713401.git-series.apopple@nvidia.com/=0D=0A[7] - https://lore.kerne=
l.org/linux-fsdevel/20250703185032.46568-1-john@groves.net/ (famfs fuse v=
2)=0D=0A[8] - https://lore.kernel.org/linux-fsdevel/20250421013346.32530-=
1-john@groves.net/ (famfs fuse v1)=0D=0A[9] - https://lore.kernel.org/lin=
ux-fsdevel/20260107153244.64703-1-john@groves.net/T/#mb2c868801be16eca82d=
ab239a1d201628534aea7 (famfs fuse v3)=0D=0A=0D=0A=0D=0AJohn Groves (8):=0D=
=0A  dax: move dax_pgoff_to_phys from [drivers/dax/] device.c to bus.c=0D=
=0A  dax: Factor out dax_folio_reset_order() helper=0D=0A  dax: add fsdev=
=2Ec driver for fs-dax on character dax=0D=0A  dax: Save the kva from mem=
remap=0D=0A  dax: Add dax_operations for use by fs-dax on fsdev dax=0D=0A=
  dax: Add dax_set_ops() for setting dax_operations at bind time=0D=0A  d=
ax: Add fs_dax_get() func to prepare dax for fs-dax usage=0D=0A  dax: exp=
ort dax_dev_get()=0D=0A=0D=0A MAINTAINERS               |   8 +=0D=0A dri=
vers/dax/Kconfig       |   5 +=0D=0A drivers/dax/Makefile      |   2 +=0D=
=0A drivers/dax/bus.c         |  22 ++-=0D=0A drivers/dax/bus.h         |=
   3 +=0D=0A drivers/dax/dax-private.h |   4 +=0D=0A drivers/dax/device.c=
      |  23 ---=0D=0A drivers/dax/fsdev.c       | 346 +++++++++++++++++++=
+++++++++++++++++++=0D=0A drivers/dax/super.c       | 107 +++++++++++-=0D=
=0A fs/dax.c                  |  74 ++++++--=0D=0A include/linux/dax.h   =
    |  19 ++-=0D=0A 11 files changed, 563 insertions(+), 50 deletions(-)=0D=
=0A create mode 100644 drivers/dax/fsdev.c=0D=0A=0D=0A=0D=0Abase-commit: =
c369299895a591d96745d6492d4888259b004a9e=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A=
