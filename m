Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2A85481FC5
 for <linux-nvdimm@lists.01.org>; Wed,  1 Feb 2017 10:39:27 -0800 (PST)
Subject: [PATCH] libnvdimm, namespace: do not delete namespace-id 0
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 01 Feb 2017 10:35:21 -0800
Message-ID: <148597412157.20990.8337801110453234119.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
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
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Given that the naming of pmem devices changes from the pmemX form to the
pmemX.Y form when namespace id is greater than 0, arrange for namespaces
with id-0 to be exempt from deletion. Otherwise a simple reconfiguration
of an existing namespace to a new mode results in a name change of the
resulting block device:

    # ndctl list --namespace=namespace1.0
    {
      "dev":"namespace1.0",
      "mode":"raw",
      "size":2147483648,
      "uuid":"3dadf3dc-89b9-4b24-b20e-abc8a4707ce3",
      "blockdev":"pmem1"
    }

    # ndctl create-namespace --reconfig=namespace1.0 --mode=memory --force
    {
      "dev":"namespace1.1",
      "mode":"memory",
      "size":2111832064,
      "uuid":"7b4a6341-7318-4219-a02c-fb57c0bbf613",
      "blockdev":"pmem1.1"
    }

This change does require tooling changes to explicitly look for
namespaceX.0 if the seed has already advanced to another namespace.

Cc: <stable@vger.kernel.org>
Fixes: 98a29c39dc68 ("libnvdimm, namespace: allow creation of multiple pmem-namespaces per region")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index eda027db0918..ce3e8dfa10ad 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -962,8 +962,8 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 	struct nvdimm_drvdata *ndd;
 	struct nd_label_id label_id;
 	u32 flags = 0, remainder;
+	int rc, i, id = -1;
 	u8 *uuid = NULL;
-	int rc, i;
 
 	if (dev->driver || ndns->claim)
 		return -EBUSY;
@@ -972,11 +972,13 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
 		uuid = nspm->uuid;
+		id = nspm->id;
 	} else if (is_namespace_blk(dev)) {
 		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
 
 		uuid = nsblk->uuid;
 		flags = NSLABEL_FLAG_LOCAL;
+		id = nsblk->id;
 	}
 
 	/*
@@ -1039,10 +1041,11 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 
 	/*
 	 * Try to delete the namespace if we deleted all of its
-	 * allocation, this is not the seed device for the region, and
-	 * it is not actively claimed by a btt instance.
+	 * allocation, this is not the seed or 0th device for the
+	 * region, and it is not actively claimed by a btt, pfn, or dax
+	 * instance.
 	 */
-	if (val == 0 && nd_region->ns_seed != dev && !ndns->claim)
+	if (val == 0 && id != 0 && nd_region->ns_seed != dev && !ndns->claim)
 		nd_device_unregister(dev, ND_ASYNC);
 
 	return rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
