Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E039821A16EFB
 for <linux-nvdimm@lists.01.org>; Wed, 17 May 2017 23:27:52 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/23] afs: switch to use uuid_t and uuid_gen
Date: Thu, 18 May 2017 08:26:52 +0200
Message-Id: <20170518062705.25902-11-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Howells <dhowells@redhat.com>
---
 fs/afs/cmservice.c | 46 +++++++++++++++++++++++-----------------------
 fs/afs/internal.h  |  2 +-
 fs/afs/main.c      |  4 ++--
 3 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index 3062cceb5c2a..d4e77d12570c 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -350,7 +350,7 @@ static int afs_deliver_cb_init_call_back_state3(struct afs_call *call)
 {
 	struct sockaddr_rxrpc srx;
 	struct afs_server *server;
-	struct uuid_v1 *r;
+	uuid_t *r;
 	unsigned loop;
 	__be32 *b;
 	int ret;
@@ -380,20 +380,20 @@ static int afs_deliver_cb_init_call_back_state3(struct afs_call *call)
 		}
 
 		_debug("unmarshall UUID");
-		call->request = kmalloc(sizeof(struct uuid_v1), GFP_KERNEL);
+		call->request = kmalloc(sizeof(uuid_t), GFP_KERNEL);
 		if (!call->request)
 			return -ENOMEM;
 
 		b = call->buffer;
 		r = call->request;
-		r->time_low			= b[0];
-		r->time_mid			= htons(ntohl(b[1]));
-		r->time_hi_and_version		= htons(ntohl(b[2]));
-		r->clock_seq_hi_and_reserved 	= ntohl(b[3]);
-		r->clock_seq_low		= ntohl(b[4]);
+		r->v1.time_low			= b[0];
+		r->v1.time_mid			= htons(ntohl(b[1]));
+		r->v1.time_hi_and_version	= htons(ntohl(b[2]));
+		r->v1.clock_seq_hi_and_reserved = ntohl(b[3]);
+		r->v1.clock_seq_low		= ntohl(b[4]);
 
 		for (loop = 0; loop < 6; loop++)
-			r->node[loop] = ntohl(b[loop + 5]);
+			r->v1.node[loop] = ntohl(b[loop + 5]);
 
 		call->offset = 0;
 		call->unmarshall++;
@@ -453,7 +453,7 @@ static int afs_deliver_cb_probe(struct afs_call *call)
 static void SRXAFSCB_ProbeUuid(struct work_struct *work)
 {
 	struct afs_call *call = container_of(work, struct afs_call, work);
-	struct uuid_v1 *r = call->request;
+	uuid_t *r = call->request;
 
 	struct {
 		__be32	match;
@@ -476,7 +476,7 @@ static void SRXAFSCB_ProbeUuid(struct work_struct *work)
  */
 static int afs_deliver_cb_probe_uuid(struct afs_call *call)
 {
-	struct uuid_v1 *r;
+	uuid_t *r;
 	unsigned loop;
 	__be32 *b;
 	int ret;
@@ -502,20 +502,20 @@ static int afs_deliver_cb_probe_uuid(struct afs_call *call)
 		}
 
 		_debug("unmarshall UUID");
-		call->request = kmalloc(sizeof(struct uuid_v1), GFP_KERNEL);
+		call->request = kmalloc(sizeof(uuid_t), GFP_KERNEL);
 		if (!call->request)
 			return -ENOMEM;
 
 		b = call->buffer;
 		r = call->request;
-		r->time_low			= b[0];
-		r->time_mid			= htons(ntohl(b[1]));
-		r->time_hi_and_version		= htons(ntohl(b[2]));
-		r->clock_seq_hi_and_reserved 	= ntohl(b[3]);
-		r->clock_seq_low		= ntohl(b[4]);
+		r->v1.time_low			= b[0];
+		r->v1.time_mid			= htons(ntohl(b[1]));
+		r->v1.time_hi_and_version	= htons(ntohl(b[2]));
+		r->v1.clock_seq_hi_and_reserved = ntohl(b[3]);
+		r->v1.clock_seq_low		= ntohl(b[4]);
 
 		for (loop = 0; loop < 6; loop++)
-			r->node[loop] = ntohl(b[loop + 5]);
+			r->v1.node[loop] = ntohl(b[loop + 5]);
 
 		call->offset = 0;
 		call->unmarshall++;
@@ -568,13 +568,13 @@ static void SRXAFSCB_TellMeAboutYourself(struct work_struct *work)
 	memset(&reply, 0, sizeof(reply));
 	reply.ia.nifs = htonl(nifs);
 
-	reply.ia.uuid[0] = afs_uuid.time_low;
-	reply.ia.uuid[1] = htonl(ntohs(afs_uuid.time_mid));
-	reply.ia.uuid[2] = htonl(ntohs(afs_uuid.time_hi_and_version));
-	reply.ia.uuid[3] = htonl((s8) afs_uuid.clock_seq_hi_and_reserved);
-	reply.ia.uuid[4] = htonl((s8) afs_uuid.clock_seq_low);
+	reply.ia.uuid[0] = afs_uuid.v1.time_low;
+	reply.ia.uuid[1] = htonl(ntohs(afs_uuid.v1.time_mid));
+	reply.ia.uuid[2] = htonl(ntohs(afs_uuid.v1.time_hi_and_version));
+	reply.ia.uuid[3] = htonl((s8) afs_uuid.v1.clock_seq_hi_and_reserved);
+	reply.ia.uuid[4] = htonl((s8) afs_uuid.v1.clock_seq_low);
 	for (loop = 0; loop < 6; loop++)
-		reply.ia.uuid[loop + 5] = htonl((s8) afs_uuid.node[loop]);
+		reply.ia.uuid[loop + 5] = htonl((s8) afs_uuid.v1.node[loop]);
 
 	if (ifs) {
 		for (loop = 0; loop < nifs; loop++) {
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 393672997cc2..7de45c8686a2 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -544,7 +544,7 @@ extern int afs_drop_inode(struct inode *);
  * main.c
  */
 extern struct workqueue_struct *afs_wq;
-extern struct uuid_v1 afs_uuid;
+extern uuid_t afs_uuid;
 
 /*
  * misc.c
diff --git a/fs/afs/main.c b/fs/afs/main.c
index 51d7d17bca57..75b3d3a8b1ba 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -31,7 +31,7 @@ static char *rootcell;
 module_param(rootcell, charp, 0);
 MODULE_PARM_DESC(rootcell, "root AFS cell name and VL server IP addr list");
 
-struct uuid_v1 afs_uuid;
+uuid_t afs_uuid;
 struct workqueue_struct *afs_wq;
 
 /*
@@ -43,7 +43,7 @@ static int __init afs_init(void)
 
 	printk(KERN_INFO "kAFS: Red Hat AFS client v0.1 registering.\n");
 
-	generate_random_uuid((unsigned char *)&afs_uuid);
+	uuid_gen(&afs_uuid);
 
 	/* create workqueue */
 	ret = -ENOMEM;
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
