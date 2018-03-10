Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EF470226462FD
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:14 -0800 (PST)
Received: by mail-pf0-x241.google.com with SMTP id 68so2620092pfx.3
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:33 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 64/83] File operation: open, fsync, flush.
Date: Sat, 10 Mar 2018 10:18:45 -0800
Message-Id: <1520705944-6723-65-git-send-email-jix024@eng.ucsd.edu>
In-Reply-To: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: coughlan@redhat.com, miklos@szeredi.hu, Andiry Xu <jix024@cs.ucsd.edu>, david@fromorbit.com, jack@suse.com, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

From: Andiry Xu <jix024@cs.ucsd.edu>

NOVA persists file metadata and data before returning to the user space.
Hence, fsync is a no-op if the file is not mmaped.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/file.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/fs/nova/file.c b/fs/nova/file.c
index ecaf20a..f60fdf3 100644
--- a/fs/nova/file.c
+++ b/fs/nova/file.c
@@ -66,9 +66,59 @@ static loff_t nova_llseek(struct file *file, loff_t offset, int origin)
 	return offset;
 }
 
+/* This function is called by both msync() and fsync().
+ * TODO: Check if we can avoid calling nova_flush_buffer() for fsync. We use
+ * movnti to write data to files, so we may want to avoid doing unnecessary
+ * nova_flush_buffer() on fsync()
+ */
+static int nova_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	struct address_space *mapping = file->f_mapping;
+	unsigned long start_pgoff, end_pgoff;
+	int ret = 0;
+	timing_t fsync_time;
+
+	NOVA_START_TIMING(fsync_t, fsync_time);
+
+	if (datasync)
+		NOVA_STATS_ADD(fdatasync, 1);
+
+	/* No need to flush if the file is not mmaped */
+	if (!mapping_mapped(mapping))
+		goto persist;
+
+	start_pgoff = start >> PAGE_SHIFT;
+	end_pgoff = (end + 1) >> PAGE_SHIFT;
+	nova_dbgv("%s: msync pgoff range %lu to %lu\n",
+			__func__, start_pgoff, end_pgoff);
+
+	ret = generic_file_fsync(file, start, end, datasync);
+
+persist:
+	PERSISTENT_BARRIER();
+	NOVA_END_TIMING(fsync_t, fsync_time);
+
+	return ret;
+}
+
+/* This callback is called when a file is closed */
+static int nova_flush(struct file *file, fl_owner_t id)
+{
+	PERSISTENT_BARRIER();
+	return 0;
+}
+
+static int nova_open(struct inode *inode, struct file *filp)
+{
+	return generic_file_open(inode, filp);
+}
+
 
 const struct file_operations nova_dax_file_operations = {
 	.llseek		= nova_llseek,
+	.open		= nova_open,
+	.fsync		= nova_fsync,
+	.flush		= nova_flush,
 };
 
 const struct inode_operations nova_file_inode_operations = {
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
