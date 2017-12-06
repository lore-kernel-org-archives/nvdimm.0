Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D97B120352A97
 for <linux-nvdimm@lists.01.org>; Tue,  5 Dec 2017 16:33:21 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v5 0/2] add test for DAX MAP_SYNC support
Date: Tue,  5 Dec 2017 17:37:42 -0700
Message-Id: <20171206003744.28587-1-ross.zwisler@linux.intel.com>
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
To: fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

This is the fifth revision of my xfstest adding a test for the new
mmap() MAP_SYNC flag.  The previous version can be found here:

https://lists.01.org/pipermail/linux-nvdimm/2017-November/013329.html

Changes since v4:
 - Test for dm-log-writes + DAX support in the spirit of
   _require_scratch_dax() instead of relying on specific module version
   number. (Eryu)

 - Print out the missing mark name in the error output of
   _log_writes_replay_log().  (Eryu)

 - Go back to using the output from "du -sh" to test our file block
   allocations.  The "stat -c %s" I was using in v4 was broken if the
   file existed and only had partial block allocations, and the number
   of blocks reported by "stat -c %b" can vary based on the block size.

 - Move the test number to 999 to avoid rebasing collisions.  Feel free
   to renumber as necessary when merging.

I've updated the links at the bottom of this mail to point to the most
recent version of my xfsprogs changes and to the current version of this
series.

---

The purpose of this series is to exercise the new MAP_SYNC mmap()
functionality [1].  It adds a test which uses dm-log-writes to try and
replay filesystem metadata operations for a file that is being written via
mmap().

If MAP_SYNC is active the dm-log-writes replay will recreate the file's
block allocations and you'll end up with a test file which is a known
size.

If MAP_SYNC is not active the metadata writes will most likely be lost and
the replay will either fail to create the test file at all or it will may
be smaller.  In all of my testing the file simply doesn't exist on the
replay if MAP_SYNC is ommited.

This test relies on a kernel with both the MAP_SYNC mmap() functionality
and the DAX enabling in dm-log-writes.  These both appear in kernel
v4.15-rc*.  For ease of testing I've posted a kernel that is v4.14 plus
just those two patch series [2].

This test also relies on xfsprogs having support for MAP_SYNC and for
dm-log-writes.  I've posed a tree adding that support [3].  This xfsprogs
series is still under review so if the xfs_io interfaces change this
test will of course need to be updated as well.

Lastly, I've also posted a working version of this series [4].

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-November/013164.html
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/linux.git/log/?h=map_sync_dm_log_writes
[3]: https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/xfsprogs-dev.git/log/?h=map_sync_v2
[4]: https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/xfstests-dev.git/log/?h=map_sync_test_v5

Ross Zwisler (2):
  dm-log-writes: only replay log to marks that exist
  generic: add test for DAX MAP_SYNC support

 common/dmlogwrites    | 24 +++++++++++++++
 tests/generic/999     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  3 ++
 tests/generic/group   |  1 +
 4 files changed, 110 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
