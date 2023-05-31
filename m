Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E36A1391
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 02:21:00 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="118879843"
X-IronPort-AV: E=Sophos;i="6.00,205,1681138800"; 
   d="scan'208";a="118879843"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 11:19:50 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 74BB3E4289
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 11:19:47 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id BC63ED5EB7
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 11:19:46 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.234.230])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 20DCD6B824;
	Wed, 31 May 2023 11:19:46 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v3 3/6] cxl/monitor: use strcmp to compare the reserved word
Date: Wed, 31 May 2023 10:19:33 +0800
Message-Id: <20230531021936.7366-4-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--5.391400-10.000000
X-TMASE-MatchedRID: D4Z888FpREt15zj/0di3Qx1kSRHxj+Z5RpgtqnD1BD4yiHqxwIX2MV3w
	KTJCsiojZpCaFaIgtCAIA0tg8Os0LyfB+/OOFhyOTuctSpiuWyUUi4Ehat0546MQi364g884C5U
	xy0A8KC06hUOcTonr9IAy6p60ZV62To3UJuRLIoTdB/CxWTRRu25FeHtsUoHurxzJJThFy9pwi+
	yqnG6mrAC9kRkqGgyWO2wwhUOsaGJLhb8xGEnVfg==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

According to the tool's documentation, when '-l standard' is specified,
log would be output to the stdout. But since it's using strncmp(a, b, 10)
to compare the former 10 characters, it will also wrongly detect a filename
starting with a substring 'standard' as stdout.

For example:
$ cxl monitor -l standard.log

User is most likely want to save log to ./standard.log instead of stdout.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V3: Improve commit log # Dave
V2: commit log updated # Dave
---
 cxl/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index f0e3c4c3f45c..179646562187 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -188,7 +188,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 	else
 		monitor.ctx.log_priority = LOG_INFO;
 
-	if (strncmp(log, "./standard", 10) == 0)
+	if (strcmp(log, "./standard") == 0)
 		monitor.ctx.log_fn = log_standard;
 	else {
 		monitor.ctx.log_file = fopen(log, "a+");
-- 
2.29.2

