Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 67E75212E259D
 for <linux-nvdimm@lists.01.org>; Sat, 27 Jul 2019 14:56:41 -0700 (PDT)
Subject: [ndctl PATCH v2 07/26] ndctl/namespace: Always zero info-blocks
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 27 Jul 2019 14:39:57 -0700
Message-ID: <156426359741.531577.6721558516702343422.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Do not gate zeroing on whether a namespace is claimed by a personality.
The namespace might not have been able to be claimed due to info-block
corruption.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 9eec313c2d5b..645aa14882bb 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -930,9 +930,6 @@ static int namespace_destroy(struct ndctl_region *region,
 		struct ndctl_namespace *ndns)
 {
 	const char *devname = ndctl_namespace_get_devname(ndns);
-	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
-	struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
-	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
 	bool did_zero = false;
 	int rc;
 
@@ -954,13 +951,11 @@ static int namespace_destroy(struct ndctl_region *region,
 
 	ndctl_namespace_set_enforce_mode(ndns, NDCTL_NS_MODE_RAW);
 
-	if (pfn || btt || dax) {
-		rc = zero_info_block(ndns);
-		if (rc < 0)
-			return rc;
-		if (rc == 0)
-			did_zero = true;
-	}
+	rc = zero_info_block(ndns);
+	if (rc < 0)
+		return rc;
+	if (rc == 0)
+		did_zero = true;
 
 	switch (ndctl_namespace_get_type(ndns)) {
         case ND_DEVICE_NAMESPACE_PMEM:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
