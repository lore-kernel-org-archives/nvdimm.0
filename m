Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EF2A2212FE8AC
 for <linux-nvdimm@lists.01.org>; Tue,  6 Aug 2019 21:47:00 -0700 (PDT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH] ndctl: Use the same align value as original namespace on
 reconfigure
Date: Wed,  7 Aug 2019 10:14:16 +0530
Message-Id: <20190807044416.30799-1-aneesh.kumar@linux.ibm.com>
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

When using reconfigure command to add a `name` to the namespace we end
up updating the align attribute. Avoid this by using the value from
the original namespace. Do this only if we are keeping the namespace mode
same.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 ndctl/namespace.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 1f212a2b3a9b..24e51bb35ae1 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -596,6 +596,22 @@ static int validate_namespace_options(struct ndctl_region *region,
 			return -ENXIO;
 		}
 	} else {
+
+		/*
+		 * If we are tryint to reconfigure with the same namespace mode
+		 * Use the align details from the origin namespace. Otherwise
+		 * pick the align details from seed namespace
+		 */
+		if (ndns && p->mode == ndctl_namespace_get_mode(ndns)) {
+			struct ndctl_pfn *ns_pfn = ndctl_namespace_get_pfn(ndns);
+			struct ndctl_dax *ns_dax = ndctl_namespace_get_dax(ndns);
+			if (ns_pfn)
+				p->align = ndctl_pfn_get_align(ns_pfn);
+			else if (ns_dax)
+				p->align = ndctl_dax_get_align(ns_dax);
+			else
+				p->align = sysconf(_SC_PAGE_SIZE);
+		} else
 		/*
 		 * Use the seed namespace alignment as the default if we need
 		 * one. If we don't then use PAGE_SIZE so the size_align
-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
