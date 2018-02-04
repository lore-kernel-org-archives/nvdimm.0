Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE9FB2237A4DE
 for <linux-nvdimm@lists.01.org>; Sun,  4 Feb 2018 15:08:45 -0800 (PST)
Subject: [PATCH 1/3] dax: fix S_DAX definition
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 04 Feb 2018 15:05:20 -0800
Message-ID: <151778552057.7139.16434857860597414697.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151778551496.7139.17808629759104553625.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151778551496.7139.17808629759104553625.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: alex.williamson@redhat.com
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Make sure S_DAX is defined in the CONFIG_FS_DAX=n + CONFIG_DEV_DAX=y
case. Otherwise vma_is_dax() may incorrectly return false in the
Device-DAX case.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 511fbaabf624..a3329258ff5c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1850,7 +1850,7 @@ struct super_operations {
 #define S_IMA		1024	/* Inode has an associated IMA struct */
 #define S_AUTOMOUNT	2048	/* Automount/referral quasi-directory */
 #define S_NOSEC		4096	/* no suid or xattr security attributes */
-#ifdef CONFIG_FS_DAX
+#if IS_ENABLED(CONFIG_FS_DAX) || IS_ENABLED(CONFIG_DEV_DAX)
 #define S_DAX		8192	/* Direct Access, avoiding the page cache */
 #else
 #define S_DAX		0	/* Make all the DAX code disappear */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
