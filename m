Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A47D1398
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 02:21:01 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="107113884"
X-IronPort-AV: E=Sophos;i="6.00,205,1681138800"; 
   d="scan'208";a="107113884"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 11:19:48 +0900
Received: from yto-m4.gw.nic.fujitsu.com (yto-nat-yto-m4.gw.nic.fujitsu.com [192.168.83.67])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id C1BE1C68E5
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 11:19:46 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 0545BD3F31
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 11:19:46 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.234.230])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 5E2FB6B824;
	Wed, 31 May 2023 11:19:45 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v3 1/6] cxl/monitor: Enable default_log and refactor sanity check
Date: Wed, 31 May 2023 10:19:31 +0800
Message-Id: <20230531021936.7366-2-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--14.214300-10.000000
X-TMASE-MatchedRID: MY+gfqSKTkYmIUsxKhH73B1kSRHxj+Z5+gx7Y6zr6DlXPwnnY5XL5K/n
	cbbeKXJgGch0Pdb2B17LcexyZRDdfKHtbfqnw/DJCKFDk1kJexLRNIyGX0EQxMnJhTYnTng9jcR
	qQigdY12nsveNgW5ycFeCc7s6V0VH+gtEW3D/QKYgFhzkd+/gE8E5XPQnBzGXq8KsbROd9VQhvk
	2mor77msw/xnPT4YLVIAkHRTl/xj3Tyr0pKxS1VwKDWtq/hHcNwRdjnTeqAAGbKItl61J/yZ+in
	TK0bC9eKrauXd3MZDX4ZcfVYTi075uYg5Ct0VxwxI3Ud3GIUJsWYvASVaWCkRyARZvsalY4
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

The default_log(/var/log/cxl-monitor.log) should be used when no '-l'
argument is specified in daemon mode, but it was not working at all.

Here we assigned it a default log per its arguments, and simplify the
sanity check so that it can be consistent with the document.

Please note that i also removed following addition stuff, since we have
added this prefix if needed during parsing the FILENAME in
parse_options_prefix().
if (strncmp(monitor.log, "./", 2) != 0)
    fix_filename(prefix, (const char **)&monitor.log);

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V2: exchange order of previous patch1 and patch2 # Alison
    a few commit log updated
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 cxl/monitor.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index e3469b9a4792..c6df2bad3c53 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -164,6 +164,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 	};
 	const char *prefix ="./";
 	int rc = 0, i;
+	const char *log;
 
 	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
 	for (i = 0; i < argc; i++)
@@ -171,32 +172,33 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 	if (argc)
 		usage_with_options(u, options);
 
+	// sanity check
+	if (monitor.daemon && monitor.log && !strncmp(monitor.log, "./", 2)) {
+		error("standard or relative path for <file> will not work for daemon mode\n");
+		return -EINVAL;
+	}
+
 	log_init(&monitor.ctx, "cxl/monitor", "CXL_MONITOR_LOG");
-	monitor.ctx.log_fn = log_standard;
+	if (monitor.log)
+		log = monitor.log;
+	else
+		log = monitor.daemon ? default_log : "./standard";
 
 	if (monitor.verbose)
 		monitor.ctx.log_priority = LOG_DEBUG;
 	else
 		monitor.ctx.log_priority = LOG_INFO;
 
-	if (monitor.log) {
-		if (strncmp(monitor.log, "./", 2) != 0)
-			fix_filename(prefix, (const char **)&monitor.log);
-		if (strncmp(monitor.log, "./standard", 10) == 0 && !monitor.daemon) {
-			monitor.ctx.log_fn = log_standard;
-		} else {
-			const char *log = monitor.log;
-
-			if (!monitor.log)
-				log = default_log;
-			monitor.log_file = fopen(log, "a+");
-			if (!monitor.log_file) {
-				rc = -errno;
-				error("open %s failed: %d\n", monitor.log, rc);
-				goto out;
-			}
-			monitor.ctx.log_fn = log_file;
+	if (strncmp(log, "./standard", 10) == 0)
+		monitor.ctx.log_fn = log_standard;
+	else {
+		monitor.log_file = fopen(log, "a+");
+		if (!monitor.log_file) {
+			rc = -errno;
+			error("open %s failed: %d\n", log, rc);
+			goto out;
 		}
+		monitor.ctx.log_fn = log_file;
 	}
 
 	if (monitor.daemon) {
-- 
2.29.2

