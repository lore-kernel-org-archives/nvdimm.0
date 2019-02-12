Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00EE521A134A1
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 13:42:02 -0800 (PST)
Subject: [ndctl PATCH 7/8] ndctl/namespace: Always zero info-blocks
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 13:29:24 -0800
Message-ID: <155000696457.348282.2462787488474915269.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
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
index 6e42acb695aa..63b870ff7a6d 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -917,9 +917,6 @@ static int namespace_destroy(struct ndctl_region *region,
 		struct ndctl_namespace *ndns)
 {
 	const char *devname = ndctl_namespace_get_devname(ndns);
-	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
-	struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
-	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
 	bool did_zero = false;
 	int rc;
 
@@ -941,13 +938,11 @@ static int namespace_destroy(struct ndctl_region *region,
 
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
