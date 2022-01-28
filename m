Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2052CB4;
	Fri, 28 Jan 2022 00:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643329646; x=1674865646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eZfTd1SDHxpeSkQFf4Hi1IY90tP7t53lECHImTN5KkA=;
  b=ieqjGwP3rvbDSwAX01sd9JS9Y4RUgVPz9rprFxB43yn1J69DLyj58bxA
   KP87lTCFqwNiaQ7+9pwUyETysnvDOA0xpyDcGyUQ3PCPLrRixXK7L5NWt
   gtyI9HA8Qe1ufr6c4n36COcSFqwJlxXP9U58RSHqoL8ckhir/FDE9tpdI
   O7A4Bef9hi5IUOe9qL4oQOXS6jkKkVNT0KfiGPhB8F530LV3QYyPHcbWX
   Tlh8cMHDueQ1Lwm/CFzK7dpfRvhmXHJsJ1MJMABKrqtS55r6uawPkg9PM
   D18NePsb3KehOUJd1mAzcbFvd1k5xo2bdJpL78oU2xI/xBduFVfYojJ43
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="226982071"
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="226982071"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 16:27:25 -0800
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="674909623"
Received: from vrao2-mobl1.gar.corp.intel.com (HELO localhost.localdomain) ([10.252.129.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 16:27:24 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org
Subject: [PATCH v3 05/14] cxl/acpi: Handle address space allocation
Date: Thu, 27 Jan 2022 16:26:58 -0800
Message-Id: <20220128002707.391076-6-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220128002707.391076-1-ben.widawsky@intel.com>
References: <20220128002707.391076-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Regions are carved out of an addresses space which is claimed by top
level decoders, and subsequently their children decoders. Regions are
created with a size and therefore must fit, with proper alignment, in
that address space. The support for doing this fitting is handled by the
driver automatically.

As an example, a platform might configure a top level decoder to claim
1TB of address space @ 0x800000000 -> 0x10800000000; it would be
possible to create M regions with appropriate alignment to occupy that
address space. Each of those regions would have a host physical address
somewhere in the range between 32G and 1.3TB, and the location will be
determined by the logic added here.

The request_region() usage is not strictly mandatory at this point as
the actual handling of the address space is done with genpools. It is
highly likely however that the resource/region APIs will become useful
in the not too distant future.

All decoders manage a host physical address space while active. Only the
root decoder has constraints on location and size. As a result, it makes
most sense for the root decoder to be responsible for managing the
entire address space, and mid-level decoders and endpoints can ask the
root decoder for suballocations.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/acpi.c | 30 ++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h  |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index d6dcb2b6af48..74681bfbf53c 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2021 Intel Corporation. All rights reserved. */
 #include <linux/platform_device.h>
+#include <linux/genalloc.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -73,6 +74,27 @@ static int cxl_acpi_cfmws_verify(struct device *dev,
 	return 0;
 }
 
+/*
+ * Every decoder while active has an address space that it is decoding. However,
+ * only the root level decoders have fixed host physical address space ranges.
+ */
+static int cxl_create_cfmws_address_space(struct cxl_decoder *cxld,
+					  struct acpi_cedt_cfmws *cfmws)
+{
+	const int order = ilog2(SZ_256M * cxld->interleave_ways);
+	struct device *dev = &cxld->dev;
+	struct gen_pool *pool;
+
+	pool = devm_gen_pool_create(dev, order, NUMA_NO_NODE, dev_name(dev));
+	if (IS_ERR(pool))
+		return PTR_ERR(pool);
+
+	cxld->address_space = pool;
+
+	return gen_pool_add(cxld->address_space, cfmws->base_hpa,
+			    cfmws->window_size, NUMA_NO_NODE);
+}
+
 struct cxl_cfmws_context {
 	struct device *dev;
 	struct cxl_port *root_port;
@@ -113,6 +135,14 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
 	cxld->interleave_ways = CFMWS_INTERLEAVE_WAYS(cfmws);
 	cxld->interleave_granularity = CFMWS_INTERLEAVE_GRANULARITY(cfmws);
 
+	rc = cxl_create_cfmws_address_space(cxld, cfmws);
+	if (rc) {
+		dev_err(dev,
+			"Failed to create CFMWS address space for decoder\n");
+		put_device(&cxld->dev);
+		return 0;
+	}
+
 	rc = cxl_decoder_add(cxld, target_map);
 	if (rc)
 		put_device(&cxld->dev);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index d1a8ca19c9ea..b300673072f5 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -251,6 +251,7 @@ enum cxl_decoder_type {
  * @flags: memory type capabilities and locking
  * @target_lock: coordinate coherent reads of the target list
  * @region_ida: allocator for region ids.
+ * @address_space: Used/free address space for regions.
  * @nr_targets: number of elements in @target
  * @target: active ordered target list in current decoder configuration
  */
@@ -267,6 +268,7 @@ struct cxl_decoder {
 	unsigned long flags;
 	seqlock_t target_lock;
 	struct ida region_ida;
+	struct gen_pool *address_space;
 	int nr_targets;
 	struct cxl_dport *target[];
 };
-- 
2.35.0

