Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 4677F1A1E01
 for <linux-nvdimm@lists.01.org>; Sun, 26 Jun 2016 16:25:55 -0700 (PDT)
Subject: [ndctl PATCH 2/9] test,
 libndctl: invalidate dax info blocks before reuse
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Jun 2016 16:24:38 -0700
Message-ID: <146698347889.40541.8448936636550885217.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
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

A recent kernel fix addressed cases where a live setting change
mismatches with the current contents of the info block.  Rather than
silently overwrite the new settings with the info block contents the
kernel now invalidates the info block if the uuid changes, but otherwise
warns if a setting is mismatched.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/test/libndctl.c b/test/libndctl.c
index 147f69d0c27a..8346108aacec 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -787,6 +787,12 @@ static int check_dax_create(struct ndctl_region *region,
 	for (i = 0; i < ARRAY_SIZE(dax_s->locs); i++) {
 		fprintf(stderr, "%s: %ld\n", __func__, ARRAY_SIZE(dax_s->aligns));
 		for (j = 0; j < ARRAY_SIZE(dax_s->aligns); j++) {
+			/*
+			 * The kernel enforces invalidating the previous
+			 * info block when the current uuid is does not
+			 * validate with the contents of the info block.
+			 */
+			dax_s->uuid[0]++;
 			rc = __check_dax_create(region, ndns, namespace,
 					dax_s->locs[i], dax_s->aligns[j],
 					dax_s->uuid);
@@ -923,6 +929,12 @@ static int check_pfn_create(struct ndctl_region *region,
 
 	for (i = 0; i < ARRAY_SIZE(pfn_s->locs); i++) {
 		for (j = 0; j < ARRAY_SIZE(pfn_s->aligns); j++) {
+			/*
+			 * The kernel enforces invalidating the previous
+			 * info block when the current uuid is does not
+			 * validate with the contents of the info block.
+			 */
+			pfn_s->uuid[0]++;
 			rc = __check_pfn_create(region, ndns, namespace, buf,
 					pfn_s->locs[i], pfn_s->aligns[j],
 					pfn_s->uuid);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
