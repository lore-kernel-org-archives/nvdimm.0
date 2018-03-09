Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5DD1B220C2A6A
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 15:12:27 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] libndctl.sym: move new interfaces since v59 to a nee
 section
Date: Fri,  9 Mar 2018 16:18:40 -0700
Message-Id: <20180309231840.16228-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Since we're adding new interfaces, the libndctl 'current' will change to
'15'. Add a corresponding section in libndctl.sym, and move the new
symbols to it.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.sym | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 6de1e0b..2127661 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -339,11 +339,15 @@ global:
 	ndctl_cmd_fw_info_get_query_interval;
 	ndctl_cmd_fw_info_get_max_query_time;
 	ndctl_cmd_fw_info_get_run_version;
-	ndctl_cmd_fw_info_get_next_version;
 	ndctl_cmd_fw_start_get_context;
 	ndctl_cmd_fw_fquery_get_fw_rev;
 	ndctl_cmd_fw_xlat_firmware_status;
+} LIBNDCTL_13;
+
+LIBNDCTL_15 {
+global:
+	ndctl_cmd_fw_info_get_next_version;
 	ndctl_dimm_cmd_new_ack_shutdown_count;
 	ndctl_region_get_numa_node;
 	ndctl_dimm_fw_update_supported;
-} LIBNDCTL_13;
+} LIBNDCTL_14;
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
