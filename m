Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D6908223DB799
 for <linux-nvdimm@lists.01.org>; Fri,  9 Feb 2018 21:27:07 -0800 (PST)
Subject: [ndctl PATCH] ndctl, firmware: fix kernel version check
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Feb 2018 21:23:48 -0800
Message-ID: <151824022875.4967.15665172528794072137.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The firmware update passes when it should skip due to a misplaced
newline.

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/firmware-update.sh |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/test/firmware-update.sh b/test/firmware-update.sh
index 79767d2dc41f..0d5bcdb3cc42 100755
--- a/test/firmware-update.sh
+++ b/test/firmware-update.sh
@@ -53,8 +53,7 @@ do_tests()
 	$ndctl update-firmware -d $dev -f $image
 }
 
-check_min_kver "4.16" || { echo "kernel $KVER may lack firmware update test handling"; exit
-$rc; }
+check_min_kver "4.16" || { echo "kernel $KVER may lack firmware update test handling"; exit $rc; }
 modprobe nfit_test
 rc=1
 reset

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
