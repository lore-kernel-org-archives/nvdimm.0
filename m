Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909342C80
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418363; x=1672954363;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vQxxEbqbl1RTUOVMG1TzrStopuZ3lUbgSkJhlz6poFs=;
  b=c61upTmfP77hw94xnjtB97v62EDYfpGb9ksqmvWpPHg3H8VDwnlzr/Mp
   20O7KPBXRs26NKBCBK700YtqCJM6n7/4sZPVs/1q70nOzzSJB2rkSrOMx
   X4jxdFf80RGKbyOmlEuuMkI2+5KBh9cjNJ+XgrSsVfBkpqbQ8uSL1AWf0
   WbtFBklw5MQnz2mpHOYJjEi8R/wu2Wyr+dcWtoNvVIgVtpxunou7IwB6l
   gC98SReTsl2yq0CU5zmBvFHXVsYpi/WCal0FJDDuBFZhe0kfEbq0gXNTh
   3J92mwIViRyrkyasx9Bv/P2inYpDB+xMKOxWLoUhzPjvmIavOy3gLoI/d
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="303290121"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="303290121"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:43 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="574526557"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:42 -0800
Subject: [ndctl PATCH v3 12/16] test: Prepare out of line builds
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:32:42 -0800
Message-ID: <164141836235.3990253.5237538466465550643.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for converting to meson prepare the unit tests to run out of
a build directory rather than out of the source directory. Introduce
TEST_PATH for the location of the test executables.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/btt-errors.sh     |    4 +---
 test/common            |   37 +++++++++++++++++++++----------------
 test/dax-pmd.c         |   11 +++++++++--
 test/dax.sh            |    6 +++---
 test/daxdev-errors.sh  |    4 ++--
 test/device-dax-fio.sh |    2 +-
 test/dm.sh             |    4 ++--
 test/inject-smart.sh   |    2 +-
 test/mmap.sh           |    6 +++---
 test/monitor.sh        |    6 +++---
 test/pmem-errors.sh    |    8 +++-----
 test/sub-section.sh    |    4 ++--
 test/track-uuid.sh     |    2 +-
 13 files changed, 52 insertions(+), 44 deletions(-)

diff --git a/test/btt-errors.sh b/test/btt-errors.sh
index 6e69178cc3cf..18518d503e9c 100755
--- a/test/btt-errors.sh
+++ b/test/btt-errors.sh
@@ -11,14 +11,12 @@ rc=77
 
 cleanup()
 {
-	rm -f $FILE
-	rm -f $MNT/$FILE
 	if grep -q "$MNT" /proc/mounts; then
 		umount $MNT
 	else
 		rc=77
 	fi
-	rmdir $MNT
+	rm -rf $MNT
 }
 
 force_raw()
diff --git a/test/common b/test/common
index b6d47128f209..fb487958a29b 100644
--- a/test/common
+++ b/test/common
@@ -4,27 +4,32 @@
 # Global variables
 
 # NDCTL
-#
-if [ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ]; then
-	export NDCTL=../ndctl/ndctl
-elif [ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ]; then
-	export NDCTL=./ndctl/ndctl
-else
-	echo "Couldn't find an ndctl binary"
-	exit 1
+if [ -z $NDCTL ]; then
+	if [ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ]; then
+		export NDCTL=../ndctl/ndctl
+	elif [ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ]; then
+		export NDCTL=./ndctl/ndctl
+	else
+		echo "Couldn't find an ndctl binary"
+		exit 1
+	fi
 fi
 
 # DAXCTL
-#
-if [ -f "../daxctl/daxctl" ] && [ -x "../daxctl/daxctl" ]; then
-	export DAXCTL=../daxctl/daxctl
-elif [ -f "./daxctl/daxctl" ] && [ -x "./daxctl/daxctl" ]; then
-	export DAXCTL=./daxctl/daxctl
-else
-	echo "Couldn't find an daxctl binary"
-	exit 1
+if [ -z $DAXCTL ]; then
+	if [ -f "../daxctl/daxctl" ] && [ -x "../daxctl/daxctl" ]; then
+		export DAXCTL=../daxctl/daxctl
+	elif [ -f "./daxctl/daxctl" ] && [ -x "./daxctl/daxctl" ]; then
+		export DAXCTL=./daxctl/daxctl
+	else
+		echo "Couldn't find an daxctl binary"
+		exit 1
+	fi
 fi
 
+if [ -z $TEST_PATH ]; then
+	export TEST_PATH=.
+fi
 
 # NFIT_TEST_BUS[01]
 #
diff --git a/test/dax-pmd.c b/test/dax-pmd.c
index 7648e348b0a6..f8408759d51e 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -24,7 +24,8 @@
 	__func__, __LINE__, strerror(errno))
 #define faili(i) fprintf(stderr, "%s: failed at: %d: %d (%s)\n", \
 	__func__, __LINE__, i, strerror(errno))
-#define TEST_FILE "test_dax_data"
+#define TEST_DIR "test_dax_mnt"
+#define TEST_FILE TEST_DIR "/test_dax_data"
 
 #define REGION_MEM_SIZE 4096*4
 #define REGION_PM_SIZE        4096*512
@@ -171,8 +172,14 @@ int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t off
 		}
 		rc = -ENXIO;
 
+		rc = mkdir(TEST_DIR, 0600);
+		if (rc < 0 && errno != EEXIST) {
+			faili(i);
+			munmap(addr, 2 * align);
+			break;
+		}
 		fd2 = open(TEST_FILE, O_CREAT|O_TRUNC|O_DIRECT|O_RDWR,
-				DEFFILEMODE);
+				0600);
 		if (fd2 < 0) {
 			faili(i);
 			munmap(addr, 2*align);
diff --git a/test/dax.sh b/test/dax.sh
index bcdd4e9bda27..bb9848b10ecc 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -15,13 +15,13 @@ cleanup() {
 	else
 		rc=77
 	fi
-	rmdir $MNT
+	rm -rf $MNT
 	exit $rc
 }
 
 run_test() {
 	rc=0
-	if ! trace-cmd record -e fs_dax:dax_pmd_fault_done ./dax-pmd $MNT/$FILE; then
+	if ! trace-cmd record -e fs_dax:dax_pmd_fault_done $TEST_PATH/dax-pmd $MNT/$FILE; then
 		rc=$?
 		if [ "$rc" -ne 77 ] && [ "$rc" -ne 0 ]; then
 			cleanup "$1"
@@ -104,7 +104,7 @@ set -e
 mkdir -p $MNT
 trap 'err $LINENO cleanup' ERR
 
-dev=$(./dax-dev)
+dev=$($TEST_PATH/dax-dev)
 json=$($NDCTL list -N -n $dev)
 eval $(json2var <<< "$json")
 rc=1
diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index e13453dfaa73..7f79718113d0 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -62,8 +62,8 @@ read sector len < /sys/bus/nd/devices/$region/badblocks
 echo "sector: $sector len: $len"
 
 # run the daxdev-errors test
-test -x ./daxdev-errors
-./daxdev-errors $busdev $region
+test -x $TEST_PATH/daxdev-errors
+$TEST_PATH/daxdev-errors $busdev $region
 
 # check badblocks, should be empty
 if read sector len < /sys/bus/platform/devices/nfit_test.0/$busdev/$region/badblocks; then
diff --git a/test/device-dax-fio.sh b/test/device-dax-fio.sh
index f57a9d266afc..c43ac058d2b0 100755
--- a/test/device-dax-fio.sh
+++ b/test/device-dax-fio.sh
@@ -18,7 +18,7 @@ if ! fio --enghelp | grep -q "dev-dax"; then
 	exit 77
 fi
 
-dev=$(./dax-dev)
+dev=$($TEST_PATH/dax-dev)
 for align in 4k 2m 1g
 do
 	json=$($NDCTL create-namespace -m devdax -a $align -f -e $dev)
diff --git a/test/dm.sh b/test/dm.sh
index 4656e5bfbebe..b780a65c27d2 100755
--- a/test/dm.sh
+++ b/test/dm.sh
@@ -8,7 +8,7 @@ SKIP=77
 FAIL=1
 SUCCESS=0
 
-. ./common
+. $(dirname $0)/common
 
 MNT=test_dax_mnt
 TEST_DM_PMEM=/dev/mapper/test_pmem
@@ -30,7 +30,7 @@ cleanup() {
 	if [ -L $TEST_DM_PMEM ]; then
 		dmsetup remove $TEST_DM_PMEM
 	fi
-	rmdir $MNT
+	rm -rf $MNT
 	# opportunistic cleanup, not fatal if these fail
 	namespaces=$($NDCTL list -N | jq -r ".[] | select(.name==\"$NAME\") | .dev")
 	for i in $namespaces
diff --git a/test/inject-smart.sh b/test/inject-smart.sh
index 4ca83b8b2263..8b913601bdd2 100755
--- a/test/inject-smart.sh
+++ b/test/inject-smart.sh
@@ -170,7 +170,7 @@ check_prereq "jq"
 modprobe nfit_test
 rc=1
 
-jlist=$(./list-smart-dimm -b $bus)
+jlist=$($TEST_PATH/list-smart-dimm -b $bus)
 dimm="$(jq '.[]."dev"?, ."dev"?' <<< $jlist | sort | head -1 | xargs)"
 test -n "$dimm"
 
diff --git a/test/mmap.sh b/test/mmap.sh
index 50a1d34d0b75..760257dc7f93 100755
--- a/test/mmap.sh
+++ b/test/mmap.sh
@@ -7,7 +7,7 @@
 MNT=test_mmap_mnt
 FILE=image
 DEV=""
-TEST=./mmap
+TEST=$TEST_PATH/mmap
 rc=77
 
 cleanup() {
@@ -17,7 +17,7 @@ cleanup() {
 	else
 		rc=77
 	fi
-	rmdir $MNT
+	rm -rf $MNT
 	exit $rc
 }
 
@@ -49,7 +49,7 @@ set -e
 mkdir -p $MNT
 trap 'err $LINENO cleanup' ERR
 
-dev=$(./dax-dev)
+dev=$($TEST_PATH/dax-dev)
 json=$($NDCTL list -N -n $dev)
 eval $(json2var <<< "$json")
 DEV="/dev/${blockdev}"
diff --git a/test/monitor.sh b/test/monitor.sh
index 14450a7b23e3..ef04607d8eb0 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -31,7 +31,7 @@ start_monitor()
 set_smart_supported_bus()
 {
 	smart_supported_bus=$NFIT_TEST_BUS0
-	monitor_dimms=$(./list-smart-dimm -b $smart_supported_bus | jq -r .[0].dev)
+	monitor_dimms=$($TEST_PATH/list-smart-dimm -b $smart_supported_bus | jq -r .[0].dev)
 	if [ -z $monitor_dimms ]; then
 		smart_supported_bus=$NFIT_TEST_BUS1
 	fi
@@ -39,14 +39,14 @@ set_smart_supported_bus()
 
 get_monitor_dimm()
 {
-	jlist=$(./list-smart-dimm -b $smart_supported_bus $1)
+	jlist=$($TEST_PATH/list-smart-dimm -b $smart_supported_bus $1)
 	monitor_dimms=$(jq '.[]."dev"?, ."dev"?' <<<$jlist | sort | uniq | xargs)
 	echo $monitor_dimms
 }
 
 call_notify()
 {
-	./smart-notify $smart_supported_bus
+	$TEST_PATH/smart-notify $smart_supported_bus
 	sync; sleep 3
 }
 
diff --git a/test/pmem-errors.sh b/test/pmem-errors.sh
index 20657801fc0e..9a59c25d4a79 100755
--- a/test/pmem-errors.sh
+++ b/test/pmem-errors.sh
@@ -10,14 +10,12 @@ rc=77
 
 cleanup()
 {
-	rm -f $FILE
-	rm -f $MNT/$FILE
 	if [ -n "$blockdev" ]; then
 		umount /dev/$blockdev
 	else
 		rc=77
 	fi
-	rmdir $MNT
+	rm -rf $MNT
 }
 
 check_min_kver "4.7" || do_skip "may lack dax error handling"
@@ -82,8 +80,8 @@ echo $start_sect 8 > /sys/block/$blockdev/badblocks
 dd if=$MNT/$FILE of=/dev/null iflag=direct bs=4096 count=1 && err $LINENO || true
 
 # run the dax-errors test
-test -x ./dax-errors
-./dax-errors $MNT/$FILE
+test -x $TEST_PATH/dax-errors
+$TEST_PATH/dax-errors $MNT/$FILE
 
 # TODO: disable this check till we have clear-on-write in the kernel
 #if read sector len < /sys/block/$blockdev/badblocks; then
diff --git a/test/sub-section.sh b/test/sub-section.sh
index 92ae816c448c..77b963355c8f 100755
--- a/test/sub-section.sh
+++ b/test/sub-section.sh
@@ -8,7 +8,7 @@ SKIP=77
 FAIL=1
 SUCCESS=0
 
-. ./common
+. $(dirname $0)/common
 
 check_min_kver "5.3" || do_skip "may lack align sub-section hotplug support"
 
@@ -30,7 +30,7 @@ cleanup() {
 	if mountpoint -q $MNT; then
 		umount $MNT
 	fi
-	rmdir $MNT
+	rm -rf $MNT
 	# opportunistic cleanup, not fatal if these fail
 	namespaces=$($NDCTL list -N | jq -r ".[] | select(.name==\"$NAME\") | .dev")
 	for i in $namespaces
diff --git a/test/track-uuid.sh b/test/track-uuid.sh
index 3bacd2c24787..a967d0e4691c 100755
--- a/test/track-uuid.sh
+++ b/test/track-uuid.sh
@@ -5,7 +5,7 @@
 blockdev=""
 rc=77
 
-. ./common
+. $(dirname $0)/common
 
 set -e
 trap 'err $LINENO' ERR

