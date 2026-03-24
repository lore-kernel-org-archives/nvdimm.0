Received: from a11-16.smtp-out.amazonses.com (a11-16.smtp-out.amazonses.com [54.240.11.16])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5188325A2C9
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312773; cv=none; b=blIYc+tNlwvtlEJTbM1pzBmAPJhg0bgkb5QcQXxVJuEbesUkdNVzUhHPFtmOFuR0dsSYOoksbMWuZj3BOMWiyDqmNqJTgo+Igjx57jg87ZIkzgp0wxuzyLB8aKXyG6LEuZo7/9NuyIlapTmDO2ojiycCWn/9puiEsotb1Fm6YaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312773; c=relaxed/simple;
	bh=iXbT+gYignqduNbmtIkrHJznxa0fJiB+Pex30xfScZk=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=PB6cwvWTUZPeDarq1qRuSLS6fJBMqFve3Y/6J8TQngENidP97rj3G5+tHXnh06SYuFU710Kx4RCZWryeb+rkD5PL7xecvcL2Mx6hBG7zYg5uhgyktAWVT6Hytxit5ZHVkSFFmA+D2rL2+rZnYbTeCMVHS+uLZByLdJbjQVFDnCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=qbLKXSD8; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=n0inwkJV; arc=none smtp.client-ip=54.240.11.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="qbLKXSD8";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="n0inwkJV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312771;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=iXbT+gYignqduNbmtIkrHJznxa0fJiB+Pex30xfScZk=;
	b=qbLKXSD86UAPzU42IBVXux6ZjzH/Aaibu4cDfgLnVz/8JpU+7hUnx7ZAJF5dERAK
	/VPPvQLOmyf7kEMFPlyBCTqzscPej04dQ7gXrzW6Rn4Q2/s2hIQMyx6AIklzK/iHsFn
	9Qvzv2/RBVKWyy+ODaZgHW/AU82/iyAVq/nGJqAA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312771;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=iXbT+gYignqduNbmtIkrHJznxa0fJiB+Pex30xfScZk=;
	b=n0inwkJVIgIBkLkaKp0lXJenhEyOBQRAMzv/PJcozdrwo4XKEsQDCMONZglzciOH
	CTFlQnD/dh7hUwCAPZ2X+A5zatkRt33PCPXXrtMyCwZ2CyB2n1+Yq+GA4J84IfFNCgh
	AZzkO1D/ygBmbzIatBGy5IoVqpN/w0y8wzFoLpTU=
Subject: [PATCH V9 7/8] dax: Add fs_dax_get() func to prepare dax for fs-dax
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
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Tue, 24 Mar 2026 00:39:31 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
References: 
 <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com> 
 <20260324003919.5106-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuyasDstNJqn3QUm30xyLwGjtTg==
Thread-Topic: [PATCH V9 7/8] dax: Add fs_dax_get() func to prepare dax for
 fs-dax usage
X-Wm-Sent-Timestamp: 1774312769
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d484ddc-2487f887-7ecd-49a3-abfe-9dabec28873f-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.11.16

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
will be called by fs/fuse/famfs.c in a subsequent commit.=0D=0A=0D=0ASign=
ed-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/bus.c=
   |  2 --=0D=0A drivers/dax/bus.h   |  2 ++=0D=0A drivers/dax/super.c | =
66 ++++++++++++++++++++++++++++++++++++++++++++-=0D=0A include/linux/dax.=
h | 17 +++++++++---=0D=0A 4 files changed, 80 insertions(+), 7 deletions(=
-)=0D=0A=0D=0Adiff --git a/drivers/dax/bus.c b/drivers/dax/bus.c=0D=0Aind=
ex 562e2b06f61a..8a8710a8234e 100644=0D=0A--- a/drivers/dax/bus.c=0D=0A++=
+ b/drivers/dax/bus.c=0D=0A@@ -39,8 +39,6 @@ static int dax_bus_uevent(co=
nst struct device *dev, struct kobj_uevent_env *env)=0D=0A =09return add_=
uevent_var(env, "MODALIAS=3D" DAX_DEVICE_MODALIAS_FMT, 0);=0D=0A }=0D=0A=20=
=0D=0A-#define to_dax_drv(__drv)=09container_of_const(__drv, struct dax_d=
evice_driver, drv)=0D=0A-=0D=0A static struct dax_id *__dax_match_id(cons=
t struct dax_device_driver *dax_drv,=0D=0A =09=09const char *dev_name)=0D=
=0A {=0D=0Adiff --git a/drivers/dax/bus.h b/drivers/dax/bus.h=0D=0Aindex =
880bdf7e72d7..dc6f112ac4a4 100644=0D=0A--- a/drivers/dax/bus.h=0D=0A+++ b=
/drivers/dax/bus.h=0D=0A@@ -42,6 +42,8 @@ struct dax_device_driver {=0D=0A=
 =09void (*remove)(struct dev_dax *dev);=0D=0A };=0D=0A=20=0D=0A+#define =
to_dax_drv(__drv) container_of_const(__drv, struct dax_device_driver, drv=
)=0D=0A+=0D=0A int __dax_driver_register(struct dax_device_driver *dax_dr=
v,=0D=0A =09=09struct module *module, const char *mod_name);=0D=0A #defin=
e dax_driver_register(driver) \=0D=0Adiff --git a/drivers/dax/super.c b/d=
rivers/dax/super.c=0D=0Aindex ba0b4cd18a77..d4ab60c406bf 100644=0D=0A--- =
a/drivers/dax/super.c=0D=0A+++ b/drivers/dax/super.c=0D=0A@@ -14,6 +14,7 =
@@=0D=0A #include <linux/fs.h>=0D=0A #include <linux/cacheinfo.h>=0D=0A #=
include "dax-private.h"=0D=0A+#include "bus.h"=0D=0A=20=0D=0A /**=0D=0A  =
* struct dax_device - anchor object for dax services=0D=0A@@ -111,6 +112,=
10 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev, u6=
4 *start_off,=0D=0A }=0D=0A EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);=0D=0A=20=
=0D=0A+#endif /* CONFIG_BLOCK && CONFIG_FS_DAX */=0D=0A+=0D=0A+#if IS_ENA=
BLED(CONFIG_FS_DAX)=0D=0A+=0D=0A void fs_put_dax(struct dax_device *dax_d=
ev, void *holder)=0D=0A {=0D=0A =09if (dax_dev && holder &&=0D=0A@@ -119,=
7 +124,66 @@ void fs_put_dax(struct dax_device *dax_dev, void *holder)=0D=
=0A =09put_dax(dax_dev);=0D=0A }=0D=0A EXPORT_SYMBOL_GPL(fs_put_dax);=0D=0A=
-#endif /* CONFIG_BLOCK && CONFIG_FS_DAX */=0D=0A+=0D=0A+/**=0D=0A+ * fs_=
dax_get() - get ownership of a devdax via holder/holder_ops=0D=0A+ *=0D=0A=
+ * fs-dax file systems call this function to prepare to use a devdax dev=
ice for=0D=0A+ * fsdax. This is like fs_dax_get_by_bdev(), but the caller=
 already has struct=0D=0A+ * dev_dax (and there is no bdev). The holder m=
akes this exclusive.=0D=0A+ *=0D=0A+ * @dax_dev: dev to be prepared for f=
s-dax usage=0D=0A+ * @holder: filesystem or mapped device inside the dax_=
device=0D=0A+ * @hops: operations for the inner holder=0D=0A+ *=0D=0A+ * =
Returns: 0 on success, <0 on failure=0D=0A+ */=0D=0A+int fs_dax_get(struc=
t dax_device *dax_dev, void *holder,=0D=0A+=09const struct dax_holder_ope=
rations *hops)=0D=0A+{=0D=0A+=09struct dev_dax *dev_dax;=0D=0A+=09struct =
dax_device_driver *dax_drv;=0D=0A+=09int id;=0D=0A+=0D=0A+=09id =3D dax_r=
ead_lock();=0D=0A+=09if (!dax_dev || !dax_alive(dax_dev) || !igrab(&dax_d=
ev->inode)) {=0D=0A+=09=09dax_read_unlock(id);=0D=0A+=09=09return -ENODEV=
;=0D=0A+=09}=0D=0A+=09dax_read_unlock(id);=0D=0A+=0D=0A+=09/* Verify the =
device is bound to fsdev_dax driver */=0D=0A+=09dev_dax =3D dax_get_priva=
te(dax_dev);=0D=0A+=09if (!dev_dax) {=0D=0A+=09=09iput(&dax_dev->inode);=0D=
=0A+=09=09return -ENODEV;=0D=0A+=09}=0D=0A+=0D=0A+=09device_lock(&dev_dax=
->dev);=0D=0A+=09if (!dev_dax->dev.driver) {=0D=0A+=09=09device_unlock(&d=
ev_dax->dev);=0D=0A+=09=09iput(&dax_dev->inode);=0D=0A+=09=09return -ENOD=
EV;=0D=0A+=09}=0D=0A+=09dax_drv =3D to_dax_drv(dev_dax->dev.driver);=0D=0A=
+=09if (dax_drv->type !=3D DAXDRV_FSDEV_TYPE) {=0D=0A+=09=09device_unlock=
(&dev_dax->dev);=0D=0A+=09=09iput(&dax_dev->inode);=0D=0A+=09=09return -E=
OPNOTSUPP;=0D=0A+=09}=0D=0A+=09device_unlock(&dev_dax->dev);=0D=0A+=0D=0A=
+=09if (cmpxchg(&dax_dev->holder_data, NULL, holder)) {=0D=0A+=09=09iput(=
&dax_dev->inode);=0D=0A+=09=09return -EBUSY;=0D=0A+=09}=0D=0A+=0D=0A+=09d=
ax_dev->holder_ops =3D hops;=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+EXPO=
RT_SYMBOL_GPL(fs_dax_get);=0D=0A+#endif /* CONFIG_FS_DAX */=0D=0A=20=0D=0A=
 enum dax_device_flags {=0D=0A =09/* !alive + rcu grace period =3D=3D no =
new operations / mappings */=0D=0Adiff --git a/include/linux/dax.h b/incl=
ude/linux/dax.h=0D=0Aindex b19bfe0c2fd1..bf37b9a982f3 100644=0D=0A--- a/i=
nclude/linux/dax.h=0D=0A+++ b/include/linux/dax.h=0D=0A@@ -130,7 +130,6 @=
@ int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk);=0D=0A=
 void dax_remove_host(struct gendisk *disk);=0D=0A struct dax_device *fs_=
dax_get_by_bdev(struct block_device *bdev, u64 *start_off,=0D=0A =09=09vo=
id *holder, const struct dax_holder_operations *ops);=0D=0A-void fs_put_d=
ax(struct dax_device *dax_dev, void *holder);=0D=0A #else=0D=0A static in=
line int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk)=0D=
=0A {=0D=0A@@ -145,12 +144,13 @@ static inline struct dax_device *fs_dax_=
get_by_bdev(struct block_device *bdev,=0D=0A {=0D=0A =09return NULL;=0D=0A=
 }=0D=0A-static inline void fs_put_dax(struct dax_device *dax_dev, void *=
holder)=0D=0A-{=0D=0A-}=0D=0A #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */=0D=
=0A=20=0D=0A #if IS_ENABLED(CONFIG_FS_DAX)=0D=0A+void fs_put_dax(struct d=
ax_device *dax_dev, void *holder);=0D=0A+int fs_dax_get(struct dax_device=
 *dax_dev, void *holder,=0D=0A+=09       const struct dax_holder_operatio=
ns *hops);=0D=0A+struct dax_device *inode_dax(struct inode *inode);=0D=0A=
 int dax_writeback_mapping_range(struct address_space *mapping,=0D=0A =09=
=09struct dax_device *dax_dev, struct writeback_control *wbc);=0D=0A int =
dax_folio_reset_order(struct folio *folio);=0D=0A@@ -164,6 +164,15 @@ dax=
_entry_t dax_lock_mapping_entry(struct address_space *mapping,=0D=0A void=
 dax_unlock_mapping_entry(struct address_space *mapping,=0D=0A =09=09unsi=
gned long index, dax_entry_t cookie);=0D=0A #else=0D=0A+static inline voi=
d fs_put_dax(struct dax_device *dax_dev, void *holder)=0D=0A+{=0D=0A+}=0D=
=0A+=0D=0A+static inline int fs_dax_get(struct dax_device *dax_dev, void =
*holder,=0D=0A+=09=09=09     const struct dax_holder_operations *hops)=0D=
=0A+{=0D=0A+=09return -EOPNOTSUPP;=0D=0A+}=0D=0A static inline struct pag=
e *dax_layout_busy_page(struct address_space *mapping)=0D=0A {=0D=0A =09r=
eturn NULL;=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
