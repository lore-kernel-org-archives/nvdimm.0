Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4CAA021D0B667
 for <linux-nvdimm@lists.01.org>; Tue, 11 Jul 2017 23:43:23 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 2D94CAC00CA
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jul 2017 15:45:01 +0900 (JST)
Date: Wed, 12 Jul 2017 15:44:46 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH v3] ndctl list should show more hardware information
Message-Id: <20170712154441.C680.E1E9C6FF@jp.fujitsu.com>
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

Hi, 

I made the v3 of output hardware id .
If this patch is ok, please apply.

--
Change log

v3 :  - rebased on human readable option patch.


v2 :  - use json_object_new_int() for each data.
      - check MAX value for each data.
      - phys_id becomes unsigned short from signed short.

---
   The current "id" data of dimm (ndctl list -D) shows the information
   of DIMM module vendor or serial number.  However, I think it is not enough. 
 
   If a NVDIMM becomes broken, users need to know its physical place
   rather than vendor or serial number to replace the NVDIMM.

   There are 2 candidate of such information. 
     a) NFIT Device Handle (_ADR of the NVDIMM device)
        This date includes node controller id and socket id.
     b) NVDIMM Physical ID (Handle for the SMBIOS Memory Device (Type 17)).
        The dmidecode can show this handle with more information like "Locator"
        So, user can find the location of NVDIMM.

   At first, I think _ADR is enough information. 

   However, when I talked with our firmware team about this requirement, 
   they said it may not be good data, because the node contoller ID is not
   stable on our server due to "partitioning" feature.
   (Our server can have plural partition on one box, and may have plural
    node 0.)

   So, I make the ndctl shows not only NFIT Device Handle but also
   NVDIMM Physical ID. Then, user can find the location with dmidecode.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---

diff --git a/ndctl/list.c b/ndctl/list.c
index d81d646..7f8db66 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -388,7 +388,7 @@ int cmd_list(int argc, const char **argv, void *ctx)
 					json_object_object_add(jbus, "dimms", jdimms);
 			}
 
-			jdimm = util_dimm_to_json(dimm);
+			jdimm = util_dimm_to_json(dimm, listopts_to_flags());
 			if (!jdimm) {
 				fail("\n");
 				continue;
diff --git a/util/json.c b/util/json.c
index 0878979..80512bd 100644
--- a/util/json.c
+++ b/util/json.c
@@ -148,10 +148,13 @@ struct json_object *util_bus_to_json(struct ndctl_bus *bus)
 	return NULL;
 }
 
-struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
+struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
+		unsigned long flags)
 {
 	struct json_object *jdimm = json_object_new_object();
 	const char *id = ndctl_dimm_get_unique_id(dimm);
+	unsigned int handle = ndctl_dimm_get_handle(dimm);
+	unsigned short phys_id = ndctl_dimm_get_phys_id(dimm);
 	struct json_object *jobj;
 
 	if (!jdimm)
@@ -169,6 +172,20 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
 		json_object_object_add(jdimm, "id", jobj);
 	}
 
+	if (handle < UINT_MAX) {
+		jobj = util_json_object_hex(handle, flags);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "handle", jobj);
+	}
+
+	if (phys_id < USHRT_MAX) {
+		jobj = util_json_object_hex(phys_id, flags);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "phys_id", jobj);
+	}
+
 	if (!ndctl_dimm_is_enabled(dimm)) {
 		jobj = json_object_new_string("disabled");
 		if (!jobj)
diff --git a/util/json.h b/util/json.h
index ec394b6..d885ead 100644
--- a/util/json.h
+++ b/util/json.h
@@ -26,7 +26,8 @@ enum util_json_flags {
 struct json_object;
 void util_display_json_array(FILE *f_out, struct json_object *jarray, int jflag);
 struct json_object *util_bus_to_json(struct ndctl_bus *bus);
-struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm);
+struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
+		unsigned long flags);
 struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping,
 		unsigned long flags);
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,

---
Yasunori Goto


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
