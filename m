Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7127F223DB786
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 21:29:19 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 1/4] ndctl,
 inject-error: error out for a non-existent namespace
Date: Thu,  8 Feb 2018 22:34:57 -0700
Message-Id: <20180209053500.6871-1-vishal.l.verma@intel.com>
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

When an invalid namespace was specified, inject-error would simply walk
through a loop trying to matching namespace, and at the end, exit out
silently. This could make it look as though the operation had been
successful, when in reality, nothing had been done.

Fix to print a message, and exit with an ENXIO when this happens.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/inject-error.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
index 9b9d821..efa9f92 100644
--- a/ndctl/inject-error.c
+++ b/ndctl/inject-error.c
@@ -338,7 +338,8 @@ static int do_inject(const char *namespace, struct ndctl_ctx *ctx)
 		}
 	}
 
-	return 0;
+	error("%s: no such namespace\n", namespace);
+	return rc;
 }
 
 int cmd_inject_error(int argc, const char **argv, void *ctx)
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
