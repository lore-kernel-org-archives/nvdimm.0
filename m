Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6151878
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 02:21:05 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="118879846"
X-IronPort-AV: E=Sophos;i="6.00,205,1681138800"; 
   d="scan'208";a="118879846"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 11:19:51 +0900
Received: from yto-m4.gw.nic.fujitsu.com (yto-nat-yto-m4.gw.nic.fujitsu.com [192.168.83.67])
	by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 5357FCD6C2
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 11:19:48 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 9FB49D5072
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 11:19:47 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.234.230])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id EA9146B824;
	Wed, 31 May 2023 11:19:46 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v3 5/6] Documentation/cxl/cxl-monitor.txt: Fix inaccurate description
Date: Wed, 31 May 2023 10:19:35 +0800
Message-Id: <20230531021936.7366-6-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230531021936.7366-1-lizhijian@fujitsu.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27662.004
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27662.004
X-TMASE-Result: 10--4.632400-10.000000
X-TMASE-MatchedRID: AuCKiGuH5B4hYREeQEM9SU7nLUqYrlslFIuBIWrdOePfUZT83lbkEI/M
	VY+TBf96aL3qKCUFEDH4O/wkN6cR6ZH0YXYnbGozFEUknJ/kEl5jFT88f69nG/oLR4+zsDTtjoc
	zmuoPCq29LyQ4JDCFvHvtfn+qRSOv/hWfCcPVmFI4RMKVeGL9ywIImSWafD+p41H+5mLWxCEZTW
	qHEry1oU0T3u5Cfou4AEVn2YJISkkVwbf5lERMgI/2RRfVn5u4Tcu6aRtCI3BUKpNI+7y1VHsDE
	gQ63iHZ
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

No syslog is supported by cxl-monitor

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V2: add Reviewed-by tag
---
 Documentation/cxl/cxl-monitor.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/cxl/cxl-monitor.txt b/Documentation/cxl/cxl-monitor.txt
index 3fc992e4d4d9..c284099f16c3 100644
--- a/Documentation/cxl/cxl-monitor.txt
+++ b/Documentation/cxl/cxl-monitor.txt
@@ -39,8 +39,7 @@ OPTIONS
 --log=::
 	Send log messages to the specified destination.
 	- "<file>":
-	  Send log messages to specified <file>. When fopen() is not able
-	  to open <file>, log messages will be forwarded to syslog.
+	  Send log messages to specified <file>.
 	- "standard":
 	  Send messages to standard output.
 
-- 
2.29.2

