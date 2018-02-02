Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B7F2D2237A4CC
 for <linux-nvdimm@lists.01.org>; Fri,  2 Feb 2018 12:09:28 -0800 (PST)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] acpi, nfit: fix register dimm error handling
Date: Fri,  2 Feb 2018 14:00:36 -0700
Message-Id: <20180202210036.3153-1-toshi.kani@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-acpi@vger.kernel.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

A NULL pointer reference kernel bug was observed when
acpi_nfit_add_dimm() called in acpi_nfit_register_dimms()
failed. This error path does not set nfit_mem->nvdimm, but
the 2nd list_for_each_entry() loop in the function assumes
it's always set. Add a check to nfit_mem->nvdimm.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
---
 drivers/acpi/nfit/core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index abeb4df4f22e..b28ce440a06f 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1867,6 +1867,9 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		struct kernfs_node *nfit_kernfs;
 
 		nvdimm = nfit_mem->nvdimm;
+		if (!nvdimm)
+			continue;
+
 		nfit_kernfs = sysfs_get_dirent(nvdimm_kobj(nvdimm)->sd, "nfit");
 		if (nfit_kernfs)
 			nfit_mem->flags_attr = sysfs_get_dirent(nfit_kernfs,
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
