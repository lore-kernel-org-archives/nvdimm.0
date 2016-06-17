Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 4ABFF1A1E16
 for <linux-nvdimm@lists.01.org>; Thu, 16 Jun 2016 18:05:06 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 2/2] xfs: initial/partial support for badblocks
Date: Thu, 16 Jun 2016 19:03:39 -0600
Message-Id: <1466125419-17736-3-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
References: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org, xfs@oss.sgi.com
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

RFC/WIP commit.

This adds the foollowing:
1. In xfs_mountfs(), get an initial badblocks list from gendisk's
badblocks infrastructure.
2. Register with the badblocks notifier to get updates for this disk's
badblocks

TODO:
1. Add badblocks info to the reverse mapping tree (and remove if a
badblock was cleared).
2. Before doing file IO, refer the rmap/badblocks to error out early if
the IO will attempt wo read a bad sector
3. Figure out interactions with mmap/DAX.

Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 fs/xfs/xfs_linux.h |   1 +
 fs/xfs/xfs_mount.c | 104 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h |   1 +
 3 files changed, 106 insertions(+)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 7e749be..f66d181 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -78,6 +78,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/freezer.h>
 #include <linux/list_sort.h>
 #include <linux/ratelimit.h>
+#include <linux/badblocks.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5e68b2c..1a47737 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -618,6 +618,96 @@ xfs_default_resblks(xfs_mount_t *mp)
 	return resblks;
 }
 
+STATIC int
+xfs_notifier_call(
+	struct notifier_block	*nb,
+	unsigned long		action,
+	void			*data)
+{
+	struct bb_notifier_data *bb_data = data;
+	struct xfs_mount *mp;
+
+	mp = container_of(nb, struct xfs_mount, m_badblocks_nb);
+	/* TODO xfs_add_bb_to_rmap(mp, bb_data->sector, bb_data->count); */
+	xfs_warn(mp, "xfs badblock %s sector %lu (count %d)\n",
+		(action == BB_ADD)?"added":"cleared",
+		bb_data->sector, bb_data->count);
+	return 0;
+}
+
+STATIC int
+xfs_init_badblocks(struct xfs_mount *mp)
+{
+	struct badblocks *bb = mp->m_super->s_bdev->bd_disk->bb;
+	int done = 0, error = 0;
+	ssize_t len, off = 0;
+	char *p;
+
+	/*
+	 * TODO: get a list of known badblocks so far and process it.
+	 * Can we just parse the sysfs format that badblocks_show()
+	 * returns? That should be the fastest way to get this.
+	 * Something like: (Is this too hacky? Should we just do
+	 * badblocks_check() in a (rather large) loop?)
+	 */
+	p = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	len = badblocks_show(bb, p, 0);
+	while (len) {
+		int count, n;
+		sector_t s;
+
+		/*
+		 * The sysfs badblocks format is multiple lines of:
+		 * "<sector> <count>"
+		 */
+		n = sscanf(p + off, "%lu %d\n%n", &s, &count, &done);
+		if (n < 2 || done < 3) {
+			error = -1;
+			break;
+		}
+		off += done;
+		len -= done;
+		xfs_warn(mp, "got badblocks: sector %ld, count %d", s, count);
+		/* TODO xfs_add_bb_to_rmap(mp, s, count); */
+	}
+	kfree(p);
+	if (error)
+		return error;
+
+	mp->m_badblocks_nb.notifier_call = xfs_notifier_call;
+	error = bb_notifier_register(bb, &mp->m_badblocks_nb);
+	if (error)
+		return error;
+
+	/*
+	 * TODO: There is probably a TOCTOU race hiding here - what if the
+	 * badblocks list gets updated before we register for notifications..
+	 * Can likely be solved by registering for notifications _first_ (the
+	 * above xfs_add_bb_to_rmap function has to be ready to accept new
+	 * blocks), then querying for the initial list (there could be overlap
+	 * here, shich the above function could handle), and then setting the
+	 * mount flag below.
+	 */
+
+	/*
+	 * TODO: set some flag (mount flag?) in xfs so that xfs knows
+	 * it will be doing error checking, and can possibly, later,
+	 * tell the block layer (possibly using a REQ_ flag in its IO
+	 * requests) not to do further badblock checking for those IOs.
+	 */
+
+	/* mp->m_flags |= XFS_MOUNT_FS_BADBLOCKS; */
+	return 0;
+}
+
+STATIC void
+xfs_badblocks_unmount(struct xfs_mount *mp)
+{
+	struct badblocks *bb = mp->m_super->s_bdev->bd_disk->bb;
+
+	bb_notifier_unregister(bb, &mp->m_badblocks_nb);
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -955,6 +1045,19 @@ xfs_mountfs(
 	}
 
 	/*
+	 * Register with the badblocks notifier chain
+	 */
+	error = xfs_init_badblocks(mp);
+	if (error) {
+		xfs_warn(mp, "Unable to register to badblocks notifications\n");
+		/*
+		 * TODO is this a hard error or can we simply
+		 * warn and continue?
+		 */
+		goto out_rtunmount;
+	}
+
+	/*
 	 * Now we are mounted, reserve a small amount of unused space for
 	 * privileged transactions. This is needed so that transaction
 	 * space required for critical operations can dip into this pool
@@ -1085,6 +1188,7 @@ xfs_unmountfs(
 	xfs_log_unmount(mp);
 	xfs_da_unmount(mp);
 	xfs_uuid_unmount(mp);
+	xfs_badblocks_unmount(mp);
 
 #if defined(DEBUG)
 	xfs_errortag_clearall(mp, 0);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 0ca9244..f0d1111 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -139,6 +139,7 @@ typedef struct xfs_mount {
 						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
 	struct xstats		m_stats;	/* per-fs stats */
+	struct notifier_block	m_badblocks_nb;	/* disk badblocks notifier */
 
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_data_workqueue;
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
