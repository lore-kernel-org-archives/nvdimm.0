Received: from a11-70.smtp-out.amazonses.com (a11-70.smtp-out.amazonses.com [54.240.11.70])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C926737F300;
	Mon, 10 Aug 2026 20:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393481; cv=none; b=EAZRyBWuDfuJrqDvxtvO9x8VnuRVKujQurPb49B/S3pT8Q4BP4+5Pn+qgEcysB+jN1IJdxlUSYkXdsg22yP0pxGXbzgpFRctRmQ7ElsfNnuM5Ts+eLrVrWzS493qHlT1r2JTd4NqOJcBMSUv9yUuGdVyl+c/uUA5XODUhQgbuEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393481; c=relaxed/simple;
	bh=d9H/iPfNpwvK1+HiDJv0NxIe7H1hdp9AUCqNu/EYsFk=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=tG3s/ob4UezTUgLuz4u+3F6StzTThDAydL+zbhTCnAcJV1jFMw9gahFa23HC+8D2Abk6J7xU3Qj2wyprjegIAFqMIElzKrqbCWOGI27FUA+cyaENmgoFkrfJFpb2sC29+//fFwRMJCcJ3nT68iuApH+a/qXFzruWjhl/fBZ4ojo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=bR47QtoH; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=ZD7O1+dp; arc=none smtp.client-ip=54.240.11.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="bR47QtoH";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="ZD7O1+dp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1786393478;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=d9H/iPfNpwvK1+HiDJv0NxIe7H1hdp9AUCqNu/EYsFk=;
	b=bR47QtoHqifK2MoiT1S9NmgFEOQMgvob5YjMjnqEfCA6gpa4lyzFv8VjoI52jllg
	KmExRzyheX3EQfMCVF4UJ95D+obeDaPeA9FW7Qc1XyJP049hR57K3McnxwX8L+SgkRb
	brUknvC3XZt1V57qecr9dPvqKMhTyYY/cy8AP/Sg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1786393478;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=d9H/iPfNpwvK1+HiDJv0NxIe7H1hdp9AUCqNu/EYsFk=;
	b=ZD7O1+dpfDTzQpENxN8bloQcsKwchhJRmDnbMkEOZAattS3EyLpHYeX430k+smGQ
	DOLpHidWeROKEWBlKvPRxxy4Yb2B2BnJCL7vLzjeJ8AA+coJaBZ1/7O26CIx/FuKe32
	nQwporvZ3GXpeeptZV6vmdCDYMMfvSoXdOb04Ozk=
Subject: [PATCH v13 03/12] famfs: Add daxdev table and dax notify_failure
 support
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
Date: Mon, 10 Aug 2026 20:24:38 +0000
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
 <20260810202430.96259-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdKQYd8BhJGjNjSyqPwMCz2Vr35AAACYj0
Thread-Topic: [PATCH v13 03/12] famfs: Add daxdev table and dax
 notify_failure support
X-Wm-Sent-Timestamp: 1786393477
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <0100019fed5945de-89b374bb-2792-4bbe-acc5-a806f6e1b309-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.10-54.240.11.70

From: John Groves <john@groves.net>=0D=0A=0D=0AFamfs file systems can spa=
n multiple dax devices, and daxdevs are stored=0D=0Ain the daxdev_table. =
This adds the basic table structure, primtives and=0D=0Aserialization cod=
e. Famfs file extents reference daxdevs by index, which=0D=0Ais a cluster=
 invariant maintained by user space.=0D=0A=0D=0AWe also add dax_holder_op=
erations and a notify_failure handler, which=0D=0Ais necessary to properl=
y "open" a famfs-mode daxdev.=0D=0A=0D=0ASigned-off-by: John Groves <john=
@groves.net>=0D=0A---=0D=0A fs/famfs/famfs_inode.c    | 240 +++++++++++++=
+++++++++++++++++++++++++=0D=0A fs/famfs/famfs_internal.h |  46 ++++++++=0D=
=0A 2 files changed, 286 insertions(+)=0D=0A=0D=0Adiff --git a/fs/famfs/f=
amfs_inode.c b/fs/famfs/famfs_inode.c=0D=0Aindex 5a13903da61b..5735d8d190=
0b 100644=0D=0A--- a/fs/famfs/famfs_inode.c=0D=0A+++ b/fs/famfs/famfs_ino=
de.c=0D=0A@@ -76,6 +76,231 @@ famfs_get_inode(=0D=0A /*=0D=0A  * famfs da=
x_operations (for famfs-mode dax)=0D=0A  */=0D=0A+static void famfs_set_d=
axdev_err(struct famfs_fs_info *fsi,=0D=0A+=09=09=09=09 struct dax_device=
 *dax_devp);=0D=0A+=0D=0A+static int=0D=0A+famfs_dax_notify_failure(=0D=0A=
+=09struct dax_device *dax_dev,=0D=0A+=09u64 offset,=0D=0A+=09u64 len,=0D=
=0A+=09int mf_flags)=0D=0A+{=0D=0A+=09struct super_block *sb =3D dax_hold=
er(dax_dev);=0D=0A+=09struct famfs_fs_info *fsi =3D sb->s_fs_info;=0D=0A+=
=0D=0A+=09pr_err("%s: offset=3D%lld len=3D%llu flags=3D%x\n", __func__,=0D=
=0A+=09       offset, len, mf_flags);=0D=0A+=0D=0A+=09/*=0D=0A+=09 * Reco=
rd the error on the specific daxdev and, near-term, shut the=0D=0A+=09 * =
mount down: famfs_set_daxdev_err() also sets fsi->deverror so=0D=0A+=09 *=
 subsequent famfs operations fail. The resolver's per-daxdev=0D=0A+=09 * =
famfs_dax_err() check remains and can make this finer later.=0D=0A+=09 */=
=0D=0A+=09famfs_set_daxdev_err(fsi, dax_dev);=0D=0A+=0D=0A+=09return 0;=0D=
=0A+}=0D=0A+=0D=0A+static const struct dax_holder_operations famfs_dax_ho=
lder_ops =3D {=0D=0A+=09.notify_failure=09=09=3D famfs_dax_notify_failure=
,=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A+ * Allocate the daxdev table on first us=
e (idempotent via cmpxchg).=0D=0A+ */=0D=0A+int=0D=0A+famfs_devlist_alloc=
(struct famfs_fs_info *fsi)=0D=0A+{=0D=0A+=09struct famfs_dax_devlist *de=
vlist;=0D=0A+=0D=0A+=09if (fsi->dax_devlist)=0D=0A+=09=09return 0;=0D=0A+=
=0D=0A+=09devlist =3D kcalloc(1, sizeof(*devlist), GFP_KERNEL);=0D=0A+=09=
if (!devlist)=0D=0A+=09=09return -ENOMEM;=0D=0A+=0D=0A+=09devlist->nslots=
 =3D FAMFS_MAX_DAXDEVS;=0D=0A+=09devlist->devlist =3D kcalloc(FAMFS_MAX_D=
AXDEVS, sizeof(struct famfs_daxdev),=0D=0A+=09=09=09=09   GFP_KERNEL);=0D=
=0A+=09if (!devlist->devlist) {=0D=0A+=09=09kfree(devlist);=0D=0A+=09=09r=
eturn -ENOMEM;=0D=0A+=09}=0D=0A+=0D=0A+=09/* If another thread allocated =
it first, drop ours */=0D=0A+=09if (cmpxchg(&fsi->dax_devlist, NULL, devl=
ist) !=3D NULL) {=0D=0A+=09=09kfree(devlist->devlist);=0D=0A+=09=09kfree(=
devlist);=0D=0A+=09}=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+/*=0D=
=0A+ * famfs_install_daxdev() - exclusively acquire a resolved daxdev and=
 publish=0D=0A+ * it in the table at @index. Slot 0 is the mount primary;=
 slots 1..n come from=0D=0A+ * the daxdev-open ioctl.=0D=0A+ *=0D=0A+ * S=
erializes with concurrent installers under devlist_sem and rechecks=0D=0A=
+ * ->valid, so re-registering an already-installed slot is idempotent. A=
 daxdev=0D=0A+ * is entered in the table only once it has been exclusivel=
y acquired via=0D=0A+ * fs_dax_get() (with the super_block as the holder)=
; on failure the=0D=0A+ * dax_dev_find() reference is released and the sl=
ot is left invalid. @name may=0D=0A+ * be NULL (the ioctl path passes no =
pathname).=0D=0A+ */=0D=0A+int=0D=0A+famfs_install_daxdev(=0D=0A+=09struc=
t famfs_fs_info *fsi,=0D=0A+=09struct super_block *sb,=0D=0A+=09u64 index=
,=0D=0A+=09dev_t devno,=0D=0A+=09const char *name)=0D=0A+{=0D=0A+=09struc=
t famfs_daxdev *daxdev;=0D=0A+=09int rc =3D 0;=0D=0A+=0D=0A+=09if (index =
>=3D fsi->dax_devlist->nslots) {=0D=0A+=09=09pr_debug("%s: index(%llu) >=3D=
 nslots(%d)\n",=0D=0A+=09=09       __func__, index, fsi->dax_devlist->nsl=
ots);=0D=0A+=09=09return -EINVAL;=0D=0A+=09}=0D=0A+=0D=0A+=09scoped_guard=
(rwsem_write, &fsi->devlist_sem) {=0D=0A+=09=09daxdev =3D &fsi->dax_devli=
st->devlist[index];=0D=0A+=0D=0A+=09=09/* Installed already by a concurre=
nt (or repeated) open */=0D=0A+=09=09if (daxdev->valid)=0D=0A+=09=09=09re=
turn 0;=0D=0A+=0D=0A+=09=09/*=0D=0A+=09=09 * A prior attempt already dete=
rmined this daxdev cannot be=0D=0A+=09=09 * exclusively acquired (see the=
 fs_dax_get() failure handling=0D=0A+=09=09 * below). Don't thrash on fs_=
dax_get(); fail fast.=0D=0A+=09=09 */=0D=0A+=09=09if (daxdev->dax_err)=0D=
=0A+=09=09=09return -EIO;=0D=0A+=0D=0A+=09=09daxdev->devp =3D dax_dev_fin=
d(devno);=0D=0A+=09=09if (!daxdev->devp) {=0D=0A+=09=09=09pr_debug("%s: d=
evice %u:%u not found or not dax\n",=0D=0A+=09=09=09=09__func__, MAJOR(de=
vno), MINOR(devno));=0D=0A+=09=09=09return -ENODEV;=0D=0A+=09=09}=0D=0A+=0D=
=0A+=09=09rc =3D fs_dax_get(daxdev->devp, sb, &famfs_dax_holder_ops);=0D=0A=
+=09=09if (rc) {=0D=0A+=09=09=09/*=0D=0A+=09=09=09 * Distinguish a lost r=
ace from a real failure. -EBUSY=0D=0A+=09=09=09 * with the daxdev already=
 held by *this* super_block=0D=0A+=09=09=09 * means a concurrent acquire =
won and will publish the=0D=0A+=09=09=09 * slot valid: not an error, and =
must not be cached as=0D=0A+=09=09=09 * dax_err. Any other failure is per=
manent for this=0D=0A+=09=09=09 * mount, so record dax_err to stop re-acq=
uiring it.=0D=0A+=09=09=09 */=0D=0A+=09=09=09if (!(rc =3D=3D -EBUSY && da=
x_holder(daxdev->devp) =3D=3D sb)) {=0D=0A+=09=09=09=09pr_debug("%s: fs_d=
ax_get(%u:%u) failed rc=3D%d\n",=0D=0A+=09=09=09=09       __func__, MAJOR=
(devno), MINOR(devno), rc);=0D=0A+=09=09=09=09daxdev->dax_err =3D true;=0D=
=0A+=09=09=09}=0D=0A+=09=09=09put_dax(daxdev->devp);=0D=0A+=09=09=09daxde=
v->devp =3D NULL;=0D=0A+=09=09=09return rc;=0D=0A+=09=09}=0D=0A+=0D=0A+=09=
=09daxdev->devno =3D devno;=0D=0A+=09=09if (name) {=0D=0A+=09=09=09daxdev=
->name =3D kstrdup(name, GFP_KERNEL);=0D=0A+=09=09=09if (!daxdev->name) {=
=0D=0A+=09=09=09=09fs_put_dax(daxdev->devp, sb);=0D=0A+=09=09=09=09put_da=
x(daxdev->devp);=0D=0A+=09=09=09=09daxdev->devp =3D NULL;=0D=0A+=09=09=09=
=09return -ENOMEM;=0D=0A+=09=09=09}=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09wmb(=
); /* All other fields must be visible before valid */=0D=0A+=09=09daxdev=
->valid =3D 1;=0D=0A+=09}=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+=
/*=0D=0A+ * Release every daxdev in the table and free it. Detach the tab=
le under=0D=0A+ * devlist_sem so a notify_failure racing teardown either =
runs first against=0D=0A+ * the live table or observes dax_devlist =3D=3D=
 NULL and bails.=0D=0A+ */=0D=0A+static=0D=0A+void famfs_devlist_free(=0D=
=0A+=09struct famfs_fs_info *fsi,=0D=0A+=09struct super_block *sb)=0D=0A+=
{=0D=0A+=09struct famfs_dax_devlist *devlist __free(kfree) =3D NULL;=0D=0A=
+=09int i;=0D=0A+=0D=0A+=09scoped_guard(rwsem_write, &fsi->devlist_sem) {=
=0D=0A+=09=09devlist =3D fsi->dax_devlist;=0D=0A+=09=09fsi->dax_devlist =3D=
 NULL;=0D=0A+=09}=0D=0A+=0D=0A+=09if (!devlist || !devlist->devlist)=0D=0A=
+=09=09return;=0D=0A+=0D=0A+=09for (i =3D 0; i < devlist->nslots; i++) {=0D=
=0A+=09=09struct famfs_daxdev *dd =3D &devlist->devlist[i];=0D=0A+=0D=0A+=
=09=09if (!dd->valid)=0D=0A+=09=09=09continue;=0D=0A+=0D=0A+=09=09if (dd-=
>devp) {=0D=0A+=09=09=09if (!dd->dax_err)=0D=0A+=09=09=09=09fs_put_dax(dd=
->devp, sb);=0D=0A+=09=09=09put_dax(dd->devp);=0D=0A+=09=09}=0D=0A+=09=09=
kfree(dd->name);=0D=0A+=09}=0D=0A+=09kfree(devlist->devlist);=0D=0A+}=0D=0A=
+=0D=0A+/*=0D=0A+ * Record a memory error on the daxdev matching @dax_dev=
p. Searches the table=0D=0A+ * under the write lock (which serializes aga=
inst famfs_devlist_free()).=0D=0A+ */=0D=0A+static void=0D=0A+famfs_set_d=
axdev_err(=0D=0A+=09struct famfs_fs_info *fsi,=0D=0A+=09struct dax_device=
 *dax_devp)=0D=0A+{=0D=0A+=09int i;=0D=0A+=0D=0A+=09scoped_guard(rwsem_wr=
ite, &fsi->devlist_sem) {=0D=0A+=09=09if (!fsi->dax_devlist)=0D=0A+=09=09=
=09return;=0D=0A+=09=09for (i =3D 0; i < fsi->dax_devlist->nslots; i++) {=
=0D=0A+=09=09=09struct famfs_daxdev *dd =3D &fsi->dax_devlist->devlist[i]=
;=0D=0A+=0D=0A+=09=09=09if (!dd->valid || dd->devp !=3D dax_devp)=0D=0A+=09=
=09=09=09continue;=0D=0A+=0D=0A+=09=09=09dd->error =3D true;=0D=0A+=09=09=
=09/*=0D=0A+=09=09=09 * Near-term policy: any daxdev memory error shuts d=
own=0D=0A+=09=09=09 * the whole mount. Finer per-daxdev handling (via=0D=0A=
+=09=09=09 * famfs_dax_err() in the resolver) already exists and=0D=0A+=09=
=09=09 * can supersede this later.=0D=0A+=09=09=09 */=0D=0A+=09=09=09fsi-=
>deverror =3D true;=0D=0A+=09=09=09pr_err("%s: memory error on daxdev %s =
(%d)\n",=0D=0A+=09=09=09       __func__, dd->name, i);=0D=0A+=09=09=09ret=
urn;=0D=0A+=09=09}=0D=0A+=09}=0D=0A+=09pr_debug("%s: memory error on unre=
cognized daxdev\n", __func__);=0D=0A+}=0D=0A+=0D=0A /********************=
*********************************************************=0D=0A  * fs_con=
text_operations=0D=0A  */=0D=0A@@ -159,6 +384,18 @@ famfs_get_tree(struct=
 fs_context *fc)=0D=0A =09=09famfs_fill_super(sb, fc);=0D=0A =09}=0D=0A=20=
=0D=0A+=09/* Install the primary daxdev (from the mount device) at slot 0=
 */=0D=0A+=09err =3D famfs_devlist_alloc(fsi);=0D=0A+=09if (err)=0D=0A+=09=
=09goto deactivate_out;=0D=0A+=0D=0A+=09err =3D famfs_install_daxdev(fsi,=
 sb, 0, daxdevno, fc->source);=0D=0A+=09if (err) {=0D=0A+=09=09pr_err("%s=
: failed to install primary daxdev %s\n",=0D=0A+=09=09       __func__, fc=
->source);=0D=0A+=09=09goto deactivate_out;=0D=0A+=09}=0D=0A+=0D=0A =09in=
ode =3D famfs_get_inode(sb, NULL, S_IFDIR | fsi->mount_opts.mode, 0);=0D=0A=
 =09sb->s_root =3D d_make_root(inode);=0D=0A =09if (!sb->s_root) {=0D=0A@=
@ -247,6 +484,7 @@ famfs_init_fs_context(struct fs_context *fc)=0D=0A =09=
if (!fsi)=0D=0A =09=09return -ENOMEM;=0D=0A=20=0D=0A+=09init_rwsem(&fsi->=
devlist_sem);=0D=0A =09fsi->mount_opts.mode =3D FAMFS_DEFAULT_MODE;=0D=0A=
 =09fc->s_fs_info        =3D fsi;=0D=0A =09fc->ops              =3D &famf=
s_context_ops;=0D=0A@@ -258,6 +496,8 @@ famfs_kill_sb(struct super_block =
*sb)=0D=0A {=0D=0A =09struct famfs_fs_info *fsi =3D sb->s_fs_info;=0D=0A=20=
=0D=0A+=09famfs_devlist_free(fsi, sb);=0D=0A+=0D=0A =09kill_char_super(sb=
);=0D=0A=20=0D=0A =09kfree(fsi);=0D=0Adiff --git a/fs/famfs/famfs_interna=
l.h b/fs/famfs/famfs_internal.h=0D=0Aindex 378544b1aabe..37f667b2b79a 100=
644=0D=0A--- a/fs/famfs/famfs_internal.h=0D=0A+++ b/fs/famfs/famfs_intern=
al.h=0D=0A@@ -11,22 +11,68 @@=0D=0A #ifndef FAMFS_INTERNAL_H=0D=0A #defin=
e FAMFS_INTERNAL_H=0D=0A=20=0D=0A+#include <linux/rwsem.h>=0D=0A+#include=
 <linux/bits.h>=0D=0A+#include <linux/build_bug.h>=0D=0A+=0D=0A struct fa=
mfs_mount_opts {=0D=0A =09umode_t mode;=0D=0A };=0D=0A=20=0D=0A+/*=0D=0A+=
 * famfs_daxdev - one entry in the per-superblock daxdev table=0D=0A+ *=0D=
=0A+ * @valid:   slot is populated and the daxdev has been exclusively ac=
quired=0D=0A+ * @error:   dax reported a memory error (probably poison) v=
ia notify_failure=0D=0A+ * @dax_err: fs_dax_get() failed for this daxdev=0D=
=0A+ * @devno:   dax device dev_t=0D=0A+ * @devp:    the acquired dax_dev=
ice=0D=0A+ * @name:    dax device path (may be NULL for ioctl-registered =
daxdevs)=0D=0A+ */=0D=0A+struct famfs_daxdev {=0D=0A+=09bool valid;=0D=0A=
+=09bool error;=0D=0A+=09bool dax_err;=0D=0A+=09dev_t devno;=0D=0A+=09str=
uct dax_device *devp;=0D=0A+=09char *name;=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A=
+ * The daxdev index space (and thus this table) is capped at 64 so the s=
et of=0D=0A+ * daxdev indices referenced by a file's fmap fits in a u64 b=
itmap.=0D=0A+ */=0D=0A+#define FAMFS_MAX_DAXDEVS 64=0D=0A+static_assert(B=
ITS_PER_TYPE(u64) >=3D FAMFS_MAX_DAXDEVS);=0D=0A+=0D=0A+/*=0D=0A+ * famfs=
_dax_devlist - the per-superblock table of famfs_daxdev's. Slot 0 is=0D=0A=
+ * the primary daxdev supplied at mount; slots 1..n are registered via i=
octl.=0D=0A+ */=0D=0A+struct famfs_dax_devlist {=0D=0A+=09int nslots;=0D=0A=
+=09struct famfs_daxdev *devlist;=0D=0A+};=0D=0A+=0D=0A /**=0D=0A  * @fam=
fs_fs_info=0D=0A  *=0D=0A  * @mount_opts:  The mount options=0D=0A  * @de=
verror:    True if the dax device has called our notify_failure entry=0D=0A=
  *               point, or if other "shutdown" conditions exist=0D=0A+ *=
 @dax_devlist: Table of backing daxdevs (slot 0 is the mount primary)=0D=0A=
+ * @devlist_sem: Serializes installs into, and teardown of, @dax_devlist=
=0D=0A  */=0D=0A struct famfs_fs_info {=0D=0A =09struct famfs_mount_opts =
  mount_opts;=0D=0A =09bool                      deverror;=0D=0A+=09struc=
t famfs_dax_devlist *dax_devlist;=0D=0A+=09struct rw_semaphore       devl=
ist_sem;=0D=0A };=0D=0A=20=0D=0A int famfs_lookup_daxdev(const char *path=
name, dev_t *devno);=0D=0A+int famfs_devlist_alloc(struct famfs_fs_info *=
fsi);=0D=0A+int famfs_install_daxdev(struct famfs_fs_info *fsi, struct su=
per_block *sb,=0D=0A+=09=09=09 u64 index, dev_t devno, const char *name);=
=0D=0A=20=0D=0A #endif /* FAMFS_INTERNAL_H */=0D=0A--=20=0D=0A2.53.0=0D=0A=
=0D=0A
