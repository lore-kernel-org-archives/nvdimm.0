Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F3A79223DB78C
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 23:56:55 -0800 (PST)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id C04C1AC00DC
 for <linux-nvdimm@lists.01.org>;
 Fri,  9 Feb 2018 17:02:35 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [RFC PATCH v3 1/5] ndctl: nvdimmd: add LOG_NOTICE level to
Date: Fri,  9 Feb 2018 17:02:21 +0900
Message-Id: <20180209080225.5137-2-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180209080225.5137-1-qi.fuli@jp.fujitsu.com>
References: <20180209080225.5137-1-qi.fuli@jp.fujitsu.com>
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

This patch adds LOG_NOTICE level to log_priority for the notifications
of nvdimm dimm over threshold event. Currently, the LOG_INFO level
is too low, and the notifications are not up to LOG_ERROR level.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 util/log.c | 2 ++
 util/log.h | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/util/log.c b/util/log.c
index cc4d7d8..c60ca33 100644
--- a/util/log.c
+++ b/util/log.c
@@ -50,6 +50,8 @@ static int log_priority(const char *priority)
 		return LOG_INFO;
 	if (strncmp(priority, "debug", 5) == 0)
 		return LOG_DEBUG;
+	if (strncmp(priority, "notice", 6) == 0)
+		return LOG_NOTICE;
 	return 0;
 }
 
diff --git a/util/log.h b/util/log.h
index 5fc56e8..495e0d3 100644
--- a/util/log.h
+++ b/util/log.h
@@ -48,15 +48,18 @@ do { \
 #  endif
 #  define log_info(ctx, arg...) log_cond(ctx, LOG_INFO, ## arg)
 #  define log_err(ctx, arg...) log_cond(ctx, LOG_ERR, ## arg)
+#  define log_notice(ctx, arg...) log_cond(ctx, LOG_NOTICE, ## arg)
 #else
 #  define log_dbg(ctx, arg...) log_null(ctx, ## arg)
 #  define log_info(ctx, arg...) log_null(ctx, ## arg)
 #  define log_err(ctx, arg...) log_null(ctx, ## arg)
+#  define log_notice(ctx, arg...) log_null(ctx, ## arg)
 #endif
 
 #define dbg(x, arg...) log_dbg(&(x)->ctx, ## arg)
 #define info(x, arg...) log_info(&(x)->ctx, ## arg)
 #define err(x, arg...) log_err(&(x)->ctx, ## arg)
+#define notice(x, arg...) log_notice(&(x)->ctx, ## arg)
 
 #ifndef HAVE_SECURE_GETENV
 #  ifdef HAVE___SECURE_GETENV
-- 
2.9.5


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
