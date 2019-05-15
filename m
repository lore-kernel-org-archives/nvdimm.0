Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B468B212657B5
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 12:27:33 -0700 (PDT)
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v2 06/30] fuse: Export fuse_send_init_request()
Date: Wed, 15 May 2019 15:26:51 -0400
Message-Id: <20190515192715.18000-7-vgoyal@redhat.com>
In-Reply-To: <20190515192715.18000-1-vgoyal@redhat.com>
References: <20190515192715.18000-1-vgoyal@redhat.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: swhiteho@redhat.com, dgilbert@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
List-ID: <linux-nvdimm@lists.01.org>

This will be used by virtio-fs to send init request to fuse server after
initialization of virt queues.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/dev.c    | 1 +
 fs/fuse/fuse_i.h | 1 +
 fs/fuse/inode.c  | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index d8054b1a45f5..40eb827caa10 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -139,6 +139,7 @@ void fuse_request_free(struct fuse_req *req)
 	fuse_req_pages_free(req);
 	kmem_cache_free(fuse_req_cachep, req);
 }
+EXPORT_SYMBOL_GPL(fuse_request_free);
 
 void __fuse_get_request(struct fuse_req *req)
 {
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 3a235386d667..16f238d7f624 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -987,6 +987,7 @@ void fuse_conn_put(struct fuse_conn *fc);
 
 struct fuse_dev *fuse_dev_alloc(struct fuse_conn *fc);
 void fuse_dev_free(struct fuse_dev *fud);
+void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req);
 
 /**
  * Add connection to control filesystem
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index ec5d9953dfb6..f02291469518 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -958,7 +958,7 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 	wake_up_all(&fc->blocked_waitq);
 }
 
-static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
+void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 {
 	struct fuse_init_in *arg = &req->misc.init_in;
 
@@ -988,6 +988,7 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 	req->end = process_init_reply;
 	fuse_request_send_background(fc, req);
 }
+EXPORT_SYMBOL_GPL(fuse_send_init);
 
 static void fuse_free_conn(struct fuse_conn *fc)
 {
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
