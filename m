Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 62381226516AA
 for <linux-nvdimm@lists.01.org>; Sat,  7 Apr 2018 08:00:53 -0700 (PDT)
Subject: [PATCH] libnvdimm, region: quiet region probe
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 07 Apr 2018 07:50:57 -0700
Message-ID: <152311265738.13507.13982862389654638905.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The message about constraining number of online cpus to be less than or
equal to ND_MAX_LANES (256) is only useful for block-aperture
configurations and BTT. Make it debug since its only relevant when
debugging performance.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 034f0a07d627..b9ca0033cc99 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -27,10 +27,10 @@ static int nd_region_probe(struct device *dev)
 	if (nd_region->num_lanes > num_online_cpus()
 			&& nd_region->num_lanes < num_possible_cpus()
 			&& !test_and_set_bit(0, &once)) {
-		dev_info(dev, "online cpus (%d) < concurrent i/o lanes (%d) < possible cpus (%d)\n",
+		dev_dbg(dev, "online cpus (%d) < concurrent i/o lanes (%d) < possible cpus (%d)\n",
 				num_online_cpus(), nd_region->num_lanes,
 				num_possible_cpus());
-		dev_info(dev, "setting nr_cpus=%d may yield better libnvdimm device performance\n",
+		dev_dbg(dev, "setting nr_cpus=%d may yield better libnvdimm device performance\n",
 				nd_region->num_lanes);
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
