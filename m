Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C1FAD2253FB58
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 14:00:52 -0800 (PST)
Subject: [ndctl PATCH v2] ndctl, list: fix sector_size listing
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Mar 2018 13:58:04 -0800
Message-ID: <152063266441.35685.17297254306158306542.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Commit a7320456f1bc "ndctl: add sector_size to 'ndctl list' output"
mishandles the case where a namespace does not specify a sector_size,
but otherwise supports a sector_size selection:

    # ndctl list --namespace=namespace1.0
    {
      "dev":"namespace1.0",
      "mode":"memory",
      "size":32763805696,
      "uuid":"7c985ba5-6d33-48bd-8fde-6c25a520abe0",
      "sector_size":-1,
      "blockdev":"pmem1",
      "numa_node":0
    }

Fixes: a7320456f1bc ("ndctl: add sector_size to 'ndctl list' output")
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
v2: drop the additional change to filter the sector_size == 512 case.

 util/json.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/util/json.c b/util/json.c
index 17d8f135b686..a464f21d6d5a 100644
--- a/util/json.c
+++ b/util/json.c
@@ -646,6 +646,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	struct json_object *jndns = json_object_new_object();
 	struct json_object *jobj, *jbbs = NULL;
 	unsigned long long size = ULLONG_MAX;
+	unsigned int sector_size = UINT_MAX;
 	enum ndctl_namespace_mode mode;
 	const char *bdev = NULL, *name;
 	unsigned int bb_count = 0;
@@ -769,29 +770,26 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	} else
 		bdev = ndctl_namespace_get_block_device(ndns);
 
-	jobj = NULL;
-	if (btt) {
-		jobj = json_object_new_int(ndctl_btt_get_sector_size(btt));
-		if (!jobj)
-			goto err;
-	} else if (!dax) {
-		unsigned int sector_size = ndctl_namespace_get_sector_size(ndns);
-
-		/*
-		 * The kernel will default to a 512 byte sector size on PMEM
-		 * namespaces that don't explicitly have a sector size. This
-		 * happens because they use pre-v1.2 labels or because they
-		 * don't have a label space (devtype=nd_namespace_io).
-		 */
-		if (!sector_size)
+	if (btt)
+		sector_size = ndctl_btt_get_sector_size(btt);
+	else if (!dax) {
+		sector_size = ndctl_namespace_get_sector_size(ndns);
+		if (!sector_size || sector_size == UINT_MAX)
 			sector_size = 512;
+	}
 
+	/*
+	 * The kernel will default to a 512 byte sector size on PMEM
+	 * namespaces that don't explicitly have a sector size. This
+	 * happens because they use pre-v1.2 labels or because they
+	 * don't have a label space (devtype=nd_namespace_io).
+	 */
+	if (sector_size < UINT_MAX) {
 		jobj = json_object_new_int(sector_size);
 		if (!jobj)
 			goto err;
-	}
-	if (jobj)
 		json_object_object_add(jndns, "sector_size", jobj);
+	}
 
 	if (bdev && bdev[0]) {
 		jobj = json_object_new_string(bdev);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
