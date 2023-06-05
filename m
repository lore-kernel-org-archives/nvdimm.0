Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75421261D7
	for <nvdimm@lists.linux.dev>; Mon,  5 Jun 2023 20:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685996475; x=1717532475;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=LlVEQrDPE8IPCzrGqxiaHepxm+PhW003Qczq56Mw48s=;
  b=M9MsuDsJWmFTuM8tlLW5e/ioF0SEsyjCivp90M6DMNLDqr77yBgJiP/S
   kydBXh5UXMWZQNAXJNOUg/5RZD2V0TOy1/HhXVU+Aa19AefatRPTMcJ9c
   MftkIOIoy4Gt8aC0fj3aTAV/z84bqMgjz27vZtkVpoFEq0ld+4gQ3Bql+
   9GuJxMOu2LLasTU7oknM1o4jYafxMW8ho+Lmn9lb0ZXdFUVSUzhPISl4u
   wO9A8l3rZ4TOTZL59xqEAwZtRho9wXSXMML4fcN+Eg2HDoO9THHuslTJp
   FE9l3IIlJfROcBOyJu/8ofZFRhAjQnPErcC2QvovmUT9KhG2HmO4moavR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336093186"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="336093186"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 13:21:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="832934323"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="832934323"
Received: from kmsalzbe-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.209.52.9])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 13:21:12 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Mon, 05 Jun 2023 14:21:07 -0600
Subject: [PATCH ndctl v2 5/5] test/cxl-update-firmware: add a unit test for
 firmware update
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-vv-fw_update-v2-5-a778a15e860b@intel.com>
References: <20230405-vv-fw_update-v2-0-a778a15e860b@intel.com>
In-Reply-To: <20230405-vv-fw_update-v2-0-a778a15e860b@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-02a79
X-Developer-Signature: v=1; a=openpgp-sha256; l=5613;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=LlVEQrDPE8IPCzrGqxiaHepxm+PhW003Qczq56Mw48s=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCl1ztteWJkL7XxhwWdldGPmOp9Ven/VdCzc4qLyj12bd
 67Jty2so5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABN5H8zwTyUkY+E9myXymT3d
 Xh/K/MKOzT0z41Sn8hE1A20pb8NrLYwMF9vZ53qtYT2zd+/WJ83ZSpr6qxqXbJ7WGPPZendzb/F
 MbgA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Add a unit test to exercise the different operating modes of the
cxl-update-firmware command. Perform an update synchronously,
asynchronously, on multiple devices, and attempt cancellation of an
in-progress update.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/cxl-update-firmware.sh | 195 ++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build            |   2 +
 2 files changed, 197 insertions(+)

diff --git a/test/cxl-update-firmware.sh b/test/cxl-update-firmware.sh
new file mode 100755
index 0000000..c6cd742
--- /dev/null
+++ b/test/cxl-update-firmware.sh
@@ -0,0 +1,195 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 Intel Corporation. All rights reserved.
+
+. $(dirname $0)/common
+
+rc=77
+
+set -ex
+
+trap 'err $LINENO' ERR
+
+check_prereq "jq"
+check_prereq "dd"
+check_prereq "sha256sum"
+
+modprobe -r cxl_test
+modprobe cxl_test
+rc=1
+
+mk_fw_file()
+{
+	size="$1"
+
+	if [[ ! $size ]]; then
+		err "$LINENO"
+	fi
+	if (( size > 64 )); then
+		err "$LINENO"
+	fi
+
+	fw_file="$(mktemp -p /tmp fw_file_XXXX)"
+	dd if=/dev/urandom of="$fw_file" bs=1M count="$size"
+	echo "$fw_file"
+}
+
+find_memdevs()
+{
+	count="$1"
+
+	if [[ ! $count ]]; then
+		count=1
+	fi
+
+	"$CXL" list -M -b "$CXL_TEST_BUS" \
+		| jq -r '.[] | select(.host | startswith("cxl_mem.")) | .memdev' \
+		| head -"$count"
+}
+
+do_update_fw()
+{
+	"$CXL" update-firmware -b "$CXL_TEST_BUS" "$@"
+}
+
+wait_complete()
+{
+	mem="$1"  # single memdev, not a list
+	max_wait="$2"  # in seconds
+	waited=0
+
+	while true; do
+		json="$("$CXL" list -m "$mem" -F)"
+		in_prog="$(jq -r '.[].firmware.fw_update_in_progress' <<< "$json")"
+		if [[ $in_prog == "true" ]]; then
+			sleep 1
+			waited="$((waited + 1))"
+			continue
+		else
+			break
+		fi
+		if (( waited == max_wait )); then
+			echo "completion timeout for $mem"
+			err "$LINENO"
+		fi
+	done
+}
+
+validate_json_state()
+{
+	json="$1"
+	state="$2"
+
+	while read -r in_prog_state; do
+		if [[ $in_prog_state == $state ]]; then
+			continue
+		else
+			echo "expected fw_update_in_progress:$state"
+			err "$LINENO"
+		fi
+	done < <(jq -r '.[].firmware.fw_update_in_progress' <<< "$json")
+}
+
+validate_fw_update_in_progress()
+{
+	validate_json_state "$1" "true"
+}
+
+validate_fw_update_idle()
+{
+	validate_json_state "$1" "false"
+}
+
+validate_staged_slot()
+{
+	json="$1"
+	slot="$2"
+
+	while read -r staged_slot; do
+		if [[ $staged_slot == $slot ]]; then
+			continue
+		else
+			echo "expected staged_slot:$slot"
+			err "$LINENO"
+		fi
+	done < <(jq -r '.[].firmware.staged_slot' <<< "$json")
+}
+
+check_sha()
+{
+	mem="$1"
+	file="$2"
+	csum_path="/sys/bus/platform/devices/cxl_mem.${mem#mem}/fw_buf_checksum"
+
+	mem_csum="$(cat "$csum_path")"
+	file_csum="$(sha256sum "$file" | awk '{print $1}')"
+
+	if [[ $mem_csum != $file_csum ]]; then
+		echo "checksum failure for mem$mem"
+		err "$LINENO"
+	fi
+}
+
+test_blocking_update()
+{
+	file="$(mk_fw_file 8)"
+	mem="$(find_memdevs 1)"
+	json=$(do_update_fw -F "$file" --wait "$mem")
+	validate_fw_update_idle "$json"
+	# cxl_test's starting slot is '2', so staged should be 3
+	validate_staged_slot "$json" 3
+	check_sha "$mem" "$file"
+	rm "$file"
+}
+
+test_nonblocking_update()
+{
+	file="$(mk_fw_file 16)"
+	mem="$(find_memdevs 1)"
+	json=$(do_update_fw -F "$file" "$mem")
+	validate_fw_update_in_progress "$json"
+	wait_complete "$mem" 15
+	validate_fw_update_idle "$("$CXL" list -m "$mem" -F)"
+	check_sha "$mem" "$file"
+	rm "$file"
+}
+
+test_multiple_memdev()
+{
+	num_mems=2
+
+	file="$(mk_fw_file 16)"
+	declare -a mems
+	mems=( $(find_memdevs "$num_mems") )
+	json="$(do_update_fw -F "$file" "${mems[@]}")"
+	validate_fw_update_in_progress "$json"
+	# use the in-band wait this time
+	json="$(do_update_fw --wait "${mems[@]}")"
+	validate_fw_update_idle "$json"
+	for mem in ${mems[@]}; do
+		check_sha "$mem" "$file"
+	done
+	rm "$file"
+}
+
+test_cancel()
+{
+	file="$(mk_fw_file 16)"
+	mem="$(find_memdevs 1)"
+	json=$(do_update_fw -F "$file" "$mem")
+	validate_fw_update_in_progress "$json"
+	do_update_fw --cancel "$mem"
+	# cancellation is asynchronous, and the result looks the same as idle
+	wait_complete "$mem" 15
+	validate_fw_update_idle "$("$CXL" list -m "$mem" -F)"
+	# no need to check_sha
+	rm "$file"
+}
+
+test_blocking_update
+test_nonblocking_update
+test_multiple_memdev
+test_cancel
+
+check_dmesg "$LINENO"
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index a956885..0f4d3c4 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -155,6 +155,7 @@ cxl_sysfs = find_program('cxl-region-sysfs.sh')
 cxl_labels = find_program('cxl-labels.sh')
 cxl_create_region = find_program('cxl-create-region.sh')
 cxl_xor_region = find_program('cxl-xor-region.sh')
+cxl_update_firmware = find_program('cxl-update-firmware.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -198,6 +199,7 @@ if get_option('destructive').enabled()
 
   tests += [
     [ 'firmware-update.sh',     firmware_update,	  'ndctl' ],
+    [ 'cxl-update-firmware.sh', cxl_update_firmware,      'cxl'   ],
     [ 'pmem-ns',           pmem_ns,	   'ndctl' ],
     [ 'sub-section.sh',    sub_section,	   'dax'   ],
     [ 'dax-dev',           dax_dev,	   'dax'   ],

-- 
2.40.1

