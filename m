Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E4B92194EB6F
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:06:42 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 13 Apr 2017 16:05:22 -0600
Message-Id: <1492121135-4437-10-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 09/22] dm-crypt: Make use of the new sg_map helper in 4 call
 sites
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
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Sumit Semwal <sumit.semwal@linaro.org>, Ming Lin <ming.l@ssi.samsung.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, target-devel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: Steve Wise <swise@opengridcomputing.com>
List-ID: <linux-nvdimm@lists.01.org>

Very straightforward conversion to the new function in all four spots.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/dm-crypt.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 389a363..6bd0ffc 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -589,9 +589,12 @@ static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
 	int r = 0;
 
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
-		src = kmap_atomic(sg_page(&dmreq->sg_in));
-		r = crypt_iv_lmk_one(cc, iv, dmreq, src + dmreq->sg_in.offset);
-		kunmap_atomic(src);
+		src = sg_map(&dmreq->sg_in, SG_KMAP_ATOMIC);
+		if (IS_ERR(src))
+			return PTR_ERR(src);
+
+		r = crypt_iv_lmk_one(cc, iv, dmreq, src);
+		sg_unmap(&dmreq->sg_in, src, SG_KMAP_ATOMIC);
 	} else
 		memset(iv, 0, cc->iv_size);
 
@@ -607,14 +610,17 @@ static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
 		return 0;
 
-	dst = kmap_atomic(sg_page(&dmreq->sg_out));
-	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + dmreq->sg_out.offset);
+	dst = sg_map(&dmreq->sg_out, SG_KMAP_ATOMIC);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
+
+	r = crypt_iv_lmk_one(cc, iv, dmreq, dst);
 
 	/* Tweak the first block of plaintext sector */
 	if (!r)
-		crypto_xor(dst + dmreq->sg_out.offset, iv, cc->iv_size);
+		crypto_xor(dst, iv, cc->iv_size);
 
-	kunmap_atomic(dst);
+	sg_unmap(&dmreq->sg_out, dst, SG_KMAP_ATOMIC);
 	return r;
 }
 
@@ -731,9 +737,12 @@ static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
 
 	/* Remove whitening from ciphertext */
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
-		src = kmap_atomic(sg_page(&dmreq->sg_in));
-		r = crypt_iv_tcw_whitening(cc, dmreq, src + dmreq->sg_in.offset);
-		kunmap_atomic(src);
+		src = sg_map(&dmreq->sg_in, SG_KMAP_ATOMIC);
+		if (IS_ERR(src))
+			return PTR_ERR(src);
+
+		r = crypt_iv_tcw_whitening(cc, dmreq, src);
+		sg_unmap(&dmreq->sg_in, src, SG_KMAP_ATOMIC);
 	}
 
 	/* Calculate IV */
@@ -755,9 +764,12 @@ static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
 		return 0;
 
 	/* Apply whitening on ciphertext */
-	dst = kmap_atomic(sg_page(&dmreq->sg_out));
-	r = crypt_iv_tcw_whitening(cc, dmreq, dst + dmreq->sg_out.offset);
-	kunmap_atomic(dst);
+	dst = sg_map(&dmreq->sg_out, SG_KMAP_ATOMIC);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
+
+	r = crypt_iv_tcw_whitening(cc, dmreq, dst);
+	sg_unmap(&dmreq->sg_out, dst, SG_KMAP_ATOMIC);
 
 	return r;
 }
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
