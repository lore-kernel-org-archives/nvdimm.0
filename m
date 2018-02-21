Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7B99C2034D8D6
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 14:56:57 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 3/3] ndctl,
 update: remove the check for !cmd when dereferencing it
Date: Wed, 21 Feb 2018 16:02:52 -0700
Message-Id: <20180221230252.16632-4-vishal.l.verma@intel.com>
In-Reply-To: <20180221230252.16632-1-vishal.l.verma@intel.com>
References: <20180221230252.16632-1-vishal.l.verma@intel.com>
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

ndctl_cmd_unref() already checks for the cmd being NULL, no need to
check at every call site.

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/update.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/ndctl/update.c b/ndctl/update.c
index 71d95eb..4ca6a0d 100644
--- a/ndctl/update.c
+++ b/ndctl/update.c
@@ -254,8 +254,7 @@ static int send_firmware(struct update_context *uctx)
 	}
 
 cleanup:
-	if (cmd)
-		ndctl_cmd_unref(cmd);
+	ndctl_cmd_unref(cmd);
 	free(buf);
 	return rc;
 }
@@ -546,8 +545,7 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx)
 	if (rc < 0)
 		return rc;
 
-	if (uctx.start)
-		ndctl_cmd_unref(uctx.start);
+	ndctl_cmd_unref(uctx.start);
 
 	return 0;
 }
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
