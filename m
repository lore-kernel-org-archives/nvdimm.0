Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0BDF221959D28
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 11:02:33 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/16] uuid: rename uuid types
Date: Wed, 10 May 2017 20:02:01 +0200
Message-Id: <20170510180214.16852-4-hch@lst.de>
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

Our "little endian" UUID really is a Wintel GUID, so rename it and its
helpers such (guid_t).  The big endian UUID is the only true one, so
give it the name uuid_t.  The uuid_le and uuid_be names are retained for,
but will hopefully go away soon.

Also remove the existing typedef in XFS that's now been superceeded by
the generic type name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[andy: also updated the UUID_LE/UUID_BE macros including fallout]
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 fs/jfs/jfs_logmgr.h       |  4 ++--
 fs/xfs/xfs_linux.h        |  2 --
 include/linux/efi.h       |  3 +--
 include/linux/uuid.h      | 28 ++++++++++++++++++----------
 include/uapi/linux/uuid.h | 27 +++++++++++++++------------
 lib/test_uuid.c           | 12 ++++++------
 lib/uuid.c                | 28 ++++++++++++++--------------
 lib/vsprintf.c            |  4 ++--
 8 files changed, 58 insertions(+), 50 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.h b/fs/jfs/jfs_logmgr.h
index e38c21598850..0b9efddeb9f5 100644
--- a/fs/jfs/jfs_logmgr.h
+++ b/fs/jfs/jfs_logmgr.h
@@ -19,6 +19,8 @@
 #ifndef	_H_JFS_LOGMGR
 #define _H_JFS_LOGMGR
 
+#include <linux/uuid.h>
+
 #include "jfs_filsys.h"
 #include "jfs_lock.h"
 
@@ -80,8 +82,6 @@ struct logsuper {
 	} active[MAX_ACTIVE];	/* 2048: active file systems list */
 };
 
-#define NULL_UUID "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
-
 /* log flag: commit option (see jfs_filsys.h) */
 
 /* log state */
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
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ec36f42a2add..cbd4d00e62c5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -50,7 +50,7 @@ typedef void *efi_handle_t;
 typedef uuid_le efi_guid_t;
 
 #define EFI_GUID(a,b,c,d0,d1,d2,d3,d4,d5,d6,d7) \
-	UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
+	GUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
 
 /*
  * Generic EFI table header
@@ -584,7 +584,6 @@ void efi_native_runtime_setup(void);
  * Note that the 'extra space' separates the values at the same place
  * where the UEFI SPEC breaks the line.
  */
-#define NULL_GUID				EFI_GUID(0x00000000, 0x0000, 0x0000,  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
 #define MPS_TABLE_GUID				EFI_GUID(0xeb9d2d2f, 0x2d88, 0x11d3,  0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
 #define ACPI_TABLE_GUID				EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3,  0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
 #define ACPI_20_TABLE_GUID			EFI_GUID(0x8868e871, 0xe4f1, 0x11d3,  0xbc, 0x22, 0x00, 0x80, 0xc7, 0x3c, 0x88, 0x81)
diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 4dff73a89758..af669f317780 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -48,27 +48,35 @@ struct uuid_v1 {
  */
 #define	UUID_STRING_LEN		36
 
-static inline int uuid_le_cmp(const uuid_le u1, const uuid_le u2)
+static inline int guid_cmp(const guid_t u1, const guid_t u2)
 {
-	return memcmp(&u1, &u2, sizeof(uuid_le));
+	return memcmp(&u1, &u2, sizeof(guid_t));
 }
 
-static inline int uuid_be_cmp(const uuid_be u1, const uuid_be u2)
+static inline int uuid_cmp(const uuid_t u1, const uuid_t u2)
 {
-	return memcmp(&u1, &u2, sizeof(uuid_be));
+	return memcmp(&u1, &u2, sizeof(uuid_t));
 }
 
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
 
-int uuid_le_to_bin(const char *uuid, uuid_le *u);
-int uuid_be_to_bin(const char *uuid, uuid_be *u);
+int guid_to_bin(const char *uuid, guid_t *u);
+int uuid_to_bin(const char *uuid, uuid_t *u);
+
+/* backwards compatibility, don't use in new code */
+#define uuid_le_cmp(u1, u2)	guid_cmp(u1, u2)
+#define uuid_be_cmp(u1, u2)	uuid_cmp(u1, u2)
+#define uuid_le_gen(u)		guid_gen(u)
+#define uuid_be_gen(u)		uuid_gen(u)
+#define uuid_le_to_bin(guid, u)	guid_to_bin(guid, u)
+#define uuid_be_to_bin(uuid, u)	uuid_to_bin(uuid, u)
 
 #endif
diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
index 3738e5fb6a4d..1a2914d8b225 100644
--- a/include/uapi/linux/uuid.h
+++ b/include/uapi/linux/uuid.h
@@ -22,33 +22,36 @@
 
 typedef struct {
 	__u8 b[16];
-} uuid_le;
+} guid_t;
 
 typedef struct {
 	__u8 b[16];
-} uuid_be;
+} uuid_t;
 
-#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
-((uuid_le)								\
+#define GUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
+((guid_t)								\
 {{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
    (b) & 0xff, ((b) >> 8) & 0xff,					\
    (c) & 0xff, ((c) >> 8) & 0xff,					\
    (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
 
-#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
-((uuid_be)								\
+#define UUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
+((uuid_t)								\
 {{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
    ((b) >> 8) & 0xff, (b) & 0xff,					\
    ((c) >> 8) & 0xff, (c) & 0xff,					\
    (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
 
-#define NULL_UUID_LE							\
-	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
-		0x00, 0x00, 0x00, 0x00)
+#define NULL_GUID							\
+	GUID(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+	     0x00, 0x00, 0x00, 0x00)
 
-#define NULL_UUID_BE							\
-	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
-		0x00, 0x00, 0x00, 0x00)
+#define NULL_UUID							\
+	UUID(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+	     0x00, 0x00, 0x00, 0x00)
 
+/* backwards compatibility, don't use in new code */
+typedef guid_t uuid_le;
+typedef uuid_t uuid_be;
 
 #endif /* _UAPI_LINUX_UUID_H_ */
diff --git a/lib/test_uuid.c b/lib/test_uuid.c
index 547d3127a3cf..7e05c1565dcc 100644
--- a/lib/test_uuid.c
+++ b/lib/test_uuid.c
@@ -18,18 +18,18 @@ struct test_uuid_data {
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
