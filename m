From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [patch] nd_blk,nd_pmem,nd_btt: add endio blktrace events
Date: Wed, 09 Nov 2016 14:08:33 -0500
Message-ID: <x49twbgo4i6.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Dan J. Williams" <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Right now, any of the above three drivers will report Q events in
blktrace but no corresponding C events.  Fix it.

Signed-off-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 9faaa96..90676f3 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -19,6 +19,7 @@
 #include <linux/moduleparam.h>
 #include <linux/nd.h>
 #include <linux/sizes.h>
+#include <trace/events/block.h>
 #include "nd.h"
 
 static u32 nsblk_meta_size(struct nd_namespace_blk *nsblk)
@@ -213,6 +214,7 @@ static blk_qc_t nd_blk_make_request(struct request_queue *q, struct bio *bio)
 		nd_iostat_end(bio, start);
 
  out:
+	trace_block_bio_complete(q, bio, bio->bi_error);
 	bio_endio(bio);
 	return BLK_QC_T_NONE;
 }
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 368795a..a11c00d 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -23,6 +23,7 @@
 #include <linux/ndctl.h>
 #include <linux/fs.h>
 #include <linux/nd.h>
+#include <trace/events/block.h>
 #include "btt.h"
 #include "nd.h"
 
@@ -1195,6 +1196,7 @@ static blk_qc_t btt_make_request(struct request_queue *q, struct bio *bio)
 		nd_iostat_end(bio, start);
 
 out:
+	trace_block_bio_complete(q, bio, bio->bi_error);
 	bio_endio(bio);
 	return BLK_QC_T_NONE;
 }
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 42b3a82..4ea3b9f 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/pmem.h>
 #include <linux/nd.h>
+#include <trace/events/block.h>
 #include "pmem.h"
 #include "pfn.h"
 #include "nd.h"
@@ -165,6 +166,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	if (bio->bi_opf & REQ_FUA)
 		nvdimm_flush(nd_region);
 
+	trace_block_bio_complete(q, bio, bio->bi_error);
 	bio_endio(bio);
 	return BLK_QC_T_NONE;
 }
