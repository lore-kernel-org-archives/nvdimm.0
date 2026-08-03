Received: from a11-70.smtp-out.amazonses.com (a11-70.smtp-out.amazonses.com [54.240.11.70])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4A131E840;
	Mon,  3 Aug 2026 02:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724210; cv=none; b=EfpvYo5zYK+Qj3EXRoZtisSbVT00zxAaV8EddY+fN5Avlbwm/JL8ZWFdV9sfrWuPMOVjiCksLPzs2FVIk/ceonZBunnrcoWp2mpCfcW+qZ3+YP+98sQbwbl9FuqMHGPf6GDvV6w6C8sYhpaoqKrORtwWnT/kuY9B7J6iRSwnrD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724210; c=relaxed/simple;
	bh=i5dsOB46Eqq0Gxo+kOSdE52voz+AB/ZgKcaUDceeIIQ=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=J0OBa60y6u1Y3kjVOVIV1+vxEWRVhzkkrju/j4tKrKylMIj40+ZXy1TcLv6+osoqDOOuZ0IPJDsAkZSUnwGXf0EOVuja73FQ1KH++FnRCR36rG3D0TiyjVNuGtx7Jsw1Jx0GKa+CjcCIshVOYv0R7bUyki5QqbeA3HPHE6IxN5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=vJLZDkjR; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=Ai0Lzt9n; arc=none smtp.client-ip=54.240.11.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="vJLZDkjR";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Ai0Lzt9n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1785724207;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=i5dsOB46Eqq0Gxo+kOSdE52voz+AB/ZgKcaUDceeIIQ=;
	b=vJLZDkjREpWiVR84kFuLvyu+AcmVOi2TX6dfwn3AWKGvw0GbnW+NGyp3M5YOf48e
	6c7P3wdrLoskDMb+/Kz5Bl62xjjFfPTjr4bh4EErY+eE2P0wo3U/xpJ/yBHHG/G7yEi
	JdmzDz/osazhn9D8jTWX5nOgJAggRKsteUSjO5f8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1785724207;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=i5dsOB46Eqq0Gxo+kOSdE52voz+AB/ZgKcaUDceeIIQ=;
	b=Ai0Lzt9n9aYvtgoG5Gfa8BuCtQS+z7SeRAModutPGX7JtbZPghkXb7E50Lq1cMbU
	9FmThkO2mfoksp9qIq7d/EwQGtMvdEQWqHhAfAbbxKZfYhlNrhnNLxWE5Iwy5MSAUIR
	fdh/WZZP5tqFeQXGMfZf7RZSoA6vTOfgf0/sVIyo=
Subject: [PATCH V12 11/12] famfs: Report device capacity via statfs so df
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
Date: Mon, 3 Aug 2026 02:30:07 +0000
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
 <20260803023000.75948-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdIu+ovgpm4enMRRGNw8yF9Kn6iwAAFaJl
Thread-Topic: [PATCH V12 11/12] famfs: Report device capacity via statfs so
 df works
X-Wm-Sent-Timestamp: 1785724206
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019fc57500f5-06c293c8-393c-44e3-ad42-d4f4de58245d-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.03-54.240.11.70

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
te: I am the maintainer of drivers/dax/fsdev.c)=0D=0A=0D=0ASigned-off-by:=
 John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/fsdev.c       |=
 19 +++++++++++++++++=0D=0A fs/famfs/famfs_file.c     |  5 +++++=0D=0A fs=
/famfs/famfs_inode.c    | 43 ++++++++++++++++++++++++++++++++++++++-=0D=0A=
 fs/famfs/famfs_internal.h |  8 ++++++++=0D=0A include/linux/dax.h       =
|  1 +=0D=0A 5 files changed, 75 insertions(+), 1 deletion(-)=0D=0A=0D=0A=
diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c=0D=0Aindex 188b252=
6bee4..a5b4b2d79428 100644=0D=0A--- a/drivers/dax/fsdev.c=0D=0A+++ b/driv=
ers/dax/fsdev.c=0D=0A@@ -104,6 +104,25 @@ static size_t fsdev_dax_recover=
y_write(struct dax_device *dax_dev, pgoff_t pgoff=0D=0A =09return _copy_f=
rom_iter_flushcache(addr, bytes, i);=0D=0A }=0D=0A=20=0D=0A+/**=0D=0A+ * =
dax_fsdev_size() - total size in bytes of an fsdev dax device=0D=0A+ * @d=
ax_dev: the dax device (must be bound to this driver)=0D=0A+ *=0D=0A+ * R=
eturns the size cached at probe time (sum of all ranges); it cannot chang=
e=0D=0A+ * while the driver is bound. Only valid for fsdev dax devices - =
callers=0D=0A+ * ensure that (e.g. fs_dax_get() enforces DAXDRV_FSDEV_TYP=
E). Returns 0 if the=0D=0A+ * device is not alive.=0D=0A+ */=0D=0A+u64 da=
x_fsdev_size(struct dax_device *dax_dev)=0D=0A+{=0D=0A+=09struct dev_dax =
*dev_dax =3D dax_get_private(dax_dev);=0D=0A+=0D=0A+=09if (!dev_dax)=0D=0A=
+=09=09return 0;=0D=0A+=09return dev_dax->cached_size;=0D=0A+}=0D=0A+EXPO=
RT_SYMBOL_GPL(dax_fsdev_size);=0D=0A+=0D=0A static const struct dax_opera=
tions dev_dax_ops =3D {=0D=0A =09.direct_access =3D fsdev_dax_direct_acce=
ss,=0D=0A =09.zero_page_range =3D fsdev_dax_zero_page_range,=0D=0Adiff --=
git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c=0D=0Aindex abf049b32a=
4b..5be39d677089 100644=0D=0A--- a/fs/famfs/famfs_file.c=0D=0A+++ b/fs/fa=
mfs/famfs_file.c=0D=0A@@ -280,6 +280,11 @@ famfs_file_init_dax(struct fil=
e *file, void __user *arg)=0D=0A =09}=0D=0A =09inode_unlock(inode);=0D=0A=
=20=0D=0A+=09/* Account the mapped device bytes for statfs (only on succe=
ss) */=0D=0A+=09if (!rc) {=0D=0A+=09=09scoped_guard(rwsem_write, &fsi->st=
ats_sem)=0D=0A+=09=09=09fsi->used_capacity +=3D extent_total;=0D=0A+=09}=0D=
=0A out:=0D=0A =09kvfree(fmap_buf);=0D=0A =09if (meta)=0D=0Adiff --git a/=
fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c=0D=0Aindex 6cbd7d657fd8..=
3c0d1094d653 100644=0D=0A--- a/fs/famfs/famfs_inode.c=0D=0A+++ b/fs/famfs=
/famfs_inode.c=0D=0A@@ -24,6 +24,7 @@=0D=0A #include <linux/iomap.h>=0D=0A=
 #include <linux/path.h>=0D=0A #include <linux/namei.h>=0D=0A+#include <l=
inux/statfs.h>=0D=0A=20=0D=0A #include "famfs_internal.h"=0D=0A=20=0D=0A@=
@ -307,8 +308,37 @@ static void famfs_evict_inode(struct inode *inode)=0D=
=0A =09clear_inode(inode);=0D=0A }=0D=0A=20=0D=0A+/*=0D=0A+ * famfs_statf=
s() - report device capacity and consumption so 'df' works.=0D=0A+ * @tot=
al_capacity is the sum of installed daxdev sizes; @used_capacity is the=0D=
=0A+ * sum of device bytes mapped by fmaps (superblock + log + data files=
). Free is=0D=0A+ * the difference - an approximation of the userspace al=
locator's free space=0D=0A+ * (it ignores allocator gaps / reserved regio=
ns), which is fine for df.=0D=0A+ */=0D=0A+static int famfs_statfs(struct=
 dentry *dentry, struct kstatfs *buf)=0D=0A+{=0D=0A+=09struct famfs_fs_in=
fo *fsi =3D dentry->d_sb->s_fs_info;=0D=0A+=09u64 total, used, free;=0D=0A=
+=0D=0A+=09scoped_guard(rwsem_read, &fsi->stats_sem) {=0D=0A+=09=09total =
=3D fsi->total_capacity;=0D=0A+=09=09used  =3D fsi->used_capacity;=0D=0A+=
=09}=0D=0A+=09free =3D total > used =3F total - used : 0;=0D=0A+=0D=0A+=09=
buf->f_type    =3D FAMFS_SUPER_MAGIC;=0D=0A+=09buf->f_bsize   =3D PAGE_SI=
ZE;=0D=0A+=09buf->f_frsize  =3D PAGE_SIZE;=0D=0A+=09buf->f_blocks  =3D to=
tal >> PAGE_SHIFT;=0D=0A+=09buf->f_bfree   =3D free  >> PAGE_SHIFT;=0D=0A=
+=09buf->f_bavail  =3D free  >> PAGE_SHIFT;=09/* no root reservation */=0D=
=0A+=09buf->f_namelen =3D NAME_MAX;=0D=0A+=09buf->f_fsid    =3D u64_to_fs=
id(huge_encode_dev(dentry->d_sb->s_dev));=0D=0A+=09return 0;=0D=0A+}=0D=0A=
+=0D=0A static const struct super_operations famfs_super_ops =3D {=0D=0A-=
=09.statfs=09=09=3D simple_statfs,=0D=0A+=09.statfs=09=09=3D famfs_statfs=
,=0D=0A =09.drop_inode=09=3D inode_just_drop,=0D=0A =09.show_options=09=3D=
 famfs_show_options,=0D=0A =09.evict_inode    =3D famfs_evict_inode,=0D=0A=
@@ -399,6 +429,7 @@ int famfs_install_daxdev(=0D=0A =09=09const char *nam=
e)=0D=0A {=0D=0A =09struct famfs_daxdev *daxdev;=0D=0A+=09struct dax_devi=
ce *devp =3D NULL;=0D=0A =09int rc =3D 0;=0D=0A=20=0D=0A =09if (index >=3D=
 fsi->dax_devlist->nslots) {=0D=0A@@ -462,6 +493,15 @@ int famfs_install_=
daxdev(=0D=0A=20=0D=0A =09=09wmb(); /* All other fields must be visible b=
efore valid */=0D=0A =09=09daxdev->valid =3D 1;=0D=0A+=09=09devp =3D daxd=
ev->devp;=0D=0A+=09}=0D=0A+=0D=0A+=09/* Freshly installed: add its capaci=
ty to the statfs accounting */=0D=0A+=09if (devp) {=0D=0A+=09=09u64 sz =3D=
 dax_fsdev_size(devp);=0D=0A+=0D=0A+=09=09scoped_guard(rwsem_write, &fsi-=
>stats_sem)=0D=0A+=09=09=09fsi->total_capacity +=3D sz;=0D=0A =09}=0D=0A=20=
=0D=0A =09return 0;=0D=0A@@ -717,6 +757,7 @@ static int famfs_init_fs_con=
text(struct fs_context *fc)=0D=0A =09=09return -ENOMEM;=0D=0A=20=0D=0A =09=
init_rwsem(&fsi->devlist_sem);=0D=0A+=09init_rwsem(&fsi->stats_sem);=0D=0A=
 =09atomic64_set(&fsi->opts, FAMFS_OPT_DEFAULT);=0D=0A =09fsi->mount_opts=
=2Emode =3D FAMFS_DEFAULT_MODE;=0D=0A =09fc->s_fs_info        =3D fsi;=0D=
=0Adiff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h=0D=0A=
index 26873162b4a0..0bf50774fa82 100644=0D=0A--- a/fs/famfs/famfs_interna=
l.h=0D=0A+++ b/fs/famfs/famfs_internal.h=0D=0A@@ -123,6 +123,11 @@ struct=
 famfs_dax_devlist {=0D=0A  *               point, or if other "shutdown"=
 conditions exist=0D=0A  * @dax_devlist: Table of backing daxdevs (slot 0=
 is the mount primary)=0D=0A  * @devlist_sem: Serializes installs into, a=
nd teardown of, @dax_devlist=0D=0A+ * @stats_sem:   Protects the statfs a=
ccounting counters below=0D=0A+ * @total_capacity: Sum of installed daxde=
v sizes, in bytes (grows as daxdevs=0D=0A+ *               are added)=0D=0A=
+ * @used_capacity:  Sum of installed fmap sizes, in bytes (grows as MAP_=
CREATE=0D=0A+ *               attaches fmaps; this is device bytes consum=
ed, not file size)=0D=0A  */=0D=0A struct famfs_fs_info {=0D=0A =09struct=
 famfs_mount_opts   mount_opts;=0D=0A@@ -130,6 +135,9 @@ struct famfs_fs_=
info {=0D=0A =09bool                      deverror;=0D=0A =09struct famfs=
_dax_devlist *dax_devlist;=0D=0A =09struct rw_semaphore       devlist_sem=
;=0D=0A+=09struct rw_semaphore       stats_sem;=0D=0A+=09u64             =
          total_capacity;=0D=0A+=09u64                       used_capacit=
y;=0D=0A };=0D=0A=20=0D=0A /*=0D=0Adiff --git a/include/linux/dax.h b/inc=
lude/linux/dax.h=0D=0Aindex 29113eb95e72..c25ef499d04f 100644=0D=0A--- a/=
include/linux/dax.h=0D=0A+++ b/include/linux/dax.h=0D=0A@@ -256,6 +256,7 =
@@ static inline void dax_break_layout_final(struct inode *inode)=0D=0A=20=
=0D=0A bool dax_alive(struct dax_device *dax_dev);=0D=0A void *dax_get_pr=
ivate(struct dax_device *dax_dev);=0D=0A+u64 dax_fsdev_size(struct dax_de=
vice *dax_dev);=0D=0A int dax_set_ops(struct dax_device *dax_dev, const s=
truct dax_operations *ops);=0D=0A long dax_direct_access(struct dax_devic=
e *dax_dev, pgoff_t pgoff, long nr_pages,=0D=0A =09=09enum dax_access_mod=
e mode, void **kaddr, unsigned long *pfn);=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=
=0A
