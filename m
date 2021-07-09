Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804A56D10
	for <nvdimm@lists.linux.dev>; Fri,  9 Jul 2021 19:53:14 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10040"; a="189446343"
X-IronPort-AV: E=Sophos;i="5.84,227,1620716400"; 
   d="scan'208";a="189446343"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 12:53:11 -0700
X-IronPort-AV: E=Sophos;i="5.84,227,1620716400"; 
   d="scan'208";a="450398653"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 12:53:08 -0700
Subject: [ndctl PATCH 5/6] test: Prepare out of line builds
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
Date: Fri, 09 Jul 2021 12:53:07 -0700
Message-ID: <162586038774.1431180.5754001305667433014.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162586035908.1431180.14991721381432827647.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162586035908.1431180.14991721381432827647.stgit@dwillia2-desk3.amr.corp.intel.com>
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
 test/dax-pmd.c         |    7 +++++--
 test/dax.sh            |    6 +++---
 test/daxdev-errors.sh  |    4 ++--
 test/device-dax-fio.sh |    2 +-
 test/dm.sh             |    4 ++--
 test/inject-smart.sh   |    2 +-
 test/list-smart-dimm.c |    1 +
 test/mmap.sh           |    6 +++---
 test/monitor.sh        |    6 +++---
 test/pmem-errors.sh    |    8 +++-----
 test/sub-section.sh    |    4 ++--
 test/track-uuid.sh     |    2 +-
 14 files changed, 49 insertions(+), 44 deletions(-)

diff --git a/test/btt-errors.sh b/test/btt-errors.sh
index 4e59f57aea7c..599d160d1922 100755
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
index 6bcefcad9bf9..251a129b1771 100644
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
index 190a0fd16786..11dc390fd732 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -24,7 +24,7 @@
 	__func__, __LINE__, strerror(errno))
 #define faili(i) fprintf(stderr, "%s: failed at: %d: %d (%s)\n", \
 	__func__, __LINE__, i, strerror(errno))
-#define TEST_FILE "test_dax_data"
+#define TEST_FILE "test_dax_mnt/test_dax_data"
 
 #define REGION_MEM_SIZE 4096*4
 #define REGION_PM_SIZE        4096*512
@@ -173,8 +173,11 @@ int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t off
 		rc = -ENXIO;
 
 		fd2 = open(TEST_FILE, O_CREAT|O_TRUNC|O_DIRECT|O_RDWR,
-				DEFFILEMODE);
+				0600);
 		if (fd2 < 0) {
+			/* skip on tmpfs */
+			if (errno == EINVAL)
+				rc = 77;
 			faili(i);
 			munmap(addr, 2*align);
 			break;
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
index 9547d781162b..3718e32a3052 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -64,8 +64,8 @@ read sector len < /sys/bus/nd/devices/$region/badblocks
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
 
diff --git a/test/list-smart-dimm.c b/test/list-smart-dimm.c
index 47b711e63670..da5044b73cc6 100644
--- a/test/list-smart-dimm.c
+++ b/test/list-smart-dimm.c
@@ -10,6 +10,7 @@
 #include <ndctl/filter.h>
 #include <ndctl/ndctl.h>
 #include <ndctl/json.h>
+#include <version.h>
 
 struct util_filter_params param;
 static int did_fail;
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
index 28c55415c819..7b0031c650f3 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -38,7 +38,7 @@ start_monitor()
 set_smart_supported_bus()
 {
 	smart_supported_bus=$NFIT_TEST_BUS0
-	monitor_dimms=$(./list-smart-dimm -b $smart_supported_bus | jq -r .[0].dev)
+	monitor_dimms=$($TEST_PATH/list-smart-dimm -b $smart_supported_bus | jq -r .[0].dev)
 	if [ -z $monitor_dimms ]; then
 		smart_supported_bus=$NFIT_TEST_BUS1
 	fi
@@ -46,14 +46,14 @@ set_smart_supported_bus()
 
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
index 4225c3bce0c7..4083fc389bdf 100755
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
@@ -84,8 +82,8 @@ echo $start_sect 8 > /sys/block/$blockdev/badblocks
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
index be3cf9c07a0a..516d073ac109 100755
--- a/test/track-uuid.sh
+++ b/test/track-uuid.sh
@@ -5,7 +5,7 @@
 blockdev=""
 rc=77
 
-. ./common
+. $(dirname $0)/common
 
 set -e
 trap 'err $LINENO' ERR

