Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D63821A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:28:47 -0800 (PST)
Subject: [ndctl PATCH 02/17] libndctl: add nfit_dsm_mask as a private dimm
 property
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:24:40 -0800
Message-ID: <151217068041.28402.15691057595823686329.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Lijun Pan <Lijun.Pan@dell.com>
List-ID: <linux-nvdimm@lists.01.org>

Validate vendor specific ACPI-defined command implementations against
the published dsm_mask.

Cc: Lijun Pan <Lijun.Pan@dell.com>
Cc: Jerry Hoemann <jerry.hoemann@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/hpe1.c     |   12 ++++++++++++
 ndctl/lib/libndctl.c |    5 +++++
 ndctl/lib/msft.c     |    5 +++++
 ndctl/lib/private.h  |   16 ++++++++++++++++
 4 files changed, 38 insertions(+)

diff --git a/ndctl/lib/hpe1.c b/ndctl/lib/hpe1.c
index 45cb5cc6db73..addebe952ce6 100644
--- a/ndctl/lib/hpe1.c
+++ b/ndctl/lib/hpe1.c
@@ -36,6 +36,12 @@ static struct ndctl_cmd *hpe1_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 		return NULL;
 	}
 
+	if (test_dimm_dsm(dimm, NDN_HPE1_CMD_SMART)
+			== DIMM_DSM_UNSUPPORTED) {
+		dbg(ctx, "unsupported function\n");
+		return NULL;
+	}
+
 	size = sizeof(*cmd) + sizeof(struct ndn_pkg_hpe1);
 	cmd = calloc(1, size);
 	if (!cmd)
@@ -214,6 +220,12 @@ static struct ndctl_cmd *hpe1_dimm_cmd_new_smart_threshold(struct ndctl_dimm *di
 		return NULL;
 	}
 
+	if (test_dimm_dsm(dimm, NDN_HPE1_CMD_SMART_THRESHOLD)
+			== DIMM_DSM_UNSUPPORTED) {
+		dbg(ctx, "unsupported function\n");
+		return NULL;
+	}
+
 	size = sizeof(*cmd) + sizeof(struct ndn_pkg_hpe1);
 	cmd = calloc(1, size);
 	if (!cmd)
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index bb47c9d1f522..0473b482ad23 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1232,6 +1232,7 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 	dimm->manufacturing_date = -1;
 	dimm->manufacturing_location = -1;
 	dimm->cmd_family = -1;
+	dimm->nfit_dsm_mask = ULONG_MAX;
 	for (i = 0; i < formats; i++)
 		dimm->format[i] = -1;
 
@@ -1310,6 +1311,10 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 	if (dimm->cmd_family == NVDIMM_FAMILY_MSFT)
 		dimm->smart_ops = msft_smart_ops;
 
+	sprintf(path, "%s/nfit/dsm_mask", dimm_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		dimm->nfit_dsm_mask = strtoul(buf, NULL, 0);
+
 	dimm->formats = formats;
 	sprintf(path, "%s/nfit/format", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
index 8c226f5602f1..1c4c8913714f 100644
--- a/ndctl/lib/msft.c
+++ b/ndctl/lib/msft.c
@@ -35,6 +35,11 @@ static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 		return NULL;
 	}
 
+	if (test_dimm_dsm(dimm, NDN_MSFT_CMD_SMART) == DIMM_DSM_UNSUPPORTED) {
+		dbg(ctx, "unsupported function\n");
+		return NULL;
+	}
+
 	size = sizeof(*cmd) + sizeof(struct ndn_pkg_msft);
 	cmd = calloc(1, size);
 	if (!cmd)
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 64bc5aee1134..685d65d89a06 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -77,6 +77,7 @@ struct ndctl_dimm {
 	unsigned char manufacturing_location;
 	unsigned long cmd_family;
 	unsigned long cmd_mask;
+	unsigned long nfit_dsm_mask;
 	char *unique_id;
 	char *dimm_path;
 	char *dimm_buf;
@@ -102,6 +103,21 @@ struct ndctl_dimm {
 	int format[0];
 };
 
+enum dsm_support {
+	DIMM_DSM_UNSUPPORTED, /* don't attempt command */
+	DIMM_DSM_SUPPORTED, /* good to go */
+	DIMM_DSM_UNKNOWN, /* try ND_CMD_CALL on older kernels */
+};
+
+static inline enum dsm_support test_dimm_dsm(struct ndctl_dimm *dimm, int fn)
+{
+	if (dimm->nfit_dsm_mask == ULONG_MAX) {
+		return DIMM_DSM_UNKNOWN;
+	} else if (dimm->nfit_dsm_mask & (1 << fn))
+		return DIMM_DSM_SUPPORTED;
+	return DIMM_DSM_UNSUPPORTED;
+}
+
 void region_flag_refresh(struct ndctl_region *region);
 
 /**

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
