Received: from a11-132.smtp-out.amazonses.com (a11-132.smtp-out.amazonses.com [54.240.11.132])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F197139AD25;
	Mon, 20 Jul 2026 03:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519177; cv=none; b=Dmfe+EKolv3LsHZJ/EdFq5fTbFQJX4HpXbjeEd1XROvUHURVyfph1sYtbUJvmGh5iu9Yu9FzeWZ4JZ0r3c2K6ppcDG3UU/ZpDyzAJz2kznTxB84mF1Z2j4XR0GnD2WDtpG60S+vhdNnWxcY8bUo1deEcxFgF3covAK3fVAi1aIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519177; c=relaxed/simple;
	bh=7Xjn9p4RBEFPzdEkqx62v9badRWqTIZCs4Uzga11bxA=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=Lgp8Eece168rvuAoJBFN8q1gfl+FaHA+EWCL/q4+oc7I7PG2cJxUY9NxEudBl4bcSHuxvmJTl637DerBAlSKElGH8+lEX6u2dzPkD+TIlYzMQHY2am9wImmEIs8I0w5gj0KgvY0fFOxNMurhrmXUBxRNxrJyb1WzmqFrlAwYJTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=iM9A6Jso; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=i1V7Rsji; arc=none smtp.client-ip=54.240.11.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="iM9A6Jso";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="i1V7Rsji"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1784519173;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=7Xjn9p4RBEFPzdEkqx62v9badRWqTIZCs4Uzga11bxA=;
	b=iM9A6Jso8hyI9lez8Kef3WUOUx6FlagrPlHo0Yuwcf0Jyoho3vUWthvBRq4keQy/
	2HI6cVRpUuc90xrgW/zEZSmUXnCHt+qagEFurANdDFLL/viTYQdl9sge+mDTxxX1KpE
	eXoDIqTWepjSvpSMBZtITAtFuKUBCiLns3T6pLyc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1784519173;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=7Xjn9p4RBEFPzdEkqx62v9badRWqTIZCs4Uzga11bxA=;
	b=i1V7RsjiKWJUgGHAt/slEoFpt+QoKAadFVoQVO1ZFNVjPqvaW12ztfg6lrm7dmG5
	9oPupy5zIy7IywOjZI5p4O/3RGZLVmzF2mqiRd7TvqNXARTDWyzHiNwf3fprAdKIGvI
	bRprE4vESdGlNrF08Ji6O+QNzrA/gyZs43Dh5jWg=
Subject: [PATCH V11 5/9] famfs_fuse: register fs-dax daxdevs via
 FUSE_DEV_IOC_DAXDEV_OPEN
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>, 
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
	=?UTF-8?Q?Andrew_Morton?= <akpm@linux-foundation.org>, 
	=?UTF-8?Q?Namjae_Jeon?= <linkinjeon@kernel.org>, 
	=?UTF-8?Q?Lorenzo_Stoakes?= <ljs@kernel.org>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40micron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2E?= =?UTF-8?Q?org?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2E?= =?UTF-8?Q?linux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40v?= =?UTF-8?Q?ger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?fuse-devel=40lists=2Elinux=2E?= =?UTF-8?Q?dev?= <fuse-devel@lists.linux.dev>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Mon, 20 Jul 2026 03:46:13 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
References: 
 <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com> 
 <20260720034603.68815-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdF/oEAFJtLKnZRyOlO7hUjUgWYwAAEp6M
Thread-Topic: [PATCH V11 5/9] famfs_fuse: register fs-dax daxdevs via
 FUSE_DEV_IOC_DAXDEV_OPEN
X-Wm-Sent-Timestamp: 1784519172
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019f7da1a534-2fc6658c-4f30-4cc6-b010-5e3f8fd7164b-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.07.20-54.240.11.132

From: John Groves <john@groves.net>=0D=0A=0D=0AAdd a dedicated ioctl, FUS=
E_DEV_IOC_DAXDEV_OPEN, by which a fuse server=0D=0Aregisters the devdax d=
evices that back an fs-dax (famfs) filesystem: the=0D=0Aserver hands the =
kernel an fd to a /dev/daxN.N device plus its=0D=0Acluster-invariant famf=
s index.=0D=0A=0D=0AA dedicated ioctl, rather than overloading FUSE_DEV_I=
OC_BACKING_OPEN,=0D=0Aavoids a dependency on CONFIG_FUSE_PASSTHROUGH and =
the backing-file=0D=0Amachinery, which famfs does not use.=0D=0A=0D=0A- s=
truct fuse_backing_map is reused as the argument; the index rides on=0D=0A=
  the reserved 'padding' field (daxdev_index).=0D=0A- fuse_dev_ioctl_daxd=
ev_open() copies the map and calls=0D=0A  famfs_daxdev_open(), which reso=
lves the fd to a dax device by its inode=0D=0A  i_rdev. The daxdev table =
store is added in the following patch.=0D=0A=0D=0AAccess control:=0D=0A=0D=
=0A- The ioctl is gated on famfs mode (enabled at FUSE_INIT only when the=
=0D=0A  server held CAP_SYS_RAWIO), and additionally re-checks=0D=0A  cap=
able(CAP_SYS_RAWIO) on each call. The famfs-mode flag attests only=0D=0A =
 to the session founder's privilege; the fuse device fd may be inherited=0D=
=0A  across fork() or SCM_RIGHTS-passed to a less-privileged task, so the=
=0D=0A  capability is re-checked against the task actually performing the=
=0D=0A  registration.=0D=0A- famfs_daxdev_open() resolves the fd with fge=
t(), not fget_raw(), so=0D=0A  O_PATH fds are rejected. A successful look=
up then proves the caller=0D=0A  holds an fd from a real open() of the da=
xdev -- i.e. it already passed=0D=0A  may_open_dev() and the device node'=
s DAC checks -- rather than an=0D=0A  O_PATH reference that bypasses them=
=2E=0D=0A=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A=
 fs/fuse/dev.c             |  31 ++++=0D=0A fs/fuse/dev.h             |  =
 1 +=0D=0A fs/fuse/famfs.c           | 330 ++++++++++++++++++++++++++++++=
++++++++=0D=0A fs/fuse/famfs_kfmap.h     |  27 ++++=0D=0A fs/fuse/fuse_i.=
h          |  28 ++++=0D=0A fs/fuse/inode.c           |   7 +-=0D=0A incl=
ude/uapi/linux/fuse.h |   7 +-=0D=0A 7 files changed, 429 insertions(+), =
2 deletions(-)=0D=0A=0D=0Adiff --git a/fs/fuse/dev.c b/fs/fuse/dev.c=0D=0A=
index 5763a7cd3b37..3e6aa15e0346 100644=0D=0A--- a/fs/fuse/dev.c=0D=0A+++=
 b/fs/fuse/dev.c=0D=0A@@ -2330,6 +2330,34 @@ static long fuse_dev_ioctl_b=
acking_close(struct file *file, __u32 __user *argp)=0D=0A =09return fuse_=
backing_close(fud->chan->conn, backing_id);=0D=0A }=0D=0A=20=0D=0A+static=
 long fuse_dev_ioctl_daxdev_open(struct file *file,=0D=0A+=09=09=09=09   =
    struct fuse_backing_map __user *argp)=0D=0A+{=0D=0A+=09struct fuse_de=
v *fud =3D fuse_get_dev(file);=0D=0A+=09struct fuse_backing_map map;=0D=0A=
+=0D=0A+=09if (IS_ERR(fud))=0D=0A+=09=09return PTR_ERR(fud);=0D=0A+=0D=0A=
+=09if (!IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))=0D=0A+=09=09return -EOPNOTSUP=
P;=0D=0A+=0D=0A+=09/*=0D=0A+=09 * The famfs-mode gate (fc->famfs_iomap) l=
ives in famfs_daxdev_open(),=0D=0A+=09 * which has the full fuse_conn def=
inition. Here, re-check CAP_SYS_RAWIO=0D=0A+=09 * against the task perfor=
ming the registration: famfs mode being enabled=0D=0A+=09 * only attests =
that the session founder held it at FUSE_INIT, and the=0D=0A+=09 * fuse d=
evice fd may have been passed to a less-privileged process.=0D=0A+=09 */=0D=
=0A+=09if (!capable(CAP_SYS_RAWIO))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A=
+=09if (copy_from_user(&map, argp, sizeof(map)))=0D=0A+=09=09return -EFAU=
LT;=0D=0A+=0D=0A+=09return famfs_daxdev_open(fud->chan->conn, &map);=0D=0A=
+}=0D=0A+=0D=0A static long fuse_dev_ioctl_sync_init(struct file *file)=0D=
=0A {=0D=0A =09struct fuse_dev *fud =3D fuse_file_to_fud(file);=0D=0A@@ -=
2359,6 +2387,9 @@ static long fuse_dev_ioctl(struct file *file, unsigned =
int cmd,=0D=0A =09case FUSE_DEV_IOC_SYNC_INIT:=0D=0A =09=09return fuse_de=
v_ioctl_sync_init(file);=0D=0A=20=0D=0A+=09case FUSE_DEV_IOC_DAXDEV_OPEN:=
=0D=0A+=09=09return fuse_dev_ioctl_daxdev_open(file, argp);=0D=0A+=0D=0A =
=09default:=0D=0A =09=09return -ENOTTY;=0D=0A =09}=0D=0Adiff --git a/fs/f=
use/dev.h b/fs/fuse/dev.h=0D=0Aindex aed69fd14c41..545940b635cc 100644=0D=
=0A--- a/fs/fuse/dev.h=0D=0A+++ b/fs/fuse/dev.h=0D=0A@@ -87,6 +87,7 @@ in=
t fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,=0D=0A=20=0D=
=0A int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *=
map);=0D=0A int fuse_backing_close(struct fuse_conn *fc, int backing_id);=
=0D=0A+int famfs_daxdev_open(struct fuse_conn *fc, struct fuse_backing_ma=
p *map);=0D=0A=20=0D=0A int fuse_copy_one(struct fuse_copy_state *cs, voi=
d *val, unsigned size);=0D=0A int fuse_copy_folio(struct fuse_copy_state =
*cs, struct folio **foliop,=0D=0Adiff --git a/fs/fuse/famfs.c b/fs/fuse/f=
amfs.c=0D=0Aindex 8f7ee7d6151b..a2a7dd631dc0 100644=0D=0A--- a/fs/fuse/fa=
mfs.c=0D=0A+++ b/fs/fuse/famfs.c=0D=0A@@ -11,6 +11,7 @@=0D=0A=20=0D=0A #i=
nclude <linux/cleanup.h>=0D=0A #include <linux/fs.h>=0D=0A+#include <linu=
x/file.h>=0D=0A #include <linux/mm.h>=0D=0A #include <linux/dax.h>=0D=0A =
#include <linux/iomap.h>=0D=0A@@ -22,6 +23,331 @@=0D=0A #include "famfs_k=
fmap.h"=0D=0A #include "fuse_i.h"=0D=0A=20=0D=0A+static void famfs_set_da=
xdev_err(=0D=0A+=09struct fuse_conn *fc, struct dax_device *dax_devp);=0D=
=0A+=0D=0A+static int=0D=0A+famfs_dax_notify_failure(struct dax_device *d=
ax_devp, u64 offset,=0D=0A+=09=09=09u64 len, int mf_flags)=0D=0A+{=0D=0A+=
=09struct fuse_conn *fc =3D dax_holder(dax_devp);=0D=0A+=0D=0A+=09famfs_s=
et_daxdev_err(fc, dax_devp);=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A=
+static const struct dax_holder_operations famfs_fuse_dax_holder_ops =3D =
{=0D=0A+=09.notify_failure=09=09=3D famfs_dax_notify_failure,=0D=0A+};=0D=
=0A+=0D=0A+/*************************************************************=
****************/=0D=0A+=0D=0A+/*=0D=0A+ * famfs_teardown()=0D=0A+ *=0D=0A=
+ * Deallocate famfs metadata for a fuse_conn=0D=0A+ */=0D=0A+void=0D=0A+=
famfs_teardown(struct fuse_conn *fc)=0D=0A+{=0D=0A+=09struct famfs_dax_de=
vlist *devlist __free(kfree) =3D NULL;=0D=0A+=09int i;=0D=0A+=0D=0A+=09/*=
=0D=0A+=09 * Detach the table under the same lock famfs_set_daxdev_err() =
takes, so=0D=0A+=09 * a notify_failure racing teardown either runs first =
against the live=0D=0A+=09 * table or observes dax_devlist =3D=3D NULL an=
d bails, rather than=0D=0A+=09 * dereferencing it after we clear it. The =
daxdev holders are dropped=0D=0A+=09 * below, after which no further noti=
fy_failure can arrive.=0D=0A+=09 */=0D=0A+=09scoped_guard(rwsem_write, &f=
c->famfs_devlist_sem) {=0D=0A+=09=09devlist =3D fc->dax_devlist;=0D=0A+=09=
=09fc->dax_devlist =3D NULL;=0D=0A+=09}=0D=0A+=0D=0A+=09if (!devlist)=0D=0A=
+=09=09return;=0D=0A+=0D=0A+=09if (!devlist->devlist)=0D=0A+=09=09return;=
=0D=0A+=0D=0A+=09/* Close & release all the daxdevs in our table */=0D=0A=
+=09for (i =3D 0; i < devlist->nslots; i++) {=0D=0A+=09=09struct famfs_da=
xdev *dd =3D &devlist->devlist[i];=0D=0A+=0D=0A+=09=09if (!dd->valid)=0D=0A=
+=09=09=09continue;=0D=0A+=0D=0A+=09=09/* Only call fs_put_dax if fs_dax_=
get succeeded */=0D=0A+=09=09if (dd->devp) {=0D=0A+=09=09=09if (!dd->dax_=
err)=0D=0A+=09=09=09=09fs_put_dax(dd->devp, fc);=0D=0A+=09=09=09put_dax(d=
d->devp);=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09kfree(dd->name);=0D=0A+=09}=0D=
=0A+=09kfree(devlist->devlist);=0D=0A+}=0D=0A+=0D=0A+/* Allocate the daxd=
ev table on first use (idempotent via cmpxchg) */=0D=0A+static int famfs_=
devlist_alloc(struct fuse_conn *fc)=0D=0A+{=0D=0A+=09struct famfs_dax_dev=
list *devlist;=0D=0A+=0D=0A+=09if (fc->dax_devlist)=0D=0A+=09=09return 0;=
=0D=0A+=0D=0A+=09devlist =3D kcalloc(1, sizeof(*devlist), GFP_KERNEL);=0D=
=0A+=09if (!devlist)=0D=0A+=09=09return -ENOMEM;=0D=0A+=0D=0A+=09devlist-=
>nslots =3D MAX_DAXDEVS;=0D=0A+=09devlist->devlist =3D kcalloc(MAX_DAXDEV=
S, sizeof(struct famfs_daxdev),=0D=0A+=09=09=09=09   GFP_KERNEL);=0D=0A+=09=
if (!devlist->devlist) {=0D=0A+=09=09kfree(devlist);=0D=0A+=09=09return -=
ENOMEM;=0D=0A+=09}=0D=0A+=0D=0A+=09/* If another thread allocated it firs=
t, drop ours */=0D=0A+=09if (cmpxchg(&fc->dax_devlist, NULL, devlist) !=3D=
 NULL) {=0D=0A+=09=09kfree(devlist->devlist);=0D=0A+=09=09kfree(devlist);=
=0D=0A+=09}=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+/*=0D=0A+ * fa=
mfs_install_daxdev() - exclusively acquire a resolved daxdev and publish=0D=
=0A+ * it in the table at @index. Shared by the GET_DAXDEV (pull) and=0D=0A=
+ * DAXDEV_OPEN (push) registration paths.=0D=0A+ *=0D=0A+ * Serializes w=
ith concurrent installers under famfs_devlist_sem and rechecks=0D=0A+ * -=
>valid. A daxdev is entered in the table only once it has been exclusivel=
y=0D=0A+ * acquired via fs_dax_get(); on failure the dax_dev_get() refere=
nce is=0D=0A+ * released and the slot is left invalid, so the referencing=
 fmap is rejected=0D=0A+ * rather than mapped without an exclusive holder=
=2E @name may be NULL (the push=0D=0A+ * path passes no pathname).=0D=0A+=
 */=0D=0A+static int famfs_install_daxdev(struct fuse_conn *fc, u64 index=
, dev_t devno,=0D=0A+=09=09=09=09const char *name)=0D=0A+{=0D=0A+=09struc=
t famfs_daxdev *daxdev;=0D=0A+=09int rc =3D 0;=0D=0A+=0D=0A+=09if (index =
>=3D fc->dax_devlist->nslots) {=0D=0A+=09=09pr_err("%s: index(%llu) >=3D =
nslots(%d)\n",=0D=0A+=09=09       __func__, index, fc->dax_devlist->nslot=
s);=0D=0A+=09=09return -EINVAL;=0D=0A+=09}=0D=0A+=0D=0A+=09scoped_guard(r=
wsem_write, &fc->famfs_devlist_sem) {=0D=0A+=09=09daxdev =3D &fc->dax_dev=
list->devlist[index];=0D=0A+=0D=0A+=09=09/* Installed already by a concur=
rent push/pull */=0D=0A+=09=09if (daxdev->valid)=0D=0A+=09=09=09return 0;=
=0D=0A+=0D=0A+=09=09/*=0D=0A+=09=09 * A prior attempt already determined =
this daxdev cannot be=0D=0A+=09=09 * exclusively acquired (see the fs_dax=
_get() failure handling=0D=0A+=09=09 * below). Don't thrash on GET_DAXDEV=
/fs_dax_get(); fail fast.=0D=0A+=09=09 */=0D=0A+=09=09if (daxdev->dax_err=
)=0D=0A+=09=09=09return -EIO;=0D=0A+=0D=0A+=09=09/*=0D=0A+=09=09 * Tempor=
ary: dax_dev_get() is the exported upstream lookup, but=0D=0A+=09=09 * un=
like dax_dev_find() it allocates for any dev_t and does not=0D=0A+=09=09 =
* reject non-dax devices. Restore dax_dev_find() (and that=0D=0A+=09=09 *=
 rejection) once it is upstream.=0D=0A+=09=09 */=0D=0A+=09=09daxdev->devp=
 =3D dax_dev_get(devno);=0D=0A+=09=09if (!daxdev->devp) {=0D=0A+=09=09=09=
pr_warn("%s: device %u:%u not found or not dax\n",=0D=0A+=09=09=09=09__fu=
nc__, MAJOR(devno), MINOR(devno));=0D=0A+=09=09=09return -ENODEV;=0D=0A+=09=
=09}=0D=0A+=0D=0A+=09=09rc =3D fs_dax_get(daxdev->devp, fc, &famfs_fuse_d=
ax_holder_ops);=0D=0A+=09=09if (rc) {=0D=0A+=09=09=09/*=0D=0A+=09=09=09 *=
 Distinguish a lost race from a real failure. -EBUSY=0D=0A+=09=09=09 * wi=
th the daxdev already held by *this* fuse_conn=0D=0A+=09=09=09 * means a =
concurrent acquire won and will publish the=0D=0A+=09=09=09 * slot valid:=
 not an error, and must not be cached as=0D=0A+=09=09=09 * dax_err. Any o=
ther failure (foreign holder, not a dax=0D=0A+=09=09=09 * device, wrong d=
river type) is permanent for this=0D=0A+=09=09=09 * connection, so record=
 dax_err to stop re-fetching and=0D=0A+=09=09=09 * re-acquiring it.=0D=0A=
+=09=09=09 */=0D=0A+=09=09=09if (!(rc =3D=3D -EBUSY && dax_holder(daxdev-=
>devp) =3D=3D fc)) {=0D=0A+=09=09=09=09pr_err("%s: fs_dax_get(%u:%u) fail=
ed rc=3D%d\n",=0D=0A+=09=09=09=09       __func__, MAJOR(devno), MINOR(dev=
no), rc);=0D=0A+=09=09=09=09daxdev->dax_err =3D true;=0D=0A+=09=09=09}=0D=
=0A+=09=09=09put_dax(daxdev->devp);=0D=0A+=09=09=09daxdev->devp =3D NULL;=
=0D=0A+=09=09=09return rc;=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09daxdev->devno=
 =3D devno;=0D=0A+=09=09if (name) {=0D=0A+=09=09=09daxdev->name =3D kstrd=
up(name, GFP_KERNEL);=0D=0A+=09=09=09if (!daxdev->name) {=0D=0A+=09=09=09=
=09fs_put_dax(daxdev->devp, fc);=0D=0A+=09=09=09=09put_dax(daxdev->devp);=
=0D=0A+=09=09=09=09daxdev->devp =3D NULL;=0D=0A+=09=09=09=09return -ENOME=
M;=0D=0A+=09=09=09}=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09wmb(); /* All other =
fields must be visible before valid */=0D=0A+=09=09daxdev->valid =3D 1;=0D=
=0A+=09}=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+/**=0D=0A+ * famf=
s_daxdev_open() - Register a daxdev via FUSE_DEV_IOC_DAXDEV_OPEN=0D=0A+ *=
 @fc:   fuse_conn=0D=0A+ * @map:  fuse_backing_map; @map->fd is an fd to =
the devdax device and=0D=0A+ *        @map->daxdev_index is the (cluster-=
invariant) famfs index.=0D=0A+ *=0D=0A+ * The server pushes a daxdev to t=
he kernel by reference (an fd), rather than=0D=0A+ * the kernel pulling i=
t by name via GET_DAXDEV. The resolved daxdev is=0D=0A+ * exclusively acq=
uired and entered in the table at @map->daxdev_index.=0D=0A+ *=0D=0A+ * R=
eturn: 0=3Dsuccess=0D=0A+ *         -errno=3Dfailure=0D=0A+ */=0D=0A+int =
famfs_daxdev_open(struct fuse_conn *fc, struct fuse_backing_map *map)=0D=0A=
+{=0D=0A+=09struct inode *inode;=0D=0A+=09struct file *file;=0D=0A+=09dev=
_t devno;=0D=0A+=09int rc;=0D=0A+=0D=0A+=09/* Only fs-dax (famfs) mode ac=
cepts daxdev registration */=0D=0A+=09if (!fc->famfs_iomap)=0D=0A+=09=09r=
eturn -EOPNOTSUPP;=0D=0A+=0D=0A+=09file =3D fget(map->fd);=0D=0A+=09if (!=
file)=0D=0A+=09=09return -EBADF;=0D=0A+=0D=0A+=09inode =3D file_inode(fil=
e);=0D=0A+=09if (!S_ISCHR(inode->i_mode)) {=0D=0A+=09=09fput(file);=0D=0A=
+=09=09return -EINVAL;=0D=0A+=09}=0D=0A+=09devno =3D inode->i_rdev;=0D=0A=
+=09fput(file);=0D=0A+=0D=0A+=09rc =3D famfs_devlist_alloc(fc);=0D=0A+=09=
if (rc)=0D=0A+=09=09return rc;=0D=0A+=0D=0A+=09rc =3D famfs_install_daxde=
v(fc, map->daxdev_index, devno, NULL);=0D=0A+=09if (rc)=0D=0A+=09=09pr_er=
r("%s: failed to install daxdev\n", __func__);=0D=0A+=0D=0A+=09return rc;=
=0D=0A+}=0D=0A+=0D=0A+/**=0D=0A+ * famfs_check_daxdev_table() - Verify an=
 fmap's referenced daxdevs are installed=0D=0A+ * @fm:   fuse_mount=0D=0A=
+ * @meta: famfs_file_meta, in-memory format, built from a GET_FMAP respo=
nse=0D=0A+ *=0D=0A+ * Called for each new file fmap. Every daxdev the fma=
p references must already=0D=0A+ * be installed in the table, having been=
 pushed in via FUSE_DEV_IOC_DAXDEV_OPEN=0D=0A+ * before any file that use=
s it is accessed. If any referenced daxdev is not=0D=0A+ * present, the f=
map is rejected so the file is never mapped against a daxdev=0D=0A+ * tha=
t has no exclusive holder.=0D=0A+ *=0D=0A+ * Return: 0=3Dsuccess (all ref=
erenced daxdevs present)=0D=0A+ *         <0=3Da referenced daxdev is mis=
sing from the table=0D=0A+ */=0D=0A+static int=0D=0A+famfs_check_daxdev_t=
able(=0D=0A+=09struct fuse_mount *fm,=0D=0A+=09const struct famfs_file_me=
ta *meta)=0D=0A+{=0D=0A+=09struct fuse_conn *fc =3D fm->fc;=0D=0A+=09int =
nmissing =3D 0;=0D=0A+=09int err;=0D=0A+=0D=0A+=09err =3D famfs_devlist_a=
lloc(fc);=0D=0A+=09if (err)=0D=0A+=09=09return err;=0D=0A+=0D=0A+=09/* Co=
unt missing daxdevs while holding the reader lock */=0D=0A+=09scoped_guar=
d(rwsem_read, &fc->famfs_devlist_sem) {=0D=0A+=09=09unsigned long i;=0D=0A=
+=0D=0A+=09=09for_each_set_bit(i, (unsigned long *)&meta->dev_bitmap,=0D=0A=
+=09=09=09=09 MAX_DAXDEVS) {=0D=0A+=09=09=09struct famfs_daxdev *dd =3D &=
fc->dax_devlist->devlist[i];=0D=0A+=0D=0A+=09=09=09/*=0D=0A+=09=09=09 * S=
kip daxdevs already installed (valid) or already=0D=0A+=09=09=09 * known =
to be unusable (dax_err). Re-fetching either=0D=0A+=09=09=09 * just thras=
hes on GET_DAXDEV and fs_dax_get().=0D=0A+=09=09=09 */=0D=0A+=09=09=09if =
(!dd->valid && !dd->dax_err)=0D=0A+=09=09=09=09nmissing++;=0D=0A+=09=09}=0D=
=0A+=09}=0D=0A+=0D=0A+=09if (nmissing > 0) {=0D=0A+=09=09/* this file ref=
erenced at least one daxdev that is not in=0D=0A+=09=09 * the table. Daxd=
evs must be known before any file that=0D=0A+=09=09 * uses them is access=
ed=0D=0A+=09=09 */=0D=0A+=09=09pr_err("%s: %d missing daxdev(s)\n", __fun=
c__, nmissing);=0D=0A+=09=09return -ENODEV;=0D=0A+=09}=0D=0A+=0D=0A+=09re=
turn 0;=0D=0A+}=0D=0A+=0D=0A+static void=0D=0A+famfs_set_daxdev_err(=0D=0A=
+=09struct fuse_conn *fc,=0D=0A+=09struct dax_device *dax_devp)=0D=0A+{=0D=
=0A+=09int i;=0D=0A+=0D=0A+=09/*=0D=0A+=09 * Search the list by dax_devp =
under the write lock: we set dd->error,=0D=0A+=09 * and it serializes aga=
inst famfs_teardown() clearing the table.=0D=0A+=09 */=0D=0A+=09scoped_gu=
ard(rwsem_write, &fc->famfs_devlist_sem) {=0D=0A+=09=09if (!fc->dax_devli=
st)=0D=0A+=09=09=09return;=0D=0A+=09=09for (i =3D 0; i < fc->dax_devlist-=
>nslots; i++) {=0D=0A+=09=09=09if (fc->dax_devlist->devlist[i].valid) {=0D=
=0A+=09=09=09=09struct famfs_daxdev *dd;=0D=0A+=0D=0A+=09=09=09=09dd =3D =
&fc->dax_devlist->devlist[i];=0D=0A+=09=09=09=09if (dd->devp !=3D dax_dev=
p)=0D=0A+=09=09=09=09=09continue;=0D=0A+=0D=0A+=09=09=09=09dd->error =3D =
true;=0D=0A+=0D=0A+=09=09=09=09pr_err("%s: memory error on daxdev %s (%d)=
\n",=0D=0A+=09=09=09=09       __func__, dd->name, i);=0D=0A+=09=09=09=09r=
eturn;=0D=0A+=09=09=09}=0D=0A+=09=09}=0D=0A+=09}=0D=0A+=09pr_err("%s: mem=
ory err on unrecognized daxdev\n", __func__);=0D=0A+}=0D=0A=20=0D=0A /***=
************************************************************************/=
=0D=0A=20=0D=0A@@ -228,6 +554,10 @@ famfs_file_init_dax(=0D=0A =09if (rc)=
=0D=0A =09=09goto errout;=0D=0A=20=0D=0A+=09/* Make sure this fmap doesn'=
t reference any unknown daxdevs */=0D=0A+=09if (famfs_check_daxdev_table(=
fm, meta))=0D=0A+=09=09meta->error =3D true;=0D=0A+=0D=0A =09/* Publish t=
he famfs metadata on fi->famfs_meta */=0D=0A =09inode_lock(inode);=0D=0A=20=
=0D=0Adiff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h=0D=0Aind=
ex d87b065e8ac8..6b78e78325c8 100644=0D=0A--- a/fs/fuse/famfs_kfmap.h=0D=0A=
+++ b/fs/fuse/famfs_kfmap.h=0D=0A@@ -61,4 +61,31 @@ struct famfs_file_met=
a {=0D=0A =09struct famfs_meta_simple_ext  *se;=0D=0A };=0D=0A=20=0D=0A+/=
*=0D=0A+ * famfs_daxdev - tracking struct for a daxdev within a famfs fil=
e system=0D=0A+ *=0D=0A+ * This is the in-memory daxdev metadata that is =
populated by parsing=0D=0A+ * the responses to GET_FMAP messages=0D=0A+ *=
/=0D=0A+struct famfs_daxdev {=0D=0A+=09/* Include dev uuid=3F */=0D=0A+=09=
bool valid;=0D=0A+=09bool error; /* Dax has reported a memory error (prob=
ably poison) */=0D=0A+=09bool dax_err; /* fs_dax_get() failed */=0D=0A+=09=
dev_t devno;=0D=0A+=09struct dax_device *devp;=0D=0A+=09char *name;=0D=0A=
+};=0D=0A+=0D=0A+#define MAX_DAXDEVS 24=0D=0A+=0D=0A+/*=0D=0A+ * famfs_da=
x_devlist - list of famfs_daxdev's=0D=0A+ */=0D=0A+struct famfs_dax_devli=
st {=0D=0A+=09int nslots;=0D=0A+=09int ndevs;=0D=0A+=09struct famfs_daxde=
v *devlist;=0D=0A+};=0D=0A+=0D=0A #endif /* FAMFS_KFMAP_H */=0D=0Adiff --=
git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h=0D=0Aindex 46a7040b38dc..5394aa=
e9dbac 100644=0D=0A--- a/fs/fuse/fuse_i.h=0D=0A+++ b/fs/fuse/fuse_i.h=0D=0A=
@@ -773,6 +773,11 @@ struct fuse_conn {=0D=0A =09/** @backing_files_map: =
IDR for backing files ids */=0D=0A =09struct idr backing_files_map;=0D=0A=
 #endif=0D=0A+=0D=0A+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)=0D=0A+=09struc=
t rw_semaphore famfs_devlist_sem;=0D=0A+=09struct famfs_dax_devlist *dax_=
devlist;=0D=0A+#endif=0D=0A };=0D=0A=20=0D=0A /*=0D=0A@@ -1352,6 +1357,8 =
@@ int famfs_file_init_dax(struct fuse_mount *fm,=0D=0A =09=09=09size_t f=
map_size);=0D=0A void __famfs_meta_free(void *map);=0D=0A=20=0D=0A+void f=
amfs_teardown(struct fuse_conn *fc);=0D=0A+=0D=0A /* Set fi->famfs_meta =3D=
 NULL regardless of prior value */=0D=0A static inline void famfs_meta_in=
it(struct fuse_inode *fi)=0D=0A {=0D=0A@@ -1373,6 +1380,11 @@ static inli=
ne void famfs_meta_free(struct fuse_inode *fi)=0D=0A =09}=0D=0A }=0D=0A=20=
=0D=0A+static inline void famfs_init_devlist_sem(struct fuse_conn *fc)=0D=
=0A+{=0D=0A+=09init_rwsem(&fc->famfs_devlist_sem);=0D=0A+}=0D=0A+=0D=0A s=
tatic inline int fuse_file_famfs(struct fuse_inode *fi)=0D=0A {=0D=0A =09=
return (READ_ONCE(fi->famfs_meta) !=3D NULL);=0D=0A@@ -1380,8 +1392,14 @@=
 static inline int fuse_file_famfs(struct fuse_inode *fi)=0D=0A=20=0D=0A =
int fuse_get_fmap(struct fuse_mount *fm, struct inode *inode);=0D=0A=20=0D=
=0A+int famfs_daxdev_open(struct fuse_conn *fc, struct fuse_backing_map *=
map);=0D=0A+=0D=0A #else /* !CONFIG_FUSE_FAMFS_DAX */=0D=0A=20=0D=0A+stat=
ic inline void famfs_teardown(struct fuse_conn *fc)=0D=0A+{=0D=0A+}=0D=0A=
+=0D=0A static inline struct fuse_backing *famfs_meta_set(struct fuse_ino=
de *fi,=0D=0A =09=09=09=09=09=09  void *meta)=0D=0A {=0D=0A@@ -1392,6 +14=
10,10 @@ static inline void famfs_meta_free(struct fuse_inode *fi)=0D=0A =
{=0D=0A }=0D=0A=20=0D=0A+static inline void famfs_init_devlist_sem(struct=
 fuse_conn *fc)=0D=0A+{=0D=0A+}=0D=0A+=0D=0A static inline int fuse_file_=
famfs(struct fuse_inode *fi)=0D=0A {=0D=0A =09return 0;=0D=0A@@ -1403,6 +=
1425,12 @@ fuse_get_fmap(struct fuse_mount *fm, struct inode *inode)=0D=0A=
 =09return 0;=0D=0A }=0D=0A=20=0D=0A+static inline int=0D=0A+famfs_daxdev=
_open(struct fuse_conn *fc, struct fuse_backing_map *map)=0D=0A+{=0D=0A+=09=
return -EOPNOTSUPP;=0D=0A+}=0D=0A+=0D=0A #endif /* CONFIG_FUSE_FAMFS_DAX =
*/=0D=0A=20=0D=0A #endif /* _FS_FUSE_I_H */=0D=0Adiff --git a/fs/fuse/ino=
de.c b/fs/fuse/inode.c=0D=0Aindex 78ffc5fd50d0..9fc37015fb11 100644=0D=0A=
--- a/fs/fuse/inode.c=0D=0A+++ b/fs/fuse/inode.c=0D=0A@@ -1021,6 +1021,9 =
@@ void fuse_conn_put(struct fuse_conn *fc)=0D=0A =09=09WARN_ON(atomic_re=
ad(&bucket->count) !=3D 1);=0D=0A =09=09kfree(bucket);=0D=0A =09}=0D=0A+=09=
if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))=0D=0A+=09=09famfs_teardown(fc);=0D=
=0A+=0D=0A =09if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))=0D=0A =09=09fuse_b=
acking_files_free(fc);=0D=0A =09call_rcu(&fc->rcu, delayed_release);=0D=0A=
@@ -1427,8 +1430,10 @@ static void process_init_reply(struct fuse_args *a=
rgs, int error)=0D=0A =09=09=09=09u64 in_flags =3D FIELD_PREP(GENMASK_ULL=
(63, 32), ia->in.flags2)=0D=0A =09=09=09=09=09=09| ia->in.flags;=0D=0A=20=
=0D=0A-=09=09=09=09if (in_flags & FUSE_DAX_FMAP)=0D=0A+=09=09=09=09if (in=
_flags & FUSE_DAX_FMAP) {=0D=0A+=09=09=09=09=09famfs_init_devlist_sem(fc)=
;=0D=0A =09=09=09=09=09fc->famfs_iomap =3D 1;=0D=0A+=09=09=09=09}=0D=0A =09=
=09=09}=0D=0A =09=09} else {=0D=0A =09=09=09ra_pages =3D fc->max_read / P=
AGE_SIZE;=0D=0Adiff --git a/include/uapi/linux/fuse.h b/include/uapi/linu=
x/fuse.h=0D=0Aindex 4b84a58a8f1c..a143e6818416 100644=0D=0A--- a/include/=
uapi/linux/fuse.h=0D=0A+++ b/include/uapi/linux/fuse.h=0D=0A@@ -1143,7 +1=
143,10 @@ struct fuse_notify_prune_out {=0D=0A struct fuse_backing_map {=0D=
=0A =09int32_t=09=09fd;=0D=0A =09uint32_t=09flags;=0D=0A-=09uint64_t=09pa=
dding;=0D=0A+=09union {=0D=0A+=09=09uint64_t=09padding;=0D=0A+=09=09uint6=
4_t=09daxdev_index;=09/* FUSE_DEV_IOC_DAXDEV_OPEN */=0D=0A+=09};=0D=0A };=
=0D=0A=20=0D=0A /* Device ioctls: */=0D=0A@@ -1153,6 +1156,8 @@ struct fu=
se_backing_map {=0D=0A =09=09=09=09=09     struct fuse_backing_map)=0D=0A=
 #define FUSE_DEV_IOC_BACKING_CLOSE=09_IOW(FUSE_DEV_IOC_MAGIC, 2, uint32_=
t)=0D=0A #define FUSE_DEV_IOC_SYNC_INIT=09=09_IO(FUSE_DEV_IOC_MAGIC, 3)=0D=
=0A+#define FUSE_DEV_IOC_DAXDEV_OPEN=09_IOW(FUSE_DEV_IOC_MAGIC, 4, \=0D=0A=
+=09=09=09=09=09     struct fuse_backing_map)=0D=0A=20=0D=0A struct fuse_=
lseek_in {=0D=0A =09uint64_t=09fh;=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
