Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 995371A1E72
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:42:31 -0700 (PDT)
Subject: [PATCH 09/14] libnvdimm,
 namespace: expand pmem device naming scheme for multi-pmem
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:39:29 -0700
Message-ID: <147585836894.22349.11287745776727706515.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

pmem devices are currently named /dev/pmem<region-index>. Preserve the
naming of the 0th device, but add a ".<namespace-index>" for other
devices.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index f0536c2789e9..132c5b8b5366 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -173,7 +173,21 @@ const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 		suffix = "s";
 
 	if (is_namespace_pmem(&ndns->dev) || is_namespace_io(&ndns->dev)) {
-		sprintf(name, "pmem%d%s", nd_region->id, suffix ? suffix : "");
+		int nsidx = 0;
+
+		if (is_namespace_pmem(&ndns->dev)) {
+			struct nd_namespace_pmem *nspm;
+
+			nspm = to_nd_namespace_pmem(&ndns->dev);
+			nsidx = nspm->id;
+		}
+
+		if (nsidx)
+			sprintf(name, "pmem%d.%d%s", nd_region->id, nsidx,
+					suffix ? suffix : "");
+		else
+			sprintf(name, "pmem%d%s", nd_region->id,
+					suffix ? suffix : "");
 	} else if (is_namespace_blk(&ndns->dev)) {
 		struct nd_namespace_blk *nsblk;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
