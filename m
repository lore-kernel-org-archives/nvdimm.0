Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 685CC21962301
 for <linux-nvdimm@lists.01.org>; Thu, 11 Oct 2018 19:05:50 -0700 (PDT)
Subject: [PATCH] libnvdimm, label: Fix sparse warning
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Oct 2018 18:54:01 -0700
Message-ID: <153930924180.1057750.14086655850300209980.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>, kbuild test robot <lkp@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The kbuild robot reports:

drivers/nvdimm/label.c:500:32: warning: restricted __le32 degrades to integer

...read 'nslot' into a local u32.

Reported-by: kbuild test robot <lkp@intel.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 7f03d117824f..750dbaa6ce82 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -424,6 +424,7 @@ int nd_label_data_init(struct nvdimm_drvdata *ndd)
 	struct nd_namespace_index *nsindex;
 	unsigned int i;
 	int rc = 0;
+	u32 nslot;
 
 	if (ndd->data)
 		return 0;
@@ -495,9 +496,10 @@ int nd_label_data_init(struct nvdimm_drvdata *ndd)
 
 	/* Determine starting offset for label data */
 	offset = __le64_to_cpu(nsindex->labeloff);
+	nslot = __le32_to_cpu(nsindex->nslot);
 
 	/* Loop through the free list pulling in any active labels */
-	for (i = 0; i < nsindex->nslot; i++, offset += ndd->nslabel_size) {
+	for (i = 0; i < nslot; i++, offset += ndd->nslabel_size) {
 		size_t label_read_size;
 
 		/* zero out the unused labels */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
