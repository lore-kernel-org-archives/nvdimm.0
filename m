Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com
 [IPv6:2607:f8b0:4864:20::442])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3021B211B7F66
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 01:49:29 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id z9so2835381pfi.2
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 01:49:29 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH v3 4/6] ndctl/namespace: Validate alignment from the {pfn|dax}
 seed
Date: Wed, 16 Jan 2019 20:49:07 +1100
Message-Id: <20190116094909.23112-4-oohall@gmail.com>
In-Reply-To: <20190116094909.23112-1-oohall@gmail.com>
References: <20190116094909.23112-1-oohall@gmail.com>
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

This patch adds support to the ndctl tool for validating that the
namespace alignment is valid.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 ndctl/namespace.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index b27cc6967a68..44fc91232ecb 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -537,8 +537,23 @@ static int validate_namespace_options(struct ndctl_region *region,
 	}
 
 	if (param.align) {
-		if (p->mode != NDCTL_NS_MODE_MEMORY &&
-		    p->mode != NDCTL_NS_MODE_DAX) {
+		int i, alignments;
+
+		switch (p->mode) {
+		case NDCTL_NS_MODE_MEMORY:
+			if (!pfn) {
+				error("Kernel does not support setting an alignment in fsdax mode\n");
+				return -EINVAL;
+			}
+
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
@@ -546,13 +561,19 @@ static int validate_namespace_options(struct ndctl_region *region,
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
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
