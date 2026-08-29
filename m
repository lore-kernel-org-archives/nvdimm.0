Received: from a11-77.smtp-out.amazonses.com (a11-77.smtp-out.amazonses.com [54.240.11.77])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0575E3BB116;
	Sat, 29 Aug 2026 17:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788023597; cv=none; b=HjDkDhvRQPyWm6+k0/hZfk5ER9qh+wlaR8KFGnmHseVF6Vmo8WadBLiMKLgcdbHG8I0fk94cG290TyW9l7BytK85UyAjuIGZnuru7ly1Mj1WQzGNEzG/mt/E+Gcb/E+mTeOHj0DVhGELzhD1j+MehAEYvepGcTUJ/XHSYTMb0cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788023597; c=relaxed/simple;
	bh=CcJeL7yxa75NnpqBcRT/gP/0ZgH0KpqVOLzrxHccWJs=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=khLdQiqK2mwzosjp6cF9mwIqjSQyY4HIvZptgD74AdC/XcM4RfUlqmNpgC7jwPPNmelImzT0ig9n3sMs4Hft2fh7XYSVHQOpLZ697YZAAVzaAKEbGQ1u/uO05ghzbTksnYHC/OT50VWdhmZhHQ3fISCSJ3YWppQTXlqu3mLDw80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=SPY2EDvz; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=Pgems5gr; arc=none smtp.client-ip=54.240.11.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="SPY2EDvz";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Pgems5gr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=rjayupzefgi7e6fmzxcxe4cv4arrjs35; d=jagalactic.com; t=1788023594;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=CcJeL7yxa75NnpqBcRT/gP/0ZgH0KpqVOLzrxHccWJs=;
	b=SPY2EDvzUQZgxzqztHDYqmHxiklYS8ZwfnZeJh8OY9f0gefzSZ1vWnqfc6ENv0Tq
	P0pXILAtLJKpKNjYPWxMVVNk9xBeA3NI4gdtd4s9KbcTggLmAlOipZpLe44pVau2rPr
	12imdgzsL30QYE/KLPcIVlR1+gc1xUXfiLo5NtmA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1788023594;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=CcJeL7yxa75NnpqBcRT/gP/0ZgH0KpqVOLzrxHccWJs=;
	b=Pgems5grXYm5R5WSlPc07K388SaHvBN9F2Fz+4elSiK/lIKd/2gfLyf3ZlpY2FGd
	pMiPblIfHI8W7YE/kNA50KongzYzWIQKa7m5bySHjm8ZkhzAsv5T+mCvAaH3+bijDO8
	31aAeF7mWq9QudT7fMYGr9y0t2w44bVEjtrcE4F4=
Subject: [PATCH V14 11/12] famfs: Report device capacity via statfs so df
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
Date: Sat, 29 Aug 2026 17:13:14 +0000
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
 <20260829171307.7532-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdN9lAfqnLmnnsQyaIwPphM+3eHAAAGxUa
Thread-Topic: [PATCH V14 11/12] famfs: Report device capacity via statfs so
 df works
X-Wm-Sent-Timestamp: 1788023593
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <010001a04e82df10-e266ce13-d8e7-42f0-ae64-0b2df6e94be5-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.29-54.240.11.77

From: John Groves <John@Groves.net>=0D=0A=0D=0AReplace simple_statfs(), w=
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
te: I am the maintainer of drivers/dax/fsdev.c)=0D=0A=0D=0AReviewed-by: "=
Darrick J. Wong" <djwong@kernel.org>=0D=0AReviewed-by: Jeff Layton <jlayt=
on@kernel.org>=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=
=0D=0A drivers/dax/fsdev.c       | 19 +++++++++++++++=0D=0A fs/famfs/famf=
s_file.c     |  5 ++++=0D=0A fs/famfs/famfs_inode.c    | 49 +++++++++++++=
+++++++++++++++++++++-----=0D=0A fs/famfs/famfs_internal.h |  8 +++++++=0D=
=0A include/linux/dax.h       |  1 +=0D=0A 5 files changed, 76 insertions=
(+), 6 deletions(-)=0D=0A=0D=0Adiff --git a/drivers/dax/fsdev.c b/drivers=
/dax/fsdev.c=0D=0Aindex 188b2526bee4..a5b4b2d79428 100644=0D=0A--- a/driv=
ers/dax/fsdev.c=0D=0A+++ b/drivers/dax/fsdev.c=0D=0A@@ -104,6 +104,25 @@ =
static size_t fsdev_dax_recovery_write(struct dax_device *dax_dev, pgoff_=
t pgoff=0D=0A =09return _copy_from_iter_flushcache(addr, bytes, i);=0D=0A=
 }=0D=0A=20=0D=0A+/**=0D=0A+ * dax_fsdev_size() - total size in bytes of =
an fsdev dax device=0D=0A+ * @dax_dev: the dax device (must be bound to t=
his driver)=0D=0A+ *=0D=0A+ * Returns the size cached at probe time (sum =
of all ranges); it cannot change=0D=0A+ * while the driver is bound. Only=
 valid for fsdev dax devices - callers=0D=0A+ * ensure that (e.g. fs_dax_=
get() enforces DAXDRV_FSDEV_TYPE). Returns 0 if the=0D=0A+ * device is no=
t alive.=0D=0A+ */=0D=0A+u64 dax_fsdev_size(struct dax_device *dax_dev)=0D=
=0A+{=0D=0A+=09struct dev_dax *dev_dax =3D dax_get_private(dax_dev);=0D=0A=
+=0D=0A+=09if (!dev_dax)=0D=0A+=09=09return 0;=0D=0A+=09return dev_dax->c=
ached_size;=0D=0A+}=0D=0A+EXPORT_SYMBOL_GPL(dax_fsdev_size);=0D=0A+=0D=0A=
 static const struct dax_operations dev_dax_ops =3D {=0D=0A =09.direct_ac=
cess =3D fsdev_dax_direct_access,=0D=0A =09.zero_page_range =3D fsdev_dax=
_zero_page_range,=0D=0Adiff --git a/fs/famfs/famfs_file.c b/fs/famfs/famf=
s_file.c=0D=0Aindex 0a6d0392794c..965b6732f52c 100644=0D=0A--- a/fs/famfs=
/famfs_file.c=0D=0A+++ b/fs/famfs/famfs_file.c=0D=0A@@ -344,6 +344,11 @@ =
famfs_file_init_dax(struct file *file, void __user *arg)=0D=0A =09}=0D=0A=
 =09inode_unlock(inode);=0D=0A=20=0D=0A+=09/* Account the mapped device b=
ytes for statfs (only on success) */=0D=0A+=09if (!rc) {=0D=0A+=09=09scop=
ed_guard(rwsem_write, &fsi->stats_sem)=0D=0A+=09=09=09fsi->used_capacity =
+=3D extent_total;=0D=0A+=09}=0D=0A out:=0D=0A =09kvfree(fmap_buf);=0D=0A=
 =09if (meta)=0D=0Adiff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_i=
node.c=0D=0Aindex 2f1938adbfbc..61b668b299ef 100644=0D=0A--- a/fs/famfs/f=
amfs_inode.c=0D=0A+++ b/fs/famfs/famfs_inode.c=0D=0A@@ -24,6 +24,7 @@=0D=0A=
 #include <linux/iomap.h>=0D=0A #include <linux/path.h>=0D=0A #include <l=
inux/namei.h>=0D=0A+#include <linux/statfs.h>=0D=0A=20=0D=0A #include "fa=
mfs_internal.h"=0D=0A=20=0D=0A@@ -348,8 +349,38 @@ famfs_evict_inode(stru=
ct inode *inode)=0D=0A =09clear_inode(inode);=0D=0A }=0D=0A=20=0D=0A+/*=0D=
=0A+ * famfs_statfs() - report device capacity and consumption so 'df' wo=
rks.=0D=0A+ * @total_capacity is the sum of installed daxdev sizes; @used=
_capacity is the=0D=0A+ * sum of device bytes mapped by fmaps (superblock=
 + log + data files). Free is=0D=0A+ * the difference - an approximation =
of the userspace allocator's free space=0D=0A+ * (it ignores allocator ga=
ps / reserved regions), which is fine for df.=0D=0A+ */=0D=0A+static int=0D=
=0A+famfs_statfs(struct dentry *dentry, struct kstatfs *buf)=0D=0A+{=0D=0A=
+=09struct famfs_fs_info *fsi =3D dentry->d_sb->s_fs_info;=0D=0A+=09u64 t=
otal, used, free;=0D=0A+=0D=0A+=09scoped_guard(rwsem_read, &fsi->stats_se=
m) {=0D=0A+=09=09total =3D fsi->total_capacity;=0D=0A+=09=09used  =3D fsi=
->used_capacity;=0D=0A+=09}=0D=0A+=09free =3D total > used =3F total - us=
ed : 0;=0D=0A+=0D=0A+=09buf->f_type    =3D FAMFS_SUPER_MAGIC;=0D=0A+=09bu=
f->f_bsize   =3D PAGE_SIZE;=0D=0A+=09buf->f_frsize  =3D PAGE_SIZE;=0D=0A+=
=09buf->f_blocks  =3D total >> PAGE_SHIFT;=0D=0A+=09buf->f_bfree   =3D fr=
ee  >> PAGE_SHIFT;=0D=0A+=09buf->f_bavail  =3D free  >> PAGE_SHIFT;=09/* =
no root reservation */=0D=0A+=09buf->f_namelen =3D NAME_MAX;=0D=0A+=09buf=
->f_fsid    =3D u64_to_fsid(huge_encode_dev(dentry->d_sb->s_dev));=0D=0A+=
=09return 0;=0D=0A+}=0D=0A+=0D=0A static const struct super_operations fa=
mfs_super_ops =3D {=0D=0A-=09.statfs=09=09=3D simple_statfs,=0D=0A+=09.st=
atfs=09=09=3D famfs_statfs,=0D=0A =09.drop_inode=09=3D inode_just_drop,=0D=
=0A =09.show_options=09=3D famfs_show_options,=0D=0A =09.evict_inode    =3D=
 famfs_evict_inode,=0D=0A@@ -444,6 +475,7 @@ famfs_install_daxdev(=0D=0A =
=09const char *name)=0D=0A {=0D=0A =09struct famfs_daxdev *daxdev;=0D=0A+=
=09struct dax_device *devp =3D NULL;=0D=0A =09int rc =3D 0;=0D=0A=20=0D=0A=
 =09if (index >=3D fsi->dax_devlist->nslots) {=0D=0A@@ -507,6 +539,15 @@ =
famfs_install_daxdev(=0D=0A=20=0D=0A =09=09wmb(); /* All other fields mus=
t be visible before valid */=0D=0A =09=09daxdev->valid =3D 1;=0D=0A+=09=09=
devp =3D daxdev->devp;=0D=0A+=09}=0D=0A+=0D=0A+=09/* Freshly installed: a=
dd its capacity to the statfs accounting */=0D=0A+=09if (devp) {=0D=0A+=09=
=09u64 sz =3D dax_fsdev_size(devp);=0D=0A+=0D=0A+=09=09scoped_guard(rwsem=
_write, &fsi->stats_sem)=0D=0A+=09=09=09fsi->total_capacity +=3D sz;=0D=0A=
 =09}=0D=0A=20=0D=0A =09return 0;=0D=0A@@ -769,6 +810,7 @@ famfs_init_fs_=
context(struct fs_context *fc)=0D=0A =09=09return -ENOMEM;=0D=0A=20=0D=0A=
 =09init_rwsem(&fsi->devlist_sem);=0D=0A+=09init_rwsem(&fsi->stats_sem);=0D=
=0A =09atomic64_set(&fsi->opts, FAMFS_OPT_DEFAULT);=0D=0A =09fsi->mount_o=
pts.mode =3D FAMFS_DEFAULT_MODE;=0D=0A =09fc->s_fs_info        =3D fsi;=0D=
=0A@@ -802,16 +844,11 @@ static struct file_system_type famfs_fs_type =3D=
 {=0D=0A /***************************************************************=
***************=0D=0A  * Module stuff=0D=0A  */=0D=0A-#define FAMFS_MODUL=
E_INCOMPLETE 1=0D=0A-=0D=0A static int __init=0D=0A init_famfs_fs(void)=0D=
=0A {=0D=0A =09int rc;=0D=0A=20=0D=0A-=09if (FAMFS_MODULE_INCOMPLETE)=0D=0A=
-=09=09return -ENODEV;=0D=0A-=0D=0A =09rc =3D register_filesystem(&famfs_=
fs_type);=0D=0A=20=0D=0A =09return rc;=0D=0Adiff --git a/fs/famfs/famfs_i=
nternal.h b/fs/famfs/famfs_internal.h=0D=0Aindex 5e043b5a0ddd..8765be41e4=
a7 100644=0D=0A--- a/fs/famfs/famfs_internal.h=0D=0A+++ b/fs/famfs/famfs_=
internal.h=0D=0A@@ -123,6 +123,11 @@ struct famfs_dax_devlist {=0D=0A  * =
              point, or if other "shutdown" conditions exist=0D=0A  * @da=
x_devlist: Table of backing daxdevs (slot 0 is the mount primary)=0D=0A  =
* @devlist_sem: Serializes installs into, and teardown of, @dax_devlist=0D=
=0A+ * @stats_sem:   Protects the statfs accounting counters below=0D=0A+=
 * @total_capacity: Sum of installed daxdev sizes, in bytes (grows as dax=
devs=0D=0A+ *               are added)=0D=0A+ * @used_capacity:  Sum of i=
nstalled fmap sizes, in bytes (grows as MAP_CREATE=0D=0A+ *              =
 attaches fmaps; this is device bytes consumed, not file size)=0D=0A  */=0D=
=0A struct famfs_fs_info {=0D=0A =09struct famfs_mount_opts   mount_opts;=
=0D=0A@@ -130,6 +135,9 @@ struct famfs_fs_info {=0D=0A =09bool           =
           deverror;=0D=0A =09struct famfs_dax_devlist *dax_devlist;=0D=0A=
 =09struct rw_semaphore       devlist_sem;=0D=0A+=09struct rw_semaphore  =
     stats_sem;=0D=0A+=09u64                       total_capacity;=0D=0A+=
=09u64                       used_capacity;=0D=0A };=0D=0A=20=0D=0A /*=0D=
=0Adiff --git a/include/linux/dax.h b/include/linux/dax.h=0D=0Aindex 2911=
3eb95e72..c25ef499d04f 100644=0D=0A--- a/include/linux/dax.h=0D=0A+++ b/i=
nclude/linux/dax.h=0D=0A@@ -256,6 +256,7 @@ static inline void dax_break_=
layout_final(struct inode *inode)=0D=0A=20=0D=0A bool dax_alive(struct da=
x_device *dax_dev);=0D=0A void *dax_get_private(struct dax_device *dax_de=
v);=0D=0A+u64 dax_fsdev_size(struct dax_device *dax_dev);=0D=0A int dax_s=
et_ops(struct dax_device *dax_dev, const struct dax_operations *ops);=0D=0A=
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long n=
r_pages,=0D=0A =09=09enum dax_access_mode mode, void **kaddr, unsigned lo=
ng *pfn);=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
