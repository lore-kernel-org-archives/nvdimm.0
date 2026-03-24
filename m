Received: from a11-4.smtp-out.amazonses.com (a11-4.smtp-out.amazonses.com [54.240.11.4])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDBD336EC0
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312860; cv=none; b=JfEdO59uu/xKWKnZL/JcP3wULL14OqjVvab55qPCbKQmys1t3NxtziJcNvbJkFbUyRgKrTf/OW7uRWE/zXpe9FZ1JsY4/A6NvSabzGZh0Rh4I6+v2ON0Rk5Kd/H+1g49h5AQwG3PLK6m+cWsWJQecYtcMwGvWJ5VYqbLqFQ67P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312860; c=relaxed/simple;
	bh=6vaOfHejNkJnZ/4/z5f8XW9WnlvSfrDUMMFDPip0kfw=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=dZYp6y1M9ivQ4C2Nec6aWuNhksoQzgAzRoCXVJSD4KNEXilNktzDOBSanJ0tQH42smXOs5I3/fj/1EaJL7UeTSLHhAVrJ/jLn0C0aXnT+XMtKRqKJYO93vFYX513n4ADwb8hNv2gz/Wa5VhtbqhBLXQj2YQt07RZsys8SM9GAws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=Xc+RC58+; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=j4ILJgUs; arc=none smtp.client-ip=54.240.11.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="Xc+RC58+";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="j4ILJgUs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312857;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=6vaOfHejNkJnZ/4/z5f8XW9WnlvSfrDUMMFDPip0kfw=;
	b=Xc+RC58+vrKg7+uKkAIV5kgcPaaQrgvTZ0gq/jQ8oT5mW9r1ey8NrNyLAj+lK0RV
	R1E1W/lQti13n5YTQ9epwXw3L0MXglsR7+AsqPkjIMC5DA8t8fzLZvdSiJqJQjrTN4M
	X2JOwIDFoQAOZPu/x2yrJTfIfn04Tu5uAw1+cmvI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312857;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=6vaOfHejNkJnZ/4/z5f8XW9WnlvSfrDUMMFDPip0kfw=;
	b=j4ILJgUszmS2m5jjhvStr5mpUNHBnQuu1WxFVPGUjQQ4Vuf4fl0gH9nCVcgT48UP
	2g4vSi53MHiFxfVgWDvmKnclQ+cZuDYYPnXK38PtxM9xlPaLT/OdxxIpJAVOnviu6EI
	d8crkKXI8sHIcIDBQc4q+muK2m1RO2/4ak4+FZ3I=
Subject: [PATCH V9 03/10] famfs_fuse: Plumb the GET_FMAP message/response
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
Date: Tue, 24 Mar 2026 00:40:57 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d1d48b7e8-4468329f-b446-43f1-87db-3c7e1ff6f28b-000000@email.amazonses.com>
References: 
 <0100019d1d48b7e8-4468329f-b446-43f1-87db-3c7e1ff6f28b-000000@email.amazonses.com> 
 <20260324004049.5205-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuybgx3wHFgMiQOK2IYDYCbWokQ==
Thread-Topic: [PATCH V9 03/10] famfs_fuse: Plumb the GET_FMAP message/response
X-Wm-Sent-Timestamp: 1774312856
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d499f55-8614dc64-8a4d-432f-a31e-1aa8b91ff8c3-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.11.4

From: John Groves <john@groves.net>=0D=0A=0D=0AUpon completion of an OPEN=
, if we're in famfs-mode we do a GET_FMAP to=0D=0Aretrieve and cache up t=
he file-to-dax map in the kernel. If this=0D=0Asucceeds, read/write/mmap =
are resolved direct-to-dax with no upcalls.=0D=0A=0D=0ASigned-off-by: Joh=
n Groves <john@groves.net>=0D=0A---=0D=0A MAINTAINERS               |  8 =
+++++=0D=0A fs/fuse/Makefile          |  1 +=0D=0A fs/fuse/famfs.c       =
    | 73 +++++++++++++++++++++++++++++++++++++++=0D=0A fs/fuse/file.c    =
        | 14 +++++++-=0D=0A fs/fuse/fuse_i.h          | 70 ++++++++++++++=
++++++++++++++++++++---=0D=0A fs/fuse/inode.c           |  8 ++++-=0D=0A =
fs/fuse/iomode.c          |  2 +-=0D=0A include/uapi/linux/fuse.h |  7 ++=
++=0D=0A 8 files changed, 175 insertions(+), 8 deletions(-)=0D=0A create =
mode 100644 fs/fuse/famfs.c=0D=0A=0D=0Adiff --git a/MAINTAINERS b/MAINTAI=
NERS=0D=0Aindex eedf4cce56ed..71040a6494a3 100644=0D=0A--- a/MAINTAINERS=0D=
=0A+++ b/MAINTAINERS=0D=0A@@ -10512,6 +10512,14 @@ F:=09fs/fuse/=0D=0A F:=
=09include/uapi/linux/fuse.h=0D=0A F:=09tools/testing/selftests/filesyste=
ms/fuse/=0D=0A=20=0D=0A+FUSE [FAMFS Fabric-Attached Memory File System]=0D=
=0A+M:=09John Groves <jgroves@micron.com>=0D=0A+M:=09John Groves <John@Gr=
oves.net>=0D=0A+L:=09linux-cxl@vger.kernel.org=0D=0A+L:=09linux-fsdevel@v=
ger.kernel.org=0D=0A+S:=09Supported=0D=0A+F:=09fs/fuse/famfs.c=0D=0A+=0D=0A=
 FUTEX SUBSYSTEM=0D=0A M:=09Thomas Gleixner <tglx@kernel.org>=0D=0A M:=09=
Ingo Molnar <mingo@redhat.com>=0D=0Adiff --git a/fs/fuse/Makefile b/fs/fu=
se/Makefile=0D=0Aindex 22ad9538dfc4..3f8dcc8cbbd0 100644=0D=0A--- a/fs/fu=
se/Makefile=0D=0A+++ b/fs/fuse/Makefile=0D=0A@@ -17,5 +17,6 @@ fuse-$(CON=
FIG_FUSE_DAX) +=3D dax.o=0D=0A fuse-$(CONFIG_FUSE_PASSTHROUGH) +=3D passt=
hrough.o backing.o=0D=0A fuse-$(CONFIG_SYSCTL) +=3D sysctl.o=0D=0A fuse-$=
(CONFIG_FUSE_IO_URING) +=3D dev_uring.o=0D=0A+fuse-$(CONFIG_FUSE_FAMFS_DA=
X) +=3D famfs.o=0D=0A=20=0D=0A virtiofs-y :=3D virtio_fs.o=0D=0Adiff --gi=
t a/fs/fuse/famfs.c b/fs/fuse/famfs.c=0D=0Anew file mode 100644=0D=0Ainde=
x 000000000000..d238d853afa8=0D=0A--- /dev/null=0D=0A+++ b/fs/fuse/famfs.=
c=0D=0A@@ -0,0 +1,73 @@=0D=0A+// SPDX-License-Identifier: GPL-2.0=0D=0A+/=
*=0D=0A+ * famfs - dax file system for shared fabric-attached memory=0D=0A=
+ *=0D=0A+ * Copyright 2023-2026 Micron Technology, Inc.=0D=0A+ *=0D=0A+ =
* This file system, originally based on ramfs the dax support from xfs,=0D=
=0A+ * is intended to allow multiple host systems to mount a common file =
system=0D=0A+ * view of dax files that map to shared memory.=0D=0A+ */=0D=
=0A+=0D=0A+#include <linux/cleanup.h>=0D=0A+#include <linux/fs.h>=0D=0A+#=
include <linux/mm.h>=0D=0A+#include <linux/dax.h>=0D=0A+#include <linux/i=
omap.h>=0D=0A+#include <linux/path.h>=0D=0A+#include <linux/namei.h>=0D=0A=
+#include <linux/string.h>=0D=0A+=0D=0A+#include "fuse_i.h"=0D=0A+=0D=0A+=
=0D=0A+#define FMAP_BUFSIZE PAGE_SIZE=0D=0A+=0D=0A+int fuse_get_fmap(stru=
ct fuse_mount *fm, struct inode *inode)=0D=0A+{=0D=0A+=09struct fuse_inod=
e *fi =3D get_fuse_inode(inode);=0D=0A+=09size_t fmap_bufsize =3D FMAP_BU=
FSIZE;=0D=0A+=09u64 nodeid =3D get_node_id(inode);=0D=0A+=09ssize_t fmap_=
size;=0D=0A+=09int rc;=0D=0A+=0D=0A+=09FUSE_ARGS(args);=0D=0A+=0D=0A+=09/=
* Don't retrieve if we already have the famfs metadata */=0D=0A+=09if (fi=
->famfs_meta)=0D=0A+=09=09return 0;=0D=0A+=0D=0A+=09void *fmap_buf __free=
(kfree) =3D kzalloc(FMAP_BUFSIZE, GFP_KERNEL);=0D=0A+=0D=0A+=09if (!fmap_=
buf)=0D=0A+=09=09return -ENOMEM;=0D=0A+=0D=0A+=09args.opcode =3D FUSE_GET=
_FMAP;=0D=0A+=09args.nodeid =3D nodeid;=0D=0A+=0D=0A+=09/* Variable-sized=
 output buffer=0D=0A+=09 * this causes fuse_simple_request() to return th=
e size of the=0D=0A+=09 * output payload=0D=0A+=09 */=0D=0A+=09args.out_a=
rgvar =3D true;=0D=0A+=09args.out_numargs =3D 1;=0D=0A+=09args.out_args[0=
].size =3D fmap_bufsize;=0D=0A+=09args.out_args[0].value =3D fmap_buf;=0D=
=0A+=0D=0A+=09/* Send GET_FMAP command */=0D=0A+=09rc =3D fuse_simple_req=
uest(fm, &args);=0D=0A+=09if (rc < 0) {=0D=0A+=09=09pr_err("%s: err=3D%d =
from fuse_simple_request()\n",=0D=0A+=09=09       __func__, rc);=0D=0A+=09=
=09return rc;=0D=0A+=09}=0D=0A+=09fmap_size =3D rc;=0D=0A+=0D=0A+=09/* We=
 retrieved the "fmap" (the file's map to memory), but=0D=0A+=09 * we have=
n't used it yet. A call to famfs_file_init_dax() will be added=0D=0A+=09 =
* here in a subsequent patch, when we add the ability to attach=0D=0A+=09=
 * fmaps to files.=0D=0A+=09 */=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0Adi=
ff --git a/fs/fuse/file.c b/fs/fuse/file.c=0D=0Aindex 4ee5065737d8..d7fd9=
34f4412 100644=0D=0A--- a/fs/fuse/file.c=0D=0A+++ b/fs/fuse/file.c=0D=0A@=
@ -277,6 +277,16 @@ static int fuse_open(struct inode *inode, struct file=
 *file)=0D=0A =09err =3D fuse_do_open(fm, get_node_id(inode), file, false=
);=0D=0A =09if (!err) {=0D=0A =09=09ff =3D file->private_data;=0D=0A+=0D=0A=
+=09=09if ((fm->fc->famfs_iomap) && (S_ISREG(inode->i_mode))) {=0D=0A+=09=
=09=09/* Get the famfs fmap - failure is fatal */=0D=0A+=09=09=09err =3D =
fuse_get_fmap(fm, inode);=0D=0A+=09=09=09if (err) {=0D=0A+=09=09=09=09fus=
e_sync_release(fi, ff, file->f_flags);=0D=0A+=09=09=09=09goto out_nowrite=
;=0D=0A+=09=09=09}=0D=0A+=09=09}=0D=0A+=0D=0A =09=09err =3D fuse_finish_o=
pen(inode, file);=0D=0A =09=09if (err)=0D=0A =09=09=09fuse_sync_release(f=
i, ff, file->f_flags);=0D=0A@@ -284,12 +294,14 @@ static int fuse_open(st=
ruct inode *inode, struct file *file)=0D=0A =09=09=09fuse_truncate_update=
_attr(inode, file);=0D=0A =09}=0D=0A=20=0D=0A+out_nowrite:=0D=0A =09if (i=
s_wb_truncate || dax_truncate)=0D=0A =09=09fuse_release_nowrite(inode);=0D=
=0A =09if (!err) {=0D=0A =09=09if (is_truncate)=0D=0A =09=09=09truncate_p=
agecache(inode, 0);=0D=0A-=09=09else if (!(ff->open_flags & FOPEN_KEEP_CA=
CHE))=0D=0A+=09=09else if (!(ff->open_flags & FOPEN_KEEP_CACHE) &&=0D=0A+=
=09=09=09 !fuse_file_famfs(fi))=0D=0A =09=09=09invalidate_inode_pages2(in=
ode->i_mapping);=0D=0A =09}=0D=0A =09if (dax_truncate)=0D=0Adiff --git a/=
fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h=0D=0Aindex 2839efb219a9..b66b5ca0bc11=
 100644=0D=0A--- a/fs/fuse/fuse_i.h=0D=0A+++ b/fs/fuse/fuse_i.h=0D=0A@@ -=
223,6 +223,14 @@ struct fuse_inode {=0D=0A =09 * so preserve the blocksiz=
e specified by the server.=0D=0A =09 */=0D=0A =09u8 cached_i_blkbits;=0D=0A=
+=0D=0A+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)=0D=0A+=09/* Pointer to the =
file's famfs metadata. Primary content is the=0D=0A+=09 * in-memory versi=
on of the fmap - the map from file's offset range=0D=0A+=09 * to DAX memo=
ry=0D=0A+=09 */=0D=0A+=09void *famfs_meta;=0D=0A+#endif=0D=0A };=0D=0A=20=
=0D=0A /** FUSE inode state bits */=0D=0A@@ -1511,11 +1519,8 @@ void fuse=
_free_conn(struct fuse_conn *fc);=0D=0A=20=0D=0A /* dax.c */=0D=0A=20=0D=0A=
-static inline bool fuse_file_famfs(struct fuse_inode *fuse_inode) /* Wil=
l be superseded */=0D=0A-{=0D=0A-=09(void)fuse_inode;=0D=0A-=09return fal=
se;=0D=0A-}=0D=0A+static inline int fuse_file_famfs(struct fuse_inode *fi=
); /* forward */=0D=0A+=0D=0A #define FUSE_IS_VIRTIO_DAX(fuse_inode) (IS_=
ENABLED(CONFIG_FUSE_DAX)=09\=0D=0A =09=09=09=09=09&& IS_DAX(&fuse_inode->=
inode)  \=0D=0A =09=09=09=09=09&& !fuse_file_famfs(fuse_inode))=0D=0A@@ -=
1634,4 +1639,59 @@ extern void fuse_sysctl_unregister(void);=0D=0A #defin=
e fuse_sysctl_unregister()=09do { } while (0)=0D=0A #endif /* CONFIG_SYSC=
TL */=0D=0A=20=0D=0A+/* famfs.c */=0D=0A+=0D=0A+#if IS_ENABLED(CONFIG_FUS=
E_FAMFS_DAX)=0D=0A+void __famfs_meta_free(void *map);=0D=0A+=0D=0A+/* Set=
 fi->famfs_meta =3D NULL regardless of prior value */=0D=0A+static inline=
 void famfs_meta_init(struct fuse_inode *fi)=0D=0A+{=0D=0A+=09fi->famfs_m=
eta =3D NULL;=0D=0A+}=0D=0A+=0D=0A+/* Set fi->famfs_meta iff the current =
value is NULL */=0D=0A+static inline struct fuse_backing *famfs_meta_set(=
struct fuse_inode *fi,=0D=0A+=09=09=09=09=09=09  void *meta)=0D=0A+{=0D=0A=
+=09return cmpxchg(&fi->famfs_meta, NULL, meta);=0D=0A+}=0D=0A+=0D=0A+sta=
tic inline void famfs_meta_free(struct fuse_inode *fi)=0D=0A+{=0D=0A+=09f=
amfs_meta_set(fi, NULL);=0D=0A+}=0D=0A+=0D=0A+static inline int fuse_file=
_famfs(struct fuse_inode *fi)=0D=0A+{=0D=0A+=09return (READ_ONCE(fi->famf=
s_meta) !=3D NULL);=0D=0A+}=0D=0A+=0D=0A+int fuse_get_fmap(struct fuse_mo=
unt *fm, struct inode *inode);=0D=0A+=0D=0A+#else /* !CONFIG_FUSE_FAMFS_D=
AX */=0D=0A+=0D=0A+static inline struct fuse_backing *famfs_meta_set(stru=
ct fuse_inode *fi,=0D=0A+=09=09=09=09=09=09  void *meta)=0D=0A+{=0D=0A+=09=
return NULL;=0D=0A+}=0D=0A+=0D=0A+static inline void famfs_meta_free(stru=
ct fuse_inode *fi)=0D=0A+{=0D=0A+}=0D=0A+=0D=0A+static inline int fuse_fi=
le_famfs(struct fuse_inode *fi)=0D=0A+{=0D=0A+=09return 0;=0D=0A+}=0D=0A+=
=0D=0A+static inline int=0D=0A+fuse_get_fmap(struct fuse_mount *fm, struc=
t inode *inode)=0D=0A+{=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+#endif /*=
 CONFIG_FUSE_FAMFS_DAX */=0D=0A+=0D=0A #endif /* _FS_FUSE_I_H */=0D=0Adif=
f --git a/fs/fuse/inode.c b/fs/fuse/inode.c=0D=0Aindex fa77add7d9f8..e39a=
00c79085 100644=0D=0A--- a/fs/fuse/inode.c=0D=0A+++ b/fs/fuse/inode.c=0D=0A=
@@ -120,6 +120,9 @@ static struct inode *fuse_alloc_inode(struct super_bl=
ock *sb)=0D=0A =09if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))=0D=0A =09=09fu=
se_inode_backing_set(fi, NULL);=0D=0A=20=0D=0A+=09if (IS_ENABLED(CONFIG_F=
USE_FAMFS_DAX))=0D=0A+=09=09famfs_meta_set(fi, NULL);=0D=0A+=0D=0A =09ret=
urn &fi->inode;=0D=0A=20=0D=0A out_free_forget:=0D=0A@@ -141,6 +144,9 @@ =
static void fuse_free_inode(struct inode *inode)=0D=0A =09if (IS_ENABLED(=
CONFIG_FUSE_PASSTHROUGH))=0D=0A =09=09fuse_backing_put(fuse_inode_backing=
(fi));=0D=0A=20=0D=0A+=09if (S_ISREG(inode->i_mode) && fuse_file_famfs(fi=
))=0D=0A+=09=09famfs_meta_free(fi);=0D=0A+=0D=0A =09kmem_cache_free(fuse_=
inode_cachep, fi);=0D=0A }=0D=0A=20=0D=0A@@ -162,7 +168,7 @@ static void =
fuse_evict_inode(struct inode *inode)=0D=0A =09/* Will write inode on clo=
se/munmap and in all other dirtiers */=0D=0A =09WARN_ON(inode_state_read_=
once(inode) & I_DIRTY_INODE);=0D=0A=20=0D=0A-=09if (FUSE_IS_VIRTIO_DAX(fi=
))=0D=0A+=09if (FUSE_IS_VIRTIO_DAX(fi) || fuse_file_famfs(fi))=0D=0A =09=09=
dax_break_layout_final(inode);=0D=0A=20=0D=0A =09truncate_inode_pages_fin=
al(&inode->i_data);=0D=0Adiff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c=
=0D=0Aindex 31ee7f3304c6..948148316ef0 100644=0D=0A--- a/fs/fuse/iomode.c=
=0D=0A+++ b/fs/fuse/iomode.c=0D=0A@@ -203,7 +203,7 @@ int fuse_file_io_op=
en(struct file *file, struct inode *inode)=0D=0A =09 * io modes are not r=
elevant with DAX and with server that does not=0D=0A =09 * implement open=
=2E=0D=0A =09 */=0D=0A-=09if (FUSE_IS_VIRTIO_DAX(fi) || !ff->args)=0D=0A+=
=09if (FUSE_IS_VIRTIO_DAX(fi) || fuse_file_famfs(fi) || !ff->args)=0D=0A =
=09=09return 0;=0D=0A=20=0D=0A =09/*=0D=0Adiff --git a/include/uapi/linux=
/fuse.h b/include/uapi/linux/fuse.h=0D=0Aindex 25686f088e6a..9eff9083d3b5=
 100644=0D=0A--- a/include/uapi/linux/fuse.h=0D=0A+++ b/include/uapi/linu=
x/fuse.h=0D=0A@@ -669,6 +669,9 @@ enum fuse_opcode {=0D=0A =09FUSE_STATX=09=
=09=3D 52,=0D=0A =09FUSE_COPY_FILE_RANGE_64=09=3D 53,=0D=0A=20=0D=0A+=09/=
* Famfs / devdax opcodes */=0D=0A+=09FUSE_GET_FMAP           =3D 54,=0D=0A=
+=0D=0A =09/* CUSE specific operations */=0D=0A =09CUSE_INIT=09=09=3D 409=
6,=0D=0A=20=0D=0A@@ -1313,4 +1316,8 @@ struct fuse_uring_cmd_req {=0D=0A =
=09uint8_t padding[6];=0D=0A };=0D=0A=20=0D=0A+/* Famfs fmap message comp=
onents */=0D=0A+=0D=0A+#define FAMFS_FMAP_MAX 32768 /* Largest supported =
fmap message */=0D=0A+=0D=0A #endif /* _LINUX_FUSE_H */=0D=0A--=20=0D=0A2=
=2E53.0=0D=0A=0D=0A
