Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA4E5208F7AA7
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 13:32:31 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [ndctl PATCH] ndctl, tests: firmware-update.sh post-test cleanup
Date: Fri, 23 Feb 2018 14:38:27 -0700
Message-Id: <20180223213827.24808-1-ross.zwisler@linux.intel.com>
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
To: dan.j.williams@intel.com, linux-nvdimm@lists.01.org, vishal.l.verma@intel.com, dave.jiang@intel.com
List-ID: <linux-nvdimm@lists.01.org>

When firmware-update.sh is run multiple times by itself, all runs but the
first fail with this:

+ ../ndctl/ndctl update-firmware -d nmem1 -f update-fw.img
  Error: START FIRMWARE UPDATE failed: 0x9

  Error: Another firmware upload in progress or finished.

Fix this by having the test properly clean up and disable all the nfit_test
regions and unloading the nfit_test module, as we do in test/pmem-errors.sh
et al.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 test/firmware-update.sh | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/test/firmware-update.sh b/test/firmware-update.sh
index 1736472..44c1412 100755
--- a/test/firmware-update.sh
+++ b/test/firmware-update.sh
@@ -6,6 +6,7 @@
 [ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ] && ndctl="./ndctl/ndctl"
 [ -z "$ndctl" ] && echo "Couldn't find an ndctl binary" && exit 1
 bus="nfit_test.0"
+bus1="nfit_test.1"
 json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 dev=""
@@ -41,6 +42,13 @@ reset()
 	fi
 }
 
+cleanup()
+{
+	$ndctl disable-region -b "$bus" all
+	$ndctl disable-region -b "$bus1" all
+	modprobe -r nfit_test
+}
+
 detect()
 {
 	dev=$($ndctl list -b "$bus" -D | jq .[0].dev | tr -d '"')
@@ -59,6 +67,5 @@ rc=1
 reset
 detect
 do_tests
-reset
+cleanup
 exit 0
-
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
