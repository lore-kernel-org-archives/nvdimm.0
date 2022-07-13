Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327EA7A
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 07:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657698721; x=1689234721;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NqigUAdEDXdw5FweWIzhNROtpMXs2hUUrd59Qm+5Pis=;
  b=ggk48M2wiEY6Tv1zmMdgb1w+ypgKiCC1p7qoTFoGaaLIwUDgwFy7Szsc
   V7nJfc+FoXSRexC0vqRj0GdU6U7hGt2PAlZdM396/o5UCJW386YCn4XYA
   SdXcMfovrfOgrIbBVkxuBNC3nXcJR09fFj9mIIdqOJT1bfn5X7e7ic/y5
   Ryia2OyaDyPKhYAT78kf19iceP+LnT7y/40kIhIyBzc0Rldxsw7DtU5I9
   x2iTTDs0VmtRMyBcNY2552T5pO5tZLtu+v88kKfG1xoxjX7X35ybRSZCL
   Ybe+D4EIOFTv4rKtd2wlmL1ulIEtQ/VcJ9JB8Dyzk8SBjkqF4/cE4LJDE
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="346822790"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="346822790"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 00:52:00 -0700
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="653267389"
Received: from atang28-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.213.168.179])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 00:52:00 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] cxl/test: add a test to {read,write,zero}-labels
Date: Wed, 13 Jul 2022 01:51:57 -0600
Message-Id: <20220713075157.411479-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2532; h=from:subject; bh=NqigUAdEDXdw5FweWIzhNROtpMXs2hUUrd59Qm+5Pis=; b=owGbwMvMwCXGf25diOft7jLG02pJDEnnKmdcP5a+qE7kuMLjoAdi18RWiwuuvsRofVNPssplyk4Z 93PVHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiI2WeGf2Z64YlPXLxUtvF5FQfMnl j95+fvM3piTfs0TtxoOcR8SIThv+fnn7KrrSbsvHP2N9/6z72ulZHZgq6xRx783cu7wmnST1YA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a unit test to test writing, reading, and zeroing LSA aread for
cxl_test based memdevs using ndctl commands.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/cxl-labels.sh | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build   |  2 ++
 2 files changed, 55 insertions(+)
 create mode 100644 test/cxl-labels.sh

diff --git a/test/cxl-labels.sh b/test/cxl-labels.sh
new file mode 100644
index 0000000..ce73963
--- /dev/null
+++ b/test/cxl-labels.sh
@@ -0,0 +1,53 @@
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

