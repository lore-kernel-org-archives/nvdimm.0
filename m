Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6AB18B14
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 11:55:08 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="111917455"
X-IronPort-AV: E=Sophos;i="6.01,196,1684767600"; 
   d="scan'208";a="111917455"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 20:53:57 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id A56CED69D5
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 20:53:55 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id DA436CFBC3
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 20:53:54 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.234.230])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 2852220077BB3;
	Tue, 11 Jul 2023 20:53:54 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev,
	alison.schofield@intel.com
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v4 2/4] cxl/monitor: replace monitor.log_file with monitor.ctx.log_file
Date: Tue, 11 Jul 2023 19:53:42 +0800
Message-Id: <20230711115344.562823-3-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230711115344.562823-1-lizhijian@fujitsu.com>
References: <20230711115344.562823-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27744.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27744.006
X-TMASE-Result: 10--12.638700-10.000000
X-TMASE-MatchedRID: tQw5ef8H/dt4Ydbp7yKeAVhRyidsElYkQR7lWMXPA1uOVdQAiMmbZ441
	Yiw6vZQgEr2Q42LcwM8KRuKRI67R4Aw8Nmue9wz38IK7yRWPRNFc8r3LfPzYa6CjQPEjtbB0dqr
	zSDDO/UQi+t+0AiFaYvL3NxFKQpq1uE+7i0XVHsEMPOZL2X19in607foZgOWyPdIdnoYIUtmjxY
	yRBa/qJcFwgTvxipFajoczmuoPCq0mkgQKuNNMrkwcfFlhTHyDXn57FXFUEqewRxQ5xVOCTszFc
	YWKl9tq
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Commit ba5825b0b7e0 ("ndctl/monitor: move common logging functions to util/log.c")
have replaced monitor.log_file with monitor.ctx.log_file for
ndctl-monitor, but for cxl-monitor, it forgot to do such work.

So where user specifies its own logfile, a segmentation fault will be
trggered like below:

 # build/cxl/cxl monitor -l ./monitor.log
Segmentation fault (core dumped)

Fixes: 299f69f974a6 ("cxl/monitor: add a new monitor command for CXL trace events")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V4: add reviewed tag
V2: exchange order of previous patch1 and patch2 # Alison
    a few commit log updated
---
 cxl/monitor.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index d8245ed8d0e9..e83455b63d35 100644
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

