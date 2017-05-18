Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5930521A16EFB
 for <linux-nvdimm@lists.01.org>; Wed, 17 May 2017 23:28:40 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/23] uuid: remove uuid_be
Date: Thu, 18 May 2017 08:27:05 +0200
Message-Id: <20170518062705.25902-24-hch@lst.de>
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

Everything uses uuid_t now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uuid.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index e8a065035113..6b9a05570565 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -111,26 +111,12 @@ int guid_to_bin(const char *uuid, guid_t *u);
 int uuid_to_bin(const char *uuid, uuid_t *u);
 
 /* backwards compatibility, don't use in new code */
-typedef uuid_t uuid_be;
-#define UUID_BE(a, _b, c, d0, d1, d2, d3, d4, d5, d6, d7) \
-	UUID(a, _b, c, d0, d1, d2, d3, d4, d5, d6, d7)
-#define NULL_UUID_BE 							\
-	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
-	     0x00, 0x00, 0x00, 0x00)
-
 #define uuid_le_gen(u)		guid_gen(u)
-#define uuid_be_gen(u)		uuid_gen(u)
 #define uuid_le_to_bin(guid, u)	guid_to_bin(guid, u)
-#define uuid_be_to_bin(uuid, u)	uuid_to_bin(uuid, u)
 
 static inline int uuid_le_cmp(const guid_t u1, const guid_t u2)
 {
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
