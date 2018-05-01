Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BEA76203B8BEA
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 11:00:32 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/4] libndctl, ars: add an API to retrieve clear_err_unit
Date: Tue,  1 May 2018 12:00:20 -0600
Message-Id: <20180501180023.30193-2-vishal.l.verma@intel.com>
In-Reply-To: <20180501180023.30193-1-vishal.l.verma@intel.com>
References: <20180501180023.30193-1-vishal.l.verma@intel.com>
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

The ars_cap command contains a field called clear_err_unit which is the
unit in which internal ARS related operations are carried out. In
preparation for the error injection reworks, provide an API to expose
this value to users.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/ars.c        | 15 +++++++++++++++
 ndctl/lib/libndctl.sym |  5 +++++
 ndctl/libndctl.h       |  1 +
 3 files changed, 21 insertions(+)

diff --git a/ndctl/lib/ars.c b/ndctl/lib/ars.c
index d53d898..1ff6cf7 100644
--- a/ndctl/lib/ars.c
+++ b/ndctl/lib/ars.c
@@ -180,6 +180,21 @@ NDCTL_EXPORT int ndctl_cmd_ars_cap_get_range(struct ndctl_cmd *ars_cap,
 	return -EINVAL;
 }
 
+NDCTL_EXPORT unsigned int ndctl_cmd_ars_cap_get_clear_unit(
+		struct ndctl_cmd *ars_cap)
+{
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(cmd_to_bus(ars_cap));
+
+	if (ars_cap->type == ND_CMD_ARS_CAP && ars_cap->status == 0) {
+		dbg(ctx, "clear_err_unit: %d\n",
+			ars_cap->ars_cap->clear_err_unit);
+		return ars_cap->ars_cap->clear_err_unit;
+	}
+
+	dbg(ctx, "invalid ars_cap\n");
+	return 0;
+}
+
 NDCTL_EXPORT int ndctl_cmd_ars_in_progress(struct ndctl_cmd *cmd)
 {
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(cmd_to_bus(cmd));
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 65e735f..92822be 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -359,3 +359,8 @@ global:
 	ndctl_bus_start_scrub;
 	ndctl_region_deep_flush;
 } LIBNDCTL_14;
+
+LIBNDCTL_16 {
+global:
+	ndctl_cmd_ars_cap_get_clear_unit;
+} LIBNDCTL_15;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 498ae19..74fe0f4 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -209,6 +209,7 @@ struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(unsigned long long address,
 		unsigned long long len, struct ndctl_cmd *ars_cap);
 unsigned long long ndctl_cmd_clear_error_get_cleared(
 		struct ndctl_cmd *clear_err);
+unsigned int ndctl_cmd_ars_cap_get_clear_unit(struct ndctl_cmd *ars_cap);
 
 /*
  * Note: ndctl_cmd_smart_get_temperature is an alias for
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
