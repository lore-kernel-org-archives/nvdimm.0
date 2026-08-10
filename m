Received: from a48-182.smtp-out.amazonses.com (a48-182.smtp-out.amazonses.com [54.240.48.182])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC9537F300;
	Mon, 10 Aug 2026 20:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393471; cv=none; b=EYVh/pWR7XAm31PZGweK8p29/1jD0MM794S5lG+iZeQXs16hKjWTCDDVcxkksOfYALDZQ0OgFBM4jgC/6jXeGN/2INycvi/ETPL2vAjIdn0vJtoKvQCQUhC9SoZHjUI2RXcDXgWG1sdlQxWoGZiRxyaPOTCPP8cdQAwLeQStGqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393471; c=relaxed/simple;
	bh=iOm694WDsUZmngsnhZQx0HjSfZh36pKV0vKGzFHj4G8=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=ES18b2l5LHPkfinYtAxYk/zo4WQTV0sRC345tSvuE0KiPYT1XRGbXbCHQceEHPhflJsbZHyyedrjd1jJ1K/BxbDbP44WYbOmLNfYADtxyy1q4vMnaEfeiEs7YhpmHXWt+5FIy1G5BnH2eBBj1FQu0TTLbWEybrT5f7+B3Sofc4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=cKAs2WMB; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=oCFhm6im; arc=none smtp.client-ip=54.240.48.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="cKAs2WMB";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="oCFhm6im"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1786393468;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=iOm694WDsUZmngsnhZQx0HjSfZh36pKV0vKGzFHj4G8=;
	b=cKAs2WMBloNDpvATso8Q6iyE+vOOjI65pf6uIJWe+Qr5xQ7p49BAG07ofGVHr1mu
	BBeJGSlUR1eFDqOJRfC34My23f+HaxXAlDwUI1ymeDNuAZdp9Yh8BTvyHWRevYYo8LI
	PH3hbmH/S4Qag67DWyAMuF4LRfXtVzM411vR3q60=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1786393468;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=iOm694WDsUZmngsnhZQx0HjSfZh36pKV0vKGzFHj4G8=;
	b=oCFhm6imQJcdUhFqGw9iaVZsLpPVj0CXTmArdcgKYKQzOMkMjStPhijL+m7GBTIs
	Pku/nErqZMNG5x7vkRSdddRvG7B+bRJZUR56P79O+CYK+DEXgDk0d+TwXx6rOe1AYrc
	IF6gafUuOm43O/hEmBMs3d2U+OVDs+5aL6LGA2A0=
Subject: [PATCH v13 02/12] famfs: Module operations, fs_context, and mount
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
Date: Mon, 10 Aug 2026 20:24:28 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
References: 
 <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com> 
 <20260810202419.96242-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdKQYd8BhJGjNjSyqPwMCz2Vr35AAACBAf
Thread-Topic: [PATCH v13 02/12] famfs: Module operations, fs_context, and
 mount
X-Wm-Sent-Timestamp: 1786393467
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <0100019fed591d6d-1cc81b91-15bf-44cb-90c3-33fa02bf8849-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.10-54.240.48.182

From: John Groves <john@groves.net>=0D=0A=0D=0AStart building up from the=
 famfs module operations. This commit=0D=0Aincludes the following:=0D=0A=0D=
=0A* Register as a file system=0D=0A* Parse mount parameters=0D=0A* Alloc=
ate or find (and initialize) a superblock via famfs_get_tree()=0D=0A* Loo=
kup the host dax device, and bail if it's in use (or not dax)=0D=0A* Add =
Kconfig and Makefile misc to build famfs=0D=0A* Add FAMFS_SUPER_MAGIC to =
include/uapi/linux/magic.h=0D=0A* Add export of fs/namei.c:may_open_dev()=
, which famfs needs to call=0D=0A* Update MAINTAINERS file for the fs/fam=
fs/ path=0D=0A* module_init uses the MODULE_INCOMPLETE guard to protect b=
isect-=0D=0A  ability by preventing registration as a file system until t=
he famfs=0D=0A  code is complete=0D=0A=0D=0AAdd and export fs/super.c:kil=
l_char_super().=0D=0A=0D=0Afamfs keys its superblock on the backing devda=
x device's dev_t (via=0D=0Asget_dev()), so a second mount of the same dev=
ice shares one super,=0D=0Amuch as a block filesystem keys on its block d=
evice. As a result=0D=0Asb->s_dev is a real char-device number: there is =
no s_bdev, and no=0D=0Aanonymous block device was allocated. None of the =
existing kill_sb=0D=0Ahelpers fit:=0D=0A=0D=0A  - kill_block_super() rele=
ases an s_bdev, which famfs does not have.=0D=0A  - kill_anon_super()/kil=
l_litter_super() call free_anon_bdev(s_dev),=0D=0A    but s_dev is the de=
vdax dev_t, not an anon-bdev minor famfs=0D=0A    allocated; freeing it w=
ould corrupt the anonymous-dev IDA.=0D=0A  - generic_shutdown_super() alo=
ne omits kill_super_notify(), which=0D=0A    unlinks the dying sb from fs=
_supers and wakes concurrent mounters=0D=0A    (SB_DEAD); skipping it can=
 leave a dead sb discoverable and hang a=0D=0A    racing mount.=0D=0A=0D=0A=
The correct teardown is generic_shutdown_super() + kill_super_notify()=0D=
=0Awith no device free. kill_super_notify() is static to fs/super.c, so a=
=0D=0Amodule cannot compose it -- hence this small exported helper.=0D=0A=
=0D=0AThis commit builds but is otherwise too incomplete to run=0D=0A=0D=0A=
Signed-off-by: John Groves <john@groves.net>=0D=0A---=0D=0Av13:=0D=0A - E=
xpanded the commit message to explain why the existing kill_*_super=0D=0A=
   helpers do not fit per Darrick.=0D=0A - Set famfs_fs_type.owner =3D TH=
IS_MODULE so the module cannot be unloaded=0D=0A   while a famfs is still=
 mounted (Sashiko bot).=0D=0A - Kconfig: add "depends on 64BIT". famfs ta=
rgets CXL / fabric-attached=0D=0A   memory, which only exists on 64-bit s=
ystems. (This is also why the=0D=0A   interleaved offset resolver uses na=
tive u64 arithmetic rather than=0D=0A   do_div(): Sashiko flagged the 64-=
bit division, but the resolution is that=0D=0A   famfs is 64-bit-only, no=
t do_div.)=0D=0A - Prefixed the non-static symbol lookup_daxdev() -> famf=
s_lookup_daxdev() so=0D=0A   it does not pollute the global/kallsyms name=
space (Sashiko bot).=0D=0A - famfs_parse_param(): reject an unrecognized =
mount parameter (return=0D=0A   -ENOPARAM) and an invalid dax=3D value (r=
eturn -EINVAL) instead of silently=0D=0A   accepting them (Sashiko bot).=0D=
=0A - Bisect safety: init_famfs_fs() returns -ENODEV while FAMFS_MODULE_I=
NCOMPLETE=0D=0A   is defined (added in this patch), so intermediate commi=
ts of the series=0D=0A   build but famfs cannot be mounted until it is co=
mplete. The guard is=0D=0A   removed in the statfs patch (v12 11/12).=0D=0A=
=0D=0A MAINTAINERS                |   7 +=0D=0A fs/Kconfig               =
  |   2 +=0D=0A fs/Makefile                |   1 +=0D=0A fs/famfs/Kconfig=
           |  12 ++=0D=0A fs/famfs/Makefile          |   5 +=0D=0A fs/fam=
fs/famfs_inode.c     | 307 +++++++++++++++++++++++++++++++++++++=0D=0A fs=
/famfs/famfs_internal.h  |  32 ++++=0D=0A fs/namei.c                 |   =
1 +=0D=0A fs/super.c                 |   7 +=0D=0A include/linux/fs.h    =
     |   1 +=0D=0A include/uapi/linux/magic.h |   1 +=0D=0A 11 files chan=
ged, 376 insertions(+)=0D=0A create mode 100644 fs/famfs/Kconfig=0D=0A cr=
eate mode 100644 fs/famfs/Makefile=0D=0A create mode 100644 fs/famfs/famf=
s_inode.c=0D=0A create mode 100644 fs/famfs/famfs_internal.h=0D=0A=0D=0Ad=
iff --git a/MAINTAINERS b/MAINTAINERS=0D=0Aindex 5114e6db7307..156fa62f70=
86 100644=0D=0A--- a/MAINTAINERS=0D=0A+++ b/MAINTAINERS=0D=0A@@ -9905,6 +=
9905,13 @@ F:=09Documentation/networking/failover.rst=0D=0A F:=09include/=
net/failover.h=0D=0A F:=09net/core/failover.c=0D=0A=20=0D=0A+FAMFS [Fabri=
c-Attached Memory File System]=0D=0A+M:=09John Groves <john@groves.net>=0D=
=0A+L:=09linux-fsdevel@vger.kernel.org=0D=0A+L:=09linux-cxl@vger.kernel.o=
rg=0D=0A+S:=09Supported=0D=0A+F:=09fs/famfs/=0D=0A+=0D=0A FANOTIFY=0D=0A =
M:=09Jan Kara <jack@suse.cz>=0D=0A R:=09Amir Goldstein <amir73il@gmail.co=
m>=0D=0Adiff --git a/fs/Kconfig b/fs/Kconfig=0D=0Aindex cf6ae64776e6..2db=
647accc00 100644=0D=0A--- a/fs/Kconfig=0D=0A+++ b/fs/Kconfig=0D=0A@@ -131=
,6 +131,8 @@ source "fs/autofs/Kconfig"=0D=0A source "fs/fuse/Kconfig"=0D=
=0A source "fs/overlayfs/Kconfig"=0D=0A=20=0D=0A+source "fs/famfs/Kconfig=
"=0D=0A+=0D=0A menu "Caches"=0D=0A=20=0D=0A source "fs/netfs/Kconfig"=0D=0A=
diff --git a/fs/Makefile b/fs/Makefile=0D=0Aindex 89a8a9d207d1..f49f9a000=
210 100644=0D=0A--- a/fs/Makefile=0D=0A+++ b/fs/Makefile=0D=0A@@ -129,3 +=
129,4 @@ obj-$(CONFIG_VBOXSF_FS)=09=09+=3D vboxsf/=0D=0A obj-$(CONFIG_ZON=
EFS_FS)=09=09+=3D zonefs/=0D=0A obj-$(CONFIG_BPF_LSM)=09=09+=3D bpf_fs_kf=
uncs.o=0D=0A obj-$(CONFIG_RESCTRL_FS)=09+=3D resctrl/=0D=0A+obj-$(CONFIG_=
FAMFS)=09=09+=3D famfs/=0D=0Adiff --git a/fs/famfs/Kconfig b/fs/famfs/Kco=
nfig=0D=0Anew file mode 100644=0D=0Aindex 000000000000..c914b6be0627=0D=0A=
--- /dev/null=0D=0A+++ b/fs/famfs/Kconfig=0D=0A@@ -0,0 +1,12 @@=0D=0A+=0D=
=0A+=0D=0A+config FAMFS=0D=0A+       tristate "famfs: shared memory file =
system"=0D=0A+       depends on 64BIT=0D=0A+       depends on DEV_DAX && =
FS_DAX && DEV_DAX_FSDEV=0D=0A+       default m if DEV_DAX && FS_DAX && DE=
V_DAX_FSDEV=0D=0A+       help=0D=0A+=09  Support for the famfs file syste=
m. Famfs is a dax file system that=0D=0A+=09  can support scale-out share=
d access to fabric-attached memory=0D=0A+=09  (e.g. CXL shared memory). F=
amfs is not a general purpose file system;=0D=0A+=09  it is an enabler fo=
r data sets in shared memory.=0D=0Adiff --git a/fs/famfs/Makefile b/fs/fa=
mfs/Makefile=0D=0Anew file mode 100644=0D=0Aindex 000000000000..62230bcd6=
793=0D=0A--- /dev/null=0D=0A+++ b/fs/famfs/Makefile=0D=0A@@ -0,0 +1,5 @@=0D=
=0A+# SPDX-License-Identifier: GPL-2.0=0D=0A+=0D=0A+obj-$(CONFIG_FAMFS) +=
=3D famfs.o=0D=0A+=0D=0A+famfs-y :=3D famfs_inode.o=0D=0Adiff --git a/fs/=
famfs/famfs_inode.c b/fs/famfs/famfs_inode.c=0D=0Anew file mode 100644=0D=
=0Aindex 000000000000..5a13903da61b=0D=0A--- /dev/null=0D=0A+++ b/fs/famf=
s/famfs_inode.c=0D=0A@@ -0,0 +1,307 @@=0D=0A+// SPDX-License-Identifier: =
GPL-2.0=0D=0A+/*=0D=0A+ * famfs - dax file system for shared fabric-attac=
hed memory=0D=0A+ *=0D=0A+ * Copyright 2023-2024 Micron Technology, inc=0D=
=0A+ *=0D=0A+ * This file system, originally based on ramfs the dax suppo=
rt from xfs,=0D=0A+ * is intended to allow multiple host systems to mount=
 a common file system=0D=0A+ * view of dax files that map to shared memor=
y.=0D=0A+ */=0D=0A+=0D=0A+#include <linux/fs.h>=0D=0A+#include <linux/cle=
anup.h>=0D=0A+#include <linux/time.h>=0D=0A+#include <linux/init.h>=0D=0A=
+#include <linux/string.h>=0D=0A+#include <linux/parser.h>=0D=0A+#include=
 <linux/magic.h>=0D=0A+#include <linux/slab.h>=0D=0A+#include <linux/fs_c=
ontext.h>=0D=0A+#include <linux/fs_parser.h>=0D=0A+#include <linux/dax.h>=
=0D=0A+#include <linux/hugetlb.h>=0D=0A+#include <linux/iomap.h>=0D=0A+#i=
nclude <linux/path.h>=0D=0A+#include <linux/namei.h>=0D=0A+=0D=0A+#includ=
e "famfs_internal.h"=0D=0A+=0D=0A+#define FAMFS_DEFAULT_MODE=090755=0D=0A=
+=0D=0A+static struct inode *=0D=0A+famfs_get_inode(=0D=0A+=09struct supe=
r_block *sb,=0D=0A+=09const struct inode *dir,=0D=0A+=09umode_t mode, dev=
_t dev)=0D=0A+{=0D=0A+=09struct inode *inode =3D new_inode(sb);=0D=0A+=09=
struct timespec64 tv;=0D=0A+=0D=0A+=09if (!inode)=0D=0A+=09=09return NULL=
;=0D=0A+=0D=0A+=09inode->i_ino =3D get_next_ino();=0D=0A+=09inode_init_ow=
ner(&nop_mnt_idmap, inode, dir, mode);=0D=0A+=09inode->i_mapping->a_ops =3D=
 &ram_aops;=0D=0A+=09mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER)=
;=0D=0A+=09mapping_set_unevictable(inode->i_mapping);=0D=0A+=09tv =3D ino=
de_set_ctime_current(inode);=0D=0A+=09inode_set_mtime_to_ts(inode, tv);=0D=
=0A+=09inode_set_atime_to_ts(inode, tv);=0D=0A+=0D=0A+=09switch (mode & S=
_IFMT) {=0D=0A+=09default:=0D=0A+=09=09init_special_inode(inode, mode, de=
v);=0D=0A+=09=09break;=0D=0A+=09case S_IFREG:=0D=0A+=09=09inode->i_op =3D=
 NULL /* famfs_file_inode_operations */;=0D=0A+=09=09inode->i_fop =3D NUL=
L /* &famfs_file_operations */;=0D=0A+=09=09break;=0D=0A+=09case S_IFDIR:=
=0D=0A+=09=09inode->i_op =3D NULL /* famfs_dir_inode_operations */;=0D=0A=
+=09=09inode->i_fop =3D &simple_dir_operations;=0D=0A+=0D=0A+=09=09/* Dir=
ectory inodes start off with i_nlink =3D=3D 2 (for ".") */=0D=0A+=09=09in=
c_nlink(inode);=0D=0A+=09=09break;=0D=0A+=09case S_IFLNK:=0D=0A+=09=09ino=
de->i_op =3D &page_symlink_inode_operations;=0D=0A+=09=09inode_nohighmem(=
inode);=0D=0A+=09=09break;=0D=0A+=09}=0D=0A+=09return inode;=0D=0A+}=0D=0A=
+=0D=0A+/*=0D=0A+ * famfs dax_operations (for famfs-mode dax)=0D=0A+ */=0D=
=0A+/********************************************************************=
*********=0D=0A+ * fs_context_operations=0D=0A+ */=0D=0A+=0D=0A+static vo=
id=0D=0A+famfs_fill_super(struct super_block *sb, struct fs_context *fc)=0D=
=0A+{=0D=0A+=09sb->s_maxbytes=09=09=3D MAX_LFS_FILESIZE;=0D=0A+=09sb->s_b=
locksize=09=09=3D PAGE_SIZE;=0D=0A+=09sb->s_blocksize_bits=09=3D PAGE_SHI=
FT;=0D=0A+=09sb->s_magic=09=09=3D FAMFS_SUPER_MAGIC;=0D=0A+=09sb->s_op=09=
=09=3D NULL /* famfs_super_ops */;=0D=0A+=09sb->s_time_gran=09=09=3D 1;=0D=
=0A+}=0D=0A+=0D=0A+int=0D=0A+famfs_lookup_daxdev(const char *pathname, de=
v_t *devno)=0D=0A+{=0D=0A+=09struct inode *inode;=0D=0A+=09struct path pa=
th;=0D=0A+=09int err;=0D=0A+=0D=0A+=09if (!pathname || !*pathname)=0D=0A+=
=09=09return -EINVAL;=0D=0A+=0D=0A+=09err =3D kern_path(pathname, LOOKUP_=
FOLLOW, &path);=0D=0A+=09if (err)=0D=0A+=09=09return err;=0D=0A+=0D=0A+=09=
inode =3D d_backing_inode(path.dentry);=0D=0A+=09if (!S_ISCHR(inode->i_mo=
de)) {=0D=0A+=09=09err =3D -EINVAL;=0D=0A+=09=09goto out_path_put;=0D=0A+=
=09}=0D=0A+=0D=0A+=09if (!may_open_dev(&path)) {=0D=0A+=09=09err =3D -EAC=
CES;=0D=0A+=09=09goto out_path_put;=0D=0A+=09}=0D=0A+=0D=0A+=09/* i_rdev =
is the char dev_t; fs_dax_get() confirms it is dax later */=0D=0A+=09*dev=
no =3D inode->i_rdev;=0D=0A+=0D=0A+out_path_put:=0D=0A+=09path_put(&path)=
;=0D=0A+=09return err;=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+famfs_get_tr=
ee(struct fs_context *fc)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D =
fc->s_fs_info;=0D=0A+=09struct super_block *sb;=0D=0A+=09struct inode *in=
ode;=0D=0A+=09dev_t daxdevno;=0D=0A+=09int err;=0D=0A+=0D=0A+=09err =3D f=
amfs_lookup_daxdev(fc->source, &daxdevno);=0D=0A+=09if (err)=0D=0A+=09=09=
return err;=0D=0A+=0D=0A+=09/* This will set sb->s_dev=3Ddaxdevno */=0D=0A=
+=09sb =3D sget_dev(fc, daxdevno);=0D=0A+=09if (IS_ERR(sb)) {=0D=0A+=09=09=
pr_debug("%s: sget_dev error\n", __func__);=0D=0A+=09=09return PTR_ERR(sb=
);=0D=0A+=09}=0D=0A+=0D=0A+=09if (sb->s_root) {=0D=0A+=09=09pr_debug("%s:=
 found a matching superblock for %s\n",=0D=0A+=09=09=09__func__, fc->sour=
ce);=0D=0A+=0D=0A+=09=09/* We don't expect to find a match by dev_t; if w=
e do, it must=0D=0A+=09=09 * already be mounted, so we bail=0D=0A+=09=09 =
*/=0D=0A+=09=09err =3D -EBUSY;=0D=0A+=09=09goto deactivate_out;=0D=0A+=09=
} else {=0D=0A+=09=09pr_debug("%s: initializing new superblock for %s\n",=
=0D=0A+=09=09=09__func__, fc->source);=0D=0A+=09=09famfs_fill_super(sb, f=
c);=0D=0A+=09}=0D=0A+=0D=0A+=09inode =3D famfs_get_inode(sb, NULL, S_IFDI=
R | fsi->mount_opts.mode, 0);=0D=0A+=09sb->s_root =3D d_make_root(inode);=
=0D=0A+=09if (!sb->s_root) {=0D=0A+=09=09pr_debug("%s: d_make_root() fail=
ed\n", __func__);=0D=0A+=09=09err =3D -ENOMEM;=0D=0A+=09=09goto deactivat=
e_out;=0D=0A+=09}=0D=0A+=0D=0A+=09sb->s_flags |=3D SB_ACTIVE;=0D=0A+=0D=0A=
+=09WARN_ON(fc->root);=0D=0A+=09fc->root =3D dget(sb->s_root);=0D=0A+=09r=
eturn 0;=0D=0A+=0D=0A+deactivate_out:=0D=0A+=09pr_debug("%s: deactivating=
 sb=3D%llx\n", __func__, (u64)sb);=0D=0A+=09deactivate_locked_super(sb);=0D=
=0A+=09return err;=0D=0A+}=0D=0A+=0D=0A+/********************************=
*********************************************/=0D=0A+=0D=0A+enum famfs_pa=
ram {=0D=0A+=09Opt_mode,=0D=0A+=09Opt_dax,=0D=0A+};=0D=0A+=0D=0A+const st=
ruct fs_parameter_spec famfs_fs_parameters[] =3D {=0D=0A+=09fsparam_u32oc=
t("mode",=09  Opt_mode),=0D=0A+=09fsparam_string("dax",     Opt_dax),=0D=0A=
+=09{}=0D=0A+};=0D=0A+=0D=0A+static int=0D=0A+famfs_parse_param(struct fs=
_context *fc, struct fs_parameter *param)=0D=0A+{=0D=0A+=09struct famfs_f=
s_info *fsi =3D fc->s_fs_info;=0D=0A+=09struct fs_parse_result result;=0D=
=0A+=09int opt;=0D=0A+=0D=0A+=09opt =3D fs_parse(fc, famfs_fs_parameters,=
 param, &result);=0D=0A+=09if (opt =3D=3D -ENOPARAM) {=0D=0A+=09=09opt =3D=
 vfs_parse_fs_param_source(fc, param);=0D=0A+=09=09if (opt !=3D -ENOPARAM=
)=0D=0A+=09=09=09return opt;=0D=0A+=0D=0A+=09=09return -ENOPARAM;=0D=0A+=09=
}=0D=0A+=09if (opt < 0)=0D=0A+=09=09return opt;=0D=0A+=0D=0A+=09switch (o=
pt) {=0D=0A+=09case Opt_mode:=0D=0A+=09=09fsi->mount_opts.mode =3D result=
=2Euint_32 & S_IALLUGO;=0D=0A+=09=09break;=0D=0A+=09case Opt_dax:=0D=0A+=09=
=09if (strcmp(param->string, "always")) {=0D=0A+=09=09=09pr_debug("%s: in=
valid dax mode %s\n",=0D=0A+=09=09=09=09  __func__, param->string);=0D=0A=
+=09=09=09return -EINVAL;=0D=0A+=09=09}=0D=0A+=09=09break;=0D=0A+=09}=0D=0A=
+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static void=0D=0A+famfs_free_fc=
(struct fs_context *fc)=0D=0A+{=0D=0A+=09kfree(fc->s_fs_info);=0D=0A+}=0D=
=0A+=0D=0A+static const struct fs_context_operations famfs_context_ops =3D=
 {=0D=0A+=09.free=09=09=3D famfs_free_fc,=0D=0A+=09.parse_param=09=3D fam=
fs_parse_param,=0D=0A+=09.get_tree=09=3D famfs_get_tree,=0D=0A+};=0D=0A+=0D=
=0A+static int=0D=0A+famfs_init_fs_context(struct fs_context *fc)=0D=0A+{=
=0D=0A+=09struct famfs_fs_info *fsi;=0D=0A+=0D=0A+=09fsi =3D kzalloc_obj(=
*fsi, GFP_KERNEL);=0D=0A+=09if (!fsi)=0D=0A+=09=09return -ENOMEM;=0D=0A+=0D=
=0A+=09fsi->mount_opts.mode =3D FAMFS_DEFAULT_MODE;=0D=0A+=09fc->s_fs_inf=
o        =3D fsi;=0D=0A+=09fc->ops              =3D &famfs_context_ops;=0D=
=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static void=0D=0A+famfs_kill_sb(str=
uct super_block *sb)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D sb->s=
_fs_info;=0D=0A+=0D=0A+=09kill_char_super(sb);=0D=0A+=0D=0A+=09kfree(fsi)=
;=0D=0A+=09sb->s_fs_info =3D NULL;=0D=0A+}=0D=0A+=0D=0A+#define MODULE_NA=
ME "famfs"=0D=0A+static struct file_system_type famfs_fs_type =3D {=0D=0A=
+=09.owner=09=09  =3D THIS_MODULE,=0D=0A+=09.name=09=09  =3D MODULE_NAME,=
=0D=0A+=09.init_fs_context  =3D famfs_init_fs_context,=0D=0A+=09.paramete=
rs=09  =3D famfs_fs_parameters,=0D=0A+=09.kill_sb=09  =3D famfs_kill_sb,=0D=
=0A+=09.fs_flags=09  =3D FS_REQUIRES_DEV,=0D=0A+};=0D=0A+=0D=0A+/********=
**********************************************************************=0D=
=0A+ * Module stuff=0D=0A+ */=0D=0A+#define FAMFS_MODULE_INCOMPLETE 1=0D=0A=
+=0D=0A+static int __init=0D=0A+init_famfs_fs(void)=0D=0A+{=0D=0A+=09int =
rc;=0D=0A+=0D=0A+=09if (FAMFS_MODULE_INCOMPLETE)=0D=0A+=09=09return -ENOD=
EV;=0D=0A+=0D=0A+=09rc =3D register_filesystem(&famfs_fs_type);=0D=0A+=0D=
=0A+=09return rc;=0D=0A+}=0D=0A+=0D=0A+static void __exit=0D=0A+famfs_exi=
t(void)=0D=0A+{=0D=0A+=09unregister_filesystem(&famfs_fs_type);=0D=0A+=09=
pr_info("%s: unregistered\n", __func__);=0D=0A+}=0D=0A+=0D=0A+fs_initcall=
(init_famfs_fs);=0D=0A+module_exit(famfs_exit);=0D=0A+=0D=0A+MODULE_AUTHO=
R("John Groves");=0D=0A+MODULE_DESCRIPTION("Fabric-Attached Memory File S=
ystem: see famfs.org");=0D=0A+MODULE_LICENSE("GPL");=0D=0Adiff --git a/fs=
/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h=0D=0Anew file mode 10=
0644=0D=0Aindex 000000000000..378544b1aabe=0D=0A--- /dev/null=0D=0A+++ b/=
fs/famfs/famfs_internal.h=0D=0A@@ -0,0 +1,32 @@=0D=0A+/* SPDX-License-Ide=
ntifier: GPL-2.0 */=0D=0A+/*=0D=0A+ * famfs - dax file system for shared =
fabric-attached memory=0D=0A+ *=0D=0A+ * Copyright 2023-2024 Micron Techn=
ology, Inc.=0D=0A+ *=0D=0A+ * This file system, originally based on ramfs=
 the dax support from xfs,=0D=0A+ * is intended to allow multiple host sy=
stems to mount a common file system=0D=0A+ * view of dax files that map t=
o shared memory.=0D=0A+ */=0D=0A+#ifndef FAMFS_INTERNAL_H=0D=0A+#define F=
AMFS_INTERNAL_H=0D=0A+=0D=0A+struct famfs_mount_opts {=0D=0A+=09umode_t m=
ode;=0D=0A+};=0D=0A+=0D=0A+/**=0D=0A+ * @famfs_fs_info=0D=0A+ *=0D=0A+ * =
@mount_opts:  The mount options=0D=0A+ * @deverror:    True if the dax de=
vice has called our notify_failure entry=0D=0A+ *               point, or=
 if other "shutdown" conditions exist=0D=0A+ */=0D=0A+struct famfs_fs_inf=
o {=0D=0A+=09struct famfs_mount_opts   mount_opts;=0D=0A+=09bool         =
             deverror;=0D=0A+};=0D=0A+=0D=0A+int famfs_lookup_daxdev(cons=
t char *pathname, dev_t *devno);=0D=0A+=0D=0A+#endif /* FAMFS_INTERNAL_H =
*/=0D=0Adiff --git a/fs/namei.c b/fs/namei.c=0D=0Aindex 19ce43c9a6e6..d67=
194e89963 100644=0D=0A--- a/fs/namei.c=0D=0A+++ b/fs/namei.c=0D=0A@@ -423=
2,6 +4232,7 @@ bool may_open_dev(const struct path *path)=0D=0A =09return=
 !(path->mnt->mnt_flags & MNT_NODEV) &&=0D=0A =09=09!(path->mnt->mnt_sb->=
s_iflags & SB_I_NODEV);=0D=0A }=0D=0A+EXPORT_SYMBOL(may_open_dev);=0D=0A=20=
=0D=0A static int may_open(struct mnt_idmap *idmap, const struct path *pa=
th,=0D=0A =09=09    int acc_mode, int flag)=0D=0Adiff --git a/fs/super.c =
b/fs/super.c=0D=0Aindex ffdcc6a2e0de..bcdfd3563aaa 100644=0D=0A--- a/fs/s=
uper.c=0D=0A+++ b/fs/super.c=0D=0A@@ -1241,6 +1241,13 @@ void kill_anon_s=
uper(struct super_block *sb)=0D=0A }=0D=0A EXPORT_SYMBOL(kill_anon_super)=
;=0D=0A=20=0D=0A+void kill_char_super(struct super_block *sb)=0D=0A+{=0D=0A=
+=09generic_shutdown_super(sb);=0D=0A+=09kill_super_notify(sb);=0D=0A+}=0D=
=0A+EXPORT_SYMBOL(kill_char_super);=0D=0A+=0D=0A int set_anon_super_fc(st=
ruct super_block *sb, struct fs_context *fc)=0D=0A {=0D=0A =09return set_=
anon_super(sb, NULL);=0D=0Adiff --git a/include/linux/fs.h b/include/linu=
x/fs.h=0D=0Aindex 50ce731a2b78..a8b030d6f218 100644=0D=0A--- a/include/li=
nux/fs.h=0D=0A+++ b/include/linux/fs.h=0D=0A@@ -2328,6 +2328,7 @@ void re=
tire_super(struct super_block *sb);=0D=0A void generic_shutdown_super(str=
uct super_block *sb);=0D=0A void kill_block_super(struct super_block *sb)=
;=0D=0A void kill_anon_super(struct super_block *sb);=0D=0A+void kill_cha=
r_super(struct super_block *sb);=0D=0A void deactivate_super(struct super=
_block *sb);=0D=0A void deactivate_locked_super(struct super_block *sb);=0D=
=0A int set_anon_super(struct super_block *s, void *data);=0D=0Adiff --gi=
t a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h=0D=0Aindex 4f=
2da935a76c..e644e1fd49bd 100644=0D=0A--- a/include/uapi/linux/magic.h=0D=0A=
+++ b/include/uapi/linux/magic.h=0D=0A@@ -38,6 +38,7 @@=0D=0A #define OVE=
RLAYFS_SUPER_MAGIC=090x794c7630=0D=0A #define FUSE_SUPER_MAGIC=090x657355=
46=0D=0A #define BCACHEFS_SUPER_MAGIC=090xca451a4e=0D=0A+#define FAMFS_SU=
PER_MAGIC=090x87b282ff=0D=0A=20=0D=0A #define MINIX_SUPER_MAGIC=090x137F=09=
=09/* minix v1 fs, 14 char names */=0D=0A #define MINIX_SUPER_MAGIC2=090x=
138F=09=09/* minix v1 fs, 30 char names */=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=
=0A
