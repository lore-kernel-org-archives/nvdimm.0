Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13F6921161B0A
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 17:01:05 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/2] ndctl,
 monitor: fix the severity of the "daemon started" message
Date: Thu,  4 Oct 2018 18:00:56 -0600
Message-Id: <20181005000057.30186-1-vishal.l.verma@intel.com>
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
Cc: Andreas Hasenack <andreas@canonical.com>
List-ID: <linux-nvdimm@lists.01.org>

The above message was printed as an error, but it is just an
informational message. Change it to dbg().

Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index d29e378..b44f946 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -660,7 +660,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 			err((struct ndctl_ctx *)ctx, "daemon start failed\n");
 			goto out;
 		}
-		err((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
+		dbg((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
 	}
 
 	if (parse_monitor_event(&monitor, (struct ndctl_ctx *)ctx))
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
