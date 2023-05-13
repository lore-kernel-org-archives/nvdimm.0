Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43CA2263E
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 14:21:00 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="116525315"
X-IronPort-AV: E=Sophos;i="5.99,272,1677510000"; 
   d="scan'208";a="116525315"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 23:20:51 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id D2F7FCD6C0
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:48 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 1199AD5E86
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:48 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 836112007CDE6;
	Sat, 13 May 2023 23:20:47 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH 2/6] cxl/monitor: compare the whole filename with reserved words
Date: Sat, 13 May 2023 22:20:34 +0800
Message-Id: <20230513142038.753351-3-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--4.797400-10.000000
X-TMASE-MatchedRID: IAkHRTl/xj1ujdbubeNfIyoiRKlBVkYIMC4zO7d4kaPAuQ0xDMaXkH4q
	tYI9sRE/KqrQ7lLcMnxRzi+uKjH4IZH0YXYnbGozFEUknJ/kEl5jFT88f69nG/oLR4+zsDTtjoc
	zmuoPCq37Cu2a4WDaU0ZOXxkv2Gc9WaogLJqKD25J5fd8V3ESyWcHEgh/NuPzpfbrmfPbzvjacC
	tPgmIKEDIW6PkGTevcvTlZnIcT2uEVwbf5lERMgI/2RRfVn5u4Tcu6aRtCI3BUKpNI+7y1VHsDE
	gQ63iHZ
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

For example:
$ cxl monitor -l standard.log

User is most likely want to save log to ./standard.log instead of stdout.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 cxl/monitor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index 4043928db3ef..842e54b186ab 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -181,7 +181,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 	if (monitor.log) {
 		if (strncmp(monitor.log, "./", 2) != 0)
 			fix_filename(prefix, (const char **)&monitor.log);
-		if (strncmp(monitor.log, "./standard", 10) == 0 && !monitor.daemon) {
+
+		if (strcmp(monitor.log, "./standard") == 0 && !monitor.daemon) {
 			monitor.ctx.log_fn = log_standard;
 		} else {
 			const char *log = monitor.log;
-- 
2.29.2

