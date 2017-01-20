Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C75481E9E
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jan 2017 19:55:29 -0800 (PST)
Subject: [PATCH 13/13] libnvdimm,
 pmem: disable dax flushing for 'cache flush on fail' platforms
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Jan 2017 19:51:23 -0800
Message-ID: <148488428321.37913.17056461381323304389.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

There are platforms that arrange for caches to be flushed on a power
fail event. When the platform has this capability it is redundant to
spend cycles flushing caches at fsync(). Provide a libnvdimm module
parameter to override the default flushing behavior since there is no
other mechanism defined to detect this platform property.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region_devs.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index ef32b938023e..4cc7fbc4f13f 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -11,6 +11,7 @@
  * General Public License for more details.
  */
 #include <linux/scatterlist.h>
+#include <linux/moduleparam.h>
 #include <linux/highmem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -21,6 +22,11 @@
 #include "nd-core.h"
 #include "nd.h"
 
+static bool platform_has_flush_on_fail;
+module_param(platform_has_flush_on_fail, bool, 00444);
+MODULE_PARM_DESC(platform_has_flush_on_fail,
+	"Platform arranges for cpu caches to be flushed on power failure");
+
 /*
  * For readq() and writeq() on 32-bit builds, the hi-lo, lo-hi order is
  * irrelevant.
@@ -963,6 +969,11 @@ int nvdimm_has_flush(struct nd_region *nd_region)
 	struct nd_region_data *ndrd = dev_get_drvdata(&nd_region->dev);
 	int i;
 
+	if (platform_has_flush_on_fail) {
+		pr_info_once("libnvdimm.platform_has_flush_on_fail enabled\n");
+		return -EINVAL;
+	}
+
 	if (is_nd_volatile(&nd_region->dev))
 		return -EINVAL;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
