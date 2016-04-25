Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id A6DE61A1ED1
 for <linux-nvdimm@lists.01.org>; Mon, 25 Apr 2016 12:51:04 -0700 (PDT)
Subject: [ndctl PATCH 5/7] ndctl: fix to_dsm_index() static analysis warning
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Apr 2016 12:50:15 -0700
Message-ID: <146161381575.21779.8108705781017518591.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Static analysis tools don't like the fact that we do multiple
overwriting assignments to a variable.  Use IS_ENABLED() to clean this
up.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 lib/libndctl-private.h |   15 +++++++++++++++
 lib/libndctl.c         |   10 +++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/lib/libndctl-private.h b/lib/libndctl-private.h
index cbb0ed9f76b5..a0a36885b160 100644
--- a/lib/libndctl-private.h
+++ b/lib/libndctl-private.h
@@ -177,6 +177,21 @@ struct ndctl_cmd {
 	};
 };
 
+/* internal library helpers for conditionally defined command numbers */
+#ifdef HAVE_NDCTL_ARS
+static const int nd_cmd_ars_status = ND_CMD_ARS_STATUS;
+static const int nd_cmd_ars_cap = ND_CMD_ARS_CAP;
+#else
+static const int nd_cmd_ars_status;
+static const int nd_cmd_ars_cap;
+#endif
+
+#ifdef HAVE_NDCTL_CLEAR_ERROR
+static const int nd_cmd_clear_error = ND_CMD_CLEAR_ERROR;
+#else
+static const int nd_cmd_clear_error;
+#endif
+
 static inline struct ndctl_bus *cmd_to_bus(struct ndctl_cmd *cmd)
 {
 	if (cmd->dimm)
diff --git a/lib/libndctl.c b/lib/libndctl.c
index 1014da2aa8a9..5c2894d6b82e 100644
--- a/lib/libndctl.c
+++ b/lib/libndctl.c
@@ -813,13 +813,9 @@ static int to_dsm_index(const char *name, int dimm)
 		end_cmd = ND_CMD_VENDOR;
 		cmd_name_fn = nvdimm_cmd_name;
 	} else {
-		end_cmd = 0;
-#ifdef HAVE_NDCTL_ARS
-		end_cmd = ND_CMD_ARS_STATUS;
-#endif
-#ifdef HAVE_NDCTL_CLEAR_ERROR
-		end_cmd = ND_CMD_CLEAR_ERROR;
-#endif
+		end_cmd = nd_cmd_clear_error;
+		if (!end_cmd)
+			end_cmd = nd_cmd_ars_status;
 		cmd_name_fn = nvdimm_bus_cmd_name;
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
