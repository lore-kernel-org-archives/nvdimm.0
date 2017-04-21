Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x242.google.com (mail-io0-x242.google.com
 [IPv6:2607:f8b0:4001:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA8C62194EB4B
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 00:12:45 -0700 (PDT)
Received: by mail-io0-x242.google.com with SMTP id h41so27101141ioi.1
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 00:12:45 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 3/3] ndctl: print alignment of dax namespaces
Date: Fri, 21 Apr 2017 17:12:19 +1000
Message-Id: <20170421071219.18744-3-oohall@gmail.com>
In-Reply-To: <20170421071219.18744-1-oohall@gmail.com>
References: <20170421071219.18744-1-oohall@gmail.com>
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

Print the alignment for dax namespaces creation. It's good to be explicit about
it since about the selected region alignment dictates the type of faults
we allow on the namespace.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 util/json.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/util/json.c b/util/json.c
index d6a8d4c899ed..720d22559df0 100644
--- a/util/json.c
+++ b/util/json.c
@@ -299,6 +299,11 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		if (!jobj)
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
+		jobj = json_object_new_int64(ndctl_dax_get_align(dax));
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "align", jobj);
+
 		if (include_dax) {
 			dax_region = ndctl_dax_get_daxctl_region(dax);
 			jobj = util_daxctl_region_to_json(dax_region,
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
