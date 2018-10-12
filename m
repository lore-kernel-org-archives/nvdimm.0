Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C83452116DFB6
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 15:29:14 -0700 (PDT)
Subject: [PATCH v4 7/7] ndctl: add unit test for security ops (minus overwrite)
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 15:29:13 -0700
Message-ID: <153938335357.20740.7177100102219176460.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153938316555.20740.14314691018876178251.stgit@djiang5-desk3.ch.intel.com>
References: <153938316555.20740.14314691018876178251.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add unit test for security enable, disable, update, erase, unlock, and
freeze.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/Makefile.am |    3 +
 test/security.sh |  187 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 189 insertions(+), 1 deletion(-)
 create mode 100755 test/security.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index ebdd23f6..68adfdee 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -25,7 +25,8 @@ TESTS =\
 	inject-smart.sh \
 	monitor.sh \
 	max_available_extent_ns.sh \
-	pfn-meta-errors.sh
+	pfn-meta-errors.sh \
+	security.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/security.sh b/test/security.sh
new file mode 100755
index 00000000..07d9dd7d
--- /dev/null
+++ b/test/security.sh
@@ -0,0 +1,187 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+rc=77
+dev=""
+id=""
+dev_no=""
+sstate=""
+PASSWD="/etc/nvdimm.passwd"
+PASSWD_BACKUP="/etc/nvdimm.passwd.ndctl.backup"
+PASS1="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
+PASS2="bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
+UNLOCK="/sys/devices/platform/nfit_test.0/nfit_test_dimm/test_dimm"
+
+. ./common
+
+trap 'err $LINENO' ERR
+
+setup()
+{
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+}
+
+detect()
+{
+	dev=$($NDCTL list -b $NFIT_TEST_BUS0 -D | jq .[0].dev | tr -d '"')
+	[ -n "$dev" ] || err "$LINENO"
+	id=$($NDCTL list -b $NFIT_TEST_BUS0 -D | jq .[0].id | tr -d '"')
+	[ -n "$id" ] || err "$LINENO"
+}
+
+setup_passwd()
+{
+	if [ ! -f $PASSWD_BACKUP ]; then
+		cp $PASSWD $PASSWD_BACKUP
+		echo "$id:$PASS1" > $PASSWD
+	else
+		echo "Unclean setup. Please cleanup $PASSWD_BACKUP file."
+		exit 1
+	fi
+}
+
+test_restore()
+{
+	if [ -f $PASSWD_BACKUP ]; then
+		mv $PASSWD.ndctl.backup $PASSWD
+	fi
+}
+
+locking_dimm()
+{
+	$NDCTL disable-dimm $dev
+	dev_no=$(echo $dev | cut -b 5-)
+	echo 1 > "$UNLOCK$dev_no/lock_dimm"
+	get_security_state
+	if [ "$sstate" != "locked" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		exit 1
+	fi
+}
+
+get_security_state()
+{
+	sstate=$($NDCTL list -i -b $NFIT_TEST_BUS0 -d $dev | jq .[].dimms[0].security_state | tr -d '"')
+	[ -n "$sstate" ] || err "$LINENO"
+}
+
+enable_security()
+{
+	$NDCTL update-security -i $dev
+	get_security_state
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		exit 1
+	fi
+}
+
+disable_security()
+{
+	$NDCTL disable-security -i $dev
+	get_security_state
+	if [ "$sstate" != "disabled" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		exit 1
+	fi
+}
+
+erase_security()
+{
+	$NDCTL sanitize -m crypto-erase -i $dev
+	get_security_state
+	if [ "$sstate" != "disabled" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		exit 1
+	fi
+}
+
+update_security()
+{
+	if [ -f $PASSWD_BACKUP ]; then
+		echo "$id:$PASS2:$PASS1" > $PASSWD
+	fi
+	enable_security
+	echo "$id:$PASS2" > $PASSWD
+}
+
+freeze_security()
+{
+	$NDCTL freeze-security $dev
+}
+
+test_1_security_enable_and_disable()
+{
+	enable_security
+	disable_security
+}
+
+test_2_security_enable_and_update()
+{
+	enable_security
+	update_security
+	disable_security
+}
+
+test_3_security_enable_and_erase()
+{
+	enable_security
+	erase_security
+}
+
+test_4_security_unlocking()
+{
+	enable_security
+	locking_dimm
+	$NDCTL enable-dimm $dev
+	get_security_state
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		exit 1
+	fi
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	disable_security
+}
+
+# this should always be the last test. with security frozen, nfit_test must
+# be removed and is no longer usable
+test_5_security_freeze()
+{
+	enable_security
+	freeze_security
+	get_security_state
+	if [ "$sstate" != "frozen" ]; then
+		echo "Incorrect security state: $sstate expected: frozen"
+		exit 1
+	fi
+	$NDCTL disable-security -i $dev && { echo "diable succeed after frozen"; exit 1; }
+	get_security_state
+	echo $sstate
+	if [ "$sstate" != "frozen" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		exit 1
+	fi
+}
+
+check_min_kver "4.20" || do_skip "may lack security test handling"
+
+modprobe nfit_test
+rc=1
+setup
+rc=2
+detect
+setup_passwd
+echo "Test 1, security enable and disable"
+test_1_security_enable_and_disable
+echo "Test 2, security enable, update, and disable"
+test_2_security_enable_and_update
+echo "Test 3, security enable and erase"
+test_3_security_enable_and_erase
+echo "Test 4, unlocking dimm"
+test_4_security_unlocking
+echo "Test 5, freeze security"
+test_5_security_freeze
+
+test_restore
+_cleanup
+exit 0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
