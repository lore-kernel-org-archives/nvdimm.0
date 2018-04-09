Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B25682267F105
 for <linux-nvdimm@lists.01.org>; Mon,  9 Apr 2018 14:19:34 -0700 (PDT)
Subject: [PATCH] libnvdimm, of_pmem: workaround OF_NUMA=n build error
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 09 Apr 2018 14:09:38 -0700
Message-ID: <152330817871.32685.18143005199739186530.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
List-ID: <linux-nvdimm@lists.01.org>

Stephen reports that an x86 allmodconfig build fails to build the
of_pmem driver due to a missing definition of of_node_to_nid(). That
helper is currently only exported in the OF_NUMA=y case. In other cases,
ppc and sparc, it is a weak symbol, and outside of those platforms it is
a static inline.

Until an OF_NUMA=n configuration can reliably support usage of
of_node_to_nid() in modules across architectures, mark this driver as
'bool' instead of 'tristate'.

Cc: Rob Herring <robh@kernel.org>
Cc: Oliver O'Halloran <oohall@gmail.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 2d6862bf7436..f6c533c4d09b 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -103,7 +103,8 @@ config NVDIMM_DAX
 	  Select Y if unsure
 
 config OF_PMEM
-	tristate "Device-tree support for persistent memory regions"
+	# FIXME: make tristate once OF_NUMA dependency removed
+	bool "Device-tree support for persistent memory regions"
 	depends on OF
 	default LIBNVDIMM
 	help

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
