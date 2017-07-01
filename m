Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EABCD21BADADB
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 17:33:43 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] ndctl: add lbasize to read-label json output
Date: Fri, 30 Jun 2017 18:33:21 -0600
Message-Id: <20170701003321.13360-2-vishal.l.verma@intel.com>
In-Reply-To: <20170701003321.13360-1-vishal.l.verma@intel.com>
References: <20170701003321.13360-1-vishal.l.verma@intel.com>
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

The UEFI 2.7 spec labels add a new lbasize field to labels. Add it to
the json output of read-labels.

Reported-by: Kaushik Kanetkar <kaushik.a.kanetkar@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/dimm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index f6a07a7..d0de4d4 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -159,6 +159,11 @@ static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t s
 			break;
 		json_object_object_add(jlabel, "isetcookie", jobj);
 
+		jobj = json_object_new_int64(le64_to_cpu(nslabel.lbasize));
+		if (!jobj)
+			break;
+		json_object_object_add(jlabel, "lbasize", jobj);
+
 		jobj = json_object_new_int64(le64_to_cpu(nslabel.dpa));
 		if (!jobj)
 			break;
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
