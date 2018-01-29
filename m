Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 012082215BD88
 for <linux-nvdimm@lists.01.org>; Mon, 29 Jan 2018 13:42:31 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [ndctl PATCH v3 2/2] ndctl: add sector_size to 'ndctl list' output
Date: Mon, 29 Jan 2018 14:48:00 -0700
Message-Id: <20180129214800.13750-1-ross.zwisler@linux.intel.com>
In-Reply-To: <CAPcyv4j32EVw94JMsou0GgX=t-OWrNwQ=_qvpmUaVs2hy6D6aQ@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

It used to be that the only PMEM namespaces with a variable sector size
were ones with a BTT, but that has changed.  sector_size still doesn't make
sense for device DAX since we don't have a block I/O path.

If we don't have a specified sector size, as happens with namespaces of
devtype nd_namespace_io and older v1.1 namespace labels, we will display
the default sector size of 512.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 util/json.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/util/json.c b/util/json.c
index 95beaa2..17d8f13 100644
--- a/util/json.c
+++ b/util/json.c
@@ -718,11 +718,6 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
 
-		jobj = json_object_new_int(ndctl_btt_get_sector_size(btt));
-		if (!jobj)
-			goto err;
-		json_object_object_add(jndns, "sector_size", jobj);
-
 		bdev = ndctl_btt_get_block_device(btt);
 	} else if (pfn) {
 		ndctl_pfn_get_uuid(pfn, uuid);
@@ -774,6 +769,30 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	} else
 		bdev = ndctl_namespace_get_block_device(ndns);
 
+	jobj = NULL;
+	if (btt) {
+		jobj = json_object_new_int(ndctl_btt_get_sector_size(btt));
+		if (!jobj)
+			goto err;
+	} else if (!dax) {
+		unsigned int sector_size = ndctl_namespace_get_sector_size(ndns);
+
+		/*
+		 * The kernel will default to a 512 byte sector size on PMEM
+		 * namespaces that don't explicitly have a sector size. This
+		 * happens because they use pre-v1.2 labels or because they
+		 * don't have a label space (devtype=nd_namespace_io).
+		 */
+		if (!sector_size)
+			sector_size = 512;
+
+		jobj = json_object_new_int(sector_size);
+		if (!jobj)
+			goto err;
+	}
+	if (jobj)
+		json_object_object_add(jndns, "sector_size", jobj);
+
 	if (bdev && bdev[0]) {
 		jobj = json_object_new_string(bdev);
 		if (!jobj)
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
