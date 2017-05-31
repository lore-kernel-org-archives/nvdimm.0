Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 77B3821A0910B
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 16:12:51 -0700 (PDT)
Subject: [PATCH] ndctl: add numa_node to --list command
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 31 May 2017 16:13:51 -0700
Message-ID: <149627243165.15800.17084928523692021655.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding numa_node of a namesapce to the --list command. If numa_node is -1,
numa_node will not be display as there's no NUMA node.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 util/json.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/util/json.c b/util/json.c
index b718d74..a9b733a 100644
--- a/util/json.c
+++ b/util/json.c
@@ -445,6 +445,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	struct ndctl_dax *dax;
 	char buf[40];
 	uuid_t uuid;
+	int numa;
 
 	if (!jndns)
 		return NULL;
@@ -567,6 +568,13 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		json_object_object_add(jndns, "state", jobj);
 	}
 
+	numa = ndctl_namespace_get_numa_node(ndns);
+	if (numa >= 0) {
+		jobj = json_object_new_int(numa);
+		if (jobj)
+			json_object_object_add(jndns, "numa_node", jobj);
+	}
+
 	if (pfn)
 		jbbs = util_pfn_badblocks_to_json(pfn, include_media_errors,
 				&bb_count);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
