Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 9E4021A1E76
 for <linux-nvdimm@lists.01.org>; Wed, 18 May 2016 16:44:59 -0700 (PDT)
Subject: [PATCH 2/2] libnvdimm, dax: fix alignment validation
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 May 2016 16:44:07 -0700
Message-ID: <146361504728.37798.4211838382035993859.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146361503689.37798.44566892348278285.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146361503689.37798.44566892348278285.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Testing the dax-device autodetect support revealed a probe failure with
the following result:

    dax0.1: bad offset: 0x8200000 dax disabled

The original pfn-device implementation inferred the alignment from
ilog2(offset), now that the alignment is explicit the is_power_of_2()
needs replacing with a real sanity check against the recorded alignment.
Otherwise the alignment check is useless in the implicit case and only
the minimum size of the offset matters.

This self-consistency check is further validated by the probe path that
will re-check that the offset is large enough to contain all the
metadata required to enable the device.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 816cd9828ca5..33c97076ddf0 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -416,6 +416,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 			return -ENODEV;
 	}
 
+	nd_pfn->align = le32_to_cpu(pfn_sb->align);
 	if (nd_pfn->align > nvdimm_namespace_capacity(ndns)) {
 		dev_err(&nd_pfn->dev, "alignment: %lx exceeds capacity %llx\n",
 				nd_pfn->align, nvdimm_namespace_capacity(ndns));
@@ -436,8 +437,8 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 		return -EBUSY;
 	}
 
-	nd_pfn->align = le32_to_cpu(pfn_sb->align);
-	if (!is_power_of_2(offset) || offset < PAGE_SIZE) {
+	if ((nd_pfn->align && !IS_ALIGNED(offset, nd_pfn->align))
+			|| !IS_ALIGNED(offset, PAGE_SIZE)) {
 		dev_err(&nd_pfn->dev, "bad offset: %#llx dax disabled\n",
 				offset);
 		return -ENXIO;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
