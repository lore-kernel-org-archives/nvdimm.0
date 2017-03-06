Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 813E3802B4
 for <linux-nvdimm@lists.01.org>; Sun,  5 Mar 2017 23:07:39 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Mon,  6 Mar 2017 00:04:19 -0700
Message-Id: <1488783873-2614-4-git-send-email-logang@deltatee.com>
In-Reply-To: <1488783873-2614-1-git-send-email-logang@deltatee.com>
References: <1488783873-2614-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v3 03/16] device-dax: utilize new cdev_device_add helper
 function
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

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index a5ed59a..e5f8555 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -677,8 +677,6 @@ static void dax_dev_release(struct device *dev)
 
 static void kill_dax_dev(struct dax_dev *dax_dev)
 {
-	struct cdev *cdev = &dax_dev->cdev;
-
 	/*
 	 * Note, rcu is not protecting the liveness of dax_dev, rcu is
 	 * ensuring that any fault handlers that might have seen
@@ -689,7 +687,6 @@ static void kill_dax_dev(struct dax_dev *dax_dev)
 	dax_dev->alive = false;
 	synchronize_rcu();
 	unmap_mapping_range(dax_dev->inode->i_mapping, 0, 0, 1);
-	cdev_del(cdev);
 }
 
 static void unregister_dax_dev(void *dev)
@@ -699,7 +696,8 @@ static void unregister_dax_dev(void *dev)
 	dev_dbg(dev, "%s\n", __func__);
 
 	kill_dax_dev(dax_dev);
-	device_unregister(dev);
+	cdev_device_del(&dax_dev->cdev, dev);
+	put_device(dev);
 }
 
 struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
@@ -750,18 +748,13 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 		goto err_inode;
 	}
 
-	/* device_initialize() so cdev can reference kobj parent */
+	/* from here on we're committed to teardown via dax_dev_release() */
 	device_initialize(dev);
 
 	cdev = &dax_dev->cdev;
 	cdev_init(cdev, &dax_fops);
 	cdev->owner = parent->driver->owner;
-	cdev->kobj.parent = &dev->kobj;
-	rc = cdev_add(&dax_dev->cdev, dev_t, 1);
-	if (rc)
-		goto err_cdev;
 
-	/* from here on we're committed to teardown via dax_dev_release() */
 	dax_dev->num_resources = count;
 	dax_dev->alive = true;
 	dax_dev->region = dax_region;
@@ -773,7 +766,8 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 	dev->groups = dax_attribute_groups;
 	dev->release = dax_dev_release;
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dax_dev->id);
-	rc = device_add(dev);
+
+	rc = cdev_device_add(cdev, dev);
 	if (rc) {
 		kill_dax_dev(dax_dev);
 		put_device(dev);
@@ -786,8 +780,6 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 
 	return dax_dev;
 
- err_cdev:
-	iput(dax_dev->inode);
  err_inode:
 	ida_simple_remove(&dax_minor_ida, minor);
  err_minor:
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
