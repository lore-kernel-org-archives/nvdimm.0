Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ACEA021D49196
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 12:27:34 -0700 (PDT)
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v2 28/30] fuse: Reschedule dax free work if too many EAGAIN
 attempts
Date: Wed, 15 May 2019 15:27:13 -0400
Message-Id: <20190515192715.18000-29-vgoyal@redhat.com>
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

fuse_dax_free_memory() can be very cpu intensive in corner cases. For example,
if one inode has consumed all the memory and a setupmapping request is
pending, that means inode lock is held by request and worker thread will
not get lock for a while. And given there is only one inode consuming all
the dax ranges, all the attempts to acquire lock will fail.

So if there are too many inode lock failures (-EAGAIN), reschedule the
worker with a 10ms delay.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index b0293a308b5e..9b82d9b4ebc3 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -4047,7 +4047,7 @@ int fuse_dax_free_one_mapping(struct fuse_conn *fc, struct inode *inode,
 int fuse_dax_free_memory(struct fuse_conn *fc, unsigned long nr_to_free)
 {
 	struct fuse_dax_mapping *dmap, *pos, *temp;
-	int ret, nr_freed = 0;
+	int ret, nr_freed = 0, nr_eagain = 0;
 	u64 dmap_start = 0, window_offset = 0;
 	struct inode *inode = NULL;
 
@@ -4056,6 +4056,12 @@ int fuse_dax_free_memory(struct fuse_conn *fc, unsigned long nr_to_free)
 		if (nr_freed >= nr_to_free)
 			break;
 
+		if (nr_eagain > 20) {
+			queue_delayed_work(system_long_wq, &fc->dax_free_work,
+						msecs_to_jiffies(10));
+			return 0;
+		}
+
 		dmap = NULL;
 		spin_lock(&fc->lock);
 
@@ -4093,8 +4099,10 @@ int fuse_dax_free_memory(struct fuse_conn *fc, unsigned long nr_to_free)
 		}
 
 		/* Could not get inode lock. Try next element */
-		if (ret == -EAGAIN)
+		if (ret == -EAGAIN) {
+			nr_eagain++;
 			continue;
+		}
 		nr_freed++;
 	}
 	return 0;
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
