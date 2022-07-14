Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55BD6002
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 17:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657818192; x=1689354192;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SXHtWpv2HNpUil832VHGH8Vd9M5eM5+D7bANZc7UQtE=;
  b=DmBMbNb/1qbFt//UHtH1HVzoRF7eCABjjCF358LS2rnb4sjuRnkNjTgJ
   9gfwFRPDwT+j/U93NfHyrvq5tCaNGdK784bSgX8/5rckeOU7zhPZGjVtx
   5hs38mmHH03dVIe/0NrUOswGF12YW7Bt+WE7T/UNKe/b/nWO0oJSwNRHT
   Hcpje5xQCF6R4wFTTY5Z5By/KM4IlzjtfaLwRZNc3Lbp8oN0eQx4va+xV
   2/pqJ7j5EoqCqfxj54NimEW3yG2e7JWAgwCc9SDtyOhVOcI89tIOCMTia
   fIbwkMmVbbaT8qUGRM1qnPQMkXmtYHkntvGom2fACK+vQ0jkxv8wjt+95
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="371889778"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="371889778"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:55 -0700
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="772694252"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:55 -0700
Subject: [ndctl PATCH v2 12/12] cxl/test: Checkout region setup/teardown
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Thu, 14 Jul 2022 10:02:55 -0700
Message-ID: <165781817516.1555691.3557156570639615515.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
References: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Exercise the fundamental region provisioning sysfs mechanisms of discovering
available DPA capacity, allocating DPA to a region, and programming HDM
decoders.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/cxl-region-sysfs.sh |  122 ++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build         |    2 +
 2 files changed, 124 insertions(+)
 create mode 100644 test/cxl-region-sysfs.sh

diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
new file mode 100644
index 000000000000..2582edb3f306
--- /dev/null
+++ b/test/cxl-region-sysfs.sh
@@ -0,0 +1,122 @@
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
+# THEORY OF OPERATION: Create a x8 interleave across the pmem capacity
+# of the 8 endpoints defined by cxl_test, commit the decoders (which
+# just stubs out the actual hardware programming aspect, but updates the
+# driver state), and then tear it all down again. As with other cxl_test
+# tests if the CXL topology in tools/testing/cxl/test/cxl.c ever changes
+# then the paired update must be made to this test.
+
+# find the root decoder that spans both test host-bridges and support pmem
+decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+	  select(.pmem_capable == true) |
+	  select(.nr_targets == 2) |
+	  .decoder")
+
+# find the memdevs mapped by that decoder
+readarray -t mem < <($CXL list -M -d $decoder | jq -r ".[].memdev")
+
+# ask cxl reserve-dpa to allocate pmem capacity from each of those memdevs
+readarray -t endpoint < <($CXL reserve-dpa -t pmem ${mem[*]} -s $((256<<20)) |
+			  jq -r ".[] | .decoder.decoder")
+
+# instantiate an empty region
+region=$(cat /sys/bus/cxl/devices/$decoder/create_pmem_region)
+echo $region > /sys/bus/cxl/devices/$decoder/create_pmem_region
+uuidgen > /sys/bus/cxl/devices/$region/uuid
+
+# setup interleave geometry
+nr_targets=${#endpoint[@]}
+echo $nr_targets > /sys/bus/cxl/devices/$region/interleave_ways
+g=$(cat /sys/bus/cxl/devices/$decoder/interleave_granularity)
+echo $g > /sys/bus/cxl/devices/$region/interleave_granularity
+echo $((nr_targets * (256<<20))) > /sys/bus/cxl/devices/$region/size
+
+# grab the list of memdevs grouped by host-bridge interleave position
+port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+	    .targets | .[] | select(.position == 0) | .target")
+port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
+	    .targets | .[] | select(.position == 1) | .target")
+readarray -t mem_sort0 < <($CXL list -M -p $port_dev0 | jq -r ".[] | .memdev")
+readarray -t mem_sort1 < <($CXL list -M -p $port_dev1 | jq -r ".[] | .memdev")
+
+# TODO: add a cxl list option to list memdevs in valid region provisioning
+# order, hardcode for now.
+mem_sort=()
+mem_sort[0]=${mem_sort0[0]}
+mem_sort[1]=${mem_sort1[0]}
+mem_sort[2]=${mem_sort0[2]}
+mem_sort[3]=${mem_sort1[2]}
+mem_sort[4]=${mem_sort0[1]}
+mem_sort[5]=${mem_sort1[1]}
+mem_sort[6]=${mem_sort0[3]}
+mem_sort[7]=${mem_sort1[3]}
+
+# TODO: use this alternative memdev ordering to validate a negative test for
+# specifying invalid positions of memdevs
+#mem_sort[2]=${mem_sort0[0]}
+#mem_sort[1]=${mem_sort1[0]}
+#mem_sort[0]=${mem_sort0[2]}
+#mem_sort[3]=${mem_sort1[2]}
+#mem_sort[4]=${mem_sort0[1]}
+#mem_sort[5]=${mem_sort1[1]}
+#mem_sort[6]=${mem_sort0[3]}
+#mem_sort[7]=${mem_sort1[3]}
+
+# re-generate the list of endpoint decoders in region position programming order
+endpoint=()
+for i in ${mem_sort[@]}
+do
+	readarray -O ${#endpoint[@]} -t endpoint < <($CXL list -Di -d endpoint -m $i | jq -r ".[] |
+						     select(.mode == \"pmem\") | .decoder")
+done
+
+# attach all endpoint decoders to the region
+pos=0
+for i in ${endpoint[@]}
+do
+	echo $i > /sys/bus/cxl/devices/$region/target$pos
+	pos=$((pos+1))
+done
+echo "$region added ${#endpoint[@]} targets: ${endpoint[@]}"
+
+# walk up the topology and commit all decoders
+echo 1 > /sys/bus/cxl/devices/$region/commit
+
+# walk down the topology and de-commit all decoders
+echo 0 > /sys/bus/cxl/devices/$region/commit
+
+# remove endpoints from the region
+pos=0
+for i in ${endpoint[@]}
+do
+	echo "" > /sys/bus/cxl/devices/$region/target$pos
+	pos=$((pos+1))
+done
+
+# release DPA capacity
+readarray -t endpoint < <($CXL free-dpa -t pmem ${mem[*]} |
+			  jq -r ".[] | .decoder.decoder")
+echo "$region released ${#endpoint[@]} targets: ${endpoint[@]}"
+
+# validate no WARN or lockdep report during the run
+log=$(journalctl -r -k --since "-$((SECONDS+1))s")
+grep -q "Call Trace" <<< $log && err "$LINENO"
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index 210dcb0b5ff1..3203d9cea243 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -151,6 +151,7 @@ max_extent = find_program('max_available_extent_ns.sh')
 pfn_meta_errors = find_program('pfn-meta-errors.sh')
 track_uuid = find_program('track-uuid.sh')
 cxl_topo = find_program('cxl-topology.sh')
+cxl_sysfs = find_program('cxl-region-sysfs.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -176,6 +177,7 @@ tests = [
   [ 'pfn-meta-errors.sh',     pfn_meta_errors,	  'ndctl' ],
   [ 'track-uuid.sh',          track_uuid,	  'ndctl' ],
   [ 'cxl-topology.sh',	      cxl_topo,		  'cxl'   ],
+  [ 'cxl-region-sysfs.sh',    cxl_sysfs,	  'cxl'   ],
 ]
 
 if get_option('destructive').enabled()

