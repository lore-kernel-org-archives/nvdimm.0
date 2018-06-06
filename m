Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D024A211E3708
 for <linux-nvdimm@lists.01.org>; Tue,  5 Jun 2018 17:00:45 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: add an api for getting ars_status flags
Date: Tue,  5 Jun 2018 18:00:34 -0600
Message-Id: <20180606000034.12161-1-vishal.l.verma@intel.com>
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
Cc: Jacek Zloch <jacek.zloch@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The ARS status command defines a 'flags' field that wasn't being exposed
via an API yet. Add a new ndctl_cmd_ars_get_flags() helper to retrieve
this field.

Reported-by: Jacek Zloch <jacek.zloch@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/ars.c        | 10 ++++++++++
 ndctl/lib/libndctl.sym |  1 +
 ndctl/libndctl.h       |  1 +
 3 files changed, 12 insertions(+)

diff --git a/ndctl/lib/ars.c b/ndctl/lib/ars.c
index e04b51e..b0a7ae6 100644
--- a/ndctl/lib/ars.c
+++ b/ndctl/lib/ars.c
@@ -269,6 +269,16 @@ NDCTL_EXPORT unsigned long long ndctl_cmd_ars_get_record_len(
 	return ars_stat->ars_status->records[rec_index].length;
 }
 
+NDCTL_EXPORT unsigned int ndctl_cmd_ars_get_flags(struct ndctl_cmd *ars_stat)
+{
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(cmd_to_bus(ars_stat));
+
+	if (!validate_ars_stat(ctx, ars_stat))
+		return 0;
+
+	return ars_stat->ars_status->flags;
+}
+
 NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(
 		unsigned long long address, unsigned long long len,
 		struct ndctl_cmd *ars_cap)
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index c1228e5..9940c7a 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -365,4 +365,5 @@ global:
 	ndctl_cmd_ars_cap_get_clear_unit;
 	ndctl_namespace_inject_error2;
 	ndctl_namespace_uninject_error2;
+	ndctl_cmd_ars_get_flags;
 } LIBNDCTL_15;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index be997ac..99218e6 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -210,6 +210,7 @@ struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(unsigned long long address,
 unsigned long long ndctl_cmd_clear_error_get_cleared(
 		struct ndctl_cmd *clear_err);
 unsigned int ndctl_cmd_ars_cap_get_clear_unit(struct ndctl_cmd *ars_cap);
+unsigned int ndctl_cmd_ars_get_flags(struct ndctl_cmd *ars_stat);
 
 /*
  * Note: ndctl_cmd_smart_get_temperature is an alias for
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
