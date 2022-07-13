Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1C928E1
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 20:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657744692; x=1689280692;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xWx7tQXWKJpmldftLea6k7fwymKShodMXw/tMKE/N/c=;
  b=VQHJlOktSxGY7revysweDx2gF5hOGIY6vVP3gT1Sx/Kt3bFvjGjLY8+z
   aKwrHf6v5F/HIWGkBt87yFR6Jg7lXtMpMOnOMkXSEY597neXeMDpWcAe3
   AUADvEEQjehbjrrCXZ8WmK3tQl+XZZg6+LvhYgq4EfH1i1onA6GWuIEjn
   8nH9RXopUUAKeL9UB0Ua4a1CG+G4LUYCgiLXHSoLjuAOQ2HlvTef+yNvs
   DGW2/5I58sBOzKueve9ktynlDJeht8ip2Y9GXaHLwqgEeQ4jpAT1pIvDd
   1fW+2EoaRfgIXUpMu7Kz9kuVEyjPpIpsROxzXR4axEc34R5bpZUD1Q+jM
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="265128789"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="265128789"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 13:38:11 -0700
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="545996157"
Received: from ddvanett-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.71.157])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 13:38:10 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	dave@stgolabs.net,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2] cxl/test: add a test to {read,write,zero}-labels
Date: Wed, 13 Jul 2022 14:37:58 -0600
Message-Id: <20220713203758.519892-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3380; h=from:subject; bh=xWx7tQXWKJpmldftLea6k7fwymKShodMXw/tMKE/N/c=; b=owGbwMvMwCXGf25diOft7jLG02pJDEnnddWYytS41Y3U7CdZPDRh59PtqJmY8XXb0aXTln7m53y6 LDOmo5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABPh+cLwV3K3YfO3Hountb+e8a9j/B KzNe9lu/AJgX9npE4t/qNavIfhf0WP+v+IiDt9r7I/Fi1p4OqxXe1bsvtfppjv5OOBPz/pMQAA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a unit test to test writing, reading, and zeroing LSA aread for
cxl_test based memdevs using ndctl commands, and reading using cxl-cli
commands to exercise that route as much as possible.

Note that writing using cxl-cli requires a bit more enabling to enable,
as the corresponding nvdimm-bridge object will need to be disabled
first.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/cxl-labels.sh | 69 ++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build   |  2 ++
 2 files changed, 71 insertions(+)
 create mode 100644 test/cxl-labels.sh

Changes since v1[1]:
- Collect Reviewed-by's
- Add a read-labels using cxl-cli in addition to the ndctl operations.

[1]: https://lore.kernel.org/linux-cxl/20220713075157.411479-1-vishal.l.verma@intel.com/

diff --git a/test/cxl-labels.sh b/test/cxl-labels.sh
new file mode 100644
index 0000000..e782e2d
--- /dev/null
+++ b/test/cxl-labels.sh
@@ -0,0 +1,69 @@
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
+test_label_ops()
+{
+	nmem="$1"
+	lsa=$(mktemp /tmp/lsa-$nmem.XXXX)
+	lsa_read=$(mktemp /tmp/lsa-read-$nmem.XXXX)
+
+	# determine LSA size
+	"$NDCTL" read-labels -o "$lsa_read" "$nmem"
+	lsa_size=$(stat -c %s "$lsa_read")
+
+	dd "if=/dev/urandom" "of=$lsa" "bs=$lsa_size" "count=1"
+	"$NDCTL" write-labels -i "$lsa" "$nmem"
+	"$NDCTL" read-labels -o "$lsa_read" "$nmem"
+
+	# compare what was written vs read
+	diff "$lsa" "$lsa_read"
+
+	# zero the LSA and test
+	"$NDCTL" zero-labels "$nmem"
+	dd "if=/dev/zero" "of=$lsa" "bs=$lsa_size" "count=1"
+	"$NDCTL" read-labels -o "$lsa_read" "$nmem"
+	diff "$lsa" "$lsa_read"
+
+	# cleanup
+	rm "$lsa" "$lsa_read"
+}
+
+test_label_ops_cxl()
+{
+	mem="$1"
+	lsa_read=$(mktemp /tmp/lsa-read-$mem.XXXX)
+
+	"$CXL" read-labels -o "$lsa_read" "$mem"
+	rm "$lsa_read"
+}
+
+# test reading labels directly through cxl-cli
+readarray -t mems < <("$CXL" list -b cxl_test -Mi | jq -r '.[].memdev')
+
+for mem in ${mems[@]}; do
+	test_label_ops_cxl "$mem"
+done
+
+# find nmem devices corresponding to cxl memdevs
+readarray -t nmems < <("$NDCTL" list -b cxl_test -Di | jq -r '.[].dev')
+
+for nmem in ${nmems[@]}; do
+	test_label_ops "$nmem"
+done
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index fbcfc08..687a71f 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -152,6 +152,7 @@ pfn_meta_errors = find_program('pfn-meta-errors.sh')
 track_uuid = find_program('track-uuid.sh')
 cxl_topo = find_program('cxl-topology.sh')
 cxl_region = find_program('cxl-region-create.sh')
+cxl_labels = find_program('cxl-labels.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -178,6 +179,7 @@ tests = [
   [ 'track-uuid.sh',          track_uuid,	  'ndctl' ],
   [ 'cxl-topology.sh',	      cxl_topo,		  'cxl'   ],
   [ 'cxl-region-create.sh',   cxl_region,	  'cxl'   ],
+  [ 'cxl-labels.sh',          cxl_labels,	  'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.36.1

