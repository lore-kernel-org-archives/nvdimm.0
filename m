Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD9FF223DB78C
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 23:56:58 -0800 (PST)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id F395DAC01D9
 for <linux-nvdimm@lists.01.org>; Fri,  9 Feb 2018 17:02:38 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [RfC PATCH v3 5/5] ndctl: monitor: add ndclt destroy-monitor command
Date: Fri,  9 Feb 2018 17:02:25 +0900
Message-Id: <20180209080225.5137-6-qi.fuli@jp.fujitsu.com>
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

This patch is used to add $ndctl destroy-monitor command, by which users
can destroy a monitor. After the monitor is destroyed, the file with
same name under /var/ndctl/monitor will also be deleted.
Example: #ndctl destroy-monitor --monitor m_nmem1

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 builtin.h       |  1 +
 ndctl/monitor.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/ndctl.c   |  1 +
 3 files changed, 56 insertions(+)

diff --git a/builtin.h b/builtin.h
index b5a006d..2143666 100644
--- a/builtin.h
+++ b/builtin.h
@@ -39,6 +39,7 @@ int cmd_inject_error(int argc, const char **argv, void *ctx);
 int cmd_create_monitor(int argc, const char **argv, void *ctx);
 int cmd_list_monitor(int argc, const char **argv, void *ctx);
 int cmd_show_monitor(int argc, const char **argv, void *ctx);
+int cmd_destroy_monitor(int argc, const char **argv, void *ctx);
 int cmd_list(int argc, const char **argv, void *ctx);
 #ifdef ENABLE_TEST
 int cmd_test(int argc, const char **argv, void *ctx);
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 1cff2d8..563a726 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -407,3 +407,57 @@ int cmd_show_monitor(int argc, const char **argv, void *ctx)
 out:
 	return 1;
 }
+
+int cmd_destroy_monitor(int argc, const char **argv, void *ctx)
+{
+	const struct option options[] = {
+		OPT_STRING('m', "monitor", &param.monitor, "monitor name",
+				"monitor name")
+	};
+	const char * const u[] = {
+		"ndctl destroy-monitor <monitor>",
+		NULL
+	};
+	argc = parse_options(argc, argv, options, u, 0);
+	for (int i = 0; i < argc; i++) {
+		error("unknown parameter \"%s\"\n", argv[i]);
+		goto out;
+	}
+	if (!param.monitor) {
+		error("monitor name --monitor is required\n");
+		goto out;
+	}
+
+	char *filename;
+	struct json_object *jmonitors, *jpid;
+	int pid;
+	filename = get_full_path_filename(proc_path, param.monitor);
+	jmonitors = json_object_from_file(filename);
+	if (jmonitors == NULL) {
+		error("monitor %s is not exist\n", param.monitor);
+		goto out;
+	}
+
+	if (!json_object_object_get_ex(jmonitors, "pid", &jpid)) {
+		error("cannot find pid in %s\n", filename);
+		goto out;
+	}
+	pid = json_object_get_int(jpid);
+	if (!pid) {
+		error("cannot find pid in %s\n", filename);
+		goto out;
+	}
+	if (kill(pid, SIGUSR1) != 0) {
+		error("failed to kill pid(%d)\n", pid);
+		goto out;
+	}
+	if (destroy_monitor_proc() != 0) {
+		error("failed to delete %s\n", filename);
+		goto out;
+	}
+	printf("destroy monitor %s successed\n", param.monitor);
+
+	return 0;
+out:
+	return 1;
+}
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 460cf76..ad69222 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -87,6 +87,7 @@ static struct cmd_struct commands[] = {
 	{ "create-monitor", cmd_create_monitor },
 	{ "list-monitor", cmd_list_monitor },
 	{ "show-monitor", cmd_show_monitor },
+	{ "destroy-monitor", cmd_destroy_monitor },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST
-- 
2.9.5


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
