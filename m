Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com
 [IPv6:2607:f8b0:4864:20::444])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D27A21A09130
 for <linux-nvdimm@lists.01.org>; Mon, 19 Nov 2018 00:01:13 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id b7so1225088pfi.8
 for <linux-nvdimm@lists.01.org>; Mon, 19 Nov 2018 00:01:13 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 4/4] ndctl/namespace: Validate alignment from the {pfn|dax}
 seed
Date: Mon, 19 Nov 2018 19:00:56 +1100
Message-Id: <20181119080056.13386-4-oohall@gmail.com>
In-Reply-To: <20181119080056.13386-1-oohall@gmail.com>
References: <20181119080056.13386-1-oohall@gmail.com>
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

This patch adds support to the ndctl tool for validating that the
namespace alignment is valid.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 ndctl/namespace.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 1e04f32c0e95..6f8dca288527 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -537,8 +537,18 @@ static int validate_namespace_options(struct ndctl_region *region,
 	}
 
 	if (param.align) {
-		if (p->mode != NDCTL_NS_MODE_MEMORY &&
-		    p->mode != NDCTL_NS_MODE_DAX) {
+		int i, alignments;
+
+		switch (p->mode) {
+		case NDCTL_NS_MODE_MEMORY:
+			alignments = ndctl_pfn_get_num_alignments(pfn);
+			break;
+
+		case NDCTL_NS_MODE_DAX:
+			alignments = ndctl_dax_get_num_alignments(dax);
+			break;
+
+		default:
 			error("%s mode does not support setting an alignment\n",
 					p->mode == NDCTL_NS_MODE_SAFE
 					? "sector" : "raw");
@@ -546,13 +556,19 @@ static int validate_namespace_options(struct ndctl_region *region,
 		}
 
 		p->align = parse_size64(param.align);
+		for (i = 0; i < alignments; i++) {
+			uint64_t a;
 
-		switch (p->align) {
-		case SZ_4K:
-		case SZ_2M:
-		case SZ_1G:
-			break;
-		default:
+			if (p->mode == NDCTL_NS_MODE_MEMORY)
+				a = ndctl_pfn_get_supported_alignment(pfn, i);
+			else
+				a = ndctl_dax_get_supported_alignment(dax, i);
+
+			if (p->align == a)
+				break;
+		}
+
+		if (i >= alignments) {
 			error("unsupported align: %s\n", param.align);
 			return -ENXIO;
 		}
-- 
2.17.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
