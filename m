Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 338D1210DF4EB
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 06:18:09 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id B87C2AC008D
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 22:18:04 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH 2/4] ndctl,
 monitor: set default log destination to syslog if "--daemon" is
 specified
Date: Tue,  7 Aug 2018 22:17:54 +0900
Message-Id: <20180807131756.23673-3-qi.fuli@jp.fujitsu.com>
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

When running monitor as a daemon, if the log destination is "standard" or
a relative path for log file, the messages will not be able to be logged.
Sometimes, users may not notice that the default log destination is "standard"
when they start monitor daemon by systemctl, so they will lose messages.
This patch is used to fix the unfriendly interface. When running monitor as a
daemon, the default log destination will be changed to syslog. Also, the messages
will be forwarded to syslog if the log destination is a relative path for log file.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 Documentation/ndctl/ndctl-monitor.txt | 16 +++++++++++++++-
 ndctl/monitor.c                       |  5 ++++-
 ndctl/monitor.conf                    |  2 ++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/ndctl/ndctl-monitor.txt b/Documentation/ndctl/ndctl-monitor.txt
index 1cba9ea..9a8d76b 100644
--- a/Documentation/ndctl/ndctl-monitor.txt
+++ b/Documentation/ndctl/ndctl-monitor.txt
@@ -67,7 +67,21 @@ OPTIONS
 
 -l <file | syslog | standard>::
 --log=<file | syslog | standard>::
-	Output notifications to <file>, syslog or standard output.
+	Send log messages to the specified destination.
++
+--
+<file>::
+	Send log messages to specified <file>. When fopen() is not able
+	to open <file>, log messages will be forwarded to syslog.
+syslog::
+	Send messages to syslog.
+standard::
+	Send messages to standard output.
+--
++
+The default log destination is 'syslog' if "--daemon" is specified,
+otherwise 'standard'. Note that standard and relative path for <file>
+will not work if "--daemon" is specified.
 
 -c::
 --config-file=::
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index bf1f1d3..2f3d751 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -93,7 +93,8 @@ static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
 	f = fopen(monitor.log, "a+");
 	if (!f) {
 		ndctl_set_log_fn(ctx, log_syslog);
-		err(ctx, "open logfile %s failed\n", monitor.log);
+		err(ctx, "open logfile %s failed, forward messages to syslog\n",
+				monitor.log);
 		did_fail = 1;
 		notice(ctx, "%s\n", buf);
 		goto end;
@@ -644,6 +645,8 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 	}
 
 	if (monitor.daemon) {
+		if (!monitor.log || strncmp(monitor.log, "./", 2) == 0)
+			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
 		if (daemon(0, 0) != 0) {
 			err((struct ndctl_ctx *)ctx, "daemon start failed\n");
 			goto out;
diff --git a/ndctl/monitor.conf b/ndctl/monitor.conf
index 857aadf..934e2c0 100644
--- a/ndctl/monitor.conf
+++ b/ndctl/monitor.conf
@@ -38,4 +38,6 @@
 # to standard output (log=standard) or to write into a special file (log=<file>)
 # by setting key "log". If this value is in conflict with the value of
 # [--log=<value>] option, this value will be ignored.
+# Note: Setting value to "standard" or relative path for <file> will not work
+# when running moniotr as a daemon.
 # log = /var/log/ndctl/monitor.log
-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
