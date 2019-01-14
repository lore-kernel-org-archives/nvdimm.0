Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39AB821959CB2
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 12:07:10 -0800 (PST)
Subject: [PATCH v8 06/12] ndctl: add unit test for security ops (minus
 overwrite)
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 14 Jan 2019 13:07:09 -0700
Message-ID: <154749642921.63704.16381620150804266304.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154749627829.63704.2987015129166185725.stgit@djiang5-desk3.ch.intel.com>
References: <154749627829.63704.2987015129166185725.stgit@djiang5-desk3.ch.intel.com>
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
 test/security.sh |  197 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 201 insertions(+)
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
index 00000000..9f69b481
--- /dev/null
+++ b/test/security.sh
@@ -0,0 +1,197 @@
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
+
+. ./common
+
+lockpath="/sys/devices/platform/${NFIT_TEST_BUS0}/nfit_test_dimm/test_dimm"
+
+trap 'err $LINENO' ERR
+
+setup()
+{
+	$NDCTL disable-region -b "$NFIT_TEST_BUS0" all
+}
+
+detect()
+{
+	dev="$($NDCTL list -b "$NFIT_TEST_BUS0" -D | jq -r .[0].dev)"
+	[ -n "$dev" ] || err "$LINENO"
+	id="$($NDCTL list -b "$NFIT_TEST_BUS0" -D | jq -r .[0].id)"
+	[ -n "$id" ] || err "$LINENO"
+}
+
+setup_keys()
+{
+	keyctl add user "$masterkey" "$(dd if=/dev/urandom bs=1 count=32 2>/dev/null)" @u
+	keyctl pipe "$(keyctl search @u user $masterkey)" > "$masterpath"
+}
+
+test_cleanup()
+{
+	if keyctl search @u encrypted nvdimm:"$id"; then
+		keyctl unlink "$(keyctl search @u encrypted nvdimm:"$id")"
+	fi
+
+	if keyctl search @u user "$masterkey"; then
+		keyctl unlink "$(keyctl search @u user $masterkey)"
+	fi
+
+	if [ -f "$keypath"/nvdimm_"$id"_"$(hostname)".blob ]; then
+		rm -f "$keypath"/nvdimm_"$id"_"$(hostname)".blob
+	fi
+
+	if [ -f $masterpath ]; then
+		rm -f "$masterpath"
+	fi
+}
+
+lock_dimm()
+{
+	$NDCTL disable-dimm "$dev"
+	dev_no="${dev#nmem}"
+	echo 1 > "${lockpath}${dev_no}/lock_dimm"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "locked" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		err $LINENO
+	fi
+}
+
+get_security_state()
+{
+	$NDCTL list -i -b "$NFIT_TEST_BUS0" -d "$dev" | jq -r .[].dimms[0].security
+}
+
+enable_passphrase()
+{
+	$NDCTL enable-passphrase -m user:"$masterkey" "$dev"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		err $LINENO
+	fi
+}
+
+disable_passphrase()
+{
+	$NDCTL disable-passphrase "$dev"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "disabled" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		err $LINENO
+	fi
+}
+
+erase_security()
+{
+	$NDCTL sanitize-dimm -c "$dev"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "disabled" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		err $LINENO
+	fi
+}
+
+update_security()
+{
+	$NDCTL update-passphrase -m user:"$masterkey" "$dev"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		err $LINENO
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
+test_4_security_unlock()
+{
+	enable_passphrase
+	lock_dimm
+	$NDCTL enable-dimm "$dev"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		err $LINENO
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
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "frozen" ]; then
+		echo "Incorrect security state: $sstate expected: frozen"
+		err $LINENO
+	fi
+	$NDCTL disable-passphrase "$dev" && { echo "disable succeed after frozen"; }
+	sstate="$(get_security_state)"
+	echo "$sstate"
+	if [ "$sstate" != "frozen" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		err $LINENO
+	fi
+}
+
+check_min_kver "5.0" || do_skip "may lack security handling"
+
+modprobe nfit_test
+setup
+check_prereq "keyctl"
+rc=1
+detect
+test_cleanup
+setup_keys
+echo "Test 1, security enable and disable"
+test_1_security_enable_and_disable
+echo "Test 2, security enable, update, and disable"
+test_2_security_enable_and_update
+echo "Test 3, security enable and erase"
+test_3_security_enable_and_erase
+echo "Test 4, unlock dimm"
+test_4_security_unlock
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
