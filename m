Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9CDB32217CE53
 for <linux-nvdimm@lists.01.org>; Fri,  8 Dec 2017 12:55:51 -0800 (PST)
Subject: [PATCH v2 4/4] nfit-test: Add platform cap support from ACPI 6.2a
 to test
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 08 Dec 2017 14:00:25 -0700
Message-ID: <151276682564.31888.9763911491092344231.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151276655874.31888.13113966406333561201.stgit@djiang5-desk3.ch.intel.com>
References: <151276655874.31888.13113966406333561201.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding NFIT platform capabilities sub table in nfit_test simulated ACPI
NFIT table. Only the first NFIT table is added with the capability
sub-table.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 7217b2b953b5..8a16f90a9573 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -993,6 +993,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	struct acpi_nfit_control_region *dcr;
 	struct acpi_nfit_data_region *bdw;
 	struct acpi_nfit_flush_address *flush;
+	struct acpi_nfit_capabilities *pcap;
 	unsigned int offset, i;
 
 	/*
@@ -1500,8 +1501,16 @@ static void nfit_test0_setup(struct nfit_test *t)
 	for (i = 0; i < NUM_HINTS; i++)
 		flush->hint_address[i] = t->flush_dma[3] + i * sizeof(u64);
 
+	/* platform capabilities */
+	pcap = nfit_buf + offset + flush_hint_size * 4;
+	pcap->header.type = ACPI_NFIT_TYPE_CAPABILITIES;
+	pcap->header.length = sizeof(*pcap);
+	pcap->highest_capability = BIT(2);
+	pcap->capabilities = ACPI_NFIT_CAPABILITY_CACHE_FLUSH |
+		ACPI_NFIT_CAPABILITY_MEM_FLUSH;
+
 	if (t->setup_hotplug) {
-		offset = offset + flush_hint_size * 4;
+		offset = offset + sizeof(*pcap);
 		/* dcr-descriptor4: blk */
 		dcr = nfit_buf + offset;
 		dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
