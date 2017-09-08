Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 65B0621E8796E
 for <linux-nvdimm@lists.01.org>; Fri,  8 Sep 2017 16:42:05 -0700 (PDT)
Subject: [ndctl PATCH 2/2] ndctl: add missing symbol export for
 ndctl_bus_is_nfit_cmd_supported()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 08 Sep 2017 16:38:32 -0700
Message-ID: <150491391214.35962.17674116679502574937.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150491390688.35962.11854315078014907861.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150491390688.35962.11854315078014907861.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Enable applications to use this new helper.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.sym |    1 +
 1 file changed, 1 insertion(+)

diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 8a1111672334..58db669ac2d7 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -285,6 +285,7 @@ LIBNDCTL_13 {
 global:
 	ndctl_bus_get_region_by_physical_address;
 	ndctl_bus_get_dimm_by_physical_address;
+	ndctl_bus_is_nfit_cmd_supported;
 	ndctl_dimm_read_labels;
 	ndctl_dimm_validate_labels;
 	ndctl_dimm_init_labels;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
