Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6326520958BE5
 for <linux-nvdimm@lists.01.org>; Wed,  6 Sep 2017 22:02:09 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 88FADAC019B
 for <linux-nvdimm@lists.01.org>; Thu,  7 Sep 2017 14:04:53 +0900 (JST)
Date: Thu, 07 Sep 2017 14:04:40 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [ndctl PATCH v5 2/5] ndctl: read device/nfit/dsm_mask
In-Reply-To: <20170907140049.7F71.E1E9C6FF@jp.fujitsu.com>
References: <20170907140049.7F71.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170907140436.7F77.E1E9C6FF@jp.fujitsu.com>
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

To check what feature can be called via ND_CMD_CALL, ndctl needs to read
device/nfit/dsm_mask.

To read it from ndctl/lib/nfit.c, ndctl_bus is moved to ndctl/lib/private.h.
This is used later patch.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 ndctl/lib/libndctl.c | 34 ++++++----------------------------
 ndctl/lib/private.h  | 30 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 4361cd8..6852137 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -77,34 +77,6 @@ NDCTL_EXPORT size_t ndctl_sizeof_namespace_label(void)
 }
 
 struct ndctl_ctx;
-/**
- * struct ndctl_bus - a nfit table instance
- * @major: control character device major number
- * @minor: control character device minor number
- * @revision: NFIT table revision number
- * @provider: identifier for the source of the NFIT table
- *
- * The expectation is one NFIT/nd bus per system provided by platform
- * firmware (for example @provider == "ACPI.NFIT").  However, the
- * nfit_test module provides multiple test busses with provider names of
- * the format "nfit_test.N"
- */
-struct ndctl_bus {
-	struct ndctl_ctx *ctx;
-	unsigned int id, major, minor, revision;
-	char *provider;
-	struct list_head dimms;
-	struct list_head regions;
-	struct list_node list;
-	int dimms_init;
-	int regions_init;
-	int has_nfit;
-	char *bus_path;
-	char *bus_buf;
-	size_t buf_len;
-	char *wait_probe_path;
-	unsigned long dsm_mask;
-};
 
 /**
  * struct ndctl_mapping - dimm extent relative to a region
@@ -793,6 +765,12 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
 		bus->revision = strtoul(buf, NULL, 0);
 	}
 
+	sprintf(path, "%s/device/nfit/dsm_mask", ctl_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		bus->nfit_dsm_mask = 0;
+	else
+		bus->nfit_dsm_mask = strtoul(buf, NULL, 0);
+
 	sprintf(path, "%s/device/provider", ctl_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 83a8067..aeedc03 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -127,6 +127,36 @@ struct ndctl_ctx {
 };
 
 /**
+ * struct ndctl_bus - a nfit table instance
+ * @major: control character device major number
+ * @minor: control character device minor number
+ * @revision: NFIT table revision number
+ * @provider: identifier for the source of the NFIT table
+ *
+ * The expectation is one NFIT/nd bus per system provided by platform
+ * firmware (for example @provider == "ACPI.NFIT").  However, the
+ * nfit_test module provides multiple test busses with provider names of
+ * the format "nfit_test.N"
+ */
+struct ndctl_bus {
+	struct ndctl_ctx *ctx;
+	unsigned int id, major, minor, revision;
+	char *provider;
+	struct list_head dimms;
+	struct list_head regions;
+	struct list_node list;
+	int dimms_init;
+	int regions_init;
+	int has_nfit;
+	char *bus_path;
+	char *bus_buf;
+	size_t buf_len;
+	char *wait_probe_path;
+	unsigned long dsm_mask;
+	unsigned long nfit_dsm_mask;
+};
+
+/**
  * struct ndctl_cmd - device-specific-method (_DSM ioctl) container
  * @dimm: set if the command is relative to a dimm, NULL otherwise
  * @bus: set if the command is relative to a bus (like ARS), NULL otherwise



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
