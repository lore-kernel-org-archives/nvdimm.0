Received: from a11-70.smtp-out.amazonses.com (a11-70.smtp-out.amazonses.com [54.240.11.70])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1552F3C3D;
	Mon,  3 Aug 2026 02:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724119; cv=none; b=ZtspWsYe14ESvRspYaPNKRokJMqkmblajesqIrn7kGW5XUe+BEcErXtJqbcU1314OVvyHxkhHbspP7smU27fnHIKHUpOGpmM6th0vqVSfbk/bq2NhF2rrUJo6nxExPzsq08leyT9wZZJQWcm7ksF66/tLDrAOm93kDA+KSy/BYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724119; c=relaxed/simple;
	bh=EX98jXT+tmXzhcmTGs6aUXIdgRuxWLr5uct7vMxYELg=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=RS33JB8smF6mSH/mN2f1Hcbi2ktBJxkwOIe3AmataALL7+kDD9pf3gd80RiO6e6xfXhEDaw5gVkEZO/qxDSLzDxS4IOtPY8y0ZhkyomFDe9K1f7gAE8v8BG5WjYsF6h+Lmgc1dUD0GmIinqC+H/S+QA4s9Y0uVkWBf2RTlvVB2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=Tpxpve0R; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=nq4SbD1J; arc=none smtp.client-ip=54.240.11.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="Tpxpve0R";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="nq4SbD1J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1785724116;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=EX98jXT+tmXzhcmTGs6aUXIdgRuxWLr5uct7vMxYELg=;
	b=Tpxpve0Rly8hyz+kQrioXzZq/6OBe0fkI1/xq8B2KRdeh+NQCEgYLzK+8kEjVq2W
	f60Q7ELuo1iNdGNJes4FgnDpH2DvDjl0t7ZYf+Z5+NqPMQM4bU0w8kTKNsiXSb+Jal7
	M2VtIdupV0k0xJ5rbvB5/MSPaH/YYur5fDSwvhRg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1785724116;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=EX98jXT+tmXzhcmTGs6aUXIdgRuxWLr5uct7vMxYELg=;
	b=nq4SbD1JgfYQ/U9EWRMLXZQ6USaAN4QCOz6Fg+HovL/zpRfpRZuA2N5niEn73Et/
	S1kOjG9NWs5cqSdB7/vhJ7OQn3y5S71PZQUu6D/o/ZBX8vjM9c1JzDk1DfVruFc5lj5
	ms5Ss2l4CB0EucEOGOc0njesfvSNqXg1zm2vc7IQ=
Subject: [PATCH V12 02/12] famfs: Module operations, fs_context, and mount
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
Date: Mon, 3 Aug 2026 02:28:36 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
References: 
 <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com> 
 <20260803022828.75776-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdIu+ovgpm4enMRRGNw8yF9Kn6iwAACCbS
Thread-Topic: [PATCH V12 02/12] famfs: Module operations, fs_context, and
 mount
X-Wm-Sent-Timestamp: 1785724115
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.03-54.240.11.70

From: John Groves <john@groves.net>=0D=0A=0D=0AStart building up from the=
 famfs module operations. This commit=0D=0Aincludes the following:=0D=0A=0D=
=0A* Register as a file system=0D=0A* Parse mount parameters=0D=0A* Alloc=
ate or find (and initialize) a superblock via famfs_get_tree()=0D=0A* Loo=
kup the host dax device, and bail if it's in use (or not dax)=0D=0A* Add =
Kconfig and Makefile misc to build famfs=0D=0A* Add FAMFS_SUPER_MAGIC to =
include/uapi/linux/magic.h=0D=0A* Add export of fs/namei.c:may_open_dev()=
, which famfs needs to call=0D=0A* Update MAINTAINERS file for the fs/fam=
fs/ path=0D=0A=0D=0AThe following exports had to happen to enable famfs:=0D=
=0A=0D=0A* This adds the new fs/super.c:kill_char_super() - the other kil=
l*super=0D=0A  helpers were not quite right.=0D=0A=0D=0AThis commit build=
s but is otherwise too incomplete to run=0D=0A=0D=0ASigned-off-by: John G=
roves <john@groves.net>=0D=0A---=0D=0A MAINTAINERS                |   7 +=
=0D=0A fs/Kconfig                 |   2 +=0D=0A fs/Makefile              =
  |   1 +=0D=0A fs/famfs/Kconfig           |  11 ++=0D=0A fs/famfs/Makefi=
le          |   5 +=0D=0A fs/famfs/famfs_inode.c     | 293 ++++++++++++++=
+++++++++++++++++++++++=0D=0A fs/famfs/famfs_internal.h  |  32 ++++=0D=0A=
 fs/namei.c                 |   1 +=0D=0A fs/super.c                 |   =
7 +=0D=0A include/linux/fs.h         |   1 +=0D=0A include/uapi/linux/mag=
ic.h |   1 +=0D=0A 11 files changed, 361 insertions(+)=0D=0A create mode =
100644 fs/famfs/Kconfig=0D=0A create mode 100644 fs/famfs/Makefile=0D=0A =
create mode 100644 fs/famfs/famfs_inode.c=0D=0A create mode 100644 fs/fam=
fs/famfs_internal.h=0D=0A=0D=0Adiff --git a/MAINTAINERS b/MAINTAINERS=0D=0A=
index a674e36529f7..ca7b90a8f0a1 100644=0D=0A--- a/MAINTAINERS=0D=0A+++ b=
/MAINTAINERS=0D=0A@@ -9905,6 +9905,13 @@ F:=09Documentation/networking/fa=
ilover.rst=0D=0A F:=09include/net/failover.h=0D=0A F:=09net/core/failover=
=2Ec=0D=0A=20=0D=0A+FAMFS [Fabric-Attached Memory File System]=0D=0A+M:=09=
John Groves <John@Groves.net>=0D=0A+L:=09linux-fsdevel@vger.kernel.org=0D=
=0A+L:=09linux-cxl@vger.kernel.org=0D=0A+S:=09Supported=0D=0A+F:=09fs/fam=
fs/=0D=0A+=0D=0A FANOTIFY=0D=0A M:=09Jan Kara <jack@suse.cz>=0D=0A R:=09A=
mir Goldstein <amir73il@gmail.com>=0D=0Adiff --git a/fs/Kconfig b/fs/Kcon=
fig=0D=0Aindex cf6ae64776e6..2db647accc00 100644=0D=0A--- a/fs/Kconfig=0D=
=0A+++ b/fs/Kconfig=0D=0A@@ -131,6 +131,8 @@ source "fs/autofs/Kconfig"=0D=
=0A source "fs/fuse/Kconfig"=0D=0A source "fs/overlayfs/Kconfig"=0D=0A=20=
=0D=0A+source "fs/famfs/Kconfig"=0D=0A+=0D=0A menu "Caches"=0D=0A=20=0D=0A=
 source "fs/netfs/Kconfig"=0D=0Adiff --git a/fs/Makefile b/fs/Makefile=0D=
=0Aindex 89a8a9d207d1..f49f9a000210 100644=0D=0A--- a/fs/Makefile=0D=0A++=
+ b/fs/Makefile=0D=0A@@ -129,3 +129,4 @@ obj-$(CONFIG_VBOXSF_FS)=09=09+=3D=
 vboxsf/=0D=0A obj-$(CONFIG_ZONEFS_FS)=09=09+=3D zonefs/=0D=0A obj-$(CONF=
IG_BPF_LSM)=09=09+=3D bpf_fs_kfuncs.o=0D=0A obj-$(CONFIG_RESCTRL_FS)=09+=3D=
 resctrl/=0D=0A+obj-$(CONFIG_FAMFS)=09=09+=3D famfs/=0D=0Adiff --git a/fs=
/famfs/Kconfig b/fs/famfs/Kconfig=0D=0Anew file mode 100644=0D=0Aindex 00=
0000000000..ed40cf8b0592=0D=0A--- /dev/null=0D=0A+++ b/fs/famfs/Kconfig=0D=
=0A@@ -0,0 +1,11 @@=0D=0A+=0D=0A+=0D=0A+config FAMFS=0D=0A+       tristat=
e "famfs: shared memory file system"=0D=0A+       depends on DEV_DAX && F=
S_DAX && DEV_DAX_FSDEV=0D=0A+       default m if DEV_DAX && FS_DAX && DEV=
_DAX_FSDEV=0D=0A+       help=0D=0A+=09  Support for the famfs file system=
=2E Famfs is a dax file system that=0D=0A+=09  can support scale-out shar=
ed access to fabric-attached memory=0D=0A+=09  (e.g. CXL shared memory). =
Famfs is not a general purpose file system;=0D=0A+=09  it is an enabler f=
or data sets in shared memory.=0D=0Adiff --git a/fs/famfs/Makefile b/fs/f=
amfs/Makefile=0D=0Anew file mode 100644=0D=0Aindex 000000000000..62230bcd=
6793=0D=0A--- /dev/null=0D=0A+++ b/fs/famfs/Makefile=0D=0A@@ -0,0 +1,5 @@=
=0D=0A+# SPDX-License-Identifier: GPL-2.0=0D=0A+=0D=0A+obj-$(CONFIG_FAMFS=
) +=3D famfs.o=0D=0A+=0D=0A+famfs-y :=3D famfs_inode.o=0D=0Adiff --git a/=
fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c=0D=0Anew file mode 100644=
=0D=0Aindex 000000000000..c299a90912a5=0D=0A--- /dev/null=0D=0A+++ b/fs/f=
amfs/famfs_inode.c=0D=0A@@ -0,0 +1,293 @@=0D=0A+// SPDX-License-Identifie=
r: GPL-2.0=0D=0A+/*=0D=0A+ * famfs - dax file system for shared fabric-at=
tached memory=0D=0A+ *=0D=0A+ * Copyright 2023-2024 Micron Technology, in=
c=0D=0A+ *=0D=0A+ * This file system, originally based on ramfs the dax s=
upport from xfs,=0D=0A+ * is intended to allow multiple host systems to m=
ount a common file system=0D=0A+ * view of dax files that map to shared m=
emory.=0D=0A+ */=0D=0A+=0D=0A+#include <linux/fs.h>=0D=0A+#include <linux=
/cleanup.h>=0D=0A+#include <linux/time.h>=0D=0A+#include <linux/init.h>=0D=
=0A+#include <linux/string.h>=0D=0A+#include <linux/parser.h>=0D=0A+#incl=
ude <linux/magic.h>=0D=0A+#include <linux/slab.h>=0D=0A+#include <linux/f=
s_context.h>=0D=0A+#include <linux/fs_parser.h>=0D=0A+#include <linux/dax=
=2Eh>=0D=0A+#include <linux/hugetlb.h>=0D=0A+#include <linux/iomap.h>=0D=0A=
+#include <linux/path.h>=0D=0A+#include <linux/namei.h>=0D=0A+=0D=0A+#inc=
lude "famfs_internal.h"=0D=0A+=0D=0A+#define FAMFS_DEFAULT_MODE=090755=0D=
=0A+=0D=0A+static struct inode *famfs_get_inode(=0D=0A+=09=09=09struct su=
per_block *sb,=0D=0A+=09=09=09const struct inode *dir,=0D=0A+=09=09=09umo=
de_t mode, dev_t dev)=0D=0A+{=0D=0A+=09struct inode *inode =3D new_inode(=
sb);=0D=0A+=09struct timespec64 tv;=0D=0A+=0D=0A+=09if (!inode)=0D=0A+=09=
=09return NULL;=0D=0A+=0D=0A+=09inode->i_ino =3D get_next_ino();=0D=0A+=09=
inode_init_owner(&nop_mnt_idmap, inode, dir, mode);=0D=0A+=09inode->i_map=
ping->a_ops =3D &ram_aops;=0D=0A+=09mapping_set_gfp_mask(inode->i_mapping=
, GFP_HIGHUSER);=0D=0A+=09mapping_set_unevictable(inode->i_mapping);=0D=0A=
+=09tv =3D inode_set_ctime_current(inode);=0D=0A+=09inode_set_mtime_to_ts=
(inode, tv);=0D=0A+=09inode_set_atime_to_ts(inode, tv);=0D=0A+=0D=0A+=09s=
witch (mode & S_IFMT) {=0D=0A+=09default:=0D=0A+=09=09init_special_inode(=
inode, mode, dev);=0D=0A+=09=09break;=0D=0A+=09case S_IFREG:=0D=0A+=09=09=
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
=3D 1;=0D=0A+}=0D=0A+=0D=0A+int=0D=0A+lookup_daxdev(const char *pathname,=
 dev_t *devno)=0D=0A+{=0D=0A+=09struct inode *inode;=0D=0A+=09struct path=
 path;=0D=0A+=09int err;=0D=0A+=0D=0A+=09if (!pathname || !*pathname)=0D=0A=
+=09=09return -EINVAL;=0D=0A+=0D=0A+=09err =3D kern_path(pathname, LOOKUP=
_FOLLOW, &path);=0D=0A+=09if (err)=0D=0A+=09=09return err;=0D=0A+=0D=0A+=09=
inode =3D d_backing_inode(path.dentry);=0D=0A+=09if (!S_ISCHR(inode->i_mo=
de)) {=0D=0A+=09=09err =3D -EINVAL;=0D=0A+=09=09goto out_path_put;=0D=0A+=
=09}=0D=0A+=0D=0A+=09if (!may_open_dev(&path)) {=0D=0A+=09=09err =3D -EAC=
CES;=0D=0A+=09=09goto out_path_put;=0D=0A+=09}=0D=0A+=0D=0A+=09/* i_rdev =
is the char dev_t; fs_dax_get() confirms it is dax later */=0D=0A+=09*dev=
no =3D inode->i_rdev;=0D=0A+=0D=0A+out_path_put:=0D=0A+=09path_put(&path)=
;=0D=0A+=09return err;=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+famfs_get_tr=
ee(struct fs_context *fc)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D =
fc->s_fs_info;=0D=0A+=09struct super_block *sb;=0D=0A+=09struct inode *in=
ode;=0D=0A+=09dev_t daxdevno;=0D=0A+=09int err;=0D=0A+=0D=0A+=09err =3D l=
ookup_daxdev(fc->source, &daxdevno);=0D=0A+=09if (err)=0D=0A+=09=09return=
 err;=0D=0A+=0D=0A+=09/* This will set sb->s_dev=3Ddaxdevno */=0D=0A+=09s=
b =3D sget_dev(fc, daxdevno);=0D=0A+=09if (IS_ERR(sb)) {=0D=0A+=09=09pr_d=
ebug("%s: sget_dev error\n", __func__);=0D=0A+=09=09return PTR_ERR(sb);=0D=
=0A+=09}=0D=0A+=0D=0A+=09if (sb->s_root) {=0D=0A+=09=09pr_debug("%s: foun=
d a matching superblock for %s\n",=0D=0A+=09=09=09__func__, fc->source);=0D=
=0A+=0D=0A+=09=09/* We don't expect to find a match by dev_t; if we do, i=
t must=0D=0A+=09=09 * already be mounted, so we bail=0D=0A+=09=09 */=0D=0A=
+=09=09err =3D -EBUSY;=0D=0A+=09=09goto deactivate_out;=0D=0A+=09} else {=
=0D=0A+=09=09pr_debug("%s: initializing new superblock for %s\n",=0D=0A+=09=
=09=09__func__, fc->source);=0D=0A+=09=09famfs_fill_super(sb, fc);=0D=0A+=
=09}=0D=0A+=0D=0A+=09inode =3D famfs_get_inode(sb, NULL, S_IFDIR | fsi->m=
ount_opts.mode, 0);=0D=0A+=09sb->s_root =3D d_make_root(inode);=0D=0A+=09=
if (!sb->s_root) {=0D=0A+=09=09pr_debug("%s: d_make_root() failed\n", __f=
unc__);=0D=0A+=09=09err =3D -ENOMEM;=0D=0A+=09=09goto deactivate_out;=0D=0A=
+=09}=0D=0A+=0D=0A+=09sb->s_flags |=3D SB_ACTIVE;=0D=0A+=0D=0A+=09WARN_ON=
(fc->root);=0D=0A+=09fc->root =3D dget(sb->s_root);=0D=0A+=09return 0;=0D=
=0A+=0D=0A+deactivate_out:=0D=0A+=09pr_debug("%s: deactivating sb=3D%llx\=
n", __func__, (u64)sb);=0D=0A+=09deactivate_locked_super(sb);=0D=0A+=09re=
turn err;=0D=0A+}=0D=0A+=0D=0A+/*****************************************=
************************************/=0D=0A+=0D=0A+enum famfs_param {=0D=0A=
+=09Opt_mode,=0D=0A+=09Opt_dax,=0D=0A+};=0D=0A+=0D=0A+const struct fs_par=
ameter_spec famfs_fs_parameters[] =3D {=0D=0A+=09fsparam_u32oct("mode",=09=
  Opt_mode),=0D=0A+=09fsparam_string("dax",     Opt_dax),=0D=0A+=09{}=0D=0A=
+};=0D=0A+=0D=0A+static int famfs_parse_param(struct fs_context *fc, stru=
ct fs_parameter *param)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D fc=
->s_fs_info;=0D=0A+=09struct fs_parse_result result;=0D=0A+=09int opt;=0D=
=0A+=0D=0A+=09opt =3D fs_parse(fc, famfs_fs_parameters, param, &result);=0D=
=0A+=09if (opt =3D=3D -ENOPARAM) {=0D=0A+=09=09opt =3D vfs_parse_fs_param=
_source(fc, param);=0D=0A+=09=09if (opt !=3D -ENOPARAM)=0D=0A+=09=09=09re=
turn opt;=0D=0A+=0D=0A+=09=09return 0;=0D=0A+=09}=0D=0A+=09if (opt < 0)=0D=
=0A+=09=09return opt;=0D=0A+=0D=0A+=09switch (opt) {=0D=0A+=09case Opt_mo=
de:=0D=0A+=09=09fsi->mount_opts.mode =3D result.uint_32 & S_IALLUGO;=0D=0A=
+=09=09break;=0D=0A+=09case Opt_dax:=0D=0A+=09=09if (strcmp(param->string=
, "always"))=0D=0A+=09=09=09pr_debug("%s: invalid dax mode %s\n",=0D=0A+=09=
=09=09=09  __func__, param->string);=0D=0A+=09=09break;=0D=0A+=09}=0D=0A+=
=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static void famfs_free_fc(struct=
 fs_context *fc)=0D=0A+{=0D=0A+=09kfree(fc->s_fs_info);=0D=0A+}=0D=0A+=0D=
=0A+static const struct fs_context_operations famfs_context_ops =3D {=0D=0A=
+=09.free=09=09=3D famfs_free_fc,=0D=0A+=09.parse_param=09=3D famfs_parse=
_param,=0D=0A+=09.get_tree=09=3D famfs_get_tree,=0D=0A+};=0D=0A+=0D=0A+st=
atic int famfs_init_fs_context(struct fs_context *fc)=0D=0A+{=0D=0A+=09st=
ruct famfs_fs_info *fsi;=0D=0A+=0D=0A+=09fsi =3D kzalloc_obj(*fsi, GFP_KE=
RNEL);=0D=0A+=09if (!fsi)=0D=0A+=09=09return -ENOMEM;=0D=0A+=0D=0A+=09fsi=
->mount_opts.mode =3D FAMFS_DEFAULT_MODE;=0D=0A+=09fc->s_fs_info        =3D=
 fsi;=0D=0A+=09fc->ops              =3D &famfs_context_ops;=0D=0A+=09retu=
rn 0;=0D=0A+}=0D=0A+=0D=0A+static void famfs_kill_sb(struct super_block *=
sb)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D sb->s_fs_info;=0D=0A+=0D=
=0A+=09kill_char_super(sb);=0D=0A+=0D=0A+=09kfree(fsi);=0D=0A+=09sb->s_fs=
_info =3D NULL;=0D=0A+}=0D=0A+=0D=0A+#define MODULE_NAME "famfs"=0D=0A+st=
atic struct file_system_type famfs_fs_type =3D {=0D=0A+=09.name=09=09  =3D=
 MODULE_NAME,=0D=0A+=09.init_fs_context  =3D famfs_init_fs_context,=0D=0A=
+=09.parameters=09  =3D famfs_fs_parameters,=0D=0A+=09.kill_sb=09  =3D fa=
mfs_kill_sb,=0D=0A+=09.fs_flags=09  =3D FS_REQUIRES_DEV,=0D=0A+};=0D=0A+=0D=
=0A+/********************************************************************=
**********=0D=0A+ * Module stuff=0D=0A+ */=0D=0A+static int __init init_f=
amfs_fs(void)=0D=0A+{=0D=0A+=09int rc;=0D=0A+=0D=0A+=09rc =3D register_fi=
lesystem(&famfs_fs_type);=0D=0A+=0D=0A+=09return rc;=0D=0A+}=0D=0A+=0D=0A=
+static void=0D=0A+__exit famfs_exit(void)=0D=0A+{=0D=0A+=09unregister_fi=
lesystem(&famfs_fs_type);=0D=0A+=09pr_info("%s: unregistered\n", __func__=
);=0D=0A+}=0D=0A+=0D=0A+fs_initcall(init_famfs_fs);=0D=0A+module_exit(fam=
fs_exit);=0D=0A+=0D=0A+MODULE_AUTHOR("John Groves");=0D=0A+MODULE_DESCRIP=
TION("Fabric-Attached Memory File System: see famfs.org");=0D=0A+MODULE_L=
ICENSE("GPL");=0D=0Adiff --git a/fs/famfs/famfs_internal.h b/fs/famfs/fam=
fs_internal.h=0D=0Anew file mode 100644=0D=0Aindex 000000000000..6f481d79=
ed88=0D=0A--- /dev/null=0D=0A+++ b/fs/famfs/famfs_internal.h=0D=0A@@ -0,0=
 +1,32 @@=0D=0A+/* SPDX-License-Identifier: GPL-2.0 */=0D=0A+/*=0D=0A+ * =
famfs - dax file system for shared fabric-attached memory=0D=0A+ *=0D=0A+=
 * Copyright 2023-2024 Micron Technology, Inc.=0D=0A+ *=0D=0A+ * This fil=
e system, originally based on ramfs the dax support from xfs,=0D=0A+ * is=
 intended to allow multiple host systems to mount a common file system=0D=
=0A+ * view of dax files that map to shared memory.=0D=0A+ */=0D=0A+#ifnd=
ef FAMFS_INTERNAL_H=0D=0A+#define FAMFS_INTERNAL_H=0D=0A+=0D=0A+struct fa=
mfs_mount_opts {=0D=0A+=09umode_t mode;=0D=0A+};=0D=0A+=0D=0A+/**=0D=0A+ =
* @famfs_fs_info=0D=0A+ *=0D=0A+ * @mount_opts:  The mount options=0D=0A+=
 * @deverror:    True if the dax device has called our notify_failure ent=
ry=0D=0A+ *               point, or if other "shutdown" conditions exist=0D=
=0A+ */=0D=0A+struct famfs_fs_info {=0D=0A+=09struct famfs_mount_opts   m=
ount_opts;=0D=0A+=09bool                      deverror;=0D=0A+};=0D=0A+=0D=
=0A+int lookup_daxdev(const char *pathname, dev_t *devno);=0D=0A+=0D=0A+#=
endif /* FAMFS_INTERNAL_H */=0D=0Adiff --git a/fs/namei.c b/fs/namei.c=0D=
=0Aindex 19ce43c9a6e6..d67194e89963 100644=0D=0A--- a/fs/namei.c=0D=0A+++=
 b/fs/namei.c=0D=0A@@ -4232,6 +4232,7 @@ bool may_open_dev(const struct p=
ath *path)=0D=0A =09return !(path->mnt->mnt_flags & MNT_NODEV) &&=0D=0A =09=
=09!(path->mnt->mnt_sb->s_iflags & SB_I_NODEV);=0D=0A }=0D=0A+EXPORT_SYMB=
OL(may_open_dev);=0D=0A=20=0D=0A static int may_open(struct mnt_idmap *id=
map, const struct path *path,=0D=0A =09=09    int acc_mode, int flag)=0D=0A=
diff --git a/fs/super.c b/fs/super.c=0D=0Aindex a8fd61136aaf..822ed205d07=
b 100644=0D=0A--- a/fs/super.c=0D=0A+++ b/fs/super.c=0D=0A@@ -1235,6 +123=
5,13 @@ void kill_anon_super(struct super_block *sb)=0D=0A }=0D=0A EXPORT=
_SYMBOL(kill_anon_super);=0D=0A=20=0D=0A+void kill_char_super(struct supe=
r_block *sb)=0D=0A+{=0D=0A+=09generic_shutdown_super(sb);=0D=0A+=09kill_s=
uper_notify(sb);=0D=0A+}=0D=0A+EXPORT_SYMBOL(kill_char_super);=0D=0A+=0D=0A=
 int set_anon_super_fc(struct super_block *sb, struct fs_context *fc)=0D=0A=
 {=0D=0A =09return set_anon_super(sb, NULL);=0D=0Adiff --git a/include/li=
nux/fs.h b/include/linux/fs.h=0D=0Aindex 50ce731a2b78..a8b030d6f218 10064=
4=0D=0A--- a/include/linux/fs.h=0D=0A+++ b/include/linux/fs.h=0D=0A@@ -23=
28,6 +2328,7 @@ void retire_super(struct super_block *sb);=0D=0A void gen=
eric_shutdown_super(struct super_block *sb);=0D=0A void kill_block_super(=
struct super_block *sb);=0D=0A void kill_anon_super(struct super_block *s=
b);=0D=0A+void kill_char_super(struct super_block *sb);=0D=0A void deacti=
vate_super(struct super_block *sb);=0D=0A void deactivate_locked_super(st=
ruct super_block *sb);=0D=0A int set_anon_super(struct super_block *s, vo=
id *data);=0D=0Adiff --git a/include/uapi/linux/magic.h b/include/uapi/li=
nux/magic.h=0D=0Aindex 4f2da935a76c..e644e1fd49bd 100644=0D=0A--- a/inclu=
de/uapi/linux/magic.h=0D=0A+++ b/include/uapi/linux/magic.h=0D=0A@@ -38,6=
 +38,7 @@=0D=0A #define OVERLAYFS_SUPER_MAGIC=090x794c7630=0D=0A #define =
FUSE_SUPER_MAGIC=090x65735546=0D=0A #define BCACHEFS_SUPER_MAGIC=090xca45=
1a4e=0D=0A+#define FAMFS_SUPER_MAGIC=090x87b282ff=0D=0A=20=0D=0A #define =
MINIX_SUPER_MAGIC=090x137F=09=09/* minix v1 fs, 14 char names */=0D=0A #d=
efine MINIX_SUPER_MAGIC2=090x138F=09=09/* minix v1 fs, 30 char names */=0D=
=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
