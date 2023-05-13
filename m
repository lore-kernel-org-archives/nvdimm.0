Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A42F63C8
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 14:21:01 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="96025989"
X-IronPort-AV: E=Sophos;i="5.99,272,1677510000"; 
   d="scan'208";a="96025989"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 23:20:51 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 7013CE4289
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:48 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id BB3C2CFB67
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:47 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 3A84D2007CDE5;
	Sat, 13 May 2023 23:20:47 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH 1/6] cxl/monitor: Fix monitor not working
Date: Sat, 13 May 2023 22:20:33 +0800
Message-Id: <20230513142038.753351-2-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--7.603700-10.000000
X-TMASE-MatchedRID: iuUHfCgXiTNujdbubeNfI5jnsVPBNMvRG24YVeuZGmPk6Qbi+9i6DwzK
	NF0GZctoN/7rnrBxoxzmn3xyPJAJoh2P280ZiGmRuLt50vtxBA5+tO36GYDlsj3SHZ6GCFLZo8W
	MkQWv6iV3LAytsQR4e42j49Ftap9EOwBXM346/+wy9G73P9DbMVuwe9LV+wr+rZ3TaYPN2sEEbV
	9K1w1C14m9ixJ12P85
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

It looks that someone forgot to rewrite this part after
ba5825b0b7e0 ("ndctl/monitor: move common logging functions to util/log.c")

 # build/cxl/cxl monitor -l ./monitor.log
Segmentation fault (core dumped)

Fixes: 299f69f974a6 ("cxl/monitor: add a new monitor command for CXL trace events")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 cxl/monitor.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index e3469b9a4792..4043928db3ef 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -37,7 +37,6 @@ const char *default_log = "/var/log/cxl-monitor.log";
 static struct monitor {
 	const char *log;
 	struct log_ctx ctx;
-	FILE *log_file;
 	bool human;
 	bool verbose;
 	bool daemon;
@@ -189,8 +188,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 
 			if (!monitor.log)
 				log = default_log;
-			monitor.log_file = fopen(log, "a+");
-			if (!monitor.log_file) {
+			monitor.ctx.log_file = fopen(log, "a+");
+			if (!monitor.ctx.log_file) {
 				rc = -errno;
 				error("open %s failed: %d\n", monitor.log, rc);
 				goto out;
@@ -210,7 +209,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 	rc = monitor_event(ctx);
 
 out:
-	if (monitor.log_file)
-		fclose(monitor.log_file);
+	if (monitor.ctx.log_file)
+		fclose(monitor.ctx.log_file);
 	return rc;
 }
-- 
2.29.2

