Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 93D0E211B81A5
 for <linux-nvdimm@lists.01.org>; Thu, 24 Jan 2019 15:07:38 -0800 (PST)
Subject: [PATCH v10 06/12] ndctl: add unit test for security ops (minus
 overwrite)
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 24 Jan 2019 16:07:37 -0700
Message-ID: <154837125793.37086.1862844997973456756.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154837084784.37086.4597479371733088393.stgit@djiang5-desk3.ch.intel.com>
References: <154837084784.37086.4597479371733088393.stgit@djiang5-desk3.ch.intel.com>
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
 test/security.sh |  222 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+)
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
index 00000000..38b21183
--- /dev/null
+++ b/test/security.sh
@@ -0,0 +1,222 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+rc=77
+dev=""
+id=""
+keypath="/etc/ndctl/keys"
+masterkey="nvdimm-master-test"
+masterpath="$keypath/$masterkey"
+
+. ./common
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
+	if [ ! -d "$keypath" ]; then
+		mkdir -p "$keypath"
+	fi
+
+	dd if=/dev/urandom bs=1 count=32 2>/dev/null | keyctl padd user "$masterkey" @u
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
+
+	rm -f "$keypath"/"$NFIT_TEST_BUS0".kek
+}
+
+lock_dimm()
+{
+	$NDCTL disable-dimm "$dev"
+	# convert nmemX --> test_dimmY
+	# for now this is the only user of such a conversion so we can leave it
+	# inline once a subsequent user arrives we can refactor this to a
+	# helper in test/common:
+	#   get_test_dimm_path "nfit_test.0" "nmem3"
+	handle="$(ndctl list -b "$NFIT_TEST_BUS0"  -d "$dev" -i | jq -r .[].dimms[0].handle)"
+	test_dimm_path=""
+	for test_dimm in /sys/devices/platform/"$NFIT_TEST_BUS0"/nfit_test_dimm/test_dimm*; do
+		td_handle_file="$test_dimm/handle"
+		test -e "$td_handle_file" || continue
+		td_handle="$(cat "$td_handle_file")"
+		if [[ "$td_handle" -eq "$handle" ]]; then
+			test_dimm_path="$test_dimm"
+			break
+		fi
+	done
+	test -d "$test_dimm_path"
+
+	# now lock the dimm
+	echo 1 > "${test_dimm_path}/lock_dimm"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "locked" ]; then
+		echo "Incorrect security state: $sstate expected: locked"
+		err "$LINENO"
+	fi
+}
+
+get_security_state()
+{
+	$NDCTL list -i -b "$NFIT_TEST_BUS0" -d "$dev" | jq -r .[].dimms[0].security
+}
+
+setup_passphrase()
+{
+	$NDCTL setup-passphrase "$dev" -k user:"$masterkey"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		err "$LINENO"
+	fi
+}
+
+remove_passphrase()
+{
+	$NDCTL remove-passphrase "$dev"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "disabled" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		err "$LINENO"
+	fi
+}
+
+erase_security()
+{
+	$NDCTL sanitize-dimm -c "$dev"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "disabled" ]; then
+		echo "Incorrect security state: $sstate expected: disabled"
+		err "$LINENO"
+	fi
+}
+
+update_security()
+{
+	$NDCTL update-passphrase "$dev"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		err "$LINENO"
+	fi
+}
+
+freeze_security()
+{
+	$NDCTL freeze-security "$dev"
+}
+
+test_1_security_setup_and_remove()
+{
+	setup_passphrase
+	remove_passphrase
+}
+
+test_2_security_setup_and_update()
+{
+	setup_passphrase
+	update_security
+	remove_passphrase
+}
+
+test_3_security_setup_and_erase()
+{
+	setup_passphrase
+	erase_security
+}
+
+test_4_security_unlock()
+{
+	setup_passphrase
+	lock_dimm
+	$NDCTL enable-dimm "$dev"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		err "$LINENO"
+	fi
+	$NDCTL disable-region -b "$NFIT_TEST_BUS0" all
+	remove_passphrase
+}
+
+# this should always be the last test. with security frozen, nfit_test must
+# be removed and is no longer usable
+test_5_security_freeze()
+{
+	setup_passphrase
+	freeze_security
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "frozen" ]; then
+		echo "Incorrect security state: $sstate expected: frozen"
+		err "$LINENO"
+	fi
+	$NDCTL remove-passphrase "$dev" && { echo "remove succeed after frozen"; }
+	sstate="$(get_security_state)"
+	echo "$sstate"
+	if [ "$sstate" != "frozen" ]; then
+		echo "Incorrect security state: $sstate expected: frozen"
+		err "$LINENO"
+	fi
+}
+
+check_min_kver "5.0" || do_skip "may lack security handling"
+uid="$(keyctl show | grep -Eo "_uid.[0-9]+" | head -1 | cut -d. -f2-)"
+if [ "$uid" -ne 0 ]; then
+	do_skip "run as root or with a sudo login shell for test to work"
+fi
+
+modprobe nfit_test
+setup
+check_prereq "keyctl"
+rc=1
+detect
+test_cleanup
+setup_keys
+echo "Test 1, security setup and remove"
+test_1_security_setup_and_remove
+echo "Test 2, security setup, update, and remove"
+test_2_security_setup_and_update
+echo "Test 3, security setup and erase"
+test_3_security_setup_and_erase
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
