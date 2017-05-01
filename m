Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 931F321A04830
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 16:04:52 -0700 (PDT)
Subject: [ndctl PATCH] test, btt-check: bump supported version to 4.13
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 01 May 2017 15:58:59 -0700
Message-ID: <149367953971.14481.15896479342915007512.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Given that the kernel needs to carry the BTT error clearing workaround
for another cycle [1], bump the default expectations of this test to
4.13. It is worth noting that the nfit_test bus provider does not suffer
from the same sleeping while atomic issue in its emulation of the "clear
error DSM", so this kernel band-aid can be reverted when testing through
that path.

[1]: https://patchwork.kernel.org/patch/9706741/

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/btt-check.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/btt-check.sh b/test/btt-check.sh
index 2dde2461ec81..4c328fecbe88 100755
--- a/test/btt-check.sh
+++ b/test/btt-check.sh
@@ -43,7 +43,7 @@ check_min_kver()
 	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
 }
 
-check_min_kver "4.12" || { echo "kernel $KVER may not support badblocks clearing on pmem via btt"; exit $rc; }
+check_min_kver "4.13" || { echo "kernel $KVER may not support badblocks clearing on pmem via btt"; exit $rc; }
 
 create()
 {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
