Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9EEDF2034D834
 for <linux-nvdimm@lists.01.org>; Tue,  7 Nov 2017 15:45:22 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] libndctl,
 inject: ensure that bb_add_record doesn't leak memory
Date: Tue,  7 Nov 2017 16:47:06 -0700
Message-Id: <20171107234706.6406-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

It was non-obvious that in the loop to add a new badblock, the entry
allocated was always consumed by adding it to the list. Ensure that it
happens by setting the 'bb' pointer to NULL when we add it to the list,
and at the end of the loop, free and error out if it was not added.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/inject.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
index 4df6414..8bfb5c9 100644
--- a/ndctl/lib/inject.c
+++ b/ndctl/lib/inject.c
@@ -199,6 +199,7 @@ static int bb_add_record(struct list_head *h, u64 block, u64 count)
 			/* bb_iter is the first entry */
 			if (bb->block < bb_iter->block) {
 				list_add(h, &bb->list);
+				bb = NULL;
 				break;
 			}
 		}
@@ -210,12 +211,14 @@ static int bb_add_record(struct list_head *h, u64 block, u64 count)
 			 * following checks for the previous iteration.
 			 */
 			list_add_tail(h, &bb->list);
+			bb = NULL;
 			break;
 		}
 		/* Add to the left of bb_iter */
 		if (bb->block <= bb_iter->block) {
 			if (bb_prev && (bb_prev->block <= bb->block)) {
 				list_add_after(h, &bb_prev->list, &bb->list);
+				bb = NULL;
 				break;
 			}
 		}
@@ -223,11 +226,18 @@ static int bb_add_record(struct list_head *h, u64 block, u64 count)
 		if (bb_iter->block <= bb->block) {
 			if (bb_next && (bb->block <= bb_next->block)) {
 				list_add_after(h, &bb_iter->list, &bb->list);
+				bb = NULL;
 				break;
 			}
 		}
 	}
 
+	/* ensure bb has actually been consumed (set to NULL earlier) */
+	if (bb != NULL) {
+		free(bb);
+		return -ENXIO;
+	}
+
 	/* second pass over the list looking for mergeable entries */
 	list_for_each(h, bb_iter, list) {
 		u64 cur_end, next_end, cur_start, next_start;
@@ -357,6 +367,11 @@ NDCTL_EXPORT int ndctl_namespace_injection_status(struct ndctl_namespace *ndns)
 		}
 		rc = injection_status_to_bb(ndns, err_inj_stat,
 			ns_offset, ns_size);
+		if (rc) {
+			dbg(ctx, "Error converting status to badblocks: %d\n",
+				rc);
+			goto out;
+		}
 	}
 
  out:
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
