Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 126DF1A1E14
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 20:27:28 -0700 (PDT)
Subject: [PATCH 1/7] dax: cleanup needlessly global symbol warnings
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Aug 2016 20:25:04 -0700
Message-ID: <147131790405.13727.4769799544104882308.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147131789847.13727.7932192631919982514.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147131789847.13727.7932192631919982514.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
List-ID: <linux-nvdimm@lists.01.org>

drivers/dax/dax.c:75:6: warning: symbol 'dax_region_put' was not declared.
drivers/dax/dax.c:95:19: warning: symbol 'alloc_dax_region' was not declared.
drivers/dax/dax.c:173:5: warning: symbol 'devm_create_dax_dev' was not declared.
drivers/dax/pmem.c:27:17: warning: symbol 'to_dax_pmem' was not declared.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c  |    1 +
 drivers/dax/pmem.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 803f3953b341..736c03830fd0 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -18,6 +18,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include "dax.h"
 
 static int dax_major;
 static struct class *dax_class;
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index dfb168568af1..59b75c5972bb 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -24,7 +24,7 @@ struct dax_pmem {
 	struct completion cmp;
 };
 
-struct dax_pmem *to_dax_pmem(struct percpu_ref *ref)
+static struct dax_pmem *to_dax_pmem(struct percpu_ref *ref)
 {
 	return container_of(ref, struct dax_pmem, ref);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
