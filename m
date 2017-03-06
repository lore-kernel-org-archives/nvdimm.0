Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85603802AE
 for <linux-nvdimm@lists.01.org>; Sun,  5 Mar 2017 23:06:46 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Mon,  6 Mar 2017 00:04:20 -0700
Message-Id: <1488783873-2614-5-git-send-email-logang@deltatee.com>
In-Reply-To: <1488783873-2614-1-git-send-email-logang@deltatee.com>
References: <1488783873-2614-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v3 04/16] input: utilize new cdev_device_add helper function
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
new device_add_cdev() helper in evdev, joydev and mousedev. The helper
replaces a common pattern by taking the proper reference against the
parent device and adding both the cdev and the device.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/evdev.c    | 11 ++---------
 drivers/input/joydev.c   | 11 ++---------
 drivers/input/mousedev.c | 11 ++---------
 3 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index e9ae3d5..9255714 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -1354,8 +1354,6 @@ static void evdev_cleanup(struct evdev *evdev)
 	evdev_mark_dead(evdev);
 	evdev_hangup(evdev);
 
-	cdev_del(&evdev->cdev);
-
 	/* evdev is marked dead so no one else accesses evdev->open */
 	if (evdev->open) {
 		input_flush_device(handle, NULL);
@@ -1416,12 +1414,8 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 		goto err_free_evdev;
 
 	cdev_init(&evdev->cdev, &evdev_fops);
-	evdev->cdev.kobj.parent = &evdev->dev.kobj;
-	error = cdev_add(&evdev->cdev, evdev->dev.devt, 1);
-	if (error)
-		goto err_unregister_handle;
 
-	error = device_add(&evdev->dev);
+	error = cdev_device_add(&evdev->cdev, &evdev->dev);
 	if (error)
 		goto err_cleanup_evdev;
 
@@ -1429,7 +1423,6 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 
  err_cleanup_evdev:
 	evdev_cleanup(evdev);
- err_unregister_handle:
 	input_unregister_handle(&evdev->handle);
  err_free_evdev:
 	put_device(&evdev->dev);
@@ -1442,7 +1435,7 @@ static void evdev_disconnect(struct input_handle *handle)
 {
 	struct evdev *evdev = handle->private;
 
-	device_del(&evdev->dev);
+	cdev_device_del(&evdev->cdev, &evdev->dev);
 	evdev_cleanup(evdev);
 	input_free_minor(MINOR(evdev->dev.devt));
 	input_unregister_handle(handle);
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 065e67b..29d677c 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -742,8 +742,6 @@ static void joydev_cleanup(struct joydev *joydev)
 	joydev_mark_dead(joydev);
 	joydev_hangup(joydev);
 
-	cdev_del(&joydev->cdev);
-
 	/* joydev is marked dead so no one else accesses joydev->open */
 	if (joydev->open)
 		input_close_device(handle);
@@ -913,12 +911,8 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 		goto err_free_joydev;
 
 	cdev_init(&joydev->cdev, &joydev_fops);
-	joydev->cdev.kobj.parent = &joydev->dev.kobj;
-	error = cdev_add(&joydev->cdev, joydev->dev.devt, 1);
-	if (error)
-		goto err_unregister_handle;
 
-	error = device_add(&joydev->dev);
+	error = cdev_device_add(&joydev->cdev, &joydev->dev);
 	if (error)
 		goto err_cleanup_joydev;
 
@@ -926,7 +920,6 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 
  err_cleanup_joydev:
 	joydev_cleanup(joydev);
- err_unregister_handle:
 	input_unregister_handle(&joydev->handle);
  err_free_joydev:
 	put_device(&joydev->dev);
@@ -939,7 +932,7 @@ static void joydev_disconnect(struct input_handle *handle)
 {
 	struct joydev *joydev = handle->private;
 
-	device_del(&joydev->dev);
+	cdev_device_del(&joydev->cdev, &joydev->dev);
 	joydev_cleanup(joydev);
 	input_free_minor(MINOR(joydev->dev.devt));
 	input_unregister_handle(handle);
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index b604564..0e0ff84 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -812,8 +812,6 @@ static void mousedev_cleanup(struct mousedev *mousedev)
 	mousedev_mark_dead(mousedev);
 	mousedev_hangup(mousedev);
 
-	cdev_del(&mousedev->cdev);
-
 	/* mousedev is marked dead so no one else accesses mousedev->open */
 	if (mousedev->open)
 		input_close_device(handle);
@@ -901,12 +899,8 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
 	}
 
 	cdev_init(&mousedev->cdev, &mousedev_fops);
-	mousedev->cdev.kobj.parent = &mousedev->dev.kobj;
-	error = cdev_add(&mousedev->cdev, mousedev->dev.devt, 1);
-	if (error)
-		goto err_unregister_handle;
 
-	error = device_add(&mousedev->dev);
+	error = cdev_device_add(&mousedev->cdev, &mousedev->dev);
 	if (error)
 		goto err_cleanup_mousedev;
 
@@ -914,7 +908,6 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
 
  err_cleanup_mousedev:
 	mousedev_cleanup(mousedev);
- err_unregister_handle:
 	if (!mixdev)
 		input_unregister_handle(&mousedev->handle);
  err_free_mousedev:
@@ -927,7 +920,7 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
 
 static void mousedev_destroy(struct mousedev *mousedev)
 {
-	device_del(&mousedev->dev);
+	cdev_device_del(&mousedev->cdev, &mousedev->dev);
 	mousedev_cleanup(mousedev);
 	input_free_minor(MINOR(mousedev->dev.devt));
 	if (mousedev != mousedev_mix)
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
