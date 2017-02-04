From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] fixup! xfs: test per-inode DAX flag by IO
Date: Sat,  4 Feb 2017 08:17:52 -0700
Message-ID: <1486221472-1007-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1484892950-25178-2-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1484892950-25178-2-git-send-email-xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

This makes a few changes to allow xfs/138 to use PMD faults, and has a few
other changes which I think are improvements.

For PMD faults:
- We need to use MKFS_OPTIONS="-d su=2m,sw=1" to ensure that the block
  allocations we get from XFS are 2MiB sized and aligned.  Without this we
  will fall back to 4k DAX pages for all the tests.

- We need to preallocate the file size with fallocate, rather than using
  "xfs_io -c pwrite".  This lets XFS increase the size of the test files
  before the test starts, giving us 2MiB sized and aligned blocks.  This
  also has the added bonus that we don't start out the mmap portion of the
  test with all the areas of the files written to and allocated.  This
  means that on the first read pass through a portion of a file we exercise
  the zero page DAX path for holes, then on subsequent passes we'll fill
  the holes and exercise the normal DAX path, giving us better overall
  coverage of the DAX code.  It also makes the test run slightly faster.

- For some reason I was having trouble getting XFS to give me 2MiB aligned
  and sized block allocations with file size 1GiB?  The test only needs
  file sizes of 64 MiB, and dropping the files used to that size ensured
  that I always got 2MiB allocations, but truthfully I don't understand
  this behavior from XFS.

And one cleanup thing:

- Changed the sizes above 4k to use bash math instead of having hard coded
  values.  I personally don't have 67108864 memorized to be 64 MiB (maybe
  everyone else does), but the meaning of $((64 * 1024 * 1024)) is more
  obvious to the reader.

I'm working on similar changes for your generic/405, but am still having
trouble getting PMD faults from ext4, even with the mkfs options I had
previously been using for other testing.

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 tests/xfs/138 | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tests/xfs/138 b/tests/xfs/138
index 9822441..4762534 100755
--- a/tests/xfs/138
+++ b/tests/xfs/138
@@ -79,22 +79,21 @@ do_tests()
 	# page size
 	t_dax_flag_mmap_dio `src/feature -s`
 	# bigger sizes, for PMD faults
-	t_dax_flag_mmap_dio 16777216
-	t_dax_flag_mmap_dio 67108864
+	t_dax_flag_mmap_dio $((16 * 1024 * 1024))
+	t_dax_flag_mmap_dio $((64 * 1024 * 1024))
 }
 
+export MKFS_OPTIONS="-d su=2m,sw=1"
 _scratch_mkfs > /dev/null 2>&1
 
 # mount with dax option
 _scratch_mount "-o dax"
 
 psize=`src/feature -s`
-tsize=$((1024 * 1024 * 1024))
+tsize=$((64 * 1024 * 1024))
 
-$XFS_IO_PROG -f -c "pwrite -W -b $psize 0 $tsize" \
-	$SCRATCH_MNT/tf_s >> $seqres.full 2>&1
-$XFS_IO_PROG -f -c "pwrite -W -b $psize 0 $tsize" \
-	$SCRATCH_MNT/tf_d >> $seqres.full 2>&1
+$XFS_IO_PROG -f -c "falloc 0 $tsize" $SCRATCH_MNT/tf_s >> $seqres.full 2>&1
+$XFS_IO_PROG -f -c "falloc 0 $tsize" $SCRATCH_MNT/tf_d >> $seqres.full 2>&1
 
 do_tests
 _scratch_unmount
-- 
2.7.4
