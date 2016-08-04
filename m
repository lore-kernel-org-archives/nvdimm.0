Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 144E71A1DFE
 for <linux-nvdimm@lists.01.org>; Thu,  4 Aug 2016 08:34:46 -0700 (PDT)
Subject: [ndctl PATCH] ndctl,
 create-namespace: trap and report invalid sector-size values
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 04 Aug 2016 08:32:22 -0700
Message-ID: <147032474225.32368.15775067933518377793.stgit@dwillia2-desk3.amr.corp.intel.com>
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

While the kernel will prevent invalid configurations, the user
experience of a kernel error message and disabling of the namespace is
too harsh.  Trap and report these attempts to make create-namespace more
user friendly.

    # ndctl create-namespace -e namespace0.0 -m sector -l 513 -f -v
    validate_namespace_options:437: region0: does not support btt sector_size 513
    failed to reconfigure namespace

Reported-by: Yi Zhang <yizhan@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xaction-namespace.c |   40 +++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 8304203750d8..e136bfdefa39 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -415,14 +415,42 @@ static int validate_namespace_options(struct ndctl_region *region,
 		p->mode = ndctl_namespace_get_mode(ndns);
 
 	if (param.sector_size) {
-		p->sector_size = parse_size64(param.sector_size);
+		struct ndctl_btt *btt;
+		int num, i;
 
-		if (ndns && p->mode != NDCTL_NS_MODE_SAFE
-				&& ndctl_namespace_get_type(ndns)
-				== ND_DEVICE_NAMESPACE_PMEM) {
-			debug("%s: does not support sector_size modification\n",
-					ndctl_namespace_get_devname(ndns));
+		p->sector_size = parse_size64(param.sector_size);
+		btt = ndctl_region_get_btt_seed(region);
+		if (p->mode == NDCTL_NS_MODE_SAFE) {
+			if (!btt) {
+				debug("%s: does not support 'sector' mode\n",
+						ndctl_region_get_devname(region));
+				return -EINVAL;
+			}
+			num = ndctl_btt_get_num_sector_sizes(btt);
+			for (i = 0; i < num; i++)
+				if (ndctl_btt_get_supported_sector_size(btt, i)
+						== p->sector_size)
+					break;
+			if (i >= num) {
+				debug("%s: does not support btt sector_size %lu\n",
+						ndctl_region_get_devname(region),
+						p->sector_size);
 				return -EINVAL;
+			}
+		} else {
+			if (!ndns)
+				ndns = ndctl_region_get_namespace_seed(region);
+			num = ndctl_namespace_get_num_sector_sizes(ndns);
+			for (i = 0; i < num; i++)
+				if (ndctl_namespace_get_supported_sector_size(ndns, i)
+						== p->sector_size)
+					break;
+			if (i >= num) {
+				debug("%s: does not support namespace sector_size %lu\n",
+						ndctl_region_get_devname(region),
+						p->sector_size);
+				return -EINVAL;
+			}
 		}
 	} else if (ndns) {
 		struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
