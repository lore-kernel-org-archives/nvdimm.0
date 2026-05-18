Received: from a11-75.smtp-out.amazonses.com (a11-75.smtp-out.amazonses.com [54.240.11.75])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E114B3002B3
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 21:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140199; cv=none; b=VevXwJjIp6SyRqCgx6G4L1bQhUErIyHAmmvLgLZo7hKaw2KCQBge5sgnQ5MS9Xkdp4rVaVCK7HUFm8O1kV4Z9jV7gXSlAKiFjbldDXS47sUIRm83/Wx9zoOdbcuzUTLsmhl1KxUMviQCgnK0YEhHX4MrTenUiMPSSLa8AW18MZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140199; c=relaxed/simple;
	bh=az1RGapaCTQsQWX566iUctnHK71U0CH1Qh72A3XOvWI=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=eUgWQGLo5YQFgGiLCHcQ8pYpHsizuDEMsJiTqazqz0+MjCVuuAPnn3I1rkawpXoAr8NgI+7yB3T53ldxd0G3O+ji0zpbUwHSq3TxdYhPuUvExCV9rtRof842FgO3h0VNL3YgAXffx0UYcJ9Pl4flSDSUSl4Y/IZRqJEMA79/O+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=pmy3ZI2E; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=pYnPvzAB; arc=none smtp.client-ip=54.240.11.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="pmy3ZI2E";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="pYnPvzAB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779140197;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=az1RGapaCTQsQWX566iUctnHK71U0CH1Qh72A3XOvWI=;
	b=pmy3ZI2ERDIh5n+Q18GtVT1yRTjU8XTQU//wSTRFSI5jcvCjfuqmPlYKBVsfLhnb
	dpM5x18Kml83w4O5RKRUE2cPvBApDx7jVvSJLKINifVTsSW7BNStpZy2UEtgNLc8J28
	1deMBh5fsMk7ffAidHbTinI2aOeJx/L7dItTLHzc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779140197;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=az1RGapaCTQsQWX566iUctnHK71U0CH1Qh72A3XOvWI=;
	b=pYnPvzAB55htLdedLWJArYxH69KHnh0PXWuwDJAcgoWi3fTsAQUkp+dtQ8K8+ifw
	VY3ZaAII2dz3Xq/xQZkiAtao50Uu6cLulsS9Q7XAsQS/DBcFgWTQu7mUNjLiwXvdN9i
	WZ0v3Cl/sFiyT0mTLlCylKj/MQ/FgHBbaRbhatyM=
Subject: [PATCH 6/6] dax: replace exported dax_dev_get() with non-allocating
 dax_dev_find()
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?Christian_Brauner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Mon, 18 May 2026 21:36:36 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com>
References: 
 <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com> 
 <20260518213631.31342-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc5w41mkJXxS0+R8GcNdWTTpRlkwAADGVL
Thread-Topic: [PATCH 6/6] dax: replace exported dax_dev_get() with
 non-allocating dax_dev_find()
X-Wm-Sent-Timestamp: 1779140195
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e3d04fa32-0941bfaf-d42e-4b57-af82-ed8bef9b39c5-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.18-54.240.11.75

From: John Groves <John@Groves.net>=0D=0A=0D=0AThis fix is in response to=
 a Sashiko review, and some subsequent=0D=0Aanalysis.=0D=0A=0D=0Adax_dev_=
get() uses iget5_locked() which creates a new inode if no=0D=0Amatching o=
ne exists. This is correct for the internal caller=0D=0A(alloc_dax), but =
dangerous for external callers that look up devices=0D=0Afrom user-suppli=
ed or metadata-supplied dev_t values:=0D=0A=0D=0A1. A new inode is create=
d with DAXDEV_ALIVE set but no backing driver,=0D=0A   no ops, and no IDA=
-allocated minor number.=0D=0A=0D=0A2. On teardown, dax_destroy_inode() w=
arns because kill_dax() was never=0D=0A   called, and dax_free_inode() ca=
lls ida_free() for a minor that was=0D=0A   never ida_alloc'd =E2=80=94 p=
otentially freeing the minor of a real device.=0D=0A=0D=0AAdd dax_dev_fin=
d() which uses ilookup5() for lookup-only semantics:=0D=0Ait returns an e=
xisting dax_device with an elevated inode reference, or=0D=0ANULL if no d=
evice with the given dev_t exists. It never creates inodes.=0D=0A=0D=0AMa=
ke dax_dev_get() static again (internal to super.c for alloc_dax),=0D=0Ae=
xport dax_dev_find() instead, and update the two external callers=0D=0A(f=
amfs_inode.c, famfs.c). Also add the missing CONFIG_DAX=3Dn stub.=0D=0A=0D=
=0AFixes: 2ae624d5a555d ("dax: export dax_dev_get()")=0D=0ASigned-off-by:=
 John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/super.c    | 27=
 +++++++++++++++++++++++++--=0D=0A fs/famfs/famfs_inode.c |  2 +-=0D=0A f=
s/fuse/famfs.c        |  2 +-=0D=0A include/linux/dax.h    |  6 +++++-=0D=
=0A 4 files changed, 32 insertions(+), 5 deletions(-)=0D=0A=0D=0Adiff --g=
it a/drivers/dax/super.c b/drivers/dax/super.c=0D=0Aindex fa1d2a6eb2408..=
79e5823d1010d 100644=0D=0A--- a/drivers/dax/super.c=0D=0A+++ b/drivers/da=
x/super.c=0D=0A@@ -541,7 +541,7 @@ static int dax_set(struct inode *inode=
, void *data)=0D=0A =09return 0;=0D=0A }=0D=0A=20=0D=0A-struct dax_device=
 *dax_dev_get(dev_t devt)=0D=0A+static struct dax_device *dax_dev_get(dev=
_t devt)=0D=0A {=0D=0A =09struct dax_device *dax_dev;=0D=0A =09struct ino=
de *inode;=0D=0A@@ -564,7 +564,30 @@ struct dax_device *dax_dev_get(dev_t=
 devt)=0D=0A=20=0D=0A =09return dax_dev;=0D=0A }=0D=0A-EXPORT_SYMBOL_GPL(=
dax_dev_get);=0D=0A+=0D=0A+/**=0D=0A+ * dax_dev_find - look up an existin=
g dax_device by dev_t=0D=0A+ * @devt: the device number to find=0D=0A+ *=0D=
=0A+ * Returns a dax_device with an elevated inode reference, or NULL if =
no=0D=0A+ * device with the given dev_t exists. Unlike dax_dev_get(), thi=
s never=0D=0A+ * allocates a new inode =E2=80=94 it is safe for external =
callers that are looking=0D=0A+ * up devices from user-supplied or metada=
ta-supplied dev_t values.=0D=0A+ *=0D=0A+ * Caller must put_dax() the ret=
urned device when done.=0D=0A+ */=0D=0A+struct dax_device *dax_dev_find(d=
ev_t devt)=0D=0A+{=0D=0A+=09struct inode *inode;=0D=0A+=0D=0A+=09inode =3D=
 ilookup5(dax_superblock, hash_32(devt + DAXFS_MAGIC, 31),=0D=0A+=09=09=09=
 dax_test, &devt);=0D=0A+=09if (!inode)=0D=0A+=09=09return NULL;=0D=0A+=0D=
=0A+=09return to_dax_dev(inode);=0D=0A+}=0D=0A+EXPORT_SYMBOL_GPL(dax_dev_=
find);=0D=0A=20=0D=0A struct dax_device *alloc_dax(void *private, const s=
truct dax_operations *ops)=0D=0A {=0D=0Adiff --git a/fs/famfs/famfs_inode=
=2Ec b/fs/famfs/famfs_inode.c=0D=0Aindex 9b8944f6aabdb..a5e6616d84de9 100=
644=0D=0A--- a/fs/famfs/famfs_inode.c=0D=0A+++ b/fs/famfs/famfs_inode.c=0D=
=0A@@ -367,7 +367,7 @@ famfs_get_tree(struct fs_context *fc)=0D=0A =09}=0D=
=0A=20=0D=0A =09/* This will fail if it's not a dax device */=0D=0A-=09da=
x_devp =3D dax_dev_get(daxdevno);=0D=0A+=09dax_devp =3D dax_dev_find(daxd=
evno);=0D=0A =09if (!dax_devp) {=0D=0A =09=09pr_warn("%s: device %s not f=
ound or not dax\n",=0D=0A =09=09       __func__, fc->source);=0D=0Adiff -=
-git a/fs/fuse/famfs.c b/fs/fuse/famfs.c=0D=0Aindex 121ed74e97277..6f867d=
cd289cc 100644=0D=0A--- a/fs/fuse/famfs.c=0D=0A+++ b/fs/fuse/famfs.c=0D=0A=
@@ -193,7 +193,7 @@ famfs_fuse_get_daxdev(struct fuse_mount *fm, const u6=
4 index)=0D=0A =09=09=09return -ENOMEM;=0D=0A=20=0D=0A =09=09/* This will=
 fail if it's not a dax device */=0D=0A-=09=09daxdev->devp =3D dax_dev_ge=
t(daxdev->devno);=0D=0A+=09=09daxdev->devp =3D dax_dev_find(daxdev->devno=
);=0D=0A =09=09if (!daxdev->devp) {=0D=0A =09=09=09pr_warn("%s: device %s=
 not found or not dax\n",=0D=0A =09=09=09=09__func__, daxdev_out.name);=0D=
=0Adiff --git a/include/linux/dax.h b/include/linux/dax.h=0D=0Aindex fe6c=
3ded1b50f..29113eb95e72d 100644=0D=0A--- a/include/linux/dax.h=0D=0A+++ b=
/include/linux/dax.h=0D=0A@@ -54,7 +54,7 @@ struct dax_device *alloc_dax(=
void *private, const struct dax_operations *ops);=0D=0A void *dax_holder(=
struct dax_device *dax_dev);=0D=0A void put_dax(struct dax_device *dax_de=
v);=0D=0A void kill_dax(struct dax_device *dax_dev);=0D=0A-struct dax_dev=
ice *dax_dev_get(dev_t devt);=0D=0A+struct dax_device *dax_dev_find(dev_t=
 devt);=0D=0A void dax_write_cache(struct dax_device *dax_dev, bool wc);=0D=
=0A bool dax_write_cache_enabled(struct dax_device *dax_dev);=0D=0A bool =
dax_synchronous(struct dax_device *dax_dev);=0D=0A@@ -92,6 +92,10 @@ stat=
ic inline void put_dax(struct dax_device *dax_dev)=0D=0A static inline vo=
id kill_dax(struct dax_device *dax_dev)=0D=0A {=0D=0A }=0D=0A+static inli=
ne struct dax_device *dax_dev_find(dev_t devt)=0D=0A+{=0D=0A+=09return NU=
LL;=0D=0A+}=0D=0A static inline void dax_write_cache(struct dax_device *d=
ax_dev, bool wc)=0D=0A {=0D=0A }=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
