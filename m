Received: from a11-16.smtp-out.amazonses.com (a11-16.smtp-out.amazonses.com [54.240.11.16])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB43397B02;
	Mon, 10 Aug 2026 20:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393501; cv=none; b=QqYCeidkk7FD2Y3szqAxKcxwvo9zYUjzd4X2Y6YxR3utatvOE1zKi5YuWVwXOoqyF4OY8T4A6v2bgO+5dn0dBTzSxMfjKQ0mbDPL2fw9162U4pqizHfQlvchZvjPDaNcHZdFD8bSYoMHdDPN/5U6qPnJOWbN35oLLOBGp7yxYZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393501; c=relaxed/simple;
	bh=ZqYamBbCr26xhg7gcFKXVgqVcVTxhLs+rTOF2sLtDvc=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=HuyJYtJDmKlglzY6LVNmOmL9gFyLURtiakW60LsZR7uPNdZbTow0yLRubnIIntvsYp3HeU87wNyyVLL6XsuvPAXRDaeimBXDygnquGGS7VywUl2u80md2fxb5Oosa8WV7+C6rgaBVGM98C6gqc2fWd/hIWGrVrM2EX7Mt7IGrx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=BPrkJGAT; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=FfV89t6M; arc=none smtp.client-ip=54.240.11.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="BPrkJGAT";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="FfV89t6M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1786393498;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=ZqYamBbCr26xhg7gcFKXVgqVcVTxhLs+rTOF2sLtDvc=;
	b=BPrkJGAT5/ABcXeqJmYWMdr4yiStgMrF57LYCCQuBy96ipYz7JibI7ThxHMqP9g5
	k7c+/Nx69wYRljMMyoPLDTm6cz+tXVq/E6jAleYTAkzAvA5F8P6kYX4JcIzDtfaKtbZ
	QHJuGVb0oB9kxSPDRVtGfOWa9RsVMcN67wqMCpz0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1786393498;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=ZqYamBbCr26xhg7gcFKXVgqVcVTxhLs+rTOF2sLtDvc=;
	b=FfV89t6MlFMRaIVy2TqMsmDL7f6TvdBw3O/E2OwlBjCnbpNvkqqBnQ2KmlWku39R
	u69qlyrBQW4ac39x9xm6KgFCnopp2bJG+Eiqt6YqsSUEhvGVwH3XXn0vyufuBY2LWnr
	HN5+un/X0qoSQWuCGAtqDbZZEKULOhmaR7wfuf3g=
Subject: [PATCH v13 05/12] famfs: Introduce file_operations read/write
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
Date: Mon, 10 Aug 2026 20:24:57 +0000
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
 <20260810202450.96296-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdKQYd8BhJGjNjSyqPwMCz2Vr35AAADHne
Thread-Topic: [PATCH v13 05/12] famfs: Introduce file_operations read/write
X-Wm-Sent-Timestamp: 1786393496
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <0100019fed59914b-622f6c0a-05cd-4ff6-9cc4-f952557e0f59-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.10-54.240.11.16

From: John Groves <john@groves.net>=0D=0A=0D=0AThis commit introduces fs/=
famfs/famfs_file.c and the famfs=0D=0Afile_operations for read/write.=0D=0A=
=0D=0AThis is not usable yet because:=0D=0A=0D=0A* It calls dax_iomap_rw(=
) with NULL iomap_ops (which will be=0D=0A  introduced in a subsequent co=
mmit).=0D=0A* famfs_ioctl() is coming in a later commit, and it is necess=
ary=0D=0A  to map a file to a memory allocation.=0D=0A=0D=0ASigned-off-by=
: John Groves <john@groves.net>=0D=0A---=0D=0Av13:=0D=0A - Use copy_splic=
e_read() instead of filemap_splice_read() for .splice_read:=0D=0A   famfs=
 inodes are DAX (no page cache), so filemap_splice_read() faulted in=0D=0A=
   zero-filled ram_aops folios and splice()/sendfile() returned a stream =
of=0D=0A   zeroes; copy_splice_read() routes through ->read_iter (dax_iom=
ap_rw) and=0D=0A   returns the real data (Sashiko bot).=0D=0A - No code c=
hange. The Sashiko bot flagged that famfs_dax_write_iter() does=0D=0A   n=
ot call generic_write_sync() for O_SYNC/O_DSYNC writes. Considered and=0D=
=0A   declined -- the finding does not apply to famfs: there is no page c=
ache,=0D=0A   no dirty tracking and no writeback, and ->fsync is noop_fsy=
nc by design,=0D=0A   so generic_write_sync() resolves to vfs_fsync_range=
() -> noop_fsync() -> 0,=0D=0A   an inert no-op. Bla bla bla ;)=0D=0A=0D=0A=
 fs/famfs/Makefile         |   2 +-=0D=0A fs/famfs/famfs_file.c     | 141=
 ++++++++++++++++++++++++++++++++++++++=0D=0A fs/famfs/famfs_inode.c    |=
   2 +-=0D=0A fs/famfs/famfs_internal.h |   2 +=0D=0A 4 files changed, 14=
5 insertions(+), 2 deletions(-)=0D=0A create mode 100644 fs/famfs/famfs_f=
ile.c=0D=0A=0D=0Adiff --git a/fs/famfs/Makefile b/fs/famfs/Makefile=0D=0A=
index 62230bcd6793..8cac90c090a4 100644=0D=0A--- a/fs/famfs/Makefile=0D=0A=
+++ b/fs/famfs/Makefile=0D=0A@@ -2,4 +2,4 @@=0D=0A=20=0D=0A obj-$(CONFIG_=
FAMFS) +=3D famfs.o=0D=0A=20=0D=0A-famfs-y :=3D famfs_inode.o=0D=0A+famfs=
-y :=3D famfs_inode.o famfs_file.o=0D=0Adiff --git a/fs/famfs/famfs_file.=
c b/fs/famfs/famfs_file.c=0D=0Anew file mode 100644=0D=0Aindex 0000000000=
00..1369fe1824bc=0D=0A--- /dev/null=0D=0A+++ b/fs/famfs/famfs_file.c=0D=0A=
@@ -0,0 +1,141 @@=0D=0A+// SPDX-License-Identifier: GPL-2.0=0D=0A+/*=0D=0A=
+ * famfs - dax file system for shared fabric-attached memory=0D=0A+ *=0D=
=0A+ * Copyright 2023-2024 Micron Technology, Inc.=0D=0A+ *=0D=0A+ * This=
 file system, originally based on ramfs the dax support from xfs,=0D=0A+ =
* is intended to allow multiple host systems to mount a common file syste=
m=0D=0A+ * view of dax files that map to shared memory.=0D=0A+ */=0D=0A+=0D=
=0A+#include <linux/fs.h>=0D=0A+#include <linux/mm.h>=0D=0A+#include <lin=
ux/dax.h>=0D=0A+#include <linux/iomap.h>=0D=0A+=0D=0A+#include "famfs_int=
ernal.h"=0D=0A+=0D=0A+/**************************************************=
*******************=0D=0A+ * file_operations=0D=0A+ */=0D=0A+=0D=0A+/* Re=
ject I/O to files that aren't in a valid state */=0D=0A+static ssize_t=0D=
=0A+famfs_file_invalid(struct inode *inode)=0D=0A+{=0D=0A+=09if (!IS_DAX(=
inode)) {=0D=0A+=09=09pr_debug("%s: inode %llx IS_DAX is false\n",=0D=0A+=
=09=09=09 __func__, (u64)inode);=0D=0A+=09=09return -ENXIO;=0D=0A+=09}=0D=
=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static ssize_t=0D=0A+famfs_rw_prep(=
struct kiocb *iocb, struct iov_iter *ubuf)=0D=0A+{=0D=0A+=09struct inode =
*inode =3D iocb->ki_filp->f_mapping->host;=0D=0A+=09struct super_block *s=
b =3D inode->i_sb;=0D=0A+=09struct famfs_fs_info *fsi =3D sb->s_fs_info;=0D=
=0A+=09size_t i_size =3D i_size_read(inode);=0D=0A+=09size_t count =3D io=
v_iter_count(ubuf);=0D=0A+=09size_t max_count;=0D=0A+=09ssize_t rc;=0D=0A=
+=0D=0A+=09if (fsi->deverror)=0D=0A+=09=09return -ENODEV;=0D=0A+=0D=0A+=09=
rc =3D famfs_file_invalid(inode);=0D=0A+=09if (rc)=0D=0A+=09=09return rc;=
=0D=0A+=0D=0A+=09/* Avoid unsigned underflow if position is past EOF */=0D=
=0A+=09if (iocb->ki_pos >=3D i_size)=0D=0A+=09=09max_count =3D 0;=0D=0A+=09=
else=0D=0A+=09=09max_count =3D i_size - iocb->ki_pos;=0D=0A+=0D=0A+=09if =
(count > max_count)=0D=0A+=09=09iov_iter_truncate(ubuf, max_count);=0D=0A=
+=0D=0A+=09if (!iov_iter_count(ubuf))=0D=0A+=09=09return 0;=0D=0A+=0D=0A+=
=09return rc;=0D=0A+}=0D=0A+=0D=0A+static ssize_t=0D=0A+famfs_dax_read_it=
er(struct kiocb *iocb, struct iov_iter=09*to)=0D=0A+{=0D=0A+=09struct ino=
de *inode =3D iocb->ki_filp->f_mapping->host;=0D=0A+=09ssize_t rc;=0D=0A+=
=0D=0A+=09/* dax_iomap_rw() requires i_rwsem held (shared for read) */=0D=
=0A+=09inode_lock_shared(inode);=0D=0A+=09rc =3D famfs_rw_prep(iocb, to);=
=0D=0A+=09if (rc || !iov_iter_count(to)) {=0D=0A+=09=09inode_unlock_share=
d(inode);=0D=0A+=09=09return rc;=0D=0A+=09}=0D=0A+=0D=0A+=09rc =3D dax_io=
map_rw(iocb, to, NULL /*&famfs_iomap_ops */);=0D=0A+=09inode_unlock_share=
d(inode);=0D=0A+=0D=0A+=09if (rc > 0)=0D=0A+=09=09file_accessed(iocb->ki_=
filp);=0D=0A+=09return rc;=0D=0A+}=0D=0A+=0D=0A+/**=0D=0A+ * famfs_dax_wr=
ite_iter()=0D=0A+ *=0D=0A+ * We need our own write-iter in order to preve=
nt append=0D=0A+ *=0D=0A+ * @iocb:=0D=0A+ * @from: iterator describing th=
e user memory source for the write=0D=0A+ */=0D=0A+static ssize_t=0D=0A+f=
amfs_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)=0D=0A+{=0D=
=0A+=09struct inode *inode =3D iocb->ki_filp->f_mapping->host;=0D=0A+=09s=
truct famfs_fs_info *fsi =3D inode->i_sb->s_fs_info;=0D=0A+=09ssize_t rc;=
=0D=0A+=0D=0A+=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_WRITE))=0D=0A+=09=09=
return -EPERM;=0D=0A+=0D=0A+=09/* dax_iomap_rw() requires i_rwsem held (e=
xclusive for write) */=0D=0A+=09inode_lock(inode);=0D=0A+=09rc =3D famfs_=
rw_prep(iocb, from);=0D=0A+=09if (rc || !iov_iter_count(from)) {=0D=0A+=09=
=09inode_unlock(inode);=0D=0A+=09=09return rc;=0D=0A+=09}=0D=0A+=0D=0A+=09=
kiocb_modified(iocb); /* mtime/ctime + strip set[e]uid */=0D=0A+=0D=0A+=09=
rc =3D dax_iomap_rw(iocb, from, NULL /*&famfs_iomap_ops*/);=0D=0A+=09inod=
e_unlock(inode);=0D=0A+=09return rc;=0D=0A+}=0D=0A+=0D=0A+const struct fi=
le_operations famfs_file_operations =3D {=0D=0A+=09.owner             =3D=
 THIS_MODULE,=0D=0A+=0D=0A+=09/* Custom famfs operations */=0D=0A+=09.wri=
te_iter=09   =3D famfs_dax_write_iter,=0D=0A+=09.read_iter=09   =3D famfs=
_dax_read_iter,=0D=0A+=09.unlocked_ioctl    =3D NULL /*famfs_file_ioctl*/=
,=0D=0A+=09.mmap=09=09   =3D NULL /* famfs_file_mmap */,=0D=0A+=0D=0A+=09=
/* Force PMD alignment for mmap */=0D=0A+=09.get_unmapped_area =3D thp_ge=
t_unmapped_area,=0D=0A+=0D=0A+=09/* Generic Operations */=0D=0A+=09.fsync=
=09=09   =3D noop_fsync,=0D=0A+=09.splice_read=09   =3D copy_splice_read,=
=0D=0A+=09.splice_write=09   =3D iter_file_splice_write,=0D=0A+=09.llseek=
=09=09   =3D generic_file_llseek,=0D=0A+};=0D=0A+=0D=0Adiff --git a/fs/fa=
mfs/famfs_inode.c b/fs/famfs/famfs_inode.c=0D=0Aindex b7a3d8d6ee8c..9e866=
2c4ac98 100644=0D=0A--- a/fs/famfs/famfs_inode.c=0D=0A+++ b/fs/famfs/famf=
s_inode.c=0D=0A@@ -59,7 +59,7 @@ famfs_get_inode(=0D=0A =09=09break;=0D=0A=
 =09case S_IFREG:=0D=0A =09=09inode->i_op =3D &famfs_file_inode_operation=
s;=0D=0A-=09=09inode->i_fop =3D NULL /* &famfs_file_operations */;=0D=0A+=
=09=09inode->i_fop =3D &famfs_file_operations;=0D=0A =09=09break;=0D=0A =09=
case S_IFDIR:=0D=0A =09=09inode->i_op =3D &famfs_dir_inode_operations;=0D=
=0Adiff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h=0D=0A=
index 30f0b01010d5..ff9f1d3f686e 100644=0D=0A--- a/fs/famfs/famfs_interna=
l.h=0D=0A+++ b/fs/famfs/famfs_internal.h=0D=0A@@ -15,6 +15,8 @@=0D=0A #in=
clude <linux/bits.h>=0D=0A #include <linux/build_bug.h>=0D=0A=20=0D=0A+ex=
tern const struct file_operations famfs_file_operations;=0D=0A+=0D=0A str=
uct famfs_mount_opts {=0D=0A =09umode_t mode;=0D=0A };=0D=0A--=20=0D=0A2.=
53.0=0D=0A=0D=0A
