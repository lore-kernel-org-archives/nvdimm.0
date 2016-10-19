Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 70D3E1A1E72
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 09:50:56 -0700 (PDT)
Subject: [ndctl PATCH 1/8] libndctl: fix error returns for unsigned apis
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 09:47:54 -0700
Message-ID: <147689567402.11015.8666074208286654272.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
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

For unsigned attributes the library inconsistently returns ULLONG_MAX /
ULONG_MAX as an error return.  Fix up ndctl_region_get_available_size()
and ndctl_dimm_get_available_labels() to indicate errors following this
scheme.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 02524501db16..7d870b082cd4 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1707,11 +1707,11 @@ NDCTL_EXPORT unsigned long long ndctl_region_get_available_size(
 	if (snprintf(path, len, "%s/available_size", region->region_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
 				ndctl_region_get_devname(region));
-		return -ENOMEM;
+		return ULLONG_MAX;
 	}
 
 	if (sysfs_read_attr(ctx, path, buf) < 0)
-		return -ENXIO;
+		return ULLONG_MAX;
 
 	return strtoull(buf, NULL, 0);
 }
@@ -2519,11 +2519,11 @@ NDCTL_EXPORT unsigned long ndctl_dimm_get_available_labels(
 	if (snprintf(path, len, "%s/available_slots", dimm->dimm_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
 				ndctl_dimm_get_devname(dimm));
-		return -ENOMEM;
+		return ULONG_MAX;
 	}
 
 	if (sysfs_read_attr(ctx, path, buf) < 0)
-		return 0;
+		return ULONG_MAX;
 
 	return strtoul(buf, NULL, 0);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
