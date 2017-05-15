Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E238B21A0BAB0
 for <linux-nvdimm@lists.01.org>; Mon, 15 May 2017 08:43:29 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/17] uuid: hoist helpers uuid_equal() and uuid_copy() from
 xfs
Date: Mon, 15 May 2017 17:42:57 +0200
Message-Id: <20170515154308.26739-7-hch@lst.de>
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

These helper are used to compare and copy two uuid_t type objects.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[hch: also provide the respective guid_ versions]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/uuid.c        |  6 ------
 fs/xfs/uuid.h        |  7 -------
 include/linux/uuid.h | 20 ++++++++++++++++++++
 lib/test_uuid.c      |  4 ++--
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
index b83f76b6d410..29ed78c8637b 100644
--- a/fs/xfs/uuid.c
+++ b/fs/xfs/uuid.c
@@ -55,9 +55,3 @@ uuid_is_nil(uuid_t *uuid)
 		if (*cp++) return 0;	/* not nil */
 	return 1;	/* is nil */
 }
-
-int
-uuid_equal(uuid_t *uuid1, uuid_t *uuid2)
-{
-	return memcmp(uuid1, uuid2, sizeof(uuid_t)) ? 0 : 1;
-}
diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
index 4f1441ba4fa5..86bbed071e79 100644
--- a/fs/xfs/uuid.h
+++ b/fs/xfs/uuid.h
@@ -19,13 +19,6 @@
 #define __XFS_SUPPORT_UUID_H__
 
 extern int uuid_is_nil(uuid_t *uuid);
-extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
 extern void uuid_getnodeuniq(uuid_t *uuid, int fsid [2]);
 
-static inline void
-uuid_copy(uuid_t *dst, uuid_t *src)
-{
-	memcpy(dst, src, sizeof(uuid_t));
-}
-
 #endif	/* __XFS_SUPPORT_UUID_H__ */
diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index a0c32f364b09..aef21b580b17 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -48,6 +48,26 @@ struct uuid_v1 {
  */
 #define	UUID_STRING_LEN		36
 
+static inline bool guid_equal(const guid_t *u1, const guid_t *u2)
+{
+	return memcmp(u1, u2, sizeof(guid_t)) == 0;
+}
+
+static inline void guid_copy(guid_t *dst, const guid_t *src)
+{
+	memcpy(dst, src, sizeof(guid_t));
+}
+
+static inline bool uuid_equal(const uuid_t *u1, const uuid_t *u2)
+{
+	return memcmp(u1, u2, sizeof(uuid_t)) == 0;
+}
+
+static inline void uuid_copy(uuid_t *dst, const uuid_t *src)
+{
+	memcpy(dst, src, sizeof(uuid_t));
+}
+
 void generate_random_uuid(unsigned char uuid[16]);
 
 extern void guid_gen(guid_t *u);
diff --git a/lib/test_uuid.c b/lib/test_uuid.c
index 9cad846fd805..4d05189e5f87 100644
--- a/lib/test_uuid.c
+++ b/lib/test_uuid.c
@@ -71,7 +71,7 @@ static void __init test_uuid_test(const struct test_uuid_data *data)
 		test_uuid_failed("conversion", false, false, data->uuid, NULL);
 
 	total_tests++;
-	if (uuid_le_cmp(data->le, le)) {
+	if (!guid_equal(&data->le, &le)) {
 		sprintf(buf, "%pUl", &le);
 		test_uuid_failed("cmp", false, false, data->uuid, buf);
 	}
@@ -82,7 +82,7 @@ static void __init test_uuid_test(const struct test_uuid_data *data)
 		test_uuid_failed("conversion", false, true, data->uuid, NULL);
 
 	total_tests++;
-	if (uuid_be_cmp(data->be, be)) {
+	if (uuid_equal(&data->be, &be)) {
 		sprintf(buf, "%pUb", &be);
 		test_uuid_failed("cmp", false, true, data->uuid, buf);
 	}
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
