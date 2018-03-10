Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x242.google.com (mail-pg0-x242.google.com
 [IPv6:2607:f8b0:400e:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9745C22646317
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:28 -0800 (PST)
Received: by mail-pg0-x242.google.com with SMTP id g8so4833068pgv.7
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:47 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 75/83] File operation: read/write iter.
Date: Sat, 10 Mar 2018 10:18:56 -0800
Message-Id: <1520705944-6723-76-git-send-email-jix024@eng.ucsd.edu>
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

They use the iomap framework to do read/write. Due to software overheads
they are slower than dax read/write.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/file.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/fs/nova/file.c b/fs/nova/file.c
index 0ae0333..7e90415 100644
--- a/fs/nova/file.c
+++ b/fs/nova/file.c
@@ -260,6 +260,69 @@ static long nova_fallocate(struct file *file, int mode, loff_t offset,
 	return ret;
 }
 
+static ssize_t nova_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	ssize_t ret;
+	timing_t read_iter_time;
+
+	if (!iov_iter_count(to))
+		return 0;
+
+	NOVA_START_TIMING(read_iter_t, read_iter_time);
+
+	inode_lock_shared(inode);
+	ret = dax_iomap_rw(iocb, to, &nova_iomap_ops);
+	inode_unlock_shared(inode);
+
+	file_accessed(iocb->ki_filp);
+	NOVA_END_TIMING(read_iter_t, read_iter_time);
+	return ret;
+}
+
+static ssize_t nova_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	loff_t offset;
+	size_t count;
+	ssize_t ret;
+	timing_t write_iter_time;
+
+	NOVA_START_TIMING(write_iter_t, write_iter_time);
+	inode_lock(inode);
+	ret = generic_write_checks(iocb, from);
+	if (ret <= 0)
+		goto out_unlock;
+
+	ret = file_remove_privs(file);
+	if (ret)
+		goto out_unlock;
+
+	ret = file_update_time(file);
+	if (ret)
+		goto out_unlock;
+
+	count = iov_iter_count(from);
+	offset = iocb->ki_pos;
+
+	ret = dax_iomap_rw(iocb, from, &nova_iomap_ops);
+	if (ret > 0 && iocb->ki_pos > i_size_read(inode)) {
+		i_size_write(inode, iocb->ki_pos);
+		sih->i_size = iocb->ki_pos;
+		mark_inode_dirty(inode);
+	}
+
+out_unlock:
+	inode_unlock(inode);
+	if (ret > 0)
+		ret = generic_write_sync(iocb, ret);
+	NOVA_END_TIMING(write_iter_t, write_iter_time);
+	return ret;
+}
+
 static ssize_t
 do_dax_mapping_read(struct file *filp, char __user *buf,
 	size_t len, loff_t *ppos)
@@ -645,6 +708,8 @@ const struct file_operations nova_dax_file_operations = {
 	.llseek		= nova_llseek,
 	.read		= nova_dax_file_read,
 	.write		= nova_dax_file_write,
+	.read_iter	= nova_dax_read_iter,
+	.write_iter	= nova_dax_write_iter,
 	.mmap		= nova_dax_file_mmap,
 	.open		= nova_open,
 	.fsync		= nova_fsync,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
