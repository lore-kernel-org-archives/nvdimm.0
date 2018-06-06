Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AACC72118B662
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 09:45:17 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 3/4] libnvdimm: use dax_write_cache* helpers
Date: Wed,  6 Jun 2018 10:45:14 -0600
Message-Id: <20180606164515.25677-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20180606164515.25677-1-ross.zwisler@linux.intel.com>
References: <20180606164515.25677-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Use dax_write_cache() and dax_write_cache_enabled() instead of open coding
the bit operations.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/dax/super.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 2b2332b605e4..c2c46f96b18c 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -182,8 +182,7 @@ static ssize_t write_cache_show(struct device *dev,
 	if (!dax_dev)
 		return -ENXIO;
 
-	rc = sprintf(buf, "%d\n", !!test_bit(DAXDEV_WRITE_CACHE,
-				&dax_dev->flags));
+	rc = sprintf(buf, "%d\n", !!dax_write_cache_enabled(dax_dev));
 	put_dax(dax_dev);
 	return rc;
 }
@@ -201,10 +200,8 @@ static ssize_t write_cache_store(struct device *dev,
 
 	if (rc)
 		len = rc;
-	else if (write_cache)
-		set_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
 	else
-		clear_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
+		dax_write_cache(dax_dev, write_cache);
 
 	put_dax(dax_dev);
 	return len;
@@ -286,7 +283,7 @@ EXPORT_SYMBOL_GPL(dax_copy_from_iter);
 void arch_wb_cache_pmem(void *addr, size_t size);
 void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
 {
-	if (unlikely(!test_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags)))
+	if (unlikely(!dax_write_cache_enabled(dax_dev)))
 		return;
 
 	arch_wb_cache_pmem(addr, size);
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
