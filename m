Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3343321AF39C0
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 09:18:14 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/24] uuid: rename uuid types
Date: Wed, 31 May 2017 18:18:08 +0200
Message-Id: <20170531161826.23243-7-hch@lst.de>
In-Reply-To: <20170531161826.23243-1-hch@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
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
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-block@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Our "little endian" UUID really is a Wintel GUID, so rename it and its
helpers such (guid_t).  The big endian UUID is the only true one, so
give it the name uuid_t.  The uuid_le and uuid_be names are retained for
now, but will hopefully go away soon.  The exception to that are the _cmp
helpers that will be replaced by better primitives ASAP and thus don't
get the new names.

Also remove the existing typedef in XFS that's now been superceeded by
the generic type name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[andy: also update the UUID_LE/UUID_BE macros including fallout]
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 fs/xfs/xfs_linux.h        |  2 --
 include/linux/uuid.h      | 55 +++++++++++++++++++++++++++--------------------
 include/uapi/linux/uuid.h | 12 +++++++----
 lib/test_uuid.c           | 32 +++++++++++++--------------
 lib/uuid.c                | 28 ++++++++++++------------
 lib/vsprintf.c            |  4 ++--
 6 files changed, 72 insertions(+), 61 deletions(-)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 89ee5ec66837..2c33d915e550 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -39,8 +39,6 @@ typedef __s64			xfs_daddr_t;	/* <disk address> type */
 typedef __u32			xfs_dev_t;
 typedef __u32			xfs_nlink_t;
 
-typedef uuid_be			uuid_t;
-
 #include "xfs_types.h"
 
 #include "kmem.h"
diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 30fb13018e29..a9d0fdba5404 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -20,46 +20,55 @@
 
 typedef struct {
 	__u8 b[16];
-} uuid_be;
+} uuid_t;
 
-#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
-((uuid_be)								\
+#define UUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
+((uuid_t)								\
 {{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
    ((b) >> 8) & 0xff, (b) & 0xff,					\
    ((c) >> 8) & 0xff, (c) & 0xff,					\
    (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
 
-#define NULL_UUID_BE							\
-	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
-		0x00, 0x00, 0x00, 0x00)
-
 /*
  * The length of a UUID string ("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
  * not including trailing NUL.
  */
 #define	UUID_STRING_LEN		36
 
-static inline int uuid_le_cmp(const uuid_le u1, const uuid_le u2)
-{
-	return memcmp(&u1, &u2, sizeof(uuid_le));
-}
-
-static inline int uuid_be_cmp(const uuid_be u1, const uuid_be u2)
-{
-	return memcmp(&u1, &u2, sizeof(uuid_be));
-}
-
 void generate_random_uuid(unsigned char uuid[16]);
 
-extern void uuid_le_gen(uuid_le *u);
-extern void uuid_be_gen(uuid_be *u);
+extern void guid_gen(guid_t *u);
+extern void uuid_gen(uuid_t *u);
 
 bool __must_check uuid_is_valid(const char *uuid);
 
-extern const u8 uuid_le_index[16];
-extern const u8 uuid_be_index[16];
+extern const u8 guid_index[16];
+extern const u8 uuid_index[16];
+
+int guid_to_bin(const char *uuid, guid_t *u);
+int uuid_to_bin(const char *uuid, uuid_t *u);
 
-int uuid_le_to_bin(const char *uuid, uuid_le *u);
-int uuid_be_to_bin(const char *uuid, uuid_be *u);
+/* backwards compatibility, don't use in new code */
+typedef uuid_t uuid_be;
+#define UUID_BE(a, _b, c, d0, d1, d2, d3, d4, d5, d6, d7) \
+	UUID(a, _b, c, d0, d1, d2, d3, d4, d5, d6, d7)
+#define NULL_UUID_BE 							\
+	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+	     0x00, 0x00, 0x00, 0x00)
+
+#define uuid_le_gen(u)		guid_gen(u)
+#define uuid_be_gen(u)		uuid_gen(u)
+#define uuid_le_to_bin(guid, u)	guid_to_bin(guid, u)
+#define uuid_be_to_bin(uuid, u)	uuid_to_bin(uuid, u)
+
+static inline int uuid_le_cmp(const guid_t u1, const guid_t u2)
+{
+	return memcmp(&u1, &u2, sizeof(guid_t));
+}
+
+static inline int uuid_be_cmp(const uuid_t u1, const uuid_t u2)
+{
+	return memcmp(&u1, &u2, sizeof(uuid_t));
+}
 
 #endif
diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
index 0099756c4bac..1eeeca973315 100644
--- a/include/uapi/linux/uuid.h
+++ b/include/uapi/linux/uuid.h
@@ -22,17 +22,21 @@
 
 typedef struct {
 	__u8 b[16];
-} uuid_le;
+} guid_t;
 
-#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
-((uuid_le)								\
+#define GUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
+((guid_t)								\
 {{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
    (b) & 0xff, ((b) >> 8) & 0xff,					\
    (c) & 0xff, ((c) >> 8) & 0xff,					\
    (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
 
+/* backwards compatibility, don't use in new code */
+typedef guid_t uuid_le;
+#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
+	GUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
 #define NULL_UUID_LE							\
 	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
-		0x00, 0x00, 0x00, 0x00)
+	     0x00, 0x00, 0x00, 0x00)
 
 #endif /* _UAPI_LINUX_UUID_H_ */
diff --git a/lib/test_uuid.c b/lib/test_uuid.c
index 547d3127a3cf..9cad846fd805 100644
--- a/lib/test_uuid.c
+++ b/lib/test_uuid.c
@@ -11,25 +11,25 @@
 
 struct test_uuid_data {
 	const char *uuid;
-	uuid_le le;
-	uuid_be be;
+	guid_t le;
+	uuid_t be;
 };
 
 static const struct test_uuid_data test_uuid_test_data[] = {
 	{
 		.uuid = "c33f4995-3701-450e-9fbf-206a2e98e576",
-		.le = UUID_LE(0xc33f4995, 0x3701, 0x450e, 0x9f, 0xbf, 0x20, 0x6a, 0x2e, 0x98, 0xe5, 0x76),
-		.be = UUID_BE(0xc33f4995, 0x3701, 0x450e, 0x9f, 0xbf, 0x20, 0x6a, 0x2e, 0x98, 0xe5, 0x76),
+		.le = GUID(0xc33f4995, 0x3701, 0x450e, 0x9f, 0xbf, 0x20, 0x6a, 0x2e, 0x98, 0xe5, 0x76),
+		.be = UUID(0xc33f4995, 0x3701, 0x450e, 0x9f, 0xbf, 0x20, 0x6a, 0x2e, 0x98, 0xe5, 0x76),
 	},
 	{
 		.uuid = "64b4371c-77c1-48f9-8221-29f054fc023b",
-		.le = UUID_LE(0x64b4371c, 0x77c1, 0x48f9, 0x82, 0x21, 0x29, 0xf0, 0x54, 0xfc, 0x02, 0x3b),
-		.be = UUID_BE(0x64b4371c, 0x77c1, 0x48f9, 0x82, 0x21, 0x29, 0xf0, 0x54, 0xfc, 0x02, 0x3b),
+		.le = GUID(0x64b4371c, 0x77c1, 0x48f9, 0x82, 0x21, 0x29, 0xf0, 0x54, 0xfc, 0x02, 0x3b),
+		.be = UUID(0x64b4371c, 0x77c1, 0x48f9, 0x82, 0x21, 0x29, 0xf0, 0x54, 0xfc, 0x02, 0x3b),
 	},
 	{
 		.uuid = "0cb4ddff-a545-4401-9d06-688af53e7f84",
-		.le = UUID_LE(0x0cb4ddff, 0xa545, 0x4401, 0x9d, 0x06, 0x68, 0x8a, 0xf5, 0x3e, 0x7f, 0x84),
-		.be = UUID_BE(0x0cb4ddff, 0xa545, 0x4401, 0x9d, 0x06, 0x68, 0x8a, 0xf5, 0x3e, 0x7f, 0x84),
+		.le = GUID(0x0cb4ddff, 0xa545, 0x4401, 0x9d, 0x06, 0x68, 0x8a, 0xf5, 0x3e, 0x7f, 0x84),
+		.be = UUID(0x0cb4ddff, 0xa545, 0x4401, 0x9d, 0x06, 0x68, 0x8a, 0xf5, 0x3e, 0x7f, 0x84),
 	},
 };
 
@@ -61,13 +61,13 @@ static void __init test_uuid_failed(const char *prefix, bool wrong, bool be,
 
 static void __init test_uuid_test(const struct test_uuid_data *data)
 {
-	uuid_le le;
-	uuid_be be;
+	guid_t le;
+	uuid_t be;
 	char buf[48];
 
 	/* LE */
 	total_tests++;
-	if (uuid_le_to_bin(data->uuid, &le))
+	if (guid_to_bin(data->uuid, &le))
 		test_uuid_failed("conversion", false, false, data->uuid, NULL);
 
 	total_tests++;
@@ -78,7 +78,7 @@ static void __init test_uuid_test(const struct test_uuid_data *data)
 
 	/* BE */
 	total_tests++;
-	if (uuid_be_to_bin(data->uuid, &be))
+	if (uuid_to_bin(data->uuid, &be))
 		test_uuid_failed("conversion", false, true, data->uuid, NULL);
 
 	total_tests++;
@@ -90,17 +90,17 @@ static void __init test_uuid_test(const struct test_uuid_data *data)
 
 static void __init test_uuid_wrong(const char *data)
 {
-	uuid_le le;
-	uuid_be be;
+	guid_t le;
+	uuid_t be;
 
 	/* LE */
 	total_tests++;
-	if (!uuid_le_to_bin(data, &le))
+	if (!guid_to_bin(data, &le))
 		test_uuid_failed("negative", true, false, data, NULL);
 
 	/* BE */
 	total_tests++;
-	if (!uuid_be_to_bin(data, &be))
+	if (!uuid_to_bin(data, &be))
 		test_uuid_failed("negative", true, true, data, NULL);
 }
 
diff --git a/lib/uuid.c b/lib/uuid.c
index 37687af77ff8..f80dc63f6ca8 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -21,10 +21,10 @@
 #include <linux/uuid.h>
 #include <linux/random.h>
 
-const u8 uuid_le_index[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
-EXPORT_SYMBOL(uuid_le_index);
-const u8 uuid_be_index[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
-EXPORT_SYMBOL(uuid_be_index);
+const u8 guid_index[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
+EXPORT_SYMBOL(guid_index);
+const u8 uuid_index[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
+EXPORT_SYMBOL(uuid_index);
 
 /***************************************************************
  * Random UUID interface
@@ -53,21 +53,21 @@ static void __uuid_gen_common(__u8 b[16])
 	b[8] = (b[8] & 0x3F) | 0x80;
 }
 
-void uuid_le_gen(uuid_le *lu)
+void guid_gen(guid_t *lu)
 {
 	__uuid_gen_common(lu->b);
 	/* version 4 : random generation */
 	lu->b[7] = (lu->b[7] & 0x0F) | 0x40;
 }
-EXPORT_SYMBOL_GPL(uuid_le_gen);
+EXPORT_SYMBOL_GPL(guid_gen);
 
-void uuid_be_gen(uuid_be *bu)
+void uuid_gen(uuid_t *bu)
 {
 	__uuid_gen_common(bu->b);
 	/* version 4 : random generation */
 	bu->b[6] = (bu->b[6] & 0x0F) | 0x40;
 }
-EXPORT_SYMBOL_GPL(uuid_be_gen);
+EXPORT_SYMBOL_GPL(uuid_gen);
 
 /**
   * uuid_is_valid - checks if UUID string valid
@@ -115,14 +115,14 @@ static int __uuid_to_bin(const char *uuid, __u8 b[16], const u8 ei[16])
 	return 0;
 }
 
-int uuid_le_to_bin(const char *uuid, uuid_le *u)
+int guid_to_bin(const char *uuid, guid_t *u)
 {
-	return __uuid_to_bin(uuid, u->b, uuid_le_index);
+	return __uuid_to_bin(uuid, u->b, guid_index);
 }
-EXPORT_SYMBOL(uuid_le_to_bin);
+EXPORT_SYMBOL(guid_to_bin);
 
-int uuid_be_to_bin(const char *uuid, uuid_be *u)
+int uuid_to_bin(const char *uuid, uuid_t *u)
 {
-	return __uuid_to_bin(uuid, u->b, uuid_be_index);
+	return __uuid_to_bin(uuid, u->b, uuid_index);
 }
-EXPORT_SYMBOL(uuid_be_to_bin);
+EXPORT_SYMBOL(uuid_to_bin);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 2d41de3f98a1..9f37d6208e99 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1308,14 +1308,14 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 	char uuid[UUID_STRING_LEN + 1];
 	char *p = uuid;
 	int i;
-	const u8 *index = uuid_be_index;
+	const u8 *index = uuid_index;
 	bool uc = false;
 
 	switch (*(++fmt)) {
 	case 'L':
 		uc = true;		/* fall-through */
 	case 'l':
-		index = uuid_le_index;
+		index = guid_index;
 		break;
 	case 'B':
 		uc = true;
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
