Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8EE742194EB70
 for <linux-nvdimm@lists.01.org>; Fri, 29 Mar 2019 04:02:04 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 113E4AC0112
 for <linux-nvdimm@lists.01.org>; Fri, 29 Mar 2019 20:01:59 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH] monitor: removing the requirement of default config
Date: Fri, 29 Mar 2019 20:01:50 +0900
Message-Id: <20190329110150.3725-1-qi.fuli@jp.fujitsu.com>
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

Removing the requirement of default configuration file.
If "-c, --config-file" option is not specified, default configuration
file should be dispensable.

Link: https://github.com/pmem/ndctl/issues/83
Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>

---
 ndctl/monitor.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 346a6df..6829a6b 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -484,8 +484,11 @@ static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
 
 	f = fopen(config_file, "r");
 	if (!f) {
-		err(&monitor, "config-file: %s cannot be opened\n", config_file);
-		rc = -errno;
+		if (_monitor->config_file) {
+			err(&monitor, "config-file: %s cannot be opened\n",
+				config_file);
+			rc = -errno;
+		}
 		goto out;
 	}
 
-- 
2.21.0.rc1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
