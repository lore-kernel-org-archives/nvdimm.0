Received: from esa8.hc1455-7.c3s2.iphmx.com (esa8.hc1455-7.c3s2.iphmx.com [139.138.61.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0B563CB
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 14:22:04 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="104611334"
X-IronPort-AV: E=Sophos;i="5.99,272,1677510000"; 
   d="scan'208";a="104611334"
Received: from unknown (HELO oym-r1.gw.nic.fujitsu.com) ([210.162.30.89])
  by esa8.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 23:20:52 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
	by oym-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id ACEF0CC144
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:49 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id E36AABF496
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:48 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 5CE672007CDDD;
	Sat, 13 May 2023 23:20:48 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH 5/6] Documentation/cxl/cxl-monitor.txt: Fix inaccurate description
Date: Sat, 13 May 2023 22:20:37 +0800
Message-Id: <20230513142038.753351-6-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230513142038.753351-1-lizhijian@fujitsu.com>
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27622.007
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27622.007
X-TMASE-Result: 10--4.028400-10.000000
X-TMASE-MatchedRID: qT9V7Qri989lYwkarmHZPhF4zyLyne+ATJDl9FKHbrk8DTfVRLTQzGtC
	SH0t7mTXCaWhCMLM4iM1hvF/jmI7sx8TzIzimOwPlpYqKNmWxsHZs3HUcS/scCq2rl3dzGQ1R9Z
	hy3GxKcWP1rsEtYf0PMTgIROGAdZIzcEqMArWfCOVM0+Xr7B8A8lBMvaqb8g34OAc0T7V8JkBg0
	bU7ew8YGgZBmgHRVb07jOrYwIKPdAVxRB/din+uJ07T8ZSLiAVvR84/OmB1wQp4n8eQBnwiw==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

No syslog is supported by cxl-monitor

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
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

