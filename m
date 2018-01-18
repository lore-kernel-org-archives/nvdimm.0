Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F41552238B592
 for <linux-nvdimm@lists.01.org>; Thu, 18 Jan 2018 08:02:22 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v2] generic/347: dm-thin lacks DAX support
Date: Thu, 18 Jan 2018 09:07:37 -0700
Message-Id: <20180118160737.24708-1-ross.zwisler@linux.intel.com>
In-Reply-To: <20180118042343.GQ3102@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

generic/347 currently fails when run in conjunction with the DAX mount
option:

generic/347 72s ... - output mismatch (see
/root/project/xfstests/results//generic/347.out.bad)
    --- tests/generic/347.out	2016-05-12 11:56:32.086618744 -0600
    +++ /root/project/xfstests/results//generic/347.out.bad	2018-01-17
    16:04:33.459348448 -0700
    @@ -1,2 +1,3 @@
     QA output created by 347
    +mount: /mnt/xfstests_scratch: can't read superblock on
    /dev/mapper/thin-vol.
     === completed
    ...
    (Run 'diff -u tests/generic/347.out
    /root/project/xfstests/results//generic/347.out.bad'  to see the entire
    diff)

This is expected because the dm-thin target currently lacks DAX support.

Just skip this test if we are using DAX.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 common/dmthin | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/common/dmthin b/common/dmthin
index baab6284..da0ad284 100644
--- a/common/dmthin
+++ b/common/dmthin
@@ -35,6 +35,11 @@ DMTHIN_POOL_DEV="/dev/mapper/$DMTHIN_POOL_NAME"
 DMTHIN_VOL_NAME="thin-vol"
 DMTHIN_VOL_DEV="/dev/mapper/$DMTHIN_VOL_NAME"
 
+echo $MOUNT_OPTIONS | grep -q dax
+if [ $? -eq 0 ]; then
+	_notrun "Cannot run tests with DAX on dmthin devices"
+fi
+
 _dmthin_cleanup()
 {
 	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
