From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 3/8] xfs: remove s_maxbytes enforcement in xfs_file_read_iter
Date: Wed, 22 Jun 2016 17:27:11 +0200
Message-ID: <1466609236-23801-4-git-send-email-hch@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1466609236-23801-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

All the three low-level read implementations that we might call already
take care of not overflowing the maximum supported bytes, no need to
duplicate it here.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/xfs/xfs_file.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b32e6b0..09a5a78 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -249,7 +249,6 @@ xfs_file_read_iter(
 	struct xfs_mount	*mp = ip->i_mount;
 	size_t			size = iov_iter_count(to);
 	ssize_t			ret = 0;
-	xfs_fsize_t		n;
 	loff_t			pos = iocb->ki_pos;
 
 	XFS_STATS_INC(mp, xs_read_calls);
@@ -266,13 +265,6 @@ xfs_file_read_iter(
 		}
 	}
 
-	n = mp->m_super->s_maxbytes - pos;
-	if (n <= 0 || size == 0)
-		return 0;
-
-	if (n < size)
-		size = n;
-
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-- 
2.1.4
