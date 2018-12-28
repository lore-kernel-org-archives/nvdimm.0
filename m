Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CFD7A2119EF2B
 for <linux-nvdimm@lists.01.org>; Thu, 27 Dec 2018 19:42:50 -0800 (PST)
Subject: [ndctl PATCH 3/7] ndctl/monitor: Drop 'struct ndctl_ctx *' casts
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Dec 2018 19:30:14 -0800
Message-ID: <154596781442.164521.11095363906849256036.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154596779833.164521.12632457592535372923.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <154596779833.164521.12632457592535372923.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Now that the command harness is type-safe with respect to the @ctx
argument. Drop the casts in cmd_monitor().

Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/monitor.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 47caae55d56d..08219f99b12b 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -623,14 +623,14 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		usage_with_options(u, options);
 
 	/* default to log_standard */
-	ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_standard);
+	ndctl_set_log_fn(ctx, log_standard);
 
 	if (monitor.verbose)
-		ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_DEBUG);
+		ndctl_set_log_priority(ctx, LOG_DEBUG);
 	else
-		ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_INFO);
+		ndctl_set_log_priority(ctx, LOG_INFO);
 
-	rc = read_config_file((struct ndctl_ctx *)ctx, &monitor, &param);
+	rc = read_config_file(ctx, &monitor, &param);
 	if (rc)
 		goto out;
 
@@ -638,7 +638,7 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		if (strncmp(monitor.log, "./", 2) != 0)
 			fix_filename(prefix, (const char **)&monitor.log);
 		if (strncmp(monitor.log, "./syslog", 8) == 0)
-			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
+			ndctl_set_log_fn(ctx, log_syslog);
 		else if (strncmp(monitor.log, "./standard", 10) == 0)
 			; /*default, already set */
 		else {
@@ -649,21 +649,21 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 				goto out;
 			}
 			fclose(f);
-			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_file);
+			ndctl_set_log_fn(ctx, log_file);
 		}
 	}
 
 	if (monitor.daemon) {
 		if (!monitor.log || strncmp(monitor.log, "./", 2) == 0)
-			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
+			ndctl_set_log_fn(ctx, log_syslog);
 		if (daemon(0, 0) != 0) {
-			err((struct ndctl_ctx *)ctx, "daemon start failed\n");
+			err(ctx, "daemon start failed\n");
 			goto out;
 		}
-		info((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
+		info(ctx, "ndctl monitor daemon started\n");
 	}
 
-	if (parse_monitor_event(&monitor, (struct ndctl_ctx *)ctx))
+	if (parse_monitor_event(&monitor, ctx))
 		goto out;
 
 	fctx.filter_bus = filter_bus;
@@ -681,7 +681,7 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		goto out;
 
 	if (!mfa.num_dimm) {
-		dbg((struct ndctl_ctx *)ctx, "no dimms to monitor\n");
+		dbg(ctx, "no dimms to monitor\n");
 		if (!monitor.daemon)
 			rc = -ENXIO;
 		goto out;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
