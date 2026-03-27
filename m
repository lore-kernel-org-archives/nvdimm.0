Received: from a8-208.smtp-out.amazonses.com (a8-208.smtp-out.amazonses.com [54.240.8.208])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FCB393DFD
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 21:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774645514; cv=none; b=rjSLyZ9OfUpHoEl5ZdGznI64rDKy6gZSrj3RBjAlq+S7TX3/SRlOYzIYn/+uzIPjT5tunEeHFtfQmwi1W1yy00+BASjN4zTgpW1/dmfqq6GyHUp4pCy6y8WMiWBSunpuVgqVJdJNH1v97Xvc99XMt+GrfV5by8v8DSl3tMgYqlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774645514; c=relaxed/simple;
	bh=kSF6X6wcgHhF0iClvWpMC/+1EDQ/d7jxIoBNhWlJfAM=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=WK7ydjwITWSuxsDt8P3Fkjdlw5mHeIvaN2LuODNPwUx9evX2FrqZcLvPMbO33lj4ey1sdrNrHqrIwfAGMNeijqVej2djitF965IOyrEqt+N0tU/sAAAEZX/MNV4usYr7j8kkKM2stVcldhBwpZiVvT5JiGi0aFHuDbmJ0LIPY0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=mmWnEB73; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=EV8vX4Sh; arc=none smtp.client-ip=54.240.8.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="mmWnEB73";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="EV8vX4Sh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774645512;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=kSF6X6wcgHhF0iClvWpMC/+1EDQ/d7jxIoBNhWlJfAM=;
	b=mmWnEB73lGE/9aVBLoNesOs3EQ+FwCe6rsO1J0bPmHaRKCRjm8dXDIQJO4vJTo7l
	FTqjR4kya8A80JYaQZdfkBf9GVADm8qRiNxVhEVxVRCWDwaa+GBb+XrgPgja6DbRVP4
	qD3l0Wqvm6V6qWgYP/BM/Sj6sD8M5D/UWdeHIyhc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774645512;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=kSF6X6wcgHhF0iClvWpMC/+1EDQ/d7jxIoBNhWlJfAM=;
	b=EV8vX4ShTSN3E21pI04fvBUmo8Cth44Rpp7NGNFd4VwDTUyJiq+tLeISXrQ317X4
	UxDIOehqJiTAvixESmHiO98hC5SjNuaXrxmFImDefIfIrzQ+9BrfgFVweafWOfovY3t
	3+Pr6P1TQ5rWC3CPfguvYIEZBxiCVnHYhMVP15fQ=
Subject: [PATCH V10 7/8] dax: Add fs_dax_get() func to prepare dax for fs-dax
 usage
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
	=?UTF-8?Q?John_Groves?= <john@groves.net>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jonathan.cameron@huawei.com>
Date: Fri, 27 Mar 2026 21:05:12 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
References: 
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com> 
 <20260327210505.79239-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcvi1l2bzusgUORrCY97XNODCliQ==
Thread-Topic: [PATCH V10 7/8] dax: Add fs_dax_get() func to prepare dax for
 fs-dax usage
X-Wm-Sent-Timestamp: 1774645510
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d311d8750-75395c22-031b-4d5f-aebe-790dca656b87-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.27-54.240.8.208

From: John Groves <john@groves.net>=0D=0A=0D=0AThe fs_dax_get() function =
should be called by fs-dax file systems after=0D=0Aopening a fsdev dax de=
vice. This adds holder_operations, which provides=0D=0Aa memory failure c=
allback path and effects exclusivity between callers=0D=0Aof fs_dax_get()=
=2E=0D=0A=0D=0Afs_dax_get() is specific to fsdev_dax, so it checks the dr=
iver type=0D=0A(which required touching bus.[ch]). fs_dax_get() fails if =
fsdev_dax is=0D=0Anot bound to the memory.=0D=0A=0D=0AThis function serve=
s the same role as fs_dax_get_by_bdev(), which dax=0D=0Afile systems call=
 after opening the pmem block device.=0D=0A=0D=0AThis can't be located in=
 fsdev.c because struct dax_device is opaque=0D=0Athere.=0D=0A=0D=0AThis =
will be called by fs/fuse/famfs.c in a subsequent commit.=0D=0A=0D=0ARevi=
ewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>=0D=0AReviewed-by:=
 Dave Jiang <dave.jiang@intel.com>=0D=0ASigned-off-by: John Groves <john@=
groves.net>=0D=0A---=0D=0A drivers/dax/bus.c   |  2 --=0D=0A drivers/dax/=
bus.h   |  2 ++=0D=0A drivers/dax/super.c | 66 ++++++++++++++++++++++++++=
++++++++++++++++++-=0D=0A include/linux/dax.h | 16 ++++++++---=0D=0A 4 fi=
les changed, 79 insertions(+), 7 deletions(-)=0D=0A=0D=0Adiff --git a/dri=
vers/dax/bus.c b/drivers/dax/bus.c=0D=0Aindex 1b412264bb36..32f7b7702c28 =
100644=0D=0A--- a/drivers/dax/bus.c=0D=0A+++ b/drivers/dax/bus.c=0D=0A@@ =
-39,8 +39,6 @@ static int dax_bus_uevent(const struct device *dev, struct=
 kobj_uevent_env *env)=0D=0A =09return add_uevent_var(env, "MODALIAS=3D" =
DAX_DEVICE_MODALIAS_FMT, 0);=0D=0A }=0D=0A=20=0D=0A-#define to_dax_drv(__=
drv)=09container_of_const(__drv, struct dax_device_driver, drv)=0D=0A-=0D=
=0A static struct dax_id *__dax_match_id(const struct dax_device_driver *=
dax_drv,=0D=0A =09=09const char *dev_name)=0D=0A {=0D=0Adiff --git a/driv=
ers/dax/bus.h b/drivers/dax/bus.h=0D=0Aindex 880bdf7e72d7..dc6f112ac4a4 1=
00644=0D=0A--- a/drivers/dax/bus.h=0D=0A+++ b/drivers/dax/bus.h=0D=0A@@ -=
42,6 +42,8 @@ struct dax_device_driver {=0D=0A =09void (*remove)(struct d=
ev_dax *dev);=0D=0A };=0D=0A=20=0D=0A+#define to_dax_drv(__drv) container=
_of_const(__drv, struct dax_device_driver, drv)=0D=0A+=0D=0A int __dax_dr=
iver_register(struct dax_device_driver *dax_drv,=0D=0A =09=09struct modul=
e *module, const char *mod_name);=0D=0A #define dax_driver_register(drive=
r) \=0D=0Adiff --git a/drivers/dax/super.c b/drivers/dax/super.c=0D=0Aind=
ex ba0b4cd18a77..d4ab60c406bf 100644=0D=0A--- a/drivers/dax/super.c=0D=0A=
+++ b/drivers/dax/super.c=0D=0A@@ -14,6 +14,7 @@=0D=0A #include <linux/fs=
=2Eh>=0D=0A #include <linux/cacheinfo.h>=0D=0A #include "dax-private.h"=0D=
=0A+#include "bus.h"=0D=0A=20=0D=0A /**=0D=0A  * struct dax_device - anch=
or object for dax services=0D=0A@@ -111,6 +112,10 @@ struct dax_device *f=
s_dax_get_by_bdev(struct block_device *bdev, u64 *start_off,=0D=0A }=0D=0A=
 EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);=0D=0A=20=0D=0A+#endif /* CONFIG_B=
LOCK && CONFIG_FS_DAX */=0D=0A+=0D=0A+#if IS_ENABLED(CONFIG_FS_DAX)=0D=0A=
+=0D=0A void fs_put_dax(struct dax_device *dax_dev, void *holder)=0D=0A {=
=0D=0A =09if (dax_dev && holder &&=0D=0A@@ -119,7 +124,66 @@ void fs_put_=
dax(struct dax_device *dax_dev, void *holder)=0D=0A =09put_dax(dax_dev);=0D=
=0A }=0D=0A EXPORT_SYMBOL_GPL(fs_put_dax);=0D=0A-#endif /* CONFIG_BLOCK &=
& CONFIG_FS_DAX */=0D=0A+=0D=0A+/**=0D=0A+ * fs_dax_get() - get ownership=
 of a devdax via holder/holder_ops=0D=0A+ *=0D=0A+ * fs-dax file systems =
call this function to prepare to use a devdax device for=0D=0A+ * fsdax. =
This is like fs_dax_get_by_bdev(), but the caller already has struct=0D=0A=
+ * dev_dax (and there is no bdev). The holder makes this exclusive.=0D=0A=
+ *=0D=0A+ * @dax_dev: dev to be prepared for fs-dax usage=0D=0A+ * @hold=
er: filesystem or mapped device inside the dax_device=0D=0A+ * @hops: ope=
rations for the inner holder=0D=0A+ *=0D=0A+ * Returns: 0 on success, <0 =
on failure=0D=0A+ */=0D=0A+int fs_dax_get(struct dax_device *dax_dev, voi=
d *holder,=0D=0A+=09const struct dax_holder_operations *hops)=0D=0A+{=0D=0A=
+=09struct dev_dax *dev_dax;=0D=0A+=09struct dax_device_driver *dax_drv;=0D=
=0A+=09int id;=0D=0A+=0D=0A+=09id =3D dax_read_lock();=0D=0A+=09if (!dax_=
dev || !dax_alive(dax_dev) || !igrab(&dax_dev->inode)) {=0D=0A+=09=09dax_=
read_unlock(id);=0D=0A+=09=09return -ENODEV;=0D=0A+=09}=0D=0A+=09dax_read=
_unlock(id);=0D=0A+=0D=0A+=09/* Verify the device is bound to fsdev_dax d=
river */=0D=0A+=09dev_dax =3D dax_get_private(dax_dev);=0D=0A+=09if (!dev=
_dax) {=0D=0A+=09=09iput(&dax_dev->inode);=0D=0A+=09=09return -ENODEV;=0D=
=0A+=09}=0D=0A+=0D=0A+=09device_lock(&dev_dax->dev);=0D=0A+=09if (!dev_da=
x->dev.driver) {=0D=0A+=09=09device_unlock(&dev_dax->dev);=0D=0A+=09=09ip=
ut(&dax_dev->inode);=0D=0A+=09=09return -ENODEV;=0D=0A+=09}=0D=0A+=09dax_=
drv =3D to_dax_drv(dev_dax->dev.driver);=0D=0A+=09if (dax_drv->type !=3D =
DAXDRV_FSDEV_TYPE) {=0D=0A+=09=09device_unlock(&dev_dax->dev);=0D=0A+=09=09=
iput(&dax_dev->inode);=0D=0A+=09=09return -EOPNOTSUPP;=0D=0A+=09}=0D=0A+=09=
device_unlock(&dev_dax->dev);=0D=0A+=0D=0A+=09if (cmpxchg(&dax_dev->holde=
r_data, NULL, holder)) {=0D=0A+=09=09iput(&dax_dev->inode);=0D=0A+=09=09r=
eturn -EBUSY;=0D=0A+=09}=0D=0A+=0D=0A+=09dax_dev->holder_ops =3D hops;=0D=
=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+EXPORT_SYMBOL_GPL(fs_dax_get);=0D=0A=
+#endif /* CONFIG_FS_DAX */=0D=0A=20=0D=0A enum dax_device_flags {=0D=0A =
=09/* !alive + rcu grace period =3D=3D no new operations / mappings */=0D=
=0Adiff --git a/include/linux/dax.h b/include/linux/dax.h=0D=0Aindex b19b=
fe0c2fd1..a85e270bfb3c 100644=0D=0A--- a/include/linux/dax.h=0D=0A+++ b/i=
nclude/linux/dax.h=0D=0A@@ -130,7 +130,6 @@ int dax_add_host(struct dax_d=
evice *dax_dev, struct gendisk *disk);=0D=0A void dax_remove_host(struct =
gendisk *disk);=0D=0A struct dax_device *fs_dax_get_by_bdev(struct block_=
device *bdev, u64 *start_off,=0D=0A =09=09void *holder, const struct dax_=
holder_operations *ops);=0D=0A-void fs_put_dax(struct dax_device *dax_dev=
, void *holder);=0D=0A #else=0D=0A static inline int dax_add_host(struct =
dax_device *dax_dev, struct gendisk *disk)=0D=0A {=0D=0A@@ -145,12 +144,1=
2 @@ static inline struct dax_device *fs_dax_get_by_bdev(struct block_dev=
ice *bdev,=0D=0A {=0D=0A =09return NULL;=0D=0A }=0D=0A-static inline void=
 fs_put_dax(struct dax_device *dax_dev, void *holder)=0D=0A-{=0D=0A-}=0D=0A=
 #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */=0D=0A=20=0D=0A #if IS_ENABLED=
(CONFIG_FS_DAX)=0D=0A+void fs_put_dax(struct dax_device *dax_dev, void *h=
older);=0D=0A+int fs_dax_get(struct dax_device *dax_dev, void *holder,=0D=
=0A+=09       const struct dax_holder_operations *hops);=0D=0A int dax_wr=
iteback_mapping_range(struct address_space *mapping,=0D=0A =09=09struct d=
ax_device *dax_dev, struct writeback_control *wbc);=0D=0A int dax_folio_r=
eset_order(struct folio *folio);=0D=0A@@ -164,6 +163,15 @@ dax_entry_t da=
x_lock_mapping_entry(struct address_space *mapping,=0D=0A void dax_unlock=
_mapping_entry(struct address_space *mapping,=0D=0A =09=09unsigned long i=
ndex, dax_entry_t cookie);=0D=0A #else=0D=0A+static inline void fs_put_da=
x(struct dax_device *dax_dev, void *holder)=0D=0A+{=0D=0A+}=0D=0A+=0D=0A+=
static inline int fs_dax_get(struct dax_device *dax_dev, void *holder,=0D=
=0A+=09=09=09     const struct dax_holder_operations *hops)=0D=0A+{=0D=0A=
+=09return -EOPNOTSUPP;=0D=0A+}=0D=0A static inline struct page *dax_layo=
ut_busy_page(struct address_space *mapping)=0D=0A {=0D=0A =09return NULL;=
=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
