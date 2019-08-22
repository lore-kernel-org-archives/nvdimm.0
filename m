Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D4F221959CB2
 for <linux-nvdimm@lists.01.org>; Thu, 22 Aug 2019 13:37:47 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/2] ndctl/check-namespace: improve error message in
 absence of a BTT
Date: Thu, 22 Aug 2019 14:36:34 -0600
Message-Id: <20190822203635.17926-1-vishal.l.verma@intel.com>
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
Cc: Scott Davenport <scott.davenport@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

When a BTT info block is not found, check-namespace only reported
something like:

  namespace5.0: namespace_check: Unable to recover any BTT info blocks
  error checking namespaces: No such device or address
  checked 0 namespaces

This can be improved by suggesting a BTT might not have been present on
the namespace at all, so emit an additional message such as:

  namespace5.0: namespace_check: This may not be a sector mode namespace

Link: https://github.com/pmem/ndctl/issues/43
Reported-by: Jane Chu <jane.chu@oracle.com>
Reported-by: Scott Davenport <scott.davenport@oracle.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/check.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ndctl/check.c b/ndctl/check.c
index 5969012..365abaf 100644
--- a/ndctl/check.c
+++ b/ndctl/check.c
@@ -1322,6 +1322,8 @@ int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
 			rc = btt_recover_first_sb(bttc);
 			if (rc) {
 				err(bttc, "Unable to recover any BTT info blocks\n");
+				err(bttc,
+					"This may not be a sector mode namespace\n");
 				goto out_close;
 			}
 			/*
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
