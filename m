Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D50221C9127B
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 13:05:56 -0700 (PDT)
Subject: [ndctl PATCH 7/7] ndctl: auto initialize labels
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 13:02:08 -0700
Message-ID: <150403692821.8240.17921098591962254302.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
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

If we are reconfiguring an ND_DEVICE_NAMESPACE_IO namespace take the
opportunity to potentially initialize labels. DIMM capacity that is not
aliased will surface as a label-less namespace by default. If every DIMM
in the interleave set supports labels we can switch a more dynamic
configuration, i.e. enable pmem sub-division.

The --no-autolabel option is added to disable this behavior if it is not
wanted.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl/ndctl-create-namespace.txt |    7 ++
 ndctl/namespace.c                              |   90 +++++++++++++++++++++++-
 2 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index 85d1f8db792f..3844ff74a9f1 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -138,6 +138,13 @@ OPTIONS
 	active.  Specifying --force causes the namespace to be disabled
 	before reconfiguring.
 
+-L::
+--autolabel::
+	When ndctl encounters a label-less namespace while
+	performing a reconfigure operation it will try to enable labels
+	for the region. This behavior can be suppressed with
+	"--no-autolabel".
+
 -v::
 --verbose::
 	Emit debug messages for the namespace creation process
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 6cfd873da248..b6381c5822de 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -42,6 +42,7 @@ static struct parameters {
 	bool do_scan;
 	bool mode_default;
 	bool align_default;
+	bool autolabel;
 	const char *bus;
 	const char *map;
 	const char *type;
@@ -53,7 +54,9 @@ static struct parameters {
 	const char *reconfig;
 	const char *sector_size;
 	const char *align;
-} param;
+} param = {
+	.autolabel = true,
+};
 
 void builtin_xaction_namespace_reset(void)
 {
@@ -76,6 +79,7 @@ struct parsed_parameters {
 	unsigned long long size;
 	unsigned long sector_size;
 	unsigned long align;
+	bool autolabel;
 };
 
 #define debug(fmt, ...) \
@@ -111,7 +115,8 @@ OPT_STRING('t', "type", &param.type, "type", \
 	"specify the type of namespace to create 'pmem' or 'blk'"), \
 OPT_STRING('a', "align", &param.align, "align", \
 	"specify the namespace alignment in bytes (default: 2M)"), \
-OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active")
+OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active"), \
+OPT_BOOLEAN('L', "autolabel", &param.autolabel, "automatically initialize labels")
 
 #define CHECK_OPTIONS() \
 OPT_BOOLEAN('R', "repair", &repair, "perform metadata repairs"), \
@@ -675,6 +680,8 @@ static int validate_namespace_options(struct ndctl_region *region,
 		}
 	}
 
+	p->autolabel = param.autolabel;
+
 	return 0;
 }
 
@@ -810,6 +817,80 @@ static int namespace_destroy(struct ndctl_region *region,
 	return 0;
 }
 
+static void enable_labels(struct ndctl_region *region)
+{
+	int mappings = ndctl_region_get_mappings(region);
+	struct ndctl_cmd *cmd_read = NULL;
+	enum ndctl_namespace_version v;
+	struct ndctl_dimm *dimm;
+	int count;
+
+	/* no dimms => no labels */
+	if (!mappings)
+		return;
+
+	count = 0;
+	ndctl_dimm_foreach_in_region(region, dimm) {
+		if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_GET_CONFIG_SIZE))
+			break;
+		if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_GET_CONFIG_DATA))
+			break;
+		if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SET_CONFIG_DATA))
+			break;
+		count++;
+	}
+
+	/* all the dimms must support labelling */
+	if (count != mappings)
+		return;
+
+	ndctl_region_disable_invalidate(region);
+	count = 0;
+	ndctl_dimm_foreach_in_region(region, dimm)
+		if (ndctl_dimm_is_active(dimm)) {
+			count++;
+			break;
+		}
+
+	/* some of the dimms belong to multiple regions?? */
+	if (count)
+		goto out;
+
+	v = NDCTL_NS_VERSION_1_2;
+retry:
+	ndctl_dimm_foreach_in_region(region, dimm) {
+		int num_labels, avail;
+
+		ndctl_cmd_unref(cmd_read);
+		cmd_read = ndctl_dimm_read_labels(dimm);
+		if (!cmd_read)
+			continue;
+
+		num_labels = ndctl_dimm_init_labels(dimm, v);
+		if (num_labels < 0)
+			continue;
+
+		ndctl_dimm_disable(dimm);
+		ndctl_dimm_enable(dimm);
+
+		/*
+		 * If the kernel appears to not understand v1.2 labels,
+		 * try v1.1. Note, we increment avail by 1 to account
+		 * for the one free label that the kernel always
+		 * maintains for ongoing updates.
+		 */
+		avail = ndctl_dimm_get_available_labels(dimm) + 1;
+		if (num_labels != avail && v == NDCTL_NS_VERSION_1_2) {
+			v = NDCTL_NS_VERSION_1_1;
+			goto retry;
+		}
+
+	}
+	ndctl_cmd_unref(cmd_read);
+out:
+	ndctl_region_enable(region);
+}
+
 static int namespace_reconfig(struct ndctl_region *region,
 		struct ndctl_namespace *ndns)
 {
@@ -824,6 +905,11 @@ static int namespace_reconfig(struct ndctl_region *region,
 	if (rc)
 		return rc;
 
+	/* check if we can enable labels on this region */
+	if (ndctl_namespace_get_type(ndns) == ND_DEVICE_NAMESPACE_IO
+			&& p.autolabel)
+		enable_labels(region);
+
 	ndns = region_get_namespace(region);
 	if (!ndns || is_namespace_active(ndns)) {
 		debug("%s: no %s namespace seed\n",

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
