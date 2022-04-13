Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AAD2F43;
	Wed, 13 Apr 2022 18:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649875096; x=1681411096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pRLZars87pwyZ+h8xfv4rMp3ejVZKIggcp6TbwcwTjk=;
  b=Lvl6lUESA0bx1p7Qby2tzZcGnNtWVVIAm3Sroy7SqMRfaIxl8oFeHPln
   rONrKWj6ltEX7mOJup/lHEsWR6EWki4YHjTO5dA2SiHoSuwWGDnVFx4YA
   VFbE37ncDAKe0EbVjkboxwSNDScfgqXUaCB0KUGooLu3+HnTFa7Q3VTQR
   AtuzbYwKd6vHj502z4EXQgCpMTo+To0uQZ8AAAexp8ax3TcM1sHN56Z6t
   oHnws/e49X/0PSBjTg1CUsujTK5wdwzBa5P7bH3VTNhcHetHXK+WtUVvI
   MmaPHcyFI9WlWJQpcWyEltBXFFKrxaKZ2LyfAWJWAorw7R2CQS31MRaJN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="244631847"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="244631847"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:50 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="725013599"
Received: from sushobhi-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.131.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:49 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 08/15] cxl/core/hdm: Allocate resources from the media
Date: Wed, 13 Apr 2022 11:37:13 -0700
Message-Id: <20220413183720.2444089-9-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413183720.2444089-1-ben.widawsky@intel.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to how decoders consume address space for the root decoder, they
also consume space on the device's physical media. For future
allocations, it's required to mark those as used/busy.

The CXL specification requires that HDM decoder are programmed in
ascending physical address order. The device's address space can
therefore be managed by a simple allocator. Fragmentation may occur if
devices are taken in and out of active decoding. Fixing this is left to
userspace to handle.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/core/core.h |  3 +++
 drivers/cxl/core/hdm.c  | 26 +++++++++++++++++++++++++-
 drivers/cxl/core/port.c |  9 ++++++++-
 drivers/cxl/cxl.h       | 10 ++++++++++
 4 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 1a50c0fc399c..a507a2502127 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -9,6 +9,9 @@ extern const struct device_type cxl_nvdimm_type;
 
 extern struct attribute_group cxl_base_attribute_group;
 
+extern struct device_attribute dev_attr_create_pmem_region;
+extern struct device_attribute dev_attr_delete_region;
+
 struct cxl_send_command;
 struct cxl_mem_query_commands;
 int cxl_query_cmd(struct cxl_memdev *cxlmd,
diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 37c09c77e9a7..5326a2cd6968 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2022 Intel Corporation. All rights reserved. */
 #include <linux/io-64-nonatomic-hi-lo.h>
+#include <linux/genalloc.h>
 #include <linux/device.h>
 #include <linux/delay.h>
 
@@ -198,8 +199,11 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 	else
 		cxld->target_type = CXL_DECODER_ACCELERATOR;
 
-	if (is_endpoint_decoder(&cxld->dev))
+	if (is_endpoint_decoder(&cxld->dev)) {
+		to_cxl_endpoint_decoder(cxld)->skip =
+			ioread64_hi_lo(hdm + CXL_HDM_DECODER0_TL_LOW(which));
 		return 0;
+	}
 
 	target_list.value =
 		ioread64_hi_lo(hdm + CXL_HDM_DECODER0_TL_LOW(which));
@@ -218,6 +222,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
 	void __iomem *hdm = cxlhdm->regs.hdm_decoder;
 	struct cxl_port *port = cxlhdm->port;
 	int i, committed, failed;
+	u64 base = 0;
 	u32 ctrl;
 
 	/*
@@ -240,6 +245,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
 	for (i = 0, failed = 0; i < cxlhdm->decoder_count; i++) {
 		int target_map[CXL_DECODER_MAX_INTERLEAVE] = { 0 };
 		int rc, target_count = cxlhdm->target_count;
+		struct cxl_endpoint_decoder *cxled;
 		struct cxl_decoder *cxld;
 
 		if (is_cxl_endpoint(port))
@@ -267,6 +273,24 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
 				 "Failed to add decoder to port\n");
 			return rc;
 		}
+
+		if (!is_cxl_endpoint(port))
+			continue;
+
+		cxled = to_cxl_endpoint_decoder(cxld);
+		cxled->drange = (struct range) {
+			.start = base,
+			.end = base + range_len(&cxld->range) - 1,
+		};
+
+		if (!range_len(&cxld->range))
+			continue;
+
+		dev_dbg(&cxld->dev,
+			"Enumerated decoder with DPA range %#llx-%#llx\n", base,
+			base + range_len(&cxled->drange));
+		base += cxled->skip + range_len(&cxld->range);
+		port->last_cxled = cxled;
 	}
 
 	if (failed == cxlhdm->decoder_count) {
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 0d946711685b..9ef8d69dbfa5 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -84,7 +84,14 @@ static ssize_t size_show(struct device *dev, struct device_attribute *attr,
 {
 	struct cxl_decoder *cxld = to_cxl_decoder(dev);
 
-	return sysfs_emit(buf, "%#llx\n", range_len(&cxld->range));
+	if (is_endpoint_decoder(dev)) {
+		struct cxl_endpoint_decoder *cxled;
+
+		cxled = to_cxl_endpoint_decoder(cxld);
+		return sysfs_emit(buf, "%#llx\n", range_len(&cxled->drange));
+	} else {
+		return sysfs_emit(buf, "%#llx\n", range_len(&cxld->range));
+	}
 }
 static DEVICE_ATTR_RO(size);
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 52295548a071..33f8a55f2f84 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -228,9 +228,13 @@ struct cxl_decoder {
 /**
  * struct cxl_endpoint_decoder - An decoder residing in a CXL endpoint.
  * @base: Base class decoder
+ * @drange: Device physical address space this decoder is using
+ * @skip: The skip count as specified in the CXL specification.
  */
 struct cxl_endpoint_decoder {
 	struct cxl_decoder base;
+	struct range drange;
+	u64 skip;
 };
 
 /**
@@ -248,11 +252,15 @@ struct cxl_switch_decoder {
  * @base: Base class decoder
  * @window: host address space allocator
  * @targets: Downstream targets (ie. hostbridges).
+ * @next_region_id: The pre-cached next region id.
+ * @id_lock: Protects next_region_id
  */
 struct cxl_root_decoder {
 	struct cxl_decoder base;
 	struct gen_pool *window;
 	struct cxl_decoder_targets *targets;
+	int next_region_id;
+	struct mutex id_lock; /* synchronizes access to next_region_id */
 };
 
 #define _to_cxl_decoder(x)                                                     \
@@ -312,6 +320,7 @@ struct cxl_nvdimm {
  * @capacity: How much total storage the media can hold (endpoint only)
  * @pmem_offset: Partition dividing volatile, [0, pmem_offset -1 ], and persistent
  *		 [pmem_offset, capacity - 1] addresses.
+ * @last_cxled: Last active decoder doing decode (endpoint only)
  */
 struct cxl_port {
 	struct device dev;
@@ -326,6 +335,7 @@ struct cxl_port {
 
 	u64 capacity;
 	u64 pmem_offset;
+	struct cxl_endpoint_decoder *last_cxled;
 };
 
 /**
-- 
2.35.1

