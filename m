Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00EE821D4919A
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 12:27:35 -0700 (PDT)
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v2 07/30] fuse: export fuse_get_unique()
Date: Wed, 15 May 2019 15:26:52 -0400
Message-Id: <20190515192715.18000-8-vgoyal@redhat.com>
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

From: Stefan Hajnoczi <stefanha@redhat.com>

virtio-fs will need unique IDs for FORGET requests from outside
fs/fuse/dev.c.  Make the symbol visible.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 fs/fuse/dev.c    | 3 ++-
 fs/fuse/fuse_i.h | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 40eb827caa10..42fd3b576686 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -363,11 +363,12 @@ unsigned fuse_len_args(unsigned numargs, struct fuse_arg *args)
 }
 EXPORT_SYMBOL_GPL(fuse_len_args);
 
-static u64 fuse_get_unique(struct fuse_iqueue *fiq)
+u64 fuse_get_unique(struct fuse_iqueue *fiq)
 {
 	fiq->reqctr += FUSE_REQ_ID_STEP;
 	return fiq->reqctr;
 }
+EXPORT_SYMBOL_GPL(fuse_get_unique);
 
 static unsigned int fuse_req_hash(u64 unique)
 {
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 16f238d7f624..38a572ba650d 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1097,4 +1097,9 @@ int fuse_readdir(struct file *file, struct dir_context *ctx);
  */
 unsigned fuse_len_args(unsigned numargs, struct fuse_arg *args);
 
+/**
+ * Get the next unique ID for a request
+ */
+u64 fuse_get_unique(struct fuse_iqueue *fiq);
+
 #endif /* _FS_FUSE_I_H */
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
