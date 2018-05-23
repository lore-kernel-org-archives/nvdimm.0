Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 87FFD207E36D3
 for <linux-nvdimm@lists.01.org>; Wed, 23 May 2018 10:38:53 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl,
 test: fix sector-mode.sh to work with label support
Date: Wed, 23 May 2018 11:38:46 -0600
Message-Id: <20180523173846.7923-1-vishal.l.verma@intel.com>
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

The nfit_test.1 grew support for the label DSMs. Fix sector-mode.sh to
emulate labelless mode by zeroing the labels at the start, and supplying
--no-autolabel to create-namespace commands.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/sector-mode.sh | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/test/sector-mode.sh b/test/sector-mode.sh
index ee364eb..54b16a5 100755
--- a/test/sector-mode.sh
+++ b/test/sector-mode.sh
@@ -32,11 +32,7 @@ $NDCTL zero-labels $BUS all
 $NDCTL enable-region $BUS all
 
 $NDCTL disable-region $BUS1 all
-if $NDCTL zero-labels $BUS1 all; then
-	echo "DIMMs on $BUS1 support labels, skip..."
-	$NDCTL enable-region $BUS1 all
-	false
-fi
+$NDCTL zero-labels $BUS1 all
 $NDCTL enable-region $BUS1 all
 
 rc=1
@@ -44,9 +40,9 @@ query=". | sort_by(.size) | reverse | .[0].dev"
 NAMESPACE=$($NDCTL list $BUS1 -N | jq -r "$query")
 REGION=$($NDCTL list -R --namespace=$NAMESPACE | jq -r ".dev")
 echo 0 > /sys/bus/nd/devices/$REGION/read_only
-$NDCTL create-namespace -e $NAMESPACE -m sector -f -l 4K
-$NDCTL create-namespace -e $NAMESPACE -m dax -f -a 4K
-$NDCTL create-namespace -e $NAMESPACE -m sector -f -l 4K
+$NDCTL create-namespace --no-autolabel -e $NAMESPACE -m sector -f -l 4K
+$NDCTL create-namespace --no-autolabel -e $NAMESPACE -m dax -f -a 4K
+$NDCTL create-namespace --no-autolabel -e $NAMESPACE -m sector -f -l 4K
 
 $NDCTL disable-region $BUS all
 $NDCTL disable-region $BUS1 all
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
