Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6872A82212
 for <linux-nvdimm@lists.01.org>; Mon, 20 Feb 2017 21:03:07 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Mon, 20 Feb 2017 22:00:42 -0700
Message-Id: <1487653253-11497-4-git-send-email-logang@deltatee.com>
In-Reply-To: <1487653253-11497-1-git-send-email-logang@deltatee.com>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 03/14] input: utilize new device_add_cdev helper function
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

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/input/evdev.c    | 3 +--
 drivers/input/joydev.c   | 3 +--
 drivers/input/mousedev.c | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index e9ae3d5..a3407ea 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -1416,8 +1416,7 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 		goto err_free_evdev;
 
 	cdev_init(&evdev->cdev, &evdev_fops);
-	evdev->cdev.kobj.parent = &evdev->dev.kobj;
-	error = cdev_add(&evdev->cdev, evdev->dev.devt, 1);
+	error = device_add_cdev(&evdev->dev, &evdev->cdev);
 	if (error)
 		goto err_unregister_handle;
 
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index abd18f3..012e06f 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -905,8 +905,7 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 		goto err_free_joydev;
 
 	cdev_init(&joydev->cdev, &joydev_fops);
-	joydev->cdev.kobj.parent = &joydev->dev.kobj;
-	error = cdev_add(&joydev->cdev, joydev->dev.devt, 1);
+	error = device_add_cdev(&joydev->dev, &joydev->cdev);
 	if (error)
 		goto err_unregister_handle;
 
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index b604564..efd8666 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -901,8 +901,7 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
 	}
 
 	cdev_init(&mousedev->cdev, &mousedev_fops);
-	mousedev->cdev.kobj.parent = &mousedev->dev.kobj;
-	error = cdev_add(&mousedev->cdev, mousedev->dev.devt, 1);
+	error = device_add_cdev(&mousedev->dev, &mousedev->cdev);
 	if (error)
 		goto err_unregister_handle;
 
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
