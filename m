Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BBCBA24
	for <nvdimm@lists.linux.dev>; Wed, 14 Dec 2022 22:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671055243; x=1702591243;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OrlQ0dJDRVsfwVt/hAjdRAYA8Ox139BU6LnDt4ev0fU=;
  b=UBkHCr9yW9rcJtRfQnBc/GK0lnRERdTJd6XAyMEL0jjbmBzuGZDhC0LD
   HbxF2xjODDcJVDKrmRLTSTsa0NDr4e+Ez8hlp3nNd7zRwIko2iFYWCye9
   TNtoG5vAWixjmt9xxkNkvm71Txl7MZ5dsmsggTjajt1jiTGWK2qw9MMlS
   A5mXqlzavs764E2EtzJnC7SP345qTrBihixWOhKM5Xl+DhqlASYtA+az3
   mFuuOgNe938r1NOV/LJXVlJ4NHh+iwA4vQWs0ulkdMT0V3rVgzftzsvjP
   ZbV5dkyo60KdxfBCc0GLoE+FjMFsNls2qVFjudX3JQdQpFAG866pQ0VkM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="317233572"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="317233572"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 14:00:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="791406269"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="791406269"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 14:00:43 -0800
Subject: [ndctl PATCH v2 4/4] ndctl/test: Add CXL test for security
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Date: Wed, 14 Dec 2022 15:00:42 -0700
Message-ID: 
 <167105524289.3034751.7668584473744316324.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <167105505204.3034751.8113387624258581781.stgit@djiang5-desk3.ch.intel.com>
References: 
 <167105505204.3034751.8113387624258581781.stgit@djiang5-desk3.ch.intel.com>
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
v2:
- Have test share common code. (Vishal)
- Add cxl test to cxl test suite. (Dan)
---
 test/common           |    7 +++++
 test/cxl-security     |   40 ++++++++++++++++++++++++++++
 test/cxl-security.sh  |    5 ++++
 test/meson.build      |    6 +++-
 test/nfit-security    |   40 ++++++++++++++++++++++++++++
 test/nfit-security.sh |    5 ++++
 test/security.sh      |   70 ++++++++++++++++++-------------------------------
 7 files changed, 126 insertions(+), 47 deletions(-)
 create mode 100644 test/cxl-security
 create mode 100755 test/cxl-security.sh
 create mode 100644 test/nfit-security
 create mode 100755 test/nfit-security.sh

diff --git a/test/common b/test/common
index 44cc352f6009..b2519c17b34c 100644
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
diff --git a/test/cxl-security b/test/cxl-security
new file mode 100644
index 000000000000..9a28ffd82b0b
--- /dev/null
+++ b/test/cxl-security
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2022, Intel Corp. All rights reserved.
+
+detect()
+{
+	dev="$($NDCTL list -b "$CXL_TEST_BUS" -D | jq -r 'sort_by(.id) | .[0].dev')"
+	[ -n "$dev" ] || err "$LINENO"
+	id="$($NDCTL list -b "$CXL_TEST_BUS" -D | jq -r 'sort_by(.id) | .[0].id')"
+	[ -n "$id" ] || err "$LINENO"
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
diff --git a/test/cxl-security.sh b/test/cxl-security.sh
new file mode 100755
index 000000000000..d81ad3fe69d9
--- /dev/null
+++ b/test/cxl-security.sh
@@ -0,0 +1,5 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2022 Intel Corporation. All rights reserved.
+
+$(dirname $0)/security.sh cxl
diff --git a/test/meson.build b/test/meson.build
index e0aaf5c6eaa9..a956885f6df6 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -215,9 +215,11 @@ if get_option('destructive').enabled()
 endif
 
 if get_option('keyutils').enabled()
-  security = find_program('security.sh')
+  nfit_security = find_program('nfit-security.sh')
+  cxl_security = find_program('cxl-security.sh')
   tests += [
-    [ 'security.sh', security, 'ndctl' ]
+    [ 'nfit-security.sh', nfit_security, 'ndctl' ],
+    [ 'cxl-security.sh', cxl_security, 'cxl' ],
   ]
 endif
 
diff --git a/test/nfit-security b/test/nfit-security
new file mode 100644
index 000000000000..a05274ab801b
--- /dev/null
+++ b/test/nfit-security
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2022, Intel Corp. All rights reserved.
+
+detect()
+{
+	dev="$($NDCTL list -b "$NFIT_TEST_BUS0" -D | jq -r .[0].dev)"
+	[ -n "$dev" ] || err "$LINENO"
+	id="$($NDCTL list -b "$NFIT_TEST_BUS0" -D | jq -r .[0].id)"
+	[ -n "$id" ] || err "$LINENO"
+}
+
+lock_dimm()
+{
+	$NDCTL disable-dimm "$dev"
+	# convert nmemX --> test_dimmY
+	# For now this is the only user of such a conversion so we can leave it
+	# inline. Once a subsequent user arrives we can refactor this to a
+	# helper in test/common:
+	#   get_test_dimm_path "nfit_test.0" "nmem3"
+	handle="$($NDCTL list -b "$NFIT_TEST_BUS0"  -d "$dev" -i | jq -r .[].dimms[0].handle)"
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
diff --git a/test/nfit-security.sh b/test/nfit-security.sh
new file mode 100755
index 000000000000..3df9392438ab
--- /dev/null
+++ b/test/nfit-security.sh
@@ -0,0 +1,5 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2022 Intel Corporation. All rights reserved.
+
+$(dirname $0)/security.sh nfit
diff --git a/test/security.sh b/test/security.sh
index 1aa848839ea7..04f630e1946e 100755
--- a/test/security.sh
+++ b/test/security.sh
@@ -17,15 +17,7 @@ trap 'err $LINENO' ERR
 
 setup()
 {
-	$NDCTL disable-region -b "$NFIT_TEST_BUS0" all
-}
-
-detect()
-{
-	dev="$($NDCTL list -b "$NFIT_TEST_BUS0" -D | jq -r .[0].dev)"
-	[ -n "$dev" ] || err "$LINENO"
-	id="$($NDCTL list -b "$NFIT_TEST_BUS0" -D | jq -r .[0].id)"
-	[ -n "$id" ] || err "$LINENO"
+	$NDCTL disable-region -b "$TEST_BUS" all
 }
 
 setup_keys()
@@ -78,44 +70,14 @@ post_cleanup()
 	fi
 }
 
-lock_dimm()
-{
-	$NDCTL disable-dimm "$dev"
-	# convert nmemX --> test_dimmY
-	# For now this is the only user of such a conversion so we can leave it
-	# inline. Once a subsequent user arrives we can refactor this to a
-	# helper in test/common:
-	#   get_test_dimm_path "nfit_test.0" "nmem3"
-	handle="$($NDCTL list -b "$NFIT_TEST_BUS0"  -d "$dev" -i | jq -r .[].dimms[0].handle)"
-	test_dimm_path=""
-	for test_dimm in /sys/devices/platform/"$NFIT_TEST_BUS0"/nfit_test_dimm/test_dimm*; do
-		td_handle_file="$test_dimm/handle"
-		test -e "$td_handle_file" || continue
-		td_handle="$(cat "$td_handle_file")"
-		if [[ "$td_handle" -eq "$handle" ]]; then
-			test_dimm_path="$test_dimm"
-			break
-		fi
-	done
-	test -d "$test_dimm_path"
-
-	# now lock the dimm
-	echo 1 > "${test_dimm_path}/lock_dimm"
-	sstate="$(get_security_state)"
-	if [ "$sstate" != "locked" ]; then
-		echo "Incorrect security state: $sstate expected: locked"
-		err "$LINENO"
-	fi
-}
-
 get_frozen_state()
 {
-	$NDCTL list -i -b "$NFIT_TEST_BUS0" -d "$dev" | jq -r .[].dimms[0].security_frozen
+	$NDCTL list -i -b "$TEST_BUS" -d "$dev" | jq -r .[].dimms[0].security_frozen
 }
 
 get_security_state()
 {
-	$NDCTL list -i -b "$NFIT_TEST_BUS0" -d "$dev" | jq -r .[].dimms[0].security
+	$NDCTL list -i -b "$TEST_BUS" -d "$dev" | jq -r .[].dimms[0].security
 }
 
 setup_passphrase()
@@ -192,7 +154,7 @@ test_4_security_unlock()
 		echo "Incorrect security state: $sstate expected: unlocked"
 		err "$LINENO"
 	fi
-	$NDCTL disable-region -b "$NFIT_TEST_BUS0" all
+	$NDCTL disable-region -b "$TEST_BUS" all
 	remove_passphrase
 }
 
@@ -243,13 +205,26 @@ test_6_load_keys()
 	fi
 }
 
-check_min_kver "5.0" || do_skip "may lack security handling"
+if [ "$1" = "nfit" ]; then
+	. $(dirname $0)/nfit-security
+	TEST_BUS="$NFIT_TEST_BUS0"
+	check_min_kver "5.0" || do_skip "may lack security handling"
+	KMOD_TEST="nfit_test"
+elif [ "$1" = "cxl" ]; then
+	. $(dirname $0)/cxl-security
+	TEST_BUS="$CXL_TEST_BUS"
+	check_min_kver "6.2" || do_skip "may lack security handling"
+	KMOD_TEST="cxl_test"
+else
+	do_skip "Missing input parameters"
+fi
+
 uid="$(keyctl show | grep -Eo "_uid.[0-9]+" | head -1 | cut -d. -f2-)"
 if [ "$uid" -ne 0 ]; then
 	do_skip "run as root or with a sudo login shell for test to work"
 fi
 
-modprobe nfit_test
+modprobe "$KMOD_TEST"
 setup
 check_prereq "keyctl"
 rc=1
@@ -278,5 +253,10 @@ test_6_load_keys
 
 test_cleanup
 post_cleanup
-_cleanup
+if [ "$1" = "nfit" ]; then
+	_cleanup
+elif [ "$1" = "cxl" ]; then
+	_cxl_cleanup
+fi
+
 exit 0


