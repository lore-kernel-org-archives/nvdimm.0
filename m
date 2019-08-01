Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A47FE212B5F05
 for <linux-nvdimm@lists.01.org>; Thu,  1 Aug 2019 14:21:49 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl/monitor: make the daemon exit message 'info' level
Date: Thu,  1 Aug 2019 15:19:08 -0600
Message-Id: <20190801211908.11684-1-vishal.l.verma@intel.com>
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

The 'ndctl monitor daemon started' message is at an 'info' log level,
but the corresponding exit message (if no DIMMs are found for
monitoring) was only at a 'debug' level. As a result, on a system
without NVDIMMs, the sysadmin might see a 'monitor started' message, but
a monitor wouldn't actually be running. Making the exit message the same
log level ensures that no confusion arises out of this.

Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Adam Borowski <kilobyte@angband.pl>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 6829a6b..6e7f038 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -646,7 +646,7 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		goto out;
 
 	if (!mfa.num_dimm) {
-		dbg(&monitor, "no dimms to monitor\n");
+		info(&monitor, "no dimms to monitor, exiting\n");
 		if (!monitor.daemon)
 			rc = -ENXIO;
 		goto out;
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
