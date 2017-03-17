Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC80B80331
 for <linux-nvdimm@lists.01.org>; Fri, 17 Mar 2017 11:49:54 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Fri, 17 Mar 2017 12:48:20 -0600
Message-Id: <1489776503-3151-14-git-send-email-logang@deltatee.com>
In-Reply-To: <1489776503-3151-1-git-send-email-logang@deltatee.com>
References: <1489776503-3151-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v5 13/16] rapidio: utilize new cdev_device_add helper function
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

This driver did not originally set kobj.parent so it likely had
potential a use after free bug which this patch fixes.

We convert from device_register to device_initialize/cdev_device_add.
While we are at it we use put_device instead of kfree (as recommended
by the device_initialize documentation). We also remove an unnecessary
extra get_device from the code.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index 50b617a..5beb0c3 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2444,31 +2444,25 @@ static struct mport_dev *mport_cdev_add(struct rio_mport *mport)
 	mutex_init(&md->buf_mutex);
 	mutex_init(&md->file_mutex);
 	INIT_LIST_HEAD(&md->file_list);
-	cdev_init(&md->cdev, &mport_fops);
-	md->cdev.owner = THIS_MODULE;
-	ret = cdev_add(&md->cdev, MKDEV(MAJOR(dev_number), mport->id), 1);
-	if (ret < 0) {
-		kfree(md);
-		rmcd_error("Unable to register a device, err=%d", ret);
-		return NULL;
-	}
 
-	md->dev.devt = md->cdev.dev;
+	device_initialize(&md->dev);
+	md->dev.devt = MKDEV(MAJOR(dev_number), mport->id);
 	md->dev.class = dev_class;
 	md->dev.parent = &mport->dev;
 	md->dev.release = mport_device_release;
 	dev_set_name(&md->dev, DEV_NAME "%d", mport->id);
 	atomic_set(&md->active, 1);
 
-	ret = device_register(&md->dev);
+	cdev_init(&md->cdev, &mport_fops);
+	md->cdev.owner = THIS_MODULE;
+
+	ret = cdev_device_add(&md->cdev, &md->dev);
 	if (ret) {
 		rmcd_error("Failed to register mport %d (err=%d)",
 		       mport->id, ret);
 		goto err_cdev;
 	}
 
-	get_device(&md->dev);
-
 	INIT_LIST_HEAD(&md->doorbells);
 	spin_lock_init(&md->db_lock);
 	INIT_LIST_HEAD(&md->portwrites);
@@ -2513,8 +2507,7 @@ static struct mport_dev *mport_cdev_add(struct rio_mport *mport)
 	return md;
 
 err_cdev:
-	cdev_del(&md->cdev);
-	kfree(md);
+	put_device(&md->dev);
 	return NULL;
 }
 
@@ -2578,7 +2571,7 @@ static void mport_cdev_remove(struct mport_dev *md)
 	atomic_set(&md->active, 0);
 	mport_cdev_terminate_dma(md);
 	rio_del_mport_pw_handler(md->mport, md, rio_mport_pw_handler);
-	cdev_del(&(md->cdev));
+	cdev_device_del(&md->cdev, &md->dev);
 	mport_cdev_kill_fasync(md);
 
 	flush_workqueue(dma_wq);
@@ -2603,7 +2596,6 @@ static void mport_cdev_remove(struct mport_dev *md)
 
 	rio_release_inb_dbell(md->mport, 0, 0x0fff);
 
-	device_unregister(&md->dev);
 	put_device(&md->dev);
 }
 
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
