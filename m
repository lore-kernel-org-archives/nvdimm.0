Received: from a11-77.smtp-out.amazonses.com (a11-77.smtp-out.amazonses.com [54.240.11.77])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB973F9F28;
	Sat, 29 Aug 2026 17:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788023478; cv=none; b=QIZNhWNdGtvPBOC1SoEOuBxUJP7YCrSBn82BqZcqMYVicyuJRIn6yb3ZDBYsJOaMTmsmiUaXt87IW4O6OF4DmJ70mVR9ge0od5CowEEZ3Cxf24LiKZXWfLTGoB32TsJxbe2HAwOFVa962OHmJAxhi+5Dyg2n+TF44F9/Ra9XYY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788023478; c=relaxed/simple;
	bh=PAgferPPB+OkIodQMsevNLDt5Ojf1nSXI7eN1+eOSik=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=qjFbO04742fHrhZqsGJ3tRKGt9hLZ0i4wFvuAk9BhZK2LxoBkCDblKDCYC+/AyZxzeOlgPHCEwLnxLPVosfpyA4KnlGP/YFQszNUAPmaa2XdYtzUsWOxbor1RmJRNqcci9SIYJ/8SEb7d/5Z2NHunoNeCdbning0ce1V/q37yhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=pBzpmgFw; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=WPnyC8DL; arc=none smtp.client-ip=54.240.11.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="pBzpmgFw";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="WPnyC8DL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=rjayupzefgi7e6fmzxcxe4cv4arrjs35; d=jagalactic.com; t=1788023472;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=PAgferPPB+OkIodQMsevNLDt5Ojf1nSXI7eN1+eOSik=;
	b=pBzpmgFwtDodM01rnKDOQT6aDjxRc/LYOgZMVU1YIV8JVOvnQuMvuPFapwC26i3D
	nev/uqKlbrkPIQeezGIcwCh8/QXRW+J21rPjxtLoaWlyx1zO4+KxVzwqY/cV2flE4VS
	MZT6F4skUoBtkq6k6GX17cmHMdlEM+SBo04kmrD8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1788023472;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=PAgferPPB+OkIodQMsevNLDt5Ojf1nSXI7eN1+eOSik=;
	b=WPnyC8DLZXya67cPAEinmji0AnZedHwAkEB7r+PRmNTN64zQbEf80D8ppNyjIy+u
	CnCXZ00wgdekXavwwPde2Bz83BkQi2GY/TMbFnINYK/cGW2X6EtVQRyhU8OLYhE5I+G
	nbcEfnhvaTNViXZc5zCfG/+gutYDmBtkrb57Lq/0=
Subject: [PATCH V14 03/12] famfs: Add daxdev table and dax notify_failure
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
Date: Sat, 29 Aug 2026 17:11:12 +0000
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
 <20260829171104.7394-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdN9lAfqnLmnnsQyaIwPphM+3eHAAACNaz
Thread-Topic: [PATCH V14 03/12] famfs: Add daxdev table and dax
 notify_failure support
X-Wm-Sent-Timestamp: 1788023471
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <010001a04e8100cf-a8efea37-2f0c-4862-b4a9-9dc70cf04b34-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.29-54.240.11.77

From: John Groves <John@Groves.net>=0D=0A=0D=0AFamfs file systems can spa=
n multiple dax devices, and daxdevs are stored=0D=0Ain the daxdev_table. =
This adds the basic table structure, primtives and=0D=0Aserialization cod=
e. Famfs file extents reference daxdevs by index, which=0D=0Ais a cluster=
 invariant maintained by user space.=0D=0A=0D=0AWe also add dax_holder_op=
erations and a notify_failure handler, which=0D=0Ais necessary to properl=
y "open" a famfs-mode daxdev.=0D=0A=0D=0AReviewed-by: "Darrick J. Wong" <=
djwong@kernel.org>=0D=0AReviewed-by: Jeff Layton <jlayton@kernel.org>=0D=0A=
Signed-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A fs/famfs/famf=
s_inode.c    | 240 ++++++++++++++++++++++++++++++++++++++=0D=0A fs/famfs/=
famfs_internal.h |  46 ++++++++=0D=0A 2 files changed, 286 insertions(+)=0D=
=0A=0D=0Adiff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c=0D=0A=
index 5a13903da61b..5735d8d1900b 100644=0D=0A--- a/fs/famfs/famfs_inode.c=
=0D=0A+++ b/fs/famfs/famfs_inode.c=0D=0A@@ -76,6 +76,231 @@ famfs_get_ino=
de(=0D=0A /*=0D=0A  * famfs dax_operations (for famfs-mode dax)=0D=0A  */=
=0D=0A+static void famfs_set_daxdev_err(struct famfs_fs_info *fsi,=0D=0A+=
=09=09=09=09 struct dax_device *dax_devp);=0D=0A+=0D=0A+static int=0D=0A+=
famfs_dax_notify_failure(=0D=0A+=09struct dax_device *dax_dev,=0D=0A+=09u=
64 offset,=0D=0A+=09u64 len,=0D=0A+=09int mf_flags)=0D=0A+{=0D=0A+=09stru=
ct super_block *sb =3D dax_holder(dax_dev);=0D=0A+=09struct famfs_fs_info=
 *fsi =3D sb->s_fs_info;=0D=0A+=0D=0A+=09pr_err("%s: offset=3D%lld len=3D=
%llu flags=3D%x\n", __func__,=0D=0A+=09       offset, len, mf_flags);=0D=0A=
+=0D=0A+=09/*=0D=0A+=09 * Record the error on the specific daxdev and, ne=
ar-term, shut the=0D=0A+=09 * mount down: famfs_set_daxdev_err() also set=
s fsi->deverror so=0D=0A+=09 * subsequent famfs operations fail. The reso=
lver's per-daxdev=0D=0A+=09 * famfs_dax_err() check remains and can make =
this finer later.=0D=0A+=09 */=0D=0A+=09famfs_set_daxdev_err(fsi, dax_dev=
);=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static const struct dax=
_holder_operations famfs_dax_holder_ops =3D {=0D=0A+=09.notify_failure=09=
=09=3D famfs_dax_notify_failure,=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A+ * Alloca=
te the daxdev table on first use (idempotent via cmpxchg).=0D=0A+ */=0D=0A=
+int=0D=0A+famfs_devlist_alloc(struct famfs_fs_info *fsi)=0D=0A+{=0D=0A+=09=
struct famfs_dax_devlist *devlist;=0D=0A+=0D=0A+=09if (fsi->dax_devlist)=0D=
=0A+=09=09return 0;=0D=0A+=0D=0A+=09devlist =3D kcalloc(1, sizeof(*devlis=
t), GFP_KERNEL);=0D=0A+=09if (!devlist)=0D=0A+=09=09return -ENOMEM;=0D=0A=
+=0D=0A+=09devlist->nslots =3D FAMFS_MAX_DAXDEVS;=0D=0A+=09devlist->devli=
st =3D kcalloc(FAMFS_MAX_DAXDEVS, sizeof(struct famfs_daxdev),=0D=0A+=09=09=
=09=09   GFP_KERNEL);=0D=0A+=09if (!devlist->devlist) {=0D=0A+=09=09kfree=
(devlist);=0D=0A+=09=09return -ENOMEM;=0D=0A+=09}=0D=0A+=0D=0A+=09/* If a=
nother thread allocated it first, drop ours */=0D=0A+=09if (cmpxchg(&fsi-=
>dax_devlist, NULL, devlist) !=3D NULL) {=0D=0A+=09=09kfree(devlist->devl=
ist);=0D=0A+=09=09kfree(devlist);=0D=0A+=09}=0D=0A+=0D=0A+=09return 0;=0D=
=0A+}=0D=0A+=0D=0A+/*=0D=0A+ * famfs_install_daxdev() - exclusively acqui=
re a resolved daxdev and publish=0D=0A+ * it in the table at @index. Slot=
 0 is the mount primary; slots 1..n come from=0D=0A+ * the daxdev-open io=
ctl.=0D=0A+ *=0D=0A+ * Serializes with concurrent installers under devlis=
t_sem and rechecks=0D=0A+ * ->valid, so re-registering an already-install=
ed slot is idempotent. A daxdev=0D=0A+ * is entered in the table only onc=
e it has been exclusively acquired via=0D=0A+ * fs_dax_get() (with the su=
per_block as the holder); on failure the=0D=0A+ * dax_dev_find() referenc=
e is released and the slot is left invalid. @name may=0D=0A+ * be NULL (t=
he ioctl path passes no pathname).=0D=0A+ */=0D=0A+int=0D=0A+famfs_instal=
l_daxdev(=0D=0A+=09struct famfs_fs_info *fsi,=0D=0A+=09struct super_block=
 *sb,=0D=0A+=09u64 index,=0D=0A+=09dev_t devno,=0D=0A+=09const char *name=
)=0D=0A+{=0D=0A+=09struct famfs_daxdev *daxdev;=0D=0A+=09int rc =3D 0;=0D=
=0A+=0D=0A+=09if (index >=3D fsi->dax_devlist->nslots) {=0D=0A+=09=09pr_d=
ebug("%s: index(%llu) >=3D nslots(%d)\n",=0D=0A+=09=09       __func__, in=
dex, fsi->dax_devlist->nslots);=0D=0A+=09=09return -EINVAL;=0D=0A+=09}=0D=
=0A+=0D=0A+=09scoped_guard(rwsem_write, &fsi->devlist_sem) {=0D=0A+=09=09=
daxdev =3D &fsi->dax_devlist->devlist[index];=0D=0A+=0D=0A+=09=09/* Insta=
lled already by a concurrent (or repeated) open */=0D=0A+=09=09if (daxdev=
->valid)=0D=0A+=09=09=09return 0;=0D=0A+=0D=0A+=09=09/*=0D=0A+=09=09 * A =
prior attempt already determined this daxdev cannot be=0D=0A+=09=09 * exc=
lusively acquired (see the fs_dax_get() failure handling=0D=0A+=09=09 * b=
elow). Don't thrash on fs_dax_get(); fail fast.=0D=0A+=09=09 */=0D=0A+=09=
=09if (daxdev->dax_err)=0D=0A+=09=09=09return -EIO;=0D=0A+=0D=0A+=09=09da=
xdev->devp =3D dax_dev_find(devno);=0D=0A+=09=09if (!daxdev->devp) {=0D=0A=
+=09=09=09pr_debug("%s: device %u:%u not found or not dax\n",=0D=0A+=09=09=
=09=09__func__, MAJOR(devno), MINOR(devno));=0D=0A+=09=09=09return -ENODE=
V;=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09rc =3D fs_dax_get(daxdev->devp, sb, &=
famfs_dax_holder_ops);=0D=0A+=09=09if (rc) {=0D=0A+=09=09=09/*=0D=0A+=09=09=
=09 * Distinguish a lost race from a real failure. -EBUSY=0D=0A+=09=09=09=
 * with the daxdev already held by *this* super_block=0D=0A+=09=09=09 * m=
eans a concurrent acquire won and will publish the=0D=0A+=09=09=09 * slot=
 valid: not an error, and must not be cached as=0D=0A+=09=09=09 * dax_err=
=2E Any other failure is permanent for this=0D=0A+=09=09=09 * mount, so r=
ecord dax_err to stop re-acquiring it.=0D=0A+=09=09=09 */=0D=0A+=09=09=09=
if (!(rc =3D=3D -EBUSY && dax_holder(daxdev->devp) =3D=3D sb)) {=0D=0A+=09=
=09=09=09pr_debug("%s: fs_dax_get(%u:%u) failed rc=3D%d\n",=0D=0A+=09=09=09=
=09       __func__, MAJOR(devno), MINOR(devno), rc);=0D=0A+=09=09=09=09da=
xdev->dax_err =3D true;=0D=0A+=09=09=09}=0D=0A+=09=09=09put_dax(daxdev->d=
evp);=0D=0A+=09=09=09daxdev->devp =3D NULL;=0D=0A+=09=09=09return rc;=0D=0A=
+=09=09}=0D=0A+=0D=0A+=09=09daxdev->devno =3D devno;=0D=0A+=09=09if (name=
) {=0D=0A+=09=09=09daxdev->name =3D kstrdup(name, GFP_KERNEL);=0D=0A+=09=09=
=09if (!daxdev->name) {=0D=0A+=09=09=09=09fs_put_dax(daxdev->devp, sb);=0D=
=0A+=09=09=09=09put_dax(daxdev->devp);=0D=0A+=09=09=09=09daxdev->devp =3D=
 NULL;=0D=0A+=09=09=09=09return -ENOMEM;=0D=0A+=09=09=09}=0D=0A+=09=09}=0D=
=0A+=0D=0A+=09=09wmb(); /* All other fields must be visible before valid =
*/=0D=0A+=09=09daxdev->valid =3D 1;=0D=0A+=09}=0D=0A+=0D=0A+=09return 0;=0D=
=0A+}=0D=0A+=0D=0A+/*=0D=0A+ * Release every daxdev in the table and free=
 it. Detach the table under=0D=0A+ * devlist_sem so a notify_failure raci=
ng teardown either runs first against=0D=0A+ * the live table or observes=
 dax_devlist =3D=3D NULL and bails.=0D=0A+ */=0D=0A+static=0D=0A+void fam=
fs_devlist_free(=0D=0A+=09struct famfs_fs_info *fsi,=0D=0A+=09struct supe=
r_block *sb)=0D=0A+{=0D=0A+=09struct famfs_dax_devlist *devlist __free(kf=
ree) =3D NULL;=0D=0A+=09int i;=0D=0A+=0D=0A+=09scoped_guard(rwsem_write, =
&fsi->devlist_sem) {=0D=0A+=09=09devlist =3D fsi->dax_devlist;=0D=0A+=09=09=
fsi->dax_devlist =3D NULL;=0D=0A+=09}=0D=0A+=0D=0A+=09if (!devlist || !de=
vlist->devlist)=0D=0A+=09=09return;=0D=0A+=0D=0A+=09for (i =3D 0; i < dev=
list->nslots; i++) {=0D=0A+=09=09struct famfs_daxdev *dd =3D &devlist->de=
vlist[i];=0D=0A+=0D=0A+=09=09if (!dd->valid)=0D=0A+=09=09=09continue;=0D=0A=
+=0D=0A+=09=09if (dd->devp) {=0D=0A+=09=09=09if (!dd->dax_err)=0D=0A+=09=09=
=09=09fs_put_dax(dd->devp, sb);=0D=0A+=09=09=09put_dax(dd->devp);=0D=0A+=09=
=09}=0D=0A+=09=09kfree(dd->name);=0D=0A+=09}=0D=0A+=09kfree(devlist->devl=
ist);=0D=0A+}=0D=0A+=0D=0A+/*=0D=0A+ * Record a memory error on the daxde=
v matching @dax_devp. Searches the table=0D=0A+ * under the write lock (w=
hich serializes against famfs_devlist_free()).=0D=0A+ */=0D=0A+static voi=
d=0D=0A+famfs_set_daxdev_err(=0D=0A+=09struct famfs_fs_info *fsi,=0D=0A+=09=
struct dax_device *dax_devp)=0D=0A+{=0D=0A+=09int i;=0D=0A+=0D=0A+=09scop=
ed_guard(rwsem_write, &fsi->devlist_sem) {=0D=0A+=09=09if (!fsi->dax_devl=
ist)=0D=0A+=09=09=09return;=0D=0A+=09=09for (i =3D 0; i < fsi->dax_devlis=
t->nslots; i++) {=0D=0A+=09=09=09struct famfs_daxdev *dd =3D &fsi->dax_de=
vlist->devlist[i];=0D=0A+=0D=0A+=09=09=09if (!dd->valid || dd->devp !=3D =
dax_devp)=0D=0A+=09=09=09=09continue;=0D=0A+=0D=0A+=09=09=09dd->error =3D=
 true;=0D=0A+=09=09=09/*=0D=0A+=09=09=09 * Near-term policy: any daxdev m=
emory error shuts down=0D=0A+=09=09=09 * the whole mount. Finer per-daxde=
v handling (via=0D=0A+=09=09=09 * famfs_dax_err() in the resolver) alread=
y exists and=0D=0A+=09=09=09 * can supersede this later.=0D=0A+=09=09=09 =
*/=0D=0A+=09=09=09fsi->deverror =3D true;=0D=0A+=09=09=09pr_err("%s: memo=
ry error on daxdev %s (%d)\n",=0D=0A+=09=09=09       __func__, dd->name, =
i);=0D=0A+=09=09=09return;=0D=0A+=09=09}=0D=0A+=09}=0D=0A+=09pr_debug("%s=
: memory error on unrecognized daxdev\n", __func__);=0D=0A+}=0D=0A+=0D=0A=
 /***********************************************************************=
******=0D=0A  * fs_context_operations=0D=0A  */=0D=0A@@ -159,6 +384,18 @@=
 famfs_get_tree(struct fs_context *fc)=0D=0A =09=09famfs_fill_super(sb, f=
c);=0D=0A =09}=0D=0A=20=0D=0A+=09/* Install the primary daxdev (from the =
mount device) at slot 0 */=0D=0A+=09err =3D famfs_devlist_alloc(fsi);=0D=0A=
+=09if (err)=0D=0A+=09=09goto deactivate_out;=0D=0A+=0D=0A+=09err =3D fam=
fs_install_daxdev(fsi, sb, 0, daxdevno, fc->source);=0D=0A+=09if (err) {=0D=
=0A+=09=09pr_err("%s: failed to install primary daxdev %s\n",=0D=0A+=09=09=
       __func__, fc->source);=0D=0A+=09=09goto deactivate_out;=0D=0A+=09}=
=0D=0A+=0D=0A =09inode =3D famfs_get_inode(sb, NULL, S_IFDIR | fsi->mount=
_opts.mode, 0);=0D=0A =09sb->s_root =3D d_make_root(inode);=0D=0A =09if (=
!sb->s_root) {=0D=0A@@ -247,6 +484,7 @@ famfs_init_fs_context(struct fs_c=
ontext *fc)=0D=0A =09if (!fsi)=0D=0A =09=09return -ENOMEM;=0D=0A=20=0D=0A=
+=09init_rwsem(&fsi->devlist_sem);=0D=0A =09fsi->mount_opts.mode =3D FAMF=
S_DEFAULT_MODE;=0D=0A =09fc->s_fs_info        =3D fsi;=0D=0A =09fc->ops  =
            =3D &famfs_context_ops;=0D=0A@@ -258,6 +496,8 @@ famfs_kill_s=
b(struct super_block *sb)=0D=0A {=0D=0A =09struct famfs_fs_info *fsi =3D =
sb->s_fs_info;=0D=0A=20=0D=0A+=09famfs_devlist_free(fsi, sb);=0D=0A+=0D=0A=
 =09kill_char_super(sb);=0D=0A=20=0D=0A =09kfree(fsi);=0D=0Adiff --git a/=
fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h=0D=0Aindex 378544b1=
aabe..37f667b2b79a 100644=0D=0A--- a/fs/famfs/famfs_internal.h=0D=0A+++ b=
/fs/famfs/famfs_internal.h=0D=0A@@ -11,22 +11,68 @@=0D=0A #ifndef FAMFS_I=
NTERNAL_H=0D=0A #define FAMFS_INTERNAL_H=0D=0A=20=0D=0A+#include <linux/r=
wsem.h>=0D=0A+#include <linux/bits.h>=0D=0A+#include <linux/build_bug.h>=0D=
=0A+=0D=0A struct famfs_mount_opts {=0D=0A =09umode_t mode;=0D=0A };=0D=0A=
=20=0D=0A+/*=0D=0A+ * famfs_daxdev - one entry in the per-superblock daxd=
ev table=0D=0A+ *=0D=0A+ * @valid:   slot is populated and the daxdev has=
 been exclusively acquired=0D=0A+ * @error:   dax reported a memory error=
 (probably poison) via notify_failure=0D=0A+ * @dax_err: fs_dax_get() fai=
led for this daxdev=0D=0A+ * @devno:   dax device dev_t=0D=0A+ * @devp:  =
  the acquired dax_device=0D=0A+ * @name:    dax device path (may be NULL=
 for ioctl-registered daxdevs)=0D=0A+ */=0D=0A+struct famfs_daxdev {=0D=0A=
+=09bool valid;=0D=0A+=09bool error;=0D=0A+=09bool dax_err;=0D=0A+=09dev_=
t devno;=0D=0A+=09struct dax_device *devp;=0D=0A+=09char *name;=0D=0A+};=0D=
=0A+=0D=0A+/*=0D=0A+ * The daxdev index space (and thus this table) is ca=
pped at 64 so the set of=0D=0A+ * daxdev indices referenced by a file's f=
map fits in a u64 bitmap.=0D=0A+ */=0D=0A+#define FAMFS_MAX_DAXDEVS 64=0D=
=0A+static_assert(BITS_PER_TYPE(u64) >=3D FAMFS_MAX_DAXDEVS);=0D=0A+=0D=0A=
+/*=0D=0A+ * famfs_dax_devlist - the per-superblock table of famfs_daxdev=
's. Slot 0 is=0D=0A+ * the primary daxdev supplied at mount; slots 1..n a=
re registered via ioctl.=0D=0A+ */=0D=0A+struct famfs_dax_devlist {=0D=0A=
+=09int nslots;=0D=0A+=09struct famfs_daxdev *devlist;=0D=0A+};=0D=0A+=0D=
=0A /**=0D=0A  * @famfs_fs_info=0D=0A  *=0D=0A  * @mount_opts:  The mount=
 options=0D=0A  * @deverror:    True if the dax device has called our not=
ify_failure entry=0D=0A  *               point, or if other "shutdown" co=
nditions exist=0D=0A+ * @dax_devlist: Table of backing daxdevs (slot 0 is=
 the mount primary)=0D=0A+ * @devlist_sem: Serializes installs into, and =
teardown of, @dax_devlist=0D=0A  */=0D=0A struct famfs_fs_info {=0D=0A =09=
struct famfs_mount_opts   mount_opts;=0D=0A =09bool                      =
deverror;=0D=0A+=09struct famfs_dax_devlist *dax_devlist;=0D=0A+=09struct=
 rw_semaphore       devlist_sem;=0D=0A };=0D=0A=20=0D=0A int famfs_lookup=
_daxdev(const char *pathname, dev_t *devno);=0D=0A+int famfs_devlist_allo=
c(struct famfs_fs_info *fsi);=0D=0A+int famfs_install_daxdev(struct famfs=
_fs_info *fsi, struct super_block *sb,=0D=0A+=09=09=09 u64 index, dev_t d=
evno, const char *name);=0D=0A=20=0D=0A #endif /* FAMFS_INTERNAL_H */=0D=0A=
--=20=0D=0A2.53.0=0D=0A=0D=0A
