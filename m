Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EAF7BAED;
	Tue, 30 Jan 2024 22:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706653768; cv=none; b=FQE2Ce4ARSl+6EqcUyAaYJ4y1N/xFrw+lGrRY5T0ThCTdWt4Z9ebDyPy2ntZoT0J4dPnsO5eW265IZ3I3j3G5rdbEpjYa+BrMRmc5D6vVvfy4lNEGF6yUaRARxtZvsnHvxVIQVELXXPUWmKLKoEfh7yiOpcNXtQVh24Brdz3jE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706653768; c=relaxed/simple;
	bh=ywNpUyXrDvoJT+alZnSIxmANFL/SDTapo7DeqjOb4ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoLF7HuZl1EeYmGJzqLmQ5T/A0LxArDFIjyTP7GGIk7F8SkaKfgXU1uQJP5on0ukOD+j9kxi/6zAO6A2namZ/ka4b7s/NBhAYzwkx0V3PVc++9Gd8xHnr0g1Cx7vPIUTi3MS6CeA1u5Mu9y49BaOaZfZuJMkvYgGrLGX7UgWkHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59251C433F1;
	Tue, 30 Jan 2024 22:29:27 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com,
	ira.weiny@intel.com,
	vishal.l.verma@intel.com,
	alison.schofield@intel.com,
	Jonathan.Cameron@huawei.com,
	dave@stgolabs.net
Subject: [PATCH v2 3/3] cxl/test: Add support for qos_class checking
Date: Tue, 30 Jan 2024 15:29:05 -0700
Message-ID: <20240130222905.946109-3-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240130222905.946109-1-dave.jiang@intel.com>
References: <20240130222905.946109-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set a fake qos_class to a unique value in order to do simple testing of
qos_class for root decoders and mem devs via user cxl_test. A mock
function is added to set the fake qos_class values for memory device
and overrides cxl_endpoint_parse_cdat() in cxl driver code.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/cxl/Kbuild      |  1 +
 tools/testing/cxl/test/cxl.c  | 63 ++++++++++++++++++++++++++++++-----
 tools/testing/cxl/test/mock.c | 14 ++++++++
 tools/testing/cxl/test/mock.h |  1 +
 4 files changed, 70 insertions(+), 9 deletions(-)

diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 0b12c36902d8..c3eb6e24bdd9 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -13,6 +13,7 @@ ldflags-y += --wrap=cxl_hdm_decode_init
 ldflags-y += --wrap=cxl_dvsec_rr_decode
 ldflags-y += --wrap=devm_cxl_add_rch_dport
 ldflags-y += --wrap=cxl_rcd_component_reg_phys
+ldflags-y += --wrap=cxl_endpoint_parse_cdat
 
 DRIVERS := ../../../drivers
 CXL_SRC := $(DRIVERS)/cxl
diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index a3cdbb2be038..59dc28bfcb5e 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -15,6 +15,8 @@
 
 static int interleave_arithmetic;
 
+#define FAKE_QTG_ID	42
+
 #define NR_CXL_HOST_BRIDGES 2
 #define NR_CXL_SINGLE_HOST 1
 #define NR_CXL_RCH 1
@@ -209,7 +211,7 @@ static struct {
 			.granularity = 4,
 			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
 					ACPI_CEDT_CFMWS_RESTRICT_VOLATILE,
-			.qtg_id = 0,
+			.qtg_id = FAKE_QTG_ID,
 			.window_size = SZ_256M * 4UL,
 		},
 		.target = { 0 },
@@ -224,7 +226,7 @@ static struct {
 			.granularity = 4,
 			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
 					ACPI_CEDT_CFMWS_RESTRICT_VOLATILE,
-			.qtg_id = 1,
+			.qtg_id = FAKE_QTG_ID,
 			.window_size = SZ_256M * 8UL,
 		},
 		.target = { 0, 1, },
@@ -239,7 +241,7 @@ static struct {
 			.granularity = 4,
 			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
 					ACPI_CEDT_CFMWS_RESTRICT_PMEM,
-			.qtg_id = 2,
+			.qtg_id = FAKE_QTG_ID,
 			.window_size = SZ_256M * 4UL,
 		},
 		.target = { 0 },
@@ -254,7 +256,7 @@ static struct {
 			.granularity = 4,
 			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
 					ACPI_CEDT_CFMWS_RESTRICT_PMEM,
-			.qtg_id = 3,
+			.qtg_id = FAKE_QTG_ID,
 			.window_size = SZ_256M * 8UL,
 		},
 		.target = { 0, 1, },
@@ -269,7 +271,7 @@ static struct {
 			.granularity = 4,
 			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
 					ACPI_CEDT_CFMWS_RESTRICT_PMEM,
-			.qtg_id = 4,
+			.qtg_id = FAKE_QTG_ID,
 			.window_size = SZ_256M * 4UL,
 		},
 		.target = { 2 },
@@ -284,7 +286,7 @@ static struct {
 			.granularity = 4,
 			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
 					ACPI_CEDT_CFMWS_RESTRICT_VOLATILE,
-			.qtg_id = 5,
+			.qtg_id = FAKE_QTG_ID,
 			.window_size = SZ_256M,
 		},
 		.target = { 3 },
@@ -301,7 +303,7 @@ static struct {
 			.granularity = 4,
 			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
 					ACPI_CEDT_CFMWS_RESTRICT_PMEM,
-			.qtg_id = 0,
+			.qtg_id = FAKE_QTG_ID,
 			.window_size = SZ_256M * 8UL,
 		},
 		.target = { 0, },
@@ -317,7 +319,7 @@ static struct {
 			.granularity = 0,
 			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
 					ACPI_CEDT_CFMWS_RESTRICT_PMEM,
-			.qtg_id = 1,
+			.qtg_id = FAKE_QTG_ID,
 			.window_size = SZ_256M * 8UL,
 		},
 		.target = { 0, 1, },
@@ -333,7 +335,7 @@ static struct {
 			.granularity = 0,
 			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
 					ACPI_CEDT_CFMWS_RESTRICT_PMEM,
-			.qtg_id = 0,
+			.qtg_id = FAKE_QTG_ID,
 			.window_size = SZ_256M * 16UL,
 		},
 		.target = { 0, 1, 0, 1, },
@@ -976,6 +978,48 @@ static int mock_cxl_port_enumerate_dports(struct cxl_port *port)
 	return 0;
 }
 
+/*
+ * Faking the cxl_dpa_perf for the memdev when appropriate.
+ */
+static void dpa_perf_setup(struct cxl_port *endpoint, struct range *range,
+			   struct cxl_dpa_perf *dpa_perf)
+{
+	dpa_perf->qos_class = FAKE_QTG_ID;
+	dpa_perf->dpa_range = *range;
+	dpa_perf->coord.read_latency = 500;
+	dpa_perf->coord.write_latency = 500;
+	dpa_perf->coord.read_bandwidth = 1000;
+	dpa_perf->coord.write_bandwidth = 1000;
+}
+
+static void mock_cxl_endpoint_parse_cdat(struct cxl_port *port)
+{
+	struct cxl_root *cxl_root __free(put_cxl_root) =
+		find_cxl_root(port);
+	struct cxl_memdev *cxlmd = to_cxl_memdev(port->uport_dev);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
+	struct range pmem_range = {
+		.start = cxlds->pmem_res.start,
+		.end = cxlds->pmem_res.end,
+	};
+	struct range ram_range = {
+		.start = cxlds->ram_res.start,
+		.end = cxlds->ram_res.end,
+	};
+
+	if (!cxl_root)
+		return;
+
+	if (range_len(&ram_range))
+		dpa_perf_setup(port, &ram_range, &mds->ram_perf);
+
+	if (range_len(&pmem_range))
+		dpa_perf_setup(port, &pmem_range, &mds->pmem_perf);
+
+	cxl_memdev_update_attribute_groups(cxlmd);
+}
+
 static struct cxl_mock_ops cxl_mock_ops = {
 	.is_mock_adev = is_mock_adev,
 	.is_mock_bridge = is_mock_bridge,
@@ -989,6 +1033,7 @@ static struct cxl_mock_ops cxl_mock_ops = {
 	.devm_cxl_setup_hdm = mock_cxl_setup_hdm,
 	.devm_cxl_add_passthrough_decoder = mock_cxl_add_passthrough_decoder,
 	.devm_cxl_enumerate_decoders = mock_cxl_enumerate_decoders,
+	.cxl_endpoint_parse_cdat = mock_cxl_endpoint_parse_cdat,
 	.list = LIST_HEAD_INIT(cxl_mock_ops.list),
 };
 
diff --git a/tools/testing/cxl/test/mock.c b/tools/testing/cxl/test/mock.c
index 1a61e68e3095..6f737941dc0e 100644
--- a/tools/testing/cxl/test/mock.c
+++ b/tools/testing/cxl/test/mock.c
@@ -285,6 +285,20 @@ resource_size_t __wrap_cxl_rcd_component_reg_phys(struct device *dev,
 }
 EXPORT_SYMBOL_NS_GPL(__wrap_cxl_rcd_component_reg_phys, CXL);
 
+void __wrap_cxl_endpoint_parse_cdat(struct cxl_port *port)
+{
+	int index;
+	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
+	struct cxl_memdev *cxlmd = to_cxl_memdev(port->uport_dev);
+
+	if (ops && ops->is_mock_dev(cxlmd->dev.parent))
+		ops->cxl_endpoint_parse_cdat(port);
+	else
+		cxl_endpoint_parse_cdat(port);
+	put_cxl_mock_ops(index);
+}
+EXPORT_SYMBOL_NS_GPL(__wrap_cxl_endpoint_parse_cdat, CXL);
+
 MODULE_LICENSE("GPL v2");
 MODULE_IMPORT_NS(ACPI);
 MODULE_IMPORT_NS(CXL);
diff --git a/tools/testing/cxl/test/mock.h b/tools/testing/cxl/test/mock.h
index a94223750346..d1b0271d2822 100644
--- a/tools/testing/cxl/test/mock.h
+++ b/tools/testing/cxl/test/mock.h
@@ -25,6 +25,7 @@ struct cxl_mock_ops {
 	int (*devm_cxl_add_passthrough_decoder)(struct cxl_port *port);
 	int (*devm_cxl_enumerate_decoders)(
 		struct cxl_hdm *hdm, struct cxl_endpoint_dvsec_info *info);
+	void (*cxl_endpoint_parse_cdat)(struct cxl_port *port);
 };
 
 void register_cxl_mock_ops(struct cxl_mock_ops *ops);
-- 
2.43.0

