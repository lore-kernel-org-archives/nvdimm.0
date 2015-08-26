Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/2]: nfit: Clarify memory device state flags strings
Date: Wed, 26 Aug 2015 10:20:23 -0600
Message-Id: <1440606024-29873-2-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1440606024-29873-1-git-send-email-toshi.kani@hp.com>
References: <1440606024-29873-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dan.j.williams@intel.com, rafael.j.wysocki@intel.com
Cc: robert.moore@intel.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, elliott@hp.com, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.0 NFIT Memory Device State Flags in Table 5-129 defines
NVDIMM status as follows.  These bits indicate multiple info,
such as failures, pending event, and capability.

  Bit [0] set to 1 to indicate that the previous SAVE to the
  Memory Device failed.
  Bit [1] set to 1 to indicate that the last RESTORE from the
  Memory Device failed.
  Bit [2] set to 1 to indicate that platform flush of data to
  Memory Device failed. As a result, the restored data content
  may be inconsistent even if SAVE and RESTORE do not indicate
  failure.
  Bit [3] set to 1 to indicate that the Memory Device is observed
  to be not armed prior to OSPM hand off. A Memory Device is
  considered armed if it is able to accept persistent writes.
  Bit [4] set to 1 to indicate that the Memory Device observed
  SMART and health events prior to OSPM handoff.
  Bit [5] is set to 1 to indicate that platform firmware is
  enabled to notify OSPM on SMART and health events related to
  the memory device using Notify codes as specified in Section
  5.6.6.

/sys/bus/nd/devices/nmemX/nfit/flags shows this flags info.
The output strings associated with the bits are "save", "restore",
"smart", etc., which can be confusing as they may be interpreted
as positive status, i.e. save succeeded.

Change the strings to be more descriptive per the ACPI spec.
Also add a string to bit 5 for completeness.

Change also the dev_info() message in acpi_nfit_register_dimms()
to be consistent with the sysfs flags strings.

Reported-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index c3fe206..6993ff2 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -701,12 +701,13 @@ static ssize_t flags_show(struct device *dev,
 {
 	u16 flags = to_nfit_memdev(dev)->flags;
 
-	return sprintf(buf, "%s%s%s%s%s\n",
-			flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save " : "",
-			flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore " : "",
-			flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush " : "",
-			flags & ACPI_NFIT_MEM_ARMED ? "arm " : "",
-			flags & ACPI_NFIT_MEM_HEALTH_OBSERVED ? "smart " : "");
+	return sprintf(buf, "%s%s%s%s%s%s\n",
+		flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save_fail " : "",
+		flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore_fail " : "",
+		flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush_fail " : "",
+		flags & ACPI_NFIT_MEM_ARMED ? "not_arm " : "",
+		flags & ACPI_NFIT_MEM_HEALTH_OBSERVED ? "smart_event " : "",
+		flags & ACPI_NFIT_MEM_HEALTH_ENABLED ? "notify_enabled " : "");
 }
 static DEVICE_ATTR_RO(flags);
 
@@ -834,11 +835,11 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 			continue;
 
 		dev_info(acpi_desc->dev, "%s: failed: %s%s%s%s\n",
-				nvdimm_name(nvdimm),
-			mem_flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save " : "",
-			mem_flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore " : "",
-			mem_flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush " : "",
-			mem_flags & ACPI_NFIT_MEM_ARMED ? "arm " : "");
+		  nvdimm_name(nvdimm),
+		  mem_flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save_fail " : "",
+		  mem_flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore_fail ":"",
+		  mem_flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush_fail " : "",
+		  mem_flags & ACPI_NFIT_MEM_ARMED ? "not_arm " : "");
 
 	}
 
