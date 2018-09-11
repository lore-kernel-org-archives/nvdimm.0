Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B390210F5288
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 09:03:25 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 0/2] fix sync to flush processor cache for ext4 DAX files
Date: Tue, 11 Sep 2018 09:42:44 -0600
Message-Id: <20180911154246.6844-1-toshi.kani@hpe.com>
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

This patchset fixes an issue that sync syscall to an existing DAX file
does not flush processor cache.

Patch 1/2 adds a check to skip the journal inode. It's a bit awkward,
but I could not find a beter way to get the journal inode.

Patch 2/2 fixes the issue by moving up ext4_set_inode_flags() before
ext4_set_aops() in ext4_iget(). This assumes updated i_flags is harmless
in the error cases after the moved-up ext4_set_inode_flags(). Please
review.

---
Toshi Kani (2):
 1/2 ext4, dax: update dax check to skip journal inode
 2/2 ext4, dax: set ext4_dax_aops for dax files

---
 fs/ext4/ext4_jbd2.h | 8 ++++++++
 fs/ext4/inode.c     | 5 ++++-
 2 files changed, 12 insertions(+), 1 deletion(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
