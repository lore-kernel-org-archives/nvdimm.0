Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com
 [IPv6:2607:f8b0:4864:20::542])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22D922112121C
 for <linux-nvdimm@lists.01.org>; Sun,  9 Sep 2018 23:24:08 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s7-v6so9930423pgc.0
 for <linux-nvdimm@lists.01.org>; Sun, 09 Sep 2018 23:24:08 -0700 (PDT)
From: Ocean He <oceanhehy@gmail.com>
Subject: [PATCH 2/3] libnvdimm,
 namespace_devs: add function nd_region_reset_ns_seed for namespace
 seed reset
Date: Mon, 10 Sep 2018 02:21:47 -0400
Message-Id: <1536560508-24564-3-git-send-email-oceanhehy@gmail.com>
In-Reply-To: <1536560508-24564-1-git-send-email-oceanhehy@gmail.com>
References: <1536560508-24564-1-git-send-email-oceanhehy@gmail.com>
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
To: dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com
Cc: Ocean He <hehy1@lenovo.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ocean He <hehy1@lenovo.com>

During runtime, if a namespace seed is used for new namespace creation
but fail, then it needs to be reset for next namespace creation.

Add function nd_region_reset_ns_seed for namespace seed reset and
declare it in nd-core.h.

Signed-off-by: Ocean He <hehy1@lenovo.com>
---
 drivers/nvdimm/namespace_devs.c | 32 ++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h        |  1 +
 2 files changed, 33 insertions(+)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 4a42662..6678bbe 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2129,6 +2129,38 @@ void nd_region_create_ns_seed(struct nd_region *nd_region)
 		nd_device_register(nd_region->ns_seed);
 }
 
+void nd_region_reset_ns_seed(struct nd_region *nd_region)
+{
+	struct device *dev = nd_region->ns_seed;
+	unsigned long long val = 0;
+	ssize_t rc;
+	u8 **uuid = NULL;
+
+	rc = __holder_class_store(dev, "");
+	dev_dbg(dev, "%s(%zd)\n", rc < 0 ? "fail to reset claim_class " : "", rc);
+
+	rc = __size_store(dev, val);
+	if (rc >= 0)
+		rc = nd_namespace_label_update(nd_region, dev);
+	dev_dbg(dev, "%s(%zd)\n", rc < 0 ? "fail to reset size " : "", rc);
+
+	if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		uuid = &nspm->uuid;
+	} else if (is_namespace_blk(dev)) {
+		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+
+		uuid = &nsblk->uuid;
+	}
+
+	if (rc == 0 && val == 0 && uuid) {
+		/* setting size zero == 'delete namespace' */
+		kfree(*uuid);
+		*uuid = NULL;
+	}
+}
+
 void nd_region_create_dax_seed(struct nd_region *nd_region)
 {
 	WARN_ON(!is_nvdimm_bus_locked(&nd_region->dev));
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 7fd74d0..3ec6909 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -81,6 +81,7 @@ static inline bool is_memory(struct device *dev)
 void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 struct nd_region;
 void nd_region_create_ns_seed(struct nd_region *nd_region);
+void nd_region_reset_ns_seed(struct nd_region *nd_region);
 void nd_region_create_btt_seed(struct nd_region *nd_region);
 void nd_region_create_pfn_seed(struct nd_region *nd_region);
 void nd_region_create_dax_seed(struct nd_region *nd_region);
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
