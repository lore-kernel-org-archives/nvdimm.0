Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x241.google.com (mail-qt0-x241.google.com
 [IPv6:2607:f8b0:400d:c0d::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAC8D21131DB8
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jun 2018 13:44:14 -0700 (PDT)
Received: by mail-qt0-x241.google.com with SMTP id i18-v6so1047986qtp.12
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jun 2018 13:44:14 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH] ndctl: add a test file to .gitignore
Date: Tue, 19 Jun 2018 16:44:10 -0400
Message-Id: <20180619204410.19766-1-msys.mizuma@gmail.com>
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

Add test/ack-shutdown-count-set to .gitignore.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index c7d11d9..1016b3b 100644
--- a/.gitignore
+++ b/.gitignore
@@ -55,3 +55,4 @@ test/smart-listen
 test/smart-notify
 test/fio.job
 test/local-write-0-verify.state
+test/ack-shutdown-count-set
-- 
2.18.0.rc1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
