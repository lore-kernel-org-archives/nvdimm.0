Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x244.google.com (mail-qk0-x244.google.com
 [IPv6:2607:f8b0:400d:c09::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85BE921164C5B
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 12:43:51 -0700 (PDT)
Received: by mail-qk0-x244.google.com with SMTP id 185-v6so4337213qkk.11
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 12:43:51 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH 1/2] nfit,
 test: Add NFIT_TEST_BUS[01] variable and some helper funtions to
 common
Date: Thu, 14 Jun 2018 15:43:35 -0400
Message-Id: <20180614194336.15341-2-msys.mizuma@gmail.com>
In-Reply-To: <20180614194336.15341-1-msys.mizuma@gmail.com>
References: <20180614194336.15341-1-msys.mizuma@gmail.com>
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
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Add following global variable and functions to test/common file.

 - NFIT_TEST_BUS[01] (global variable)
   Buses are created when nfit_test module is loaded.

 - NDCTL (global variable)
   ndctl command path (renamed).

 - _cleanup
   Helper function cleans up nfit_test module.

 - json2var
   Helper function (filter) converts json to var.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 test/common | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/test/common b/test/common
index 8fafa91..fb4e18e 100644
--- a/test/common
+++ b/test/common
@@ -4,17 +4,23 @@
 
 # Global variables
 
-# ndctl
+# NDCTL
 #
 if [ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ]; then
-	export ndctl=../ndctl/ndctl
+	export NDCTL=../ndctl/ndctl
 elif [ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ]; then
-	export ndctl=./ndctl/ndctl
+	export NDCTL=./ndctl/ndctl
 else
 	echo "Couldn't find an ndctl binary"
 	exit 1
 fi
 
+# NFIT_TEST_BUS[01]
+#
+NFIT_TEST_BUS0=nfit_test.0
+NFIT_TEST_BUS1=nfit_test.1
+
+
 # Functions
 
 # err
@@ -58,3 +64,20 @@ check_prereq()
 		do_skip "missing $1, skipping..."
 	fi
 }
+
+# _cleanup
+#
+_cleanup()
+{
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	$NDCTL disable-region -b $NFIT_TEST_BUS1 all
+	modprobe -r nfit_test
+}
+
+# json2var
+# stdin: json
+#
+json2var()
+{
+	sed -e "s/[{}\",]//g; s/:/=/g"
+}
-- 
2.18.0.rc1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
