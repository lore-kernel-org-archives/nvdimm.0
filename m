Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D35921A0BAB0
 for <linux-nvdimm@lists.01.org>; Mon, 15 May 2017 08:43:38 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/17] uuid: add the v1 layout to uuid_t
Date: Mon, 15 May 2017 17:42:56 +0200
Message-Id: <20170515154308.26739-6-hch@lst.de>
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

Turn the content of uuid_t into a union and add the fields for the v1
interpretation to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Howells <dhowells@redhat.com>
---
 include/uapi/linux/uuid.h | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
index c31fc94695b9..6b6a583ec1fe 100644
--- a/include/uapi/linux/uuid.h
+++ b/include/uapi/linux/uuid.h
@@ -32,15 +32,42 @@ typedef struct {
    (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
 
 typedef struct {
-	__u8 b[16];
+	union {
+		__u8			b[16];
+
+		/*
+		 * V1 (time-based) UUID definition [RFC 4122]:
+		 * - the timestamp is a 60-bit value, split 32/16/12, and goes
+		 *   in 100ns increments since midnight 15th October 1582
+		 *   - add UUID_TO_UNIX_TIME to convert unix time in 100ns
+		 *     units to UUID time
+		 * - the clock sequence is a 14-bit counter to avoid duplicate
+		 *   times
+		 */
+		struct {
+			__be32		time_low;
+			__be16		time_mid;
+			__be16		time_hi_and_version;
+#define UUID_TO_UNIX_TIME	0x01b21dd213814000ULL
+#define UUID_TIMEHI_MASK	0x0fff
+#define UUID_VERSION_TIME	0x1000	/* time-based UUID */
+#define UUID_VERSION_NAME	0x3000	/* name-based UUID */
+#define UUID_VERSION_RANDOM	0x4000	/* (pseudo-)random generated UUID */
+			u8		clock_seq_hi_and_reserved;
+#define UUID_CLOCKHI_MASK	0x3f
+#define UUID_VARIANT_STD	0x80
+			u8		clock_seq_low;
+			u8		node[6];
+		} v1;
+	};
 } uuid_t;
 
-#define UUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
-((uuid_t)								\
-{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
-   ((b) >> 8) & 0xff, (b) & 0xff,					\
+#define UUID(a, _b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
+{ .b = {								\
+   ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
+   ((_b) >> 8) & 0xff, (_b) & 0xff,					\
    ((c) >> 8) & 0xff, (c) & 0xff,					\
-   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
+   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }}
 
 /* backwards compatibility, don't use in new code */
 typedef guid_t uuid_le;
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
