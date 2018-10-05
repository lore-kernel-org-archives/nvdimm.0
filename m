Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D17821130058
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 00:01:51 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id A2C8AAC0237
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 16:01:46 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH] ndctl, monitor: fix the sevrity of "daemon started" message
Date: Fri,  5 Oct 2018 16:01:24 +0900
Message-Id: <20181005070124.6429-1-qi.fuli@jp.fujitsu.com>
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

The "daemon started" message was printed as an error and this is improper.
This patch is used to chang it to info() meanwhile to chang the default log
level of monitor to "LOG_INFO".

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/monitor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index d29e378..17465bb 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -628,7 +628,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 	if (monitor.verbose)
 		ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_DEBUG);
 	else
-		ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_NOTICE);
+		ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_INFO);
 
 	rc = read_config_file((struct ndctl_ctx *)ctx, &monitor, &param);
 	if (rc)
@@ -660,7 +660,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 			err((struct ndctl_ctx *)ctx, "daemon start failed\n");
 			goto out;
 		}
-		err((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
+		info((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
 	}
 
 	if (parse_monitor_event(&monitor, (struct ndctl_ctx *)ctx))
-- 
2.19.0.rc0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
