Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E8FEC202E5E52
 for <linux-nvdimm@lists.01.org>; Mon,  6 Nov 2017 15:14:32 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 3/3] ndctl, inject-error: remove unreachable code
Date: Mon,  6 Nov 2017 16:16:10 -0700
Message-Id: <20171106231610.8271-3-vishal.l.verma@intel.com>
In-Reply-To: <20171106231610.8271-1-vishal.l.verma@intel.com>
References: <20171106231610.8271-1-vishal.l.verma@intel.com>
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

The iteration helper ndctl_namespace_bb_foreach ensures bb cannot be
NULL in the loop, so an explicit check for it is not necessary. Remove
it.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/inject-error.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
index 4c45902..a05f813 100644
--- a/ndctl/inject-error.c
+++ b/ndctl/inject-error.c
@@ -250,9 +250,6 @@ static int injection_status(struct ndctl_namespace *ndns)
 	}
 
 	ndctl_namespace_bb_foreach(ndns, bb) {
-		if (!bb)
-			break;
-
 		block = ndctl_bb_get_block(bb);
 		count = ndctl_bb_get_count(bb);
 		jbb = util_badblock_rec_to_json(block, count, ictx.flags);
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
