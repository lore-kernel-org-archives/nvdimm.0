Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6BF1A820D9
 for <linux-nvdimm@lists.01.org>; Sat, 25 Feb 2017 22:42:25 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Sat, 25 Feb 2017 23:38:08 -0700
Message-Id: <1488091097-12328-8-git-send-email-logang@deltatee.com>
In-Reply-To: <1488091097-12328-1-git-send-email-logang@deltatee.com>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 07/16] platform/chrome: cros_ec_dev - utilize new
 cdev_device_add helper function
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

Replace the open coded registration of the cdev and dev with the
new device_add_cdev() helper. The helper replaces a common pattern by
taking the proper reference against the parent device and adding both
the cdev and the device.

At the same time we cleanup the error path through device_probe
function: we use put_device instead of kfree directly as recommended
by the device_initialize documentation.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/platform/chrome/cros_ec_dev.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_dev.c b/drivers/platform/chrome/cros_ec_dev.c
index 47268ec..58f67d6 100644
--- a/drivers/platform/chrome/cros_ec_dev.c
+++ b/drivers/platform/chrome/cros_ec_dev.c
@@ -388,7 +388,6 @@ static int ec_device_probe(struct platform_device *pdev)
 	int retval = -ENOMEM;
 	struct device *dev = &pdev->dev;
 	struct cros_ec_platform *ec_platform = dev_get_platdata(dev);
-	dev_t devno = MKDEV(ec_major, pdev->id);
 	struct cros_ec_dev *ec = kzalloc(sizeof(*ec), GFP_KERNEL);
 
 	if (!ec)
@@ -404,23 +403,11 @@ static int ec_device_probe(struct platform_device *pdev)
 	cdev_init(&ec->cdev, &fops);
 
 	/*
-	 * Add the character device
-	 * Link cdev to the class device to be sure device is not used
-	 * before unbinding it.
-	 */
-	ec->cdev.kobj.parent = &ec->class_dev.kobj;
-	retval = cdev_add(&ec->cdev, devno, 1);
-	if (retval) {
-		dev_err(dev, ": failed to add character device\n");
-		goto cdev_add_failed;
-	}
-
-	/*
 	 * Add the class device
 	 * Link to the character device for creating the /dev entry
 	 * in devtmpfs.
 	 */
-	ec->class_dev.devt = ec->cdev.dev;
+	ec->class_dev.devt = MKDEV(ec_major, pdev->id);
 	ec->class_dev.class = &cros_class;
 	ec->class_dev.parent = dev;
 	ec->class_dev.release = __remove;
@@ -428,13 +415,13 @@ static int ec_device_probe(struct platform_device *pdev)
 	retval = dev_set_name(&ec->class_dev, "%s", ec_platform->ec_name);
 	if (retval) {
 		dev_err(dev, "dev_set_name failed => %d\n", retval);
-		goto set_named_failed;
+		goto failed;
 	}
 
-	retval = device_add(&ec->class_dev);
+	retval = cdev_device_add(&ec->cdev, &ec->class_dev);
 	if (retval) {
-		dev_err(dev, "device_register failed => %d\n", retval);
-		goto dev_reg_failed;
+		dev_err(dev, "cdev_device_add failed => %d\n", retval);
+		goto failed;
 	}
 
 	/* check whether this EC is a sensor hub. */
@@ -443,12 +430,8 @@ static int ec_device_probe(struct platform_device *pdev)
 
 	return 0;
 
-dev_reg_failed:
-set_named_failed:
-	dev_set_drvdata(dev, NULL);
-	cdev_del(&ec->cdev);
-cdev_add_failed:
-	kfree(ec);
+failed:
+	put_device(&ec->class_dev);
 	return retval;
 }
 
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
