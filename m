Received: from a11-174.smtp-out.amazonses.com (a11-174.smtp-out.amazonses.com [54.240.11.174])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D2F235358;
	Sat, 29 Aug 2026 17:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788023588; cv=none; b=j5h56vVa2YyezLByU7McYH8QASfZTpe1uZ6DA0ZQTcVN59PZhpXcd6R+3utCs7Ua6Si9n9vV8sYx0dQkS5TqpGuWU7yEtXsBtCCiVDsGzS3fPMnpClmbWIwZ9HJGbP+z6NpNKPyvilYowx09UfVkhq1dER9rSoU03MvC/Qp4oJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788023588; c=relaxed/simple;
	bh=kd7q6IVkxzSVl28doGbI99YHB4ZDXBcnV08PUG2hj5E=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=R2Rb7lLq8S4SPi+omDQhE924QlWcedproNN8yGcTIv26c5GrGYYLQCjF5MBMx5DvzZtAQEodxZtHGrHdaxHjQmDE6aYAVzm3/jW0eP88JSxp3rIPcyjsjJhvbjSOv36v/BtSxN02ClBwpYj4okybTC1asROcCOoGz9wCh/0twMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=oKr3zjb8; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=fsqG1JDC; arc=none smtp.client-ip=54.240.11.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="oKr3zjb8";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="fsqG1JDC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=rjayupzefgi7e6fmzxcxe4cv4arrjs35; d=jagalactic.com; t=1788023585;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=kd7q6IVkxzSVl28doGbI99YHB4ZDXBcnV08PUG2hj5E=;
	b=oKr3zjb8BHgkR7+20/LCVykNmmjlAQhOMJTabWQFDQRjZFJKAFfAR9gF7O6EYNna
	G4hGfmBM+1xr91qOisIrTVASEQmyTt9ntX7oVoYpBOUAysrDowk4ncUy19JHZUb34Yk
	7uoSvy/4Kakt6gLYPlqWx2gsTTLLJMbl82aPGDrM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1788023585;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=kd7q6IVkxzSVl28doGbI99YHB4ZDXBcnV08PUG2hj5E=;
	b=fsqG1JDCW4AUnSZfg4EWe74A6BJTRbbJaVRfBupdBTU3JvlBMXmX0WUbGGHiFSFm
	3RDesHvk/iMA0mgQSGGqNCo4lLgYvfFhgc3MozT+kiPPnEPVME+/bXbyScahiXkUnd7
	xmP0A0ns/jE9rg1CvNPdXvAJMR0O7BVJe8CA8xGs=
Subject: [PATCH V14 10/12] famfs: Add runtime operation-permission (opts)
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
Date: Sat, 29 Aug 2026 17:13:05 +0000
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
 <20260829171256.7513-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdN9lAfqnLmnnsQyaIwPphM+3eHAAAGagv
Thread-Topic: [PATCH V14 10/12] famfs: Add runtime operation-permission
 (opts) framework
X-Wm-Sent-Timestamp: 1788023583
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <010001a04e82b95e-7243abba-f884-451e-b397-efacec3a87ef-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.29-54.240.11.174

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
=0A=0D=0AReviewed-by: Jeff Layton <jlayton@kernel.org>=0D=0ASigned-off-by=
: John Groves <john@groves.net>=0D=0A---=0D=0A fs/famfs/famfs_file.c     =
       | 59 ++++++++++++++++++++++++++++++++=0D=0A fs/famfs/famfs_inode.c=
           |  1 +=0D=0A fs/famfs/famfs_internal.h        | 30 +++++++++++=
++---=0D=0A include/uapi/linux/famfs_ioctl.h | 45 +++++++++++++++++++++++=
+=0D=0A 4 files changed, 131 insertions(+), 4 deletions(-)=0D=0A=0D=0Adif=
f --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c=0D=0Aindex eba80d=
ab0562..0a6d0392794c 100644=0D=0A--- a/fs/famfs/famfs_file.c=0D=0A+++ b/f=
s/famfs/famfs_file.c=0D=0A@@ -421,6 +421,53 @@ famfs_daxdev_open(struct f=
ile *file, void __user *arg)=0D=0A =09return rc;=0D=0A }=0D=0A=20=0D=0A+/=
**=0D=0A+ * famfs_get_opts() - FAMFSIOC_GET_OPTS: return the permission b=
itmap=0D=0A+ */=0D=0A+static long=0D=0A+famfs_get_opts(struct famfs_fs_in=
fo *fsi, void __user *arg)=0D=0A+{=0D=0A+=09struct famfs_ioc_opts o =3D {=
 .opts =3D atomic64_read(&fsi->opts) };=0D=0A+=0D=0A+=09if (copy_to_user(=
arg, &o, sizeof(o)))=0D=0A+=09=09return -EFAULT;=0D=0A+=0D=0A+=09return 0=
;=0D=0A+}=0D=0A+=0D=0A+/*=0D=0A+ * famfs_modify_opts() - FAMFSIOC_SET_OPT=
S / FAMFSIOC_CLEAR_OPTS=0D=0A+ * @set: true to enable (OR in) the request=
ed bits, false to disable (mask out)=0D=0A+ *=0D=0A+ * The caller supplie=
s a mask of FAMFS_OPT_* bits; the resulting bitmap is=0D=0A+ * returned. =
Requires CAP_SYS_ADMIN since it changes mount-wide policy.=0D=0A+ */=0D=0A=
+static long=0D=0A+famfs_modify_opts(=0D=0A+=09struct famfs_fs_info *fsi,=
=0D=0A+=09void __user *arg,=0D=0A+=09bool set)=0D=0A+{=0D=0A+=09struct fa=
mfs_ioc_opts o;=0D=0A+=0D=0A+=09if (!capable(CAP_SYS_ADMIN))=0D=0A+=09=09=
return -EPERM;=0D=0A+=09if (copy_from_user(&o, arg, sizeof(o)))=0D=0A+=09=
=09return -EFAULT;=0D=0A+=09if (o.opts & ~FAMFS_OPT_ALL)=0D=0A+=09=09retu=
rn -EINVAL;=0D=0A+=0D=0A+=09if (set)=0D=0A+=09=09o.opts =3D atomic64_fetc=
h_or(o.opts, &fsi->opts) | o.opts;=0D=0A+=09else=0D=0A+=09=09o.opts =3D a=
tomic64_fetch_and(~o.opts, &fsi->opts) & ~o.opts;=0D=0A+=0D=0A+=09if (cop=
y_to_user(arg, &o, sizeof(o)))=0D=0A+=09=09return -EFAULT;=0D=0A+=0D=0A+=09=
return 0;=0D=0A+}=0D=0A+=0D=0A /**=0D=0A  * famfs_file_ioctl() - Top-leve=
l famfs file ioctl handler=0D=0A  * @file: the file=0D=0A@@ -442,6 +489,1=
8 @@ famfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long =
arg)=0D=0A =09=09rc =3D 0;=0D=0A =09=09break;=0D=0A=20=0D=0A+=09case FAMF=
SIOC_GET_OPTS:=0D=0A+=09=09rc =3D famfs_get_opts(fsi, (void __user *)arg)=
;=0D=0A+=09=09break;=0D=0A+=0D=0A+=09case FAMFSIOC_SET_OPTS:=0D=0A+=09=09=
rc =3D famfs_modify_opts(fsi, (void __user *)arg, true);=0D=0A+=09=09brea=
k;=0D=0A+=0D=0A+=09case FAMFSIOC_CLEAR_OPTS:=0D=0A+=09=09rc =3D famfs_mod=
ify_opts(fsi, (void __user *)arg, false);=0D=0A+=09=09break;=0D=0A+=0D=0A=
 =09case FAMFSIOC_DAXDEV_OPEN:=0D=0A =09=09rc =3D famfs_daxdev_open(file,=
 (void __user *)arg);=0D=0A =09=09break;=0D=0Adiff --git a/fs/famfs/famfs=
_inode.c b/fs/famfs/famfs_inode.c=0D=0Aindex 98c877a6009e..2f1938adbfbc 1=
00644=0D=0A--- a/fs/famfs/famfs_inode.c=0D=0A+++ b/fs/famfs/famfs_inode.c=
=0D=0A@@ -769,6 +769,7 @@ famfs_init_fs_context(struct fs_context *fc)=0D=
=0A =09=09return -ENOMEM;=0D=0A=20=0D=0A =09init_rwsem(&fsi->devlist_sem)=
;=0D=0A+=09atomic64_set(&fsi->opts, FAMFS_OPT_DEFAULT);=0D=0A =09fsi->mou=
nt_opts.mode =3D FAMFS_DEFAULT_MODE;=0D=0A =09fc->s_fs_info        =3D fs=
i;=0D=0A =09fc->ops              =3D &famfs_context_ops;=0D=0Adiff --git =
a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h=0D=0Aindex f17380=
d24f6d..5e043b5a0ddd 100644=0D=0A--- a/fs/famfs/famfs_internal.h=0D=0A+++=
 b/fs/famfs/famfs_internal.h=0D=0A@@ -12,11 +12,24 @@=0D=0A #define FAMFS=
_INTERNAL_H=0D=0A=20=0D=0A #include <linux/rwsem.h>=0D=0A+#include <linux=
/atomic.h>=0D=0A #include <linux/bits.h>=0D=0A #include <linux/build_bug.=
h>=0D=0A=20=0D=0A #include <linux/famfs_ioctl.h>=0D=0A=20=0D=0A+/*=0D=0A+=
 * Default operation-permission bitmap (see FAMFS_OPT_* in the uapi heade=
r).=0D=0A+ * This preserves famfs's historical behavior: file/dir creatio=
n, the fmap=0D=0A+ * ioctl, data writes, and the non-resize setattr compo=
nents are permitted;=0D=0A+ * unlink of mapped files, link, symlink, mkno=
d, rmdir, rename and truncate=0D=0A+ * are denied until enabled via FAMFS=
IOC_SET_OPTS.=0D=0A+ */=0D=0A+#define FAMFS_OPT_DEFAULT=09(FAMFS_OPT_CREA=
TE | FAMFS_OPT_MKDIR | \=0D=0A+=09=09=09=09 FAMFS_OPT_CHMOD | FAMFS_OPT_C=
HOWN | \=0D=0A+=09=09=09=09 FAMFS_OPT_UTIMES | FAMFS_OPT_WRITE | \=0D=0A+=
=09=09=09=09 FAMFS_OPT_MAP_CREATE)=0D=0A+=0D=0A extern const struct file_=
operations famfs_file_operations;=0D=0A=20=0D=0A /*=0D=0A@@ -104,6 +117,8=
 @@ struct famfs_dax_devlist {=0D=0A  * @famfs_fs_info=0D=0A  *=0D=0A  * =
@mount_opts:  The mount options=0D=0A+ * @opts:        Operation-permissi=
on bitmap (FAMFS_OPT_*), adjusted at runtime=0D=0A+ *               via t=
he FAMFSIOC_{GET,SET,CLEAR}_OPTS ioctls=0D=0A  * @deverror:    True if th=
e dax device has called our notify_failure entry=0D=0A  *               p=
oint, or if other "shutdown" conditions exist=0D=0A  * @dax_devlist: Tabl=
e of backing daxdevs (slot 0 is the mount primary)=0D=0A@@ -111,16 +126,2=
3 @@ struct famfs_dax_devlist {=0D=0A  */=0D=0A struct famfs_fs_info {=0D=
=0A =09struct famfs_mount_opts   mount_opts;=0D=0A+=09atomic64_t         =
       opts;=0D=0A =09bool                      deverror;=0D=0A =09struct=
 famfs_dax_devlist *dax_devlist;=0D=0A =09struct rw_semaphore       devli=
st_sem;=0D=0A };=0D=0A=20=0D=0A-/* This stub will be replaced in a later =
commit=0D=0A- * Note: the opt parameter is intentionally unused, and will=
 be used by=0D=0A- * the replacement function when that commit lands=0D=0A=
+/*=0D=0A+ * famfs_opt_enabled() - is operation permission @opt enabled f=
or this mount=3F=0D=0A+ *=0D=0A+ * @opt is a single FAMFS_OPT_* bit; retu=
rns true if that operation is=0D=0A+ * permitted. The bitmap is read lock=
lessly (updated via atomic RMW by the=0D=0A+ * FAMFSIOC_{SET,CLEAR}_OPTS =
ioctls).=0D=0A  */=0D=0A-#define famfs_opt_enabled(fsi, opt) (fsi !=3D 0)=
=0D=0A+static inline bool famfs_opt_enabled(struct famfs_fs_info *fsi, u6=
4 opt)=0D=0A+{=0D=0A+=09return !!(atomic64_read(&fsi->opts) & opt);=0D=0A=
+}=0D=0A=20=0D=0A int famfs_lookup_daxdev(const char *pathname, dev_t *de=
vno);=0D=0A int famfs_devlist_alloc(struct famfs_fs_info *fsi);=0D=0Adiff=
 --git a/include/uapi/linux/famfs_ioctl.h b/include/uapi/linux/famfs_ioct=
l.h=0D=0Aindex 751d8b033c2e..efe6ef263975 100644=0D=0A--- a/include/uapi/=
linux/famfs_ioctl.h=0D=0A+++ b/include/uapi/linux/famfs_ioctl.h=0D=0A@@ -=
100,6 +100,48 @@ struct famfs_ioc_daxdev {=0D=0A =09__u32 flags;=0D=0A };=
=0D=0A=20=0D=0A+/*=0D=0A+ * Mount-wide operation permissions, queried and=
 modified via the=0D=0A+ * FAMFSIOC_{GET,SET,CLEAR}_OPTS ioctls. A set bi=
t means the operation is=0D=0A+ * permitted; a clear bit means it is reje=
cted with -EPERM. famfs denies most=0D=0A+ * of these by default because =
the userspace log, not the kernel, is=0D=0A+ * authoritative for a famfs =
instance.=0D=0A+ */=0D=0A+#define FAMFS_OPT_CREATE=09(1ULL << 0)  /* crea=
te a regular file        */=0D=0A+#define FAMFS_OPT_MKDIR=09=09(1ULL << 1=
)  /* mkdir                        */=0D=0A+#define FAMFS_OPT_MKNOD=09=09=
(1ULL << 2)  /* mknod a special file         */=0D=0A+#define FAMFS_OPT_S=
YMLINK=09(1ULL << 3)  /* create a symlink             */=0D=0A+#define FA=
MFS_OPT_LINK=09=09(1ULL << 4)  /* hard link                    */=0D=0A+#=
define FAMFS_OPT_UNLINK=09(1ULL << 5)  /* unlink a mapped file         */=
=0D=0A+#define FAMFS_OPT_RMDIR=09=09(1ULL << 6)  /* rmdir                =
        */=0D=0A+#define FAMFS_OPT_RENAME=09(1ULL << 7)  /* rename       =
                */=0D=0A+#define FAMFS_OPT_CHMOD=09=09(1ULL << 8)  /* set=
attr ATTR_MODE            */=0D=0A+#define FAMFS_OPT_CHOWN=09=09(1ULL << =
9)  /* setattr ATTR_UID / ATTR_GID  */=0D=0A+#define FAMFS_OPT_TRUNCATE=09=
(1ULL << 10) /* setattr ATTR_SIZE (resize)   */=0D=0A+#define FAMFS_OPT_U=
TIMES=09(1ULL << 11) /* setattr ATTR_ATIME/ATTR_MTIME*/=0D=0A+#define FAM=
FS_OPT_WRITE=09=09(1ULL << 12) /* write file data              */=0D=0A+#=
define FAMFS_OPT_XATTR=09=09(1ULL << 13) /* set/remove xattrs (reserved) =
*/=0D=0A+#define FAMFS_OPT_MAP_CREATE=09(1ULL << 14) /* attach an fmap (M=
AP_CREATE)  */=0D=0A+=0D=0A+#define FAMFS_OPT_ALL=09=09(FAMFS_OPT_CREATE =
| FAMFS_OPT_MKDIR | \=0D=0A+=09=09=09=09 FAMFS_OPT_MKNOD | FAMFS_OPT_SYML=
INK | \=0D=0A+=09=09=09=09 FAMFS_OPT_LINK | FAMFS_OPT_UNLINK | \=0D=0A+=09=
=09=09=09 FAMFS_OPT_RMDIR | FAMFS_OPT_RENAME | \=0D=0A+=09=09=09=09 FAMFS=
_OPT_CHMOD | FAMFS_OPT_CHOWN | \=0D=0A+=09=09=09=09 FAMFS_OPT_TRUNCATE | =
FAMFS_OPT_UTIMES | \=0D=0A+=09=09=09=09 FAMFS_OPT_WRITE | FAMFS_OPT_XATTR=
 | \=0D=0A+=09=09=09=09 FAMFS_OPT_MAP_CREATE)=0D=0A+=0D=0A+/**=0D=0A+ * s=
truct famfs_ioc_opts - operation-permission bitmap=0D=0A+ * @opts: for GE=
T, the current bitmap is returned here. For SET/CLEAR, the=0D=0A+ *      =
  caller-supplied mask of bits to enable/disable on input, and the=0D=0A+=
 *        resulting bitmap on return.=0D=0A+ */=0D=0A+struct famfs_ioc_op=
ts {=0D=0A+=09__u64 opts;=0D=0A+};=0D=0A+=0D=0A #define FAMFSIOC_MAGIC 'u=
'=0D=0A=20=0D=0A /* famfs file ioctl opcodes */=0D=0A@@ -111,5 +153,8 @@ =
struct famfs_ioc_daxdev {=0D=0A  */=0D=0A #define FAMFSIOC_MAP_CREATE    =
_IOW(FAMFSIOC_MAGIC,  0x51, struct famfs_ioc_fmap_header)=0D=0A #define F=
AMFSIOC_DAXDEV_OPEN   _IOW(FAMFSIOC_MAGIC,  0x52, struct famfs_ioc_daxdev=
)=0D=0A+#define FAMFSIOC_GET_OPTS      _IOR(FAMFSIOC_MAGIC,  0x53, struct=
 famfs_ioc_opts)=0D=0A+#define FAMFSIOC_SET_OPTS      _IOWR(FAMFSIOC_MAGI=
C, 0x54, struct famfs_ioc_opts)=0D=0A+#define FAMFSIOC_CLEAR_OPTS    _IOW=
R(FAMFSIOC_MAGIC, 0x55, struct famfs_ioc_opts)=0D=0A=20=0D=0A #endif /* F=
AMFS_IOCTL_H */=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
