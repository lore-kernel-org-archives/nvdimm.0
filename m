Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B59B321F0DA76
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 23:57:00 -0800 (PST)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 8010CAC018F
 for <linux-nvdimm@lists.01.org>;
 Fri,  9 Feb 2018 17:02:37 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [RFC PATCH v3 3/5] ndctl: monitor: add ndclt list-monitor command
Date: Fri,  9 Feb 2018 17:02:23 +0900
Message-Id: <20180209080225.5137-4-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180209080225.5137-1-qi.fuli@jp.fujitsu.com>
References: <20180209080225.5137-1-qi.fuli@jp.fujitsu.com>
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

This patch adds $ndctl list-monitor command, by which users can list all
currently running monitors.
Example: $ndctl list-monitor --all

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 builtin.h       |  1 +
 ndctl/monitor.c | 32 ++++++++++++++++++++++++++++++++
 ndctl/ndctl.c   |  1 +
 3 files changed, 34 insertions(+)

diff --git a/builtin.h b/builtin.h
index 850f6a8..eda5c7a 100644
--- a/builtin.h
+++ b/builtin.h
@@ -37,6 +37,7 @@ int cmd_init_labels(int argc, const char **argv, void *ctx);
 int cmd_check_labels(int argc, const char **argv, void *ctx);
 int cmd_inject_error(int argc, const char **argv, void *ctx);
 int cmd_create_monitor(int argc, const char **argv, void *ctx);
+int cmd_list_monitor(int argc, const char **argv, void *ctx);
 int cmd_list(int argc, const char **argv, void *ctx);
 #ifdef ENABLE_TEST
 int cmd_test(int argc, const char **argv, void *ctx);
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index cf1cd6e..53b7c67 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -340,3 +340,35 @@ int cmd_create_monitor(int argc, const char **argv, void *ctx)
 out:
 	return 1;
 }
+
+int cmd_list_monitor(int argc, const char **argv, void *ctx)
+{
+	const struct option options[] = {
+		OPT_BOOLEAN('a', "all", &param.all, "list all monitors")
+	};
+	const char * const u[] = {
+		"ndctl list-monitor [<options>]",
+		NULL
+	};
+	argc = parse_options(argc, argv, options, u, 0);
+	for (int i = 0; i < argc; i++) {
+		error("unknown parameter \"%s\"\n", argv[i]);
+		goto out;
+	}
+	DIR *dir;
+	struct dirent *ent;
+	dir = opendir("/var/ndctl/monitor/");
+	if (!dir)
+		return -1;
+	while ((ent = readdir(dir)) != NULL)
+	{
+		if (strcmp(ent->d_name, ".") == 0
+				|| strcmp(ent->d_name, "..") == 0)
+			continue;
+		printf(" %s\n", ent->d_name);
+	}
+	return 0;
+
+out:
+	return 1;
+}
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 6c63d79..7eae794 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -85,6 +85,7 @@ static struct cmd_struct commands[] = {
 	{ "check-labels", cmd_check_labels },
 	{ "inject-error", cmd_inject_error },
 	{ "create-monitor", cmd_create_monitor },
+	{ "list-monitor", cmd_list_monitor },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST
-- 
2.9.5


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
