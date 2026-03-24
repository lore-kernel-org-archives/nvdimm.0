Received: from a11-71.smtp-out.amazonses.com (a11-71.smtp-out.amazonses.com [54.240.11.71])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46E933A6E9
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312908; cv=none; b=jqrZUbWRY8/4T9uWasZ+LUBS1+XdQh4EM8Vwv2wJlUw72zOE5dIGm1EcgTXyMhtTAqz0EEQsJPsuJVyXUj0FFg9jrj3R3WAzk7QOGmXZARYZy/xgKh7KEl4RPgn5+zCYyMeEMBUXc5/XqyfHwxxZfo2CM/FY1Sp51trljcbUbVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312908; c=relaxed/simple;
	bh=0ni5JY1xGJLC7/A54ntD2z9BzEmeBX6dxPlhqaxllAA=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=ek1CzkGOMPPGzJMKh1Vk8KstCv2s5xdr5dg9kl/stmauZc/5j3A0+X2XozrlfHxeKcI/zPtH4v5y3b7oVoB74sFkoSDUtvQomW0zIfNrhrT3o6k+3S7ELgkXdF5TaBSwAVmP+E9YhYD2id+TjYeqsbFVQSPKu81hS9mWirGIYv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=kPWcPVh2; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=LLP8zCAz; arc=none smtp.client-ip=54.240.11.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="kPWcPVh2";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="LLP8zCAz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312905;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=0ni5JY1xGJLC7/A54ntD2z9BzEmeBX6dxPlhqaxllAA=;
	b=kPWcPVh2b1QgnZwd5Wsb5jACmBAE9R7qN9rkzvqd7WapIJyjK3o9cUF8N66r5am9
	H20QX/L5x2RXt2GrX0hEG7UpQo0MG2osSDsoeItC8UV2JgUY+lSwix2fcbv6eDIgfI4
	/zgU3dMxZi1RV8qPP1CiMEl52PDXn3P/mgUnoZck=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312905;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=0ni5JY1xGJLC7/A54ntD2z9BzEmeBX6dxPlhqaxllAA=;
	b=LLP8zCAzhIP1d6n+Akg76+eGJRI/Czk8vRlcL0qEs8dTwUX6B5A+PefOR4rvXQIi
	Lmf2S/QHRjJkBL3nlUS9VSv2kPmLfKhkp9VPR0XbcOa1DYJRDPpDqpNcvGMVIzvXDUw
	/Vs1tWebHomhfSSWE3wtwlx6w4R4zAz++669PAxY=
Subject: [PATCH V9 07/10] famfs_fuse: Add holder_operations for dax
 notify_failure()
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
Date: Tue, 24 Mar 2026 00:41:45 +0000
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
 <20260324004129.5303-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuyb88ZDoaUzWSlykKOSVMmvglA==
Thread-Topic: [PATCH V9 07/10] famfs_fuse: Add holder_operations for dax
 notify_failure()
X-Wm-Sent-Timestamp: 1774312904
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d4a5afe-59c8820f-54ec-40d4-ab7d-4f2f7bb2d754-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.11.71

From: John Groves <john@groves.net>=0D=0A=0D=0AMemory errors are at least=
 somewhat more likely on disaggregated memory=0D=0Athan on-board memory. =
This commit registers to be notified by fsdev_dax=0D=0Ain the event that =
a memory failure is detected.=0D=0A=0D=0AWhen a file access resolves to a=
 daxdev with memory errors, it will fail=0D=0Awith an appropriate error.=0D=
=0A=0D=0AIf a daxdev failed fs_dax_get(), we set dd->dax_err. If a daxdev=
 called=0D=0Aour notify_failure(), set dd->error. When any of the above h=
appens, set=0D=0A(file)->error and stop allowing access.=0D=0A=0D=0AIn ge=
neral, the recovery from memory errors is to unmount the file=0D=0Asystem=
 and re-initialize the memory, but there may be usable degraded=0D=0Amode=
s of operation - particularly in the future when famfs supports=0D=0Afile=
 systems backed by more than one daxdev. In those cases,=0D=0Aaccessing d=
ata that is on a working daxdev can still work.=0D=0A=0D=0AFor now, retur=
n errors for any file that has encountered a memory or dax=0D=0Aerror.=0D=
=0A=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A fs/f=
use/famfs.c       | 110 +++++++++++++++++++++++++++++++++++++++---=0D=0A =
fs/fuse/famfs_kfmap.h |   3 +-=0D=0A 2 files changed, 105 insertions(+), =
8 deletions(-)=0D=0A=0D=0Adiff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c=0D=
=0Aindex 6f935032eb17..87012df537eb 100644=0D=0A--- a/fs/fuse/famfs.c=0D=0A=
+++ b/fs/fuse/famfs.c=0D=0A@@ -21,6 +21,26 @@=0D=0A #include "famfs_kfmap=
=2Eh"=0D=0A #include "fuse_i.h"=0D=0A=20=0D=0A+static void famfs_set_daxd=
ev_err(=0D=0A+=09struct fuse_conn *fc, struct dax_device *dax_devp);=0D=0A=
+=0D=0A+static int=0D=0A+famfs_dax_notify_failure(struct dax_device *dax_=
devp, u64 offset,=0D=0A+=09=09=09u64 len, int mf_flags)=0D=0A+{=0D=0A+=09=
struct fuse_conn *fc =3D dax_holder(dax_devp);=0D=0A+=0D=0A+=09famfs_set_=
daxdev_err(fc, dax_devp);=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+=
static const struct dax_holder_operations famfs_fuse_dax_holder_ops =3D {=
=0D=0A+=09.notify_failure=09=09=3D famfs_dax_notify_failure,=0D=0A+};=0D=0A=
+=0D=0A+/****************************************************************=
*************/=0D=0A+=0D=0A /*=0D=0A  * famfs_teardown()=0D=0A  *=0D=0A@@=
 -47,9 +67,12 @@ famfs_teardown(struct fuse_conn *fc)=0D=0A =09=09if (!dd=
->valid)=0D=0A =09=09=09continue;=0D=0A=20=0D=0A-=09=09/* Release referen=
ce from dax_dev_get() */=0D=0A-=09=09if (dd->devp)=0D=0A+=09=09/* Only ca=
ll fs_put_dax if fs_dax_get succeeded */=0D=0A+=09=09if (dd->devp) {=0D=0A=
+=09=09=09if (!dd->dax_err)=0D=0A+=09=09=09=09fs_put_dax(dd->devp, fc);=0D=
=0A =09=09=09put_dax(dd->devp);=0D=0A+=09=09}=0D=0A=20=0D=0A =09=09kfree(=
dd->name);=0D=0A =09}=0D=0A@@ -169,6 +192,17 @@ famfs_fuse_get_daxdev(str=
uct fuse_mount *fm, const u64 index)=0D=0A =09=09=09return -ENODEV;=0D=0A=
 =09=09}=0D=0A=20=0D=0A+=09=09rc =3D fs_dax_get(daxdev->devp, fc, &famfs_=
fuse_dax_holder_ops);=0D=0A+=09=09if (rc) {=0D=0A+=09=09=09/* Mark as val=
id with dax_err to prevent retry loop.=0D=0A+=09=09=09 * famfs_dax_err() =
will return -EIO on access attempts.=0D=0A+=09=09=09 * Teardown handles t=
his case: skips fs_put_dax, calls put_dax.=0D=0A+=09=09=09 */=0D=0A+=09=09=
=09daxdev->dax_err =3D 1;=0D=0A+=09=09=09pr_err("%s: fs_dax_get(%lld) fai=
led\n",=0D=0A+=09=09=09       __func__, (u64)daxdev->devno);=0D=0A+=09=09=
}=0D=0A+=0D=0A =09=09wmb(); /* All other fields must be visible before va=
lid */=0D=0A =09=09daxdev->valid =3D 1;=0D=0A =09}=0D=0A@@ -244,6 +278,36=
 @@ famfs_update_daxdev_table(=0D=0A =09return 0;=0D=0A }=0D=0A=20=0D=0A+=
static void=0D=0A+famfs_set_daxdev_err(=0D=0A+=09struct fuse_conn *fc,=0D=
=0A+=09struct dax_device *dax_devp)=0D=0A+{=0D=0A+=09int i;=0D=0A+=0D=0A+=
=09/* Gotta search the list by dax_devp;=0D=0A+=09 * read lock because we=
're not adding or removing daxdev entries=0D=0A+=09 */=0D=0A+=09scoped_gu=
ard(rwsem_write, &fc->famfs_devlist_sem) {=0D=0A+=09=09for (i =3D 0; i < =
fc->dax_devlist->nslots; i++) {=0D=0A+=09=09=09if (fc->dax_devlist->devli=
st[i].valid) {=0D=0A+=09=09=09=09struct famfs_daxdev *dd;=0D=0A+=0D=0A+=09=
=09=09=09dd =3D &fc->dax_devlist->devlist[i];=0D=0A+=09=09=09=09if (dd->d=
evp !=3D dax_devp)=0D=0A+=09=09=09=09=09continue;=0D=0A+=0D=0A+=09=09=09=09=
dd->error =3D true;=0D=0A+=0D=0A+=09=09=09=09pr_err("%s: memory error on =
daxdev %s (%d)\n",=0D=0A+=09=09=09=09       __func__, dd->name, i);=0D=0A=
+=09=09=09=09return;=0D=0A+=09=09=09}=0D=0A+=09=09}=0D=0A+=09}=0D=0A+=09p=
r_err("%s: memory err on unrecognized daxdev\n", __func__);=0D=0A+}=0D=0A=
+=0D=0A /****************************************************************=
***********/=0D=0A=20=0D=0A void __famfs_meta_free(void *famfs_meta)=0D=0A=
@@ -585,6 +649,26 @@ famfs_file_init_dax(=0D=0A=20=0D=0A static int famfs=
_file_bad(struct inode *inode);=0D=0A=20=0D=0A+static int famfs_dax_err(s=
truct famfs_daxdev *dd)=0D=0A+{=0D=0A+=09if (!dd->valid) {=0D=0A+=09=09pr=
_err("%s: daxdev=3D%s invalid\n",=0D=0A+=09=09       __func__, dd->name);=
=0D=0A+=09=09return -EIO;=0D=0A+=09}=0D=0A+=09if (dd->dax_err) {=0D=0A+=09=
=09pr_err("%s: daxdev=3D%s dax_err\n",=0D=0A+=09=09       __func__, dd->n=
ame);=0D=0A+=09=09return -EIO;=0D=0A+=09}=0D=0A+=09if (dd->error) {=0D=0A=
+=09=09pr_err("%s: daxdev=3D%s memory error\n",=0D=0A+=09=09       __func=
__, dd->name);=0D=0A+=09=09return -EHWPOISON;=0D=0A+=09}=0D=0A+=09return =
0;=0D=0A+}=0D=0A+=0D=0A static int=0D=0A famfs_interleave_fileofs_to_daxo=
fs(struct inode *inode, struct iomap *iomap,=0D=0A =09=09=09 loff_t file_=
offset, off_t len, unsigned int flags)=0D=0A@@ -624,6 +708,7 @@ famfs_int=
erleave_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,=0D=0A=
=20=0D=0A =09=09/* Is the data is in this striped extent=3F */=0D=0A =09=09=
if (local_offset < ext_size) {=0D=0A+=09=09=09struct famfs_daxdev *dd;=0D=
=0A =09=09=09u64 chunk_num       =3D local_offset / chunk_size;=0D=0A =09=
=09=09u64 chunk_offset    =3D local_offset % chunk_size;=0D=0A =09=09=09u=
64 chunk_remainder =3D chunk_size - chunk_offset;=0D=0A@@ -632,6 +717,7 @=
@ famfs_interleave_fileofs_to_daxofs(struct inode *inode, struct iomap *i=
omap,=0D=0A =09=09=09u64 strip_offset    =3D chunk_offset + (stripe_num *=
 chunk_size);=0D=0A =09=09=09u64 strip_dax_ofs =3D fei->ie_strips[strip_n=
um].ext_offset;=0D=0A =09=09=09u64 strip_devidx =3D fei->ie_strips[strip_=
num].dev_index;=0D=0A+=09=09=09int rc;=0D=0A=20=0D=0A =09=09=09if (strip_=
devidx >=3D fc->dax_devlist->nslots) {=0D=0A =09=09=09=09pr_err("%s: stri=
p_devidx %llu >=3D nslots %d\n",=0D=0A@@ -646,6 +732,15 @@ famfs_interlea=
ve_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,=0D=0A =09=09=
=09=09goto err_out;=0D=0A =09=09=09}=0D=0A=20=0D=0A+=09=09=09dd =3D &fc->=
dax_devlist->devlist[strip_devidx];=0D=0A+=0D=0A+=09=09=09rc =3D famfs_da=
x_err(dd);=0D=0A+=09=09=09if (rc) {=0D=0A+=09=09=09=09/* Shut down access=
 to this file */=0D=0A+=09=09=09=09meta->error =3D true;=0D=0A+=09=09=09=09=
return rc;=0D=0A+=09=09=09}=0D=0A+=0D=0A =09=09=09iomap->addr    =3D stri=
p_dax_ofs + strip_offset;=0D=0A =09=09=09iomap->offset  =3D file_offset;=0D=
=0A =09=09=09iomap->length  =3D min_t(loff_t, len, chunk_remainder);=0D=0A=
@@ -743,6 +838,7 @@ famfs_fileofs_to_daxofs(struct inode *inode, struct i=
omap *iomap,=0D=0A =09=09if (local_offset < dax_ext_len) {=0D=0A =09=09=09=
loff_t ext_len_remainder =3D dax_ext_len - local_offset;=0D=0A =09=09=09s=
truct famfs_daxdev *dd;=0D=0A+=09=09=09int rc;=0D=0A=20=0D=0A =09=09=09if=
 (daxdev_idx >=3D fc->dax_devlist->nslots) {=0D=0A =09=09=09=09pr_err("%s=
: daxdev_idx %llu >=3D nslots %d\n",=0D=0A@@ -753,11 +849,11 @@ famfs_fil=
eofs_to_daxofs(struct inode *inode, struct iomap *iomap,=0D=0A=20=0D=0A =09=
=09=09dd =3D &fc->dax_devlist->devlist[daxdev_idx];=0D=0A=20=0D=0A-=09=09=
=09if (!dd->valid || dd->error) {=0D=0A-=09=09=09=09pr_err("%s: daxdev=3D=
%lld %s\n", __func__,=0D=0A-=09=09=09=09       daxdev_idx,=0D=0A-=09=09=09=
=09       dd->valid =3F "error" : "invalid");=0D=0A-=09=09=09=09goto err_=
out;=0D=0A+=09=09=09rc =3D famfs_dax_err(dd);=0D=0A+=09=09=09if (rc) {=0D=
=0A+=09=09=09=09/* Shut down access to this file */=0D=0A+=09=09=09=09met=
a->error =3D true;=0D=0A+=09=09=09=09return rc;=0D=0A =09=09=09}=0D=0A=20=
=0D=0A =09=09=09/*=0D=0Adiff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famf=
s_kfmap.h=0D=0Aindex eb9f70b5cb81..0fff841f5a9e 100644=0D=0A--- a/fs/fuse=
/famfs_kfmap.h=0D=0A+++ b/fs/fuse/famfs_kfmap.h=0D=0A@@ -73,7 +73,8 @@ st=
ruct famfs_file_meta {=0D=0A struct famfs_daxdev {=0D=0A =09/* Include de=
v uuid=3F */=0D=0A =09bool valid;=0D=0A-=09bool error;=0D=0A+=09bool erro=
r; /* Dax has reported a memory error (probably poison) */=0D=0A+=09bool =
dax_err; /* fs_dax_get() failed */=0D=0A =09dev_t devno;=0D=0A =09struct =
dax_device *devp;=0D=0A =09char *name;=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A=
