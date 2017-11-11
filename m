Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9231320359A86
 for <linux-nvdimm@lists.01.org>; Sat, 11 Nov 2017 16:03:50 -0800 (PST)
Subject: [ndctl PATCH] ndctl,
 create-namespace: clarify autolabel failures and fallback
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 11 Nov 2017 15:59:39 -0800
Message-ID: <151044477986.16188.7243209600918286392.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The autolabel feature tries to enable labels whenever a namespace in a
label-less mode region is reconfigured. It builds on the assumption that
if the entire capacity is being reconfigured then the operation can try
to assume exclusive ownership of all the DIMMs in that region.

However, if a given DIMM is a member of multiple regions then the
reconfiguration operation cannot assume that ownership. We detect that
case by checking if the DIMM in regionX is still active in regionY after
disabling regionX.

In that case we fail the autolabel, but we should not fail the namespace
reconfiguration. Provide debug messages to indicate why the auto-label
failed, but then try to continue the namespace reconfiguration in
label-less mode.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 077d5968d0e8..b780924ecf4c 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -901,8 +901,10 @@ static int enable_labels(struct ndctl_region *region)
 	count = 0;
 	ndctl_dimm_foreach_in_region(region, dimm)
 		if (ndctl_dimm_is_active(dimm)) {
+			warning("%s is active in %s, failing autolabel\n",
+					ndctl_dimm_get_devname(dimm),
+					ndctl_region_get_devname(region));
 			count++;
-			break;
 		}
 
 	/* some of the dimms belong to multiple regions?? */
@@ -945,7 +947,7 @@ out:
 	if (ndctl_region_get_nstype(region) != ND_DEVICE_NAMESPACE_PMEM) {
 		debug("%s: failed to initialize labels\n",
 				ndctl_region_get_devname(region));
-		return -ENXIO;
+		return -EBUSY;
 	}
 
 	return 0;
@@ -968,9 +970,8 @@ static int namespace_reconfig(struct ndctl_region *region,
 	/* check if we can enable labels on this region */
 	if (ndctl_region_get_nstype(region) == ND_DEVICE_NAMESPACE_IO
 			&& p.autolabel) {
-		rc = enable_labels(region);
-		if (rc)
-			return rc;
+		/* if this fails, try to continue label-less */
+		enable_labels(region);
 	}
 
 	ndns = region_get_namespace(region);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
