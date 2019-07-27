Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1344F212B9A9D
 for <linux-nvdimm@lists.01.org>; Sat, 27 Jul 2019 14:56:10 -0700 (PDT)
Subject: [ndctl PATCH v2 01/26] ndctl/dimm: Add 'flags' field to read-labels
 output
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 27 Jul 2019 14:39:26 -0700
Message-ID: <156426356654.531577.6142389862764297120.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Recent discussions on some platform implementations setting the LOCAL
bit in namespace labels makes it apparent that this field should be
decoded in the json representation.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/dimm.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index b2b09b6aa9a2..8946dc74fe41 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -141,6 +141,11 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
 			break;
 		json_object_object_add(jlabel, "nlabel", jobj);
 
+		jobj = json_object_new_int64(le64_to_cpu(nslabel.flags));
+		if (!jobj)
+			break;
+		json_object_object_add(jlabel, "flags", jobj);
+
 		jobj = json_object_new_int64(le64_to_cpu(nslabel.isetcookie));
 		if (!jobj)
 			break;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
