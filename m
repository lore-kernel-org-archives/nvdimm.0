Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C462A612E5;
	Mon,  4 Mar 2024 17:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709573813; cv=none; b=LpRmQb0CyatZF+tp972FnF5rBLMUvO46/MW7MNiHE6rLraTvPoFpKBVljSiSEFD36N4ItyssackO1Az2pxZRqN2aYibOW0IcOvkMRt/fzmdhZoxlML1Qmq3fGxjTC8Dl29x1dKfgrlvC+5WzW67TvNLwzNjoaBALJl+oGuhmLQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709573813; c=relaxed/simple;
	bh=P32Wo1VdeIxAyw+sFnzGc9dlIaUP64tLNplkjUGoxkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnYfnBVGesg4Mz+oaD+fwO+VFy00wfOEjf71nQIqFaWnG6PwAfTnTJfTBSL5rRhpUvgpm0NEvGhsucodwAgBjz8Z9S9uJK4E+C7zZdIw0Sw7MwUkU3ECxbYUxWqf4JH+e9nqm/5MfW3GmZkGaGeaW4LTqMTxT5ZVspzxjrB4VuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A195C433C7;
	Mon,  4 Mar 2024 17:36:52 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Subject: [NDCTL PATCH v9 4/4] ndctl: add test for qos_class in CXL test suite
Date: Mon,  4 Mar 2024 10:35:35 -0700
Message-ID: <20240304173618.1580662-5-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240304173618.1580662-1-dave.jiang@intel.com>
References: <20240304173618.1580662-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tests in cxl-qos-class.sh to verify qos_class are set with the fake
qos_class create by the kernel.  Root decoders should have qos_class
attribute set. Memory devices should have ram_qos_class or pmem_qos_class
set depending on which partitions are valid.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/common           |  4 ++
 test/cxl-qos-class.sh | 99 +++++++++++++++++++++++++++++++++++++++++++
 test/meson.build      |  2 +
 3 files changed, 105 insertions(+)
 create mode 100755 test/cxl-qos-class.sh

diff --git a/test/common b/test/common
index f1023ef20f7e..5694820c7adc 100644
--- a/test/common
+++ b/test/common
@@ -150,3 +150,7 @@ check_dmesg()
 	grep -q "Call Trace" <<< $log && err $1
 	true
 }
+
+
+# CXL COMMON
+TEST_QOS_CLASS=42
diff --git a/test/cxl-qos-class.sh b/test/cxl-qos-class.sh
new file mode 100755
index 000000000000..fbc0e50b7fe4
--- /dev/null
+++ b/test/cxl-qos-class.sh
@@ -0,0 +1,99 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Intel Corporation. All rights reserved.
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
+
+modprobe -r cxl_test
+modprobe cxl_test
+rc=1
+
+check_qos_decoders () {
+	# check root decoders have expected fake qos_class
+	# also make sure the number of root decoders equal to the number
+	# with qos_class found
+	json=$($CXL list -b cxl_test -D -d root)
+	decoders=$(echo "$json" | jq length)
+	count=0
+	while read -r qos_class; do
+		if [[ "$qos_class" != "$TEST_QOS_CLASS" ]]; then
+			err "$LINENO"
+		fi
+		count=$((count+1))
+	done <<< "$(echo "$json" | jq -r '.[] | .qos_class')"
+
+	if [[ "$count" != "$decoders" ]]; then
+		err "$LINENO"
+	fi
+}
+
+check_qos_memdevs () {
+	# Check that memdevs that expose ram_qos_class or pmem_qos_class have
+	# expected fake value programmed.
+	json=$(cxl list -b cxl_test -M)
+	ram_size=$(jq ".[] | .ram_size" <<< $json)
+	ram_qos_class=$(jq ".[] | .ram_qos_class" <<< $json)
+	pmem_size=$(jq ".[] | .pmem_size" <<< $json)
+	pmem_qos_class=$(jq ".[] | .pmem_qos_class" <<< $json)
+
+	if [[ "$ram_size" != null ]] && ((ram_qos_class != TEST_QOS_CLASS)); then
+		err "$LINENO"
+	fi
+
+	if [[ "$pmem_size" != null ]] && ((pmem_qos_class != TEST_QOS_CLASS)); then
+		err "$LINENO"
+	fi
+}
+
+# Based on cxl-create-region.sh create_single()
+destroy_regions()
+{
+	if [[ "$*" ]]; then
+		$CXL destroy-region -f -b cxl_test "$@"
+	else
+		$CXL destroy-region -f -b cxl_test all
+	fi
+}
+
+create_region_check_qos()
+{
+	# Find an x1 decoder
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r "[ .[] |
+		  select(.max_available_extent > 0) |
+		  select(.pmem_capable == true) |
+		  select(.nr_targets == 1) ] |
+		  .[0].decoder")
+
+	# Find a memdev for this host-bridge
+	port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+		    .targets | .[] | select(.position == 0) | .target")
+	mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
+	memdevs="$mem0"
+
+	# Send create-region with -Q to enforce qos_class matching
+	region=$($CXL create-region -Q -d $decoder -m $memdevs | jq -r ".region")
+	if [[ ! $region ]]; then
+		echo "failed to create region"
+		err "$LINENO"
+	fi
+
+	destroy_regions "$region"
+}
+
+check_qos_decoders
+
+check_qos_memdevs
+
+create_region_check_qos
+
+check_dmesg "$LINEO"
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index 5eb35749a95b..4892df11119f 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -160,6 +160,7 @@ cxl_events = find_program('cxl-events.sh')
 cxl_poison = find_program('cxl-poison.sh')
 cxl_sanitize = find_program('cxl-sanitize.sh')
 cxl_destroy_region = find_program('cxl-destroy-region.sh')
+cxl_qos_class = find_program('cxl-qos-class.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -192,6 +193,7 @@ tests = [
   [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
   [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
   [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
+  [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.43.0

