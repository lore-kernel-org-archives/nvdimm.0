Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D1292097FAAC
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jul 2018 12:35:33 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl,
 test/monitor: fix inject-smart field in test_filter_dimmevent
Date: Mon, 30 Jul 2018 13:35:22 -0600
Message-Id: <20180730193522.30458-1-vishal.l.verma@intel.com>
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

Change the inject-smart field from -s to -m when testing the
dimm-media-temperature event. The -s seems to have been a copy-paste
error.

Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/monitor.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/monitor.sh b/test/monitor.sh
index 1bbfd14..29d4ea1 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -152,7 +152,7 @@ test_filter_dimmevent()
 	inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r .[]."health"."temperature_threshold")
 	inject_value=$((inject_value + 1))
 	start_monitor "-d $monitor_dimms -D dimm-media-temperature"
-	inject_smart "-s $inject_value"
+	inject_smart "-m $inject_value"
 	check_result "$monitor_dimms"
 	stop_monitor
 }
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
