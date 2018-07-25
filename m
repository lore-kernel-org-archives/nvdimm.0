Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D01E210C1B83
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 17:09:28 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl,
 monitor: fix a resource leak in parse_monitor_event
Date: Tue, 24 Jul 2018 18:09:13 -0600
Message-Id: <20180725000913.25528-1-vishal.l.verma@intel.com>
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

Static analysis reports we leak dimm_event in the above function.
Fix it by adding an 'out' label for all exit paths, and refactoring out
the 'all events' cases.

Fixes: fdf6b6844ccf ("ndctl, monitor: add a new command - monitor")
Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/monitor.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index dbad7aa..b97d1ea 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -410,22 +410,35 @@ static int monitor_event(struct ndctl_ctx *ctx,
 	return rc;
 }
 
+static void monitor_enable_all_events(struct monitor *_monitor)
+{
+	_monitor->event_flags = ND_EVENT_SPARES_REMAINING
+			| ND_EVENT_MEDIA_TEMPERATURE
+			| ND_EVENT_CTRL_TEMPERATURE
+			| ND_EVENT_HEALTH_STATE
+			| ND_EVENT_UNCLEAN_SHUTDOWN;
+}
+
 static int parse_monitor_event(struct monitor *_monitor, struct ndctl_ctx *ctx)
 {
 	char *dimm_event, *save;
 	const char *event;
+	int rc = 0;
+
+	if (!_monitor->dimm_event) {
+		monitor_enable_all_events(_monitor);
+		return 0;;
+	}
 
-	if (!_monitor->dimm_event)
-		goto dimm_event_all;
 	dimm_event = strdup(_monitor->dimm_event);
 	if (!dimm_event)
-		return 1;
+		return -ENOMEM;
 
 	for (event = strtok_r(dimm_event, " ", &save); event;
 			event = strtok_r(NULL, " ", &save)) {
 		if (strcmp(event, "all") == 0) {
-			free(dimm_event);
-			goto dimm_event_all;
+			monitor_enable_all_events(_monitor);
+			goto out;
 		}
 		if (strcmp(event, "dimm-spares-remaining") == 0)
 			_monitor->event_flags |= ND_EVENT_SPARES_REMAINING;
@@ -439,20 +452,14 @@ static int parse_monitor_event(struct monitor *_monitor, struct ndctl_ctx *ctx)
 			_monitor->event_flags |= ND_EVENT_UNCLEAN_SHUTDOWN;
 		else {
 			err(ctx, "no dimm-event named %s\n", event);
-			return 1;
+			rc = -EINVAL;
+			goto out;
 		}
 	}
 
+out:
 	free(dimm_event);
-	return 0;
-
-dimm_event_all:
-	_monitor->event_flags = ND_EVENT_SPARES_REMAINING
-			| ND_EVENT_MEDIA_TEMPERATURE
-			| ND_EVENT_CTRL_TEMPERATURE
-			| ND_EVENT_HEALTH_STATE
-			| ND_EVENT_UNCLEAN_SHUTDOWN;
-	return 0;
+	return rc;
 }
 
 static void parse_config(const char **arg, char *key, char *val, char *ident)
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
