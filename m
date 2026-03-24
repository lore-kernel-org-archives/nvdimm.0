Received: from a48-177.smtp-out.amazonses.com (a48-177.smtp-out.amazonses.com [54.240.48.177])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D066D336EC0
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312880; cv=none; b=af1uFmz+q542mHMRQBYPS6CXod1aTPnpmb2w6IvNvE3y9yLNroWlNdBPBa+OEzb+qTN9Z5AsvNOSje/nyz3aGsVs0+A2OP5DRNGtP31tIDGNOHhILmIRginR+WRGBT7602G35h3kPqAUXqjVwSCDJVUdzcj05lTHlH0LM4QbnII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312880; c=relaxed/simple;
	bh=vcRntf1Ii8MJTD66eSleewCtxcZ0n10sPT8GlSbCHLo=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=aGe9oB02ceG/EEW7SoMBkpQQmAZKm3+Qd4HbXdY+cxx+Bwz5nJxxfxHwIBSupxCmcmVKGQmTHlERMX5mqtHqkPH2dJGKxRK8d6nNI4C8ohrg0suOVeSSza40FTzQTZ7Vc4Qsp6UZzF6duKJoQZwYTAXzOUUkSWEAoz4dixUyMdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=D7jBC+6Z; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=nrWk9ggm; arc=none smtp.client-ip=54.240.48.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="D7jBC+6Z";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="nrWk9ggm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312877;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=vcRntf1Ii8MJTD66eSleewCtxcZ0n10sPT8GlSbCHLo=;
	b=D7jBC+6Zgx/zLaUraA+aYQyXbbKWNDuZDXhs458Xs4t2v43v5NBbXOelABTN86zL
	jIpmNPnfHGalGiEbjzmDrPdbfK5GVAG2QVDMrtv5MLUnRz9Rv9MVy4U3kHHgWDtalnN
	vOXnYiZg5i/+JOle27HziHoFoh1ke1ZatYzgyFt0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312877;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=vcRntf1Ii8MJTD66eSleewCtxcZ0n10sPT8GlSbCHLo=;
	b=nrWk9ggmdQ7UK2HLkKJKO2TT7oo8llHq5XbY0CwJSV2+c1ofLI2av16lnRqCfj3E
	FB4ATquvwC5iphN3AmF9NlMmtlTppEuEpsBRXFSQygBd0YkBa3gqB0l0I1oorklaaSH
	h0Si+mmlPQIFE/6pkQyW6skt3P9IzPLm89jR+eJ4=
Subject: [PATCH V9 05/10] famfs_fuse: GET_DAXDEV message and daxdev_table
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <dan.j.williams@intel.com>, 
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
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40micron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Tue, 24 Mar 2026 00:41:17 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d1d48b7e8-4468329f-b446-43f1-87db-3c7e1ff6f28b-000000@email.amazonses.com>
References: 
 <0100019d1d48b7e8-4468329f-b446-43f1-87db-3c7e1ff6f28b-000000@email.amazonses.com> 
 <20260324004110.5240-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuybsjgiGb7wFSj+q14eCaeyD/Q==
Thread-Topic: [PATCH V9 05/10] famfs_fuse: GET_DAXDEV message and daxdev_table
X-Wm-Sent-Timestamp: 1774312876
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d49ee03-42d410eb-7403-410c-84cf-13ea5c66a13c-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.48.177

From: John Groves <john@groves.net>=0D=0A=0D=0A- The new GET_DAXDEV messa=
ge/response is added=0D=0A- The famfs.c:famfs_teardown() function is adde=
d as a primary teardown=0D=0A  function for famfs.=0D=0A- The command it =
triggered by the update_daxdev_table() call, if there=0D=0A  are any daxd=
evs in the subject fmap that are not represented in the=0D=0A  daxdev_tab=
le yet.=0D=0A- fs/namei.c: export may_open_dev()=0D=0A=0D=0ASigned-off-by=
: John Groves <john@groves.net>=0D=0A---=0D=0A fs/fuse/famfs.c           =
| 227 +++++++++++++++++++++++++++++++++++++-=0D=0A fs/fuse/famfs_kfmap.h =
    |  26 +++++=0D=0A fs/fuse/fuse_i.h          |  19 ++++=0D=0A fs/fuse/=
inode.c           |   7 +-=0D=0A fs/namei.c                |   1 +=0D=0A =
include/uapi/linux/fuse.h |  20 ++++=0D=0A 6 files changed, 298 insertion=
s(+), 2 deletions(-)=0D=0A=0D=0Adiff --git a/fs/fuse/famfs.c b/fs/fuse/fa=
mfs.c=0D=0Aindex ac52e54e2cb5..0e9415aa6339 100644=0D=0A--- a/fs/fuse/fam=
fs.c=0D=0A+++ b/fs/fuse/famfs.c=0D=0A@@ -21,6 +21,228 @@=0D=0A #include "=
famfs_kfmap.h"=0D=0A #include "fuse_i.h"=0D=0A=20=0D=0A+/*=0D=0A+ * famfs=
_teardown()=0D=0A+ *=0D=0A+ * Deallocate famfs metadata for a fuse_conn=0D=
=0A+ */=0D=0A+void=0D=0A+famfs_teardown(struct fuse_conn *fc)=0D=0A+{=0D=0A=
+=09struct famfs_dax_devlist *devlist __free(kfree) =3D fc->dax_devlist;=0D=
=0A+=09int i;=0D=0A+=0D=0A+=09fc->dax_devlist =3D NULL;=0D=0A+=0D=0A+=09i=
f (!devlist)=0D=0A+=09=09return;=0D=0A+=0D=0A+=09if (!devlist->devlist)=0D=
=0A+=09=09return;=0D=0A+=0D=0A+=09/* Close & release all the daxdevs in o=
ur table */=0D=0A+=09for (i =3D 0; i < devlist->nslots; i++) {=0D=0A+=09=09=
struct famfs_daxdev *dd =3D &devlist->devlist[i];=0D=0A+=0D=0A+=09=09if (=
!dd->valid)=0D=0A+=09=09=09continue;=0D=0A+=0D=0A+=09=09/* Release refere=
nce from dax_dev_get() */=0D=0A+=09=09if (dd->devp)=0D=0A+=09=09=09put_da=
x(dd->devp);=0D=0A+=0D=0A+=09=09kfree(dd->name);=0D=0A+=09}=0D=0A+=09kfre=
e(devlist->devlist);=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+famfs_verify_d=
axdev(const char *pathname, dev_t *devno)=0D=0A+{=0D=0A+=09struct inode *=
inode;=0D=0A+=09struct path path;=0D=0A+=09int err;=0D=0A+=0D=0A+=09if (!=
pathname || !*pathname)=0D=0A+=09=09return -EINVAL;=0D=0A+=0D=0A+=09err =3D=
 kern_path(pathname, LOOKUP_FOLLOW, &path);=0D=0A+=09if (err)=0D=0A+=09=09=
return err;=0D=0A+=0D=0A+=09inode =3D d_backing_inode(path.dentry);=0D=0A=
+=09if (!S_ISCHR(inode->i_mode)) {=0D=0A+=09=09err =3D -EINVAL;=0D=0A+=09=
=09goto out_path_put;=0D=0A+=09}=0D=0A+=0D=0A+=09if (!may_open_dev(&path)=
) { /* had to export this */=0D=0A+=09=09err =3D -EACCES;=0D=0A+=09=09got=
o out_path_put;=0D=0A+=09}=0D=0A+=0D=0A+=09*devno =3D inode->i_rdev;=0D=0A=
+=0D=0A+out_path_put:=0D=0A+=09path_put(&path);=0D=0A+=09return err;=0D=0A=
+}=0D=0A+=0D=0A+/**=0D=0A+ * famfs_fuse_get_daxdev() - Retrieve info for =
a DAX device from fuse server=0D=0A+ *=0D=0A+ * Send a GET_DAXDEV message=
 to the fuse server to retrieve info on a=0D=0A+ * dax device.=0D=0A+ *=0D=
=0A+ * @fm:     fuse_mount=0D=0A+ * @index:  the index of the dax device;=
 daxdevs are referred to by index=0D=0A+ *          in fmaps, and the ser=
ver resolves the index to a particular daxdev=0D=0A+ *=0D=0A+ * Returns: =
0=3Dsuccess=0D=0A+ *          -errno=3Dfailure=0D=0A+ */=0D=0A+static int=
=0D=0A+famfs_fuse_get_daxdev(struct fuse_mount *fm, const u64 index)=0D=0A=
+{=0D=0A+=09struct fuse_daxdev_out daxdev_out =3D { 0 };=0D=0A+=09struct =
fuse_conn *fc =3D fm->fc;=0D=0A+=09struct famfs_daxdev *daxdev;=0D=0A+=09=
int rc;=0D=0A+=0D=0A+=09FUSE_ARGS(args);=0D=0A+=0D=0A+=09/* Store the dax=
dev in our table */=0D=0A+=09if (index >=3D fc->dax_devlist->nslots) {=0D=
=0A+=09=09pr_err("%s: index(%lld) > nslots(%d)\n",=0D=0A+=09=09       __f=
unc__, index, fc->dax_devlist->nslots);=0D=0A+=09=09return -EINVAL;=0D=0A=
+=09}=0D=0A+=0D=0A+=09args.opcode =3D FUSE_GET_DAXDEV;=0D=0A+=09args.node=
id =3D index;=0D=0A+=0D=0A+=09args.in_numargs =3D 0;=0D=0A+=0D=0A+=09args=
=2Eout_numargs =3D 1;=0D=0A+=09args.out_args[0].size =3D sizeof(daxdev_ou=
t);=0D=0A+=09args.out_args[0].value =3D &daxdev_out;=0D=0A+=0D=0A+=09/* S=
end GET_DAXDEV command */=0D=0A+=09rc =3D fuse_simple_request(fm, &args);=
=0D=0A+=09if (rc) {=0D=0A+=09=09pr_err("%s: rc=3D%d from fuse_simple_requ=
est()\n",=0D=0A+=09=09       __func__, rc);=0D=0A+=09=09/* Error will be =
that the payload is smaller than FMAP_BUFSIZE,=0D=0A+=09=09 * which is th=
e max we can handle. Empty payload handled below.=0D=0A+=09=09 */=0D=0A+=09=
=09return rc;=0D=0A+=09}=0D=0A+=0D=0A+=09scoped_guard(rwsem_write, &fc->f=
amfs_devlist_sem) {=0D=0A+=09=09daxdev =3D &fc->dax_devlist->devlist[inde=
x];=0D=0A+=0D=0A+=09=09/* Abort if daxdev is now valid (races are possibl=
e here) */=0D=0A+=09=09if (daxdev->valid) {=0D=0A+=09=09=09pr_debug("%s: =
daxdev already known\n", __func__);=0D=0A+=09=09=09return 0;=0D=0A+=09=09=
}=0D=0A+=0D=0A+=09=09/* Verify dev is valid and can be opened and gets th=
e devno */=0D=0A+=09=09rc =3D famfs_verify_daxdev(daxdev_out.name, &daxde=
v->devno);=0D=0A+=09=09if (rc) {=0D=0A+=09=09=09pr_err("%s: rc=3D%d from =
famfs_verify_daxdev()\n",=0D=0A+=09=09=09       __func__, rc);=0D=0A+=09=09=
=09return rc;=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09daxdev->name =3D kstrdup(d=
axdev_out.name, GFP_KERNEL);=0D=0A+=09=09if (!daxdev->name)=0D=0A+=09=09=09=
return -ENOMEM;=0D=0A+=0D=0A+=09=09/* This will fail if it's not a dax de=
vice */=0D=0A+=09=09daxdev->devp =3D dax_dev_get(daxdev->devno);=0D=0A+=09=
=09if (!daxdev->devp) {=0D=0A+=09=09=09pr_warn("%s: device %s not found o=
r not dax\n",=0D=0A+=09=09=09=09__func__, daxdev_out.name);=0D=0A+=09=09=09=
kfree(daxdev->name);=0D=0A+=09=09=09daxdev->name =3D NULL;=0D=0A+=09=09=09=
return -ENODEV;=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09wmb(); /* All other fiel=
ds must be visible before valid */=0D=0A+=09=09daxdev->valid =3D 1;=0D=0A=
+=09}=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+/**=0D=0A+ * famfs_u=
pdate_daxdev_table() - Update the daxdev table=0D=0A+ * @fm:   fuse_mount=
=0D=0A+ * @meta: famfs_file_meta, in-memory format, built from a GET_FMAP=
 response=0D=0A+ *=0D=0A+ * This function is called for each new file fma=
p, to verify whether all=0D=0A+ * referenced daxdevs are already known (i=
=2Ee. in the table). Any daxdev=0D=0A+ * indices referenced in @meta but =
not in the table will be retrieved via=0D=0A+ * famfs_fuse_get_daxdev() a=
nd added to the table=0D=0A+ *=0D=0A+ * Return: 0=3Dsuccess=0D=0A+ *     =
    -errno=3Dfailure=0D=0A+ */=0D=0A+static int=0D=0A+famfs_update_daxdev=
_table(=0D=0A+=09struct fuse_mount *fm,=0D=0A+=09const struct famfs_file_=
meta *meta)=0D=0A+{=0D=0A+=09struct famfs_dax_devlist *local_devlist;=0D=0A=
+=09struct fuse_conn *fc =3D fm->fc;=0D=0A+=09int indices_to_fetch[MAX_DA=
XDEVS];=0D=0A+=09int n_to_fetch =3D 0;=0D=0A+=09int err;=0D=0A+=0D=0A+=09=
/* First time through we will need to allocate the dax_devlist */=0D=0A+=09=
if (!fc->dax_devlist) {=0D=0A+=09=09local_devlist =3D kcalloc(1, sizeof(*=
fc->dax_devlist), GFP_KERNEL);=0D=0A+=09=09if (!local_devlist)=0D=0A+=09=09=
=09return -ENOMEM;=0D=0A+=0D=0A+=09=09local_devlist->nslots =3D MAX_DAXDE=
VS;=0D=0A+=0D=0A+=09=09local_devlist->devlist =3D kcalloc(MAX_DAXDEVS,=0D=
=0A+=09=09=09=09=09=09 sizeof(struct famfs_daxdev),=0D=0A+=09=09=09=09=09=
=09 GFP_KERNEL);=0D=0A+=09=09if (!local_devlist->devlist) {=0D=0A+=09=09=09=
kfree(local_devlist);=0D=0A+=09=09=09return -ENOMEM;=0D=0A+=09=09}=0D=0A+=
=0D=0A+=09=09/* We don't need famfs_devlist_sem here because we use cmpxc=
hg */=0D=0A+=09=09if (cmpxchg(&fc->dax_devlist, NULL, local_devlist) !=3D=
 NULL) {=0D=0A+=09=09=09kfree(local_devlist->devlist);=0D=0A+=09=09=09kfr=
ee(local_devlist); /* another thread beat us to it */=0D=0A+=09=09}=0D=0A=
+=09}=0D=0A+=0D=0A+=09/* Collect indices that need fetching while holding=
 read lock */=0D=0A+=09scoped_guard(rwsem_read, &fc->famfs_devlist_sem) {=
=0D=0A+=09=09unsigned long i;=0D=0A+=0D=0A+=09=09for_each_set_bit(i, (uns=
igned long *)&meta->dev_bitmap, MAX_DAXDEVS) {=0D=0A+=09=09=09if (!(fc->d=
ax_devlist->devlist[i].valid))=0D=0A+=09=09=09=09indices_to_fetch[n_to_fe=
tch++] =3D i;=0D=0A+=09=09}=0D=0A+=09}=0D=0A+=0D=0A+=09/* Fetch needed da=
xdevs outside the read lock */=0D=0A+=09for (int j =3D 0; j < n_to_fetch;=
 j++) {=0D=0A+=09=09err =3D famfs_fuse_get_daxdev(fm, indices_to_fetch[j]=
);=0D=0A+=09=09if (err)=0D=0A+=09=09=09pr_err("%s: failed to get daxdev=3D=
%d\n",=0D=0A+=09=09=09       __func__, indices_to_fetch[j]);=0D=0A+=09}=0D=
=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A=20=0D=0A /*************************=
**************************************************/=0D=0A=20=0D=0A@@ -184=
,7 +406,7 @@ famfs_fuse_meta_alloc(=0D=0A =09=09=09/* ie_in =3D one inter=
leaved extent in fmap_buf */=0D=0A =09=09=09ie_in =3D fmap_buf + next_off=
set;=0D=0A=20=0D=0A-=09=09=09/* Move past one interleaved extent header i=
n fmap_buf */=0D=0A+=09=09=09/* Move past 1 interleaved extent header in =
fmap_buf */=0D=0A =09=09=09next_offset +=3D sizeof(*ie_in);=0D=0A =09=09=09=
if (next_offset > fmap_buf_size) {=0D=0A =09=09=09=09pr_err("%s:%d: fmap_=
buf underflow offset/size %ld/%ld\n",=0D=0A@@ -329,6 +551,9 @@ famfs_file=
_init_dax(=0D=0A =09if (rc)=0D=0A =09=09goto errout;=0D=0A=20=0D=0A+=09/*=
 Make sure this fmap doesn't reference any unknown daxdevs */=0D=0A+=09fa=
mfs_update_daxdev_table(fm, meta);=0D=0A+=0D=0A =09/* Publish the famfs m=
etadata on fi->famfs_meta */=0D=0A =09inode_lock(inode);=0D=0A=20=0D=0Adi=
ff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h=0D=0Aindex 18ab2=
2bcc5a1..eb9f70b5cb81 100644=0D=0A--- a/fs/fuse/famfs_kfmap.h=0D=0A+++ b/=
fs/fuse/famfs_kfmap.h=0D=0A@@ -64,4 +64,30 @@ struct famfs_file_meta {=0D=
=0A =09};=0D=0A };=0D=0A=20=0D=0A+/*=0D=0A+ * famfs_daxdev - tracking str=
uct for a daxdev within a famfs file system=0D=0A+ *=0D=0A+ * This is the=
 in-memory daxdev metadata that is populated by parsing=0D=0A+ * the resp=
onses to GET_FMAP messages=0D=0A+ */=0D=0A+struct famfs_daxdev {=0D=0A+=09=
/* Include dev uuid=3F */=0D=0A+=09bool valid;=0D=0A+=09bool error;=0D=0A=
+=09dev_t devno;=0D=0A+=09struct dax_device *devp;=0D=0A+=09char *name;=0D=
=0A+};=0D=0A+=0D=0A+#define MAX_DAXDEVS 24=0D=0A+=0D=0A+/*=0D=0A+ * famfs=
_dax_devlist - list of famfs_daxdev's=0D=0A+ */=0D=0A+struct famfs_dax_de=
vlist {=0D=0A+=09int nslots;=0D=0A+=09int ndevs;=0D=0A+=09struct famfs_da=
xdev *devlist;=0D=0A+};=0D=0A+=0D=0A #endif /* FAMFS_KFMAP_H */=0D=0Adiff=
 --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h=0D=0Aindex dbfec5b9c6e1..83e=
24cee994b 100644=0D=0A--- a/fs/fuse/fuse_i.h=0D=0A+++ b/fs/fuse/fuse_i.h=0D=
=0A@@ -1006,6 +1006,11 @@ struct fuse_conn {=0D=0A =09=09/* Request timeo=
ut (in jiffies). 0 =3D no timeout */=0D=0A =09=09unsigned int req_timeout=
;=0D=0A =09} timeout;=0D=0A+=0D=0A+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)=0D=
=0A+=09struct rw_semaphore famfs_devlist_sem;=0D=0A+=09struct famfs_dax_d=
evlist *dax_devlist;=0D=0A+#endif=0D=0A };=0D=0A=20=0D=0A /*=0D=0A@@ -164=
7,6 +1652,8 @@ int famfs_file_init_dax(struct fuse_mount *fm,=0D=0A =09=09=
=09size_t fmap_size);=0D=0A void __famfs_meta_free(void *map);=0D=0A=20=0D=
=0A+void famfs_teardown(struct fuse_conn *fc);=0D=0A+=0D=0A /* Set fi->fa=
mfs_meta =3D NULL regardless of prior value */=0D=0A static inline void f=
amfs_meta_init(struct fuse_inode *fi)=0D=0A {=0D=0A@@ -1668,6 +1675,11 @@=
 static inline void famfs_meta_free(struct fuse_inode *fi)=0D=0A =09}=0D=0A=
 }=0D=0A=20=0D=0A+static inline void famfs_init_devlist_sem(struct fuse_c=
onn *fc)=0D=0A+{=0D=0A+=09init_rwsem(&fc->famfs_devlist_sem);=0D=0A+}=0D=0A=
+=0D=0A static inline int fuse_file_famfs(struct fuse_inode *fi)=0D=0A {=0D=
=0A =09return (READ_ONCE(fi->famfs_meta) !=3D NULL);=0D=0A@@ -1677,6 +168=
9,9 @@ int fuse_get_fmap(struct fuse_mount *fm, struct inode *inode);=0D=0A=
=20=0D=0A #else /* !CONFIG_FUSE_FAMFS_DAX */=0D=0A=20=0D=0A+static inline=
 void famfs_teardown(struct fuse_conn *fc)=0D=0A+{=0D=0A+}=0D=0A static i=
nline struct fuse_backing *famfs_meta_set(struct fuse_inode *fi,=0D=0A =09=
=09=09=09=09=09  void *meta)=0D=0A {=0D=0A@@ -1687,6 +1702,10 @@ static i=
nline void famfs_meta_free(struct fuse_inode *fi)=0D=0A {=0D=0A }=0D=0A=20=
=0D=0A+static inline void famfs_init_devlist_sem(struct fuse_conn *fc)=0D=
=0A+{=0D=0A+}=0D=0A+=0D=0A static inline int fuse_file_famfs(struct fuse_=
inode *fi)=0D=0A {=0D=0A =09return 0;=0D=0Adiff --git a/fs/fuse/inode.c b=
/fs/fuse/inode.c=0D=0Aindex d0c6037ca46b..ecd83234c0e0 100644=0D=0A--- a/=
fs/fuse/inode.c=0D=0A+++ b/fs/fuse/inode.c=0D=0A@@ -1048,6 +1048,9 @@ voi=
d fuse_conn_put(struct fuse_conn *fc)=0D=0A =09=09WARN_ON(atomic_read(&bu=
cket->count) !=3D 1);=0D=0A =09=09kfree(bucket);=0D=0A =09}=0D=0A+=09if (=
IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))=0D=0A+=09=09famfs_teardown(fc);=0D=0A+=
=0D=0A =09if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))=0D=0A =09=09fuse_backi=
ng_files_free(fc);=0D=0A =09call_rcu(&fc->rcu, delayed_release);=0D=0A@@ =
-1477,8 +1480,10 @@ static void process_init_reply(struct fuse_mount *fm,=
 struct fuse_args *args,=0D=0A =09=09=09=09u64 in_flags =3D FIELD_PREP(GE=
NMASK_ULL(63, 32), ia->in.flags2)=0D=0A =09=09=09=09=09=09| ia->in.flags;=
=0D=0A=20=0D=0A-=09=09=09=09if (in_flags & FUSE_DAX_FMAP)=0D=0A+=09=09=09=
=09if (in_flags & FUSE_DAX_FMAP) {=0D=0A+=09=09=09=09=09famfs_init_devlis=
t_sem(fc);=0D=0A =09=09=09=09=09fc->famfs_iomap =3D 1;=0D=0A+=09=09=09=09=
}=0D=0A =09=09=09}=0D=0A =09=09} else {=0D=0A =09=09=09ra_pages =3D fc->m=
ax_read / PAGE_SIZE;=0D=0Adiff --git a/fs/namei.c b/fs/namei.c=0D=0Aindex=
 58f715f7657e..434081cfbaf7 100644=0D=0A--- a/fs/namei.c=0D=0A+++ b/fs/na=
mei.c=0D=0A@@ -4206,6 +4206,7 @@ bool may_open_dev(const struct path *pat=
h)=0D=0A =09return !(path->mnt->mnt_flags & MNT_NODEV) &&=0D=0A =09=09!(p=
ath->mnt->mnt_sb->s_iflags & SB_I_NODEV);=0D=0A }=0D=0A+EXPORT_SYMBOL(may=
_open_dev);=0D=0A=20=0D=0A static int may_open(struct mnt_idmap *idmap, c=
onst struct path *path,=0D=0A =09=09    int acc_mode, int flag)=0D=0Adiff=
 --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h=0D=0Aindex=
 cf678bebbfe0..1b82895108be 100644=0D=0A--- a/include/uapi/linux/fuse.h=0D=
=0A+++ b/include/uapi/linux/fuse.h=0D=0A@@ -247,6 +247,9 @@=0D=0A  *    -=
 struct fuse_famfs_simple_ext=0D=0A  *    - struct fuse_famfs_iext=0D=0A =
 *    - struct fuse_famfs_fmap_header=0D=0A+ *  - Add the following struc=
ts for the GET_DAXDEV message and reply=0D=0A+ *    - struct fuse_get_dax=
dev_in=0D=0A+ *    - struct fuse_get_daxdev_out=0D=0A  *  - Add the follo=
wing enumerated types=0D=0A  *    - enum fuse_famfs_file_type=0D=0A  *   =
 - enum famfs_ext_type=0D=0A@@ -678,6 +681,7 @@ enum fuse_opcode {=0D=0A=20=
=0D=0A =09/* Famfs / devdax opcodes */=0D=0A =09FUSE_GET_FMAP           =3D=
 54,=0D=0A+=09FUSE_GET_DAXDEV         =3D 55,=0D=0A=20=0D=0A =09/* CUSE s=
pecific operations */=0D=0A =09CUSE_INIT=09=09=3D 4096,=0D=0A@@ -1369,6 +=
1373,22 @@ struct fuse_famfs_fmap_header {=0D=0A =09uint64_t reserved1;=0D=
=0A };=0D=0A=20=0D=0A+struct fuse_get_daxdev_in {=0D=0A+=09uint32_t      =
  daxdev_num;=0D=0A+};=0D=0A+=0D=0A+#define DAXDEV_NAME_MAX 256=0D=0A+=0D=
=0A+/* fuse_daxdev_out has enough space for a uuid if we need it */=0D=0A=
+struct fuse_daxdev_out {=0D=0A+=09uint16_t index;=0D=0A+=09uint16_t rese=
rved;=0D=0A+=09uint32_t reserved2;=0D=0A+=09uint64_t reserved3;=0D=0A+=09=
uint64_t reserved4;=0D=0A+=09char name[DAXDEV_NAME_MAX];=0D=0A+};=0D=0A+=0D=
=0A static inline int32_t fmap_msg_min_size(void)=0D=0A {=0D=0A =09/* Sma=
llest fmap message is a header plus one simple extent */=0D=0A--=20=0D=0A=
2.53.0=0D=0A=0D=0A
