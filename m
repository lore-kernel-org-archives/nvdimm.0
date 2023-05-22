Received: from esa11.hc1455-7.c3s2.iphmx.com (esa11.hc1455-7.c3s2.iphmx.com [207.54.90.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B485210F4
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 06:53:10 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="96873885"
X-IronPort-AV: E=Sophos;i="6.00,183,1681138800"; 
   d="scan'208";a="96873885"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa11.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 15:51:59 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 85024CD7E4
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 15:51:57 +0900 (JST)
Received: from kws-ab1.gw.nic.fujitsu.com (kws-ab1.gw.nic.fujitsu.com [192.51.206.11])
	by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id B015ABF4A8
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 15:51:56 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab1.gw.nic.fujitsu.com (Postfix) with ESMTP id 1A24D11464CA;
	Mon, 22 May 2023 15:51:56 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v2 2/6] cxl/monitor: replace monitor.log_file with monitor.ctx.log_file
Date: Mon, 22 May 2023 14:51:44 +0800
Message-Id: <20230522065148.818977-3-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230522065148.818977-1-lizhijian@fujitsu.com>
References: <20230522065148.818977-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1408-9.0.0.1002-27642.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1408-9.0.1002-27642.005
X-TMASE-Result: 10--12.638700-10.000000
X-TMASE-MatchedRID: tQw5ef8H/dt4Ydbp7yKeAVhRyidsElYkQR7lWMXPA1uOVdQAiMmbZ441
	Yiw6vZQgEr2Q42LcwM8KRuKRI67R4Aw8Nmue9wz38IK7yRWPRNFc8r3LfPzYa6CjQPEjtbB0dqr
	zSDDO/UQi+t+0AiFaYvL3NxFKQpq1uE+7i0XVHsEMPOZL2X19in607foZgOWyPdIdnoYIUtmjxY
	yRBa/qJcFwgTvxipFajoczmuoPCq3NWZv7SwlpdX97wrdQ8BTultpwedVA7EX5xDlC0S5GU5K94
	ag/IxDf
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Commit ba5825b0b7e0 ("ndctl/monitor: move common logging functions to util/log.c")
have replaced monitor.log_file with monitor.ctx.log_file for
ndctl-monitor, but for cxl-monitor, it forgot to do such work.

So where user specifies its own logfile, a segmentation fault will be
trggered like below:

 # build/cxl/cxl monitor -l ./monitor.log
Segmentation fault (core dumped)

Fixes: 299f69f974a6 ("cxl/monitor: add a new monitor command for CXL trace events")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V2: exchange order of previous patch1 and patch2 # Alison
    a few commit log updated
---
 cxl/monitor.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index c6df2bad3c53..f0e3c4c3f45c 100644
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
@@ -192,8 +191,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 	if (strncmp(log, "./standard", 10) == 0)
 		monitor.ctx.log_fn = log_standard;
 	else {
-		monitor.log_file = fopen(log, "a+");
-		if (!monitor.log_file) {
+		monitor.ctx.log_file = fopen(log, "a+");
+		if (!monitor.ctx.log_file) {
 			rc = -errno;
 			error("open %s failed: %d\n", log, rc);
 			goto out;
@@ -212,7 +211,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
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

