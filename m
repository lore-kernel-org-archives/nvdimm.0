Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 2/3] nfit,
 tools/testing/nvdimm: add format interface code definitions
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 08 Feb 2016 10:31:03 -0800
Message-ID: <20160208183103.27820.18786.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160208183052.27820.68922.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160208183052.27820.68922.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.1 and JEDEC Annex L Release 3 formalize the format interface
code.  Add definitions and update their usage in the unit test.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.h              |    6 ++++++
 tools/testing/nvdimm/test/nfit.c |    7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 3d549a383659..6689b0aaf194 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -40,6 +40,12 @@ enum nfit_uuids {
 	NFIT_UUID_MAX,
 };
 
+enum nfit_fic {
+	NFIT_FIC_BYTE = 0x101, /* byte-addressable energy backed */
+	NFIT_FIC_BLK = 0x201, /* block-addressable non-energy backed */
+	NFIT_FIC_BYTEN = 0x301, /* byte-addressable non-energy backed */
+};
+
 enum {
 	ND_BLK_READ_FLUSH = 1,
 	ND_BLK_DCR_LATCH = 2,
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 90bd2ea41032..f9d37143e264 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -819,6 +819,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	dcr->device_id = 0;
 	dcr->revision_id = 1;
 	dcr->serial_number = ~handle[0];
+	dcr->code = NFIT_FIC_BLK;
 	dcr->windows = 1;
 	dcr->window_size = DCR_SIZE;
 	dcr->command_offset = 0;
@@ -835,6 +836,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	dcr->device_id = 0;
 	dcr->revision_id = 1;
 	dcr->serial_number = ~handle[1];
+	dcr->code = NFIT_FIC_BLK;
 	dcr->windows = 1;
 	dcr->window_size = DCR_SIZE;
 	dcr->command_offset = 0;
@@ -851,6 +853,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	dcr->device_id = 0;
 	dcr->revision_id = 1;
 	dcr->serial_number = ~handle[2];
+	dcr->code = NFIT_FIC_BLK;
 	dcr->windows = 1;
 	dcr->window_size = DCR_SIZE;
 	dcr->command_offset = 0;
@@ -867,6 +870,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	dcr->device_id = 0;
 	dcr->revision_id = 1;
 	dcr->serial_number = ~handle[3];
+	dcr->code = NFIT_FIC_BLK;
 	dcr->windows = 1;
 	dcr->window_size = DCR_SIZE;
 	dcr->command_offset = 0;
@@ -963,6 +967,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 		dcr->device_id = 0;
 		dcr->revision_id = 1;
 		dcr->serial_number = ~handle[4];
+		dcr->code = NFIT_FIC_BLK;
 		dcr->windows = 1;
 		dcr->window_size = DCR_SIZE;
 		dcr->command_offset = 0;
@@ -1132,7 +1137,7 @@ static void nfit_test1_setup(struct nfit_test *t)
 	dcr->device_id = 0;
 	dcr->revision_id = 1;
 	dcr->serial_number = ~0;
-	dcr->code = 0x201;
+	dcr->code = NFIT_FIC_BYTE;
 	dcr->windows = 0;
 	dcr->window_size = 0;
 	dcr->command_offset = 0;
