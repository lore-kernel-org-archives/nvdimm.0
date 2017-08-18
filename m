Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4D2A21E79038
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 21:47:58 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 9F8BEAC00FD
 for <linux-nvdimm@lists.01.org>; Fri, 18 Aug 2017 13:50:19 +0900 (JST)
Date: Fri, 18 Aug 2017 13:50:16 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH 3/3] acpi nfit: nfit_test supports translate SPA
In-Reply-To: <20170818134627.8EBC.E1E9C6FF@jp.fujitsu.com>
References: <20170818134627.8EBC.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170818135014.8EC5.E1E9C6FF@jp.fujitsu.com>
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


nfit_test supports translate SPA

To test ndctl list which use interface of Translate SPA,
nfit_test needs to emulates it.
This test module searches region which includes SPA and 
returns 1 dimm handle which is last one.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 drivers/nvdimm/region_devs.c     |  1 +
 tools/testing/nvdimm/test/nfit.c | 98 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 5954cfb..3c8cc7f 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -162,6 +162,7 @@ bool is_nd_pmem(struct device *dev)
 {
 	return dev ? dev->type == &nd_pmem_device_type : false;
 }
+EXPORT_SYMBOL_GPL(is_nd_pmem);
 
 bool is_nd_blk(struct device *dev)
 {
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 4c2fa98..426d1fa 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -342,6 +342,78 @@ static int nfit_test_cmd_clear_error(struct nd_cmd_clear_error *clear_err,
 	return 0;
 }
 
+struct region_search_spa{
+	u64 addr;
+	struct nd_region *region;
+};
+
+static int nfit_test_search_region_spa(struct device *dev, void *data)
+{
+	struct region_search_spa *ctx = data;
+	struct nd_region *nd_region;
+	resource_size_t ndr_end;
+
+	if (!is_nd_pmem(dev))
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
+static int nfit_test_search_spa(struct nvdimm_bus *bus, struct nd_cmd_trans_spa *spa)
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
+	ret = device_for_each_child(&bus->dev, &ctx, nfit_test_search_region_spa);
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
+static int nfit_test_cmd_translate_spa(struct nvdimm_bus *bus, struct nd_cmd_trans_spa *spa,
+				unsigned int buf_len)
+{
+
+	if (buf_len < spa->trans_length)
+		return -EINVAL;
+
+	if (nfit_test_search_spa(bus, spa) < 0|| !spa->num_nvdimms)
+		spa->status = 2;
+
+	return 0;
+}
+
 static int nfit_test_cmd_smart(struct nd_cmd_smart *smart, unsigned int buf_len)
 {
 	static const struct nd_smart_payload smart_data = {
@@ -449,6 +521,26 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
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
+				rc = nfit_test_cmd_translate_spa(acpi_desc->nvdimm_bus,
+							buf, buf_len);
+				return rc;
+			default:
+				return -ENOTTY;
+			}
+		}
 
 		if (!nd_desc || !test_bit(cmd, &nd_desc->cmd_mask))
 			return -ENOTTY;
@@ -1430,7 +1522,9 @@ static void nfit_test0_setup(struct nfit_test *t)
 	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_cmd_force_en);
 	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_cmd_force_en);
 	set_bit(ND_CMD_CLEAR_ERROR, &acpi_desc->bus_cmd_force_en);
+	set_bit(ND_CMD_CALL, &acpi_desc->bus_cmd_force_en);
 	set_bit(ND_CMD_SMART_THRESHOLD, &acpi_desc->dimm_cmd_force_en);
+	set_bit(NFIT_CMD_TRANSLATE_SPA, &acpi_desc->bus_sub_cmd_force_en);
 }
 
 static void nfit_test1_setup(struct nfit_test *t)
@@ -1616,10 +1710,12 @@ static int nfit_ctl_test(struct device *dev)
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
