Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A615821A00AF2
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 02:11:26 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 3118BAC00CB
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 18:13:01 +0900 (JST)
Date: Wed, 05 Jul 2017 18:12:52 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [RFC/PATCH] ndctl list should show more hardware information
Message-Id: <20170705181250.8D09.E1E9C6FF@jp.fujitsu.com>
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

Hello,

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

   This is the first trial patch. So any comments are welcome.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
diff --git a/util/json.c b/util/json.c
index b718d74..749a358 100644
--- a/util/json.c
+++ b/util/json.c
@@ -68,6 +68,9 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
 {
 	struct json_object *jdimm = json_object_new_object();
 	const char *id = ndctl_dimm_get_unique_id(dimm);
+	unsigned int handle = ndctl_dimm_get_handle(dimm);
+	short phys_id = ndctl_dimm_get_phys_id(dimm);
+	char buf[11];
 	struct json_object *jobj;
 
 	if (!jdimm)
@@ -85,6 +88,18 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
 		json_object_object_add(jdimm, "id", jobj);
 	}
 
+	snprintf(buf, 11, "0x%08x", handle);
+	jobj = json_object_new_string(buf);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jdimm, "handle", jobj);
+
+	snprintf(buf, 7, "0x%04x", phys_id );
+	jobj = json_object_new_string(buf);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jdimm, "phys_id", jobj);
+
 	if (!ndctl_dimm_is_enabled(dimm)) {
 		jobj = json_object_new_string("disabled");
 		if (!jobj)

---
Yasunori Goto

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
