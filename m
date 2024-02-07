Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A09811EC;
	Wed,  7 Feb 2024 17:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707326469; cv=none; b=KPMoBvnxzbBGkJZT7tfz0a1kzbyL38QdpRJyIy+yM05lFL5S8sixmAZTb20thh2PpB5mlWMPnpqbJ98o99N4c4kLMoiOhICdeEqDKHlWP8VIZL0topa9PHwyleTzXggXF7nkUFCAbX2EtDPVuB6KsYFwoW8rBFVLpDxJwh7SCHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707326469; c=relaxed/simple;
	bh=b8UfCr2t7S4sKTEIOAIDKV8lsreYiDRda3Nn/416UAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8lNqpclV7tB+00l17t+AQJHXp/ZDYDjyzt+zpOPE5tsou94eF4Z1n58VTjndcxWHuDE0bOCrw4Ir04YXCrte0ZMyb+YJfrF5nD7nBt2MHilJY0I1dbwkZH67saJWpAzQAz7t/SwM44vYaxqsdZr2/hp7MdD/lXD8qC5yvUZBqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DB6C433F1;
	Wed,  7 Feb 2024 17:21:08 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Subject: [NDCTL PATCH v6 4/4] ndctl: add test for qos_class in CXL test suite
Date: Wed,  7 Feb 2024 10:19:39 -0700
Message-ID: <20240207172055.1882900-5-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240207172055.1882900-1-dave.jiang@intel.com>
References: <20240207172055.1882900-1-dave.jiang@intel.com>
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
v5:
- Split out from cxl-topology.sh (Vishal)
---
 test/common           |  4 +++
 test/cxl-qos-class.sh | 65 +++++++++++++++++++++++++++++++++++++++++++
 test/meson.build      |  2 ++
 3 files changed, 71 insertions(+)
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
index 000000000000..365a7df9c1e4
--- /dev/null
+++ b/test/cxl-qos-class.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Intel Corporation. All rights reserved.
+
+check_qos_decoders () {
+	# check root decoders have expected fake qos_class
+	# also make sure the number of root decoders equal to the number
+	# with qos_class found
+	json=$($CXL list -b cxl_test -D -d root)
+	decoders=$(echo "$json" | jq length)
+	count=0
+	while read -r qos_class
+	do
+		((qos_class == TEST_QOS_CLASS)) || err "$LINENO"
+		count=$((count+1))
+	done <<< "$(echo "$json" | jq -r '.[] | .qos_class')"
+
+	((count == decoders)) || err "$LINENO";
+}
+
+check_qos_memdevs () {
+	# Check that memdevs that expose ram_qos_class or pmem_qos_class have
+	# expected fake value programmed.
+	json=$(cxl list -b cxl_test -M)
+	readarray -t lines < <(jq ".[] | .ram_size, .pmem_size, .ram_qos_class, .pmem_qos_class" <<<"$json")
+	for (( i = 0; i < ${#lines[@]}; i += 4 ))
+	do
+		ram_size=${lines[i]}
+		pmem_size=${lines[i+1]}
+		ram_qos_class=${lines[i+2]}
+		pmem_qos_class=${lines[i+3]}
+
+		if [[ "$ram_size" != null ]]
+		then
+			((ram_qos_class == TEST_QOS_CLASS)) || err "$LINENO"
+		fi
+		if [[ "$pmem_size" != null ]]
+		then
+			((pmem_qos_class == TEST_QOS_CLASS)) || err "$LINENO"
+		fi
+	done
+}
+
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
+check_qos_decoders
+
+check_qos_memdevs
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

