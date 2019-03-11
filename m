Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 133AE211069EE
 for <linux-nvdimm@lists.01.org>; Mon, 11 Mar 2019 12:46:38 -0700 (PDT)
Subject: [PATCH] ndctl: update security handling post overwrite
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 11 Mar 2019 12:46:37 -0700
Message-ID: <155233359788.16519.1363511796795900412.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The security state after overwrite completion is expected to remain the
same as before overwrite. Current implementation assumed that overwrite
would remove the security state and therefore removing the keys. Update
so security keys are not removed.

Dave Jiang <dave.jiang@intel.com>
---
 ndctl/util/keys.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
index c1f2e843..f315802c 100644
--- a/ndctl/util/keys.c
+++ b/ndctl/util/keys.c
@@ -650,8 +650,5 @@ int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
 	if (rc < 0)
 		return rc;
 
-	if (key > 0)
-		return discard_key(dimm);
-
 	return 0;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
