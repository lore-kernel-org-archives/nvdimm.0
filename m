Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AF13C21A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:28:54 -0800 (PST)
Subject: [ndctl PATCH 07/17] ndctl, smart: cleanup smart_cmd_op() macro
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:25:07 -0800
Message-ID: <151217070734.28402.7251875689073860382.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Remove the redundant information passed to the smart_cmd_op macro.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/smart.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/ndctl/lib/smart.c b/ndctl/lib/smart.c
index 3eeb70e0d2b1..90c45a1a002e 100644
--- a/ndctl/lib/smart.c
+++ b/ndctl/lib/smart.c
@@ -40,8 +40,8 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart_threshold(
 		return NULL;
 }
 
-#define smart_cmd_op(name, op, rettype, defretvalue) \
-NDCTL_EXPORT rettype name(struct ndctl_cmd *cmd) \
+#define smart_cmd_op(op, rettype, defretvalue) \
+NDCTL_EXPORT rettype ndctl_cmd_##op(struct ndctl_cmd *cmd) \
 { \
 	if (cmd->dimm) { \
 		struct ndctl_smart_ops *ops = ndctl_dimm_get_smart_ops(cmd->dimm); \
@@ -51,21 +51,19 @@ NDCTL_EXPORT rettype name(struct ndctl_cmd *cmd) \
 	return defretvalue; \
 }
 
-smart_cmd_op(ndctl_cmd_smart_get_flags, smart_get_flags, unsigned int, 0)
-smart_cmd_op(ndctl_cmd_smart_get_health, smart_get_health, unsigned int, 0)
-smart_cmd_op(ndctl_cmd_smart_get_media_temperature, smart_get_media_temperature,
-		unsigned int, 0)
-smart_cmd_op(ndctl_cmd_smart_get_spares, smart_get_spares, unsigned int, 0)
-smart_cmd_op(ndctl_cmd_smart_get_alarm_flags, smart_get_alarm_flags, unsigned int, 0)
-smart_cmd_op(ndctl_cmd_smart_get_life_used, smart_get_life_used, unsigned int, 0)
-smart_cmd_op(ndctl_cmd_smart_get_shutdown_state, smart_get_shutdown_state, unsigned int, 0)
-smart_cmd_op(ndctl_cmd_smart_get_shutdown_count, smart_get_shutdown_count, unsigned int, 0)
-smart_cmd_op(ndctl_cmd_smart_get_vendor_size, smart_get_vendor_size, unsigned int, 0)
-smart_cmd_op(ndctl_cmd_smart_get_vendor_data, smart_get_vendor_data, unsigned char *, NULL)
-smart_cmd_op(ndctl_cmd_smart_threshold_get_alarm_control, smart_threshold_get_alarm_control, unsigned int, 0)
-smart_cmd_op(ndctl_cmd_smart_threshold_get_media_temperature,
-		smart_threshold_get_media_temperature, unsigned int, 0)
-smart_cmd_op(ndctl_cmd_smart_threshold_get_spares, smart_threshold_get_spares, unsigned int, 0)
+smart_cmd_op(smart_get_flags, unsigned int, 0)
+smart_cmd_op(smart_get_health, unsigned int, 0)
+smart_cmd_op(smart_get_media_temperature, unsigned int, 0)
+smart_cmd_op(smart_get_spares, unsigned int, 0)
+smart_cmd_op(smart_get_alarm_flags, unsigned int, 0)
+smart_cmd_op(smart_get_life_used, unsigned int, 0)
+smart_cmd_op(smart_get_shutdown_state, unsigned int, 0)
+smart_cmd_op(smart_get_shutdown_count, unsigned int, 0)
+smart_cmd_op(smart_get_vendor_size, unsigned int, 0)
+smart_cmd_op(smart_get_vendor_data, unsigned char *, NULL)
+smart_cmd_op(smart_threshold_get_alarm_control, unsigned int, 0)
+smart_cmd_op(smart_threshold_get_media_temperature, unsigned int, 0)
+smart_cmd_op(smart_threshold_get_spares, unsigned int, 0)
 
 NDCTL_EXPORT unsigned int ndctl_cmd_smart_get_temperature(struct ndctl_cmd *cmd)
 {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
