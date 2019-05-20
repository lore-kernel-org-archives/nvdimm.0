Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com
 [IPv6:2a00:1450:4864:20::441])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23881212604ED
 for <linux-nvdimm@lists.01.org>; Mon, 20 May 2019 07:41:46 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id w8so14932389wrl.6
 for <linux-nvdimm@lists.01.org>; Mon, 20 May 2019 07:41:46 -0700 (PDT)
Date: Mon, 20 May 2019 16:41:37 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 02/30] fuse: Clear setuid bit even in cache=never path
Message-ID: <20190520144137.GA24093@localhost.localdomain>
References: <20190515192715.18000-1-vgoyal@redhat.com>
 <20190515192715.18000-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190515192715.18000-3-vgoyal@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kvm@vger.kernel.org, linux-nvdimm@lists.01.org, dgilbert@redhat.com, linux-kernel@vger.kernel.org, stefanha@redhat.com, linux-fsdevel@vger.kernel.org, swhiteho@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 15, 2019 at 03:26:47PM -0400, Vivek Goyal wrote:
> If fuse daemon is started with cache=never, fuse falls back to direct IO.
> In that write path we don't call file_remove_privs() and that means setuid
> bit is not cleared if unpriviliged user writes to a file with setuid bit set.
> 
> pjdfstest chmod test 12.t tests this and fails.

I think better sulution is to tell the server if the suid bit needs to be
removed, so it can do so in a race free way.

Here's the kernel patch, and I'll reply with the libfuse patch.

---
 fs/fuse2/file.c           |    2 ++
 include/uapi/linux/fuse.h |    3 +++
 2 files changed, 5 insertions(+)

--- a/fs/fuse2/file.c
+++ b/fs/fuse2/file.c
@@ -363,6 +363,8 @@ static ssize_t fuse_send_write(struct fu
 		inarg->flags |= O_DSYNC;
 	if (iocb->ki_flags & IOCB_SYNC)
 		inarg->flags |= O_SYNC;
+	if (!capable(CAP_FSETID))
+		inarg->write_flags |= FUSE_WRITE_KILL_PRIV;
 	req->inh.opcode = FUSE_WRITE;
 	req->inh.nodeid = ff->nodeid;
 	req->inh.len = req->inline_inlen + count;
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -125,6 +125,7 @@
  *
  *  7.29
  *  - add FUSE_NO_OPENDIR_SUPPORT flag
+ *  - add FUSE_WRITE_KILL_PRIV flag
  */
 
 #ifndef _LINUX_FUSE_H
@@ -318,9 +319,11 @@ struct fuse_file_lock {
  *
  * FUSE_WRITE_CACHE: delayed write from page cache, file handle is guessed
  * FUSE_WRITE_LOCKOWNER: lock_owner field is valid
+ * FUSE_WRITE_KILL_PRIV: kill suid and sgid bits
  */
 #define FUSE_WRITE_CACHE	(1 << 0)
 #define FUSE_WRITE_LOCKOWNER	(1 << 1)
+#define FUSE_WRITE_KILL_PRIV	(1 << 2)
 
 /**
  * Read flags


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
