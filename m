Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CE763CA
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 14:22:07 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="116441724"
X-IronPort-AV: E=Sophos;i="5.99,272,1677510000"; 
   d="scan'208";a="116441724"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 23:20:53 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 52E55D4322
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:49 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 8BD4FD88B5
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:48 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 138D32007CDE5;
	Sat, 13 May 2023 23:20:48 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH 4/6] cxl/monitor: always log started message
Date: Sat, 13 May 2023 22:20:36 +0800
Message-Id: <20230513142038.753351-5-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--1.454700-10.000000
X-TMASE-MatchedRID: ZYjN+pfhQkov+0FNnM7lDQPZZctd3P4BmSLeIgEDej/PWp1UK7zV928g
	t97yUnX94vM1YF6AJbadn/a8z5b7FtAtbEEX0MxBxEHRux+uk8hxKpvEGAbTDjOf+hPWh33rZdq
	WI7mmTxUtUw8gDMXGog0p1KsOkL0iEqbkIH4I8Zg3sdcYTO4+VW5Oyxs3FFYCzcYlmUtMTAehkZ
	FqIiAEuVuMG6V02+QySir3tZId0WN+6klq53W5kJ9Gzq4huQVX
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Tell people monitor is starting

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 cxl/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index 139506aed85a..6761f3bb97af 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -205,8 +205,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 			err(&monitor, "daemon start failed\n");
 			goto out;
 		}
-		info(&monitor, "cxl monitor daemon started.\n");
 	}
+	info(&monitor, "cxl monitor started.\n");
 
 	rc = monitor_event(ctx);
 
-- 
2.29.2

