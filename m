Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x242.google.com (mail-qt0-x242.google.com
 [IPv6:2607:f8b0:400d:c0d::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 52A44210C1EFB
 for <linux-nvdimm@lists.01.org>; Wed,  1 Aug 2018 11:56:15 -0700 (PDT)
Received: by mail-qt0-x242.google.com with SMTP id n6-v6so21110706qtl.4
 for <linux-nvdimm@lists.01.org>; Wed, 01 Aug 2018 11:56:15 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH] ndctl, monitor: Change the fail log priority to err.
Date: Wed,  1 Aug 2018 14:55:38 -0400
Message-Id: <20180801185538.27084-1-msys.mizuma@gmail.com>
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
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

fail() is called if an error happens, but the log priority
is debug, so user may not notice the error.
Let's change the priority to err.

Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 ndctl/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 84d51c4..68bbf65 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -40,7 +40,7 @@ static int did_fail;
 #define fail(fmt, ...) \
 do { \
 	did_fail = 1; \
-	dbg(ctx, "ndctl-%s:%s:%d: " fmt, \
+	err(ctx, "ndctl-%s:%s:%d: " fmt, \
 			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
 } while (0)
 
-- 
2.18.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
