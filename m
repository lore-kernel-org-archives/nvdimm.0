Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 655FA21B02822
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 19:10:08 -0800 (PST)
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: [PATCH v2] acpi/nfit: remove duplicate set nd_set in
 acpi_nfit_init_interleave_set()
Date: Tue, 15 Jan 2019 11:09:46 +0800
Message-Id: <20190115030946.4991-1-richardw.yang@linux.intel.com>
In-Reply-To: <20190114021929.3658-1-richardw.yang@linux.intel.com>
References: <20190114021929.3658-1-richardw.yang@linux.intel.com>
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
Cc: Wei Yang <richardw.yang@linux.intel.com>, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

We allocate nd_set in acpi_nfit_init_interleave_set() and assignn it to
ndr_desc, while the assignment is done twice in this function.

This patch removes the first assignment. No functional change.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>

---
v2:
   * remove the first assignment to avoid some leak
---
 drivers/acpi/nfit/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5912d30020c7..9c3c2d2f37be 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2187,7 +2187,6 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 	nd_set = devm_kzalloc(dev, sizeof(*nd_set), GFP_KERNEL);
 	if (!nd_set)
 		return -ENOMEM;
-	ndr_desc->nd_set = nd_set;
 	guid_copy(&nd_set->type_guid, (guid_t *) spa->range_guid);
 
 	info = devm_kzalloc(dev, sizeof_nfit_set_info(nr), GFP_KERNEL);
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
