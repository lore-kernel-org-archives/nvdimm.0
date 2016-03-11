Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 0F3A41A1F6A
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 16:46:03 -0800 (PST)
Subject: [ndctl PATCH 2/3] ndctl: disable nfit_test regions after test
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Mar 2016 16:45:21 -0800
Message-ID: <20160311004521.27582.16889.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160311004511.27582.63304.stgit@dwillia2-desk3.jf.intel.com>
References: <20160311004511.27582.63304.stgit@dwillia2-desk3.jf.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Ensure that all nfit_test regions are disabled after a successful test
so the module can be removed.  Otherwise test/libndctl will not run
back-to-back runs in the case of "make TESTS=test/libndctl check".

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 2601117333a4..ca1d7515d406 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -482,11 +482,11 @@ static int check_btts(struct ndctl_region *region, struct btt **btts);
 static int check_regions(struct ndctl_bus *bus, struct region *regions, int n,
 		enum ns_mode mode)
 {
+	struct ndctl_region *region;
 	int i, rc = 0;
 
 	for (i = 0; i < n; i++) {
 		struct ndctl_interleave_set *iset;
-		struct ndctl_region *region;
 		char devname[50];
 
 		if (strcmp(regions[i].type, "pmem") == 0)
@@ -566,6 +566,10 @@ static int check_regions(struct ndctl_bus *bus, struct region *regions, int n,
 			break;
 	}
 
+	if (rc == 0)
+		ndctl_region_foreach(bus, region)
+			ndctl_region_disable_invalidate(region);
+
 	return rc;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
