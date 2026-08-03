Received: from a10-27.smtp-out.amazonses.com (a10-27.smtp-out.amazonses.com [54.240.10.27])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11862FE582;
	Mon,  3 Aug 2026 02:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.10.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724200; cv=none; b=FhRnQbH+MMmLIgyrKOwC46okA72t83Cp5U8nJlNFT98Ds14xrN6AX1g8Fy2mX7IEsu5/Fvb4bKhT+1aA9mVTzQuk2fuGSLHrucSwaycSRJruyP7LSvRrzBwOxV6XPhh4pZNXNqlUNDB3OEMMKOs3IK5v1WHBsXWDX1Fey9RKvjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724200; c=relaxed/simple;
	bh=of+uIkxCEgq9zuUws+mnYMKmsZcxOS4C5l5kHQ5Z2vc=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=s42z1tW1CRqF4IQqAQeI0Xt3D24n4BLmA4uDiQ5r4K/U0YYnsRaXIBaH5epn8Gs1huraS1QYLrvQwDRi1hjPKh2Q9otsh6PyxstDFJ1yfsmqPEnLwuPXiFAbLWFx9UUqP6ikjifHY2mjIiXzkmrXjx4mrQpFH2qvNhz7BqH0JnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=tTCMdVQN; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=PcWuoFQy; arc=none smtp.client-ip=54.240.10.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="tTCMdVQN";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="PcWuoFQy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1785724197;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=of+uIkxCEgq9zuUws+mnYMKmsZcxOS4C5l5kHQ5Z2vc=;
	b=tTCMdVQNjn2cIR3B4n1Zmn5GlGP9EIwFoP3StuEynXbpB9FVcjRuKL5dRby8Ba4h
	5O2YRE8Q3U94xGbxSjPIPcYXWJ+2GBDvge5mVoulGvUJiXxHh0BWeVl0PjWra1M2kpU
	r5bAlPCojKy8eI0yEYE9bNPA+8dNVx60mMBLdM9I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1785724197;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=of+uIkxCEgq9zuUws+mnYMKmsZcxOS4C5l5kHQ5Z2vc=;
	b=PcWuoFQyCoPs1KConDLfhJI6Xhi4BFUUj2zIq+r9Pt/XOGoFiJkFhh5Uh/0higSL
	CdiC6sZ5qICzdS9eqcAQvV6V2iCY9fZci7bpufckX1ocAX8k4CrYHuYzNiig46Gl/nZ
	poXld5S7D1NGK4wthIjYvEtHf/CycA38sTKKxRSQ=
Subject: [PATCH V12 10/12] famfs: Add runtime operation-permission (opts)
 framework
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
Date: Mon, 3 Aug 2026 02:29:57 +0000
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
 <20260803022950.75930-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdIu+ovgpm4enMRRGNw8yF9Kn6iwAAFDPH
Thread-Topic: [PATCH V12 10/12] famfs: Add runtime operation-permission
 (opts) framework
X-Wm-Sent-Timestamp: 1785724196
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019fc574dabe-572d99fc-3bb0-421a-afec-05432de2a757-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.03-54.240.10.27

From: John Groves <John@Groves.net>=0D=0A=0D=0Afamfs denies most namespac=
e, attribute and data operations by default=0D=0Abecause the userspace lo=
g, not the kernel, is authoritative for a famfs=0D=0Ainstance. Earlier co=
mmits already guard each such operation with a=0D=0Afamfs_opt_enabled(fsi=
, FAMFS_OPT_x) check backed by a permissive stub. This=0D=0Acommit define=
s the permission bitmap and makes those checks live.=0D=0A=0D=0AAdd:=0D=0A=
 - FAMFS_OPT_* (uapi): a u64 permission bitmap, one bit per gated operati=
on=0D=0A   (create, mkdir, mknod, symlink, link, unlink, rmdir, rename, t=
he four=0D=0A   setattr components, data write, and MAP_CREATE), plus FAM=
FS_OPT_ALL. The=0D=0A   FAMFS_OPT_XATTR bit is reserved - famfs has no xa=
ttr ops yet.=0D=0A - fsi->opts: a per-mount atomic64 bitmap initialized t=
o FAMFS_OPT_DEFAULT,=0D=0A   which sets famfs's default policy: create, m=
kdir, chmod, chown, utimes,=0D=0A   write and MAP_CREATE are permitted; u=
nlink of mapped files, link,=0D=0A   symlink, mknod, rmdir, rename and tr=
uncate are denied.=0D=0A - the real famfs_opt_enabled() (replacing the st=
ub), so every planted gate=0D=0A   now consults fsi->opts.=0D=0A - FAMFSI=
OC_{GET,SET,CLEAR}_OPTS: read the bitmap, or enable/disable the=0D=0A   b=
its set in a caller-supplied mask, returning the resulting bitmap.=0D=0A =
  SET/CLEAR require CAP_SYS_ADMIN and reject unknown bits with -EINVAL;=0D=
=0A   the bitmap is updated with atomic RMW so the checks stay lockless.=0D=
=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A fs/famfs/f=
amfs_file.c            | 55 ++++++++++++++++++++++++++++++++=0D=0A fs/fam=
fs/famfs_inode.c           |  1 +=0D=0A fs/famfs/famfs_internal.h        =
| 30 ++++++++++++++---=0D=0A include/uapi/linux/famfs_ioctl.h | 45 ++++++=
++++++++++++++++++++=0D=0A 4 files changed, 127 insertions(+), 4 deletion=
s(-)=0D=0A=0D=0Adiff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.=
c=0D=0Aindex e11a55ecf8d7..abf049b32a4b 100644=0D=0A--- a/fs/famfs/famfs_=
file.c=0D=0A+++ b/fs/famfs/famfs_file.c=0D=0A@@ -357,6 +357,49 @@ famfs_d=
axdev_open(struct file *file, void __user *arg)=0D=0A =09return rc;=0D=0A=
 }=0D=0A=20=0D=0A+/**=0D=0A+ * famfs_get_opts() - FAMFSIOC_GET_OPTS: retu=
rn the permission bitmap=0D=0A+ */=0D=0A+static long famfs_get_opts(struc=
t famfs_fs_info *fsi, void __user *arg)=0D=0A+{=0D=0A+=09struct famfs_ioc=
_opts o =3D { .opts =3D atomic64_read(&fsi->opts) };=0D=0A+=0D=0A+=09if (=
copy_to_user(arg, &o, sizeof(o)))=0D=0A+=09=09return -EFAULT;=0D=0A+=0D=0A=
+=09return 0;=0D=0A+}=0D=0A+=0D=0A+/*=0D=0A+ * famfs_modify_opts() - FAMF=
SIOC_SET_OPTS / FAMFSIOC_CLEAR_OPTS=0D=0A+ * @set: true to enable (OR in)=
 the requested bits, false to disable (mask out)=0D=0A+ *=0D=0A+ * The ca=
ller supplies a mask of FAMFS_OPT_* bits; the resulting bitmap is=0D=0A+ =
* returned. Requires CAP_SYS_ADMIN since it changes mount-wide policy.=0D=
=0A+ */=0D=0A+static long famfs_modify_opts(struct famfs_fs_info *fsi, vo=
id __user *arg,=0D=0A+=09=09=09      bool set)=0D=0A+{=0D=0A+=09struct fa=
mfs_ioc_opts o;=0D=0A+=0D=0A+=09if (!capable(CAP_SYS_ADMIN))=0D=0A+=09=09=
return -EPERM;=0D=0A+=09if (copy_from_user(&o, arg, sizeof(o)))=0D=0A+=09=
=09return -EFAULT;=0D=0A+=09if (o.opts & ~FAMFS_OPT_ALL)=0D=0A+=09=09retu=
rn -EINVAL;=0D=0A+=0D=0A+=09if (set)=0D=0A+=09=09o.opts =3D atomic64_fetc=
h_or(o.opts, &fsi->opts) | o.opts;=0D=0A+=09else=0D=0A+=09=09o.opts =3D a=
tomic64_fetch_and(~o.opts, &fsi->opts) & ~o.opts;=0D=0A+=0D=0A+=09if (cop=
y_to_user(arg, &o, sizeof(o)))=0D=0A+=09=09return -EFAULT;=0D=0A+=0D=0A+=09=
return 0;=0D=0A+}=0D=0A+=0D=0A /**=0D=0A  * famfs_file_ioctl() - Top-leve=
l famfs file ioctl handler=0D=0A  * @file: the file=0D=0A@@ -378,6 +421,1=
8 @@ famfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long =
arg)=0D=0A =09=09rc =3D 0;=0D=0A =09=09break;=0D=0A=20=0D=0A+=09case FAMF=
SIOC_GET_OPTS:=0D=0A+=09=09rc =3D famfs_get_opts(fsi, (void __user *)arg)=
;=0D=0A+=09=09break;=0D=0A+=0D=0A+=09case FAMFSIOC_SET_OPTS:=0D=0A+=09=09=
rc =3D famfs_modify_opts(fsi, (void __user *)arg, true);=0D=0A+=09=09brea=
k;=0D=0A+=0D=0A+=09case FAMFSIOC_CLEAR_OPTS:=0D=0A+=09=09rc =3D famfs_mod=
ify_opts(fsi, (void __user *)arg, false);=0D=0A+=09=09break;=0D=0A+=0D=0A=
 =09case FAMFSIOC_DAXDEV_OPEN:=0D=0A =09=09rc =3D famfs_daxdev_open(file,=
 (void __user *)arg);=0D=0A =09=09break;=0D=0Adiff --git a/fs/famfs/famfs=
_inode.c b/fs/famfs/famfs_inode.c=0D=0Aindex a6c3b4574e69..6cbd7d657fd8 1=
00644=0D=0A--- a/fs/famfs/famfs_inode.c=0D=0A+++ b/fs/famfs/famfs_inode.c=
=0D=0A@@ -717,6 +717,7 @@ static int famfs_init_fs_context(struct fs_cont=
ext *fc)=0D=0A =09=09return -ENOMEM;=0D=0A=20=0D=0A =09init_rwsem(&fsi->d=
evlist_sem);=0D=0A+=09atomic64_set(&fsi->opts, FAMFS_OPT_DEFAULT);=0D=0A =
=09fsi->mount_opts.mode =3D FAMFS_DEFAULT_MODE;=0D=0A =09fc->s_fs_info   =
     =3D fsi;=0D=0A =09fc->ops              =3D &famfs_context_ops;=0D=0A=
diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h=0D=0Ai=
ndex b5f9c8d0349f..26873162b4a0 100644=0D=0A--- a/fs/famfs/famfs_internal=
=2Eh=0D=0A+++ b/fs/famfs/famfs_internal.h=0D=0A@@ -12,11 +12,24 @@=0D=0A =
#define FAMFS_INTERNAL_H=0D=0A=20=0D=0A #include <linux/rwsem.h>=0D=0A+#i=
nclude <linux/atomic.h>=0D=0A #include <linux/bits.h>=0D=0A #include <lin=
ux/build_bug.h>=0D=0A=20=0D=0A #include <linux/famfs_ioctl.h>=0D=0A=20=0D=
=0A+/*=0D=0A+ * Default operation-permission bitmap (see FAMFS_OPT_* in t=
he uapi header).=0D=0A+ * This preserves famfs's historical behavior: fil=
e/dir creation, the fmap=0D=0A+ * ioctl, data writes, and the non-resize =
setattr components are permitted;=0D=0A+ * unlink of mapped files, link, =
symlink, mknod, rmdir, rename and truncate=0D=0A+ * are denied until enab=
led via FAMFSIOC_SET_OPTS.=0D=0A+ */=0D=0A+#define FAMFS_OPT_DEFAULT=09(F=
AMFS_OPT_CREATE | FAMFS_OPT_MKDIR | \=0D=0A+=09=09=09=09 FAMFS_OPT_CHMOD =
| FAMFS_OPT_CHOWN | \=0D=0A+=09=09=09=09 FAMFS_OPT_UTIMES | FAMFS_OPT_WRI=
TE | \=0D=0A+=09=09=09=09 FAMFS_OPT_MAP_CREATE)=0D=0A+=0D=0A extern const=
 struct file_operations famfs_file_operations;=0D=0A=20=0D=0A /*=0D=0A@@ =
-104,6 +117,8 @@ struct famfs_dax_devlist {=0D=0A  * @famfs_fs_info=0D=0A=
  *=0D=0A  * @mount_opts:  The mount options=0D=0A+ * @opts:        Opera=
tion-permission bitmap (FAMFS_OPT_*), adjusted at runtime=0D=0A+ *       =
        via the FAMFSIOC_{GET,SET,CLEAR}_OPTS ioctls=0D=0A  * @deverror: =
   True if the dax device has called our notify_failure entry=0D=0A  *   =
            point, or if other "shutdown" conditions exist=0D=0A  * @dax_=
devlist: Table of backing daxdevs (slot 0 is the mount primary)=0D=0A@@ -=
111,16 +126,23 @@ struct famfs_dax_devlist {=0D=0A  */=0D=0A struct famfs=
_fs_info {=0D=0A =09struct famfs_mount_opts   mount_opts;=0D=0A+=09atomic=
64_t                opts;=0D=0A =09bool                      deverror;=0D=
=0A =09struct famfs_dax_devlist *dax_devlist;=0D=0A =09struct rw_semaphor=
e       devlist_sem;=0D=0A };=0D=0A=20=0D=0A-/* This stub will be replace=
d in a later commit=20=0D=0A- * Note: the opt parameter is intentionally =
unused, and will be used by=0D=0A- * the replacement function when that c=
ommit lands=0D=0A+/*=0D=0A+ * famfs_opt_enabled() - is operation permissi=
on @opt enabled for this mount=3F=0D=0A+ *=0D=0A+ * @opt is a single FAMF=
S_OPT_* bit; returns true if that operation is=0D=0A+ * permitted. The bi=
tmap is read locklessly (updated via atomic RMW by the=0D=0A+ * FAMFSIOC_=
{SET,CLEAR}_OPTS ioctls).=0D=0A  */=0D=0A-#define famfs_opt_enabled(fsi, =
opt) (fsi !=3D 0)=0D=0A+static inline bool famfs_opt_enabled(struct famfs=
_fs_info *fsi, u64 opt)=0D=0A+{=0D=0A+=09return !!(atomic64_read(&fsi->op=
ts) & opt);=0D=0A+}=0D=0A=20=0D=0A int lookup_daxdev(const char *pathname=
, dev_t *devno);=0D=0A int famfs_devlist_alloc(struct famfs_fs_info *fsi)=
;=0D=0Adiff --git a/include/uapi/linux/famfs_ioctl.h b/include/uapi/linux=
/famfs_ioctl.h=0D=0Aindex 751d8b033c2e..efe6ef263975 100644=0D=0A--- a/in=
clude/uapi/linux/famfs_ioctl.h=0D=0A+++ b/include/uapi/linux/famfs_ioctl.=
h=0D=0A@@ -100,6 +100,48 @@ struct famfs_ioc_daxdev {=0D=0A =09__u32 flag=
s;=0D=0A };=0D=0A=20=0D=0A+/*=0D=0A+ * Mount-wide operation permissions, =
queried and modified via the=0D=0A+ * FAMFSIOC_{GET,SET,CLEAR}_OPTS ioctl=
s. A set bit means the operation is=0D=0A+ * permitted; a clear bit means=
 it is rejected with -EPERM. famfs denies most=0D=0A+ * of these by defau=
lt because the userspace log, not the kernel, is=0D=0A+ * authoritative f=
or a famfs instance.=0D=0A+ */=0D=0A+#define FAMFS_OPT_CREATE=09(1ULL << =
0)  /* create a regular file        */=0D=0A+#define FAMFS_OPT_MKDIR=09=09=
(1ULL << 1)  /* mkdir                        */=0D=0A+#define FAMFS_OPT_M=
KNOD=09=09(1ULL << 2)  /* mknod a special file         */=0D=0A+#define F=
AMFS_OPT_SYMLINK=09(1ULL << 3)  /* create a symlink             */=0D=0A+=
#define FAMFS_OPT_LINK=09=09(1ULL << 4)  /* hard link                    =
*/=0D=0A+#define FAMFS_OPT_UNLINK=09(1ULL << 5)  /* unlink a mapped file =
        */=0D=0A+#define FAMFS_OPT_RMDIR=09=09(1ULL << 6)  /* rmdir      =
                  */=0D=0A+#define FAMFS_OPT_RENAME=09(1ULL << 7)  /* ren=
ame                       */=0D=0A+#define FAMFS_OPT_CHMOD=09=09(1ULL << =
8)  /* setattr ATTR_MODE            */=0D=0A+#define FAMFS_OPT_CHOWN=09=09=
(1ULL << 9)  /* setattr ATTR_UID / ATTR_GID  */=0D=0A+#define FAMFS_OPT_T=
RUNCATE=09(1ULL << 10) /* setattr ATTR_SIZE (resize)   */=0D=0A+#define F=
AMFS_OPT_UTIMES=09(1ULL << 11) /* setattr ATTR_ATIME/ATTR_MTIME*/=0D=0A+#=
define FAMFS_OPT_WRITE=09=09(1ULL << 12) /* write file data              =
*/=0D=0A+#define FAMFS_OPT_XATTR=09=09(1ULL << 13) /* set/remove xattrs (=
reserved) */=0D=0A+#define FAMFS_OPT_MAP_CREATE=09(1ULL << 14) /* attach =
an fmap (MAP_CREATE)  */=0D=0A+=0D=0A+#define FAMFS_OPT_ALL=09=09(FAMFS_O=
PT_CREATE | FAMFS_OPT_MKDIR | \=0D=0A+=09=09=09=09 FAMFS_OPT_MKNOD | FAMF=
S_OPT_SYMLINK | \=0D=0A+=09=09=09=09 FAMFS_OPT_LINK | FAMFS_OPT_UNLINK | =
\=0D=0A+=09=09=09=09 FAMFS_OPT_RMDIR | FAMFS_OPT_RENAME | \=0D=0A+=09=09=09=
=09 FAMFS_OPT_CHMOD | FAMFS_OPT_CHOWN | \=0D=0A+=09=09=09=09 FAMFS_OPT_TR=
UNCATE | FAMFS_OPT_UTIMES | \=0D=0A+=09=09=09=09 FAMFS_OPT_WRITE | FAMFS_=
OPT_XATTR | \=0D=0A+=09=09=09=09 FAMFS_OPT_MAP_CREATE)=0D=0A+=0D=0A+/**=0D=
=0A+ * struct famfs_ioc_opts - operation-permission bitmap=0D=0A+ * @opts=
: for GET, the current bitmap is returned here. For SET/CLEAR, the=0D=0A+=
 *        caller-supplied mask of bits to enable/disable on input, and th=
e=0D=0A+ *        resulting bitmap on return.=0D=0A+ */=0D=0A+struct famf=
s_ioc_opts {=0D=0A+=09__u64 opts;=0D=0A+};=0D=0A+=0D=0A #define FAMFSIOC_=
MAGIC 'u'=0D=0A=20=0D=0A /* famfs file ioctl opcodes */=0D=0A@@ -111,5 +1=
53,8 @@ struct famfs_ioc_daxdev {=0D=0A  */=0D=0A #define FAMFSIOC_MAP_CR=
EATE    _IOW(FAMFSIOC_MAGIC,  0x51, struct famfs_ioc_fmap_header)=0D=0A #=
define FAMFSIOC_DAXDEV_OPEN   _IOW(FAMFSIOC_MAGIC,  0x52, struct famfs_io=
c_daxdev)=0D=0A+#define FAMFSIOC_GET_OPTS      _IOR(FAMFSIOC_MAGIC,  0x53=
, struct famfs_ioc_opts)=0D=0A+#define FAMFSIOC_SET_OPTS      _IOWR(FAMFS=
IOC_MAGIC, 0x54, struct famfs_ioc_opts)=0D=0A+#define FAMFSIOC_CLEAR_OPTS=
    _IOWR(FAMFSIOC_MAGIC, 0x55, struct famfs_ioc_opts)=0D=0A=20=0D=0A #en=
dif /* FAMFS_IOCTL_H */=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
