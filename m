Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E3DA021CEB108
 for <linux-nvdimm@lists.01.org>; Tue, 19 Sep 2017 12:59:57 -0700 (PDT)
Subject: [ndctl PATCH 1/2] ndctl: fix sector size manipulation for NVDIMM-N
 namespaces
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Sep 2017 12:56:38 -0700
Message-ID: <150585099801.18300.4357728197672633739.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The autolabel operation that enables sector_size settings for namespaces
will fail on label-less NVDIMMs. In that case we need to abort attempts
to set the sector_size. Typically when specifying a sector_size we are
also specifying 'sector' mode so the failure to set a sector_size at the
raw namespace level can be ignored.

Reported-by: Maurice A. Saldivar <maurice.a.saldivar@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index bbd404f4abcf..905ebadc6b8d 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -354,8 +354,30 @@ static int setup_namespace(struct ndctl_region *region,
 		try(ndctl_namespace, set_size, ndns, p->size);
 	}
 
-	if (p->sector_size && p->sector_size < UINT_MAX)
-		try(ndctl_namespace, set_sector_size, ndns, p->sector_size);
+	if (p->sector_size && p->sector_size < UINT_MAX) {
+		int i, num = ndctl_namespace_get_num_sector_sizes(ndns);
+
+		/*
+		 * With autolabel support we need to recheck if the
+		 * namespace gained sector_size support late in
+		 * namespace_reconfig().
+		 */
+		for (i = 0; i < num; i++)
+			if (ndctl_namespace_get_supported_sector_size(ndns, i)
+					== p->sector_size)
+				break;
+		if (i < num)
+			try(ndctl_namespace, set_sector_size, ndns,
+					p->sector_size);
+		else if (p->mode == NDCTL_NS_MODE_SAFE)
+			/* pass, the btt sector_size will override */;
+		else if (p->sector_size != 512) {
+			error("%s: sector_size: %ld not supported\n",
+					ndctl_namespace_get_devname(ndns),
+					p->sector_size);
+			return -EINVAL;
+		}
+	}
 
 	uuid_generate(uuid);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
