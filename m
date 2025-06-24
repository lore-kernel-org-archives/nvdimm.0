Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AD6AD2D
	for <nvdimm@lists.linux.dev>; Tue, 24 Jun 2025 01:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750726879; cv=none; b=U0Cq54AMSPq7DVvs4+HQWJFdys+SxZYYg43z6KYE3CuDu3MsPw8ZQuaO/eDJfhd95FhMqOtCCjnotkAwr54erxRKRPaMQt0PJeE1UpHnXlVOJuIXmVESIRZ5LnfCdJXmjVzxoKcJGEH7jWjFVEE5Uxcw6yq2ZY98j0m28jvDsi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750726879; c=relaxed/simple;
	bh=fxpRsLpuzC02wZQSxojWnb3a1Y/J2cXeGzjvSKAax9s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KZX4uDIxB0iDKXITPtImDuuiKBshpzzrKS635ojC2AlkDdaZSEBVRAUVRri1CXuPHrRxskuzqHI9ratbtQJ9Bj3GY5HgpIv0BxLhaKC5s4dc3p6STBrroiDc3EDVLcoxGlOtYs6C8X++nFAOybN928bN/5jThfau3LfzSLDRDTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R7kU9tvs; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R7kU9tvs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750726878; x=1782262878;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fxpRsLpuzC02wZQSxojWnb3a1Y/J2cXeGzjvSKAax9s=;
  b=R7kU9tvshojags6adJ9kF7j9WSMW6l85kWzyyeH3Obams2FKBKgadBQJ
   oo/jOnphrQRwS60OniR0Gi+XSn3CawfSXLSi7BFhIo/lov6hJKqJjNfJP
   OdkKMQqn0WvkYF3sAD9frdTNAWDrzDjXsT7Ba60yztfawB2QPw8rOCiLj
   ZhCXRfbXIh29xolsMpN1z+qQL++JDQzvX2cqhgGpMFCZQqfZgEYgq6CxV
   q5s0534+xpNSayr/BMLrkFxemAFKF9NBdeRJHJQpNSkc6IDYNTjMqZKiQ
   82Ys3dG0zmtqHbE9a4D1OkmOfjqh4yTRrke/gjI/HFgCMi8yS5wl3anJV
   A==;
X-CSE-ConnectionGUID: f4CgV5J5RVu7tC1lm2VIhA==
X-CSE-MsgGUID: xe6JtyuaRgmsZd4gLol5Kw==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="53083802"
X-IronPort-AV: E=Sophos;i="6.16,260,1744095600"; 
   d="scan'208";a="53083802"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 18:01:18 -0700
X-CSE-ConnectionGUID: n10qOus+T+yMYKMpKG5gfg==
X-CSE-MsgGUID: O+lk+iMHQHqdo52jd0G8Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,260,1744095600"; 
   d="scan'208";a="151237697"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.202])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 18:01:17 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] test/cxl-poison.sh: test inject and clear poison by HPA
Date: Mon, 23 Jun 2025 18:01:12 -0700
Message-ID: <20250624010114.694192-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The CXL kernel driver recently added support to inject and clear
poison in a region by specifying an HPA. Add a test case to the
existing cxl-poison unit test that demonstrates how to use the new
debugfs attributes. Use the kernel trace log to validate the round
trip address translations

SKIP, do not fail, if the new debugfs attributes are not present.

See the kernel ABI documentation for usage:
Documentation/ABI/testing/debugfs-cxl

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-poison.sh | 80 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 69 insertions(+), 11 deletions(-)

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 6ed890bc666c..f1668d000eb8 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -65,18 +65,45 @@ create_x2_region()
 
 inject_poison_sysfs()
 {
-	memdev="$1"
+	dev="$1"
 	addr="$2"
 
-	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
+	echo "$addr" > /sys/kernel/debug/cxl/"$dev"/inject_poison
 }
 
 clear_poison_sysfs()
 {
-	memdev="$1"
+	dev="$1"
 	addr="$2"
 
-	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
+	echo "$addr" > /sys/kernel/debug/cxl/"$dev"/clear_poison
+}
+
+check_trace_entry()
+{
+	expected_region="$1"
+	expected_hpa="$2"
+
+	trace_line=$(grep "cxl_poison" /sys/kernel/tracing/trace | tail -n 1)
+	if [[ -z "$trace_line" ]]; then
+		echo "No cxl_poison trace event found"
+		err "$LINENO"
+	fi
+
+	trace_region=$(echo "$trace_line" | grep -o 'region=[^ ]*' | cut -d= -f2)
+	trace_hpa=$(echo "$trace_line" | grep -o 'hpa=0x[0-9a-fA-F]\+' | cut -d= -f2)
+
+	if [[ "$trace_region" != "$expected_region" ]]; then
+		echo "Expected region $expected_region not found in trace"
+		echo "$trace_line"
+		err "$LINENO"
+	fi
+
+	if [[ "$trace_hpa" != "$expected_hpa" ]]; then
+		echo "Expected HPA $expected_hpa not found in trace"
+		echo "$trace_line"
+		err "$LINENO"
+	fi
 }
 
 validate_poison_found()
@@ -97,7 +124,7 @@ validate_poison_found()
 	fi
 }
 
-test_poison_by_memdev()
+test_poison_by_memdev_by_dpa()
 {
 	find_memdev
 	inject_poison_sysfs "$memdev" "0x40000000"
@@ -113,7 +140,7 @@ test_poison_by_memdev()
 	validate_poison_found "-m $memdev" 0
 }
 
-test_poison_by_region()
+test_poison_by_region_by_dpa()
 {
 	create_x2_region
 	inject_poison_sysfs "$mem0" "0x40000000"
@@ -123,15 +150,46 @@ test_poison_by_region()
 	clear_poison_sysfs "$mem0" "0x40000000"
 	clear_poison_sysfs "$mem1" "0x40000000"
 	validate_poison_found "-r $region" 0
+
+	$CXL destroy-region -f -b cxl_test "$region"
+}
+
+test_poison_by_region_by_hpa()
+{
+	create_x2_region
+
+	[ -f "/sys/kernel/debug/cxl/$region/inject_poison" ] ||
+	       do_skip "test case requires inject by region kernel support"
+
+	base=$(cat /sys/bus/cxl/devices/"$region"/resource)
+	gran=$(cat /sys/bus/cxl/devices/"$region"/interleave_granularity)
+
+	# Test two HPA addresses: base and base + granularity
+	# This hits the two memdevs in the region interleave.
+	hpa1=$(printf "0x%x" $((base)))
+	hpa2=$(printf "0x%x" $((base + gran)))
+
+	inject_poison_sysfs "$region" "$hpa1"
+	check_trace_entry "$region" "$hpa1"
+	inject_poison_sysfs "$region" "$hpa2"
+	check_trace_entry "$region" "$hpa2"
+	validate_poison_found "-r $region" 2
+
+	clear_poison_sysfs "$region" "$hpa1"
+	check_trace_entry "$region" "$hpa1"
+	clear_poison_sysfs "$region" "$hpa2"
+	check_trace_entry "$region" "$hpa2"
+	validate_poison_found "-r $region" 0
 }
 
-# Turn tracing on. Note that 'cxl list --media-errors' toggles the tracing.
-# Turning it on here allows the test user to also view inject and clear
-# trace events.
+# Clear old trace events, enable cxl_poison, enable global tracing
+echo "" > /sys/kernel/tracing/trace
 echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
+echo 1 > /sys/kernel/tracing/tracing_on
 
-test_poison_by_memdev
-test_poison_by_region
+test_poison_by_memdev_by_dpa
+test_poison_by_region_by_dpa
+test_poison_by_region_by_hpa
 
 check_dmesg "$LINENO"
 
-- 
2.37.3

