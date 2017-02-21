Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 134428220C
 for <linux-nvdimm@lists.01.org>; Mon, 20 Feb 2017 21:03:07 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Mon, 20 Feb 2017 22:00:49 -0700
Message-Id: <1487653253-11497-11-git-send-email-logang@deltatee.com>
In-Reply-To: <1487653253-11497-1-git-send-email-logang@deltatee.com>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 10/14] mtd: utilize new device_add_cdev helper function
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
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Linus Walleij <linus.walleij@linaro.org>, Alexandre Courbot <gnurou@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Olof Johansson <olof@lixom.net>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Haggai Eran <haggaie@mellanox.com>, Parav Pandit <pandit.parav@gmail.com>, Leon Romanovsky <leon@kernel.org>, Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, Hans Verkuil <hans.verkuil@cisco.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Artem Bityutskiy <dedekind1@gmail.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Marek Vasut <marek.vasut@gmail.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alexandre.bounine@idt.com>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Lorenzo Stoakes <lstoakes@gmail.com>, Vladimir Zapolskiy <vz@mleia.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Boaz Harrosh <ooo@electrozaur.com>, Benny Halevy <bhalevy@primarydata.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Bates <stephen.bates@microsemi.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-scsi@vger.kernel.org, rtc-linux@googlegroups.com, linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-input@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Note: neither of the cdev instances in the mtd tree originally
set the kobject parent. Thus, I'm reasonably confident that
both these instances would have suffered from a minor use after
free bug if the cdevs were open when the backing device was released.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/mtd/ubi/build.c |  8 +++++---
 drivers/mtd/ubi/vmt.c   | 10 +++++-----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 85d54f3..a509f15 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -434,11 +434,10 @@ static int ubi_sysfs_init(struct ubi_device *ubi, int *ref)
 	int err;
 
 	ubi->dev.release = dev_release;
-	ubi->dev.devt = ubi->cdev.dev;
 	ubi->dev.class = &ubi_class;
 	ubi->dev.groups = ubi_dev_groups;
 	dev_set_name(&ubi->dev, UBI_NAME_STR"%d", ubi->ubi_num);
-	err = device_register(&ubi->dev);
+	err = device_add(&ubi->dev);
 	if (err)
 		return err;
 
@@ -508,12 +507,15 @@ static int uif_init(struct ubi_device *ubi, int *ref)
 		return err;
 	}
 
+	device_initialize(&ubi->dev);
+	ubi->dev.devt = dev;
+
 	ubi_assert(MINOR(dev) == 0);
 	cdev_init(&ubi->cdev, &ubi_cdev_operations);
 	dbg_gen("%s major is %u", ubi->ubi_name, MAJOR(dev));
 	ubi->cdev.owner = THIS_MODULE;
 
-	err = cdev_add(&ubi->cdev, dev, 1);
+	err = device_add_cdev(&ubi->dev, &ubi->cdev);
 	if (err) {
 		ubi_err(ubi, "cannot add character device");
 		goto out_unreg;
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 7ac78c1..df84ba7 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -159,7 +159,6 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 	struct ubi_volume *vol;
 	struct ubi_vtbl_record vtbl_rec;
 	struct ubi_eba_table *eba_tbl = NULL;
-	dev_t dev;
 
 	if (ubi->ro_mode)
 		return -EROFS;
@@ -265,11 +264,13 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 			vol->last_eb_bytes = vol->usable_leb_size;
 	}
 
+	device_initialize(&vol->dev);
+	vol->dev.devt = MKDEV(MAJOR(ubi->cdev.dev), vol_id + 1);
+
 	/* Register character device for the volume */
 	cdev_init(&vol->cdev, &ubi_vol_cdev_operations);
 	vol->cdev.owner = THIS_MODULE;
-	dev = MKDEV(MAJOR(ubi->cdev.dev), vol_id + 1);
-	err = cdev_add(&vol->cdev, dev, 1);
+	err = device_add_cdev(&vol->dev, &vol->cdev);
 	if (err) {
 		ubi_err(ubi, "cannot add character device");
 		goto out_mapping;
@@ -277,12 +278,11 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 
 	vol->dev.release = vol_release;
 	vol->dev.parent = &ubi->dev;
-	vol->dev.devt = dev;
 	vol->dev.class = &ubi_class;
 	vol->dev.groups = volume_dev_groups;
 
 	dev_set_name(&vol->dev, "%s_%d", ubi->ubi_name, vol->vol_id);
-	err = device_register(&vol->dev);
+	err = device_add(&vol->dev);
 	if (err) {
 		ubi_err(ubi, "cannot register device");
 		goto out_cdev;
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
