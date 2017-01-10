Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8ACDC81B01
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jan 2017 17:11:37 -0800 (PST)
Subject: [PATCH 1/9] ndctl,
 create-namespace: skip idle regions when scanning for capacity
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 09 Jan 2017 17:07:30 -0800
Message-ID: <148401045095.16217.4685345124032453028.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148401044568.16217.6942951063735168785.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148401044568.16217.6942951063735168785.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Let validate_namespace_options() check that the region is enabled before
allowing namespace creation to proceed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xaction-namespace.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 2c4f85f5e4ac..66e61c531fa6 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -391,6 +391,12 @@ static int validate_namespace_options(struct ndctl_region *region,
 
 	memset(p, 0, sizeof(*p));
 
+	if (!ndctl_region_is_enabled(region)) {
+		debug("%s: disabled, skipping...\n",
+				ndctl_region_get_devname(region));
+		return -EAGAIN;
+	}
+
 	if (param.size)
 		p->size = parse_size64(param.size);
 	else if (ndns)
@@ -539,9 +545,11 @@ static int namespace_create(struct ndctl_region *region)
 	unsigned long long available;
 	struct ndctl_namespace *ndns;
 	struct parsed_parameters p;
+	int rc;
 
-	if (validate_namespace_options(region, NULL, &p))
-		return -EINVAL;
+	rc = validate_namespace_options(region, NULL, &p);
+	if (rc)
+		return rc;
 
 	if (ndctl_region_get_ro(region)) {
 		debug("%s: read-only, inelligible for namespace creation\n",
@@ -685,8 +693,9 @@ static int namespace_reconfig(struct ndctl_region *region,
 	struct parsed_parameters p;
 	int rc;
 
-	if (validate_namespace_options(region, ndns, &p))
-		return -EINVAL;
+	rc = validate_namespace_options(region, ndns, &p);
+	if (rc)
+		return rc;
 
 	rc = namespace_destroy(region, ndns);
 	if (rc)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
