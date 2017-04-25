Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2FC9521951C8D
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 11:21:18 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Tue, 25 Apr 2017 12:20:55 -0600
Message-Id: <1493144468-22493-9-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 08/21] dm-crypt: Make use of the new sg_map helper in 4
 call sites
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
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, target-devel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sumit Semwal <sumit.semwal@linaro.org>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Very straightforward conversion to the new function in all four spots.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-crypt.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8dbecf1..841f1fc 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -635,9 +635,12 @@ static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
 
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
 		sg = crypt_get_sg_data(cc, dmreq->sg_in);
-		src = kmap_atomic(sg_page(sg));
-		r = crypt_iv_lmk_one(cc, iv, dmreq, src + sg->offset);
-		kunmap_atomic(src);
+		src = sg_map(sg, 0, SG_KMAP_ATOMIC);
+		if (IS_ERR(src))
+			return PTR_ERR(src);
+
+		r = crypt_iv_lmk_one(cc, iv, dmreq, src);
+		sg_unmap(sg, src, 0, SG_KMAP_ATOMIC);
 	} else
 		memset(iv, 0, cc->iv_size);
 
@@ -655,14 +658,18 @@ static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
 		return 0;
 
 	sg = crypt_get_sg_data(cc, dmreq->sg_out);
-	dst = kmap_atomic(sg_page(sg));
-	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + sg->offset);
+	dst = sg_map(sg, 0, SG_KMAP_ATOMIC);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
+
+	r = crypt_iv_lmk_one(cc, iv, dmreq, dst);
 
 	/* Tweak the first block of plaintext sector */
 	if (!r)
-		crypto_xor(dst + sg->offset, iv, cc->iv_size);
+		crypto_xor(dst, iv, cc->iv_size);
+
+	sg_unmap(sg, dst, 0, SG_KMAP_ATOMIC);
 
-	kunmap_atomic(dst);
 	return r;
 }
 
@@ -786,9 +793,12 @@ static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
 	/* Remove whitening from ciphertext */
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
 		sg = crypt_get_sg_data(cc, dmreq->sg_in);
-		src = kmap_atomic(sg_page(sg));
-		r = crypt_iv_tcw_whitening(cc, dmreq, src + sg->offset);
-		kunmap_atomic(src);
+		src = sg_map(sg, 0, SG_KMAP_ATOMIC);
+		if (IS_ERR(src))
+			return PTR_ERR(src);
+
+		r = crypt_iv_tcw_whitening(cc, dmreq, src);
+		sg_unmap(sg, src, 0, SG_KMAP_ATOMIC);
 	}
 
 	/* Calculate IV */
@@ -812,9 +822,12 @@ static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
 
 	/* Apply whitening on ciphertext */
 	sg = crypt_get_sg_data(cc, dmreq->sg_out);
-	dst = kmap_atomic(sg_page(sg));
-	r = crypt_iv_tcw_whitening(cc, dmreq, dst + sg->offset);
-	kunmap_atomic(dst);
+	dst = sg_map(sg, 0, SG_KMAP_ATOMIC);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
+
+	r = crypt_iv_tcw_whitening(cc, dmreq, dst);
+	sg_unmap(sg, dst, 0, SG_KMAP_ATOMIC);
 
 	return r;
 }
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
