Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5DD4E21F322BE
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 16:00:32 -0700 (PDT)
Subject: [PATCH 2/3] libnvdimm,
 namespace: make 'resource' attribute only readable by root
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Sep 2017 15:57:20 -0700
Message-ID: <150646664054.6588.4993849833026629042.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150646662980.6588.6123788075203842948.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150646662980.6588.6123788075203842948.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

For the same reason that /proc/iomem returns 0's for non-root readers
and acpi tables are root-only, make the 'resource' attribute for
namespace devices only readable by root. Otherwise we disclose physical
address information.

Fixes: bf9bccc14c05 ("libnvdimm: pmem label sets and namespace instantiation")
Cc: <stable@vger.kernel.org>
Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 3e4d1e7998da..0af988739a06 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1620,7 +1620,7 @@ static umode_t namespace_visible(struct kobject *kobj,
 	if (a == &dev_attr_resource.attr) {
 		if (is_namespace_blk(dev))
 			return 0;
-		return a->mode;
+		return 0400;
 	}
 
 	if (is_namespace_pmem(dev) || is_namespace_blk(dev)) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
