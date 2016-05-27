Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 344B91A1F68
 for <linux-nvdimm@lists.01.org>; Fri, 27 May 2016 11:44:23 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2] libnvdimm, btt: update the usage section in Documentation
Date: Fri, 27 May 2016 12:43:45 -0600
Message-Id: <1464374625-6119-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Section 5 about BTT's in kernel usage was quite obsolete,
replace it with a simple 'Usage' section that describes how
to set up a BTT namespace using the 'ndctl' utility.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/nvdimm/btt.txt | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/Documentation/nvdimm/btt.txt b/Documentation/nvdimm/btt.txt
index b91443f..e293fb6 100644
--- a/Documentation/nvdimm/btt.txt
+++ b/Documentation/nvdimm/btt.txt
@@ -256,28 +256,18 @@ If any of these error conditions are encountered, the arena is put into a read
 only state using a flag in the info block.
 
 
-5. In-kernel usage
-==================
+5. Usage
+========
 
-Any block driver that supports byte granularity IO to the storage may register
-with the BTT. It will have to provide the rw_bytes interface in its
-block_device_operations struct:
+The BTT can be set up on any disk (namespace) exposed by the libnvdimm subsystem
+(pmem, or blk mode). The easiest way to set up such a namespace is using the
+'ndctl' utility [1]:
 
-	int (*rw_bytes)(struct gendisk *, void *, size_t, off_t, int rw);
+For example, the ndctl command line to setup a btt with a 4k sector size is:
 
-It may register with the BTT after it adds its own gendisk, using btt_init:
+    ndctl create-namespace -f -e namespace0.0 -m sector -l 4k
 
-	struct btt *btt_init(struct gendisk *disk, unsigned long long rawsize,
-			u32 lbasize, u8 uuid[], int maxlane);
+See ndctl create-namespace --help for more options.
 
-note that maxlane is the maximum amount of concurrency the driver wishes to
-allow the BTT to use.
-
-The BTT 'disk' appears as a stacked block device that grabs the underlying block
-device in the O_EXCL mode.
-
-When the driver wishes to remove the backing disk, it should similarly call
-btt_fini using the same struct btt* handle that was provided to it by btt_init.
-
-	void btt_fini(struct btt *btt);
+[1]: https://github.com/pmem/ndctl
 
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
