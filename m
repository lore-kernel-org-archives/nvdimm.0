Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA55621A02937
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 10:59:34 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 0/3] Fix DM DAX handling
Date: Tue, 26 Jun 2018 11:59:29 -0600
Message-Id: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
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
To: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This series fixes a few issues that I found with DM's handling of DAX
devices.  Here are some of the issues I found:

 * We can create a dm-stripe or dm-linear device which is made up of an
   fsdax PMEM namespace and a raw PMEM namespace but which can hold a
   filesystem mounted with the -o dax mount option.  DAX operations to
   the raw PMEM namespace part lack struct page and can fail in
   interesting/unexpected ways when doing things like fork(), examining
   memory with gdb, etc.

 * We can create a dm-stripe or dm-linear device which is made up of an
   fsdax PMEM namespace and a BRD ramdisk which can hold a filesystem
   mounted with the -o dax mount option.  All I/O to this filesystem
   will fail.

---

Changes since v2:
  * Only set QUEUE_FLAG_DAX for fsdax mode PMEM namespaces. (Mike)
  * Check for QUEUE_FLAG_DAX in __bdev_dax_supported(). (Mike)
  * Get rid of DM_TYPE_DAX_BIO_BASED reworks. (Mike)
  * Dropped the first 2 prep patches of v2 since they were merged for
    v4.18-rc1.  (Thanks, Darrick!)

---

Mike, can you take this series through your tree?

Personally I think this should be treated as a bug fix and merged in the
v4.18-rc* series.

Ross Zwisler (3):
  pmem: only set QUEUE_FLAG_DAX for fsdax mode
  dax: bdev_dax_supported() check for QUEUE_FLAG_DAX
  dm: prevent DAX mounts if not supported

 drivers/dax/super.c           | 8 ++++++++
 drivers/md/dm-ioctl.c         | 5 +++++
 drivers/md/dm-table.c         | 7 +++----
 drivers/md/dm.c               | 3 +--
 drivers/nvdimm/pmem.c         | 3 ++-
 include/linux/device-mapper.h | 5 +++++
 6 files changed, 24 insertions(+), 7 deletions(-)

-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
