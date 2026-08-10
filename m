Received: from a11-32.smtp-out.amazonses.com (a11-32.smtp-out.amazonses.com [54.240.11.32])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAAD38AC7D;
	Mon, 10 Aug 2026 20:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393560; cv=none; b=Sckk6FPWgEsJs8E275HRhpcWSsDJtDhto9dINGB4KoOqPLKc4cyzbGCWAkDVkFqYOnV62WdSs8hJ3OValRak/OyD9W/SwvvJOn+JKw+8rf/DNiv+6qKhhrrsxKqPYin9iT/U4ZmRRmw+h/4togXWJyFUc0oucKYR2JC5pmDh7zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393560; c=relaxed/simple;
	bh=8AUdrHCbpTYrFbHD+RQ6Y2Jj8+xz9I7kVU8dMMD3ovw=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=MArbgUFRoqH+2CEe3qWKnn1gHXzwXs3ifkE2IsR1ZmOTFbHqVYb2B1KxK18qdOU/+5OTuXrWAno58YApH0DBl1NireovYVxksCiOI7Qgen0uIRJZA9W0KBdMfkXdI7lXdGE4ilqpWr9GT7A63YVrF+2j0Ihm5Wtgj+2+DlxGH/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=q/X0hZ25; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=liT53Kc2; arc=none smtp.client-ip=54.240.11.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="q/X0hZ25";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="liT53Kc2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1786393557;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=8AUdrHCbpTYrFbHD+RQ6Y2Jj8+xz9I7kVU8dMMD3ovw=;
	b=q/X0hZ25Lhyxm+DgQ76C4RFrIhaLbsNDtc4R7bSK8Me2Geoe5SqN99ws8znvaTHc
	MbeZBAnimSzy1gFscPAStE5yeKPzZHS0hVGFeUG50i7V7Qq+FMT+LvZ1bDriS9WeNb4
	H7PtnUbqMHN9vdcQByCIE3QmZDGZL502hN05YpxE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1786393557;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=8AUdrHCbpTYrFbHD+RQ6Y2Jj8+xz9I7kVU8dMMD3ovw=;
	b=liT53Kc2Itc7ev/HyboFpD0IhrqUutuX0YCzNpR7bWzyqAwcu3jNP7dii/OP6f9J
	rAGjYcsWjW1n5/EhiWx44uBgDDPEWZELlOBpJEwKwImLexS/xIiHD+tbJTA4LeqfkQ+
	6x1jYrgG+WIFQJp9DUtjpXLlY//rPq9Ul5ywH1Qc=
Subject: [PATCH v13 11/12] famfs: Report device capacity via statfs so df
 works
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
Date: Mon, 10 Aug 2026 20:25:57 +0000
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
 <20260810202549.96400-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdKQYd8BhJGjNjSyqPwMCz2Vr35AAAFVF8
Thread-Topic: [PATCH v13 11/12] famfs: Report device capacity via statfs so
 df works
X-Wm-Sent-Timestamp: 1786393556
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <0100019fed5a7936-f613e396-d14b-455f-bfd0-e2a0c1f4f844-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.10-54.240.11.32

From: John Groves <john@groves.net>=0D=0A=0D=0AReplace simple_statfs(), w=
hich reports zero blocks (so df omits the mount),=0D=0Awith famfs_statfs(=
) reporting real capacity and usage.=0D=0A=0D=0AAdd dax_fsdev_size() in d=
rivers/dax/fsdev.c, returning the size fsdev=0D=0Acaches at probe (dev_da=
x->cached_size - the sum of the device's ranges,=0D=0Astable while bound)=
, exported. It lives in fsdev.c because cached_size is=0D=0Aset only by t=
he fsdev driver, and famfs only ever holds fsdev-mode daxdevs=0D=0A(fs_da=
x_get() enforces DAXDRV_FSDEV_TYPE); famfs.ko therefore depends on=0D=0Af=
sdev_dax.ko.=0D=0A=0D=0Afamfs tracks two byte counters under a new stats_=
sem:=0D=0A - total_capacity: summed in famfs_install_daxdev() from dax_fs=
dev_size(),=0D=0A   covering the mount primary and every DAXDEV_OPEN seco=
ndary, counted once=0D=0A   per daxdev (on the valid 0->1 transition).=0D=
=0A - used_capacity: summed in famfs_file_init_dax() from the fmap's mapp=
ed=0D=0A   device bytes (superblock + log + data files).=0D=0A=0D=0Afamfs=
_statfs() reports total and free (total - used). Free is an=0D=0Aapproxim=
ation of the userspace allocator's free space (it ignores allocator=0D=0A=
gaps and reserved regions), which is adequate for df.=0D=0A=0D=0A(Side no=
te: I am the maintainer of drivers/dax/fsdev.c)=0D=0A=0D=0ASigned-off-by:=
 John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/fsdev.c       |=
 19 +++++++++++++++=0D=0A fs/famfs/famfs_file.c     |  5 ++++=0D=0A fs/fa=
mfs/famfs_inode.c    | 49 ++++++++++++++++++++++++++++++++++-----=0D=0A f=
s/famfs/famfs_internal.h |  8 +++++++=0D=0A include/linux/dax.h       |  =
1 +=0D=0A 5 files changed, 76 insertions(+), 6 deletions(-)=0D=0A=0D=0Adi=
ff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c=0D=0Aindex 188b2526b=
ee4..a5b4b2d79428 100644=0D=0A--- a/drivers/dax/fsdev.c=0D=0A+++ b/driver=
s/dax/fsdev.c=0D=0A@@ -104,6 +104,25 @@ static size_t fsdev_dax_recovery_=
write(struct dax_device *dax_dev, pgoff_t pgoff=0D=0A =09return _copy_fro=
m_iter_flushcache(addr, bytes, i);=0D=0A }=0D=0A=20=0D=0A+/**=0D=0A+ * da=
x_fsdev_size() - total size in bytes of an fsdev dax device=0D=0A+ * @dax=
_dev: the dax device (must be bound to this driver)=0D=0A+ *=0D=0A+ * Ret=
urns the size cached at probe time (sum of all ranges); it cannot change=0D=
=0A+ * while the driver is bound. Only valid for fsdev dax devices - call=
ers=0D=0A+ * ensure that (e.g. fs_dax_get() enforces DAXDRV_FSDEV_TYPE). =
Returns 0 if the=0D=0A+ * device is not alive.=0D=0A+ */=0D=0A+u64 dax_fs=
dev_size(struct dax_device *dax_dev)=0D=0A+{=0D=0A+=09struct dev_dax *dev=
_dax =3D dax_get_private(dax_dev);=0D=0A+=0D=0A+=09if (!dev_dax)=0D=0A+=09=
=09return 0;=0D=0A+=09return dev_dax->cached_size;=0D=0A+}=0D=0A+EXPORT_S=
YMBOL_GPL(dax_fsdev_size);=0D=0A+=0D=0A static const struct dax_operation=
s dev_dax_ops =3D {=0D=0A =09.direct_access =3D fsdev_dax_direct_access,=0D=
=0A =09.zero_page_range =3D fsdev_dax_zero_page_range,=0D=0Adiff --git a/=
fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c=0D=0Aindex e7fa7324c374..17=
359fa4007b 100644=0D=0A--- a/fs/famfs/famfs_file.c=0D=0A+++ b/fs/famfs/fa=
mfs_file.c=0D=0A@@ -282,6 +282,11 @@ famfs_file_init_dax(struct file *fil=
e, void __user *arg)=0D=0A =09}=0D=0A =09inode_unlock(inode);=0D=0A=20=0D=
=0A+=09/* Account the mapped device bytes for statfs (only on success) */=
=0D=0A+=09if (!rc) {=0D=0A+=09=09scoped_guard(rwsem_write, &fsi->stats_se=
m)=0D=0A+=09=09=09fsi->used_capacity +=3D extent_total;=0D=0A+=09}=0D=0A =
out:=0D=0A =09kvfree(fmap_buf);=0D=0A =09if (meta)=0D=0Adiff --git a/fs/f=
amfs/famfs_inode.c b/fs/famfs/famfs_inode.c=0D=0Aindex 2f1938adbfbc..61b6=
68b299ef 100644=0D=0A--- a/fs/famfs/famfs_inode.c=0D=0A+++ b/fs/famfs/fam=
fs_inode.c=0D=0A@@ -24,6 +24,7 @@=0D=0A #include <linux/iomap.h>=0D=0A #i=
nclude <linux/path.h>=0D=0A #include <linux/namei.h>=0D=0A+#include <linu=
x/statfs.h>=0D=0A=20=0D=0A #include "famfs_internal.h"=0D=0A=20=0D=0A@@ -=
348,8 +349,38 @@ famfs_evict_inode(struct inode *inode)=0D=0A =09clear_in=
ode(inode);=0D=0A }=0D=0A=20=0D=0A+/*=0D=0A+ * famfs_statfs() - report de=
vice capacity and consumption so 'df' works.=0D=0A+ * @total_capacity is =
the sum of installed daxdev sizes; @used_capacity is the=0D=0A+ * sum of =
device bytes mapped by fmaps (superblock + log + data files). Free is=0D=0A=
+ * the difference - an approximation of the userspace allocator's free s=
pace=0D=0A+ * (it ignores allocator gaps / reserved regions), which is fi=
ne for df.=0D=0A+ */=0D=0A+static int=0D=0A+famfs_statfs(struct dentry *d=
entry, struct kstatfs *buf)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D=
 dentry->d_sb->s_fs_info;=0D=0A+=09u64 total, used, free;=0D=0A+=0D=0A+=09=
scoped_guard(rwsem_read, &fsi->stats_sem) {=0D=0A+=09=09total =3D fsi->to=
tal_capacity;=0D=0A+=09=09used  =3D fsi->used_capacity;=0D=0A+=09}=0D=0A+=
=09free =3D total > used =3F total - used : 0;=0D=0A+=0D=0A+=09buf->f_typ=
e    =3D FAMFS_SUPER_MAGIC;=0D=0A+=09buf->f_bsize   =3D PAGE_SIZE;=0D=0A+=
=09buf->f_frsize  =3D PAGE_SIZE;=0D=0A+=09buf->f_blocks  =3D total >> PAG=
E_SHIFT;=0D=0A+=09buf->f_bfree   =3D free  >> PAGE_SHIFT;=0D=0A+=09buf->f=
_bavail  =3D free  >> PAGE_SHIFT;=09/* no root reservation */=0D=0A+=09bu=
f->f_namelen =3D NAME_MAX;=0D=0A+=09buf->f_fsid    =3D u64_to_fsid(huge_e=
ncode_dev(dentry->d_sb->s_dev));=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A =
static const struct super_operations famfs_super_ops =3D {=0D=0A-=09.stat=
fs=09=09=3D simple_statfs,=0D=0A+=09.statfs=09=09=3D famfs_statfs,=0D=0A =
=09.drop_inode=09=3D inode_just_drop,=0D=0A =09.show_options=09=3D famfs_=
show_options,=0D=0A =09.evict_inode    =3D famfs_evict_inode,=0D=0A@@ -44=
4,6 +475,7 @@ famfs_install_daxdev(=0D=0A =09const char *name)=0D=0A {=0D=
=0A =09struct famfs_daxdev *daxdev;=0D=0A+=09struct dax_device *devp =3D =
NULL;=0D=0A =09int rc =3D 0;=0D=0A=20=0D=0A =09if (index >=3D fsi->dax_de=
vlist->nslots) {=0D=0A@@ -507,6 +539,15 @@ famfs_install_daxdev(=0D=0A=20=
=0D=0A =09=09wmb(); /* All other fields must be visible before valid */=0D=
=0A =09=09daxdev->valid =3D 1;=0D=0A+=09=09devp =3D daxdev->devp;=0D=0A+=09=
}=0D=0A+=0D=0A+=09/* Freshly installed: add its capacity to the statfs ac=
counting */=0D=0A+=09if (devp) {=0D=0A+=09=09u64 sz =3D dax_fsdev_size(de=
vp);=0D=0A+=0D=0A+=09=09scoped_guard(rwsem_write, &fsi->stats_sem)=0D=0A+=
=09=09=09fsi->total_capacity +=3D sz;=0D=0A =09}=0D=0A=20=0D=0A =09return=
 0;=0D=0A@@ -769,6 +810,7 @@ famfs_init_fs_context(struct fs_context *fc)=
=0D=0A =09=09return -ENOMEM;=0D=0A=20=0D=0A =09init_rwsem(&fsi->devlist_s=
em);=0D=0A+=09init_rwsem(&fsi->stats_sem);=0D=0A =09atomic64_set(&fsi->op=
ts, FAMFS_OPT_DEFAULT);=0D=0A =09fsi->mount_opts.mode =3D FAMFS_DEFAULT_M=
ODE;=0D=0A =09fc->s_fs_info        =3D fsi;=0D=0A@@ -802,16 +844,11 @@ st=
atic struct file_system_type famfs_fs_type =3D {=0D=0A /*****************=
*************************************************************=0D=0A  * Mo=
dule stuff=0D=0A  */=0D=0A-#define FAMFS_MODULE_INCOMPLETE 1=0D=0A-=0D=0A=
 static int __init=0D=0A init_famfs_fs(void)=0D=0A {=0D=0A =09int rc;=0D=0A=
=20=0D=0A-=09if (FAMFS_MODULE_INCOMPLETE)=0D=0A-=09=09return -ENODEV;=0D=0A=
-=0D=0A =09rc =3D register_filesystem(&famfs_fs_type);=0D=0A=20=0D=0A =09=
return rc;=0D=0Adiff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_i=
nternal.h=0D=0Aindex 5e043b5a0ddd..8765be41e4a7 100644=0D=0A--- a/fs/famf=
s/famfs_internal.h=0D=0A+++ b/fs/famfs/famfs_internal.h=0D=0A@@ -123,6 +1=
23,11 @@ struct famfs_dax_devlist {=0D=0A  *               point, or if o=
ther "shutdown" conditions exist=0D=0A  * @dax_devlist: Table of backing =
daxdevs (slot 0 is the mount primary)=0D=0A  * @devlist_sem: Serializes i=
nstalls into, and teardown of, @dax_devlist=0D=0A+ * @stats_sem:   Protec=
ts the statfs accounting counters below=0D=0A+ * @total_capacity: Sum of =
installed daxdev sizes, in bytes (grows as daxdevs=0D=0A+ *              =
 are added)=0D=0A+ * @used_capacity:  Sum of installed fmap sizes, in byt=
es (grows as MAP_CREATE=0D=0A+ *               attaches fmaps; this is de=
vice bytes consumed, not file size)=0D=0A  */=0D=0A struct famfs_fs_info =
{=0D=0A =09struct famfs_mount_opts   mount_opts;=0D=0A@@ -130,6 +135,9 @@=
 struct famfs_fs_info {=0D=0A =09bool                      deverror;=0D=0A=
 =09struct famfs_dax_devlist *dax_devlist;=0D=0A =09struct rw_semaphore  =
     devlist_sem;=0D=0A+=09struct rw_semaphore       stats_sem;=0D=0A+=09=
u64                       total_capacity;=0D=0A+=09u64                   =
    used_capacity;=0D=0A };=0D=0A=20=0D=0A /*=0D=0Adiff --git a/include/l=
inux/dax.h b/include/linux/dax.h=0D=0Aindex 29113eb95e72..c25ef499d04f 10=
0644=0D=0A--- a/include/linux/dax.h=0D=0A+++ b/include/linux/dax.h=0D=0A@=
@ -256,6 +256,7 @@ static inline void dax_break_layout_final(struct inode=
 *inode)=0D=0A=20=0D=0A bool dax_alive(struct dax_device *dax_dev);=0D=0A=
 void *dax_get_private(struct dax_device *dax_dev);=0D=0A+u64 dax_fsdev_s=
ize(struct dax_device *dax_dev);=0D=0A int dax_set_ops(struct dax_device =
*dax_dev, const struct dax_operations *ops);=0D=0A long dax_direct_access=
(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,=0D=0A =09=09en=
um dax_access_mode mode, void **kaddr, unsigned long *pfn);=0D=0A--=20=0D=
=0A2.53.0=0D=0A=0D=0A
