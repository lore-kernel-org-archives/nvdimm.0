Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C1D3C21A0BAB0
 for <linux-nvdimm@lists.01.org>; Mon, 15 May 2017 08:43:31 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/17] uuid: remove the now unused uuid_be_cmp helper
Date: Mon, 15 May 2017 17:42:58 +0200
Message-Id: <20170515154308.26739-8-hch@lst.de>
In-Reply-To: <20170515154308.26739-1-hch@lst.de>
References: <20170515154308.26739-1-hch@lst.de>
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uuid.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index aef21b580b17..21218351ae26 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -92,9 +92,4 @@ static inline int uuid_le_cmp(const guid_t u1, const guid_t u2)
 	return memcmp(&u1, &u2, sizeof(guid_t));
 }
 
-static inline int uuid_be_cmp(const uuid_t u1, const uuid_t u2)
-{
-	return memcmp(&u1, &u2, sizeof(uuid_t));
-}
-
 #endif
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
