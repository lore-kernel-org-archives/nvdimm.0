Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com
 [IPv6:2607:f8b0:4864:20::543])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 45139211B7F66
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 01:49:31 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id t13so2593485pgr.11
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 01:49:31 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH v3 5/6] ndctl: Add alignment to the namespace JSON output
Date: Wed, 16 Jan 2019 20:49:08 +1100
Message-Id: <20190116094909.23112-5-oohall@gmail.com>
In-Reply-To: <20190116094909.23112-1-oohall@gmail.com>
References: <20190116094909.23112-1-oohall@gmail.com>
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

Automated tooling probably wants to know this and it's helpful output
for command line users for ndctl.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 util/json.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/util/json.c b/util/json.c
index 5c3424e2a707..77c96fb53c27 100644
--- a/util/json.c
+++ b/util/json.c
@@ -753,6 +753,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	struct ndctl_btt *btt;
 	struct ndctl_pfn *pfn;
 	struct ndctl_dax *dax;
+	unsigned long align = 0;
 	char buf[40];
 	uuid_t uuid;
 	int numa;
@@ -825,6 +826,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		util_raw_uuid_to_json(ndns, flags, jndns);
 		bdev = ndctl_btt_get_block_device(btt);
 	} else if (pfn) {
+		align = ndctl_pfn_get_align(pfn);
 		ndctl_pfn_get_uuid(pfn, uuid);
 		uuid_unparse(uuid, buf);
 		jobj = json_object_new_string(buf);
@@ -837,6 +839,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		struct daxctl_region *dax_region;
 
 		dax_region = ndctl_dax_get_daxctl_region(dax);
+		align = ndctl_dax_get_align(dax);
 		ndctl_dax_get_uuid(dax, uuid);
 		uuid_unparse(uuid, buf);
 		jobj = json_object_new_string(buf);
@@ -897,6 +900,13 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		json_object_object_add(jndns, "sector_size", jobj);
 	}
 
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
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
