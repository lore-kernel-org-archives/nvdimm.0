Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BCFA29
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 17:10:12 +0000 (UTC)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23IEL1fR010106;
	Mon, 18 Apr 2022 17:10:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=xPEC9nWdoOqoqBKVu7LRDgzQ7HmM5576Kx9aFYz0W+M=;
 b=N0dbF6tMlK2LUhrTyiFJJGII396JufzC3De4q0D+sX+25uKxg27Do+Ft/yITPbHuHEZ9
 52yZ/6Ax1Frl3h2xFya6ZtXmJk31UWdooACFDNaes5oPvKbO8OQtBooytapsyxcpv9xh
 s1y+tf/SO/dbIaI9D8A8E+SNsESO0BUNcyu6Im63AA9/ERZcD26yYL7ujUz3hkuffo+z
 b7TQEY1atkFs94H9G3D1OibaUXMcuT7nzILbRsrzzZfqquvoWAsHfE5XKyJnKWSE2mOu
 /z6K7YAxpxQJ6vT20EIATodLTNH59yDmlyxhB7fGjsyIyLDrGMnUUDbtomEol+Fp/GjR Zw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7bt1jev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:10:10 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23IH2xAi002612;
	Mon, 18 Apr 2022 17:10:08 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma04ams.nl.ibm.com with ESMTP id 3ffne931cw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:10:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23IHAGDJ64815596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Apr 2022 17:10:16 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 53C6BA404D;
	Mon, 18 Apr 2022 17:10:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60E0EA4040;
	Mon, 18 Apr 2022 17:10:04 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 18 Apr 2022 17:10:04 +0000 (GMT)
Subject: [RFC ndctl PATCH 1/9] test/common: Ensure to unload test modules
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Mon, 18 Apr 2022 12:10:03 -0500
Message-ID: 
 <165030179767.3224737.3430509039595994936.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <165030175745.3224737.6985015146263991065.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <165030175745.3224737.6985015146263991065.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: l-uSEnssAbXIp-Rj0QY55wTb1plIKMx7
X-Proofpoint-ORIG-GUID: l-uSEnssAbXIp-Rj0QY55wTb1plIKMx7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=760
 clxscore=1015 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180101

The _cleanup is easily missed to be called at places where trap
ERR is set, ex security.sh.

The patch moves all the modprobes into the _init in test/common
and sets the trap on exit for "any" of the reasons to invoke
_cleanup.

The patch also gracefully skips the test if the module load fails
instead of continuing, which otherwise makes the tests fail
erroneously in random places during the tests.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 test/btt-check.sh               |    3 +--
 test/btt-errors.sh              |    3 +--
 test/btt-pad-compat.sh          |    3 +--
 test/clear.sh                   |    4 +---
 test/common                     |   12 ++++++++++++
 test/create.sh                  |    4 +---
 test/daxdev-errors.sh           |    4 +---
 test/firmware-update.sh         |    3 +--
 test/inject-error.sh            |    3 +--
 test/inject-smart.sh            |    3 +--
 test/label-compat.sh            |    4 +---
 test/max_available_extent_ns.sh |    3 +--
 test/monitor.sh                 |    3 +--
 test/multi-dax.sh               |    4 +---
 test/pfn-meta-errors.sh         |    3 +--
 test/pmem-errors.sh             |    3 +--
 test/rescan-partitions.sh       |    3 +--
 test/sector-mode.sh             |    4 +---
 test/security.sh                |    3 +--
 test/track-uuid.sh              |    3 +--
 20 files changed, 31 insertions(+), 44 deletions(-)

diff --git a/test/btt-check.sh b/test/btt-check.sh
index 65b5c58b..1039d0eb 100755
--- a/test/btt-check.sh
+++ b/test/btt-check.sh
@@ -150,10 +150,9 @@ do_tests()
 }
 
 # setup (reset nfit_test dimms, create the BTT namespace)
-modprobe nfit_test
+_init
 rc=1
 reset && create
 do_tests
 reset
-_cleanup
 exit 0
diff --git a/test/btt-errors.sh b/test/btt-errors.sh
index 18518d50..ea1a6627 100755
--- a/test/btt-errors.sh
+++ b/test/btt-errors.sh
@@ -42,7 +42,7 @@ mkdir -p $MNT
 trap 'err $LINENO cleanup' ERR
 
 # setup (reset nfit_test dimms)
-modprobe nfit_test
+_init
 resetV
 
 rc=1
@@ -144,5 +144,4 @@ dd if=/dev/$blockdev of=/dev/null iflag=direct bs=4096 count=1 && err $LINENO ||
 # done, exit
 reset
 cleanup
-_cleanup
 exit 0
diff --git a/test/btt-pad-compat.sh b/test/btt-pad-compat.sh
index 005316a2..de85fec7 100755
--- a/test/btt-pad-compat.sh
+++ b/test/btt-pad-compat.sh
@@ -172,11 +172,10 @@ do_tests()
 	ns_info_wipe
 }
 
-modprobe nfit_test
+_init
 check_prereq xxd
 rc=1
 reset
 do_tests
 reset
-_cleanup
 exit 0
diff --git a/test/clear.sh b/test/clear.sh
index c4d02d54..9b785e35 100755
--- a/test/clear.sh
+++ b/test/clear.sh
@@ -13,7 +13,7 @@ check_min_kver "4.6" || do_skip "lacks clear poison support"
 trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
-modprobe nfit_test
+_init
 reset
 
 rc=1
@@ -72,6 +72,4 @@ if check_min_kver "4.9"; then
 	fi
 fi
 
-_cleanup
-
 exit 0
diff --git a/test/common b/test/common
index fb487958..d3216a0c 100644
--- a/test/common
+++ b/test/common
@@ -113,6 +113,18 @@ _cleanup()
 	modprobe -r nfit_test
 }
 
+_init()
+{
+	set +e
+	modprobe nfit_test
+	if [ $? -ne 0 ]; then
+		echo "Could not load the nfit_test module."
+		exit 77
+	fi
+	set -e
+	trap _cleanup EXIT INT TERM HUP PIPE
+}
+
 # json2var
 # stdin: json
 #
diff --git a/test/create.sh b/test/create.sh
index 9a6f3733..c2fdee2e 100755
--- a/test/create.sh
+++ b/test/create.sh
@@ -14,7 +14,7 @@ check_min_kver "4.5" || do_skip "may lack namespace mode attribute"
 trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
-modprobe nfit_test
+_init
 reset
 
 rc=1
@@ -40,6 +40,4 @@ eval $(echo $json | json2var)
 # free capacity for blk creation
 $NDCTL destroy-namespace -f $dev
 
-_cleanup
-
 exit 0
diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index 7f797181..f32f8b80 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -14,7 +14,7 @@ check_prereq "jq"
 trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
-modprobe nfit_test
+_init
 reset
 
 rc=1
@@ -71,6 +71,4 @@ if read sector len < /sys/bus/platform/devices/nfit_test.0/$busdev/$region/badbl
 fi
 [ -n "$sector" ] && echo "fail: $LINENO" && exit 1
 
-_cleanup
-
 exit 0
diff --git a/test/firmware-update.sh b/test/firmware-update.sh
index 93ce166e..1fac9dc1 100755
--- a/test/firmware-update.sh
+++ b/test/firmware-update.sh
@@ -70,11 +70,10 @@ do_tests()
 
 check_min_kver "4.16" || do_skip "may lack firmware update test handling"
 
-modprobe nfit_test
+_init
 fwupd_reset
 detect
 rc=1
 do_tests
 rm -f $image
-_cleanup
 exit 0
diff --git a/test/inject-error.sh b/test/inject-error.sh
index fd823b6c..15d0dbe8 100755
--- a/test/inject-error.sh
+++ b/test/inject-error.sh
@@ -79,10 +79,9 @@ do_tests()
 	check_status
 }
 
-modprobe nfit_test
+_init
 rc=1
 reset && create
 do_tests
 reset
-_cleanup
 exit 0
diff --git a/test/inject-smart.sh b/test/inject-smart.sh
index 046322bf..80af058a 100755
--- a/test/inject-smart.sh
+++ b/test/inject-smart.sh
@@ -167,7 +167,7 @@ do_tests()
 
 check_min_kver "4.19" || do_skip "kernel $KVER may not support smart (un)injection"
 check_prereq "jq"
-modprobe nfit_test
+_init
 rc=1
 
 jlist=$($TEST_PATH/list-smart-dimm -b $bus)
@@ -175,5 +175,4 @@ dimm="$(jq '.[]."dev"?, ."dev"?' <<< $jlist | sort | head -1 | xargs)"
 test -n "$dimm"
 
 do_tests
-_cleanup
 exit 0
diff --git a/test/label-compat.sh b/test/label-compat.sh
index 7ae4d5ef..4ccf69fa 100755
--- a/test/label-compat.sh
+++ b/test/label-compat.sh
@@ -15,7 +15,7 @@ check_prereq "jq"
 trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
-modprobe nfit_test
+_init
 $NDCTL disable-region -b $NFIT_TEST_BUS0 all
 $NDCTL init-labels -f -b $NFIT_TEST_BUS0 all
 
@@ -43,6 +43,4 @@ if [ -z $len ]; then
 	exit 1
 fi
 
-_cleanup
-
 exit 0
diff --git a/test/max_available_extent_ns.sh b/test/max_available_extent_ns.sh
index 47a921f5..98235424 100755
--- a/test/max_available_extent_ns.sh
+++ b/test/max_available_extent_ns.sh
@@ -31,9 +31,8 @@ do_test()
 	$NDCTL create-namespace -r $region -t pmem
 }
 
-modprobe nfit_test
+_init
 rc=1
 reset
 do_test
-_cleanup
 exit 0
diff --git a/test/monitor.sh b/test/monitor.sh
index e58c908b..10e65374 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -161,10 +161,9 @@ do_tests()
 	test_filter_dimmevent
 }
 
-modprobe nfit_test
+_init
 rc=1
 reset
 set_smart_supported_bus
 do_tests
-_cleanup
 exit 0
diff --git a/test/multi-dax.sh b/test/multi-dax.sh
index 04070adb..2b21c28c 100755
--- a/test/multi-dax.sh
+++ b/test/multi-dax.sh
@@ -16,7 +16,7 @@ trap 'err $LINENO' ERR
 ALIGN_SIZE=`getconf PAGESIZE`
 
 # setup (reset nfit_test dimms)
-modprobe nfit_test
+_init
 reset
 rc=1
 
@@ -28,6 +28,4 @@ chardev1=$(echo $json | jq ". | select(.mode == \"devdax\") | .daxregion.devices
 json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -r $region -t pmem -m devdax -a $ALIGN_SIZE -s 16M)
 chardev2=$(echo $json | jq ". | select(.mode == \"devdax\") | .daxregion.devices[0].chardev")
 
-_cleanup
-
 exit 0
diff --git a/test/pfn-meta-errors.sh b/test/pfn-meta-errors.sh
index 63148979..ccf5b7a1 100755
--- a/test/pfn-meta-errors.sh
+++ b/test/pfn-meta-errors.sh
@@ -28,7 +28,7 @@ set -e
 trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
-modprobe nfit_test
+_init
 reset
 
 rc=1
@@ -67,5 +67,4 @@ if read -r sector len < "/sys/block/$raw_bdev/badblocks"; then
 	false
 fi
 
-_cleanup
 exit 0
diff --git a/test/pmem-errors.sh b/test/pmem-errors.sh
index 9a59c25d..550114ac 100755
--- a/test/pmem-errors.sh
+++ b/test/pmem-errors.sh
@@ -25,7 +25,7 @@ mkdir -p $MNT
 trap 'err $LINENO cleanup' ERR
 
 # setup (reset nfit_test dimms)
-modprobe nfit_test
+_init
 reset
 
 rc=1
@@ -110,6 +110,5 @@ echo $((start_sect + 1)) 1 > /sys/block/$blockdev/badblocks
 dd if=$MNT/$FILE of=/dev/null iflag=direct bs=4096 count=1 && err $LINENO || true
 
 cleanup
-_cleanup
 
 exit 0
diff --git a/test/rescan-partitions.sh b/test/rescan-partitions.sh
index 51bbd731..f46e17ed 100755
--- a/test/rescan-partitions.sh
+++ b/test/rescan-partitions.sh
@@ -65,11 +65,10 @@ test_mode()
 	$NDCTL destroy-namespace $dev
 }
 
-modprobe nfit_test
+_init
 rc=1
 reset
 test_mode "raw"
 test_mode "fsdax"
 test_mode "sector"
-_cleanup
 exit 0
diff --git a/test/sector-mode.sh b/test/sector-mode.sh
index f70b0f17..d4a62bf3 100755
--- a/test/sector-mode.sh
+++ b/test/sector-mode.sh
@@ -14,7 +14,7 @@ trap 'err $LINENO' ERR
 ALIGN_SIZE=`getconf PAGESIZE`
 
 # setup (reset nfit_test dimms)
-modprobe nfit_test
+_init
 reset
 reset1
 
@@ -27,6 +27,4 @@ NAMESPACE=$($NDCTL create-namespace --no-autolabel -r $REGION -m sector -f -l 4K
 $NDCTL create-namespace --no-autolabel -e $NAMESPACE -m dax -f -a $ALIGN_SIZE
 $NDCTL create-namespace --no-autolabel -e $NAMESPACE -m sector -f -l 4K
 
-_cleanup
-
 exit 0
diff --git a/test/security.sh b/test/security.sh
index 34c4977b..7ae6e88c 100755
--- a/test/security.sh
+++ b/test/security.sh
@@ -246,7 +246,7 @@ if [ "$uid" -ne 0 ]; then
 	do_skip "run as root or with a sudo login shell for test to work"
 fi
 
-modprobe nfit_test
+_init
 setup
 check_prereq "keyctl"
 rc=1
@@ -275,5 +275,4 @@ test_6_load_keys
 
 test_cleanup
 post_cleanup
-_cleanup
 exit 0
diff --git a/test/track-uuid.sh b/test/track-uuid.sh
index a967d0e4..954afe7c 100755
--- a/test/track-uuid.sh
+++ b/test/track-uuid.sh
@@ -11,7 +11,7 @@ set -e
 trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
-modprobe nfit_test
+_init
 reset
 
 rc=1
@@ -34,5 +34,4 @@ $NDCTL disable-namespace $dev
 uuidgen > /sys/bus/nd/devices/$dev/uuid
 $NDCTL enable-namespace $dev
 
-_cleanup
 exit 0


