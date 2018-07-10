Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1CA2A202E5441
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jul 2018 15:09:45 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v2 0/2] Add test for DAX+ext4+DMA race
Date: Tue, 10 Jul 2018 16:09:40 -0600
Message-Id: <20180710220942.21074-1-ross.zwisler@linux.intel.com>
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
To: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

As of kernel version 4.18-rc4, Linux has an issue with ext4+DAX where DMA
and direct I/O operations aren't synchronized with respect to operations
which can change the block mappings of an inode.  This can potentially
lead to data corruption, and is fixed in the following kernel series:

https://lists.01.org/pipermail/linux-nvdimm/2018-July/016842.html

These patches add a regression test for that series.

---

Changes since v1:
 * Added copyright and license information to files I've previously
   authored in src/.

 * Added copyright, license information and info about the test's
   purpose to src/t_mmap_collision.c. (Dave)

 * Added comments to tests/generic/999 explaining why we unset the
   mount flags for SCRATCH_MNT. (Dave)

 * Subtests in src/t_mmap_collision.c are now conditional based on the
   existence of the necessary FALLOC_FL_* flags. (Eryu)

 * Added the test to the punch, collapse and zero groups. (Eryu)

Ross Zwisler (2):
  src/: add license and copyright info to files
  generic/999: test DAX DMA vs truncate/hole-punch

 .gitignore                          |   1 +
 src/Makefile                        |   2 +-
 src/t_ext4_dax_inline_corruption.c  |   2 +
 src/t_ext4_dax_journal_corruption.c |   2 +
 src/t_mmap_collision.c              | 235 ++++++++++++++++++++++++++++++++++++
 src/t_mmap_cow_race.c               |   2 +
 src/t_mmap_stale_pmd.c              |   2 +
 tests/generic/999                   |  53 ++++++++
 tests/generic/999.out               |   2 +
 tests/generic/group                 |   1 +
 10 files changed, 301 insertions(+), 1 deletion(-)
 create mode 100644 src/t_mmap_collision.c
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
