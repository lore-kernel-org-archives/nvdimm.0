Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8FFF0225264AE
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 21:37:53 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl,
 rescan-partitions.sh: fix skipping for missing modules
Date: Wed,  4 Apr 2018 22:37:44 -0600
Message-Id: <20180405043744.23069-1-vishal.l.verma@intel.com>
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

rescan-partitions would fail if the nfit_test module was not found. Fix
by moving the modprobe attempt to earlier in the test.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/rescan-partitions.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/rescan-partitions.sh b/test/rescan-partitions.sh
index 47f0b62..7ae0957 100755
--- a/test/rescan-partitions.sh
+++ b/test/rescan-partitions.sh
@@ -54,7 +54,6 @@ check_prereq "blockdev"
 
 reset()
 {
-	modprobe nfit_test
 	$ndctl disable-region -b "$bus" all
 	$ndctl zero-labels -b "$bus" all
 	$ndctl enable-region -b "$bus" all
@@ -97,6 +96,7 @@ test_mode()
 	$ndctl destroy-namespace $dev
 }
 
+modprobe nfit_test
 rc=1
 reset
 test_mode "raw"
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
