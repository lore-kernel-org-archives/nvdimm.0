Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E7920211AEA4E
 for <linux-nvdimm@lists.01.org>; Wed,  9 Jan 2019 09:54:25 -0800 (PST)
Subject: [PATCH v7 06/12] ndctl: add unit test for security ops (minus
 overwrite)
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 09 Jan 2019 10:54:24 -0700
Message-ID: <154705646454.23227.1611247191008628484.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
References: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
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
 test/Makefile.am |    4 +
 test/security.sh |  203 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 207 insertions(+)
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
index 00000000..1dbe04d2
--- /dev/null
+++ b/test/security.sh
@@ -0,0 +1,203 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+rc=77
+dev=""
+id=""
+dev_no=""
+keypath="/etc/ndctl/keys"
+masterkey="nvdimm-master-test"
+masterpath="$keypath/$masterkey"
+keyctl="/usr/bin/keyctl"
+
+. ./common
+
+lockpath="/sys/devices/platform/${NFIT_TEST_BUS0}/nfit_test_dimm/test_dimm"
+
+trap 'err $LINENO' ERR
+
+check_prereq()
+{
+	if [ ! -f "$keyctl" ]; then
+		echo "$keyctl does not exist."
+		exit 1
+	fi
+
+	if [ ! -d "$keypath" ]; then
+		echo "$keypath directory does not exist."
+		exit 1
+	fi
+}
+
+setup()
+{
+	$NDCTL disable-region -b "$NFIT_TEST_BUS0" all
+}
+
+detect()
+{
+	dev=$($NDCTL list -b "$NFIT_TEST_BUS0" -D | jq .[0].dev | tr -d '"')
+	[ -n "$dev" ] || err "$LINENO"
+	id=$($NDCTL list -b "$NFIT_TEST_BUS0" -D | jq .[0].id | tr -d '"')
+	[ -n "$id" ] || err "$LINENO"
+}
+
+setup_keys()
+{
+	if [ ! -f "$masterpath" ]; then
+		keyctl add user $masterkey "$(dd if=/dev/urandom bs=1 count=32 2>/dev/null)" @u
+		keyctl pipe "$(keyctl search @u user $masterkey)" > $masterpath
+	else
+		echo "Unclean setup. Please cleanup $masterpath file."
+		exit 1
+	fi
+}
+
+test_cleanup()
+{
+	keyctl unlink "$(keyctl search @u encrypted nvdimm:"$id")"
+	keyctl unlink "$(keyctl search @u user $masterkey)"
+	rm -f "$keypath"/nvdimm_"$id"\_"$(hostname)".blob
+	rm -f "$masterpath"
+}
+
+lock_dimm()
+{
+	$NDCTL disable-dimm "$dev"
+	dev_no="$(echo "$dev" | cut -b 5-)"
+	echo 1 > "${lockpath}${dev_no}/lock_dimm"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "locked" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		exit 1
+	fi
+}
+
+get_security_state()
+{
+	$NDCTL list -i -b "$NFIT_TEST_BUS0" -d "$dev" | jq .[].dimms[0].security | tr -d '"'
+}
+
+enable_passphrase()
+{
+	$NDCTL enable-passphrase -m user:"$masterkey" "$dev"
+	sstate=$(get_security_state)
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		exit 1
+	fi
+}
+
+disable_passphrase()
+{
+	$NDCTL disable-passphrase "$dev"
+	sstate=$(get_security_state)
+	if [ "$sstate" != "disabled" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		exit 1
+	fi
+}
+
+erase_security()
+{
+	$NDCTL sanitize-dimm -c "$dev"
+	sstate=$(get_security_state)
+	if [ "$sstate" != "disabled" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		exit 1
+	fi
+}
+
+update_security()
+{
+	$NDCTL update-passphrase -m user:"$masterkey" "$dev"
+	sstate=$(get_security_state)
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		exit 1
+	fi
+}
+
+freeze_security()
+{
+	$NDCTL freeze-security "$dev"
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
+	lock_dimm
+	$NDCTL enable-dimm "$dev"
+	sstate=$(get_security_state)
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		exit 1
+	fi
+	$NDCTL disable-region -b "$NFIT_TEST_BUS0" all
+	disable_passphrase
+}
+
+# this should always be the last test. with security frozen, nfit_test must
+# be removed and is no longer usable
+test_5_security_freeze()
+{
+	enable_passphrase
+	freeze_security
+	sstate=$(get_security_state)
+	if [ "$sstate" != "frozen" ]; then
+		echo "Incorrect security state: $sstate expected: frozen"
+		exit 1
+	fi
+	$NDCTL disable-passphrase "$dev" && { echo "disable succeed after frozen"; }
+	sstate=$(get_security_state)
+	echo "$sstate"
+	if [ "$sstate" != "frozen" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		exit 1
+	fi
+}
+
+check_min_kver "5.0" || do_skip "may lack security handling"
+
+modprobe nfit_test
+setup
+check_prereq
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
