Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 88D4382106
 for <linux-nvdimm@lists.01.org>; Sat, 25 Feb 2017 22:42:25 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Sat, 25 Feb 2017 23:38:10 -0700
Message-Id: <1488091097-12328-10-git-send-email-logang@deltatee.com>
In-Reply-To: <1488091097-12328-1-git-send-email-logang@deltatee.com>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 09/16] infiniband: utilize the new cdev_set_parent function
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

This replaces the suspect looking cdev.kobj.parent lines with the
equivalent cdev_set_parent function. This is a straightforward change
that's largely cosmetic but it does push the kobj.parent ownership
into char_dev.c where it belongs.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/infiniband/core/user_mad.c    | 4 ++--
 drivers/infiniband/core/uverbs_main.c | 2 +-
 drivers/infiniband/hw/hfi1/device.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 249b403..f720de0 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1183,7 +1183,7 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 
 	cdev_init(&port->cdev, &umad_fops);
 	port->cdev.owner = THIS_MODULE;
-	port->cdev.kobj.parent = &umad_dev->kobj;
+	cdev_set_parent(&port->cdev, &umad_dev->kobj);
 	kobject_set_name(&port->cdev.kobj, "umad%d", port->dev_num);
 	if (cdev_add(&port->cdev, base, 1))
 		goto err_cdev;
@@ -1202,7 +1202,7 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	base += IB_UMAD_MAX_PORTS;
 	cdev_init(&port->sm_cdev, &umad_sm_fops);
 	port->sm_cdev.owner = THIS_MODULE;
-	port->sm_cdev.kobj.parent = &umad_dev->kobj;
+	cdev_set_parent(&port->sm_cdev, &umad_dev->kobj);
 	kobject_set_name(&port->sm_cdev.kobj, "issm%d", port->dev_num);
 	if (cdev_add(&port->sm_cdev, base, 1))
 		goto err_sm_cdev;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index b3f95d4..3495c83 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -1169,7 +1169,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	cdev_init(&uverbs_dev->cdev, NULL);
 	uverbs_dev->cdev.owner = THIS_MODULE;
 	uverbs_dev->cdev.ops = device->mmap ? &uverbs_mmap_fops : &uverbs_fops;
-	uverbs_dev->cdev.kobj.parent = &uverbs_dev->kobj;
+	cdev_set_parent(&uverbs_dev->cdev, &uverbs_dev->kobj);
 	kobject_set_name(&uverbs_dev->cdev.kobj, "uverbs%d", uverbs_dev->devnum);
 	if (cdev_add(&uverbs_dev->cdev, base, 1))
 		goto err_cdev;
diff --git a/drivers/infiniband/hw/hfi1/device.c b/drivers/infiniband/hw/hfi1/device.c
index bf64b5a..bbb6069 100644
--- a/drivers/infiniband/hw/hfi1/device.c
+++ b/drivers/infiniband/hw/hfi1/device.c
@@ -69,7 +69,7 @@ int hfi1_cdev_init(int minor, const char *name,
 
 	cdev_init(cdev, fops);
 	cdev->owner = THIS_MODULE;
-	cdev->kobj.parent = parent;
+	cdev_set_parent(cdev, parent);
 	kobject_set_name(&cdev->kobj, name);
 
 	ret = cdev_add(cdev, dev, 1);
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
