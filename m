Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E472125A2
	for <nvdimm@lists.linux.dev>; Wed, 14 Feb 2024 07:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707894894; cv=none; b=GtQ5DdneN4lKBndMDoTHkRPyBRaRwSKy5NPNORSBCxqxHV+jLr1UPTO4+kqC3L6ub3qsrQTLtChnL+RkOh8xZMphYUBLkCnbZdWBtDn5reZn/D5LbKRHf6Rjy8HzQELx9riD4P6AKgKBzB4uIb+KUPN+iTiuR7QAvm6BO7VQDFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707894894; c=relaxed/simple;
	bh=r5sySjqBYGjo/jIQ7WsEmW/3ucA39O36zQf4ZKHKVco=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NPLyt+ne2XYdjPMmQGT9bHoTvNfkcMkNIn0vXkvYAF/7Y9+3DRUJfGL/Llphw4kS3v4IKgtMdUycj9y3yiij4XdxBXOKoJNZojTL2k0goJPbMUJ0x1rT/GgZqo90sg2BrciavthOfiksn7xYn7VtsXU5zdZqyKCfegVDNT5gkCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BGAs36DJ; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BGAs36DJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707894893; x=1739430893;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=r5sySjqBYGjo/jIQ7WsEmW/3ucA39O36zQf4ZKHKVco=;
  b=BGAs36DJX/AXEMH2x3ZnqWM1TUlg4MtLZuQhZN/A35RtTIOhoBxdf0rg
   /Ut1eaA/3hL2ndy0qeAGAWfvlgM38D+pJQyC42zDOylcaR8B+ias4v2KY
   jcnIDi4YalgIDfpYr9M7QqOpCb4UmpEQo5VcpuzXsoOb5ZVmiyTkfbn0Y
   orkRE463DgtA/DHYbVtBZckj88R9G8Ias191+x+LbMxfl/b+Wwop96/9P
   pWpi89yBYPa0qAeNGjB/gew52BSCaJxCeljX/JnXKNCCDTx8e3yG7T1uw
   +CMdIGXjKVOrqyhqsUkyGlqhXTaVpzpazhz3ZXj+0Jh7BCGTimH1ObJ7O
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="1801810"
X-IronPort-AV: E=Sophos;i="6.06,159,1705392000"; 
   d="scan'208";a="1801810"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 23:14:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,159,1705392000"; 
   d="scan'208";a="3086662"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.66.223])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 23:14:50 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH] cxl/test: Add 3-way HB interleave testcase to cxl-xor-region.sh
Date: Tue, 13 Feb 2024 23:14:47 -0800
Message-Id: <20240214071447.1918988-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

cxl-xor-region.sh includes test cases for 1 & 2 way host bridge
interleaves. Add a new test case to exercise the modulo math
function the CXL driver uses to find positions in a 3-way host
bridge interleave.

Skip this test case, don't fail, if the new 3-way XOR decoder
is not present in cxl/test.

Add the missing check_dmesg helper before exiting this test.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-xor-region.sh | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
index 117e7a4bba61..2f3b4aa5208a 100644
--- a/test/cxl-xor-region.sh
+++ b/test/cxl-xor-region.sh
@@ -86,11 +86,44 @@ setup_x4()
         memdevs="$mem0 $mem1 $mem2 $mem3"
 }
 
+setup_x3()
+{
+        # find an x3 decoder
+        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+          select(.pmem_capable == true) |
+          select(.nr_targets == 3) |
+          .decoder")
+
+	if [[ ! $decoder ]]; then
+		echo "no x3 decoder found, skipping xor-x3 test"
+		return
+	fi
+
+        # Find a memdev for each host-bridge interleave position
+        port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
+            .targets | .[] | select(.position == 0) | .target")
+        port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
+            .targets | .[] | select(.position == 1) | .target")
+        port_dev2=$($CXL list -T -d "$decoder" | jq -r ".[] |
+            .targets | .[] | select(.position == 2) | .target")
+	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
+	mem2=$($CXL list -M -p "$port_dev2" | jq -r ".[0].memdev")
+	memdevs="$mem0 $mem1 $mem2"
+}
+
 setup_x1
 create_and_destroy_region
 setup_x2
 create_and_destroy_region
 setup_x4
 create_and_destroy_region
+# x3 decoder may not be available in cxl/test topo yet
+setup_x3
+if [[ $decoder ]]; then
+	create_and_destroy_region
+fi
+
+check_dmesg "$LINENO"
 
 modprobe -r cxl_test
-- 
2.37.3

