Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 990BF21E43B57
 for <linux-nvdimm@lists.01.org>; Fri, 22 Sep 2017 00:45:46 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id D9E12AC0146
 for <linux-nvdimm@lists.01.org>;
 Fri, 22 Sep 2017 16:48:49 +0900 (JST)
Date: Fri, 22 Sep 2017 16:48:38 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH v4 3/3] acpi nfit: nfit_test supports translate SPA
In-Reply-To: <20170922164440.4A35.E1E9C6FF@jp.fujitsu.com>
References: <20170922164440.4A35.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170922164834.4A3E.E1E9C6FF@jp.fujitsu.com>
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
To: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

To test ndctl list which use interface of Translate SPA,
nfit_test needs to emulates it.
This test module searches region which includes SPA and
returns 1 dimm handle which is last one.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 tools/testing/nvdimm/test/nfit.c | 104 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 103 insertions(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index d20791c..29c0dfe 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -342,6 +342,84 @@ static int nfit_test_cmd_clear_error(struct nd_cmd_clear_error *clear_err,
 	return 0;
 }
 
+struct region_search_spa {
+	u64 addr;
+	struct nd_region *region;
+};
+
+static int is_region_device(struct device *dev)
+{
+	return !strncmp(dev->kobj.name, "region", 6);
+}
+
+static int nfit_test_search_region_spa(struct device *dev, void *data)
+{
+	struct region_search_spa *ctx = data;
+	struct nd_region *nd_region;
+	resource_size_t ndr_end;
+
+	if (!is_region_device(dev))
+		return 0;
+
+	nd_region = to_nd_region(dev);
+	ndr_end = nd_region->ndr_start + nd_region->ndr_size;
+
+	if (ctx->addr >= nd_region->ndr_start && ctx->addr < ndr_end) {
+		ctx->region = nd_region;
+		return 1;
+	}
+
+	return 0;
+}
+
+static int nfit_test_search_spa(struct nvdimm_bus *bus,
+		struct nd_cmd_translate_spa *spa)
+{
+	int ret;
+	struct nd_region *nd_region = NULL;
+	struct nvdimm *nvdimm = NULL;
+	struct nd_mapping *nd_mapping = NULL;
+	struct region_search_spa ctx = {
+		.addr = spa->spa,
+		.region = NULL,
+	};
+	u64 dpa;
+
+	ret = device_for_each_child(&bus->dev, &ctx,
+				nfit_test_search_region_spa);
+
+	if (!ret)
+		return -ENODEV;
+
+	nd_region = ctx.region;
+
+	dpa = ctx.addr - nd_region->ndr_start;
+
+	/*
+	 * last dimm is selected for test
+	 */
+	nd_mapping = &nd_region->mapping[nd_region->ndr_mappings - 1];
+	nvdimm = nd_mapping->nvdimm;
+
+	spa->devices[0].nfit_device_handle = handle[nvdimm->id];
+	spa->num_nvdimms = 1;
+	spa->devices[0].dpa = dpa;
+
+	return 0;
+}
+
+static int nfit_test_cmd_translate_spa(struct nvdimm_bus *bus,
+		struct nd_cmd_translate_spa *spa, unsigned int buf_len)
+{
+	if (buf_len < spa->translate_length)
+		return -EINVAL;
+
+	if (nfit_test_search_spa(bus, spa) < 0 || !spa->num_nvdimms)
+		spa->status = 2;
+
+	return 0;
+}
+
 static int nfit_test_cmd_smart(struct nd_cmd_smart *smart, unsigned int buf_len)
 {
 	static const struct nd_smart_payload smart_data = {
@@ -449,6 +527,26 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		}
 	} else {
 		struct ars_state *ars_state = &t->ars_state;
+		struct nd_cmd_pkg *call_pkg = buf;
+
+		if (!nd_desc)
+			return -ENOTTY;
+
+		if (cmd == ND_CMD_CALL) {
+			func = call_pkg->nd_command;
+
+			buf_len = call_pkg->nd_size_in + call_pkg->nd_size_out;
+			buf = (void *) call_pkg->nd_payload;
+
+			switch (func) {
+			case NFIT_CMD_TRANSLATE_SPA:
+				rc = nfit_test_cmd_translate_spa(
+					acpi_desc->nvdimm_bus, buf, buf_len);
+				return rc;
+			default:
+				return -ENOTTY;
+			}
+		}
 
 		if (!nd_desc || !test_bit(cmd, &nd_desc->cmd_mask))
 			return -ENOTTY;
@@ -1430,7 +1528,9 @@ static void nfit_test0_setup(struct nfit_test *t)
 	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_cmd_force_en);
 	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_cmd_force_en);
 	set_bit(ND_CMD_CLEAR_ERROR, &acpi_desc->bus_cmd_force_en);
+	set_bit(ND_CMD_CALL, &acpi_desc->bus_cmd_force_en);
 	set_bit(ND_CMD_SMART_THRESHOLD, &acpi_desc->dimm_cmd_force_en);
+	set_bit(NFIT_CMD_TRANSLATE_SPA, &acpi_desc->bus_nfit_cmd_force_en);
 }
 
 static void nfit_test1_setup(struct nfit_test *t)
@@ -1616,10 +1716,12 @@ static int nfit_ctl_test(struct device *dev)
 			.cmd_mask = 1UL << ND_CMD_ARS_CAP
 				| 1UL << ND_CMD_ARS_START
 				| 1UL << ND_CMD_ARS_STATUS
-				| 1UL << ND_CMD_CLEAR_ERROR,
+				| 1UL << ND_CMD_CLEAR_ERROR
+				| 1UL << ND_CMD_CALL,
 			.module = THIS_MODULE,
 			.provider_name = "ACPI.NFIT",
 			.ndctl = acpi_nfit_ctl,
+			.bus_dsm_mask = 1UL << NFIT_CMD_TRANSLATE_SPA,
 		},
 		.dev = &adev->dev,
 	};



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
