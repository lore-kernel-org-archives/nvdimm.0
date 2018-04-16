Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC7E92263DD9A
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 14:34:08 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2] ndctl,
 util: add a raw_uuid field to namespace listings
Date: Mon, 16 Apr 2018 15:34:04 -0600
Message-Id: <20180416213404.15279-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

For boot support efibootmgr needs to be able to lookup up the raw
namespace uuid to match the device-path that EFI emits. By default
'ndctl list' displays the uuid that is present in the address
abstraction info-block. Add a "raw_uuid" so that tooling can
correlate the default uuid with the base uuid for the namespace.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/json.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

v2: removed an unused variable

diff --git a/util/json.c b/util/json.c
index 8d65525..1772177 100644
--- a/util/json.c
+++ b/util/json.c
@@ -650,6 +650,16 @@ static struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax,
 			bb_count, flags);
 }
 
+static struct json_object *util_raw_uuid(struct ndctl_namespace *ndns)
+{
+	uuid_t raw_uuid;
+	char buf[40];
+
+	ndctl_namespace_get_uuid(ndns, raw_uuid);
+	uuid_unparse(raw_uuid, buf);
+	return json_object_new_string(buf);
+}
+
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		unsigned long flags)
 {
@@ -723,6 +733,10 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
 
+		jobj = util_raw_uuid(ndns);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "raw_uuid", jobj);
 		bdev = ndctl_btt_get_block_device(btt);
 	} else if (pfn) {
 		ndctl_pfn_get_uuid(pfn, uuid);
@@ -731,6 +745,10 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		if (!jobj)
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
+		jobj = util_raw_uuid(ndns);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "raw_uuid", jobj);
 		bdev = ndctl_pfn_get_block_device(pfn);
 	} else if (dax) {
 		struct daxctl_region *dax_region;
@@ -742,6 +760,10 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		if (!jobj)
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
+		jobj = util_raw_uuid(ndns);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "raw_uuid", jobj);
 		if ((flags & UTIL_JSON_DAX) && dax_region) {
 			jobj = util_daxctl_region_to_json(dax_region, NULL,
 					flags);
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
