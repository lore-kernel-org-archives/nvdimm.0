Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FD2747E
	for <nvdimm@lists.linux.dev>; Mon, 19 Sep 2022 23:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663631236; x=1695167236;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PzR8Wb2kCaqO4zluutW6/HGGZBdN3ctdqpmX6wnyvNs=;
  b=YnwpO6I+3uU5sW/TeNliSnsIp2Q8gKzDUdTRiJaGI7UrTQpM16o8qw1U
   oej9A3//rg8sYBWRnNDHecgurzFXqKWjTQogc5sAKARcxkJuEJsT18vKR
   p40si5GJn5bSzn78u3fhG0ZQqOG3sGtH7Gy72PcbXh8VDhLfvywx2sTTc
   jvbHr59+15KGsGygNOyIVviOUCmOY/iLyCbQe34FzVcB4Vgo1R9pPmXoR
   b/NOzj8BvdW9lqDczx5bWRDv6mtdEaZLqixHPA0ZxjURgjzbHrHkTLJoj
   TaFdcD3cV0NuhyfCf9GvvcYnRv6f1IqWWD0ExbR9YF4rRndhrC+k2b5tu
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="286597134"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="286597134"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:47:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="618690591"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:47:15 -0700
Subject: [PATCH v2 7/9] cxl: add monitor command to cxl
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 bwidawsk@kernel.org, dan.j.williams@intel.com, nafonten@amd.com,
 nvdimm@lists.linux.dev
Date: Mon, 19 Sep 2022 16:47:15 -0700
Message-ID: 
 <166363123540.3861186.1589822434454578520.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Connect the monitoring functionality to the cxl monitor command. Add basic
functionality to the cxl monitor command where it can be launched as a daemon
and logging can be designated to stdout or a file.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/builtin.h |    1 +
 cxl/cxl.c     |    1 +
 cxl/monitor.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+)

diff --git a/cxl/builtin.h b/cxl/builtin.h
index b28c2213993b..34c5cfb49051 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -22,4 +22,5 @@ int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx);
 #endif /* _CXL_BUILTIN_H_ */
diff --git a/cxl/cxl.c b/cxl/cxl.c
index dd1be7a054a1..3be7026f43d3 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -76,6 +76,7 @@ static struct cmd_struct commands[] = {
 	{ "enable-region", .c_fn = cmd_enable_region },
 	{ "disable-region", .c_fn = cmd_disable_region },
 	{ "destroy-region", .c_fn = cmd_destroy_region },
+	{ "monitor", .c_fn = cmd_monitor },
 };
 
 int main(int argc, const char **argv)
diff --git a/cxl/monitor.c b/cxl/monitor.c
index c241ed31584f..e24200ea9d96 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -32,11 +32,15 @@
 #include "event_trace.h"
 
 static const char *cxl_system = "cxl";
+const char *default_log = "/var/log/cxl-monitor.log";
 
 static struct monitor {
+	const char *log;
 	struct log_ctx ctx;
 	FILE *log_file;
 	bool human;
+	bool verbose;
+	bool daemon;
 } monitor;
 
 static void log_standard(struct log_ctx *ctx, int priority, const char *file,
@@ -162,3 +166,74 @@ epoll_err:
 	free(events);
 	return rc;
 }
+
+int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	const struct option options[] = {
+		OPT_FILENAME('l', "log", &monitor.log,
+				"<file> | standard",
+				"where to output the monitor's notification"),
+		OPT_BOOLEAN('\0', "daemon", &monitor.daemon,
+				"run cxl monitor as a daemon"),
+		OPT_BOOLEAN('u', "human", &monitor.human,
+				"use human friendly output formats"),
+		OPT_BOOLEAN('v', "verbose", &monitor.verbose,
+				"emit extra debug messages to log"),
+		OPT_END(),
+	};
+	const char * const u[] = {
+		"cxl monitor [<options>]",
+		NULL
+	};
+	const char *prefix ="./";
+	int rc = 0, i;
+
+	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
+	for (i = 0; i < argc; i++)
+		error("unknown parameter \"%s\"\n", argv[i]);
+	if (argc)
+		usage_with_options(u, options);
+
+	log_init(&monitor.ctx, "cxl/monitor", "CXL_MONITOR_LOG");
+	monitor.ctx.log_fn = log_standard;
+
+	if (monitor.verbose)
+		monitor.ctx.log_priority = LOG_DEBUG;
+	else
+		monitor.ctx.log_priority = LOG_INFO;
+
+	if (monitor.log) {
+		if (strncmp(monitor.log, "./", 2) != 0)
+			fix_filename(prefix, (const char **)&monitor.log);
+		if (strncmp(monitor.log, "./standard", 10) == 0 && !monitor.daemon) {
+			monitor.ctx.log_fn = log_standard;
+		} else {
+			const char *log = monitor.log;
+
+			if (!monitor.log)
+				log = default_log;
+			monitor.log_file = fopen(log, "a+");
+			if (!monitor.log_file) {
+				rc = -errno;
+				error("open %s failed: %d\n", monitor.log, rc);
+				goto out;
+			}
+			monitor.ctx.log_fn = log_file;
+		}
+	}
+
+	if (monitor.daemon) {
+		if (daemon(0, 0) != 0) {
+			err(&monitor, "daemon start failed\n");
+			goto out;
+		}
+		info(&monitor, "cxl monitor daemon started.\n");
+	}
+
+	rc = monitor_event(ctx);
+
+out:
+	if (monitor.log_file)
+		fclose(monitor.log_file);
+	return rc;
+}


