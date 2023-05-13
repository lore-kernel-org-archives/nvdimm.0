Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2471263C8
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 14:21:04 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="96025990"
X-IronPort-AV: E=Sophos;i="5.99,272,1677510000"; 
   d="scan'208";a="96025990"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 23:20:51 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 0779FDAE0C
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:49 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 5167BCFB67
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:48 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id CAB382007CDDD;
	Sat, 13 May 2023 23:20:47 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH 3/6] cxl/monitor: Enable default_log and refactor sanity check
Date: Sat, 13 May 2023 22:20:35 +0800
Message-Id: <20230513142038.753351-4-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--10.932400-10.000000
X-TMASE-MatchedRID: 3egoFLofC9QmIUsxKhH73EhwlOfYeSqxIfyQNHR2naZUjspoiX02F9/o
	yHSxbX6QC3E/pZVge5ocDvR0/knYncgqWOFh1Y7mSZJFFtJz2zfBOVz0Jwcxl6vCrG0TnfVUIb5
	NpqK++5rMP8Zz0+GC1SAJB0U5f8Y908q9KSsUtVfNgrlT5Ajc7sCY5/Mqi1OiTNObyxjW9zqjxY
	yRBa/qJcFwgTvxipFajoczmuoPCq2BdyV2Bgygdc9eXW151k2XjiAVtCLqefIPbjab2Bq73UPy0
	aphFd2x
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

The default_log is not working at all. Simply the sanity check and
re-enable default log file so that it can be consistent with the
document.

Please note that i also removed following addition stuff, since we have
added this prefix if needed during parsing the FILENAME.
if (strncmp(monitor.log, "./", 2) != 0)
    fix_filename(prefix, (const char **)&monitor.log);

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 cxl/monitor.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index 842e54b186ab..139506aed85a 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -163,6 +163,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 	};
 	const char *prefix ="./";
 	int rc = 0, i;
+	const char *log;
 
 	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
 	for (i = 0; i < argc; i++)
@@ -170,32 +171,32 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 	if (argc)
 		usage_with_options(u, options);
 
-	log_init(&monitor.ctx, "cxl/monitor", "CXL_MONITOR_LOG");
-	monitor.ctx.log_fn = log_standard;
+	// sanity check
+	if (monitor.daemon && monitor.log && !strncmp(monitor.log, "./", 2)) {
+		error("standard or relative path for <file> will not work for daemon mode\n");
+		return -EINVAL;
+	}
+
+	if (monitor.log)
+		log = monitor.log;
+	else
+		log = monitor.daemon ? default_log : "./standard";
 
+	log_init(&monitor.ctx, "cxl/monitor", "CXL_MONITOR_LOG");
 	if (monitor.verbose)
 		monitor.ctx.log_priority = LOG_DEBUG;
 	else
 		monitor.ctx.log_priority = LOG_INFO;
 
-	if (monitor.log) {
-		if (strncmp(monitor.log, "./", 2) != 0)
-			fix_filename(prefix, (const char **)&monitor.log);
-
-		if (strcmp(monitor.log, "./standard") == 0 && !monitor.daemon) {
-			monitor.ctx.log_fn = log_standard;
-		} else {
-			const char *log = monitor.log;
-
-			if (!monitor.log)
-				log = default_log;
-			monitor.ctx.log_file = fopen(log, "a+");
-			if (!monitor.ctx.log_file) {
-				rc = -errno;
-				error("open %s failed: %d\n", monitor.log, rc);
-				goto out;
-			}
-			monitor.ctx.log_fn = log_file;
+	if (strcmp(log, "./standard") == 0)
+		monitor.ctx.log_fn = log_standard;
+	else {
+		monitor.ctx.log_fn = log_file;
+		monitor.ctx.log_file = fopen(log, "a+");
+		if (!monitor.ctx.log_file) {
+			rc = -errno;
+			error("open %s failed: %d\n", log, rc);
+			goto out;
 		}
 	}
 
-- 
2.29.2

