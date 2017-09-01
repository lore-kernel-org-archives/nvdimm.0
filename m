Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2013421EB88C3
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 06:14:56 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id A5CE7AC03CD
 for <linux-nvdimm@lists.01.org>;
 Fri,  1 Sep 2017 22:17:34 +0900 (JST)
Date: Fri, 01 Sep 2017 22:17:22 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [ndctl PATCH 2/5] ndctl: make interface to read device/nfit/dsm_mask
In-Reply-To: <20170901221335.C27F.E1E9C6FF@jp.fujitsu.com>
References: <20170901221335.C27F.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170901221719.C285.E1E9C6FF@jp.fujitsu.com>
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


To check what feature can be called via ND_CMD_CALL, ndctl need to read
device/nfit/dsm_mask.
Since direct pointer access is not permitted,
ndctl_bus_get_nfit_dsm_mask() is created to access nfit_dsm_mask.
It is used later patch.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 ndctl/lib/libndctl.c   | 16 ++++++++++++++++
 ndctl/lib/libndctl.sym |  1 +
 ndctl/libndctl.h.in    |  1 +
 3 files changed, 18 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index f52ecfe..ea37ca4 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -104,6 +104,7 @@ struct ndctl_bus {
 	size_t buf_len;
 	char *wait_probe_path;
 	unsigned long dsm_mask;
+	unsigned long nfit_dsm_mask;
 };
 
 /**
@@ -793,6 +794,12 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
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
@@ -1048,6 +1055,15 @@ NDCTL_EXPORT int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus,
 	return !!(bus->dsm_mask & (1ULL << cmd));
 }
 
+/*
+ * This function is exported for only nfit.c.
+ * Please use ndctl_bus_is_nfit_cmd_supported() in nfit.c instead.
+ */
+NDCTL_EXPORT unsigned long ndctl_bus_get_nfit_dsm_mask(struct ndctl_bus *bus)
+{
+	return bus->nfit_dsm_mask;
+}
+
 NDCTL_EXPORT unsigned int ndctl_bus_get_revision(struct ndctl_bus *bus)
 {
 	return bus->revision;
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 4c1773d..3f9bf09 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -30,6 +30,7 @@ global:
 	ndctl_bus_get_by_provider;
 	ndctl_bus_get_cmd_name;
 	ndctl_bus_is_cmd_supported;
+	ndctl_bus_get_nfit_dsm_mask;
 	ndctl_bus_has_nfit;
 	ndctl_bus_get_revision;
 	ndctl_bus_get_id;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 2bbda04..bfee693 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -109,6 +109,7 @@ struct ndctl_bus *ndctl_bus_get_by_provider(struct ndctl_ctx *ctx,
 		const char *provider);
 const char *ndctl_bus_get_cmd_name(struct ndctl_bus *bus, int cmd);
 int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus, int cmd);
+unsigned long ndctl_bus_get_nfit_dsm_mask(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_revision(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_id(struct ndctl_bus *bus);
 const char *ndctl_bus_get_provider(struct ndctl_bus *bus);



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
