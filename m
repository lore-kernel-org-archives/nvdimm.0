Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9667C82223
 for <linux-nvdimm@lists.01.org>; Mon, 20 Feb 2017 21:03:10 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Mon, 20 Feb 2017 22:00:40 -0700
Message-Id: <1487653253-11497-2-git-send-email-logang@deltatee.com>
In-Reply-To: <1487653253-11497-1-git-send-email-logang@deltatee.com>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 01/14] chardev: add helper function to register char devs with
 a struct device
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

Credit for this patch goes entirely to Dan Williams [1]. I've just
fleshed out the comments and created the patch, but the premise
remains exactly the same.

There's a common pattern in the kernel whereby a struct cdev is placed
in a structure along side a struct device which manages the life-cycle
of both. In the naive approach, the reference counting is broken and
the struct device can free everything before the chardev code
is entirely released.

Many developers have solved this problem by linking the internal kobjs
in this fashion:

cdev.kobj.parent = &parent_dev.kobj;

The cdev code explicitly gets and puts a reference to it's kobj parent.
So this seems like it was intended to be used this way. Dmitrty Torokhov
first put this in place in 2012 with this commit:

2f0157f char_dev: pin parent kobject

and the first instance of the fix was then done in the input subsystem
in the following commit:

4a215aa Input: fix use-after-free introduced with dynamic minor changes

Subsequently over the years, however, this issue seems to have tripped
up multiple developers independently. For example, see these commits:

0d5b7da iio: Prevent race between IIO chardev opening and IIO device
(by Lars-Peter Clausen in 2013)

ba0ef85 tpm: Fix initialization of the cdev
(by Jason Gunthorpe in 2015)

5b28dde [media] media: fix use-after-free in cdev_put() when app exits
after driver unbind
(by Shauh Khan in 2016)

This technique is similarly done in at least 15 places within the kernel
and probably should have been done so in another, at least, 5 places.
The kobj line also looks very suspect in that one would not expect
drivers to have to mess with kobject internals in this way.
Even highly experienced kernel developers can be surprised by this
code, as seen in [2].

To help alleviate this situation, and hopefully prevent future
wasted effort on this problem, this patch introduces a helper function
to register a char device with its parent struct device. This creates
a more regular API for tying a char device to its parent without the
developer having to set members in the underlying kobject.

In [1], Dan notes he took inspiration for the form of the API
device_add_disk.

[1] https://lkml.org/lkml/2017/2/13/700
[2] https://lkml.org/lkml/2017/2/10/370

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 fs/char_dev.c        | 24 ++++++++++++++++++++++++
 include/linux/cdev.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index 44a240c..1f9246c 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -471,6 +471,29 @@ int cdev_add(struct cdev *p, dev_t dev, unsigned count)
 	return 0;
 }
 
+/**
+ * device_add_cdev() - add a char device to the system with a parent
+ *	struct device
+ * @parent: the device structure of the parent
+ * @cdev: the cdev structure for the device
+ * @count: the number of consecutive minor numbers corresponding to this
+ *
+ * device_add_cdev() adds the char device represented by @p to the system,
+ * just as cdev_add does. The dev_t for the char device will be taken from
+ * the struct device which needs to be initialized first. This helper
+ * function correctly takes a reference to the parent device so the parent
+ * will not get released until all references to the cdev are released.
+ * (Thus, cdev_del should be called before device_unregister.) This
+ * function should be used whenever the struct cdev and the struct device
+ * are members of the same structure whose lifetime is managed by the
+ * struct device.
+ */
+int device_add_cdev(struct device *parent, struct cdev *cdev)
+{
+	cdev->kobj.parent = &parent->kobj;
+	return cdev_add(cdev, parent->devt, 1);
+}
+
 static void cdev_unmap(dev_t dev, unsigned count)
 {
 	kobj_unmap(cdev_map, dev, count);
@@ -570,5 +593,6 @@ EXPORT_SYMBOL(cdev_init);
 EXPORT_SYMBOL(cdev_alloc);
 EXPORT_SYMBOL(cdev_del);
 EXPORT_SYMBOL(cdev_add);
+EXPORT_SYMBOL(device_add_cdev);
 EXPORT_SYMBOL(__register_chrdev);
 EXPORT_SYMBOL(__unregister_chrdev);
diff --git a/include/linux/cdev.h b/include/linux/cdev.h
index f876361..9edbc37 100644
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -25,6 +25,7 @@ struct cdev *cdev_alloc(void);
 void cdev_put(struct cdev *p);
 
 int cdev_add(struct cdev *, dev_t, unsigned);
+int device_add_cdev(struct device *parent, struct cdev *cdev);
 
 void cdev_del(struct cdev *);
 
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
