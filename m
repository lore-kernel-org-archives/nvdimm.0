Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 25C9C2119623A
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 13:33:59 -0800 (PST)
Subject: [PATCH v5 06/12] ndctl: add unit test for security ops (minus
 overwrite)
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 30 Nov 2018 14:33:58 -0700
Message-ID: <154361363819.6129.3489713866394857291.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154361315118.6129.3346352930852675435.stgit@djiang5-desk3.ch.intel.com>
References: <154361315118.6129.3346352930852675435.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add unit test for security enable, disable, update, erase, unlock, and
freeze.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/Makefile.am |    4 +
 test/security.sh |  191 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 195 insertions(+)
 create mode 100755 test/security.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index ebdd23f6..42009c31 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -27,6 +27,10 @@ TESTS =\
 	max_available_extent_ns.sh \
 	pfn-meta-errors.sh
 
+if ENABLE_KEYUTILS
+TESTS += security.sh
+endif
+
 check_PROGRAMS =\
 	libndctl \
 	dsm-fail \
diff --git a/test/security.sh b/test/security.sh
new file mode 100755
index 00000000..5238c9c4
--- /dev/null
+++ b/test/security.sh
@@ -0,0 +1,191 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+rc=77
+dev=""
+id=""
+dev_no=""
+sstate=""
+KEYPATH="/etc/ndctl/keys"
+UNLOCK="/sys/devices/platform/nfit_test.0/nfit_test_dimm/test_dimm"
+MASTERKEY="nvdimm-master-test"
+MASTERPATH="$KEYPATH/$MASTERKEY"
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
+setup_keys()
+{
+	if [ ! -f $MASTERPATH ]; then
+		keyctl add user $MASTERKEY "`dd if=/dev/urandom bs=1 count=32 2>/dev/null`" @u
+		keyctl pipe `keyctl search @u user $MASTERKEY` > $MASTERPATH
+	else
+		echo "Unclean setup. Please cleanup $MASTERPATH file."
+		exit 1
+	fi
+}
+
+test_cleanup()
+{
+	keyctl unlink `keyctl search @u encrypted nvdimm:$id`
+	keyctl unlink `keyctl search @u user $MASTERKEY`
+	rm -f $KEYPATH/nvdimm_$id\_`hostname`.blob
+	rm -f $MASTERPATH
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
+	sstate=$($NDCTL list -i -b $NFIT_TEST_BUS0 -d $dev | jq .[].dimms[0].security | tr -d '"')
+	[ -n "$sstate" ] || err "$LINENO"
+}
+
+enable_passphrase()
+{
+	$NDCTL enable-passphrase -m user:$MASTERKEY $dev
+	get_security_state
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		exit 1
+	fi
+}
+
+disable_passphrase()
+{
+	$NDCTL disable-passphrase $dev
+	get_security_state
+	if [ "$sstate" != "disabled" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		exit 1
+	fi
+}
+
+erase_security()
+{
+	$NDCTL sanitize-dimm -c $dev
+	get_security_state
+	if [ "$sstate" != "disabled" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		exit 1
+	fi
+}
+
+update_security()
+{
+	$NDCTL update-passphrase -m user:$MASTERKEY $dev
+	get_security_state
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		exit 1
+	fi
+}
+
+freeze_security()
+{
+	$NDCTL freeze-security $dev
+}
+
+test_1_security_enable_and_disable()
+{
+	enable_passphrase
+	disable_passphrase
+}
+
+test_2_security_enable_and_update()
+{
+	enable_passphrase
+	update_security
+	disable_passphrase
+}
+
+test_3_security_enable_and_erase()
+{
+	enable_passphrase
+	erase_security
+}
+
+test_4_security_unlocking()
+{
+	enable_passphrase
+	locking_dimm
+	$NDCTL enable-dimm $dev
+	get_security_state
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		exit 1
+	fi
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	disable_passphrase
+}
+
+# this should always be the last test. with security frozen, nfit_test must
+# be removed and is no longer usable
+test_5_security_freeze()
+{
+	enable_passphrase
+	freeze_security
+	get_security_state
+	if [ "$sstate" != "frozen" ]; then
+		echo "Incorrect security state: $sstate expected: frozen"
+		exit 1
+	fi
+	$NDCTL disable-passphrase $dev && { echo "diable succeed after frozen"; exit 1; }
+	get_security_state
+	echo $sstate
+	if [ "$sstate" != "frozen" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		exit 1
+	fi
+}
+
+check_min_kver "4.21" || do_skip "may lack security test handling"
+
+modprobe nfit_test
+rc=1
+setup
+rc=2
+detect
+setup_keys
+echo "Test 1, security enable and disable"
+test_1_security_enable_and_disable
+echo "Test 2, security enable, update, and disable"
+test_2_security_enable_and_update
+echo "Test 3, security enable and erase"
+test_3_security_enable_and_erase
+echo "Test 4, unlocking dimm"
+test_4_security_unlocking
+
+# Freeze should always be run last because it locks security state and require
+# nfit_test module unload.
+echo "Test 5, freeze security"
+test_5_security_freeze
+
+test_cleanup
+_cleanup
+exit 0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
