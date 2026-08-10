Received: from a11-70.smtp-out.amazonses.com (a11-70.smtp-out.amazonses.com [54.240.11.70])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF453ACA79;
	Mon, 10 Aug 2026 20:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393539; cv=none; b=MQ10GUP8P928ZUlwwL0OtF+H/x5PbAZkpEYBnATOkJtyC9A9iaWMq3DpD7bFT3RCo8BNeN/pp+/K29fjy/K6FqdXY1uXlpwIrjm9Kbzox3BTqB1CuLHtCyqrb10eqm49C9ktfyeRN/poIJIZUR0OnZpfXr2qcaekvOGvZ7CXe9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393539; c=relaxed/simple;
	bh=NQHvL73tnB5jmTTNph8RZr50uUAwGlZ5CfmH/GlmWxE=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=ILziC+SHJwNcNfXTsV/FdTBPYP8OwSDMnb//h85u72CWFJkel4HZBNk/8rxz7+XJy+quxmdYfUAE8qG+OSgXupVtjHKK13MlgkqRreqVyHRFsmXERjchvb6Mz9SFmyr2VS/ss1L0p1MCnbx2kOb2YaidD7p9qTSyXFpCr5AXJEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=jMTbQP58; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=a6ofOAgB; arc=none smtp.client-ip=54.240.11.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="jMTbQP58";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="a6ofOAgB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1786393537;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=NQHvL73tnB5jmTTNph8RZr50uUAwGlZ5CfmH/GlmWxE=;
	b=jMTbQP58ZDtkEKexZWnc/TiGgxRpQnrbKE7FBYTJpTPpmFdouB0cH12xUji/eaAc
	PTw9aMcO2apLkaK1ePJB4qPeKX41B1UaoBoBTXx3eRVY3aObWvHWsWznMzVzCnNSJre
	tkYptw+Kvy+hO9RwjZ51uqQQRZE3VvjOe1yWTmOQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1786393537;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=NQHvL73tnB5jmTTNph8RZr50uUAwGlZ5CfmH/GlmWxE=;
	b=a6ofOAgBYN77In1wneGqRKU8jNrYKb3UUWfYGUOSOCTT2Z78hcye4xQrnWBcC3+v
	CbMKurA2muYTcSY3jsVpMfVpD43CWvXdJryrQqxdnyXk8SY5QDkSlqV86yDBA/oWubN
	29NJbeJfuLYx/B7lIoGpME7wtjrK0EzVX8Llyrg4=
Subject: [PATCH v13 09/12] famfs: Register secondary daxdevs by path
 (FAMFSIOC_DAXDEV_OPEN)
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
Date: Mon, 10 Aug 2026 20:25:36 +0000
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
 <20260810202529.96363-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdKQYd8BhJGjNjSyqPwMCz2Vr35AAAEjYl
Thread-Topic: [PATCH v13 09/12] famfs: Register secondary daxdevs by path
 (FAMFSIOC_DAXDEV_OPEN)
X-Wm-Sent-Timestamp: 1786393535
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <0100019fed5a2907-94b60adc-0d50-4728-a0eb-ebc90eb6d16e-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.10-54.240.11.70

From: John Groves <john@groves.net>=0D=0A=0D=0AFamfs file maps (fmaps) ma=
y reference multiple daxdevs. Before passing=0D=0Aan fmap that references=
 a new daxdev, the daxdev is pushed into the=0D=0Akernel via FAMFSIOC_DAX=
DEV_OPEN). This adds daxdevs to daxdev_table for=0D=0Aindex-based resolut=
ion from famfs extents to daxdevs.=0D=0A=0D=0ASigned-off-by: John Groves =
<john@groves.net>=0D=0A---=0D=0Av13:=0D=0A - famfs_daxdev_open(): declare=
 path with __free(kfree) and drop the goto/out=0D=0A   label so it is rel=
eased on every return path, per the cleanup.h guidance=0D=0A   against mi=
xing goto-unwinding with scope-based helpers (Sashiko bot).=0D=0A=0D=0A f=
s/famfs/famfs_file.c            | 74 ++++++++++++++++++++++++++++++++=0D=0A=
 include/uapi/linux/famfs_ioctl.h | 24 +++++++++++=0D=0A 2 files changed,=
 98 insertions(+)=0D=0A=0D=0Adiff --git a/fs/famfs/famfs_file.c b/fs/famf=
s/famfs_file.c=0D=0Aindex 670c8f961f11..6f71805a297c 100644=0D=0A--- a/fs=
/famfs/famfs_file.c=0D=0A+++ b/fs/famfs/famfs_file.c=0D=0A@@ -289,6 +289,=
76 @@ famfs_file_init_dax(struct file *file, void __user *arg)=0D=0A =09r=
eturn rc;=0D=0A }=0D=0A=20=0D=0A+/**=0D=0A+ * famfs_daxdev_open() - FAMFS=
IOC_DAXDEV_OPEN ioctl handler=0D=0A+ * @file: any file in the famfs mount=
 (the table is per-superblock)=0D=0A+ * @arg:  ptr to struct famfs_ioc_da=
xdev in user space=0D=0A+ *=0D=0A+ * Register a devdax device (identified=
 by path) into the mount's daxdev table=0D=0A+ * at the caller-specified =
index, so files whose extents reference that index=0D=0A+ * can be mapped=
=2E The path is resolved by famfs_lookup_daxdev() - the same=0D=0A+ * hel=
per the mount uses for the primary daxdev - so every slot is resolved=0D=0A=
+ * identically. Registering exposes raw device memory, so it requires=0D=
=0A+ * CAP_SYS_RAWIO.=0D=0A+ */=0D=0A+static int=0D=0A+famfs_daxdev_open(=
struct file *file, void __user *arg)=0D=0A+{=0D=0A+=09struct super_block =
*sb =3D file_inode(file)->i_sb;=0D=0A+=09struct famfs_fs_info *fsi =3D sb=
->s_fs_info;=0D=0A+=09struct famfs_ioc_daxdev dd;=0D=0A+=09dev_t devno;=0D=
=0A+=09int rc;=0D=0A+=0D=0A+=09char *path __free(kfree) =3D NULL;=0D=0A+=0D=
=0A+=09if (!capable(CAP_SYS_RAWIO))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A=
+=09if (copy_from_user(&dd, arg, sizeof(dd)))=0D=0A+=09=09return -EFAULT;=
=0D=0A+=0D=0A+=09/* @flags is reserved; reject non-zero so it stays avail=
able */=0D=0A+=09if (dd.flags)=0D=0A+=09=09return -EINVAL;=0D=0A+=0D=0A+=09=
/*=0D=0A+=09 * If this daxdev index is already populated there is nothing=
 to do.=0D=0A+=09 * The index is cluster-invariant, so a valid slot alrea=
dy names this=0D=0A+=09 * device; skip the path resolution entirely. inst=
all_daxdev() rechecks=0D=0A+=09 * ->valid under the write lock, so this i=
s purely an optimization.=0D=0A+=09 */=0D=0A+=09scoped_guard(rwsem_read, =
&fsi->devlist_sem) {=0D=0A+=09=09if (dd.daxdev_index >=3D fsi->dax_devlis=
t->nslots)=0D=0A+=09=09=09return -EINVAL;=0D=0A+=09=09if (fsi->dax_devlis=
t->devlist[dd.daxdev_index].valid)=0D=0A+=09=09=09return 0;=0D=0A+=09}=0D=
=0A+=0D=0A+=09if (dd.daxdev_path_len =3D=3D 0 || dd.daxdev_path_len >=3D =
PATH_MAX)=0D=0A+=09=09return -EINVAL;=0D=0A+=0D=0A+=09/* +1 so the termin=
ating NUL is included within the bound */=0D=0A+=09path =3D strndup_user(=
(const char __user *)(uintptr_t)dd.daxdev_path,=0D=0A+=09=09=09    dd.dax=
dev_path_len + 1);=0D=0A+=09if (IS_ERR(path))=0D=0A+=09=09return PTR_ERR(=
no_free_ptr(path));=0D=0A+=0D=0A+=09rc =3D famfs_lookup_daxdev(path, &dev=
no);=0D=0A+=09if (rc)=0D=0A+=09=09return rc;=0D=0A+=0D=0A+=09/*=0D=0A+=09=
 * The daxdev table is allocated at mount time (for the slot-0 primary),=0D=
=0A+=09 * so it is always present here; no need to allocate it.=0D=0A+=09=
 */=0D=0A+=09rc =3D famfs_install_daxdev(fsi, sb, dd.daxdev_index, devno,=
 path);=0D=0A+=09if (rc)=0D=0A+=09=09pr_debug("%s: failed to install daxd=
ev index %llu (%s)\n",=0D=0A+=09=09       __func__, dd.daxdev_index, path=
);=0D=0A+=09return rc;=0D=0A+}=0D=0A+=0D=0A /**=0D=0A  * famfs_file_ioctl=
() - Top-level famfs file ioctl handler=0D=0A  * @file: the file=0D=0A@@ =
-310,6 +380,10 @@ famfs_file_ioctl(struct file *file, unsigned int cmd, u=
nsigned long arg)=0D=0A =09=09rc =3D 0;=0D=0A =09=09break;=0D=0A=20=0D=0A=
+=09case FAMFSIOC_DAXDEV_OPEN:=0D=0A+=09=09rc =3D famfs_daxdev_open(file,=
 (void __user *)arg);=0D=0A+=09=09break;=0D=0A+=0D=0A =09case FAMFSIOC_MA=
P_CREATE:=0D=0A =09=09rc =3D famfs_file_init_dax(file, (void __user *)arg=
);=0D=0A =09=09break;=0D=0Adiff --git a/include/uapi/linux/famfs_ioctl.h =
b/include/uapi/linux/famfs_ioctl.h=0D=0Aindex b4eb373c1ade..751d8b033c2e =
100644=0D=0A--- a/include/uapi/linux/famfs_ioctl.h=0D=0A+++ b/include/uap=
i/linux/famfs_ioctl.h=0D=0A@@ -77,6 +77,29 @@ struct famfs_ioc_fmap_heade=
r {=0D=0A =09__u64 reserved1;=0D=0A };=0D=0A=20=0D=0A+/**=0D=0A+ * struct=
 famfs_ioc_daxdev - register an additional backing daxdev by path=0D=0A+ =
* @daxdev_index:    the (cluster-invariant) index this daxdev occupies in=
=0D=0A+ *                   extent dev_index fields. Index 0 is the mount=
-time primary.=0D=0A+ * @daxdev_path:     userspace pointer to the devdax=
 device path (e.g.=0D=0A+ *                   "/dev/dax0.0"); resolved in=
 the kernel the same way the=0D=0A+ *                   mount primary is.=
=0D=0A+ * @daxdev_path_len: length of the path string, not counting the N=
UL.=0D=0A+ * @flags:           reserved; must be zero.=0D=0A+ *=0D=0A+ * =
Standalone famfs registers every daxdev by path: the mount primary comes =
in=0D=0A+ * as the mount device name, and slots 1..n come in here. (This =
deliberately=0D=0A+ * differs from fuse's fd-based FUSE_DEV_IOC_DAXDEV_OP=
EN; each side is uniform=0D=0A+ * within itself.) Passing the path by poi=
nter keeps the struct fixed-size, so=0D=0A+ * longer paths never require =
an ABI change.=0D=0A+ */=0D=0A+struct famfs_ioc_daxdev {=0D=0A+=09__u64 d=
axdev_index;=0D=0A+=09__u64 daxdev_path;=0D=0A+=09__u32 daxdev_path_len;=0D=
=0A+=09__u32 flags;=0D=0A+};=0D=0A+=0D=0A #define FAMFSIOC_MAGIC 'u'=0D=0A=
=20=0D=0A /* famfs file ioctl opcodes */=0D=0A@@ -87,5 +110,6 @@ struct f=
amfs_ioc_fmap_header {=0D=0A  * famfs_ioc_fmap_header followed by the ext=
ent list (see above).=0D=0A  */=0D=0A #define FAMFSIOC_MAP_CREATE    _IOW=
(FAMFSIOC_MAGIC,  0x51, struct famfs_ioc_fmap_header)=0D=0A+#define FAMFS=
IOC_DAXDEV_OPEN   _IOW(FAMFSIOC_MAGIC,  0x52, struct famfs_ioc_daxdev)=0D=
=0A=20=0D=0A #endif /* FAMFS_IOCTL_H */=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A=
