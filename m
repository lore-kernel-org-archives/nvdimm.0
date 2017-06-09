Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ABFD120082E7E
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 22:14:54 -0700 (PDT)
Subject: [PATCH 9/9] libnvdimm, label: switch to using v1.2 labels by default
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 08 Jun 2017 22:09:38 -0700
Message-ID: <149698497813.11651.7323633285531215656.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149698493023.11651.13036549892428981091.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149698493023.11651.13036549892428981091.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The rules for which version of the label specification are in effect at
any given point in time are as follows:

1/ If a DIMM has an existing / valid index block then the version
   specified is used regardless if it is a previous version.

2/ By default when the kernel is initializing new index blocks the
   latest specification version (v1.2 at time of writing) is used.

3/ An environment that wants to force create v1.1 label-sets must
   arrange for userspace to disable all active regions / namespaces /
   dimms and write a valid set of v1.1 index blocks to the dimms.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 837bf21c8555..235f2089fab2 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -222,9 +222,10 @@ int nd_label_validate(struct nvdimm_drvdata *ndd)
 	 * need to know the size of the labels, and we can't trust the
 	 * size of the labels until we validate the index blocks.
 	 * Resolve this dependency loop by probing for known label
-	 * sizes.
+	 * sizes, but default to v1.2 256-byte namespace labels if
+	 * discovery fails.
 	 */
-	int label_size[] = { 256, 128 };
+	int label_size[] = { 128, 256 };
 	int i, rc;
 
 	for (i = 0; i < ARRAY_SIZE(label_size); i++) {
@@ -532,7 +533,10 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
 	nsindex->labeloff = __cpu_to_le64(offset);
 	nsindex->nslot = __cpu_to_le32(nslot);
 	nsindex->major = __cpu_to_le16(1);
-	nsindex->minor = __cpu_to_le16(1);
+	if (sizeof_namespace_label(ndd) < 256)
+		nsindex->minor = __cpu_to_le16(1);
+	else
+		nsindex->minor = __cpu_to_le16(2);
 	nsindex->checksum = __cpu_to_le64(0);
 	if (flags & ND_NSINDEX_INIT) {
 		unsigned long *free = (unsigned long *) nsindex->free;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
