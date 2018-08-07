Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C103210DC1DB
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 06:18:11 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id E87DEAC00FD
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 22:18:05 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH 3/4] ndctl,
 monitor: add timestamp and pid to log messages in log_file()
Date: Tue,  7 Aug 2018 22:17:55 +0900
Message-Id: <20180807131756.23673-4-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
References: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
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

This patch is used to add timestamp and process id to log messages when logging
messages to a file.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/monitor.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 2f3d751..d29e378 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -84,6 +84,8 @@ static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
 {
 	FILE *f;
 	char *buf;
+	struct timespec ts;
+	char timestamp[32];
 
 	if (vasprintf(&buf, format, args) < 0) {
 		fail("vasprintf error\n");
@@ -99,7 +101,14 @@ static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
 		notice(ctx, "%s\n", buf);
 		goto end;
 	}
-	fprintf(f, "%s", buf);
+
+	if (priority != LOG_NOTICE) {
+		clock_gettime(CLOCK_REALTIME, &ts);
+		sprintf(timestamp, "%10ld.%09ld", ts.tv_sec, ts.tv_nsec);
+		fprintf(f, "[%s] [%d] %s", timestamp, getpid(), buf);
+	} else
+		fprintf(f, "%s", buf);
+
 	fflush(f);
 	fclose(f);
 end:
-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
