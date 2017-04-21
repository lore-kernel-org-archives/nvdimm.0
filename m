Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x243.google.com (mail-io0-x243.google.com
 [IPv6:2607:f8b0:4001:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D4FF2195406F
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 00:12:38 -0700 (PDT)
Received: by mail-io0-x243.google.com with SMTP id d203so27154917iof.2
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 00:12:38 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 1/3] ndctl, create-namespace: Allow 64K and 16M alignments
Date: Fri, 21 Apr 2017 17:12:17 +1000
Message-Id: <20170421071219.18744-1-oohall@gmail.com>
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

These are needed on powerpc since 64K is the default page size and 16MB
is the PMD size when using the hash MMU.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 ndctl/builtin-xaction-namespace.c | 2 ++
 util/size.h                       | 1 +
 2 files changed, 3 insertions(+)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 46d651e86153..d6c38dc15984 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -494,7 +494,9 @@ static int validate_namespace_options(struct ndctl_region *region,
 
 		switch (p->align) {
 		case SZ_4K:
+		case SZ_64K:
 		case SZ_2M:
+		case SZ_16M:
 		case SZ_1G:
 			break;
 		default:
diff --git a/util/size.h b/util/size.h
index 4af14eb7d150..f1bfd1a30438 100644
--- a/util/size.h
+++ b/util/size.h
@@ -3,6 +3,7 @@
 
 #define SZ_1K     0x00000400
 #define SZ_4K     0x00001000
+#define SZ_64K    0x00010000
 #define SZ_1M     0x00100000
 #define SZ_2M     0x00200000
 #define SZ_4M     0x00400000
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
