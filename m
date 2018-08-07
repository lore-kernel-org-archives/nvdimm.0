Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7C628210DC1BF
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 06:18:07 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 975DAAC00FD
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 22:18:03 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH 1/4] ndctl,
 monitor: fix the lack of detection of invalid path of log file
Date: Tue,  7 Aug 2018 22:17:53 +0900
Message-Id: <20180807131756.23673-2-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
References: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Currently the monitor can be started even with an invalid path of log file.
This patch adds a detection of invalid path of log file when starting monitor.
If the path of log file is invalid, the monitor will refuse to be started.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/monitor.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index f10384b..bf1f1d3 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -603,6 +603,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 	struct util_filter_ctx fctx = { 0 };
 	struct monitor_filter_arg mfa = { 0 };
 	int i, rc;
+	FILE *f;
 
 	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
 	for (i = 0; i < argc; i++) {
@@ -630,8 +631,16 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
 		else if (strncmp(monitor.log, "./standard", 10) == 0)
 			; /*default, already set */
-		else
+		else {
+			f = fopen(monitor.log, "a+");
+			if (!f) {
+				error("open %s failed\n", monitor.log);
+				rc = -errno;
+				goto out;
+			}
+			fclose(f);
 			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_file);
+		}
 	}
 
 	if (monitor.daemon) {
-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
