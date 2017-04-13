Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DEEE421A6F108
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:06:22 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 13 Apr 2017 16:05:20 -0600
Message-Id: <1492121135-4437-8-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 07/22] crypto: shash,
 caam: Make use of the new sg_map helper function
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

Very straightforward conversion to the new function in two crypto
drivers.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 crypto/shash.c                | 9 ++++++---
 drivers/crypto/caam/caamalg.c | 8 +++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 5e31c8d..2b7de94 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -283,10 +283,13 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
 		void *data;
 
-		data = kmap_atomic(sg_page(sg));
-		err = crypto_shash_digest(desc, data + offset, nbytes,
+		data = sg_map(sg, SG_KMAP_ATOMIC);
+		if (IS_ERR(data))
+			return PTR_ERR(data);
+
+		err = crypto_shash_digest(desc, data, nbytes,
 					  req->result);
-		kunmap_atomic(data);
+		sg_unmap(sg, data, SG_KMAP_ATOMIC);
 		crypto_yield(desc->flags);
 	} else
 		err = crypto_shash_init(desc) ?:
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 9bc80eb..76b97de 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -89,7 +89,6 @@ static void dbg_dump_sg(const char *level, const char *prefix_str,
 			struct scatterlist *sg, size_t tlen, bool ascii)
 {
 	struct scatterlist *it;
-	void *it_page;
 	size_t len;
 	void *buf;
 
@@ -98,19 +97,18 @@ static void dbg_dump_sg(const char *level, const char *prefix_str,
 		 * make sure the scatterlist's page
 		 * has a valid virtual memory mapping
 		 */
-		it_page = kmap_atomic(sg_page(it));
-		if (unlikely(!it_page)) {
+		buf = sg_map(it, SG_KMAP_ATOMIC);
+		if (IS_ERR(buf)) {
 			printk(KERN_ERR "dbg_dump_sg: kmap failed\n");
 			return;
 		}
 
-		buf = it_page + it->offset;
 		len = min_t(size_t, tlen, it->length);
 		print_hex_dump(level, prefix_str, prefix_type, rowsize,
 			       groupsize, buf, len, ascii);
 		tlen -= len;
 
-		kunmap_atomic(it_page);
+		sg_unmap(it, buf, SG_KMAP_ATOMIC);
 	}
 }
 #endif
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
