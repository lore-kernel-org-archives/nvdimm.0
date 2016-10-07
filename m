Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF2951A1E9E
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:42:52 -0700 (PDT)
Subject: [PATCH 13/14] libnvdimm,
 namespace: lift single pmem limit in scan_labels()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:39:50 -0700
Message-ID: <147585838991.22349.155698398778808029.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Now that the rest of the infrastructure has been converted to handle
multi-pmem configurations, lift the artificial barrier at scan time.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 54babc3a80ca..fa51d751ccf7 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2070,9 +2070,6 @@ static struct device **scan_labels(struct nd_region *nd_region)
 				}
 			} else
 				devs[count++] = dev;
-
-			/* we only expect one valid pmem label set per region */
-			break;
 		}
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
