Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 40CA180331
 for <linux-nvdimm@lists.01.org>; Fri, 17 Mar 2017 11:50:27 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Fri, 17 Mar 2017 12:48:14 -0600
Message-Id: <1489776503-3151-8-git-send-email-logang@deltatee.com>
In-Reply-To: <1489776503-3151-1-git-send-email-logang@deltatee.com>
References: <1489776503-3151-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v5 07/16] platform/chrome: cros_ec_dev - utilize new
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
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Hans Verkuil <hans.verkuil@cisco.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Johannes Thumshirn <jthumshirn@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Linus Walleij <linus.walleij@linaro.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Marek Vasut <marek.vasut@gmail.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>
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
index 6f09da4..6aa120c 100644
--- a/drivers/platform/chrome/cros_ec_dev.c
+++ b/drivers/platform/chrome/cros_ec_dev.c
@@ -391,7 +391,6 @@ static int ec_device_probe(struct platform_device *pdev)
 	int retval = -ENOMEM;
 	struct device *dev = &pdev->dev;
 	struct cros_ec_platform *ec_platform = dev_get_platdata(dev);
-	dev_t devno = MKDEV(ec_major, pdev->id);
 	struct cros_ec_dev *ec = kzalloc(sizeof(*ec), GFP_KERNEL);
 
 	if (!ec)
@@ -407,23 +406,11 @@ static int ec_device_probe(struct platform_device *pdev)
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
@@ -431,13 +418,13 @@ static int ec_device_probe(struct platform_device *pdev)
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
@@ -446,12 +433,8 @@ static int ec_device_probe(struct platform_device *pdev)
 
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
