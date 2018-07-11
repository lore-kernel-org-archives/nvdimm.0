Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39B69203B99B5
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 16:56:50 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/2] ndctl,
 test: fix tests for the array vs object listing fix
Date: Wed, 11 Jul 2018 17:56:43 -0600
Message-Id: <20180711235644.26998-1-vishal.l.verma@intel.com>
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

The commit below updated json listings to always be arrays unless,
potentially, --human was specified. As a fallout of the change, some
unit tests that used jq to look for certain elements, or the json2var
conversion broke in certain cases. Fix the jq query in sector-mode.sh,
and fix json2var in test/common. The 'destructive' class of unit tests
still need to be converted to the test/common scheme, and subsequently
have their own local json2var instances. These will be fixed in a future
commit by simply performing the test/common conversion.

Fixes: 72c46ab194d9 ("ndctl list: always output array without --human")
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/common         | 2 +-
 test/sector-mode.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/common b/test/common
index fb4e18e..1b9d3da 100644
--- a/test/common
+++ b/test/common
@@ -79,5 +79,5 @@ _cleanup()
 #
 json2var()
 {
-	sed -e "s/[{}\",]//g; s/:/=/g"
+	sed -e "s/[{}\",]//g; s/\[//g; s/\]//g; s/:/=/g"
 }
diff --git a/test/sector-mode.sh b/test/sector-mode.sh
index 16c1ddf..4b964c5 100755
--- a/test/sector-mode.sh
+++ b/test/sector-mode.sh
@@ -31,7 +31,7 @@ $NDCTL enable-region -b $NFIT_TEST_BUS1 all
 rc=1
 query=". | sort_by(.size) | reverse | .[0].dev"
 NAMESPACE=$($NDCTL list -b $NFIT_TEST_BUS1 -N | jq -r "$query")
-REGION=$($NDCTL list -R --namespace=$NAMESPACE | jq -r ".dev")
+REGION=$($NDCTL list -R --namespace=$NAMESPACE | jq -r "(.[]) | .dev")
 echo 0 > /sys/bus/nd/devices/$REGION/read_only
 $NDCTL create-namespace --no-autolabel -e $NAMESPACE -m sector -f -l 4K
 $NDCTL create-namespace --no-autolabel -e $NAMESPACE -m dax -f -a 4K
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
