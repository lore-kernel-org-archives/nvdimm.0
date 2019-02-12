Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 63A4A202E5322
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 13:41:37 -0800 (PST)
Subject: [ndctl PATCH 2/8] ndctl/dimm: Add --human support to read-labels
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 13:28:59 -0800
Message-ID: <155000693912.348282.3054365378477074974.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Allow for easier comparisons between 'read-labels' output and list.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/dimm.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 292beebf9734..5ff730f42a45 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -50,6 +50,7 @@ static struct parameters {
 	bool crypto_erase;
 	bool overwrite;
 	bool master_pass;
+	bool human;
 	bool force;
 	bool json;
 	bool verbose;
@@ -79,7 +80,7 @@ static int action_zero(struct ndctl_dimm *dimm, struct action_context *actx)
 }
 
 static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
-		struct ndctl_cmd *cmd_read, ssize_t size)
+		struct ndctl_cmd *cmd_read, ssize_t size, unsigned long flags)
 {
 	struct json_object *jarray = json_object_new_array();
 	struct json_object *jlabel = NULL;
@@ -140,12 +141,13 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
 			break;
 		json_object_object_add(jlabel, "nlabel", jobj);
 
-		jobj = json_object_new_int64(le64_to_cpu(nslabel.flags));
+		jobj = util_json_object_hex(le32_to_cpu(nslabel.flags), flags);
 		if (!jobj)
 			break;
 		json_object_object_add(jlabel, "flags", jobj);
 
-		jobj = json_object_new_int64(le64_to_cpu(nslabel.isetcookie));
+		jobj = util_json_object_hex(le64_to_cpu(nslabel.isetcookie),
+				flags);
 		if (!jobj)
 			break;
 		json_object_object_add(jlabel, "isetcookie", jobj);
@@ -155,12 +157,12 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
 			break;
 		json_object_object_add(jlabel, "lbasize", jobj);
 
-		jobj = json_object_new_int64(le64_to_cpu(nslabel.dpa));
+		jobj = util_json_object_hex(le64_to_cpu(nslabel.dpa), flags);
 		if (!jobj)
 			break;
 		json_object_object_add(jlabel, "dpa", jobj);
 
-		jobj = json_object_new_int64(le64_to_cpu(nslabel.rawsize));
+		jobj = util_json_object_size(le64_to_cpu(nslabel.rawsize), flags);
 		if (!jobj)
 			break;
 		json_object_object_add(jlabel, "rawsize", jobj);
@@ -265,6 +267,7 @@ static struct json_object *dump_index_json(struct ndctl_cmd *cmd_read, ssize_t s
 static struct json_object *dump_json(struct ndctl_dimm *dimm,
 		struct ndctl_cmd *cmd_read, ssize_t size)
 {
+	unsigned long flags = param.human ? UTIL_JSON_HUMAN : 0;
 	struct json_object *jdimm = json_object_new_object();
 	struct json_object *jlabel, *jobj, *jindex;
 
@@ -273,7 +276,7 @@ static struct json_object *dump_json(struct ndctl_dimm *dimm,
 	jindex = dump_index_json(cmd_read, size);
 	if (!jindex)
 		goto err_jindex;
-	jlabel = dump_label_json(dimm, cmd_read, size);
+	jlabel = dump_label_json(dimm, cmd_read, size, flags);
 	if (!jlabel)
 		goto err_jlabel;
 
@@ -1038,7 +1041,8 @@ OPT_BOOLEAN('v',"verbose", &param.verbose, "turn on debug")
 #define READ_OPTIONS() \
 OPT_STRING('o', "output", &param.outfile, "output-file", \
 	"filename to write label area contents"), \
-OPT_BOOLEAN('j', "json", &param.json, "parse label data into json")
+OPT_BOOLEAN('j', "json", &param.json, "parse label data into json"), \
+OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats ")
 
 #define WRITE_OPTIONS() \
 OPT_STRING('i', "input", &param.infile, "input-file", \

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
