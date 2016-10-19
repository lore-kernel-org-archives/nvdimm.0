Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C83881A1E9B
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 09:51:22 -0700 (PDT)
Subject: [ndctl PATCH 6/8] ndctl: provide a read_labels() helper
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 09:48:20 -0700
Message-ID: <147689570053.11015.1779678039898343821.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for adding an 'init-labels' command, factor out the
common portion of reading the label space from a dimm.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-dimm.c |   44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/ndctl/builtin-dimm.c b/ndctl/builtin-dimm.c
index 6d0c343a29e3..34ad1d9b47e7 100644
--- a/ndctl/builtin-dimm.c
+++ b/ndctl/builtin-dimm.c
@@ -284,46 +284,62 @@ static int dump_bin(FILE *f_out, struct ndctl_cmd *cmd_read, ssize_t size)
 	return 0;
 }
 
-static int action_read(struct ndctl_dimm *dimm, struct action_context *actx)
+static struct ndctl_cmd *read_labels(struct ndctl_dimm *dimm)
 {
 	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
 	struct ndctl_cmd *cmd_size, *cmd_read;
-	ssize_t size;
 	int rc;
 
 	rc = ndctl_bus_wait_probe(bus);
 	if (rc < 0)
-		return rc;
+		return NULL;
 
 	cmd_size = ndctl_dimm_cmd_new_cfg_size(dimm);
 	if (!cmd_size)
-		return -ENOTTY;
+		return NULL;
 	rc = ndctl_cmd_submit(cmd_size);
 	if (rc || ndctl_cmd_get_firmware_status(cmd_size))
 		goto out_size;
 
 	cmd_read = ndctl_dimm_cmd_new_cfg_read(cmd_size);
-	if (!cmd_read) {
-		rc = -ENOTTY;
+	if (!cmd_read)
 		goto out_size;
-	}
 	rc = ndctl_cmd_submit(cmd_read);
 	if (rc || ndctl_cmd_get_firmware_status(cmd_read))
 		goto out_read;
 
-	size = ndctl_cmd_cfg_size_get_size(cmd_size);
+	ndctl_cmd_unref(cmd_size);
+	return cmd_read;
+
+ out_read:
+	ndctl_cmd_unref(cmd_read);
+ out_size:
+	ndctl_cmd_unref(cmd_size);
+	return NULL;
+}
+
+static int action_read(struct ndctl_dimm *dimm, struct action_context *actx)
+{
+	struct ndctl_cmd *cmd_read;
+	ssize_t size;
+	int rc = 0;
+
+	cmd_read = read_labels(dimm);
+	if (!cmd_read)
+		return -ENXIO;
+
+	size = ndctl_cmd_cfg_read_get_size(cmd_read);
 	if (actx->jdimms) {
 		struct json_object *jdimm = dump_json(dimm, cmd_read, size);
-		if (!jdimm)
-			return -ENOMEM;
-		json_object_array_add(actx->jdimms, jdimm);
+
+		if (jdimm)
+			json_object_array_add(actx->jdimms, jdimm);
+		else
+			rc = -ENOMEM;
 	} else
 		rc = dump_bin(actx->f_out, cmd_read, size);
 
- out_read:
 	ndctl_cmd_unref(cmd_read);
- out_size:
-	ndctl_cmd_unref(cmd_size);
 
 	return rc;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
