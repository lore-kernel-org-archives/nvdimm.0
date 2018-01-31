Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD33C2238B58E
 for <linux-nvdimm@lists.01.org>; Wed, 31 Jan 2018 11:40:19 -0800 (PST)
Subject: [PATCH v5 4/4] nfit-test: Add platform cap support from ACPI 6.2a
 to test
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 31 Jan 2018 12:45:55 -0700
Message-ID: <151742795542.53525.10921968294502970416.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151742786907.53525.180738048776121385.stgit@djiang5-desk3.ch.intel.com>
References: <151742786907.53525.180738048776121385.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding NFIT platform capabilities sub table in nfit_test simulated ACPI
NFIT table. Only the first NFIT table is added with the capability
sub-table.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 tools/testing/nvdimm/test/nfit.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 7217b2b953b5..de1373a7ed4f 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -881,7 +881,8 @@ static int nfit_test0_alloc(struct nfit_test *t)
 					window_size) * NUM_DCR
 			+ sizeof(struct acpi_nfit_data_region) * NUM_BDW
 			+ (sizeof(struct acpi_nfit_flush_address)
-					+ sizeof(u64) * NUM_HINTS) * NUM_DCR;
+					+ sizeof(u64) * NUM_HINTS) * NUM_DCR
+			+ sizeof(struct acpi_nfit_capabilities);
 	int i;
 
 	t->nfit_buf = test_alloc(t, nfit_size, &t->nfit_dma);
@@ -993,6 +994,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	struct acpi_nfit_control_region *dcr;
 	struct acpi_nfit_data_region *bdw;
 	struct acpi_nfit_flush_address *flush;
+	struct acpi_nfit_capabilities *pcap;
 	unsigned int offset, i;
 
 	/*
@@ -1500,8 +1502,16 @@ static void nfit_test0_setup(struct nfit_test *t)
 	for (i = 0; i < NUM_HINTS; i++)
 		flush->hint_address[i] = t->flush_dma[3] + i * sizeof(u64);
 
+	/* platform capabilities */
+	pcap = nfit_buf + offset + flush_hint_size * 4;
+	pcap->header.type = ACPI_NFIT_TYPE_CAPABILITIES;
+	pcap->header.length = sizeof(*pcap);
+	pcap->highest_capability = 1;
+	pcap->capabilities = ACPI_NFIT_CAPABILITY_CACHE_FLUSH |
+		ACPI_NFIT_CAPABILITY_MEM_FLUSH;
+
 	if (t->setup_hotplug) {
-		offset = offset + flush_hint_size * 4;
+		offset = offset + flush_hint_size * 4 + sizeof(*pcap);
 		/* dcr-descriptor4: blk */
 		dcr = nfit_buf + offset;
 		dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
