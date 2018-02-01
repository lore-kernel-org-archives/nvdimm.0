Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F40D2203564DC
 for <linux-nvdimm@lists.01.org>; Wed, 31 Jan 2018 16:44:05 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: remove a double put in injection status json
Date: Wed, 31 Jan 2018 17:49:38 -0700
Message-Id: <20180201004938.19823-1-vishal.l.verma@intel.com>
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

newer json-c catches a double put of the json object in printing the
injection status. We only need to put the containing jobj.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/inject-error.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
index 374ae0b..9b9d821 100644
--- a/ndctl/inject-error.c
+++ b/ndctl/inject-error.c
@@ -263,8 +263,6 @@ static int injection_status(struct ndctl_namespace *ndns)
 		printf("%s\n", json_object_to_json_string_ext(jobj,
 			JSON_C_TO_STRING_PRETTY));
 	}
-
-	json_object_put(jbbs);
 	json_object_put(jobj);
 
 	return rc;
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
