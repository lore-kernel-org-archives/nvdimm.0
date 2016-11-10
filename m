Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB14481C59
 for <linux-nvdimm@lists.01.org>; Wed,  9 Nov 2016 17:31:18 -0800 (PST)
Subject: [PATCH 2/2] ndctl,
 create-namespace: skip attempts to set 'align' on older kernels
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 09 Nov 2016 17:28:20 -0800
Message-ID: <147874130070.37588.7156973366536136882.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147874129531.37588.12721076898149272280.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147874129531.37588.12721076898149272280.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Prior to 4.5 kernel the 'align' attribute for pfn devices did not exist.
Skip attempts to set it on those kernels.

Link: https://github.com/pmem/ndctl/issues/7
Reported-by: Yigal Korman <yigal@plexistor.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xaction-namespace.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index c55625274f62..8257eb9cd65e 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -319,7 +319,14 @@ static int setup_namespace(struct ndctl_region *region,
 
 		try(ndctl_pfn, set_uuid, pfn, uuid);
 		try(ndctl_pfn, set_location, pfn, p->loc);
-		try(ndctl_pfn, set_align, pfn, SZ_2M);
+
+		/*
+		 * TODO: when we allow setting a non-default alignment
+		 * we'll need to check for "has_align" earlier and fail
+		 * non-default attempts on older kernels.
+		 */
+		if (ndctl_pfn_has_align(pfn))
+			try(ndctl_pfn, set_align, pfn, SZ_2M);
 		try(ndctl_pfn, set_namespace, pfn, ndns);
 		rc = ndctl_pfn_enable(pfn);
 	} else if (p->mode == NDCTL_NS_MODE_DAX) {
@@ -327,6 +334,7 @@ static int setup_namespace(struct ndctl_region *region,
 
 		try(ndctl_dax, set_uuid, dax, uuid);
 		try(ndctl_dax, set_location, dax, p->loc);
+		/* device-dax assumes 'align' attribute present */
 		try(ndctl_dax, set_align, dax, SZ_2M);
 		try(ndctl_dax, set_namespace, dax, ndns);
 		rc = ndctl_dax_enable(dax);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
