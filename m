Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F6132194EB64
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 10:04:22 -0700 (PDT)
Subject: [PATCH 2/5] acpi, nfit: add support for acpi 6.1 dimm state flags
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 09:58:22 -0700
Message-ID: <149218910195.3926.13927602427357940056.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149218909065.3926.1234846095650907678.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149218909065.3926.1234846095650907678.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add support for the ACPI_NFIT_MEM_MAP_FAILED ("map_fail") and
ACPI_NFIT_MEM_HEALTH_ENABLED ("smart_notify") health state flags. The
"map_fail" flag identifies DIMMs that were not mapped into one or more
physical address ranges. The "health_notify" flag indicates whether
platform firmware will send notifications when there is new SMART health
data to consume.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 53943d6f4214..05829de43b1d 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1246,12 +1246,14 @@ static ssize_t flags_show(struct device *dev,
 {
 	u16 flags = to_nfit_memdev(dev)->flags;
 
-	return sprintf(buf, "%s%s%s%s%s\n",
+	return sprintf(buf, "%s%s%s%s%s%s%s\n",
 		flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save_fail " : "",
 		flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore_fail " : "",
 		flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush_fail " : "",
 		flags & ACPI_NFIT_MEM_NOT_ARMED ? "not_armed " : "",
-		flags & ACPI_NFIT_MEM_HEALTH_OBSERVED ? "smart_event " : "");
+		flags & ACPI_NFIT_MEM_HEALTH_OBSERVED ? "smart_event " : "",
+		flags & ACPI_NFIT_MEM_MAP_FAILED ? "map_fail " : "",
+		flags & ACPI_NFIT_MEM_HEALTH_ENABLED ? "smart_notify " : "");
 }
 static DEVICE_ATTR_RO(flags);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
