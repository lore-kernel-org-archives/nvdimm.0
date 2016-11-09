Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64C2481CC7
 for <linux-nvdimm@lists.01.org>; Wed,  9 Nov 2016 13:16:21 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/2] ndctl: fix return value for disable-namespace
Date: Wed,  9 Nov 2016 14:16:17 -0700
Message-Id: <1478726177-21904-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1478726177-21904-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1478726177-21904-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On success the "ndctl disable-namespace" returns the number of namespaces
that were disabled to the shell as an exit value.  This non-zero value is
interpreted by the shell as an error.

Fix this by returning 0 on success, just like all the other ndctl commands.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 ndctl/builtin-xaction-namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 9b1702d..c556252 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -790,7 +790,7 @@ int cmd_disable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
 	} else {
 		fprintf(stderr, "disabled %d namespace%s\n", disabled,
 				disabled > 1 ? "s" : "");
-		return disabled;
+		return 0;
 	}
 }
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
