Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AEF96209831F7
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 16:00:15 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 4/4] ndctl,
 monitor: improve error reporting throughout monitor.c
Date: Thu, 19 Jul 2018 16:59:58 -0600
Message-Id: <20180719225958.6814-5-vishal.l.verma@intel.com>
In-Reply-To: <20180719225958.6814-1-vishal.l.verma@intel.com>
References: <20180719225958.6814-1-vishal.l.verma@intel.com>
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

In several places in the ndctl monitor, we were losing useful error
information (from 'errno' for example), and just returning a simple '1'
or '-1'. Fix these to capture and propagate the correct errors
everywhere.

In the case of notify_dimm_event(), don't error out for failures of
json_object_new_*. Follow the precedent of util/json.c and only add the
object to its parent if the 'new' function was successful.

Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/monitor.c | 58 +++++++++++++++++++++++----------------------------------
 1 file changed, 23 insertions(+), 35 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 7fc2aaa..dbad7aa 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -174,45 +174,30 @@ static int notify_dimm_event(struct monitor_dimm *mdimm)
 	jmsg = json_object_new_object();
 	if (!jmsg) {
 		fail("\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	clock_gettime(CLOCK_REALTIME, &ts);
 	sprintf(timestamp, "%10ld.%09ld", ts.tv_sec, ts.tv_nsec);
 	jobj = json_object_new_string(timestamp);
-	if (!jobj) {
-		fail("\n");
-		return -1;
-	}
-	json_object_object_add(jmsg, "timestamp", jobj);
+	if (jobj)
+		json_object_object_add(jmsg, "timestamp", jobj);
 
 	jobj = json_object_new_int(getpid());
-	if (!jobj) {
-		fail("\n");
-		return -1;
-	}
-	json_object_object_add(jmsg, "pid", jobj);
+	if (jobj)
+		json_object_object_add(jmsg, "pid", jobj);
 
 	jobj = dimm_event_to_json(mdimm);
-	if (!jobj) {
-		fail("\n");
-		return -1;
-	}
-	json_object_object_add(jmsg, "event", jobj);
+	if (jobj)
+		json_object_object_add(jmsg, "event", jobj);
 
 	jdimm = util_dimm_to_json(mdimm->dimm, 0);
-	if (!jdimm) {
-		fail("\n");
-		return -1;
-	}
-	json_object_object_add(jmsg, "dimm", jdimm);
+	if (jdimm)
+		json_object_object_add(jmsg, "dimm", jdimm);
 
 	jobj = util_dimm_health_to_json(mdimm->dimm);
-	if (!jobj) {
-		fail("\n");
-		return -1;
-	}
-	json_object_object_add(jdimm, "health", jobj);
+	if (jobj)
+		json_object_object_add(jdimm, "health", jobj);
 
 	if (monitor.human)
 		notice(ctx, "%s\n", json_object_to_json_string_ext(jmsg,
@@ -403,9 +388,12 @@ static int monitor_event(struct ndctl_ctx *ctx,
 		for (i = 0; i < nfds; i++) {
 			mdimm = events[i].data.ptr;
 			if (util_dimm_event_filter(mdimm, monitor.event_flags)) {
-				if (notify_dimm_event(mdimm))
+				rc = notify_dimm_event(mdimm);
+				if (rc) {
 					fail("%s: notify dimm event failed\n",
 						ndctl_dimm_get_devname(mdimm->dimm));
+					goto out;
+				}
 			}
 			rc = pread(mdimm->health_eventfd, &buf, sizeof(buf), 0);
 			if (rc < 0) {
@@ -601,7 +589,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 	const char *prefix = "./";
 	struct util_filter_ctx fctx = { 0 };
 	struct monitor_filter_arg mfa = { 0 };
-	int i;
+	int i, rc;
 
 	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
 	for (i = 0; i < argc; i++) {
@@ -614,7 +602,8 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 	ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_standard);
 	ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_NOTICE);
 
-	if (read_config_file((struct ndctl_ctx *)ctx, &monitor, &param))
+	rc = read_config_file((struct ndctl_ctx *)ctx, &monitor, &param);
+	if (rc)
 		goto out;
 
 	if (monitor.log) {
@@ -648,18 +637,17 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 	mfa.maxfd_dimm = -1;
 	mfa.flags = 0;
 
-	if (util_filter_walk(ctx, &fctx, &param))
+	rc = util_filter_walk(ctx, &fctx, &param);
+	if (rc)
 		goto out;
 
 	if (!mfa.num_dimm) {
 		err((struct ndctl_ctx *)ctx, "no dimms to monitor\n");
+		rc = -ENXIO;
 		goto out;
 	}
 
-	if (monitor_event(ctx, &mfa))
-		goto out;
-
-	return 0;
+	rc = monitor_event(ctx, &mfa);
 out:
-	return 1;
+	return rc;
 }
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
