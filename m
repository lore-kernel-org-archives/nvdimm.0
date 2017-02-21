From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 07/14] infiniband: utilize new device_add_cdev helper
 function
Date: Tue, 21 Feb 2017 12:09:05 -0700
Message-ID: <20170221190905.GD13138@obsidianresearch.com>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
 <1487653253-11497-8-git-send-email-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487653253-11497-8-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Alexandre Bounine <alexandre.bounine-49Rm3DX9dRQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Peter Meerwald-Stadler <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Marek Vasut <marek.vasut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Hans Verkuil <hans.verk>
List-Id: linux-nvdimm@lists.01.org

On Mon, Feb 20, 2017 at 10:00:46PM -0700, Logan Gunthorpe wrote:
> This patch updates core/ucm.c which didn't originally use the
> cdev.kobj.parent with it's parent device. I did not look heavily into
> whether this was a bug or not, but it seems likely to me there would
> be a use before free.

Hum, is probably safe - ib_ucm_remove_one can only happen on module
unload and the cdev holds the module lock while open.

Even so device_add_cdev should be used anyhow.

> I also took a look at core/uverbs_main.c, core/user_mad.c and
> hw/hfi1/device.c which utilize cdev.kobj.parent but because the
> infiniband core seems to use kobjs internally instead of struct devices
> they could not be converted to use the new helper API and still
> directly manipulate the internals of the kobj.

Yes, and hfi1 had the same use-afte-free bug when it was first
submitted as well. IHMO cdev should have a helper entry for this style
of use case as well.

> diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
> index e0a995b..38ea316 100644
> +++ b/drivers/infiniband/core/ucm.c
> @@ -1283,18 +1283,20 @@ static void ib_ucm_add_one(struct ib_device *device)
>  		set_bit(devnum, dev_map);
>  	}
>  
> +	device_initialize(&ucm_dev->dev);

Ah, this needs more help. Once device_initialize is called put_device
should be the error-unwind, can you use something more like this?

>From ac7a35ea98066c9a9e3f3e54557c0ccda44b0ffc Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Tue, 21 Feb 2017 12:07:55 -0700
Subject: [PATCH] infiniband: utilize new device_add_cdev helper

The use after free is not triggerable here because the cdev holds
the module lock and the only device_unregister is only triggered by
module ouload, however make the change for consistency.

To make this work the cdev_del needs to move out of the struct device
release function.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/ucm.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 7713ef089c3ccc..acda8d941381f3 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1202,12 +1202,16 @@ static void ib_ucm_release_dev(struct device *dev)
 	struct ib_ucm_device *ucm_dev;
 
 	ucm_dev = container_of(dev, struct ib_ucm_device, dev);
+	kfree(ucm_dev);
+}
+
+static void ib_ucm_cdev_del(struct ib_ucm_device *ucm_dev)
+{
 	cdev_del(&ucm_dev->cdev);
 	if (ucm_dev->devnum < IB_UCM_MAX_DEVICES)
 		clear_bit(ucm_dev->devnum, dev_map);
 	else
 		clear_bit(ucm_dev->devnum - IB_UCM_MAX_DEVICES, overflow_map);
-	kfree(ucm_dev);
 }
 
 static const struct file_operations ucm_fops = {
@@ -1263,6 +1267,7 @@ static void ib_ucm_add_one(struct ib_device *device)
 	if (!ucm_dev)
 		return;
 
+	device_initialize(&ucm_dev->dev);
 	ucm_dev->ib_dev = device;
 
 	devnum = find_first_zero_bit(dev_map, IB_UCM_MAX_DEVICES);
@@ -1280,18 +1285,19 @@ static void ib_ucm_add_one(struct ib_device *device)
 		set_bit(devnum, dev_map);
 	}
 
+	ucm_dev->dev.devt = base;
+	ucm_dev->dev.release = ib_ucm_release_dev;
+
 	cdev_init(&ucm_dev->cdev, &ucm_fops);
 	ucm_dev->cdev.owner = THIS_MODULE;
 	kobject_set_name(&ucm_dev->cdev.kobj, "ucm%d", ucm_dev->devnum);
-	if (cdev_add(&ucm_dev->cdev, base, 1))
+	if (device_add_cdev(&ucm_dev->dev, &ucm_dev->cdev))
 		goto err;
 
 	ucm_dev->dev.class = &cm_class;
 	ucm_dev->dev.parent = device->dma_device;
-	ucm_dev->dev.devt = ucm_dev->cdev.dev;
-	ucm_dev->dev.release = ib_ucm_release_dev;
 	dev_set_name(&ucm_dev->dev, "ucm%d", ucm_dev->devnum);
-	if (device_register(&ucm_dev->dev))
+	if (device_add(&ucm_dev->dev))
 		goto err_cdev;
 
 	if (device_create_file(&ucm_dev->dev, &dev_attr_ibdev))
@@ -1303,13 +1309,9 @@ static void ib_ucm_add_one(struct ib_device *device)
 err_dev:
 	device_unregister(&ucm_dev->dev);
 err_cdev:
-	cdev_del(&ucm_dev->cdev);
-	if (ucm_dev->devnum < IB_UCM_MAX_DEVICES)
-		clear_bit(devnum, dev_map);
-	else
-		clear_bit(devnum, overflow_map);
+	ib_ucm_cdev_del(ucm_dev);
 err:
-	kfree(ucm_dev);
+	put_device(&ucm_dev->dev);
 	return;
 }
 
@@ -1320,6 +1322,7 @@ static void ib_ucm_remove_one(struct ib_device *device, void *client_data)
 	if (!ucm_dev)
 		return;
 
+	ib_ucm_cdev_del(ucm_dev);
 	device_unregister(&ucm_dev->dev);
 }
 
-- 
2.7.4
