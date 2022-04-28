Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F4D3D60
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 22:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651183854; x=1682719854;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6EmxZJQM6gbeuuBnZcbUrwJkT+T3QCR3Fl3Sx8kLU8s=;
  b=gZGh6vS+aG6qlZB5U09aCtCtFZqujPAoGa0qumhxeq72UHWaybK/ZvQP
   YahmTkRPVz5ouPMq+KPeFoJTPGkfRMx4qdREUsA0WVyXNjOAkYCqzaDHW
   C89sMLFXAz77dEgksFvKKG4vaC6+4tVPz55T2j1JwQoLlAki1DHJmJSNL
   qk/MF+XvkIzsjdZ5AQaG1S1X8Fw8oNr2FVGb8JsXQPG1uoMP/xCScd2Ol
   Y+kpvk+mx7eL0UKYyypAxnUfGj7P2yfTZ3AyPjOzERAJMqoIKFYqGo1rb
   5wYBKWZ5km8vFT4u0I7l1BfioJ3VSsw86RMY+zTMV3Ud/LKtzPTKtIK7q
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="253823647"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="253823647"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:54 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="731735723"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:54 -0700
Subject: [ndctl PATCH 10/10] cxl/test: Add topology enumeration and hotplug
 test
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Thu, 28 Apr 2022 15:10:54 -0700
Message-ID: <165118385401.1676208.9224280236045777443.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Test the re-plug of memdevs, switch ports, root ports, and bus objects.

Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/common          |   12 ++++
 test/cxl-topology.sh |  166 ++++++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build     |    2 +
 3 files changed, 180 insertions(+)
 create mode 100644 test/cxl-topology.sh

diff --git a/test/common b/test/common
index fb487958a29b..65615cc09a3e 100644
--- a/test/common
+++ b/test/common
@@ -27,6 +27,18 @@ if [ -z $DAXCTL ]; then
 	fi
 fi
 
+# CXL
+if [ -z $CXL ]; then
+	if [ -f "../cxl/cxl" ] && [ -x "../cxl/cxl" ]; then
+		export CXL=../cxl/cxl
+	elif [ -f "./cxl/cxl" ] && [ -x "./cxl/cxl" ]; then
+		export CXL=./cxl/cxl
+	else
+		echo "Couldn't find a cxl binary"
+		exit 1
+	fi
+fi
+
 if [ -z $TEST_PATH ]; then
 	export TEST_PATH=.
 fi
diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
new file mode 100644
index 000000000000..ff11614f4f14
--- /dev/null
+++ b/test/cxl-topology.sh
@@ -0,0 +1,166 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2022 Intel Corporation. All rights reserved.
+
+. $(dirname $0)/common
+
+rc=1
+
+set -ex
+
+trap 'err $LINENO' ERR
+
+check_prereq "jq"
+
+modprobe -r cxl_test
+modprobe cxl_test
+udevadm settle
+
+# THEORY OF OPERATION: Validate the hard coded assumptions of the
+# cxl_test.ko module that defines its topology in
+# tools/testing/cxl/test/cxl.c. If that model ever changes then the
+# paired update must be made to this test.
+
+# collect cxl_test root device id
+json=$($CXL list -b cxl_test)
+count=$(jq "length" <<< $json)
+((count == 1)) || err "$LINENO"
+root=$(jq -r ".[] | .bus" <<< $json)
+
+
+# validate 2 host bridges under a root port
+port_sort="sort_by(.port | .[4:] | tonumber)"
+json=$($CXL list -b cxl_test -BP)
+count=$(jq ".[] | .[\"ports:$root\"] | length" <<< $json)
+((count == 2)) || err "$LINENO"
+
+bridge[0]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[0].port" <<< $json)
+bridge[1]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[1].port" <<< $json)
+
+
+# validate 2 root ports per host bridge
+json=$($CXL list -b cxl_test -T -p ${bridge[0]})
+count=$(jq ".[] | .dports | length" <<< $json)
+((count == 2)) || err "$LINENO"
+
+json=$($CXL list -b cxl_test -T -p ${bridge[1]})
+count=$(jq ".[] | .dports | length" <<< $json)
+((count == 2)) || err "$LINENO"
+
+
+# validate 2 switches per-root port
+json=$($CXL list -b cxl_test -P -p ${bridge[0]})
+count=$(jq ".[] | .[\"ports:${bridge[0]}\"] | length" <<< $json)
+((count == 2)) || err "$LINENO"
+
+switch[0]=$(jq -r ".[] | .[\"ports:${bridge[0]}\"] | $port_sort | .[0].host" <<< $json)
+switch[1]=$(jq -r ".[] | .[\"ports:${bridge[0]}\"] | $port_sort | .[1].host" <<< $json)
+
+json=$($CXL list -b cxl_test -P -p ${bridge[1]})
+count=$(jq ".[] | .[\"ports:${bridge[1]}\"] | length" <<< $json)
+((count == 2)) || err "$LINENO"
+
+switch[2]=$(jq -r ".[] | .[\"ports:${bridge[1]}\"] | $port_sort | .[0].host" <<< $json)
+switch[3]=$(jq -r ".[] | .[\"ports:${bridge[1]}\"] | $port_sort | .[1].host" <<< $json)
+
+
+# check that all 8 cxl_test memdevs are enabled by default and have a
+# pmem size of 256M
+json=$($CXL list -b cxl_test -M)
+count=$(jq "map(select(.pmem_size == $((256 << 20)))) | length" <<< $json)
+((count == 8)) || err "$LINENO"
+
+
+# validate the expected properties of the 4 root decoders
+json=$($CXL list -b cxl_test -D -d root)
+port_id=${root:4}
+port_id_len=${#port_id}
+decoder_sort="sort_by(.decoder | .[$((8+port_id_len)):] | tonumber)"
+count=$(jq "[ $decoder_sort | .[0] |
+	select(.volatile_capable == true) |
+	select(.size == $((256 << 20))) |
+	select(.nr_targets == 1) ] | length" <<< $json)
+((count == 1)) || err "$LINENO"
+
+count=$(jq "[ $decoder_sort | .[1] |
+	select(.volatile_capable == true) |
+	select(.size == $((512 << 20))) |
+	select(.nr_targets == 2) ] | length" <<< $json)
+((count == 1)) || err "$LINENO"
+
+count=$(jq "[ $decoder_sort | .[2] |
+	select(.pmem_capable == true) |
+	select(.size == $((256 << 20))) |
+	select(.nr_targets == 1) ] | length" <<< $json)
+((count == 1)) || err "$LINENO"
+
+count=$(jq "[ $decoder_sort | .[3] |
+	select(.pmem_capable == true) |
+	select(.size == $((512 << 20))) |
+	select(.nr_targets == 2) ] | length" <<< $json)
+((count == 1)) || err "$LINENO"
+
+# check that switch ports disappear after all of their memdevs have been
+# disabled, and return when the memdevs are enabled.
+for s in ${switch[@]}
+do
+	json=$($CXL list -M -p $s)
+	count=$(jq "length" <<< $json)
+	((count == 2)) || err "$LINENO"
+
+	mem[0]=$(jq -r ".[0] | .memdev" <<< $json)
+	mem[1]=$(jq -r ".[1] | .memdev" <<< $json)
+
+	$CXL disable-memdev ${mem[0]} --force
+	json=$($CXL list -p $s)
+	count=$(jq "length" <<< $json)
+	((count == 1)) || err "$LINENO"
+
+	$CXL disable-memdev ${mem[1]} --force
+	json=$($CXL list -p $s)
+	count=$(jq "length" <<< $json)
+	((count == 0)) || err "$LINENO"
+
+	$CXL enable-memdev ${mem[0]}
+	$CXL enable-memdev ${mem[1]}
+
+	json=$($CXL list -p $s)
+	count=$(jq "length" <<< $json)
+	((count == 1)) || err "$LINENO"
+
+	$CXL disable-port $s --force
+	json=$($CXL list -p $s)
+	count=$(jq "length" <<< $json)
+	((count == 0)) || err "$LINENO"
+
+	$CXL enable-memdev ${mem[0]} ${mem[1]}
+	json=$($CXL list -p $s)
+	count=$(jq "length" <<< $json)
+	((count == 1)) || err "$LINENO"
+done
+
+
+# validate host bridge tear down
+for b in ${bridge[@]}
+do
+	$CXL disable-port $b -f
+	json=$($CXL list -M -i -p $b)
+	count=$(jq "map(select(.state == \"disabled\")) | length" <<< $json)
+	((count == 4)) || err "$LINENO"
+
+	$CXL enable-port $b -m
+	json=$($CXL list -M -p $b)
+	count=$(jq "length" <<< $json)
+	((count == 4)) || err "$LINENO"
+done
+
+
+# validate that the bus can be disabled without issue
+$CXL disable-bus $root -f
+
+
+# validate no WARN or lockdep report during the run
+log=$(journalctl -r -k --since "-$((SECONDS+1))s")
+grep -q "Call Trace" <<< $log && err "$LINENO"
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index 7ccd45195236..210dcb0b5ff1 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -150,6 +150,7 @@ monitor = find_program('monitor.sh')
 max_extent = find_program('max_available_extent_ns.sh')
 pfn_meta_errors = find_program('pfn-meta-errors.sh')
 track_uuid = find_program('track-uuid.sh')
+cxl_topo = find_program('cxl-topology.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -174,6 +175,7 @@ tests = [
   [ 'max_extent_ns',          max_extent,	  'ndctl' ],
   [ 'pfn-meta-errors.sh',     pfn_meta_errors,	  'ndctl' ],
   [ 'track-uuid.sh',          track_uuid,	  'ndctl' ],
+  [ 'cxl-topology.sh',	      cxl_topo,		  'cxl'   ],
 ]
 
 if get_option('destructive').enabled()

