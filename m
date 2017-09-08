Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82E4121E8796E
 for <linux-nvdimm@lists.01.org>; Fri,  8 Sep 2017 16:42:00 -0700 (PDT)
Subject: [ndctl PATCH 1/2] ndctl: match new library symbols to their version
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 08 Sep 2017 16:38:26 -0700
Message-ID: <150491390688.35962.11854315078014907861.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

We should have been doing this from the beginning for new symbols, but
no time like the present to start.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.sym |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 5a73a42f5030..8a1111672334 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -36,8 +36,6 @@ global:
 	ndctl_bus_get_provider;
 	ndctl_bus_get_ctx;
 	ndctl_bus_wait_probe;
-	ndctl_bus_get_region_by_physical_address;
-	ndctl_bus_get_dimm_by_physical_address;
 	ndctl_dimm_get_first;
 	ndctl_dimm_get_next;
 	ndctl_dimm_get_handle;
@@ -115,11 +113,7 @@ global:
 	ndctl_cmd_smart_threshold_get_temperature;
 	ndctl_cmd_smart_threshold_get_spares;
 	ndctl_dimm_zero_labels;
-	ndctl_dimm_read_labels;
-	ndctl_dimm_validate_labels;
-	ndctl_dimm_init_labels;
 	ndctl_dimm_get_available_labels;
-	ndctl_dimm_sizeof_namespace_label;
 	ndctl_region_get_first;
 	ndctl_region_get_next;
 	ndctl_region_get_id;
@@ -163,7 +157,6 @@ global:
 	ndctl_mapping_get_region;
 	ndctl_mapping_get_offset;
 	ndctl_mapping_get_length;
-	ndctl_mapping_get_position;
 	ndctl_namespace_get_first;
 	ndctl_namespace_get_next;
 	ndctl_namespace_get_ctx;
@@ -176,8 +169,6 @@ global:
 	ndctl_namespace_get_devname;
 	ndctl_namespace_get_block_device;
 	ndctl_namespace_get_mode;
-	ndctl_namespace_set_enforce_mode;
-	ndctl_namespace_get_enforce_mode;
 	ndctl_region_get_nstype;
 	ndctl_namespace_get_type;
 	ndctl_namespace_get_type_name;
@@ -289,3 +280,16 @@ global:
 	ndctl_dax_is_configured;
 	ndctl_dax_get_daxctl_region;
 } LIBNDCTL_1;
+
+LIBNDCTL_13 {
+global:
+	ndctl_bus_get_region_by_physical_address;
+	ndctl_bus_get_dimm_by_physical_address;
+	ndctl_dimm_read_labels;
+	ndctl_dimm_validate_labels;
+	ndctl_dimm_init_labels;
+	ndctl_dimm_sizeof_namespace_label;
+	ndctl_mapping_get_position;
+	ndctl_namespace_set_enforce_mode;
+	ndctl_namespace_get_enforce_mode;
+} LIBNDCTL_3;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
