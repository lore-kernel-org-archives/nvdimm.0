Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E0FA211B15B5
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 17:02:26 -0800 (PST)
Date: Tue, 15 Jan 2019 18:02:26 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH v8 06/12] ndctl: add unit test for security ops (minus
 overwrite)
Message-ID: <20190116010225.GA31324@vverma7-desk1.lm.intel.com>
References: <154749627829.63704.2987015129166185725.stgit@djiang5-desk3.ch.intel.com>
 <154749642921.63704.16381620150804266304.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <154749642921.63704.16381620150804266304.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 01/14, Dave Jiang wrote:
> Add unit test for security enable, disable, update, erase, unlock, and
> freeze.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/Makefile.am |    4 +
>  test/security.sh |  197 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 201 insertions(+)
>  create mode 100755 test/security.sh
> 
> diff --git a/test/Makefile.am b/test/Makefile.am
> index ebdd23f6..42009c31 100644
> --- a/test/Makefile.am
> +++ b/test/Makefile.am
> @@ -27,6 +27,10 @@ TESTS =\
>  	max_available_extent_ns.sh \
>  	pfn-meta-errors.sh
>  
> +if ENABLE_KEYUTILS
> +TESTS += security.sh
> +endif
> +
>  check_PROGRAMS =\
>  	libndctl \
>  	dsm-fail \
> diff --git a/test/security.sh b/test/security.sh
> new file mode 100755
> index 00000000..9f69b481
> --- /dev/null
> +++ b/test/security.sh
> @@ -0,0 +1,197 @@
> +#!/bin/bash -Ex
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright(c) 2018 Intel Corporation. All rights reserved.
> +
> +rc=77
> +dev=""

[..]

> +
> +lock_dimm()
> +{
> +	$NDCTL disable-dimm "$dev"
> +	dev_no="${dev#nmem}"
> +	echo 1 > "${lockpath}${dev_no}/lock_dimm"

This breaks setups where nfit_test.0 is not the first bus on the system.
The following patch should fix it (you can squash it into this patch):

8<----


>From 9365b1af15c3c8958f87f618494c3a52d09d8cbc Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 15 Jan 2019 17:49:23 -0700
Subject: [ndctl PATCH] test/security.sh: fix nmemX to nfit_test_dimm
 translation

The lock_dimm helper used the nmemX number as is to find the test_dimm
path to trigger the dimm lock for nfit_test, which is incorrect. The
test_dimmY device numbring is relative to nfit_test only, and nmemX
is systemwide. Use the dimm handles to find the right test_dimm to
operate on in lock_dimm. If another user of this functionality shows up,
we can then refactor this into a helper routing in test/common.

While at it, and since this patch is just going to be squashed into the
original, fix up a few more quoting issues.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/security.sh | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/test/security.sh b/test/security.sh
index 9f69b48..ea6b235 100755
--- a/test/security.sh
+++ b/test/security.sh
@@ -5,15 +5,12 @@
 rc=77
 dev=""
 id=""
-dev_no=""
 keypath="/etc/ndctl/keys"
 masterkey="nvdimm-master-test"
 masterpath="$keypath/$masterkey"
 
 . ./common
 
-lockpath="/sys/devices/platform/${NFIT_TEST_BUS0}/nfit_test_dimm/test_dimm"
-
 trap 'err $LINENO' ERR
 
 setup()
@@ -57,12 +54,30 @@ test_cleanup()
 lock_dimm()
 {
 	$NDCTL disable-dimm "$dev"
-	dev_no="${dev#nmem}"
-	echo 1 > "${lockpath}${dev_no}/lock_dimm"
+
+	# convert nmemX --> test_dimmY
+	# for now this is the only user of such a conversion so we can leave it inline
+	# once a subsequent user arrives we can refactor this to a helper in test/common:
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
 	sstate="$(get_security_state)"
 	if [ "$sstate" != "locked" ]; then
 		echo "Incorrect security state: $sstate expected: disabled"
-		err $LINENO
+		err "$LINENO"
 	fi
 }
 
@@ -77,7 +92,7 @@ enable_passphrase()
 	sstate="$(get_security_state)"
 	if [ "$sstate" != "unlocked" ]; then
 		echo "Incorrect security state: $sstate expected: unlocked"
-		err $LINENO
+		err "$LINENO"
 	fi
 }
 
@@ -87,7 +102,7 @@ disable_passphrase()
 	sstate="$(get_security_state)"
 	if [ "$sstate" != "disabled" ]; then
 		echo "Incorrect security state: $sstate expected: disabled"
-		err $LINENO
+		err "$LINENO"
 	fi
 }
 
@@ -97,7 +112,7 @@ erase_security()
 	sstate="$(get_security_state)"
 	if [ "$sstate" != "disabled" ]; then
 		echo "Incorrect security state: $sstate expected: disabled"
-		err $LINENO
+		err "$LINENO"
 	fi
 }
 
@@ -107,7 +122,7 @@ update_security()
 	sstate="$(get_security_state)"
 	if [ "$sstate" != "unlocked" ]; then
 		echo "Incorrect security state: $sstate expected: unlocked"
-		err $LINENO
+		err "$LINENO"
 	fi
 }
 
@@ -143,7 +158,7 @@ test_4_security_unlock()
 	sstate="$(get_security_state)"
 	if [ "$sstate" != "unlocked" ]; then
 		echo "Incorrect security state: $sstate expected: unlocked"
-		err $LINENO
+		err "$LINENO"
 	fi
 	$NDCTL disable-region -b "$NFIT_TEST_BUS0" all
 	disable_passphrase
@@ -158,14 +173,14 @@ test_5_security_freeze()
 	sstate="$(get_security_state)"
 	if [ "$sstate" != "frozen" ]; then
 		echo "Incorrect security state: $sstate expected: frozen"
-		err $LINENO
+		err "$LINENO"
 	fi
 	$NDCTL disable-passphrase "$dev" && { echo "disable succeed after frozen"; }
 	sstate="$(get_security_state)"
 	echo "$sstate"
 	if [ "$sstate" != "frozen" ]; then
 		echo "Incorrect security state: $sstate expected: disabled"
-		err $LINENO
+		err "$LINENO"
 	fi
 }
 
-- 
2.17.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
