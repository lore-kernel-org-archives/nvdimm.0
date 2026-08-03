Received: from a11-71.smtp-out.amazonses.com (a11-71.smtp-out.amazonses.com [54.240.11.71])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6CC308F32;
	Mon,  3 Aug 2026 02:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724130; cv=none; b=uNScJBCA1pl0eJ17FC2KUu7F3rV9TmbHfchAgFDSavkLiK0rYszw5vt5yCjGMqrHtN8nc6vDUzSOS+vL+ao+Rb2+1GaZcDDNNFZNj8NRaKO+XhnEVjGNKBDa2I1Ul7xFAUCakhA+5+ik+T8ItOJHCXAM4vNcDs5W2zQYuFMmKig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724130; c=relaxed/simple;
	bh=9GHfdcTA9RItQMNj7glgklpmba6rqr2s/xfNiM/3kdc=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=kB7hTp1SqSwdReT3c/3XqDz3asYHklsHo57mP+W+cCmrytfpgjrNjlnLvgFcW+6rZEVp4IGUilVvvW1OFdo9bWlHfIBi2w/vmM9N7AHY1fzDrhlKJJwTCPMDcjWf9s+wNfBNS8HBYG8WMViUbI/xT4in0EGvVhIOyl5aR25114E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=u53mraf2; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=hxMzDY5o; arc=none smtp.client-ip=54.240.11.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="u53mraf2";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="hxMzDY5o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1785724127;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=9GHfdcTA9RItQMNj7glgklpmba6rqr2s/xfNiM/3kdc=;
	b=u53mraf2LsLlNYlRaR9znDnif79rlvd1JLpIYTUzS74xvhWx2xPtwYMCIBb10udf
	MD17zCIl4vxV0tkiGWy4zhLOMpJISx5lP64ETBxDfny7HZ6Gj09vUbkLFaIA1JJAAAf
	jsScni1jCmY9nsfO7nbl5JhIgRO96fFIOdMHcf9A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1785724127;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=9GHfdcTA9RItQMNj7glgklpmba6rqr2s/xfNiM/3kdc=;
	b=hxMzDY5osigJ8bTFHjAEVqxQbnv9yd9MzWAwuHQlGTmzhv7PHOI0lebZbz/IuVE7
	oI5gN4JbeUJqhwYxTJGU4Vjq1WfGDB+XtwI+/FoOkmEWbnt+xDXTXHTjmdqTXelmu1o
	TaPwQbahRbAFk5OGNfiDVoCi6VinS+LXJyCVumpo=
Subject: [PATCH V12 03/12] famfs: Add daxdev table and dax notify_failure
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
Date: Mon, 3 Aug 2026 02:28:47 +0000
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
 <20260803022839.75794-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdIu+ovgpm4enMRRGNw8yF9Kn6iwAACbU3
Thread-Topic: [PATCH V12 03/12] famfs: Add daxdev table and dax
 notify_failure support
X-Wm-Sent-Timestamp: 1785724126
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019fc573c7cd-d37cbc1c-7687-4b05-99e7-7d3624087b98-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.03-54.240.11.71

From: John Groves <John@Groves.net>=0D=0A=0D=0AFamfs file systems can spa=
n multiple dax devices, and daxdevs are stored=0D=0Ain the daxdev_table. =
This adds the basic table structure, primtives and=0D=0Aserialization cod=
e. Famfs file extents reference daxdevs by index, which=0D=0Ais a cluster=
 invariant maintained by user space.=0D=0A=0D=0AWe also add dax_holder_op=
erations and a notify_failure handler, which=0D=0Ais necessary to properl=
y "open" a famfs-mode daxdev.=0D=0A=0D=0ASigned-off-by: John Groves <john=
@groves.net>=0D=0A---=0D=0A fs/famfs/famfs_inode.c    | 234 +++++++++++++=
+++++++++++++++++++++++++=0D=0A fs/famfs/famfs_internal.h |  46 ++++++++=0D=
=0A 2 files changed, 280 insertions(+)=0D=0A=0D=0Adiff --git a/fs/famfs/f=
amfs_inode.c b/fs/famfs/famfs_inode.c=0D=0Aindex c299a90912a5..ad71e5e7a8=
e3 100644=0D=0A--- a/fs/famfs/famfs_inode.c=0D=0A+++ b/fs/famfs/famfs_ino=
de.c=0D=0A@@ -75,6 +75,225 @@ static struct inode *famfs_get_inode(=0D=0A=
 /*=0D=0A  * famfs dax_operations (for famfs-mode dax)=0D=0A  */=0D=0A+st=
atic void famfs_set_daxdev_err(struct famfs_fs_info *fsi,=0D=0A+=09=09=09=
=09 struct dax_device *dax_devp);=0D=0A+=0D=0A+static int=0D=0A+famfs_dax=
_notify_failure(=0D=0A+=09=09struct dax_device *dax_dev, u64 offset,=0D=0A=
+=09=09u64 len, int mf_flags)=0D=0A+{=0D=0A+=09struct super_block *sb =3D=
 dax_holder(dax_dev);=0D=0A+=09struct famfs_fs_info *fsi =3D sb->s_fs_inf=
o;=0D=0A+=0D=0A+=09pr_err("%s: offset=3D%lld len=3D%llu flags=3D%x\n", __=
func__,=0D=0A+=09       offset, len, mf_flags);=0D=0A+=0D=0A+=09/*=0D=0A+=
=09 * Record the error on the specific daxdev and, near-term, shut the=0D=
=0A+=09 * mount down: famfs_set_daxdev_err() also sets fsi->deverror so=0D=
=0A+=09 * subsequent famfs operations fail. The resolver's per-daxdev=0D=0A=
+=09 * famfs_dax_err() check remains and can make this finer later.=0D=0A=
+=09 */=0D=0A+=09famfs_set_daxdev_err(fsi, dax_dev);=0D=0A+=0D=0A+=09retu=
rn 0;=0D=0A+}=0D=0A+=0D=0A+static const struct dax_holder_operations famf=
s_dax_holder_ops =3D {=0D=0A+=09.notify_failure=09=09=3D famfs_dax_notify=
_failure,=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A+ * Allocate the daxdev table on =
first use (idempotent via cmpxchg).=0D=0A+ */=0D=0A+int famfs_devlist_all=
oc(struct famfs_fs_info *fsi)=0D=0A+{=0D=0A+=09struct famfs_dax_devlist *=
devlist;=0D=0A+=0D=0A+=09if (fsi->dax_devlist)=0D=0A+=09=09return 0;=0D=0A=
+=0D=0A+=09devlist =3D kcalloc(1, sizeof(*devlist), GFP_KERNEL);=0D=0A+=09=
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
pathname).=0D=0A+ */=0D=0A+int famfs_install_daxdev(=0D=0A+=09=09struct f=
amfs_fs_info *fsi,=0D=0A+=09=09struct super_block *sb,=0D=0A+=09=09u64 in=
dex,=0D=0A+=09=09dev_t devno,=0D=0A+=09=09const char *name)=0D=0A+{=0D=0A=
+=09struct famfs_daxdev *daxdev;=0D=0A+=09int rc =3D 0;=0D=0A+=0D=0A+=09i=
f (index >=3D fsi->dax_devlist->nslots) {=0D=0A+=09=09pr_debug("%s: index=
(%llu) >=3D nslots(%d)\n",=0D=0A+=09=09       __func__, index, fsi->dax_d=
evlist->nslots);=0D=0A+=09=09return -EINVAL;=0D=0A+=09}=0D=0A+=0D=0A+=09s=
coped_guard(rwsem_write, &fsi->devlist_sem) {=0D=0A+=09=09daxdev =3D &fsi=
->dax_devlist->devlist[index];=0D=0A+=0D=0A+=09=09/* Installed already by=
 a concurrent (or repeated) open */=0D=0A+=09=09if (daxdev->valid)=0D=0A+=
=09=09=09return 0;=0D=0A+=0D=0A+=09=09/*=0D=0A+=09=09 * A prior attempt a=
lready determined this daxdev cannot be=0D=0A+=09=09 * exclusively acquir=
ed (see the fs_dax_get() failure handling=0D=0A+=09=09 * below). Don't th=
rash on fs_dax_get(); fail fast.=0D=0A+=09=09 */=0D=0A+=09=09if (daxdev->=
dax_err)=0D=0A+=09=09=09return -EIO;=0D=0A+=0D=0A+=09=09daxdev->devp =3D =
dax_dev_find(devno);=0D=0A+=09=09if (!daxdev->devp) {=0D=0A+=09=09=09pr_d=
ebug("%s: device %u:%u not found or not dax\n",=0D=0A+=09=09=09=09__func_=
_, MAJOR(devno), MINOR(devno));=0D=0A+=09=09=09return -ENODEV;=0D=0A+=09=09=
}=0D=0A+=0D=0A+=09=09rc =3D fs_dax_get(daxdev->devp, sb, &famfs_dax_holde=
r_ops);=0D=0A+=09=09if (rc) {=0D=0A+=09=09=09/*=0D=0A+=09=09=09 * Disting=
uish a lost race from a real failure. -EBUSY=0D=0A+=09=09=09 * with the d=
axdev already held by *this* super_block=0D=0A+=09=09=09 * means a concur=
rent acquire won and will publish the=0D=0A+=09=09=09 * slot valid: not a=
n error, and must not be cached as=0D=0A+=09=09=09 * dax_err. Any other f=
ailure is permanent for this=0D=0A+=09=09=09 * mount, so record dax_err t=
o stop re-acquiring it.=0D=0A+=09=09=09 */=0D=0A+=09=09=09if (!(rc =3D=3D=
 -EBUSY && dax_holder(daxdev->devp) =3D=3D sb)) {=0D=0A+=09=09=09=09pr_de=
bug("%s: fs_dax_get(%u:%u) failed rc=3D%d\n",=0D=0A+=09=09=09=09       __=
func__, MAJOR(devno), MINOR(devno), rc);=0D=0A+=09=09=09=09daxdev->dax_er=
r =3D true;=0D=0A+=09=09=09}=0D=0A+=09=09=09put_dax(daxdev->devp);=0D=0A+=
=09=09=09daxdev->devp =3D NULL;=0D=0A+=09=09=09return rc;=0D=0A+=09=09}=0D=
=0A+=0D=0A+=09=09daxdev->devno =3D devno;=0D=0A+=09=09if (name) {=0D=0A+=09=
=09=09daxdev->name =3D kstrdup(name, GFP_KERNEL);=0D=0A+=09=09=09if (!dax=
dev->name) {=0D=0A+=09=09=09=09fs_put_dax(daxdev->devp, sb);=0D=0A+=09=09=
=09=09put_dax(daxdev->devp);=0D=0A+=09=09=09=09daxdev->devp =3D NULL;=0D=0A=
+=09=09=09=09return -ENOMEM;=0D=0A+=09=09=09}=0D=0A+=09=09}=0D=0A+=0D=0A+=
=09=09wmb(); /* All other fields must be visible before valid */=0D=0A+=09=
=09daxdev->valid =3D 1;=0D=0A+=09}=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A=
+=0D=0A+/*=0D=0A+ * Release every daxdev in the table and free it. Detach=
 the table under=0D=0A+ * devlist_sem so a notify_failure racing teardown=
 either runs first against=0D=0A+ * the live table or observes dax_devlis=
t =3D=3D NULL and bails.=0D=0A+ */=0D=0A+static void famfs_devlist_free(=0D=
=0A+=09=09=09struct famfs_fs_info *fsi,=0D=0A+=09=09=09struct super_block=
 *sb)=0D=0A+{=0D=0A+=09struct famfs_dax_devlist *devlist __free(kfree) =3D=
 NULL;=0D=0A+=09int i;=0D=0A+=0D=0A+=09scoped_guard(rwsem_write, &fsi->de=
vlist_sem) {=0D=0A+=09=09devlist =3D fsi->dax_devlist;=0D=0A+=09=09fsi->d=
ax_devlist =3D NULL;=0D=0A+=09}=0D=0A+=0D=0A+=09if (!devlist || !devlist-=
>devlist)=0D=0A+=09=09return;=0D=0A+=0D=0A+=09for (i =3D 0; i < devlist->=
nslots; i++) {=0D=0A+=09=09struct famfs_daxdev *dd =3D &devlist->devlist[=
i];=0D=0A+=0D=0A+=09=09if (!dd->valid)=0D=0A+=09=09=09continue;=0D=0A+=0D=
=0A+=09=09if (dd->devp) {=0D=0A+=09=09=09if (!dd->dax_err)=0D=0A+=09=09=09=
=09fs_put_dax(dd->devp, sb);=0D=0A+=09=09=09put_dax(dd->devp);=0D=0A+=09=09=
}=0D=0A+=09=09kfree(dd->name);=0D=0A+=09}=0D=0A+=09kfree(devlist->devlist=
);=0D=0A+}=0D=0A+=0D=0A+/*=0D=0A+ * Record a memory error on the daxdev m=
atching @dax_devp. Searches the table=0D=0A+ * under the write lock (whic=
h serializes against famfs_devlist_free()).=0D=0A+ */=0D=0A+static void f=
amfs_set_daxdev_err(=0D=0A+=09=09=09struct famfs_fs_info *fsi,=0D=0A+=09=09=
=09struct dax_device *dax_devp)=0D=0A+{=0D=0A+=09int i;=0D=0A+=0D=0A+=09s=
coped_guard(rwsem_write, &fsi->devlist_sem) {=0D=0A+=09=09if (!fsi->dax_d=
evlist)=0D=0A+=09=09=09return;=0D=0A+=09=09for (i =3D 0; i < fsi->dax_dev=
list->nslots; i++) {=0D=0A+=09=09=09struct famfs_daxdev *dd =3D &fsi->dax=
_devlist->devlist[i];=0D=0A+=0D=0A+=09=09=09if (!dd->valid || dd->devp !=3D=
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
******=0D=0A  * fs_context_operations=0D=0A  */=0D=0A@@ -158,6 +377,18 @@=
 famfs_get_tree(struct fs_context *fc)=0D=0A =09=09famfs_fill_super(sb, f=
c);=0D=0A =09}=0D=0A=20=0D=0A+=09/* Install the primary daxdev (from the =
mount device) at slot 0 */=0D=0A+=09err =3D famfs_devlist_alloc(fsi);=0D=0A=
+=09if (err)=0D=0A+=09=09goto deactivate_out;=0D=0A+=0D=0A+=09err =3D fam=
fs_install_daxdev(fsi, sb, 0, daxdevno, fc->source);=0D=0A+=09if (err) {=0D=
=0A+=09=09pr_err("%s: failed to install primary daxdev %s\n",=0D=0A+=09=09=
       __func__, fc->source);=0D=0A+=09=09goto deactivate_out;=0D=0A+=09}=
=0D=0A+=0D=0A =09inode =3D famfs_get_inode(sb, NULL, S_IFDIR | fsi->mount=
_opts.mode, 0);=0D=0A =09sb->s_root =3D d_make_root(inode);=0D=0A =09if (=
!sb->s_root) {=0D=0A@@ -241,6 +472,7 @@ static int famfs_init_fs_context(=
struct fs_context *fc)=0D=0A =09if (!fsi)=0D=0A =09=09return -ENOMEM;=0D=0A=
=20=0D=0A+=09init_rwsem(&fsi->devlist_sem);=0D=0A =09fsi->mount_opts.mode=
 =3D FAMFS_DEFAULT_MODE;=0D=0A =09fc->s_fs_info        =3D fsi;=0D=0A =09=
fc->ops              =3D &famfs_context_ops;=0D=0A@@ -251,6 +483,8 @@ sta=
tic void famfs_kill_sb(struct super_block *sb)=0D=0A {=0D=0A =09struct fa=
mfs_fs_info *fsi =3D sb->s_fs_info;=0D=0A=20=0D=0A+=09famfs_devlist_free(=
fsi, sb);=0D=0A+=0D=0A =09kill_char_super(sb);=0D=0A=20=0D=0A =09kfree(fs=
i);=0D=0Adiff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal=
=2Eh=0D=0Aindex 6f481d79ed88..ebb9c499cf69 100644=0D=0A--- a/fs/famfs/fam=
fs_internal.h=0D=0A+++ b/fs/famfs/famfs_internal.h=0D=0A@@ -11,22 +11,68 =
@@=0D=0A #ifndef FAMFS_INTERNAL_H=0D=0A #define FAMFS_INTERNAL_H=0D=0A=20=
=0D=0A+#include <linux/rwsem.h>=0D=0A+#include <linux/bits.h>=0D=0A+#incl=
ude <linux/build_bug.h>=0D=0A+=0D=0A struct famfs_mount_opts {=0D=0A =09u=
mode_t mode;=0D=0A };=0D=0A=20=0D=0A+/*=0D=0A+ * famfs_daxdev - one entry=
 in the per-superblock daxdev table=0D=0A+ *=0D=0A+ * @valid:   slot is p=
opulated and the daxdev has been exclusively acquired=0D=0A+ * @error:   =
dax reported a memory error (probably poison) via notify_failure=0D=0A+ *=
 @dax_err: fs_dax_get() failed for this daxdev=0D=0A+ * @devno:   dax dev=
ice dev_t=0D=0A+ * @devp:    the acquired dax_device=0D=0A+ * @name:    d=
ax device path (may be NULL for ioctl-registered daxdevs)=0D=0A+ */=0D=0A=
+struct famfs_daxdev {=0D=0A+=09bool valid;=0D=0A+=09bool error;=0D=0A+=09=
bool dax_err;=0D=0A+=09dev_t devno;=0D=0A+=09struct dax_device *devp;=0D=0A=
+=09char *name;=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A+ * The daxdev index space =
(and thus this table) is capped at 64 so the set of=0D=0A+ * daxdev indic=
es referenced by a file's fmap fits in a u64 bitmap.=0D=0A+ */=0D=0A+#def=
ine FAMFS_MAX_DAXDEVS 64=0D=0A+static_assert(BITS_PER_TYPE(u64) >=3D FAMF=
S_MAX_DAXDEVS);=0D=0A+=0D=0A+/*=0D=0A+ * famfs_dax_devlist - the per-supe=
rblock table of famfs_daxdev's. Slot 0 is=0D=0A+ * the primary daxdev sup=
plied at mount; slots 1..n are registered via ioctl.=0D=0A+ */=0D=0A+stru=
ct famfs_dax_devlist {=0D=0A+=09int nslots;=0D=0A+=09struct famfs_daxdev =
*devlist;=0D=0A+};=0D=0A+=0D=0A /**=0D=0A  * @famfs_fs_info=0D=0A  *=0D=0A=
  * @mount_opts:  The mount options=0D=0A  * @deverror:    True if the da=
x device has called our notify_failure entry=0D=0A  *               point=
, or if other "shutdown" conditions exist=0D=0A+ * @dax_devlist: Table of=
 backing daxdevs (slot 0 is the mount primary)=0D=0A+ * @devlist_sem: Ser=
ializes installs into, and teardown of, @dax_devlist=0D=0A  */=0D=0A stru=
ct famfs_fs_info {=0D=0A =09struct famfs_mount_opts   mount_opts;=0D=0A =09=
bool                      deverror;=0D=0A+=09struct famfs_dax_devlist *da=
x_devlist;=0D=0A+=09struct rw_semaphore       devlist_sem;=0D=0A };=0D=0A=
=20=0D=0A int lookup_daxdev(const char *pathname, dev_t *devno);=0D=0A+in=
t famfs_devlist_alloc(struct famfs_fs_info *fsi);=0D=0A+int famfs_install=
_daxdev(struct famfs_fs_info *fsi, struct super_block *sb,=0D=0A+=09=09=09=
 u64 index, dev_t devno, const char *name);=0D=0A=20=0D=0A #endif /* FAMF=
S_INTERNAL_H */=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
