Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7CC6B2125ADFF
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 12:27:32 -0700 (PDT)
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v2 03/30] fuse: Use default_file_splice_read for direct IO
Date: Wed, 15 May 2019 15:26:48 -0400
Message-Id: <20190515192715.18000-4-vgoyal@redhat.com>
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

From: Miklos Szeredi <mszeredi@redhat.com>

---
 fs/fuse/file.c     | 15 ++++++++++++++-
 fs/splice.c        |  3 ++-
 include/linux/fs.h |  2 ++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 5baf07fd2876..e9a7aa97c539 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2167,6 +2167,19 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+static ssize_t fuse_file_splice_read(struct file *in, loff_t *ppos,
+				     struct pipe_inode_info *pipe, size_t len,
+				     unsigned int flags)
+{
+	struct fuse_file *ff = in->private_data;
+
+	if (ff->open_flags & FOPEN_DIRECT_IO)
+		return default_file_splice_read(in, ppos, pipe, len, flags);
+	else
+		return generic_file_splice_read(in, ppos, pipe, len, flags);
+
+}
+
 static int convert_fuse_file_lock(struct fuse_conn *fc,
 				  const struct fuse_file_lock *ffl,
 				  struct file_lock *fl)
@@ -3174,7 +3187,7 @@ static const struct file_operations fuse_file_operations = {
 	.fsync		= fuse_fsync,
 	.lock		= fuse_file_lock,
 	.flock		= fuse_file_flock,
-	.splice_read	= generic_file_splice_read,
+	.splice_read	= fuse_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.unlocked_ioctl	= fuse_file_ioctl,
 	.compat_ioctl	= fuse_file_compat_ioctl,
diff --git a/fs/splice.c b/fs/splice.c
index 25212dcca2df..e2e881e34935 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -361,7 +361,7 @@ static ssize_t kernel_readv(struct file *file, const struct kvec *vec,
 	return res;
 }
 
-static ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
+ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 				 struct pipe_inode_info *pipe, size_t len,
 				 unsigned int flags)
 {
@@ -425,6 +425,7 @@ static ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 	iov_iter_advance(&to, copied);	/* truncates and discards */
 	return res;
 }
+EXPORT_SYMBOL(default_file_splice_read);
 
 /*
  * Send 'sd->len' bytes to socket from 'sd->file' at position 'sd->pos'
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dd28e7679089..6804aecf7e30 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3055,6 +3055,8 @@ extern void block_sync_page(struct page *page);
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
+extern ssize_t default_file_splice_read(struct file *, loff_t *,
+		struct pipe_inode_info *, size_t, unsigned int);
 extern ssize_t iter_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
 extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
