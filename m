Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1B135223C178C
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 23:02:26 -0800 (PST)
Subject: [ndctl PATCH] ndctl,
 test: kill usage of fallocate in firmware-update.sh
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Feb 2018 22:59:22 -0800
Message-ID: <151936916209.18166.8915957818264326430.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The 'fallocate -l 196608 $image' step in the test fails when $image is
on an NFS mount. Use dd instead to create a sparse file. We do not need
to allocate anything since we are only writing zeros.

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/firmware-update.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/firmware-update.sh b/test/firmware-update.sh
index 0d5bcdb3cc42..173647218c28 100755
--- a/test/firmware-update.sh
+++ b/test/firmware-update.sh
@@ -49,7 +49,7 @@ detect()
 
 do_tests()
 {
-	fallocate -l 196608 $image
+	dd if=/dev/zero of=$image bs=1 count=1 skip=196607
 	$ndctl update-firmware -d $dev -f $image
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
