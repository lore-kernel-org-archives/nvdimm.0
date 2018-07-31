Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1870121BADAB2
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jul 2018 22:15:31 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 92569AC0153
 for <linux-nvdimm@lists.01.org>; Tue, 31 Jul 2018 14:15:25 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndclt PATCH] ndctl, monitor: Fix duplicate prefix in monitor.log
Date: Tue, 31 Jul 2018 14:15:03 +0900
Message-Id: <20180731051503.30719-1-qi.fuli@jp.fujitsu.com>
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

When a monitor runs with [--log] option, the prefix will be dually
added to monitor.log. Therefore, the monitor cannot log the smart
notification to syslog. This patch is used to prevent prefix from
being dually added to monitor.log.

Fixes: fdf6b6844ccf ("ndctl, monitor: add a new command - monitor")
Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/monitor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index c6419ad..4e5daf5 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -614,7 +614,8 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 		goto out;
 
 	if (monitor.log) {
-		fix_filename(prefix, (const char **)&monitor.log);
+		if (strncmp(monitor.log, "./", 2) != 0)
+			fix_filename(prefix, (const char **)&monitor.log);
 		if (strncmp(monitor.log, "./syslog", 8) == 0)
 			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
 		else if (strncmp(monitor.log, "./standard", 10) == 0)
-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
