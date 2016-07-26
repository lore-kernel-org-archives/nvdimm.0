Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 2246F1A1E07
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jul 2016 13:59:30 -0700 (PDT)
Date: Tue, 26 Jul 2016 14:58:44 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: btt ndctl question
Message-ID: <20160726205843.GA5520@omniknight.lm.intel.com>
References: <5797C9DE.3070901@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5797C9DE.3070901@redhat.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Linda Knippers <lknipper@redhat.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 07/26, Linda Knippers wrote:
> My system has 4 8G NVDIMMs and I have them configured in different ways, as you can
> see from the ndctl output:
> 
> $ ndctl list
> [
>   {
>     "dev":"namespace3.0",
>     "mode":"raw",
>     "size":8589934592,
>     "blockdev":"pmem3"
>   },
>   {
>     "dev":"namespace2.0",
>     "mode":"memory",
>     "size":8587837440,
>     "uuid":"2567d762-68ae-486b-a6eb-2d3ab1b9dca9",
>     "blockdev":"pmem2"
>   },
>   {
>     "dev":"namespace1.0",
>     "mode":"sector",
>     "uuid":"44fb474e-7db8-4438-ad95-05ecb9f2075e",
>     "sector_size":4096,
>     "blockdev":"pmem1s"
>   },
>   {
>     "dev":"namespace0.0",
>     "mode":"memory",
>     "size":8453619712,
>     "uuid":"933ed54b-5b64-47f1-8409-c88f7c846522",
>     "blockdev":"pmem0"
>   }
> ]
> 
> The two memory namespaces have different sizes because one is --map=dev and the other is --map=mem.
> It would be nice if the map option was displayed but my question is about the size value for the
> btt device, or lack of one.
> 
> All the namespaces show a size except for the btt.  The btt only shows a sector size.  There
> is no size value exposed by the btt sysfs information, which is probably why it's not in ndctl.
> 
> I know the size can be gotten from the block device but it looks like an omission here.
> Is this a bug or a feature?

Probably an omission :)
This patch should expose a size attribute in sysfs:

$ cat /sys/bus/nd/devices/btt7.0/size 
32440320

I can look at the 'ndctl list' enabling too if this looks good.

8<------

>From fb119bf4380d1d65d82754e581bbd41161c2100f Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 26 Jul 2016 14:54:39 -0600
Subject: [PATCH] nvdimm, btt: add a size attribute for BTTs

To be consistent with other namespaces, expose a 'size' attribute for
BTT devices also.

Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c      |  1 +
 drivers/nvdimm/btt_devs.c | 15 +++++++++++++++
 drivers/nvdimm/nd.h       |  1 +
 3 files changed, 17 insertions(+)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 68a7c3c..71ce0dc 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1270,6 +1270,7 @@ static int btt_blk_init(struct btt *btt)
 		}
 	}
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
+	btt->nd_btt->size = btt->nlba * btt->sector_size;
 	revalidate_disk(btt->btt_disk);
 
 	return 0;
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 3fa7919..b54cfc7 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -140,10 +140,25 @@ static ssize_t namespace_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(namespace);
 
+
+static ssize_t size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+	ssize_t rc;
+
+	nvdimm_bus_lock(dev);
+	rc = sprintf(buf, "%llu\n", nd_btt->size);
+	nvdimm_bus_unlock(dev);
+	return rc;
+}
+static DEVICE_ATTR_RO(size);
+
 static struct attribute *nd_btt_attributes[] = {
 	&dev_attr_sector_size.attr,
 	&dev_attr_namespace.attr,
 	&dev_attr_uuid.attr,
+	&dev_attr_size.attr,
 	NULL,
 };
 
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 4047639..8024a0e 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -143,6 +143,7 @@ struct nd_btt {
 	struct nd_namespace_common *ndns;
 	struct btt *btt;
 	unsigned long lbasize;
+	u64 size;
 	u8 *uuid;
 	int id;
 };
-- 
2.7.4


> 
> -- ljk
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
