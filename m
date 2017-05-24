Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 65A1E2095A32E
 for <linux-nvdimm@lists.01.org>; Wed, 24 May 2017 14:43:20 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Wed, 24 May 2017 15:42:20 -0600
Message-Id: <1495662147-18277-10-git-send-email-logang@deltatee.com>
In-Reply-To: <1495662147-18277-1-git-send-email-logang@deltatee.com>
References: <1495662147-18277-1-git-send-email-logang@deltatee.com>
Subject: [RFC PATCH 09/16] bvec: introduce bvec_page and bvec_set_page
 accessors
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
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Berg <johannes.berg@intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ming Lei <ming.lei@canonical.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Introduce two accessor functions for bv_page: bvec_page to return the
page and bvec_set_page. A follow on patch will mechanically convert all the
individual uses within the kernel.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 include/linux/bvec.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 89b65b8..b5369a0 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -43,6 +43,16 @@ struct bvec_iter {
 						   current bvec */
 };
 
+static inline struct page *bvec_page(const struct bio_vec *bvec)
+{
+	return bvec->bv_page;
+}
+
+static inline void bvec_set_page(struct bio_vec *bvec, struct page *page)
+{
+	bvec->bv_page = page;
+}
+
 /*
  * various member access, note that bio_data should of course not be used
  * on highmem page vectors
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
