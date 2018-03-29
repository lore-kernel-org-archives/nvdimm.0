Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 81CCF224DD133
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 15:30:28 -0700 (PDT)
Subject: [PATCH 1/4] acpi: add find error record in BERT function
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 29 Mar 2018 15:37:07 -0700
Message-ID: <152236302712.35558.17322719540329044966.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <152236282506.35558.2067249639136170490.stgit@djiang5-desk3.ch.intel.com>
References: <152236282506.35558.2067249639136170490.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: tony.luck@intel.com, linux-nvdimm@lists.01.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org, Ying Huang <ying.huang@intel.com>, lenb@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Adding helper function for searching through BERT records and matching
memory based errors that matches in the given resource range given. A
callback function is passed in from the caller to process the matched
memory records. This is in preparation for adding bad memory ranges
fir nvdimm from the BERT.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Cc: Ying Huang <ying.huang@intel.com>
---
 drivers/acpi/apei/bert.c |  137 ++++++++++++++++++++++++++++++++++++++++++----
 include/linux/acpi.h     |   10 +++
 2 files changed, 134 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/apei/bert.c b/drivers/acpi/apei/bert.c
index 12771fcf0417..9569c15bd616 100644
--- a/drivers/acpi/apei/bert.c
+++ b/drivers/acpi/apei/bert.c
@@ -26,6 +26,7 @@
 #include <linux/init.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
+#include <acpi/ghes.h>
 
 #include "apei-internal.h"
 
@@ -34,33 +35,36 @@
 
 static int bert_disable;
 
-static void __init bert_print_all(struct acpi_bert_region *region,
-				  unsigned int region_len)
+static int bert_process_region(struct acpi_bert_region *region,
+		unsigned int region_len,
+		int (*process)(struct acpi_hest_generic_status *estatus,
+			void *data), void *data)
 {
 	struct acpi_hest_generic_status *estatus =
 		(struct acpi_hest_generic_status *)region;
 	int remain = region_len;
 	u32 estatus_len;
+	int rc;
 
 	if (!estatus->block_status)
-		return;
+		return -ENXIO;
 
 	while (remain > sizeof(struct acpi_bert_region)) {
 		if (cper_estatus_check(estatus)) {
 			pr_err(FW_BUG "Invalid error record.\n");
-			return;
+			return -ENXIO;
 		}
 
 		estatus_len = cper_estatus_len(estatus);
 		if (remain < estatus_len) {
-			pr_err(FW_BUG "Truncated status block (length: %u).\n",
-			       estatus_len);
-			return;
+			pr_err(FW_BUG "Truncated status block (len: %u).\n",
+					estatus_len);
+			return -ENXIO;
 		}
 
-		pr_info_once("Error records from previous boot:\n");
-
-		cper_estatus_print(KERN_INFO HW_ERR, estatus);
+		rc = process(estatus, data);
+		if (rc < 0)
+			return rc;
 
 		/*
 		 * Because the boot error source is "one-time polled" type,
@@ -72,10 +76,22 @@ static void __init bert_print_all(struct acpi_bert_region *region,
 		estatus = (void *)estatus + estatus_len;
 		/* No more error records. */
 		if (!estatus->block_status)
-			return;
+			return -ENXIO;
 
 		remain -= estatus_len;
 	}
+
+	return 0;
+}
+
+static int __init bert_print(struct acpi_hest_generic_status *estatus,
+		void *data)
+{
+	pr_info_once("Error records from previous boot:\n");
+
+	cper_estatus_print(KERN_INFO HW_ERR, estatus);
+
+	return 0;
 }
 
 static int __init setup_bert_disable(char *str)
@@ -86,7 +102,7 @@ static int __init setup_bert_disable(char *str)
 }
 __setup("bert_disable", setup_bert_disable);
 
-static int __init bert_check_table(struct acpi_table_bert *bert_tab)
+static int bert_check_table(struct acpi_table_bert *bert_tab)
 {
 	if (bert_tab->header.length < sizeof(struct acpi_table_bert) ||
 	    bert_tab->region_length < sizeof(struct acpi_bert_region))
@@ -138,7 +154,8 @@ static int __init bert_init(void)
 		goto out_fini;
 	boot_error_region = ioremap_cache(bert_tab->address, region_len);
 	if (boot_error_region) {
-		bert_print_all(boot_error_region, region_len);
+		bert_process_region(boot_error_region, region_len,
+				bert_print, NULL);
 		iounmap(boot_error_region);
 	} else {
 		rc = -ENOMEM;
@@ -152,3 +169,97 @@ static int __init bert_init(void)
 }
 
 late_initcall(bert_init);
+
+struct mem_err_cb_ctx
+{
+	void (*cb)(void *data, u64 addr, u64 len);
+	void *data;
+	u64 addr;
+	u64 len;
+};
+
+static int bert_process_mem_err(struct acpi_hest_generic_status *estatus,
+		void *data)
+{
+	struct mem_err_cb_ctx *ctx = data;
+	u16 severity;
+	u64 end = ctx->addr + ctx->len - 1;
+	struct acpi_hest_generic_data *gdata;
+	int found = 0;
+
+	severity = estatus->error_severity;
+	if (severity != CPER_SEV_CORRECTED) {
+		apei_estatus_for_each_section(estatus, gdata) {
+			guid_t *sec_type =
+				(guid_t *)gdata->section_type;
+			struct cper_sec_mem_err *mem_err =
+				acpi_hest_get_payload(gdata);
+
+			if (!guid_equal(sec_type,
+					&CPER_SEC_PLATFORM_MEM))
+				continue;
+
+			if (!(mem_err->validation_bits &
+					CPER_MEM_VALID_PA))
+				continue;
+
+			if (ctx->addr > mem_err->physical_addr ||
+				end < mem_err->physical_addr)
+				continue;
+
+			ctx->cb(ctx->data, mem_err->physical_addr,
+					L1_CACHE_BYTES);
+			found++;
+		}
+	}
+
+	return found;
+}
+
+int bert_find_mem_error_record(void (*cb)(void *data, u64 addr, u64 len),
+		void *data, u64 addr, u64 len)
+{
+	acpi_status status;
+	int rc;
+	unsigned int region_len;
+	struct acpi_bert_region *bert_region;
+	struct acpi_table_bert *bert_tab;
+	struct mem_err_cb_ctx ctx = {
+		.cb = cb,
+		.data = data,
+		.addr = addr,
+		.len = len,
+	};
+
+	if (acpi_disabled)
+		return 0;
+
+	status = acpi_get_table(ACPI_SIG_BERT, 0,
+			(struct acpi_table_header **)&bert_tab);
+	if (status == AE_NOT_FOUND)
+		return 0;
+
+	if (ACPI_FAILURE(status))
+		return -EINVAL;
+
+	rc = bert_check_table(bert_tab);
+	if (rc)
+		return rc;
+
+	region_len = bert_tab->region_length;
+	bert_region = acpi_os_map_memory(bert_tab->address, region_len);
+	if (!bert_region) {
+		rc = -ENOMEM;
+		goto put_table;
+	}
+
+	rc = bert_process_region(bert_region, region_len,
+				bert_process_mem_err, &ctx);
+
+	acpi_os_unmap_memory(bert_region, region_len);
+put_table:
+	acpi_put_table((struct acpi_table_header *)bert_tab);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(bert_find_mem_error_record);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 968173ec2726..57ed7b39f386 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1146,6 +1146,10 @@ int __acpi_probe_device_table(struct acpi_probe_entry *start, int nr);
 					  (&ACPI_PROBE_TABLE_END(t) -	\
 					   &ACPI_PROBE_TABLE(t)));	\
 	})
+
+int bert_find_mem_error_record(
+		void (*cb)(void *data, u64 addr, u64 len),
+		void *data, u64 addr, u64 len);
 #else
 static inline int acpi_dev_get_property(struct acpi_device *adev,
 					const char *name, acpi_object_type type,
@@ -1247,6 +1251,12 @@ acpi_graph_get_remote_endpoint(const struct fwnode_handle *fwnode,
 		     (void *) data }
 
 #define acpi_probe_device_table(t)	({ int __r = 0; __r;})
+int bert_find_mem_error_record(
+		void (*cb)(void *data, u64 addr, u64 len),
+		void *data, u64 addr, u64 len)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #ifdef CONFIG_ACPI_TABLE_UPGRADE

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
