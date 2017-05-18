Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB69021A16EFB
 for <linux-nvdimm@lists.01.org>; Wed, 17 May 2017 23:27:56 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/23] uuid: remove struct uuid_v1
Date: Thu, 18 May 2017 08:26:53 +0200
Message-Id: <20170518062705.25902-12-hch@lst.de>
In-Reply-To: <20170518062705.25902-1-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
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

Unused now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uuid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 47ca06d846d4..e8a065035113 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -40,7 +40,7 @@ typedef struct {
 		 * - the clock sequence is a 14-bit counter to avoid duplicate
 		 *   times
 		 */
-		struct uuid_v1 {
+		struct {
 			__be32		time_low;
 			__be16		time_mid;
 			__be16		time_hi_and_version;
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
