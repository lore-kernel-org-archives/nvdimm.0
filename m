Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/7] xfs: introduce BMAPI_ZERO for allocating zeroed extents
Date: Thu,  1 Oct 2015 17:46:36 +1000
Message-Id: <1443685599-4843-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1443685599-4843-1-git-send-email-david@fromorbit.com>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, willy@linux.intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, linux-nvdimm@lists.01.org, jack@suse.cz, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Dave Chinner <dchinner@redhat.com>

To enable DAX to do atomic allocation of zeroed extents, we need to
drive the block zeroing deep into the allocator. Because
xfs_bmapi_write() can return merged extents on allocation that were
only partially allocated (i.e. requested range spans allocated and
hole regions, allocation into the hole was contiguous), we cannot
zero the extent returned from xfs_bmapi_write() as that can
overwrite existing data with zeros.

Hence we have to drive the extent zeroing into the allocation code,
prior to where we merge the extents into the BMBT and return the
resultant map. This means we need to propagate this need down to
the xfs_alloc_vextent() and issue the block zeroing at this point.

While this functionality is being introduced for DAX, there is no
reason why it is specific to DAX - we can per-zero blocks during the
allocation transaction on any type of device. It's just slow (and
usually slower than unwritten allocation and conversion) on
traditional block devices so doesn't tend to get used. We can,
however, hook hardware zeroing optimisations via sb_issue_zeroout()
to this operation, so it may be useful in future and hence the
"allocate zeroed blocks" API needs to be implementation neutral.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 10 +++++++++-
 fs/xfs/libxfs/xfs_alloc.h |  8 +++++---
 fs/xfs/libxfs/xfs_bmap.c  | 25 +++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_bmap.h  | 13 +++++++++++--
 fs/xfs/xfs_bmap_util.c    | 36 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h        |  3 +++
 6 files changed, 87 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ffad7f2..4cffc17 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2503,7 +2503,7 @@ xfs_alloc_vextent(
 		 * Try near allocation first, then anywhere-in-ag after
 		 * the first a.g. fails.
 		 */
-		if ((args->userdata  == XFS_ALLOC_INITIAL_USER_DATA) &&
+		if ((args->userdata & XFS_ALLOC_INITIAL_USER_DATA) &&
 		    (mp->m_flags & XFS_MOUNT_32BITINODES)) {
 			args->fsbno = XFS_AGB_TO_FSB(mp,
 					((mp->m_agfrotor / rotorstep) %
@@ -2634,6 +2634,14 @@ xfs_alloc_vextent(
 		XFS_AG_CHECK_DADDR(mp, XFS_FSB_TO_DADDR(mp, args->fsbno),
 			args->len);
 #endif
+
+		/* Zero the extent if we were asked to do so */
+		if (args->userdata & XFS_ALLOC_USERDATA_ZERO) {
+			error = xfs_zero_extent(args->ip, args->fsbno, args->len);
+			if (error)
+				goto error0;
+		}
+
 	}
 	xfs_perag_put(args->pag);
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index ca1c816..0ecde4d 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -101,6 +101,7 @@ typedef struct xfs_alloc_arg {
 	struct xfs_mount *mp;		/* file system mount point */
 	struct xfs_buf	*agbp;		/* buffer for a.g. freelist header */
 	struct xfs_perag *pag;		/* per-ag struct for this agno */
+	struct xfs_inode *ip;		/* for userdata zeroing method */
 	xfs_fsblock_t	fsbno;		/* file system block number */
 	xfs_agnumber_t	agno;		/* allocation group number */
 	xfs_agblock_t	agbno;		/* allocation group-relative block # */
@@ -120,15 +121,16 @@ typedef struct xfs_alloc_arg {
 	char		wasdel;		/* set if allocation was prev delayed */
 	char		wasfromfl;	/* set if allocation is from freelist */
 	char		isfl;		/* set if is freelist blocks - !acctg */
-	char		userdata;	/* set if this is user data */
+	char		userdata;	/* mask defining userdata treatment */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
 } xfs_alloc_arg_t;
 
 /*
  * Defines for userdata
  */
-#define XFS_ALLOC_USERDATA		1	/* allocation is for user data*/
-#define XFS_ALLOC_INITIAL_USER_DATA	2	/* special case start of file */
+#define XFS_ALLOC_USERDATA		(1 << 0)/* allocation is for user data*/
+#define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
+#define XFS_ALLOC_USERDATA_ZERO		(1 << 2)/* zero extent on allocation */
 
 xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_mount *mp,
 		struct xfs_perag *pag, xfs_extlen_t need);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8e2010d..8f607ed 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3800,8 +3800,13 @@ xfs_bmap_btalloc(
 	args.wasdel = ap->wasdel;
 	args.isfl = 0;
 	args.userdata = ap->userdata;
-	if ((error = xfs_alloc_vextent(&args)))
+	if (ap->userdata & XFS_ALLOC_USERDATA_ZERO)
+		args.ip = ap->ip;
+
+	error = xfs_alloc_vextent(&args);
+	if (error)
 		return error;
+
 	if (tryagain && args.fsbno == NULLFSBLOCK) {
 		/*
 		 * Exact allocation failed. Now try with alignment
@@ -4300,11 +4305,14 @@ xfs_bmapi_allocate(
 
 	/*
 	 * Indicate if this is the first user data in the file, or just any
-	 * user data.
+	 * user data. And if it is userdata, indicate whether it needs to
+	 * be initialised to zero during allocation.
 	 */
 	if (!(bma->flags & XFS_BMAPI_METADATA)) {
 		bma->userdata = (bma->offset == 0) ?
 			XFS_ALLOC_INITIAL_USER_DATA : XFS_ALLOC_USERDATA;
+		if (bma->flags & XFS_BMAPI_ZERO)
+			bma->userdata |= XFS_ALLOC_USERDATA_ZERO;
 	}
 
 	bma->minlen = (bma->flags & XFS_BMAPI_CONTIG) ? bma->length : 1;
@@ -4419,6 +4427,17 @@ xfs_bmapi_convert_unwritten(
 	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
 				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
 
+	/*
+	 * Before insertion into the bmbt, zero the range being converted
+	 * if required.
+	 */
+	if (flags & XFS_BMAPI_ZERO) {
+		error = xfs_zero_extent(bma->ip, mval->br_startblock,
+					mval->br_blockcount);
+		if (error)
+			return error;
+	}
+
 	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, &bma->idx,
 			&bma->cur, mval, bma->firstblock, bma->flist,
 			&tmp_logflags);
@@ -4511,6 +4530,8 @@ xfs_bmapi_write(
 	ASSERT(len > 0);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT((flags & (XFS_BMAPI_METADATA | XFS_BMAPI_ZERO)) !=
+			(XFS_BMAPI_METADATA | XFS_BMAPI_ZERO));
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 6aaa0c1..a160f8a 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -52,9 +52,9 @@ struct xfs_bmalloca {
 	xfs_extlen_t		minleft; /* amount must be left after alloc */
 	bool			eof;	/* set if allocating past last extent */
 	bool			wasdel;	/* replacing a delayed allocation */
-	bool			userdata;/* set if is user data */
 	bool			aeof;	/* allocated space at eof */
 	bool			conv;	/* overwriting unwritten extents */
+	char			userdata;/* userdata mask */
 	int			flags;
 };
 
@@ -109,6 +109,14 @@ typedef	struct xfs_bmap_free
  */
 #define XFS_BMAPI_CONVERT	0x040
 
+/*
+ * allocate zeroed extents - this requires all newly allocated user data extents
+ * to be initialised to zero. It will be ignored if XFS_BMAPI_METADATA is set.
+ * Use in conjunction with XFS_BMAPI_CONVERT to convert unwritten extents found
+ * during the allocation range to zeroed written extents.
+ */
+#define XFS_BMAPI_ZERO		0x080
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -116,7 +124,8 @@ typedef	struct xfs_bmap_free
 	{ XFS_BMAPI_PREALLOC,	"PREALLOC" }, \
 	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
 	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
-	{ XFS_BMAPI_CONVERT,	"CONVERT" }
+	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
+	{ XFS_BMAPI_ZERO,	"ZERO" }
 
 
 static inline int xfs_bmapi_aflag(int w)
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 3bf4ad0..3f59698 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -57,6 +57,35 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
 }
 
 /*
+ * Routine to zero an extent on disk allocated to the specific inode.
+ *
+ * The VFS functions take a linearised filesystem block offset, so we have to
+ * convert the sparse xfs fsb to the right format first.
+ * VFS types are real funky, too.
+ */
+int
+xfs_zero_extent(
+	struct xfs_inode *ip,
+	xfs_fsblock_t	start_fsb,
+	xfs_off_t	count_fsb)
+{
+	struct xfs_mount *mp = ip->i_mount;
+	xfs_daddr_t	sector = xfs_fsb_to_db(ip, start_fsb);
+	sector_t	block = XFS_BB_TO_FSBT(mp, sector);
+	ssize_t		size = XFS_FSB_TO_B(mp, count_fsb);
+
+	if (IS_DAX(VFS_I(ip)))
+		return dax_clear_blocks(VFS_I(ip), block, size);
+
+	/*
+	 * let the block layer decide on the fastest method of
+	 * implementing the zeroing.
+	 */
+	return sb_issue_zeroout(mp->m_super, block, count_fsb, GFP_NOFS);
+
+}
+
+/*
  * Routine to be called at transaction's end by xfs_bmapi, xfs_bunmapi
  * caller.  Frees all the extents that need freeing, which must be done
  * last due to locking considerations.  We never free any extents in
@@ -229,6 +258,13 @@ xfs_bmap_rtalloc(
 		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
 			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
 					XFS_TRANS_DQ_RTBCOUNT, (long) ralen);
+
+		/* Zero the extent if we were asked to do so */
+		if (ap->userdata & XFS_ALLOC_USERDATA_ZERO) {
+			error = xfs_zero_extent(ap->ip, ap->blkno, ap->length);
+			if (error)
+				return error;
+		}
 	} else {
 		ap->length = 0;
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7999e91..404bfa5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -336,4 +336,7 @@ extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
 
 extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 
+int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
+			xfs_off_t count_fsb);
+
 #endif	/* __XFS_MOUNT_H__ */
-- 
2.5.0

