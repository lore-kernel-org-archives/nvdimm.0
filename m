Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 302D92034A7D2
 for <linux-nvdimm@lists.01.org>; Wed,  1 Nov 2017 17:31:00 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] test/btt-errors: add a case to test with errors in btt
 metadata
Date: Wed,  1 Nov 2017 18:32:39 -0600
Message-Id: <20171102003239.32012-1-vishal.l.verma@intel.com>
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

If the BTT metadata is unreadable due to a badblock, we should fail
gracefully. Add a case to make sure that an error injected into the map
causes an IO error when trying to read it.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/btt-errors.sh | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/test/btt-errors.sh b/test/btt-errors.sh
index aec0b9d..d3a4694 100755
--- a/test/btt-errors.sh
+++ b/test/btt-errors.sh
@@ -142,6 +142,30 @@ dd if=/dev/zero of=$MNT/$FILE oflag=direct bs=4096 count=1
 # read again and that should succeed
 dd if=$MNT/$FILE of=/dev/null iflag=direct bs=4096 count=1
 
+
+## ensure we get an EIO for errors in namespace metadata
+
+# reset everything to get a clean log
+$NDCTL disable-region -b "$BUS" all
+$NDCTL zero-labels -b "$BUS" all
+$NDCTL enable-region -b "$BUS" all
+dev="x"
+json=$($NDCTL create-namespace -b "$BUS" -t pmem -m sector)
+eval "$(echo "$json" | sed -e "$json2var")"
+[ $dev = "x" ] && echo "fail: $LINENO" && exit 1
+
+# insert error at an arbitrary offset in the map (sector 0)
+force_raw 1
+map=$(hexdump -s 96 -n 4 "/dev/$raw_bdev" | head -1 | cut -d' ' -f2-)
+map=$(tr -d ' ' <<< "0x${map#* }${map%% *}")
+bb_inj=$((map/512))
+$NDCTL inject-error --block="$bb_inj" --count=1 $dev
+force_raw 0
+
+# make sure reading the first block of the namespace fails
+: The following 'dd' is expected to hit an I/O Error
+dd if=/dev/$blockdev of=/dev/null iflag=direct bs=4096 count=1 && err $LINENO || true
+
 # done, exit
 $NDCTL disable-region -b "$BUS" all
 $NDCTL zero-labels -b "$BUS" all
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
