Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3955021AF39BA
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 09:17:43 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/24] uuid,afs: move struct uuid_v1 back into afs
Date: Wed, 31 May 2017 18:18:03 +0200
Message-Id: <20170531161826.23243-2-hch@lst.de>
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

This essentially is a partial revert of commit ff548773
("afs: Move UUID struct to linux/uuid.h") and moves struct uuid_v1 back into
fs/afs as struct afs_uuid.  It however keeps it as big endian structure
so that we can use the normal uuid generation helpers when casting to/from
struct afs_uuid.

The V1 uuid intrepreatation in struct form isn't really useful to the
rest of the kernel, and not really compatible to it either, so move it
back to AFS instead of polluting the global uuid.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/afs/cmservice.c   | 16 ++++++++--------
 fs/afs/internal.h    | 11 ++++++++++-
 fs/afs/main.c        |  2 +-
 include/linux/uuid.h | 24 ------------------------
 4 files changed, 19 insertions(+), 34 deletions(-)

diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index 3062cceb5c2a..782d4d05a53b 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -350,7 +350,7 @@ static int afs_deliver_cb_init_call_back_state3(struct afs_call *call)
 {
 	struct sockaddr_rxrpc srx;
 	struct afs_server *server;
-	struct uuid_v1 *r;
+	struct afs_uuid *r;
 	unsigned loop;
 	__be32 *b;
 	int ret;
@@ -380,7 +380,7 @@ static int afs_deliver_cb_init_call_back_state3(struct afs_call *call)
 		}
 
 		_debug("unmarshall UUID");
-		call->request = kmalloc(sizeof(struct uuid_v1), GFP_KERNEL);
+		call->request = kmalloc(sizeof(struct afs_uuid), GFP_KERNEL);
 		if (!call->request)
 			return -ENOMEM;
 
@@ -453,7 +453,7 @@ static int afs_deliver_cb_probe(struct afs_call *call)
 static void SRXAFSCB_ProbeUuid(struct work_struct *work)
 {
 	struct afs_call *call = container_of(work, struct afs_call, work);
-	struct uuid_v1 *r = call->request;
+	struct afs_uuid *r = call->request;
 
 	struct {
 		__be32	match;
@@ -476,7 +476,7 @@ static void SRXAFSCB_ProbeUuid(struct work_struct *work)
  */
 static int afs_deliver_cb_probe_uuid(struct afs_call *call)
 {
-	struct uuid_v1 *r;
+	struct afs_uuid *r;
 	unsigned loop;
 	__be32 *b;
 	int ret;
@@ -502,15 +502,15 @@ static int afs_deliver_cb_probe_uuid(struct afs_call *call)
 		}
 
 		_debug("unmarshall UUID");
-		call->request = kmalloc(sizeof(struct uuid_v1), GFP_KERNEL);
+		call->request = kmalloc(sizeof(struct afs_uuid), GFP_KERNEL);
 		if (!call->request)
 			return -ENOMEM;
 
 		b = call->buffer;
 		r = call->request;
-		r->time_low			= b[0];
-		r->time_mid			= htons(ntohl(b[1]));
-		r->time_hi_and_version		= htons(ntohl(b[2]));
+		r->time_low			= ntohl(b[0]);
+		r->time_mid			= ntohl(b[1]);
+		r->time_hi_and_version		= ntohl(b[2]);
 		r->clock_seq_hi_and_reserved 	= ntohl(b[3]);
 		r->clock_seq_low		= ntohl(b[4]);
 
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 393672997cc2..4e2556606623 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -410,6 +410,15 @@ struct afs_interface {
 	unsigned	mtu;		/* MTU of interface */
 };
 
+struct afs_uuid {
+	__be32		time_low;			/* low part of timestamp */
+	__be16		time_mid;			/* mid part of timestamp */
+	__be16		time_hi_and_version;		/* high part of timestamp and version  */
+	__u8		clock_seq_hi_and_reserved;	/* clock seq hi and variant */
+	__u8		clock_seq_low;			/* clock seq low */
+	__u8		node[6];			/* spatially unique node ID (MAC addr) */
+};
+
 /*****************************************************************************/
 /*
  * cache.c
@@ -544,7 +553,7 @@ extern int afs_drop_inode(struct inode *);
  * main.c
  */
 extern struct workqueue_struct *afs_wq;
-extern struct uuid_v1 afs_uuid;
+extern struct afs_uuid afs_uuid;
 
 /*
  * misc.c
diff --git a/fs/afs/main.c b/fs/afs/main.c
index 51d7d17bca57..9944770849da 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -31,7 +31,7 @@ static char *rootcell;
 module_param(rootcell, charp, 0);
 MODULE_PARM_DESC(rootcell, "root AFS cell name and VL server IP addr list");
 
-struct uuid_v1 afs_uuid;
+struct afs_uuid afs_uuid;
 struct workqueue_struct *afs_wq;
 
 /*
diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 4dff73a89758..2d095fc60204 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -19,30 +19,6 @@
 #include <uapi/linux/uuid.h>
 
 /*
- * V1 (time-based) UUID definition [RFC 4122].
- * - the timestamp is a 60-bit value, split 32/16/12, and goes in 100ns
- *   increments since midnight 15th October 1582
- *   - add AFS_UUID_TO_UNIX_TIME to convert unix time in 100ns units to UUID
- *     time
- * - the clock sequence is a 14-bit counter to avoid duplicate times
- */
-struct uuid_v1 {
-	__be32		time_low;			/* low part of timestamp */
-	__be16		time_mid;			/* mid part of timestamp */
-	__be16		time_hi_and_version;		/* high part of timestamp and version  */
-#define UUID_TO_UNIX_TIME	0x01b21dd213814000ULL
-#define UUID_TIMEHI_MASK	0x0fff
-#define UUID_VERSION_TIME	0x1000	/* time-based UUID */
-#define UUID_VERSION_NAME	0x3000	/* name-based UUID */
-#define UUID_VERSION_RANDOM	0x4000	/* (pseudo-)random generated UUID */
-	u8		clock_seq_hi_and_reserved;	/* clock seq hi and variant */
-#define UUID_CLOCKHI_MASK	0x3f
-#define UUID_VARIANT_STD	0x80
-	u8		clock_seq_low;			/* clock seq low */
-	u8		node[6];			/* spatially unique node ID (MAC addr) */
-};
-
-/*
  * The length of a UUID string ("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
  * not including trailing NUL.
  */
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
