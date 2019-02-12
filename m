Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 60088201B0448
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 13:41:32 -0800 (PST)
Subject: [ndctl PATCH 1/8] ndctl/dimm: Add 'flags' field to read-labels output
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 13:28:53 -0800
Message-ID: <155000693373.348282.13171493280743990130.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
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
index cc0bec04c3b2..292beebf9734 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -140,6 +140,11 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
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
