Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 1/8] ext2, ext4: warn when mounting with dax enabled
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 17 Nov 2015 12:15:58 -0800
Message-ID: <20151117201558.15053.94792.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
References: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, stable@vger.kernel.org, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, akpm@linux-foundation.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Similar to XFS warn when mounting DAX while it is still considered under
development.  Also, aspects of the DAX implementation, for example
synchronization against multiple faults and faults causing block
allocation, depend on the correct implementation in the filesystem.  The
maturity of a given DAX implementation is filesystem specific.

Cc: <stable@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-ext4@vger.kernel.org
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Dave Chinner <david@fromorbit.com>
Acked-by: Jan Kara <jack@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/super.c |    2 ++
 fs/ext4/super.c |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 3a71cea68420..748d35afc902 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -569,6 +569,8 @@ static int parse_options(char *options, struct super_block *sb)
 			/* Fall through */
 		case Opt_dax:
 #ifdef CONFIG_FS_DAX
+			ext2_msg(sb, KERN_WARNING,
+		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 			set_opt(sbi->s_mount_opt, DAX);
 #else
 			ext2_msg(sb, KERN_INFO, "dax option not supported");
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 753f4e68b820..c9ab67da6e5a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1664,8 +1664,12 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		}
 		sbi->s_jquota_fmt = m->mount_opt;
 #endif
-#ifndef CONFIG_FS_DAX
 	} else if (token == Opt_dax) {
+#ifdef CONFIG_FS_DAX
+		ext4_msg(sb, KERN_WARNING,
+		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
+			sbi->s_mount_opt |= m->mount_opt;
+#else
 		ext4_msg(sb, KERN_INFO, "dax option not supported");
 		return -1;
 #endif

