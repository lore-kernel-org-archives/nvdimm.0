Received: from a8-21.smtp-out.amazonses.com (a8-21.smtp-out.amazonses.com [54.240.8.21])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA57E396579;
	Sat, 29 Aug 2026 17:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788023470; cv=none; b=EjijVm9ouE3+gSv+A7eY2Zv3bIBdQLbzZ2w5Ov48mIoPoHrLIB771u0U5UA3EYbearxdpGsPI9WxMGmQPzRUBTSmYqREiSScGUPZxZRoNYokhy/sru+BEokCVwCwbE0iCqyW9wpRFaZfh0ttIDtKMhHIg2dJL15IJ054MyrVSIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788023470; c=relaxed/simple;
	bh=x+52pPGZvmw60pqwiIvWi/44oAAIbn5W+HKAymaXZsw=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=NHdRxz/XkB4s7JhdTLf65jGJg52CngyVhtl2w948vih9Pc6GCy7ANbXTmmAKp+CXKDlFQI1XBgn5c7wQCnOM+hConP6JYWEPD2SO+6m+16PP6EQC9BH0wt9SrFBtNrc3SQn93xK3Fsr4OclABk2XB3vAHde7vd9LiPnGLsgDzF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=JTlOKuYg; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=dlI9iY11; arc=none smtp.client-ip=54.240.8.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="JTlOKuYg";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="dlI9iY11"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=rjayupzefgi7e6fmzxcxe4cv4arrjs35; d=jagalactic.com; t=1788023462;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=x+52pPGZvmw60pqwiIvWi/44oAAIbn5W+HKAymaXZsw=;
	b=JTlOKuYgSgd3sd5UrG2ngPOXq4ucwhHOsitt1h6h7smDDeNZmch75osB/1Qz/s84
	VmrkEjr7fOPyx748ZDe5sR1HJjPPrbAwdvZziKtl36l+pzM5W5KRRun4w6vCm0F1KRQ
	IS9SroS1K/iyFi1FJAwwbWFgJ0d2/c4kZW4DipsA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1788023462;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=x+52pPGZvmw60pqwiIvWi/44oAAIbn5W+HKAymaXZsw=;
	b=dlI9iY11YVkpJbzKS2FYYsdXEbJMeJpAEVdyYcFnnZcnOsI6hSnKm9cO+HJngdI2
	b9VpdgE0RUwRQAWY3FTZWBVrq7jmxVPwJIt4dLs+14IIFVB0tQuczf7gaf53lVo7mc2
	zVoVIei4lmzvwuhgG8MBxuayY1msasaYLuA/fWVc=
Subject: [PATCH V14 02/12] famfs: Module operations, fs_context, and mount
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
Date: Sat, 29 Aug 2026 17:11:02 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
References: 
 <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com> 
 <20260829171055.7379-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdN9lAfqnLmnnsQyaIwPphM+3eHAAAB000
Thread-Topic: [PATCH V14 02/12] famfs: Module operations, fs_context, and
 mount
X-Wm-Sent-Timestamp: 1788023460
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <010001a04e80d952-12403958-9576-475d-a375-b0948273892f-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.29-54.240.8.21

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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>=0D=0AReviewed-by: Jeff=
 Layton <jlayton@kernel.org>=0D=0ASigned-off-by: John Groves <john@groves=
=2Enet>=0D=0A---=0D=0A=0D=0A MAINTAINERS                |   7 +=0D=0A fs/=
Kconfig                 |   2 +=0D=0A fs/Makefile                |   1 +=0D=
=0A fs/famfs/Kconfig           |  12 ++=0D=0A fs/famfs/Makefile          =
|   5 +=0D=0A fs/famfs/famfs_inode.c     | 307 ++++++++++++++++++++++++++=
+++++++++++=0D=0A fs/famfs/famfs_internal.h  |  32 ++++=0D=0A fs/namei.c =
                |   1 +=0D=0A fs/super.c                 |   7 +=0D=0A in=
clude/linux/fs.h         |   1 +=0D=0A include/uapi/linux/magic.h |   1 +=
=0D=0A 11 files changed, 376 insertions(+)=0D=0A create mode 100644 fs/fa=
mfs/Kconfig=0D=0A create mode 100644 fs/famfs/Makefile=0D=0A create mode =
100644 fs/famfs/famfs_inode.c=0D=0A create mode 100644 fs/famfs/famfs_int=
ernal.h=0D=0A=0D=0Adiff --git a/MAINTAINERS b/MAINTAINERS=0D=0Aindex 8014=
b9f8253e..bfc3acf72c9c 100644=0D=0A--- a/MAINTAINERS=0D=0A+++ b/MAINTAINE=
RS=0D=0A@@ -9896,6 +9896,13 @@ F:=09Documentation/networking/failover.rst=
=0D=0A F:=09include/net/failover.h=0D=0A F:=09net/core/failover.c=0D=0A=20=
=0D=0A+FAMFS [Fabric-Attached Memory File System]=0D=0A+M:=09John Groves =
<John@Groves.net>=0D=0A+L:=09linux-fsdevel@vger.kernel.org=0D=0A+L:=09lin=
ux-cxl@vger.kernel.org=0D=0A+S:=09Supported=0D=0A+F:=09fs/famfs/=0D=0A+=0D=
=0A FANOTIFY=0D=0A M:=09Jan Kara <jack@suse.cz>=0D=0A R:=09Amir Goldstein=
 <amir73il@gmail.com>=0D=0Adiff --git a/fs/Kconfig b/fs/Kconfig=0D=0Ainde=
x cf6ae64776e6..2db647accc00 100644=0D=0A--- a/fs/Kconfig=0D=0A+++ b/fs/K=
config=0D=0A@@ -131,6 +131,8 @@ source "fs/autofs/Kconfig"=0D=0A source "=
fs/fuse/Kconfig"=0D=0A source "fs/overlayfs/Kconfig"=0D=0A=20=0D=0A+sourc=
e "fs/famfs/Kconfig"=0D=0A+=0D=0A menu "Caches"=0D=0A=20=0D=0A source "fs=
/netfs/Kconfig"=0D=0Adiff --git a/fs/Makefile b/fs/Makefile=0D=0Aindex 89=
a8a9d207d1..f49f9a000210 100644=0D=0A--- a/fs/Makefile=0D=0A+++ b/fs/Make=
file=0D=0A@@ -129,3 +129,4 @@ obj-$(CONFIG_VBOXSF_FS)=09=09+=3D vboxsf/=0D=
=0A obj-$(CONFIG_ZONEFS_FS)=09=09+=3D zonefs/=0D=0A obj-$(CONFIG_BPF_LSM)=
=09=09+=3D bpf_fs_kfuncs.o=0D=0A obj-$(CONFIG_RESCTRL_FS)=09+=3D resctrl/=
=0D=0A+obj-$(CONFIG_FAMFS)=09=09+=3D famfs/=0D=0Adiff --git a/fs/famfs/Kc=
onfig b/fs/famfs/Kconfig=0D=0Anew file mode 100644=0D=0Aindex 00000000000=
0..c914b6be0627=0D=0A--- /dev/null=0D=0A+++ b/fs/famfs/Kconfig=0D=0A@@ -0=
,0 +1,12 @@=0D=0A+=0D=0A+=0D=0A+config FAMFS=0D=0A+       tristate "famfs=
: shared memory file system"=0D=0A+       depends on 64BIT=0D=0A+       d=
epends on DEV_DAX && FS_DAX && DEV_DAX_FSDEV=0D=0A+       default m if DE=
V_DAX && FS_DAX && DEV_DAX_FSDEV=0D=0A+       help=0D=0A+=09  Support for=
 the famfs file system. Famfs is a dax file system that=0D=0A+=09  can su=
pport scale-out shared access to fabric-attached memory=0D=0A+=09  (e.g. =
CXL shared memory). Famfs is not a general purpose file system;=0D=0A+=09=
  it is an enabler for data sets in shared memory.=0D=0Adiff --git a/fs/f=
amfs/Makefile b/fs/famfs/Makefile=0D=0Anew file mode 100644=0D=0Aindex 00=
0000000000..62230bcd6793=0D=0A--- /dev/null=0D=0A+++ b/fs/famfs/Makefile=0D=
=0A@@ -0,0 +1,5 @@=0D=0A+# SPDX-License-Identifier: GPL-2.0=0D=0A+=0D=0A+=
obj-$(CONFIG_FAMFS) +=3D famfs.o=0D=0A+=0D=0A+famfs-y :=3D famfs_inode.o=0D=
=0Adiff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c=0D=0Anew =
file mode 100644=0D=0Aindex 000000000000..5a13903da61b=0D=0A--- /dev/null=
=0D=0A+++ b/fs/famfs/famfs_inode.c=0D=0A@@ -0,0 +1,307 @@=0D=0A+// SPDX-L=
icense-Identifier: GPL-2.0=0D=0A+/*=0D=0A+ * famfs - dax file system for =
shared fabric-attached memory=0D=0A+ *=0D=0A+ * Copyright 2023-2024 Micro=
n Technology, inc=0D=0A+ *=0D=0A+ * This file system, originally based on=
 ramfs the dax support from xfs,=0D=0A+ * is intended to allow multiple h=
ost systems to mount a common file system=0D=0A+ * view of dax files that=
 map to shared memory.=0D=0A+ */=0D=0A+=0D=0A+#include <linux/fs.h>=0D=0A=
+#include <linux/cleanup.h>=0D=0A+#include <linux/time.h>=0D=0A+#include =
<linux/init.h>=0D=0A+#include <linux/string.h>=0D=0A+#include <linux/pars=
er.h>=0D=0A+#include <linux/magic.h>=0D=0A+#include <linux/slab.h>=0D=0A+=
#include <linux/fs_context.h>=0D=0A+#include <linux/fs_parser.h>=0D=0A+#i=
nclude <linux/dax.h>=0D=0A+#include <linux/hugetlb.h>=0D=0A+#include <lin=
ux/iomap.h>=0D=0A+#include <linux/path.h>=0D=0A+#include <linux/namei.h>=0D=
=0A+=0D=0A+#include "famfs_internal.h"=0D=0A+=0D=0A+#define FAMFS_DEFAULT=
_MODE=090755=0D=0A+=0D=0A+static struct inode *=0D=0A+famfs_get_inode(=0D=
=0A+=09struct super_block *sb,=0D=0A+=09const struct inode *dir,=0D=0A+=09=
umode_t mode, dev_t dev)=0D=0A+{=0D=0A+=09struct inode *inode =3D new_ino=
de(sb);=0D=0A+=09struct timespec64 tv;=0D=0A+=0D=0A+=09if (!inode)=0D=0A+=
=09=09return NULL;=0D=0A+=0D=0A+=09inode->i_ino =3D get_next_ino();=0D=0A=
+=09inode_init_owner(&nop_mnt_idmap, inode, dir, mode);=0D=0A+=09inode->i=
_mapping->a_ops =3D &ram_aops;=0D=0A+=09mapping_set_gfp_mask(inode->i_map=
ping, GFP_HIGHUSER);=0D=0A+=09mapping_set_unevictable(inode->i_mapping);=0D=
=0A+=09tv =3D inode_set_ctime_current(inode);=0D=0A+=09inode_set_mtime_to=
_ts(inode, tv);=0D=0A+=09inode_set_atime_to_ts(inode, tv);=0D=0A+=0D=0A+=09=
switch (mode & S_IFMT) {=0D=0A+=09default:=0D=0A+=09=09init_special_inode=
(inode, mode, dev);=0D=0A+=09=09break;=0D=0A+=09case S_IFREG:=0D=0A+=09=09=
inode->i_op =3D NULL /* famfs_file_inode_operations */;=0D=0A+=09=09inode=
->i_fop =3D NULL /* &famfs_file_operations */;=0D=0A+=09=09break;=0D=0A+=09=
case S_IFDIR:=0D=0A+=09=09inode->i_op =3D NULL /* famfs_dir_inode_operati=
ons */;=0D=0A+=09=09inode->i_fop =3D &simple_dir_operations;=0D=0A+=0D=0A=
+=09=09/* Directory inodes start off with i_nlink =3D=3D 2 (for ".") */=0D=
=0A+=09=09inc_nlink(inode);=0D=0A+=09=09break;=0D=0A+=09case S_IFLNK:=0D=0A=
+=09=09inode->i_op =3D &page_symlink_inode_operations;=0D=0A+=09=09inode_=
nohighmem(inode);=0D=0A+=09=09break;=0D=0A+=09}=0D=0A+=09return inode;=0D=
=0A+}=0D=0A+=0D=0A+/*=0D=0A+ * famfs dax_operations (for famfs-mode dax)=0D=
=0A+ */=0D=0A+/**********************************************************=
*******************=0D=0A+ * fs_context_operations=0D=0A+ */=0D=0A+=0D=0A=
+static void=0D=0A+famfs_fill_super(struct super_block *sb, struct fs_con=
text *fc)=0D=0A+{=0D=0A+=09sb->s_maxbytes=09=09=3D MAX_LFS_FILESIZE;=0D=0A=
+=09sb->s_blocksize=09=09=3D PAGE_SIZE;=0D=0A+=09sb->s_blocksize_bits=09=3D=
 PAGE_SHIFT;=0D=0A+=09sb->s_magic=09=09=3D FAMFS_SUPER_MAGIC;=0D=0A+=09sb=
->s_op=09=09=3D NULL /* famfs_super_ops */;=0D=0A+=09sb->s_time_gran=09=09=
=3D 1;=0D=0A+}=0D=0A+=0D=0A+int=0D=0A+famfs_lookup_daxdev(const char *pat=
hname, dev_t *devno)=0D=0A+{=0D=0A+=09struct inode *inode;=0D=0A+=09struc=
t path path;=0D=0A+=09int err;=0D=0A+=0D=0A+=09if (!pathname || !*pathnam=
e)=0D=0A+=09=09return -EINVAL;=0D=0A+=0D=0A+=09err =3D kern_path(pathname=
, LOOKUP_FOLLOW, &path);=0D=0A+=09if (err)=0D=0A+=09=09return err;=0D=0A+=
=0D=0A+=09inode =3D d_backing_inode(path.dentry);=0D=0A+=09if (!S_ISCHR(i=
node->i_mode)) {=0D=0A+=09=09err =3D -EINVAL;=0D=0A+=09=09goto out_path_p=
ut;=0D=0A+=09}=0D=0A+=0D=0A+=09if (!may_open_dev(&path)) {=0D=0A+=09=09er=
r =3D -EACCES;=0D=0A+=09=09goto out_path_put;=0D=0A+=09}=0D=0A+=0D=0A+=09=
/* i_rdev is the char dev_t; fs_dax_get() confirms it is dax later */=0D=0A=
+=09*devno =3D inode->i_rdev;=0D=0A+=0D=0A+out_path_put:=0D=0A+=09path_pu=
t(&path);=0D=0A+=09return err;=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+famf=
s_get_tree(struct fs_context *fc)=0D=0A+{=0D=0A+=09struct famfs_fs_info *=
fsi =3D fc->s_fs_info;=0D=0A+=09struct super_block *sb;=0D=0A+=09struct i=
node *inode;=0D=0A+=09dev_t daxdevno;=0D=0A+=09int err;=0D=0A+=0D=0A+=09e=
rr =3D famfs_lookup_daxdev(fc->source, &daxdevno);=0D=0A+=09if (err)=0D=0A=
+=09=09return err;=0D=0A+=0D=0A+=09/* This will set sb->s_dev=3Ddaxdevno =
*/=0D=0A+=09sb =3D sget_dev(fc, daxdevno);=0D=0A+=09if (IS_ERR(sb)) {=0D=0A=
+=09=09pr_debug("%s: sget_dev error\n", __func__);=0D=0A+=09=09return PTR=
_ERR(sb);=0D=0A+=09}=0D=0A+=0D=0A+=09if (sb->s_root) {=0D=0A+=09=09pr_deb=
ug("%s: found a matching superblock for %s\n",=0D=0A+=09=09=09__func__, f=
c->source);=0D=0A+=0D=0A+=09=09/* We don't expect to find a match by dev_=
t; if we do, it must=0D=0A+=09=09 * already be mounted, so we bail=0D=0A+=
=09=09 */=0D=0A+=09=09err =3D -EBUSY;=0D=0A+=09=09goto deactivate_out;=0D=
=0A+=09} else {=0D=0A+=09=09pr_debug("%s: initializing new superblock for=
 %s\n",=0D=0A+=09=09=09__func__, fc->source);=0D=0A+=09=09famfs_fill_supe=
r(sb, fc);=0D=0A+=09}=0D=0A+=0D=0A+=09inode =3D famfs_get_inode(sb, NULL,=
 S_IFDIR | fsi->mount_opts.mode, 0);=0D=0A+=09sb->s_root =3D d_make_root(=
inode);=0D=0A+=09if (!sb->s_root) {=0D=0A+=09=09pr_debug("%s: d_make_root=
() failed\n", __func__);=0D=0A+=09=09err =3D -ENOMEM;=0D=0A+=09=09goto de=
activate_out;=0D=0A+=09}=0D=0A+=0D=0A+=09sb->s_flags |=3D SB_ACTIVE;=0D=0A=
+=0D=0A+=09WARN_ON(fc->root);=0D=0A+=09fc->root =3D dget(sb->s_root);=0D=0A=
+=09return 0;=0D=0A+=0D=0A+deactivate_out:=0D=0A+=09pr_debug("%s: deactiv=
ating sb=3D%llx\n", __func__, (u64)sb);=0D=0A+=09deactivate_locked_super(=
sb);=0D=0A+=09return err;=0D=0A+}=0D=0A+=0D=0A+/*************************=
****************************************************/=0D=0A+=0D=0A+enum f=
amfs_param {=0D=0A+=09Opt_mode,=0D=0A+=09Opt_dax,=0D=0A+};=0D=0A+=0D=0A+c=
onst struct fs_parameter_spec famfs_fs_parameters[] =3D {=0D=0A+=09fspara=
m_u32oct("mode",=09  Opt_mode),=0D=0A+=09fsparam_string("dax",     Opt_da=
x),=0D=0A+=09{}=0D=0A+};=0D=0A+=0D=0A+static int=0D=0A+famfs_parse_param(=
struct fs_context *fc, struct fs_parameter *param)=0D=0A+{=0D=0A+=09struc=
t famfs_fs_info *fsi =3D fc->s_fs_info;=0D=0A+=09struct fs_parse_result r=
esult;=0D=0A+=09int opt;=0D=0A+=0D=0A+=09opt =3D fs_parse(fc, famfs_fs_pa=
rameters, param, &result);=0D=0A+=09if (opt =3D=3D -ENOPARAM) {=0D=0A+=09=
=09opt =3D vfs_parse_fs_param_source(fc, param);=0D=0A+=09=09if (opt !=3D=
 -ENOPARAM)=0D=0A+=09=09=09return opt;=0D=0A+=0D=0A+=09=09return -ENOPARA=
M;=0D=0A+=09}=0D=0A+=09if (opt < 0)=0D=0A+=09=09return opt;=0D=0A+=0D=0A+=
=09switch (opt) {=0D=0A+=09case Opt_mode:=0D=0A+=09=09fsi->mount_opts.mod=
e =3D result.uint_32 & S_IALLUGO;=0D=0A+=09=09break;=0D=0A+=09case Opt_da=
x:=0D=0A+=09=09if (strcmp(param->string, "always")) {=0D=0A+=09=09=09pr_d=
ebug("%s: invalid dax mode %s\n",=0D=0A+=09=09=09=09  __func__, param->st=
ring);=0D=0A+=09=09=09return -EINVAL;=0D=0A+=09=09}=0D=0A+=09=09break;=0D=
=0A+=09}=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static void=0D=0A=
+famfs_free_fc(struct fs_context *fc)=0D=0A+{=0D=0A+=09kfree(fc->s_fs_inf=
o);=0D=0A+}=0D=0A+=0D=0A+static const struct fs_context_operations famfs_=
context_ops =3D {=0D=0A+=09.free=09=09=3D famfs_free_fc,=0D=0A+=09.parse_=
param=09=3D famfs_parse_param,=0D=0A+=09.get_tree=09=3D famfs_get_tree,=0D=
=0A+};=0D=0A+=0D=0A+static int=0D=0A+famfs_init_fs_context(struct fs_cont=
ext *fc)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi;=0D=0A+=0D=0A+=09fsi =
=3D kzalloc_obj(*fsi, GFP_KERNEL);=0D=0A+=09if (!fsi)=0D=0A+=09=09return =
-ENOMEM;=0D=0A+=0D=0A+=09fsi->mount_opts.mode =3D FAMFS_DEFAULT_MODE;=0D=0A=
+=09fc->s_fs_info        =3D fsi;=0D=0A+=09fc->ops              =3D &famf=
s_context_ops;=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static void=0D=0A+=
famfs_kill_sb(struct super_block *sb)=0D=0A+{=0D=0A+=09struct famfs_fs_in=
fo *fsi =3D sb->s_fs_info;=0D=0A+=0D=0A+=09kill_char_super(sb);=0D=0A+=0D=
=0A+=09kfree(fsi);=0D=0A+=09sb->s_fs_info =3D NULL;=0D=0A+}=0D=0A+=0D=0A+=
#define MODULE_NAME "famfs"=0D=0A+static struct file_system_type famfs_fs=
_type =3D {=0D=0A+=09.owner=09=09  =3D THIS_MODULE,=0D=0A+=09.name=09=09 =
 =3D MODULE_NAME,=0D=0A+=09.init_fs_context  =3D famfs_init_fs_context,=0D=
=0A+=09.parameters=09  =3D famfs_fs_parameters,=0D=0A+=09.kill_sb=09  =3D=
 famfs_kill_sb,=0D=0A+=09.fs_flags=09  =3D FS_REQUIRES_DEV,=0D=0A+};=0D=0A=
+=0D=0A+/****************************************************************=
**************=0D=0A+ * Module stuff=0D=0A+ */=0D=0A+#define FAMFS_MODULE=
_INCOMPLETE 1=0D=0A+=0D=0A+static int __init=0D=0A+init_famfs_fs(void)=0D=
=0A+{=0D=0A+=09int rc;=0D=0A+=0D=0A+=09if (FAMFS_MODULE_INCOMPLETE)=0D=0A=
+=09=09return -ENODEV;=0D=0A+=0D=0A+=09rc =3D register_filesystem(&famfs_=
fs_type);=0D=0A+=0D=0A+=09return rc;=0D=0A+}=0D=0A+=0D=0A+static void __e=
xit=0D=0A+famfs_exit(void)=0D=0A+{=0D=0A+=09unregister_filesystem(&famfs_=
fs_type);=0D=0A+=09pr_info("%s: unregistered\n", __func__);=0D=0A+}=0D=0A=
+=0D=0A+fs_initcall(init_famfs_fs);=0D=0A+module_exit(famfs_exit);=0D=0A+=
=0D=0A+MODULE_AUTHOR("John Groves");=0D=0A+MODULE_DESCRIPTION("Fabric-Att=
ached Memory File System: see famfs.org");=0D=0A+MODULE_LICENSE("GPL");=0D=
=0Adiff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h=0D=0A=
new file mode 100644=0D=0Aindex 000000000000..378544b1aabe=0D=0A--- /dev/=
null=0D=0A+++ b/fs/famfs/famfs_internal.h=0D=0A@@ -0,0 +1,32 @@=0D=0A+/* =
SPDX-License-Identifier: GPL-2.0 */=0D=0A+/*=0D=0A+ * famfs - dax file sy=
stem for shared fabric-attached memory=0D=0A+ *=0D=0A+ * Copyright 2023-2=
024 Micron Technology, Inc.=0D=0A+ *=0D=0A+ * This file system, originall=
y based on ramfs the dax support from xfs,=0D=0A+ * is intended to allow =
multiple host systems to mount a common file system=0D=0A+ * view of dax =
files that map to shared memory.=0D=0A+ */=0D=0A+#ifndef FAMFS_INTERNAL_H=
=0D=0A+#define FAMFS_INTERNAL_H=0D=0A+=0D=0A+struct famfs_mount_opts {=0D=
=0A+=09umode_t mode;=0D=0A+};=0D=0A+=0D=0A+/**=0D=0A+ * @famfs_fs_info=0D=
=0A+ *=0D=0A+ * @mount_opts:  The mount options=0D=0A+ * @deverror:    Tr=
ue if the dax device has called our notify_failure entry=0D=0A+ *        =
       point, or if other "shutdown" conditions exist=0D=0A+ */=0D=0A+str=
uct famfs_fs_info {=0D=0A+=09struct famfs_mount_opts   mount_opts;=0D=0A+=
=09bool                      deverror;=0D=0A+};=0D=0A+=0D=0A+int famfs_lo=
okup_daxdev(const char *pathname, dev_t *devno);=0D=0A+=0D=0A+#endif /* F=
AMFS_INTERNAL_H */=0D=0Adiff --git a/fs/namei.c b/fs/namei.c=0D=0Aindex 1=
9ce43c9a6e6..d67194e89963 100644=0D=0A--- a/fs/namei.c=0D=0A+++ b/fs/name=
i.c=0D=0A@@ -4232,6 +4232,7 @@ bool may_open_dev(const struct path *path)=
=0D=0A =09return !(path->mnt->mnt_flags & MNT_NODEV) &&=0D=0A =09=09!(pat=
h->mnt->mnt_sb->s_iflags & SB_I_NODEV);=0D=0A }=0D=0A+EXPORT_SYMBOL(may_o=
pen_dev);=0D=0A=20=0D=0A static int may_open(struct mnt_idmap *idmap, con=
st struct path *path,=0D=0A =09=09    int acc_mode, int flag)=0D=0Adiff -=
-git a/fs/super.c b/fs/super.c=0D=0Aindex ffdcc6a2e0de..bcdfd3563aaa 1006=
44=0D=0A--- a/fs/super.c=0D=0A+++ b/fs/super.c=0D=0A@@ -1241,6 +1241,13 @=
@ void kill_anon_super(struct super_block *sb)=0D=0A }=0D=0A EXPORT_SYMBO=
L(kill_anon_super);=0D=0A=20=0D=0A+void kill_char_super(struct super_bloc=
k *sb)=0D=0A+{=0D=0A+=09generic_shutdown_super(sb);=0D=0A+=09kill_super_n=
otify(sb);=0D=0A+}=0D=0A+EXPORT_SYMBOL(kill_char_super);=0D=0A+=0D=0A int=
 set_anon_super_fc(struct super_block *sb, struct fs_context *fc)=0D=0A {=
=0D=0A =09return set_anon_super(sb, NULL);=0D=0Adiff --git a/include/linu=
x/fs.h b/include/linux/fs.h=0D=0Aindex 50ce731a2b78..a8b030d6f218 100644=0D=
=0A--- a/include/linux/fs.h=0D=0A+++ b/include/linux/fs.h=0D=0A@@ -2328,6=
 +2328,7 @@ void retire_super(struct super_block *sb);=0D=0A void generic=
_shutdown_super(struct super_block *sb);=0D=0A void kill_block_super(stru=
ct super_block *sb);=0D=0A void kill_anon_super(struct super_block *sb);=0D=
=0A+void kill_char_super(struct super_block *sb);=0D=0A void deactivate_s=
uper(struct super_block *sb);=0D=0A void deactivate_locked_super(struct s=
uper_block *sb);=0D=0A int set_anon_super(struct super_block *s, void *da=
ta);=0D=0Adiff --git a/include/uapi/linux/magic.h b/include/uapi/linux/ma=
gic.h=0D=0Aindex 4f2da935a76c..e644e1fd49bd 100644=0D=0A--- a/include/uap=
i/linux/magic.h=0D=0A+++ b/include/uapi/linux/magic.h=0D=0A@@ -38,6 +38,7=
 @@=0D=0A #define OVERLAYFS_SUPER_MAGIC=090x794c7630=0D=0A #define FUSE_S=
UPER_MAGIC=090x65735546=0D=0A #define BCACHEFS_SUPER_MAGIC=090xca451a4e=0D=
=0A+#define FAMFS_SUPER_MAGIC=090x87b282ff=0D=0A=20=0D=0A #define MINIX_S=
UPER_MAGIC=090x137F=09=09/* minix v1 fs, 14 char names */=0D=0A #define M=
INIX_SUPER_MAGIC2=090x138F=09=09/* minix v1 fs, 30 char names */=0D=0A--=20=
=0D=0A2.53.0=0D=0A=0D=0A
