Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 31DBD210EE4CA
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 16:17:16 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] tools/testing/nvdimm: advertise a write cache for nfit_test
Date: Mon, 18 Jun 2018 17:17:02 -0600
Message-Id: <20180618231702.16503-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Commit 546eb0317cfa "libnvdimm, pmem: Do not flush power-fail protected CPU caches"
fixed the write_cache detection to correctly show the lack of a write
cache based on the platform capabilities described in the ACPI NFIT. The
nfit_test unit tests expected a write cache to be present, so change the
nfit test namespaces to only advertise a persistence domain limited to
the memory controller. This allows the kernel to show a write_cache
attribute, and the test behaviour remains unchanged.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 tools/testing/nvdimm/test/nfit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 18157b0c0d0d..a012ab765083 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -2007,8 +2007,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	pcap->header.type = ACPI_NFIT_TYPE_CAPABILITIES;
 	pcap->header.length = sizeof(*pcap);
 	pcap->highest_capability = 1;
-	pcap->capabilities = ACPI_NFIT_CAPABILITY_CACHE_FLUSH |
-		ACPI_NFIT_CAPABILITY_MEM_FLUSH;
+	pcap->capabilities = ACPI_NFIT_CAPABILITY_MEM_FLUSH;
 	offset += pcap->header.length;
 
 	if (t->setup_hotplug) {
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
