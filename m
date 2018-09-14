Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 625ED21130E4A
 for <linux-nvdimm@lists.01.org>; Fri, 14 Sep 2018 07:51:17 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 0/3] fix sync to flush processor cache for ext2/4 DAX files
Date: Fri, 14 Sep 2018 08:51:11 -0600
Message-Id: <20180914145114.11122-1-toshi.kani@hpe.com>
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
To: jack@suse.cz, dan.j.williams@intel.com
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patchset fixes issues that sync syscall to existing DAX ex2/4
files does not flush processor cache.

Patch 1/3 adds .bmap to ext4_dax_aops so that mount -o dax works for
the journal inode.

Patch 2/3 fixes the ext4 issue by setting i_flags before ext4_set_aops()
in ext4_iget().

Patch 3/3 fixes the ext2 issue by setting i_flags before ext2_set_aops()
in ext2_iget(), i.e. same as ext4.

v2:
 - Add .bmap to ext4_dax_aops, instead of disabling dax for the journal
   inode. (Jan Kara)
 - Initialize i_flags early in ext4_iget(). (Jan Kara)
 - Update Fixes tag and add Cc to Stable. (Dan Williams)
 - Add fix to ext2.

---
Toshi Kani (3):
 1/3 ext4, dax: add ext4_bmap to ext4_dax_aops
 2/3 ext4, dax: set ext4_dax_aops for dax files
 3/3 ext2, dax: set ext2_dax_aops for dax files

---
 fs/ext2/inode.c | 2 +-
 fs/ext4/inode.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
