From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH 12/16] bvec: use sg_set_pfn when mapping a bio to an sgl
Date: Wed, 24 May 2017 15:42:23 -0600
Message-ID: <1495662147-18277-13-git-send-email-logang@deltatee.com>
References: <1495662147-18277-1-git-send-email-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1495662147-18277-1-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Going through bvec_page and sg_set_page now implies a conversion
to and then from a struct page as well as a potential unnecessary BUG_ON
check. Instead we go directly from bv_pfn to sg_set_pfn.

This is done easily with the following coccinelle patch:

@@
expression sg;
expression bv;
expression len;
expression offset;
@@
-sg_set_page(sg, bvec_page(&bv), len, offset);
+sg_set_pfn(sg, bv.bv_pfn, len, offset);

@@
expression sg;
expression bv;
expression len;
expression offset;
@@
-sg_set_page(sg, bvec_page(bv), len, offset);
+sg_set_pfn(sg, bv->bv_pfn, len, offset);

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Signed-off-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
---
 block/blk-integrity.c                                  |  3 +--
 block/blk-merge.c                                      |  4 ++--
 drivers/block/drbd/drbd_worker.c                       |  3 +--
 drivers/md/dm-crypt.c                                  | 14 ++++++--------
 drivers/md/dm-verity-target.c                          |  2 +-
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |  4 ++--
 6 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 2ba66f7..5ed474b 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -114,8 +114,7 @@ int blk_rq_map_integrity_sg(struct request_queue *q, struct bio *bio,
 				sg = sg_next(sg);
 			}
 
-			sg_set_page(sg, bvec_page(&iv), iv.bv_len,
-				    iv.bv_offset);
+			sg_set_pfn(sg, iv.bv_pfn, iv.bv_len, iv.bv_offset);
 			segments++;
 		}
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 93e87fe..1cf9df6 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -412,7 +412,7 @@ __blk_segment_map_sg(struct request_queue *q, struct bio_vec *bvec,
 			*sg = sg_next(*sg);
 		}
 
-		sg_set_page(*sg, bvec_page(bvec), nbytes, bvec->bv_offset);
+		sg_set_pfn(*sg, bvec->bv_pfn, nbytes, bvec->bv_offset);
 		(*nsegs)++;
 	}
 	*bvprv = *bvec;
@@ -422,7 +422,7 @@ static inline int __blk_bvec_map_sg(struct request_queue *q, struct bio_vec bv,
 		struct scatterlist *sglist, struct scatterlist **sg)
 {
 	*sg = sglist;
-	sg_set_page(*sg, bvec_page(&bv), bv.bv_len, bv.bv_offset);
+	sg_set_pfn(*sg, bv.bv_pfn, bv.bv_len, bv.bv_offset);
 	return 1;
 }
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 719d025..90baaea 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -327,8 +327,7 @@ void drbd_csum_bio(struct crypto_ahash *tfm, struct bio *bio, void *digest)
 	crypto_ahash_init(req);
 
 	bio_for_each_segment(bvec, bio, iter) {
-		sg_set_page(&sg, bvec_page(&bvec), bvec.bv_len,
-			    bvec.bv_offset);
+		sg_set_pfn(&sg, bvec.bv_pfn, bvec.bv_len, bvec.bv_offset);
 		ahash_request_set_crypt(req, &sg, NULL, sg.length);
 		crypto_ahash_update(req);
 		/* REQ_OP_WRITE_SAME has only one segment,
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a10a9c7..9b93c83 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1089,15 +1089,15 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
 	sg_init_table(dmreq->sg_in, 4);
 	sg_set_buf(&dmreq->sg_in[0], sector, sizeof(uint64_t));
 	sg_set_buf(&dmreq->sg_in[1], org_iv, cc->iv_size);
-	sg_set_page(&dmreq->sg_in[2], bvec_page(&bv_in), cc->sector_size,
-		    bv_in.bv_offset);
+	sg_set_pfn(&dmreq->sg_in[2], bv_in.bv_pfn, cc->sector_size,
+		   bv_in.bv_offset);
 	sg_set_buf(&dmreq->sg_in[3], tag, cc->integrity_tag_size);
 
 	sg_init_table(dmreq->sg_out, 4);
 	sg_set_buf(&dmreq->sg_out[0], sector, sizeof(uint64_t));
 	sg_set_buf(&dmreq->sg_out[1], org_iv, cc->iv_size);
-	sg_set_page(&dmreq->sg_out[2], bvec_page(&bv_out), cc->sector_size,
-		    bv_out.bv_offset);
+	sg_set_pfn(&dmreq->sg_out[2], bv_out.bv_pfn, cc->sector_size,
+		   bv_out.bv_offset);
 	sg_set_buf(&dmreq->sg_out[3], tag, cc->integrity_tag_size);
 
 	if (cc->iv_gen_ops) {
@@ -1180,12 +1180,10 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	sg_out = &dmreq->sg_out[0];
 
 	sg_init_table(sg_in, 1);
-	sg_set_page(sg_in, bvec_page(&bv_in), cc->sector_size,
-		    bv_in.bv_offset);
+	sg_set_pfn(sg_in, bv_in.bv_pfn, cc->sector_size, bv_in.bv_offset);
 
 	sg_init_table(sg_out, 1);
-	sg_set_page(sg_out, bvec_page(&bv_out), cc->sector_size,
-		    bv_out.bv_offset);
+	sg_set_pfn(sg_out, bv_out.bv_pfn, cc->sector_size, bv_out.bv_offset);
 
 	if (cc->iv_gen_ops) {
 		/* For READs use IV stored in integrity metadata */
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index d444c7a..7df3ab1 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -412,7 +412,7 @@ int verity_for_io_block(struct dm_verity *v, struct dm_verity_io *io,
 		 * until you consider the typical block size is 4,096B.
 		 * Going through this loops twice should be very rare.
 		 */
-		sg_set_page(&sg, bvec_page(&bv), len, bv.bv_offset);
+		sg_set_pfn(&sg, bv.bv_pfn, len, bv.bv_offset);
 		ahash_request_set_crypt(req, &sg, NULL, len);
 		r = verity_complete_op(res, crypto_ahash_update(req));
 
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 10637e0..88a478a 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -724,8 +724,8 @@ kiblnd_setup_rd_kiov(struct lnet_ni *ni, struct kib_tx *tx,
 
 		fragnob = min((int)(kiov->bv_len - offset), nob);
 
-		sg_set_page(sg, bvec_page(kiov), fragnob,
-			    kiov->bv_offset + offset);
+		sg_set_pfn(sg, kiov->bv_pfn, fragnob,
+			   kiov->bv_offset + offset);
 		sg = sg_next(sg);
 		if (!sg) {
 			CERROR("lacking enough sg entries to map tx\n");
-- 
2.1.4
