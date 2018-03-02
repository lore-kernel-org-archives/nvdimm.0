Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 553332250EDFF
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 11:09:32 -0800 (PST)
Subject: [PATCH v6] dax: introduce IS_DEVDAX() and IS_FSDAX()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 02 Mar 2018 11:06:36 -0800
Message-ID: <152001757529.22146.17936438768625217740.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <CAPcyv4iu32ja_vPiN=E0DP7_PFaj887XQ48EOMupE0Q4p1dCkQ@mail.gmail.com>
References: <CAPcyv4iu32ja_vPiN=E0DP7_PFaj887XQ48EOMupE0Q4p1dCkQ@mail.gmail.com>
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
To: linux-nvdimm@lists.01.org
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

The current IS_DAX() helper that checks if a file is in DAX mode serves
two purposes. It is a control flow branch condition for DAX vs
non-DAX paths and it is a mechanism to perform dead code elimination. The
dead code elimination is required in the CONFIG_FS_DAX=n case since
there are symbols in fs/dax.c that will be elided. While the
dead code elimination can be addressed with nop stubs for the fs/dax.c
symbols that does not address the need for a DAX control flow helper
where fs/dax.c symbols are not involved.

Moreover, the control flow changes, in some cases, need to be cognizant
of whether the DAX file is a typical file or a Device-DAX special file.
Introduce IS_DEVDAX() and IS_FSDAX() to simultaneously address the
file-type control flow and dead-code elimination use cases. IS_DAX()
will be deleted after all sites are converted to use the file-type
specific helper.

Note, this change is also a pre-requisite for fixing the definition of
the S_DAX inode flag in the CONFIG_FS_DAX=n + CONFIG_DEV_DAX=y case.
The flag needs to be defined, non-zero, if either DAX facility is
enabled.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: <stable@vger.kernel.org>
Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
Reported-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v5:
* add comments to clarify the S_ISCHR() checks (Darrick)

 include/linux/fs.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 79c413985305..751975b8b29b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1909,6 +1909,30 @@ static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags
 #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
 				 (inode)->i_rdev == WHITEOUT_DEV)
 
+static inline bool IS_DEVDAX(struct inode *inode)
+{
+	if (!IS_ENABLED(CONFIG_DEV_DAX))
+		return false;
+	if ((inode->i_flags & S_DAX) == 0)
+		return false;
+	/* regular files with S_DAX are filesystem-dax instances */
+	if (!S_ISCHR(inode->i_mode))
+		return false;
+	return true;
+}
+
+static inline bool IS_FSDAX(struct inode *inode)
+{
+	if (!IS_ENABLED(CONFIG_FS_DAX))
+		return false;
+	if ((inode->i_flags & S_DAX) == 0)
+		return false;
+	/* character devices with S_DAX are device-dax instances */
+	if (S_ISCHR(inode->i_mode))
+		return false;
+	return true;
+}
+
 static inline bool HAS_UNMAPPED_ID(struct inode *inode)
 {
 	return !uid_valid(inode->i_uid) || !gid_valid(inode->i_gid);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
