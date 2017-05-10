Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D21F21A04E04
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 11:02:53 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/16] uuid: hoist uuid_is_null() helper from libnvdimm
Date: Wed, 10 May 2017 20:02:09 +0200
Message-Id: <20170510180214.16852-12-hch@lst.de>
In-Reply-To: <20170510180214.16852-1-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
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

From: Amir Goldstein <amir73il@gmail.com>

Hoist the libnvdimm helper as an inline helper to linux/uuid.h
using an auxiliary const variable uuid_null in lib/uuid.c.

[hch: also add the guid variant.  Both do the same but I'd like
to keep casts to a minimum]

The common helper uses the new abstract type uuid_t * instead of
u8 *.

Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[hch: added guid_is_null]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvdimm/btt_devs.c |  9 +--------
 include/linux/uuid.h      | 13 +++++++++++++
 lib/uuid.c                |  5 +++++
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 4b76af2b8715..734290d30557 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -222,13 +222,6 @@ struct device *nd_btt_create(struct nd_region *nd_region)
 	return dev;
 }
 
-static bool uuid_is_null(u8 *uuid)
-{
-	static const u8 null_uuid[16];
-
-	return (memcmp(uuid, null_uuid, 16) == 0);
-}
-
 /**
  * nd_btt_arena_is_valid - check if the metadata layout is valid
  * @nd_btt:	device with BTT geometry and backing device info
@@ -249,7 +242,7 @@ bool nd_btt_arena_is_valid(struct nd_btt *nd_btt, struct btt_sb *super)
 	if (memcmp(super->signature, BTT_SIG, BTT_SIG_LEN) != 0)
 		return false;
 
-	if (!uuid_is_null(super->parent_uuid))
+	if (!guid_is_null((guid_t *)&super->parent_uuid))
 		if (memcmp(super->parent_uuid, parent_uuid, 16) != 0)
 			return false;
 
diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index b7fec8b266eb..2f9bdc88079e 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -24,6 +24,9 @@
  */
 #define	UUID_STRING_LEN		36
 
+extern const guid_t guid_null;
+extern const uuid_t uuid_null;
+
 static inline int guid_cmp(const guid_t u1, const guid_t u2)
 {
 	return memcmp(&u1, &u2, sizeof(guid_t));
@@ -39,6 +42,11 @@ static inline void guid_copy(guid_t *dst, const guid_t *src)
 	memcpy(dst, src, sizeof(guid_t));
 }
 
+static inline bool guid_is_null(guid_t *guid)
+{
+	return guid_equal(guid, &guid_null);
+}
+
 static inline int uuid_cmp(const uuid_t u1, const uuid_t u2)
 {
 	return memcmp(&u1, &u2, sizeof(uuid_t));
@@ -54,6 +62,11 @@ static inline void uuid_copy(uuid_t *dst, const uuid_t *src)
 	memcpy(dst, src, sizeof(uuid_t));
 }
 
+static inline bool uuid_is_null(uuid_t *uuid)
+{
+	return uuid_equal(uuid, &uuid_null);
+}
+
 void generate_random_uuid(unsigned char uuid[16]);
 
 extern void guid_gen(guid_t *u);
diff --git a/lib/uuid.c b/lib/uuid.c
index 003bf6823003..25145bfb0eaa 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -21,6 +21,11 @@
 #include <linux/uuid.h>
 #include <linux/random.h>
 
+const guid_t guid_null;
+EXPORT_SYMBOL(guid_null);
+const uuid_t uuid_null;
+EXPORT_SYMBOL(uuid_null);
+
 const u8 guid_index[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
 const u8 uuid_index[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
 
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
