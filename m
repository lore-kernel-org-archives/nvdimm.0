Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 2/2] nfit_test: Update SPD ID init handlings
Date: Fri, 19 Feb 2016 16:08:53 -0700
Message-Id: <1455923333-13629-3-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1455923333-13629-1-git-send-email-toshi.kani@hpe.com>
References: <1455923333-13629-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: robert.moore@intel.com, elliott@hpe.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, devel@acpica.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Update the test code that initializes SPD IDs of NFIT control
region structures.  nfit_set_spd_id() is added to handle
initialization to an array of bytes.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
---
 tools/testing/nvdimm/test/nfit.c |   64 +++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 25 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 90bd2ea..283e187 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -160,6 +160,14 @@ static struct nfit_test *to_nfit_test(struct device *dev)
 	return container_of(pdev, struct nfit_test, pdev);
 }
 
+static void nfit_set_spd_id(u8 *dist, u64 value, size_t size)
+{
+	int shift;
+
+	for (shift = size - 1; shift >= 0; shift--, dist++)
+		*dist = (u8)((value >> (8 * shift)) & 0xff);
+}
+
 static int nfit_test_cmd_get_config_size(struct nd_cmd_get_config_size *nd_cmd,
 		unsigned int buf_len)
 {
@@ -815,10 +823,11 @@ static void nfit_test0_setup(struct nfit_test *t)
 	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
 	dcr->header.length = sizeof(struct acpi_nfit_control_region);
 	dcr->region_index = 0+1;
-	dcr->vendor_id = 0xabcd;
-	dcr->device_id = 0;
-	dcr->revision_id = 1;
-	dcr->serial_number = ~handle[0];
+	nfit_set_spd_id(dcr->vendor_id, 0xabcd, sizeof(dcr->vendor_id));
+	nfit_set_spd_id(dcr->device_id, 0, sizeof(dcr->device_id));
+	nfit_set_spd_id(dcr->revision_id, 1, sizeof(dcr->revision_id));
+	nfit_set_spd_id(dcr->serial_number, ~handle[0],
+				sizeof(dcr->serial_number));
 	dcr->windows = 1;
 	dcr->window_size = DCR_SIZE;
 	dcr->command_offset = 0;
@@ -831,10 +840,11 @@ static void nfit_test0_setup(struct nfit_test *t)
 	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
 	dcr->header.length = sizeof(struct acpi_nfit_control_region);
 	dcr->region_index = 1+1;
-	dcr->vendor_id = 0xabcd;
-	dcr->device_id = 0;
-	dcr->revision_id = 1;
-	dcr->serial_number = ~handle[1];
+	nfit_set_spd_id(dcr->vendor_id, 0xabcd, sizeof(dcr->vendor_id));
+	nfit_set_spd_id(dcr->device_id, 0, sizeof(dcr->device_id));
+	nfit_set_spd_id(dcr->revision_id, 1, sizeof(dcr->revision_id));
+	nfit_set_spd_id(dcr->serial_number, ~handle[1],
+				sizeof(dcr->serial_number));
 	dcr->windows = 1;
 	dcr->window_size = DCR_SIZE;
 	dcr->command_offset = 0;
@@ -847,10 +857,11 @@ static void nfit_test0_setup(struct nfit_test *t)
 	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
 	dcr->header.length = sizeof(struct acpi_nfit_control_region);
 	dcr->region_index = 2+1;
-	dcr->vendor_id = 0xabcd;
-	dcr->device_id = 0;
-	dcr->revision_id = 1;
-	dcr->serial_number = ~handle[2];
+	nfit_set_spd_id(dcr->vendor_id, 0xabcd, sizeof(dcr->vendor_id));
+	nfit_set_spd_id(dcr->device_id, 0, sizeof(dcr->device_id));
+	nfit_set_spd_id(dcr->revision_id, 1, sizeof(dcr->revision_id));
+	nfit_set_spd_id(dcr->serial_number, ~handle[2],
+				sizeof(dcr->serial_number));
 	dcr->windows = 1;
 	dcr->window_size = DCR_SIZE;
 	dcr->command_offset = 0;
@@ -863,10 +874,11 @@ static void nfit_test0_setup(struct nfit_test *t)
 	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
 	dcr->header.length = sizeof(struct acpi_nfit_control_region);
 	dcr->region_index = 3+1;
-	dcr->vendor_id = 0xabcd;
-	dcr->device_id = 0;
-	dcr->revision_id = 1;
-	dcr->serial_number = ~handle[3];
+	nfit_set_spd_id(dcr->vendor_id, 0xabcd, sizeof(dcr->vendor_id));
+	nfit_set_spd_id(dcr->device_id, 0, sizeof(dcr->device_id));
+	nfit_set_spd_id(dcr->revision_id, 1, sizeof(dcr->revision_id));
+	nfit_set_spd_id(dcr->serial_number, ~handle[3],
+				sizeof(dcr->serial_number));
 	dcr->windows = 1;
 	dcr->window_size = DCR_SIZE;
 	dcr->command_offset = 0;
@@ -959,10 +971,11 @@ static void nfit_test0_setup(struct nfit_test *t)
 		dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
 		dcr->header.length = sizeof(struct acpi_nfit_control_region);
 		dcr->region_index = 4+1;
-		dcr->vendor_id = 0xabcd;
-		dcr->device_id = 0;
-		dcr->revision_id = 1;
-		dcr->serial_number = ~handle[4];
+		nfit_set_spd_id(dcr->vendor_id, 0xabcd, sizeof(dcr->vendor_id));
+		nfit_set_spd_id(dcr->device_id, 0, sizeof(dcr->device_id));
+		nfit_set_spd_id(dcr->revision_id, 1, sizeof(dcr->revision_id));
+		nfit_set_spd_id(dcr->serial_number, ~handle[4],
+					sizeof(dcr->serial_number));
 		dcr->windows = 1;
 		dcr->window_size = DCR_SIZE;
 		dcr->command_offset = 0;
@@ -1128,11 +1141,12 @@ static void nfit_test1_setup(struct nfit_test *t)
 	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
 	dcr->header.length = sizeof(struct acpi_nfit_control_region);
 	dcr->region_index = 0+1;
-	dcr->vendor_id = 0xabcd;
-	dcr->device_id = 0;
-	dcr->revision_id = 1;
-	dcr->serial_number = ~0;
-	dcr->code = 0x201;
+	nfit_set_spd_id(dcr->vendor_id, 0xabcd, sizeof(dcr->vendor_id));
+	nfit_set_spd_id(dcr->device_id, 0, sizeof(dcr->device_id));
+	nfit_set_spd_id(dcr->revision_id, 1, sizeof(dcr->revision_id));
+	nfit_set_spd_id(dcr->serial_number, ~0,
+				sizeof(dcr->serial_number));
+	nfit_set_spd_id(dcr->code, 0x201, sizeof(dcr->code));
 	dcr->windows = 0;
 	dcr->window_size = 0;
 	dcr->command_offset = 0;
