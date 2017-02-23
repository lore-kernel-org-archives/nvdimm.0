Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 235AD82174
 for <linux-nvdimm@lists.01.org>; Thu, 23 Feb 2017 11:27:20 -0800 (PST)
Subject: [PATCH] device-dax: fix cdev leak
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 23 Feb 2017 11:22:03 -0800
Message-ID: <148787772308.30127.18437190636864555810.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

If device_add() fails, cleanup the cdev. Otherwise, we leak a kobj_map()
with a stale device number.

Fixes: ba09c01d2fa8 ("dax: convert to the cdev api")
Cc: <stable@vger.kernel.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Reported-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index ed758b74ddf0..0f8008dd0b0c 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -724,6 +724,7 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dax_dev->id);
 	rc = device_add(dev);
 	if (rc) {
+		cdev_del(&dax_dev->cdev);
 		put_device(dev);
 		return ERR_PTR(rc);
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
