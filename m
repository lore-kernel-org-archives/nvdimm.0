Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7678122742AA1
 for <linux-nvdimm@lists.01.org>; Wed, 11 Apr 2018 12:55:42 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, read-labels: fix json reference counting
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Apr 2018 12:45:45 -0700
Message-ID: <152347594505.18821.8817528606205630151.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Steve Scargall <steve.scargall@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Steve Scargall <steve.scargall@intel.com>

Current versions of the json-c library abort when decrementing an object
reference past 0. Given that util_display_json_array() drops the
reference to the passed in object we do not need to drop the reference
in dimm_action(). This fixes failures with the following signature:

    $ ndctl read-labels nmem0 nmem1 -j
    ...
    ndctl: json_object.c:159: json_object_put: Assertion `jso->_ref_count > 0' failed.
    Aborted (core dumped)

Signed-off-by: Steve Scargall <steve.scargall@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/dimm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index f51f34bb28b6..1c168997105e 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -1080,11 +1080,9 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 			rc = action(single, &actx);
 	}
 
-	if (actx.jdimms) {
+	if (actx.jdimms)
 		util_display_json_array(actx.f_out, actx.jdimms,
 				JSON_C_TO_STRING_PRETTY);
-		json_object_put(actx.jdimms);
-	}
 
 	if (actx.f_out != stdout)
 		fclose(actx.f_out);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
