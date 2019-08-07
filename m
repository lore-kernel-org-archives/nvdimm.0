Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 32CEB212FE8AC
 for <linux-nvdimm@lists.01.org>; Tue,  6 Aug 2019 21:41:55 -0700 (PDT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH] Consider namespace with size as active namespace
Date: Wed,  7 Aug 2019 10:09:15 +0530
Message-Id: <20190807043915.30239-1-aneesh.kumar@linux.ibm.com>
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
To: dan.j.williams@intel.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This enables us to mark a namespace as disabled due to pfn_sb
mismatch. We have pending kernel patches at that will mark the
namespace disabled when the PAGE_SIZE or struct page size didn't
match with the value stored in pfn_sb.

We need to make sure we don't use this disabled namespace as seed namespace
for new namespace creation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 ndctl/namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 58a9e3c53474..1f212a2b3a9b 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -455,7 +455,8 @@ static int is_namespace_active(struct ndctl_namespace *ndns)
 	return ndns && (ndctl_namespace_is_enabled(ndns)
 		|| ndctl_namespace_get_pfn(ndns)
 		|| ndctl_namespace_get_dax(ndns)
-		|| ndctl_namespace_get_btt(ndns));
+		|| ndctl_namespace_get_btt(ndns)
+		|| ndctl_namespace_get_size(ndns));
 }
 
 /*
-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
