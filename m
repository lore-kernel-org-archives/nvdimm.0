Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3311481B1A
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jan 2017 17:12:13 -0800 (PST)
Subject: [PATCH 8/9] ndctl: fix ndctl_region_get_interleave_ways(), set minimum
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 09 Jan 2017 17:08:07 -0800
Message-ID: <148401048698.16217.3842178372333222383.stgit@dwillia2-desk3.amr.corp.intel.com>
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

A pmem region that does not have any associated dimm mappings is still a
x1 interleave width by definition. Given that tooling does division by
interleave-ways, return 1 as a minimum so that users do not need to
check for the zero case.

If a user instead wants to know the number of mapping entries that is
provided by ndctl_region_get_mappings().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 49e35bf0fd98..c4a9b3675d89 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1676,7 +1676,7 @@ NDCTL_EXPORT unsigned int ndctl_region_get_id(struct ndctl_region *region)
 
 NDCTL_EXPORT unsigned int ndctl_region_get_interleave_ways(struct ndctl_region *region)
 {
-	return ndctl_region_get_mappings(region);
+	return max(1, ndctl_region_get_mappings(region));
 }
 
 NDCTL_EXPORT unsigned int ndctl_region_get_mappings(struct ndctl_region *region)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
