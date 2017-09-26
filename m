Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8430121F322A9
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 15:48:49 -0700 (PDT)
Subject: [PATCH] libnvdimm,
 namespace: fix label initialization to use valid seq numbers
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Sep 2017 15:45:37 -0700
Message-ID: <150646593710.6049.14872100814913109721.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The set of valid sequence numbers is {1,2,3}. The specification
indicates that an implementation should consider 0 a sign of a critical
error:

    UEFI 2.7: 13.19 NVDIMM Label Protocol

    Software never writes the sequence number 00, so a correctly
    check-summed Index Block with this sequence number probably indicates a
    critical error. When software discovers this case it treats it as an
    invalid Index Block indication.

While the expectation is that the invalid block is just thrown away, the
Robustness Principle says we should fix this to make both sequence
numbers valid.

Fixes: f524bf271a5c ("libnvdimm: write pmem label set")
Cc: <stable@vger.kernel.org>
Reported-by: Juston Li <juston.li@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 9c5f108910e3..de66c02f6140 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -1050,7 +1050,7 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
 	nsindex = to_namespace_index(ndd, 0);
 	memset(nsindex, 0, ndd->nsarea.config_size);
 	for (i = 0; i < 2; i++) {
-		int rc = nd_label_write_index(ndd, i, i*2, ND_NSINDEX_INIT);
+		int rc = nd_label_write_index(ndd, i, 3 - i, ND_NSINDEX_INIT);
 
 		if (rc)
 			return rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
