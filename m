Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 602EE212E15B4
 for <linux-nvdimm@lists.01.org>; Sat, 27 Jul 2019 14:57:04 -0700 (PDT)
Subject: [ndctl PATCH v2 11/26] ndctl/dimm: Limit read-labels with --index
 option
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 27 Jul 2019 14:40:19 -0700
Message-ID: <156426361963.531577.9756735022332101876.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Provide a capability to limit the read-labels payload to just the
index-block data space.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/dimm.c |   43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 603e112f9568..c7ad621367e9 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -55,6 +55,7 @@ static struct parameters {
 	bool master_pass;
 	bool human;
 	bool force;
+	bool index;
 	bool json;
 	bool verbose;
 } param = {
@@ -276,27 +277,26 @@ static struct json_object *dump_json(struct ndctl_dimm *dimm,
 
 	if (!jdimm)
 		return NULL;
-	jindex = dump_index_json(cmd_read, size);
-	if (!jindex)
-		goto err_jindex;
-	jlabel = dump_label_json(dimm, cmd_read, size, flags);
-	if (!jlabel)
-		goto err_jlabel;
 
 	jobj = json_object_new_string(ndctl_dimm_get_devname(dimm));
 	if (!jobj)
-		goto err_jobj;
-
+		goto err;
 	json_object_object_add(jdimm, "dev", jobj);
+
+	jindex = dump_index_json(cmd_read, size);
+	if (!jindex)
+		goto err;
 	json_object_object_add(jdimm, "index", jindex);
+	if (param.index)
+		return jdimm;
+
+	jlabel = dump_label_json(dimm, cmd_read, size, flags);
+	if (!jlabel)
+		goto err;
 	json_object_object_add(jdimm, "label", jlabel);
-	return jdimm;
 
- err_jobj:
-	json_object_put(jlabel);
- err_jlabel:
-	json_object_put(jindex);
- err_jindex:
+	return jdimm;
+err:
 	json_object_put(jdimm);
 	return NULL;
 }
@@ -385,7 +385,11 @@ static int action_read(struct ndctl_dimm *dimm, struct action_context *actx)
 	ssize_t size;
 	int rc = 0;
 
-	cmd_read = ndctl_dimm_read_label_extent(dimm, param.len, param.offset);
+	if (param.index)
+		cmd_read = ndctl_dimm_read_label_index(dimm);
+	else
+		cmd_read = ndctl_dimm_read_label_extent(dimm, param.len,
+				param.offset);
 	if (!cmd_read)
 		return -EINVAL;
 
@@ -1054,7 +1058,8 @@ OPT_BOOLEAN('v',"verbose", &param.verbose, "turn on debug")
 OPT_STRING('o', "output", &param.outfile, "output-file", \
 	"filename to write label area contents"), \
 OPT_BOOLEAN('j', "json", &param.json, "parse label data into json"), \
-OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats (implies --json)")
+OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats (implies --json)"), \
+OPT_BOOLEAN('I', "index", &param.index, "limit read to the index block area")
 
 #define WRITE_OPTIONS() \
 OPT_STRING('i', "input", &param.infile, "input-file", \
@@ -1185,6 +1190,12 @@ static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 		return -EINVAL;
 	}
 
+	if (param.index && param.len) {
+		fprintf(stderr, "pick either --size, or --index, not both\n");
+		usage_with_options(u, options);
+		return -EINVAL;
+	}
+
 	if (json) {
 		actx.jdimms = json_object_new_array();
 		if (!actx.jdimms)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
