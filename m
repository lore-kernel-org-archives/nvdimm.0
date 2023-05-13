Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568B063CA
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 14:22:04 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="116441723"
X-IronPort-AV: E=Sophos;i="5.99,272,1677510000"; 
   d="scan'208";a="116441723"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 23:20:52 +0900
Received: from oym-m3.gw.nic.fujitsu.com (oym-nat-oym-m3.gw.nic.fujitsu.com [192.168.87.60])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id EDFC1D432C
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:49 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 2F6EBD9463
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:49 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id A41BD2007CDE5;
	Sat, 13 May 2023 23:20:48 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH 6/6] ndctl/monitor: compare the whole filename with reserved words
Date: Sat, 13 May 2023 22:20:38 +0800
Message-Id: <20230513142038.753351-7-lizhijian@fujitsu.com>
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
	tYI9sRE/KqrQ7lLcMnxRzi+uKjH4IWMAzi+7d0chngIgpj8eDcAZ1CdBJOsoY9mzcdRxL+xwKra
	uXd3MZDVkxLLBHGto3S1ApTvoxKRwKMZ9aHFjjAdspQgnOmreX+JjyF/rn4BqbJ/H0CNrzM93bq
	ahVsXC3wGgxWMmIpkPTt6vbu386HDRkHs++pxogRXFEH92Kf64nTtPxlIuIBW9Hzj86YHXBCnif
	x5AGfCL
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

For example:
$ ndctl monitor -l standard.log
User is most likely want to save log to ./standard.log instead of stdout.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 ndctl/monitor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 89903def63d4..bd8a74863476 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -610,9 +610,9 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 	if (monitor.log) {
 		if (strncmp(monitor.log, "./", 2) != 0)
 			fix_filename(prefix, (const char **)&monitor.log);
-		if (strncmp(monitor.log, "./syslog", 8) == 0)
+		if (strcmp(monitor.log, "./syslog") == 0)
 			monitor.ctx.log_fn = log_syslog;
-		else if (strncmp(monitor.log, "./standard", 10) == 0)
+		else if (strcmp(monitor.log, "./standard") == 0)
 			monitor.ctx.log_fn = log_standard;
 		else {
 			monitor.ctx.log_file = fopen(monitor.log, "a+");
-- 
2.29.2

