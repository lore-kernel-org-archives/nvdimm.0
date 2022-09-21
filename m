Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BC97C
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 21:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663794181; x=1695330181;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6NNWNNzK4UffdcdjarrsFINSPx7MqoYkv1uX3Kiwe1U=;
  b=TUo0/t0XniHueeFou7GLpk98ocV1PcWSHI9eIZ8MzP35uFNqoiGBGPXK
   SVu3AunLK71HmZODcVH1XGqFtq+tqCkxz/PwV/FqcjBZBvpY2fXKGBqv5
   XvtfUo8ufV/ZiIsj8WxQMh7ZeIkdAu62I+zosy5l2f7tW9HETdJVX58DL
   hqLchuCu1JkJeHLqQ+jA2BktZpY6LxXM+Ffj8lGR5Oin+em8HGWfDhnB7
   XrLrTug9lEudBIhyp3WcabSkjLBECz7A8UIxXfngI0HGR6ILeUDbcior5
   hT0wzjJS9n55O2lE/UMPd5PhSls1HJeAYYGJCIEXxxzyY2Eqbs3pVi0xi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="279848680"
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="279848680"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 14:03:01 -0700
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="614959299"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 14:02:59 -0700
Subject: [PATCH 4/4] ndctl/test: Add CXL test for security
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Date: Wed, 21 Sep 2022 14:02:58 -0700
Message-ID: 
 <166379417897.433612.16268594042547006566.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166379397620.433612.13099557870939895846.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166379397620.433612.13099557870939895846.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Create security-cxl.sh based off of security.sh for nfit security testing.
The test will test a cxl_test based security commands enabling through
nvdimm.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/common          |    7 +
 test/meson.build     |    7 +
 test/security-cxl.sh |  282 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 296 insertions(+)
 create mode 100755 test/security-cxl.sh

diff --git a/test/common b/test/common
index 65615cc09a3e..e13b79728b0c 100644
--- a/test/common
+++ b/test/common
@@ -47,6 +47,7 @@ fi
 #
 NFIT_TEST_BUS0="nfit_test.0"
 NFIT_TEST_BUS1="nfit_test.1"
+CXL_TEST_BUS="cxl_test"
 ACPI_BUS="ACPI.NFIT"
 E820_BUS="e820"
 
@@ -125,6 +126,12 @@ _cleanup()
 	modprobe -r nfit_test
 }
 
+_cxl_cleanup()
+{
+	$NDCTL disable-region -b $CXL_TEST_BUS all
+	modprobe -r cxl_test
+}
+
 # json2var
 # stdin: json
 #
diff --git a/test/meson.build b/test/meson.build
index 5953c286d13f..485deb89bbe2 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -219,6 +219,13 @@ if get_option('keyutils').enabled()
   ]
 endif
 
+if get_option('keyutils').enabled()
+  security_cxl = find_program('security-cxl.sh')
+  tests += [
+    [ 'security-cxl.sh', security_cxl, 'ndctl' ]
+  ]
+endif
+
 foreach t : tests
   test(t[0], t[1],
     is_parallel : false,
diff --git a/test/security-cxl.sh b/test/security-cxl.sh
new file mode 100755
index 000000000000..0ec9b335bf41
--- /dev/null
+++ b/test/security-cxl.sh
@@ -0,0 +1,282 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2022 Intel Corporation. All rights reserved.
+
+rc=77
+dev=""
+id=""
+keypath="/etc/ndctl/keys"
+masterkey="nvdimm-master"
+masterpath="$keypath/$masterkey.blob"
+backup_key=0
+backup_handle=0
+
+. $(dirname $0)/common
+
+trap 'err $LINENO' ERR
+
+setup()
+{
+	$NDCTL disable-region -b "$CXL_TEST_BUS" all
+}
+
+detect()
+{
+	dev="$($NDCTL list -b "$CXL_TEST_BUS" -D | jq -r 'sort_by(.id) | .[0].dev')"
+	[ -n "$dev" ] || err "$LINENO"
+	id="$($NDCTL list -b "$CXL_TEST_BUS" -D | jq -r 'sort_by(.id) | .[0].id')"
+	[ -n "$id" ] || err "$LINENO"
+}
+
+setup_keys()
+{
+	if [ ! -d "$keypath" ]; then
+		mkdir -p "$keypath"
+	fi
+
+	if [ -f "$masterpath" ]; then
+		mv "$masterpath" "$masterpath.bak"
+		backup_key=1
+	fi
+	if [ -f "$keypath/tpm.handle" ]; then
+		mv "$keypath/tpm.handle" "$keypath/tpm.handle.bak"
+		backup_handle=1
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
+		keyctl unlink "$(keyctl search @u user "$masterkey")"
+	fi
+
+	if [ -f "$keypath"/nvdimm_"$id"_"$(hostname)".blob ]; then
+		rm -f "$keypath"/nvdimm_"$id"_"$(hostname)".blob
+	fi
+}
+
+post_cleanup()
+{
+	if [ -f $masterpath ]; then
+		rm -f "$masterpath"
+	fi
+	if [ "$backup_key" -eq 1 ]; then
+		mv "$masterpath.bak" "$masterpath"
+	fi
+	if [ "$backup_handle" -eq 1 ]; then
+		mv "$keypath/tpm.handle.bak" "$keypath/tpm.handle"
+	fi
+}
+
+lock_dimm()
+{
+	$NDCTL disable-dimm "$dev"
+	test_dimm_path=""
+
+	nmem_rpath=$(readlink -f "/sys/bus/nd/devices/${dev}")
+	nmem_bus=$(dirname ${nmem_rpath});
+	bus_provider_path="${nmem_bus}/provider"
+	test -e "$bus_provider_path" || err "$LINENO"
+	bus_provider=$(cat ${bus_provider_path})
+
+	[[ "$bus_provider" == "$CXL_TEST_BUS" ]] || err "$LINENO"
+	bus="cxl"
+	nmem_provider_path="/sys/bus/nd/devices/${dev}/${bus}/provider"
+	nmem_provider=$(cat ${nmem_provider_path})
+
+	test_dimm_path=$(readlink -f /sys/bus/$bus/devices/${nmem_provider})
+	test_dimm_path=$(dirname $(dirname ${test_dimm_path}))/security_lock
+
+	test -e "$test_dimm_path"
+
+	# now lock the dimm
+	echo 1 > "${test_dimm_path}"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "locked" ]; then
+		echo "Incorrect security state: $sstate expected: locked"
+		err "$LINENO"
+	fi
+}
+
+get_frozen_state()
+{
+	$NDCTL list -i -b "$CXL_TEST_BUS" -d "$dev" | jq -r .[].dimms[0].security_frozen
+}
+
+get_security_state()
+{
+	$NDCTL list -i -b "$CXL_TEST_BUS" -d "$dev" | jq -r .[].dimms[0].security
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
+	$NDCTL disable-region -b "$CXL_TEST_BUS" all
+	remove_passphrase
+}
+
+# This should always be the last nvdimm security test.
+# with security frozen, cxl_test must be removed and is no longer usable
+test_5_security_freeze()
+{
+	setup_passphrase
+	freeze_security
+	sstate="$(get_security_state)"
+	fstate="$(get_frozen_state)"
+	if [ "$fstate" != "true" ]; then
+		echo "Incorrect security state: expected: frozen"
+		err "$LINENO"
+	fi
+
+	# need to simulate a soft reboot here to clean up
+	lock_dimm
+	$NDCTL enable-dimm "$dev"
+	sstate="$(get_security_state)"
+	if [ "$sstate" != "unlocked" ]; then
+		echo "Incorrect security state: $sstate expected: unlocked"
+		err "$LINENO"
+	fi
+}
+
+test_6_load_keys()
+{
+	if keyctl search @u encrypted nvdimm:"$id"; then
+		keyctl unlink "$(keyctl search @u encrypted nvdimm:"$id")"
+	fi
+
+	if keyctl search @u user "$masterkey"; then
+		keyctl unlink "$(keyctl search @u user "$masterkey")"
+	fi
+
+	$NDCTL load-keys
+
+	if keyctl search @u user "$masterkey"; then
+		echo "master key loaded"
+	else
+		echo "master key failed to loaded"
+		err "$LINENO"
+	fi
+
+	if keyctl search @u encrypted nvdimm:"$id"; then
+		echo "dimm key loaded"
+	else
+		echo "dimm key failed to load"
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
+modprobe cxl_test
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
+# Freeze should always be the last nvdimm security test because it locks
+# security state and require cxl_test module unload. However, this does
+# not impact any key management testing via libkeyctl.
+echo "Test 5, freeze security"
+test_5_security_freeze
+
+# Load-keys is independent of actual nvdimm security and is part of key
+# mangement testing.
+echo "Test 6, test load-keys"
+test_6_load_keys
+
+test_cleanup
+post_cleanup
+_cxl_cleanup
+exit 0


