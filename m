Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 733498210A
 for <linux-nvdimm@lists.01.org>; Sat, 25 Feb 2017 22:40:42 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Sat, 25 Feb 2017 23:38:13 -0700
Message-Id: <1488091097-12328-13-git-send-email-logang@deltatee.com>
In-Reply-To: <1488091097-12328-1-git-send-email-logang@deltatee.com>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 12/16] mtd: utilize new cdev_device_add helper function
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Linus Walleij <linus.walleij@linaro.org>, Alexandre Courbot <gnurou@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Olof Johansson <olof@lixom.net>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Haggai Eran <haggaie@mellanox.com>, Parav Pandit <pandit.parav@gmail.com>, Leon Romanovsky <leon@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, Hans Verkuil <hans.verkuil@cisco.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Artem Bityutskiy <dedekind1@gmail.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Marek Vasut <marek.vasut@gmail.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alexandre.bounine@idt.com>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Lorenzo Stoakes <lstoakes@gmail.com>, Vladimir Zapolskiy <vz@mleia.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Boaz Harrosh <ooo@electrozaur.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Bates <stephen.bates@microsemi.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-scsi@vger.kernel.org, rtc-linux@googlegroups.com, linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-mtd@lists.infradead.org, linux-input@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This is not as straightforward a conversion as the others
in this series. These drivers did not originally make use of
kobj.parent so they likely suffered from a use after free bug if
someone unregistered the devices while they are being used.

In order to make the conversions, switch from device_register
to device_initialize / cdev_device_add.

In build.c, this patch unwinds a complicated mess of extra
get_device/put_devices and reference tracking by moving device_initialize
early in the attach process. Then it always uses put_device and instead of
using device_unregister and extra get_devices everywhere we just use
cdev_device_del and one put_device once everything is completely done.
This simplifies things dramatically and makes it easier to reason about.

In vmt.c, the patch pushes device initialization up to the beginning of the
device creation and then that function only needs to use put_device
in the error path which simplifies things a good deal.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/mtd/ubi/build.c | 91 +++++++++----------------------------------------
 drivers/mtd/ubi/vmt.c   | 49 +++++++++-----------------
 2 files changed, 33 insertions(+), 107 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 85d54f3..c0b3a37 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -421,41 +421,6 @@ static void dev_release(struct device *dev)
 }
 
 /**
- * ubi_sysfs_init - initialize sysfs for an UBI device.
- * @ubi: UBI device description object
- * @ref: set to %1 on exit in case of failure if a reference to @ubi->dev was
- *       taken
- *
- * This function returns zero in case of success and a negative error code in
- * case of failure.
- */
-static int ubi_sysfs_init(struct ubi_device *ubi, int *ref)
-{
-	int err;
-
-	ubi->dev.release = dev_release;
-	ubi->dev.devt = ubi->cdev.dev;
-	ubi->dev.class = &ubi_class;
-	ubi->dev.groups = ubi_dev_groups;
-	dev_set_name(&ubi->dev, UBI_NAME_STR"%d", ubi->ubi_num);
-	err = device_register(&ubi->dev);
-	if (err)
-		return err;
-
-	*ref = 1;
-	return 0;
-}
-
-/**
- * ubi_sysfs_close - close sysfs for an UBI device.
- * @ubi: UBI device description object
- */
-static void ubi_sysfs_close(struct ubi_device *ubi)
-{
-	device_unregister(&ubi->dev);
-}
-
-/**
  * kill_volumes - destroy all user volumes.
  * @ubi: UBI device description object
  */
@@ -471,27 +436,19 @@ static void kill_volumes(struct ubi_device *ubi)
 /**
  * uif_init - initialize user interfaces for an UBI device.
  * @ubi: UBI device description object
- * @ref: set to %1 on exit in case of failure if a reference to @ubi->dev was
- *       taken, otherwise set to %0
  *
  * This function initializes various user interfaces for an UBI device. If the
  * initialization fails at an early stage, this function frees all the
- * resources it allocated, returns an error, and @ref is set to %0. However,
- * if the initialization fails after the UBI device was registered in the
- * driver core subsystem, this function takes a reference to @ubi->dev, because
- * otherwise the release function ('dev_release()') would free whole @ubi
- * object. The @ref argument is set to %1 in this case. The caller has to put
- * this reference.
+ * resources it allocated, returns an error.
  *
  * This function returns zero in case of success and a negative error code in
  * case of failure.
  */
-static int uif_init(struct ubi_device *ubi, int *ref)
+static int uif_init(struct ubi_device *ubi)
 {
 	int i, err;
 	dev_t dev;
 
-	*ref = 0;
 	sprintf(ubi->ubi_name, UBI_NAME_STR "%d", ubi->ubi_num);
 
 	/*
@@ -508,20 +465,17 @@ static int uif_init(struct ubi_device *ubi, int *ref)
 		return err;
 	}
 
+	ubi->dev.devt = dev;
+
 	ubi_assert(MINOR(dev) == 0);
 	cdev_init(&ubi->cdev, &ubi_cdev_operations);
 	dbg_gen("%s major is %u", ubi->ubi_name, MAJOR(dev));
 	ubi->cdev.owner = THIS_MODULE;
 
-	err = cdev_add(&ubi->cdev, dev, 1);
-	if (err) {
-		ubi_err(ubi, "cannot add character device");
-		goto out_unreg;
-	}
-
-	err = ubi_sysfs_init(ubi, ref);
+	dev_set_name(&ubi->dev, UBI_NAME_STR "%d", ubi->ubi_num);
+	err = cdev_device_add(&ubi->cdev, &ubi->dev);
 	if (err)
-		goto out_sysfs;
+		goto out_unreg;
 
 	for (i = 0; i < ubi->vtbl_slots; i++)
 		if (ubi->volumes[i]) {
@@ -536,11 +490,7 @@ static int uif_init(struct ubi_device *ubi, int *ref)
 
 out_volumes:
 	kill_volumes(ubi);
-out_sysfs:
-	if (*ref)
-		get_device(&ubi->dev);
-	ubi_sysfs_close(ubi);
-	cdev_del(&ubi->cdev);
+	cdev_device_del(&ubi->cdev, &ubi->dev);
 out_unreg:
 	unregister_chrdev_region(ubi->cdev.dev, ubi->vtbl_slots + 1);
 	ubi_err(ubi, "cannot initialize UBI %s, error %d",
@@ -559,8 +509,7 @@ static int uif_init(struct ubi_device *ubi, int *ref)
 static void uif_close(struct ubi_device *ubi)
 {
 	kill_volumes(ubi);
-	ubi_sysfs_close(ubi);
-	cdev_del(&ubi->cdev);
+	cdev_device_del(&ubi->cdev, &ubi->dev);
 	unregister_chrdev_region(ubi->cdev.dev, ubi->vtbl_slots + 1);
 }
 
@@ -857,7 +806,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 		       int vid_hdr_offset, int max_beb_per1024)
 {
 	struct ubi_device *ubi;
-	int i, err, ref = 0;
+	int i, err;
 
 	if (max_beb_per1024 < 0 || max_beb_per1024 > MAX_MTD_UBI_BEB_LIMIT)
 		return -EINVAL;
@@ -919,6 +868,11 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	if (!ubi)
 		return -ENOMEM;
 
+	device_initialize(&ubi->dev);
+	ubi->dev.release = dev_release;
+	ubi->dev.class = &ubi_class;
+	ubi->dev.groups = ubi_dev_groups;
+
 	ubi->mtd = mtd;
 	ubi->ubi_num = ubi_num;
 	ubi->vid_hdr_offset = vid_hdr_offset;
@@ -995,7 +949,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	/* Make device "available" before it becomes accessible via sysfs */
 	ubi_devices[ubi_num] = ubi;
 
-	err = uif_init(ubi, &ref);
+	err = uif_init(ubi);
 	if (err)
 		goto out_detach;
 
@@ -1045,8 +999,6 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 out_debugfs:
 	ubi_debugfs_exit_dev(ubi);
 out_uif:
-	get_device(&ubi->dev);
-	ubi_assert(ref);
 	uif_close(ubi);
 out_detach:
 	ubi_devices[ubi_num] = NULL;
@@ -1056,10 +1008,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 out_free:
 	vfree(ubi->peb_buf);
 	vfree(ubi->fm_buf);
-	if (ref)
-		put_device(&ubi->dev);
-	else
-		kfree(ubi);
+	put_device(&ubi->dev);
 	return err;
 }
 
@@ -1120,12 +1069,6 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 	if (ubi->bgt_thread)
 		kthread_stop(ubi->bgt_thread);
 
-	/*
-	 * Get a reference to the device in order to prevent 'dev_release()'
-	 * from freeing the @ubi object.
-	 */
-	get_device(&ubi->dev);
-
 	ubi_debugfs_exit_dev(ubi);
 	uif_close(ubi);
 
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 7ac78c1..85237cf 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -155,11 +155,10 @@ static void vol_release(struct device *dev)
  */
 int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 {
-	int i, err, vol_id = req->vol_id, do_free = 1;
+	int i, err, vol_id = req->vol_id;
 	struct ubi_volume *vol;
 	struct ubi_vtbl_record vtbl_rec;
 	struct ubi_eba_table *eba_tbl = NULL;
-	dev_t dev;
 
 	if (ubi->ro_mode)
 		return -EROFS;
@@ -168,6 +167,12 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 	if (!vol)
 		return -ENOMEM;
 
+	device_initialize(&vol->dev);
+	vol->dev.release = vol_release;
+	vol->dev.parent = &ubi->dev;
+	vol->dev.class = &ubi_class;
+	vol->dev.groups = volume_dev_groups;
+
 	spin_lock(&ubi->volumes_lock);
 	if (vol_id == UBI_VOL_NUM_AUTO) {
 		/* Find unused volume ID */
@@ -268,24 +273,13 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 	/* Register character device for the volume */
 	cdev_init(&vol->cdev, &ubi_vol_cdev_operations);
 	vol->cdev.owner = THIS_MODULE;
-	dev = MKDEV(MAJOR(ubi->cdev.dev), vol_id + 1);
-	err = cdev_add(&vol->cdev, dev, 1);
-	if (err) {
-		ubi_err(ubi, "cannot add character device");
-		goto out_mapping;
-	}
-
-	vol->dev.release = vol_release;
-	vol->dev.parent = &ubi->dev;
-	vol->dev.devt = dev;
-	vol->dev.class = &ubi_class;
-	vol->dev.groups = volume_dev_groups;
 
+	vol->dev.devt = MKDEV(MAJOR(ubi->cdev.dev), vol_id + 1);
 	dev_set_name(&vol->dev, "%s_%d", ubi->ubi_name, vol->vol_id);
-	err = device_register(&vol->dev);
+	err = cdev_device_add(&vol->cdev, &vol->dev);
 	if (err) {
-		ubi_err(ubi, "cannot register device");
-		goto out_cdev;
+		ubi_err(ubi, "cannot add device");
+		goto out_mapping;
 	}
 
 	/* Fill volume table record */
@@ -318,28 +312,17 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 	 * We have registered our device, we should not free the volume
 	 * description object in this function in case of an error - it is
 	 * freed by the release function.
-	 *
-	 * Get device reference to prevent the release function from being
-	 * called just after sysfs has been closed.
 	 */
-	do_free = 0;
-	get_device(&vol->dev);
-	device_unregister(&vol->dev);
-out_cdev:
-	cdev_del(&vol->cdev);
+	cdev_device_del(&vol->cdev, &vol->dev);
 out_mapping:
-	if (do_free)
-		ubi_eba_destroy_table(eba_tbl);
+	ubi_eba_destroy_table(eba_tbl);
 out_acc:
 	spin_lock(&ubi->volumes_lock);
 	ubi->rsvd_pebs -= vol->reserved_pebs;
 	ubi->avail_pebs += vol->reserved_pebs;
 out_unlock:
 	spin_unlock(&ubi->volumes_lock);
-	if (do_free)
-		kfree(vol);
-	else
-		put_device(&vol->dev);
+	put_device(&vol->dev);
 	ubi_err(ubi, "cannot create volume %d, error %d", vol_id, err);
 	return err;
 }
@@ -391,8 +374,8 @@ int ubi_remove_volume(struct ubi_volume_desc *desc, int no_vtbl)
 			goto out_err;
 	}
 
-	cdev_del(&vol->cdev);
-	device_unregister(&vol->dev);
+	cdev_device_del(&vol->cdev, &vol->dev);
+	put_device(&vol->dev);
 
 	spin_lock(&ubi->volumes_lock);
 	ubi->rsvd_pebs -= reserved_pebs;
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
