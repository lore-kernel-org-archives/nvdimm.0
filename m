Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
 by ml01.01.org (Postfix) with ESMTP id 9257B212017C0
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 18:27:29 -0700 (PDT)
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 0/4] xfs: add handle for reflink in dax
Date: Wed, 17 Apr 2019 09:27:11 +0800
Message-ID: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
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
To: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In XFS (under fsdax mode), reflink did not work correctly because xfs
iomap operators did not handle the inode with both reflink and dax flag.

This patchset aims to take care of this issue to make COW operation work
correctly in XFS.

XFS uses iomap to do read/write/mmap operations:
  vfs interface       xfs:
    iomap_bengin();     --> xfs_iomap_begin();
    actor();            --> dax_iomap_actor() / mmap actor function
    iomap_end();        --> xfs_iomap_end();

In xfs_iomap_begin(), COW operation is detected but not told to actor
function.  To resolve this, a new field 'src_addr' is added into
'struct iomap' to pass this COW info.  It means the start address of
source blocks in a COW operation, for actor functions to copy data
before writing.

In actor functions, the value of iomap->src_addr determines if it is a
COW operation.  If it is, copy data from source blocks to destination
blocks first, and then write user data.

After the COW operation, it is supposed to update the metadata of the
inode.  Added in xfs_iomap_end().


Shiyang Ruan (4):
  fs/iomap: Introduce src_addr for COW in fsdax mode.
  fs/xfs: iomap: add handle for reflink in fsdax mode
  fs/dax: copy source blocks before writing when COW
  fs/xfs: iomap: update the extent list after a COW

 fs/dax.c              | 70 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c    | 23 +++++++++++---
 include/linux/iomap.h |  4 +++
 3 files changed, 93 insertions(+), 4 deletions(-)

-- 
2.17.0



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
