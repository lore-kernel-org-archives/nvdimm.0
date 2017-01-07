Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 055CD81A51
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jan 2017 17:46:50 -0800 (PST)
Subject: [ndctl PATCH 7/7] ndctl, list: limit mappings when --dimm is specified
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Jan 2017 17:42:43 -0800
Message-ID: <148375336328.38836.13046350126554675733.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Single out the mapping for the requested dimm device when specified.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-list.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/ndctl/builtin-list.c b/ndctl/builtin-list.c
index ed4edf6f0249..e8d007003b62 100644
--- a/ndctl/builtin-list.c
+++ b/ndctl/builtin-list.c
@@ -173,6 +173,9 @@ static struct json_object *region_to_json(struct ndctl_region *region)
 		if (!list.dimms)
 			break;
 
+		if (!util_dimm_filter(dimm, param.dimm))
+			continue;
+
 		if (!list.idle && !ndctl_dimm_is_enabled(dimm))
 			continue;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
