Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x244.google.com (mail-pf0-x244.google.com
 [IPv6:2607:f8b0:400e:c00::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCE7021951C94
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 02:15:13 -0700 (PDT)
Received: by mail-pf0-x244.google.com with SMTP id a188so8053102pfa.2
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 02:15:13 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 4/4] ndctl: print alignment for dax and pfn devs
Date: Thu, 27 Apr 2017 19:14:54 +1000
Message-Id: <20170427091454.17412-4-oohall@gmail.com>
In-Reply-To: <20170427091454.17412-1-oohall@gmail.com>
References: <20170427091454.17412-1-oohall@gmail.com>
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

It's handy to know. Doubly so if the user didn't supply an alignment.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 util/json.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/util/json.c b/util/json.c
index d6a8d4c899ed..f454163df0e9 100644
--- a/util/json.c
+++ b/util/json.c
@@ -217,6 +217,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	struct ndctl_btt *btt;
 	struct ndctl_pfn *pfn;
 	struct ndctl_dax *dax;
+	unsigned long align = 0;
 	char buf[40];
 	uuid_t uuid;
 
@@ -283,6 +284,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 
 		bdev = ndctl_btt_get_block_device(btt);
 	} else if (pfn) {
+		align = ndctl_pfn_get_align(pfn);
 		ndctl_pfn_get_uuid(pfn, uuid);
 		uuid_unparse(uuid, buf);
 		jobj = json_object_new_string(buf);
@@ -293,6 +295,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	} else if (dax) {
 		struct daxctl_region *dax_region;
 
+		align = ndctl_dax_get_align(dax);
 		ndctl_dax_get_uuid(dax, uuid);
 		uuid_unparse(uuid, buf);
 		jobj = json_object_new_string(buf);
@@ -327,6 +330,13 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	} else
 		bdev = ndctl_namespace_get_block_device(ndns);
 
+	if (align) {
+		jobj = json_object_new_int64(align);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "align", jobj);
+	}
+
 	if (bdev && bdev[0]) {
 		jobj = json_object_new_string(bdev);
 		if (!jobj)
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
