Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C2A1CAA7D
	for <nvdimm@lists.linux.dev>; Wed,  1 Jul 2026 04:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782880937; cv=none; b=WzPNYVyl1I7PyjLbJnL8MFIlKzPWBr84M2F/q0t9b9NBErOfS2JLVRY9wivJFytVc11P9KxCrNHDRec4FMVIHEcrT9WSwXDK9RWsEvaPdfwdT3xSLLyCn6CjVVAey8sAgjyLrVbfUtyp19NQjVhIKAVgLiYOLYIUHV7SniFcSpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782880937; c=relaxed/simple;
	bh=ghq/OG98GWLYP09JXIbbtHNZyBgDF5ppJNG3bpPzzPw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qhoeSbWvsEisu7BPLIui/4lsR7GmPR5t+lteyX6WprDSHa+A7pzorYh55/FpjDzQfMp0sJrzDBE0oZBs8u5RVuIZb6Vg4aDe6KqEusLtBLJPgfnS/FsYIDLqvbpqDxbchxj8EwitfkUlTk6ZQ7TE6TtxDhNol+ALHXvzZZ+ACjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n4i24Lu5; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n4i24Lu5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782880936; x=1814416936;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ghq/OG98GWLYP09JXIbbtHNZyBgDF5ppJNG3bpPzzPw=;
  b=n4i24Lu5TYoT95d+yCJUf5wyYoVJCqs3MXrj8Zndqi6Qf5J4IpJOTGox
   leJdlTrfjAeBm+FG3hKuuECWhquce050XHflQqlVk2/di5Qi0rg4p4Dwd
   t7XyZOp1b8Q6PGmvdsKgjV+6y6NJJf6koZm8++fa4ZpIYbKNPwzL+8QAQ
   EZ8QnJYpwQtZ45H8zn+ZDajZlh0MmCNIDx20yX+zFRPFHcuVKkcq4hWJ3
   1G7KTUZjy3rKSqOePpvNvLqzUUAqYffsMdHtKkDrbQPBkFG9hJrGk5ADt
   NZQ9CWISxQjOLEFfpIIHxfqdYKXUX5g85BQTIIsXSG7rA5F/rLKMU7Dia
   g==;
X-CSE-ConnectionGUID: tjvhrBYSTCiOQ1euTPDbmQ==
X-CSE-MsgGUID: PaCK158lRLinBkJx1fYxzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="83738120"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="83738120"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:42:15 -0700
X-CSE-ConnectionGUID: 7/Dpd1gURUC9bRlpwcpJjA==
X-CSE-MsgGUID: 8c0OlzJ9S4CHtBdp/Q9usA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="256811594"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.46])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:42:14 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
	Richard Cheng <icheng@nvidia.com>
Subject: [ndctl PATCH] test/cxl-poison.sh: test scanning past fully mapped partitions
Date: Tue, 30 Jun 2026 21:42:02 -0700
Message-ID: <20260701044205.1589967-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Listing poison by memdev scans the unmapped tail of every partition.
When an earlier partition is fully mapped, its tail is zero length, but
the scan must continue to later partitions. A regression caused the
scan to stop at the first fully-mapped partition, leaving later
partitions unscanned.

Backstop that behavior with a test case that fully maps a memdev's RAM
partition so its unmapped tail is zero length, then injects poison into
the unmapped PMEM partition that follows. The PMEM poison is only
reported if the scan continues past the fully-mapped RAM partition.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-poison.sh | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 49aa1b68c5c1..a03e08084eb4 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -219,6 +219,45 @@ test_poison_by_region_offset_negative()
 	clear_poison "$region" "$large_offset" true
 }
 
+# Backstop a driver fix where a fully mapped partition prematurely
+# terminated the unmapped poison scan.
+test_poison_unmapped_later_partition()
+{
+	local decoder ram_size pmem_dpa
+
+	check_min_kver "7.3" || return 0
+
+	# Free the auto region to use the ram capacity
+	$CXL destroy-region -f -b "$CXL_TEST_BUS" all
+
+	find_memdev
+
+	# Fully map the ram partition so it has a zero-length unmapped tail
+	decoder=$($CXL list -b "$CXL_TEST_BUS" -D -d root -m "$memdev" |
+		  jq -r ".[] |
+		  select(.volatile_capable == true) |
+		  select(.nr_targets == 1) |
+		  .decoder")
+	[[ -n "$decoder" && "$decoder" != "null" ]] ||
+		do_skip "no x1 volatile decoder found"
+
+	ram_size=$($CXL list -m "$memdev" | jq -r ".[0].ram_size")
+	[[ -n "$ram_size" && "$ram_size" != "null" ]] || err "$LINENO"
+
+	region=$($CXL create-region -t ram -d "$decoder" -m "$memdev" \
+		 -s "$ram_size" | jq -r ".region")
+	[[ -n "$region" && "$region" != "null" ]] || err "$LINENO"
+
+	# Poison the unmapped pmem tail
+	pmem_dpa=$ram_size
+	inject_poison "$memdev" "$pmem_dpa"
+	validate_poison_found "-m $memdev" 1
+	clear_poison "$memdev" "$pmem_dpa"
+	validate_poison_found "-m $memdev" 0
+
+	$CXL destroy-region -f -b "$CXL_TEST_BUS" "$region"
+}
+
 is_unaligned() {
 	local region=$1
 	local hbiw=$2
@@ -332,6 +371,7 @@ run_poison_test()
 		do_skip "test cases requires inject by region kernel support"
 	test_poison_by_region_offset
 	test_poison_by_region_offset_negative
+	test_poison_unmapped_later_partition
 }
 
 modprobe -r cxl_test

base-commit: 15e932c4e1318a9608ad9b799ad83a32a8b5970d
-- 
2.37.3

