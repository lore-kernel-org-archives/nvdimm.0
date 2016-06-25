Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 711661A1E12
 for <linux-nvdimm@lists.01.org>; Sat, 25 Jun 2016 10:42:18 -0700 (PDT)
Subject: [PATCH 1/2] mm: CONFIG_ZONE_DEVICE stop depending on CONFIG_EXPERT
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 25 Jun 2016 10:41:02 -0700
Message-ID: <146687646274.39261.14267596518720371009.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146687645727.39261.14620086569655191314.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146687645727.39261.14620086569655191314.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

When it was first introduced CONFIG_ZONE_DEVICE depended on disabling
CONFIG_ZONE_DMA, a configuration choice reserved for "experts".
However, now that the ZONE_DMA conflict has been eliminated it no longer
makes sense to require CONFIG_EXPERT.

Reported-by: Eric Sandeen <sandeen@redhat.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 3e2daef3c946..d109a7a0c1c4 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -673,7 +673,7 @@ config IDLE_PAGE_TRACKING
 	  See Documentation/vm/idle_page_tracking.txt for more details.
 
 config ZONE_DEVICE
-	bool "Device memory (pmem, etc...) hotplug support" if EXPERT
+	bool "Device memory (pmem, etc...) hotplug support"
 	depends on MEMORY_HOTPLUG
 	depends on MEMORY_HOTREMOVE
 	depends on SPARSEMEM_VMEMMAP

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
