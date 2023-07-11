Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EC818B18
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 11:55:09 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="124194839"
X-IronPort-AV: E=Sophos;i="6.01,196,1684767600"; 
   d="scan'208";a="124194839"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 20:53:59 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 209619C537
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 20:53:56 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 5BF85CFBC3
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 20:53:55 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.234.230])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id A10E020076844;
	Tue, 11 Jul 2023 20:53:54 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev,
	alison.schofield@intel.com
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v4 3/4] ndctl: use strcmp for reserved word in monitor commands
Date: Tue, 11 Jul 2023 19:53:43 +0800
Message-Id: <20230711115344.562823-4-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230711115344.562823-1-lizhijian@fujitsu.com>
References: <20230711115344.562823-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27744.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27744.006
X-TMASE-Result: 10--4.362400-10.000000
X-TMASE-MatchedRID: +E1SUSpNQdt15zj/0di3Qx1kSRHxj+Z5RpgtqnD1BD4yiHqxwIX2MV3w
	KTJCsiojZpCaFaIgtCAdfEeFOaCvLySKeTIQJ1bzIBYc5Hfv4BMJlr1xKkE5ucC5DTEMxpeQfiq
	1gj2xET/gr0WZ6u+ypUdIXKGnf0mFr4JCzA6K3s+eAiCmPx4NwBnUJ0Ek6yhjxEHRux+uk8hxKp
	vEGAbTDi5K23wR87ZDosT8gdFtwm+adl+NXdpcsPPElldbNnf2X2jXRtmOHUtNoddW0HpLUtHhg
	qqP/ZS2QBisM09Emc65tcP5gK+8kluMG6V02+QySir3tZId0WN+6klq53W5kJ9Gzq4huQVX
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

According to the tool's documentation, when '-l standard' is specified,
log would be output to the stdout. But since it's using strncmp(a, b, 10)
to compare the former 10 characters, it will also wrongly detect a filename
starting with a substring 'standard' as stdout.

For example:
$ cxl monitor -l standard.log

User is most likely want to save log to ./standard.log instead of stdout.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V4: combine ndctl/monitor to one patch
V3: Improve commit log # Dave
V2: commit log updated # Dave
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 cxl/monitor.c   | 2 +-
 ndctl/monitor.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index e83455b63d35..a85452a4dc82 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -188,7 +188,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 	else
 		monitor.ctx.log_priority = LOG_INFO;
 
-	if (strncmp(log, "./standard", 10) == 0)
+	if (strcmp(log, "./standard") == 0)
 		monitor.ctx.log_fn = log_standard;
 	else {
 		monitor.ctx.log_file = fopen(log, "a+");
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 89903def63d4..bd8a74863476 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -610,9 +610,9 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 	if (monitor.log) {
 		if (strncmp(monitor.log, "./", 2) != 0)
 			fix_filename(prefix, (const char **)&monitor.log);
-		if (strncmp(monitor.log, "./syslog", 8) == 0)
+		if (strcmp(monitor.log, "./syslog") == 0)
 			monitor.ctx.log_fn = log_syslog;
-		else if (strncmp(monitor.log, "./standard", 10) == 0)
+		else if (strcmp(monitor.log, "./standard") == 0)
 			monitor.ctx.log_fn = log_standard;
 		else {
 			monitor.ctx.log_file = fopen(monitor.log, "a+");
-- 
2.29.2

