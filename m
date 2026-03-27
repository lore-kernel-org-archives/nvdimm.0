Received: from a11-129.smtp-out.amazonses.com (a11-129.smtp-out.amazonses.com [54.240.11.129])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36CB36B04B
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 21:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774645478; cv=none; b=quGZ9Ia1zN45011EQKaAleawSB/lxiU0MtK80VvKzQafwbbuY+UZzIOS9qbXgmO33+Z2gkZhATfy8ZdY5t+5/Z38mQdsGrFueEgZvEuMA7lV9z7iAPfPFEDQm0jqkt8PkKK7r4HYJv44BCmEFCb7YuQYGeH2A5ejMe7WxadGacs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774645478; c=relaxed/simple;
	bh=cH2faEMRzFXKfq7fWRIa8agBCXp6TyAN46Umx3FLhtk=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=RPwdWv0Di6Dq1oZPGoV2Rq8PYQ4Yv13K/VAeQkIyJAL2PIhOlhzZLvNZmIsSUuznlzXYfceFmFhkyXu0PYBTdOZtKc/bG3Gwy2/Gfj5fUSIRRUT1vs3MosQ3mkiv0H59+KTcuNKOcaoiwhFLxOL+4EIT7yLjh9/p/ku7qfMx9zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=jDT7AHVE; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=tdvOjxG9; arc=none smtp.client-ip=54.240.11.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="jDT7AHVE";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="tdvOjxG9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774645475;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=cH2faEMRzFXKfq7fWRIa8agBCXp6TyAN46Umx3FLhtk=;
	b=jDT7AHVEnhRRcNoqZidfa3cXEFqqCebFBVsCp8VTSztJq7EMfKv1qZvXl7+EMfr8
	vpMLmwLgRnG6GhYG7XdNk3ZeoAufkJ8eeqTgH8R/sc9gEsS360QIQLMBPol58yknEWI
	BChVba6JXsjVUaWJpmXZHNPywl8FZiyVR1dItiVw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774645475;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=cH2faEMRzFXKfq7fWRIa8agBCXp6TyAN46Umx3FLhtk=;
	b=tdvOjxG9ycyVKRXW+i8wY2iuPwSQBnuivj6IwTTifDB51GmsoWBxfpJS9Jn9VFj/
	1t+mZ2QRrphXuNCP4m67sq7U1QHs32+q4HLS2NPhT+/w4MHVNVWLW3lv52i1DHi2jlO
	5GrT9Fz+kmaMnnGv9NhKlQApEkfayr+NSezKijnc=
Subject: [PATCH V10 3/8] dax: add fsdev.c driver for fs-dax on character dax
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
Date: Fri, 27 Mar 2026 21:04:35 +0000
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
 <20260327210425.79170-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcvi1PmhfH0/7tTO+c9A4hiOIBMw==
Thread-Topic: [PATCH V10 3/8] dax: add fsdev.c driver for fs-dax on character
 dax
X-Wm-Sent-Timestamp: 1774645474
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d311cf904-419e9526-bdaf-4daa-97f1-5060b31a5c9f-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.27-54.240.11.129

From: John Groves <john@groves.net>=0D=0A=0D=0AThe new fsdev driver provi=
des pages/folios initialized compatibly with=0D=0Afsdax - normal rather t=
han devdax-style refcounting, and starting out=0D=0Awith order-0 folios.=0D=
=0A=0D=0AWhen fsdev binds to a daxdev, it is usually (always=3F) switchin=
g from the=0D=0Adevdax mode (device.c), which pre-initializes compound fo=
lios according=0D=0Ato its alignment. Fsdev uses fsdev_clear_folio_state(=
) to switch the=0D=0Afolios into a fsdax-compatible state.=0D=0A=0D=0AA s=
ide effect of this is that raw mmap doesn't (can't=3F) work on an fsdev=0D=
=0Adax instance. Accordingly, The fsdev driver does not provide raw mmap =
-=0D=0Adevices must be put in 'devdax' mode (drivers/dax/device.c) to get=
 raw=0D=0Ammap capability.=0D=0A=0D=0AIn this commit is just the framewor=
k, which remaps pages/folios compatibly=0D=0Awith fsdax.=0D=0A=0D=0AEnabl=
ing dax changes:=0D=0A=0D=0A- bus.h: add DAXDRV_FSDEV_TYPE driver type=0D=
=0A- bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs=0D=0A- dax=
=2Eh: prototype inode_dax(), which fsdev needs=0D=0A=0D=0ASuggested-by: D=
an Williams <dan.j.williams@intel.com>=0D=0ASuggested-by: Gregory Price <=
gourry@gourry.net>=0D=0AReviewed-by: Jonathan Cameron <jonathan.cameron@h=
uawei.com>=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A=
 MAINTAINERS          |   8 ++=0D=0A drivers/dax/Kconfig  |   5 +=0D=0A d=
rivers/dax/Makefile |   2 +=0D=0A drivers/dax/bus.h    |   1 +=0D=0A driv=
ers/dax/fsdev.c  | 245 +++++++++++++++++++++++++++++++++++++++++++=0D=0A =
fs/dax.c             |   1 +=0D=0A 6 files changed, 262 insertions(+)=0D=0A=
 create mode 100644 drivers/dax/fsdev.c=0D=0A=0D=0Adiff --git a/MAINTAINE=
RS b/MAINTAINERS=0D=0Aindex 7d10988cbc62..eedf4cce56ed 100644=0D=0A--- a/=
MAINTAINERS=0D=0A+++ b/MAINTAINERS=0D=0A@@ -7298,6 +7298,14 @@ L:=09linux=
-cxl@vger.kernel.org=0D=0A S:=09Supported=0D=0A F:=09drivers/dax/=0D=0A=20=
=0D=0A+DEVICE DIRECT ACCESS (DAX) [fsdev_dax]=0D=0A+M:=09John Groves <jgr=
oves@micron.com>=0D=0A+M:=09John Groves <John@Groves.net>=0D=0A+L:=09nvdi=
mm@lists.linux.dev=0D=0A+L:=09linux-cxl@vger.kernel.org=0D=0A+S:=09Suppor=
ted=0D=0A+F:=09drivers/dax/fsdev.c=0D=0A+=0D=0A DEVICE FREQUENCY (DEVFREQ=
)=0D=0A M:=09MyungJoo Ham <myungjoo.ham@samsung.com>=0D=0A M:=09Kyungmin =
Park <kyungmin.park@samsung.com>=0D=0Adiff --git a/drivers/dax/Kconfig b/=
drivers/dax/Kconfig=0D=0Aindex d656e4c0eb84..6d8493cc540c 100644=0D=0A---=
 a/drivers/dax/Kconfig=0D=0A+++ b/drivers/dax/Kconfig=0D=0A@@ -61,6 +61,1=
1 @@ config DEV_DAX_HMEM_DEVICES=0D=0A =09depends on DEV_DAX_HMEM && DAX=0D=
=0A =09def_bool y=0D=0A=20=0D=0A+config DEV_DAX_FSDEV=0D=0A+=09tristate=0D=
=0A+=09depends on DEV_DAX && FS_DAX=0D=0A+=09default DEV_DAX=0D=0A+=0D=0A=
 config DEV_DAX_KMEM=0D=0A =09tristate "KMEM DAX: map dax-devices as Syst=
em-RAM"=0D=0A =09default DEV_DAX=0D=0Adiff --git a/drivers/dax/Makefile b=
/drivers/dax/Makefile=0D=0Aindex 5ed5c39857c8..ba35bda7abef 100644=0D=0A-=
-- a/drivers/dax/Makefile=0D=0A+++ b/drivers/dax/Makefile=0D=0A@@ -4,11 +=
4,13 @@ obj-$(CONFIG_DEV_DAX) +=3D device_dax.o=0D=0A obj-$(CONFIG_DEV_DA=
X_KMEM) +=3D kmem.o=0D=0A obj-$(CONFIG_DEV_DAX_PMEM) +=3D dax_pmem.o=0D=0A=
 obj-$(CONFIG_DEV_DAX_CXL) +=3D dax_cxl.o=0D=0A+obj-$(CONFIG_DEV_DAX_FSDE=
V) +=3D fsdev_dax.o=0D=0A=20=0D=0A dax-y :=3D super.o=0D=0A dax-y +=3D bu=
s.o=0D=0A device_dax-y :=3D device.o=0D=0A dax_pmem-y :=3D pmem.o=0D=0A d=
ax_cxl-y :=3D cxl.o=0D=0A+fsdev_dax-y :=3D fsdev.o=0D=0A=20=0D=0A obj-y +=
=3D hmem/=0D=0Adiff --git a/drivers/dax/bus.h b/drivers/dax/bus.h=0D=0Ain=
dex cbbf64443098..880bdf7e72d7 100644=0D=0A--- a/drivers/dax/bus.h=0D=0A+=
++ b/drivers/dax/bus.h=0D=0A@@ -31,6 +31,7 @@ struct dev_dax *devm_create=
_dev_dax(struct dev_dax_data *data);=0D=0A enum dax_driver_type {=0D=0A =09=
DAXDRV_KMEM_TYPE,=0D=0A =09DAXDRV_DEVICE_TYPE,=0D=0A+=09DAXDRV_FSDEV_TYPE=
,=0D=0A };=0D=0A=20=0D=0A struct dax_device_driver {=0D=0Adiff --git a/dr=
ivers/dax/fsdev.c b/drivers/dax/fsdev.c=0D=0Anew file mode 100644=0D=0Ain=
dex 000000000000..8b5c6976ad17=0D=0A--- /dev/null=0D=0A+++ b/drivers/dax/=
fsdev.c=0D=0A@@ -0,0 +1,245 @@=0D=0A+// SPDX-License-Identifier: GPL-2.0=0D=
=0A+/* Copyright(c) 2026 Micron Technology, Inc. */=0D=0A+#include <linux=
/memremap.h>=0D=0A+#include <linux/pagemap.h>=0D=0A+#include <linux/modul=
e.h>=0D=0A+#include <linux/device.h>=0D=0A+#include <linux/cdev.h>=0D=0A+=
#include <linux/slab.h>=0D=0A+#include <linux/dax.h>=0D=0A+#include <linu=
x/uio.h>=0D=0A+#include <linux/fs.h>=0D=0A+#include <linux/mm.h>=0D=0A+#i=
nclude "dax-private.h"=0D=0A+#include "bus.h"=0D=0A+=0D=0A+/*=0D=0A+ * FS=
-DAX compatible devdax driver=0D=0A+ *=0D=0A+ * Unlike drivers/dax/device=
=2Ec which pre-initializes compound folios based=0D=0A+ * on device align=
ment (via vmemmap_shift), this driver leaves folios=0D=0A+ * uninitialize=
d similar to pmem. This allows fs-dax filesystems like famfs=0D=0A+ * to =
work without needing special handling for pre-initialized folios.=0D=0A+ =
*=0D=0A+ * Key differences from device.c:=0D=0A+ * - pgmap type is MEMORY=
_DEVICE_FS_DAX (not MEMORY_DEVICE_GENERIC)=0D=0A+ * - vmemmap_shift is NO=
T set (folios remain order-0)=0D=0A+ * - fs-dax can dynamically create co=
mpound folios as needed=0D=0A+ * - No mmap support - all access is throug=
h fs-dax/iomap=0D=0A+ */=0D=0A+=0D=0A+static void fsdev_cdev_del(void *cd=
ev)=0D=0A+{=0D=0A+=09cdev_del(cdev);=0D=0A+}=0D=0A+=0D=0A+static void fsd=
ev_kill(void *dev_dax)=0D=0A+{=0D=0A+=09kill_dev_dax(dev_dax);=0D=0A+}=0D=
=0A+=0D=0A+/*=0D=0A+ * Page map operations for FS-DAX mode=0D=0A+ * Simil=
ar to fsdax_pagemap_ops in drivers/nvdimm/pmem.c=0D=0A+ *=0D=0A+ * Note: =
folio_free callback is not needed for MEMORY_DEVICE_FS_DAX.=0D=0A+ * The =
core mm code in free_zone_device_folio() handles the wake_up_var()=0D=0A+=
 * directly for this memory type.=0D=0A+ */=0D=0A+static int fsdev_pagema=
p_memory_failure(struct dev_pagemap *pgmap,=0D=0A+=09=09unsigned long pfn=
, unsigned long nr_pages, int mf_flags)=0D=0A+{=0D=0A+=09struct dev_dax *=
dev_dax =3D pgmap->owner;=0D=0A+=09u64 offset =3D PFN_PHYS(pfn) - dev_dax=
->ranges[0].range.start;=0D=0A+=09u64 len =3D nr_pages << PAGE_SHIFT;=0D=0A=
+=0D=0A+=09return dax_holder_notify_failure(dev_dax->dax_dev, offset,=0D=0A=
+=09=09=09=09=09 len, mf_flags);=0D=0A+}=0D=0A+=0D=0A+static const struct=
 dev_pagemap_ops fsdev_pagemap_ops =3D {=0D=0A+=09.memory_failure=09=09=3D=
 fsdev_pagemap_memory_failure,=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A+ * Clear an=
y stale folio state from pages in the given range.=0D=0A+ * This is neces=
sary because device_dax pre-initializes compound folios=0D=0A+ * based on=
 vmemmap_shift, and that state may persist after driver unbind.=0D=0A+ * =
Since fsdev_dax uses MEMORY_DEVICE_FS_DAX without vmemmap_shift, fs-dax=0D=
=0A+ * expects to find clean order-0 folios that it can build into compou=
nd=0D=0A+ * folios on demand.=0D=0A+ *=0D=0A+ * At probe time, no filesys=
tem should be mounted yet, so all mappings=0D=0A+ * are stale and must be=
 cleared along with compound state.=0D=0A+ */=0D=0A+static void fsdev_cle=
ar_folio_state(struct dev_dax *dev_dax)=0D=0A+{=0D=0A+=09for (int i =3D 0=
; i < dev_dax->nr_range; i++) {=0D=0A+=09=09struct range *range =3D &dev_=
dax->ranges[i].range;=0D=0A+=09=09unsigned long pfn =3D PHYS_PFN(range->s=
tart);=0D=0A+=09=09unsigned long end_pfn =3D PHYS_PFN(range->end) + 1;=0D=
=0A+=0D=0A+=09=09while (pfn < end_pfn) {=0D=0A+=09=09=09struct folio *fol=
io =3D pfn_folio(pfn);=0D=0A+=09=09=09int order =3D dax_folio_reset_order=
(folio);=0D=0A+=0D=0A+=09=09=09pfn +=3D 1UL << order;=0D=0A+=09=09}=0D=0A=
+=09}=0D=0A+}=0D=0A+=0D=0A+static void fsdev_clear_folio_state_action(voi=
d *data)=0D=0A+{=0D=0A+=09fsdev_clear_folio_state(data);=0D=0A+}=0D=0A+=0D=
=0A+static int fsdev_open(struct inode *inode, struct file *filp)=0D=0A+{=
=0D=0A+=09struct dax_device *dax_dev =3D inode_dax(inode);=0D=0A+=09struc=
t dev_dax *dev_dax =3D dax_get_private(dax_dev);=0D=0A+=0D=0A+=09filp->pr=
ivate_data =3D dev_dax;=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+st=
atic int fsdev_release(struct inode *inode, struct file *filp)=0D=0A+{=0D=
=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static const struct file_operations=
 fsdev_fops =3D {=0D=0A+=09.llseek =3D noop_llseek,=0D=0A+=09.owner =3D T=
HIS_MODULE,=0D=0A+=09.open =3D fsdev_open,=0D=0A+=09.release =3D fsdev_re=
lease,=0D=0A+};=0D=0A+=0D=0A+static int fsdev_dax_probe(struct dev_dax *d=
ev_dax)=0D=0A+{=0D=0A+=09struct dax_device *dax_dev =3D dev_dax->dax_dev;=
=0D=0A+=09struct device *dev =3D &dev_dax->dev;=0D=0A+=09struct dev_pagem=
ap *pgmap;=0D=0A+=09struct inode *inode;=0D=0A+=09struct cdev *cdev;=0D=0A=
+=09void *addr;=0D=0A+=09int rc, i;=0D=0A+=0D=0A+=09if (static_dev_dax(de=
v_dax)) {=0D=0A+=09=09if (dev_dax->nr_range > 1) {=0D=0A+=09=09=09dev_war=
n(dev, "static pgmap / multi-range device conflict\n");=0D=0A+=09=09=09re=
turn -EINVAL;=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09pgmap =3D dev_dax->pgmap;=0D=
=0A+=09} else {=0D=0A+=09=09size_t pgmap_size;=0D=0A+=0D=0A+=09=09if (dev=
_dax->pgmap) {=0D=0A+=09=09=09dev_warn(dev, "dynamic-dax with pre-populat=
ed page map\n");=0D=0A+=09=09=09return -EINVAL;=0D=0A+=09=09}=0D=0A+=0D=0A=
+=09=09pgmap_size =3D struct_size(pgmap, ranges, dev_dax->nr_range - 1);=0D=
=0A+=09=09pgmap =3D devm_kzalloc(dev, pgmap_size, GFP_KERNEL);=0D=0A+=09=09=
if (!pgmap)=0D=0A+=09=09=09return -ENOMEM;=0D=0A+=0D=0A+=09=09pgmap->nr_r=
ange =3D dev_dax->nr_range;=0D=0A+=09=09dev_dax->pgmap =3D pgmap;=0D=0A+=0D=
=0A+=09=09for (i =3D 0; i < dev_dax->nr_range; i++) {=0D=0A+=09=09=09stru=
ct range *range =3D &dev_dax->ranges[i].range;=0D=0A+=0D=0A+=09=09=09pgma=
p->ranges[i] =3D *range;=0D=0A+=09=09}=0D=0A+=09}=0D=0A+=0D=0A+=09for (i =
=3D 0; i < dev_dax->nr_range; i++) {=0D=0A+=09=09struct range *range =3D =
&dev_dax->ranges[i].range;=0D=0A+=0D=0A+=09=09if (!devm_request_mem_regio=
n(dev, range->start,=0D=0A+=09=09=09=09=09range_len(range), dev_name(dev)=
)) {=0D=0A+=09=09=09dev_warn(dev, "mapping%d: %#llx-%#llx could not reser=
ve range\n",=0D=0A+=09=09=09=09 i, range->start, range->end);=0D=0A+=09=09=
=09return -EBUSY;=0D=0A+=09=09}=0D=0A+=09}=0D=0A+=0D=0A+=09/*=0D=0A+=09 *=
 Use MEMORY_DEVICE_FS_DAX without setting vmemmap_shift, leaving=0D=0A+=09=
 * folios at order-0. Unlike device.c (MEMORY_DEVICE_GENERIC), this=0D=0A=
+=09 * lets fs-dax dynamically build compound folios as needed, similar=0D=
=0A+=09 * to pmem behavior.=0D=0A+=09 */=0D=0A+=09pgmap->type =3D MEMORY_=
DEVICE_FS_DAX;=0D=0A+=09pgmap->ops =3D &fsdev_pagemap_ops;=0D=0A+=09pgmap=
->owner =3D dev_dax;=0D=0A+=0D=0A+=09addr =3D devm_memremap_pages(dev, pg=
map);=0D=0A+=09if (IS_ERR(addr))=0D=0A+=09=09return PTR_ERR(addr);=0D=0A+=
=0D=0A+=09/*=0D=0A+=09 * Clear any stale compound folio state left over f=
rom a previous=0D=0A+=09 * driver (e.g., device_dax with vmemmap_shift). =
Also register this=0D=0A+=09 * as a devm action so folio state is cleared=
 on unbind, ensuring=0D=0A+=09 * clean pages for subsequent drivers (e.g.=
, kmem for system-ram).=0D=0A+=09 */=0D=0A+=09fsdev_clear_folio_state(dev=
_dax);=0D=0A+=09rc =3D devm_add_action_or_reset(dev, fsdev_clear_folio_st=
ate_action,=0D=0A+=09=09=09=09      dev_dax);=0D=0A+=09if (rc)=0D=0A+=09=09=
return rc;=0D=0A+=0D=0A+=09/* Detect whether the data is at a non-zero of=
fset into the memory */=0D=0A+=09if (pgmap->range.start !=3D dev_dax->ran=
ges[0].range.start) {=0D=0A+=09=09u64 phys =3D dev_dax->ranges[0].range.s=
tart;=0D=0A+=09=09u64 pgmap_phys =3D dev_dax->pgmap[0].range.start;=0D=0A=
+=09=09u64 data_offset =3D 0;=0D=0A+=0D=0A+=09=09if (!WARN_ON(pgmap_phys =
> phys))=0D=0A+=09=09=09data_offset =3D phys - pgmap_phys;=0D=0A+=0D=0A+=09=
=09pr_debug("%s: offset detected phys=3D%llx pgmap_phys=3D%llx offset=3D%=
llx\n",=0D=0A+=09=09       __func__, phys, pgmap_phys, data_offset);=0D=0A=
+=09}=0D=0A+=0D=0A+=09inode =3D dax_inode(dax_dev);=0D=0A+=09cdev =3D ino=
de->i_cdev;=0D=0A+=09cdev_init(cdev, &fsdev_fops);=0D=0A+=09cdev->owner =3D=
 dev->driver->owner;=0D=0A+=09cdev_set_parent(cdev, &dev->kobj);=0D=0A+=09=
rc =3D cdev_add(cdev, dev->devt, 1);=0D=0A+=09if (rc)=0D=0A+=09=09return =
rc;=0D=0A+=0D=0A+=09rc =3D devm_add_action_or_reset(dev, fsdev_cdev_del, =
cdev);=0D=0A+=09if (rc)=0D=0A+=09=09return rc;=0D=0A+=0D=0A+=09run_dax(da=
x_dev);=0D=0A+=09return devm_add_action_or_reset(dev, fsdev_kill, dev_dax=
);=0D=0A+}=0D=0A+=0D=0A+static struct dax_device_driver fsdev_dax_driver =
=3D {=0D=0A+=09.probe =3D fsdev_dax_probe,=0D=0A+=09.type =3D DAXDRV_FSDE=
V_TYPE,=0D=0A+};=0D=0A+=0D=0A+static int __init dax_init(void)=0D=0A+{=0D=
=0A+=09return dax_driver_register(&fsdev_dax_driver);=0D=0A+}=0D=0A+=0D=0A=
+static void __exit dax_exit(void)=0D=0A+{=0D=0A+=09dax_driver_unregister=
(&fsdev_dax_driver);=0D=0A+}=0D=0A+=0D=0A+MODULE_AUTHOR("John Groves");=0D=
=0A+MODULE_DESCRIPTION("FS-DAX Device: fs-dax compatible devdax driver");=
=0D=0A+MODULE_LICENSE("GPL");=0D=0A+module_init(dax_init);=0D=0A+module_e=
xit(dax_exit);=0D=0A+MODULE_ALIAS_DAX_DEVICE(0);=0D=0Adiff --git a/fs/dax=
=2Ec b/fs/dax.c=0D=0Aindex 87bed6de920d..cb5c87e43bc3 100644=0D=0A--- a/f=
s/dax.c=0D=0A+++ b/fs/dax.c=0D=0A@@ -429,6 +429,7 @@ int dax_folio_reset_=
order(struct folio *folio)=0D=0A=20=0D=0A =09return order;=0D=0A }=0D=0A+=
EXPORT_SYMBOL_GPL(dax_folio_reset_order);=0D=0A=20=0D=0A static inline un=
signed long dax_folio_put(struct folio *folio)=0D=0A {=0D=0A--=20=0D=0A2.=
53.0=0D=0A=0D=0A
