Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F69021F322BF
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 15:49:50 -0700 (PDT)
Subject: [ndctl PATCH] ndctl,
 init-labels: fix label initialization to use valid seq numbers
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Sep 2017 15:46:38 -0700
Message-ID: <150646599811.6110.8609223703710925670.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Fixes: 681f5d786e94 ("ndctl: init-labels command")
Reported-by: Juston Li <juston.li@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/dimm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 794a4f4469c9..b3e032e04088 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -452,7 +452,7 @@ NDCTL_EXPORT int ndctl_dimm_init_labels(struct ndctl_dimm *dimm,
 	for (i = 0; i < 2; i++) {
 		int rc;
 
-		rc = write_label_index(dimm, v, i, i*2);
+		rc = write_label_index(dimm, v, i, 3 - i);
 		if (rc < 0)
 			return rc;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
