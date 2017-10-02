Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A2FE21F303EB
 for <linux-nvdimm@lists.01.org>; Mon,  2 Oct 2017 09:13:24 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: fix static analysis report, unchecked sscanf
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 02 Oct 2017 09:10:18 -0700
Message-ID: <150696061891.21689.14927545469089860105.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

Static analysis flags some occasions of unchecked sscanf return value.

Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/json.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/util/json.c b/util/json.c
index d1ee351546b9..0c92c3b49c71 100644
--- a/util/json.c
+++ b/util/json.c
@@ -374,11 +374,12 @@ static int compare_dimm_number(const void *p1, const void *p2)
 	const char *dimm2_name = ndctl_dimm_get_devname(dimm2);
 	int num1, num2;
 
-	sscanf(dimm1_name, "nmem%d", &num1);
-	sscanf(dimm2_name, "nmem%d", &num2);
+	if (sscanf(dimm1_name, "nmem%d", &num1) != 1)
+		num1 = 0;
+	if (sscanf(dimm2_name, "nmem%d", &num2) != 1)
+		num2 = 0;
 
 	return num1 - num2;
-
 }
 
 static struct json_object *badblocks_to_jdimms(struct ndctl_region *region,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
