Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x244.google.com (mail-qt0-x244.google.com
 [IPv6:2607:f8b0:400d:c0d::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 68602202E53F1
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 08:45:44 -0700 (PDT)
Received: by mail-qt0-x244.google.com with SMTP id z6-v6so10308568qti.2
 for <linux-nvdimm@lists.01.org>; Fri, 06 Jul 2018 08:45:44 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [ndctl PATCH] ndctl,
 test: remove the firmware image file before the test end
Date: Fri,  6 Jul 2018 11:44:55 -0400
Message-Id: <20180706154455.5600-1-msys.mizuma@gmail.com>
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

Remove test/update-fw.img before test/firmware-update.sh end.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 test/firmware-update.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/firmware-update.sh b/test/firmware-update.sh
index 50674a6..7852e58 100755
--- a/test/firmware-update.sh
+++ b/test/firmware-update.sh
@@ -40,5 +40,6 @@ reset
 rc=2
 detect
 do_tests
+rm -f $image
 _cleanup
 exit 0
-- 
2.18.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
