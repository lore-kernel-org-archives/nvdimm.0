Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14BE31A1E43
 for <linux-nvdimm@lists.01.org>; Mon,  4 Jul 2016 22:56:36 -0700 (PDT)
From: Vikas C Sajjan <vikas.cha.sajjan@hpe.com>
Subject: [PATCH] dax: use devm_add_action_or_reset()
Date: Tue,  5 Jul 2016 11:20:07 +0530
Message-Id: <1467697807-27067-1-git-send-email-vikas.cha.sajjan@hpe.com>
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
To: dan.j.williams@intel.com, jthumshirn@suse.de
Cc: linux-acpi@vger.kernel.org, Vikas C Sajjan <vikas.cha.sajjan@hpe.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

If devm_add_action() fails, we are explicitly calling the cleanup to free
the resources allocated. Use the helper devm_add_action_or_reset()
and return directly in case of error, since the cleanup function
has been already called by the helper if there was any error.

Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Vikas C Sajjan <vikas.cha.sajjan@hpe.com>
---
 drivers/dax/dax.c  |  6 ++----
 drivers/dax/pmem.c | 14 ++++++--------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index b891a12..803f395 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -211,11 +211,9 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 	}
 	dax_dev->dev = dev;
 
-	rc = devm_add_action(dax_region->dev, unregister_dax_dev, dev);
-	if (rc) {
-		unregister_dax_dev(dev);
+	rc = devm_add_action_or_reset(dax_region->dev, unregister_dax_dev, dev);
+	if (rc)
 		return rc;
-	}
 
 	return 0;
 
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index 55d510e..dfb1685 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -102,21 +102,19 @@ static int dax_pmem_probe(struct device *dev)
 	if (rc)
 		return rc;
 
-	rc = devm_add_action(dev, dax_pmem_percpu_exit, &dax_pmem->ref);
-	if (rc) {
-		dax_pmem_percpu_exit(&dax_pmem->ref);
+	rc = devm_add_action_or_reset(dev, dax_pmem_percpu_exit,
+							&dax_pmem->ref);
+	if (rc)
 		return rc;
-	}
 
 	addr = devm_memremap_pages(dev, &res, &dax_pmem->ref, altmap);
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
 
-	rc = devm_add_action(dev, dax_pmem_percpu_kill, &dax_pmem->ref);
-	if (rc) {
-		dax_pmem_percpu_kill(&dax_pmem->ref);
+	rc = devm_add_action_or_reset(dev, dax_pmem_percpu_kill,
+							&dax_pmem->ref);
+	if (rc)
 		return rc;
-	}
 
 	nd_region = to_nd_region(dev->parent);
 	dax_region = alloc_dax_region(dev, nd_region->id, &res,
-- 
1.9.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
