Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 20A878032B
 for <linux-nvdimm@lists.01.org>; Sun,  5 Mar 2017 23:06:53 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Mon,  6 Mar 2017 00:04:31 -0700
Message-Id: <1488783873-2614-16-git-send-email-logang@deltatee.com>
In-Reply-To: <1488783873-2614-1-git-send-email-logang@deltatee.com>
References: <1488783873-2614-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v3 15/16] scsi: utilize new cdev_device_add helper function
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

This driver did not set kobj.parent so it likely suffered from
a potential use after free race if the user unregistered the
device while it was in use.

This was not so straightforward a conversion but I think this patch
cleans up its probe's error path significantly.

This patch adds device_initialize, which is required for
cdev_device_add. Then it switches to put_device instead of kfree as
recommended by device_initialize's documentation. This removes a lot
from the error path which was already in __remove.
A couple things needed to be re-ordered to be entirely correct, though.
ida_remove is also moved out of __remove and into unregister to
simplify things and follow the pattern other devices are using.

This also drop an extra unnecessary get_device/put_device in the code.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/scsi/osd/osd_uld.c | 56 +++++++++++++++++-----------------------------
 1 file changed, 20 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index e0ce5d2..4101c31 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -400,9 +400,6 @@ static void __remove(struct device *dev)
 
 	kfree(oud->odi.osdname);
 
-	if (oud->cdev.owner)
-		cdev_del(&oud->cdev);
-
 	osd_dev_fini(&oud->od);
 	scsi_device_put(scsi_device);
 
@@ -411,7 +408,6 @@ static void __remove(struct device *dev)
 
 	if (oud->disk)
 		put_disk(oud->disk);
-	ida_remove(&osd_minor_ida, oud->minor);
 
 	kfree(oud);
 }
@@ -446,8 +442,20 @@ static int osd_probe(struct device *dev)
 	if (NULL == oud)
 		goto err_retract_minor;
 
+	/* class device member */
+	device_initialize(&oud->class_dev);
 	dev_set_drvdata(dev, oud);
 	oud->minor = minor;
+	oud->class_dev.devt = MKDEV(SCSI_OSD_MAJOR, oud->minor);
+	oud->class_dev.class = &osd_uld_class;
+	oud->class_dev.parent = dev;
+	oud->class_dev.release = __remove;
+
+	/* hold one more reference to the scsi_device that will get released
+	 * in __release, in case a logout is happening while fs is mounted
+	 */
+	scsi_device_get(scsi_device);
+	osd_dev_init(&oud->od, scsi_device);
 
 	/* allocate a disk and set it up */
 	/* FIXME: do we need this since sg has already done that */
@@ -461,59 +469,34 @@ static int osd_probe(struct device *dev)
 	sprintf(disk->disk_name, "osd%d", oud->minor);
 	oud->disk = disk;
 
-	/* hold one more reference to the scsi_device that will get released
-	 * in __release, in case a logout is happening while fs is mounted
-	 */
-	scsi_device_get(scsi_device);
-	osd_dev_init(&oud->od, scsi_device);
-
 	/* Detect the OSD Version */
 	error = __detect_osd(oud);
 	if (error) {
 		OSD_ERR("osd detection failed, non-compatible OSD device\n");
-		goto err_put_disk;
+		goto err_free_osd;
 	}
 
 	/* init the char-device for communication with user-mode */
 	cdev_init(&oud->cdev, &osd_fops);
 	oud->cdev.owner = THIS_MODULE;
-	error = cdev_add(&oud->cdev,
-			 MKDEV(SCSI_OSD_MAJOR, oud->minor), 1);
-	if (error) {
-		OSD_ERR("cdev_add failed\n");
-		goto err_put_disk;
-	}
 
-	/* class device member */
-	oud->class_dev.devt = oud->cdev.dev;
-	oud->class_dev.class = &osd_uld_class;
-	oud->class_dev.parent = dev;
-	oud->class_dev.release = __remove;
 	error = dev_set_name(&oud->class_dev, "%s", disk->disk_name);
 	if (error) {
 		OSD_ERR("dev_set_name failed => %d\n", error);
-		goto err_put_cdev;
+		goto err_free_osd;
 	}
 
-	error = device_register(&oud->class_dev);
+	error = cdev_device_add(&oud->cdev, &oud->class_dev);
 	if (error) {
 		OSD_ERR("device_register failed => %d\n", error);
-		goto err_put_cdev;
+		goto err_free_osd;
 	}
 
-	get_device(&oud->class_dev);
-
 	OSD_INFO("osd_probe %s\n", disk->disk_name);
 	return 0;
 
-err_put_cdev:
-	cdev_del(&oud->cdev);
-err_put_disk:
-	scsi_device_put(scsi_device);
-	put_disk(disk);
 err_free_osd:
-	dev_set_drvdata(dev, NULL);
-	kfree(oud);
+	put_device(&oud->class_dev);
 err_retract_minor:
 	ida_remove(&osd_minor_ida, minor);
 	return error;
@@ -530,9 +513,10 @@ static int osd_remove(struct device *dev)
 			scsi_device);
 	}
 
-	device_unregister(&oud->class_dev);
-
+	cdev_device_del(&oud->cdev, &oud->class_dev);
+	ida_remove(&osd_minor_ida, oud->minor);
 	put_device(&oud->class_dev);
+
 	return 0;
 }
 
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
