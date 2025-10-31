Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AB8285061;
	Fri, 31 Oct 2025 17:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761932409; cv=none; b=U+nbaXpXrsqp64JqgbUcbTW/+UjsUAT1tWMdpCMaCTPxYaWBmP/prUhTgjyMFl+bN24b5yT+9+htuOGXbn3q996Fle6eWtjoEKoW6faSsmeFr9kHnfnbCy3DWqW0ijvHfJMne6KT2eQIMJKFE45KxDan75cb7dJg/7K2+W75RnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761932409; c=relaxed/simple;
	bh=Iwudpw+Vfc3lPd+An9QDwJKYAuVIB4STHYG9mMa8QrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOqv521fXscAut6oPLfYWXIWqg3Oo3FvPkQunzxAh7fY4kQ9Ewi9y/AO41/J5h2++jDYZM6UxElXryrBcqL9uVOIl88RZiIFnNkqk+k54ZrHyq+WMjvJmRMEtKbpOuh0Se9+am3s29/HGmWDBSYAZm6IN+uKBJWFz6KMMFYQuSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D22C4CEE7;
	Fri, 31 Oct 2025 17:40:08 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com
Subject: [NDCTL PATCH 3/5] cxl/test: Move cxl-poison.sh to use cxl_test auto region
Date: Fri, 31 Oct 2025 10:40:01 -0700
Message-ID: <20251031174003.3547740-4-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251031174003.3547740-1-dave.jiang@intel.com>
References: <20251031174003.3547740-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move cxl-poison.sh to use the cxl_test auto region instead of manually
create an additional region. This is in preparation to allow utilize
the existing poison unit tests to also test the extended linear cache
region.

The offset has been changed due to the auto region starts at 0 and pmem
region starts at 0x40000000. The original test was creating a pmem
region. It makes no difference what type of region is being used for
testing.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/cxl-poison.sh | 38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 8e81baceeb24..430780cf7128 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -35,28 +35,14 @@ find_memdev()
 	memdev=${capable_mems[0]}
 }
 
-create_x2_region()
+find_auto_region()
 {
-	# Find an x2 decoder
-	decoder="$($CXL list -b "$CXL_TEST_BUS" -D -d root | jq -r ".[] |
-		select(.pmem_capable == true) |
-		select(.nr_targets == 2) |
-		.decoder")"
-
-	# Find a memdev for each host-bridge interleave position
-	port_dev0="$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")"
-	port_dev1="$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 1) | .target")"
-	mem0="$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")"
-	mem1="$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")"
-
-	region="$($CXL create-region -d "$decoder" -m "$mem0" "$mem1" |
-		jq -r ".region")"
-	if [[ ! $region ]]; then
-		echo "create-region failed for $decoder"
-		err "$LINENO"
-	fi
+	region="$($CXL list -b "$CXL_TEST_BUS" -R | jq -r ".[0].region")"
+	[[ -n "$region" && "$region" != "null" ]] || do_skip "no test region found"
+	mem0="$($CXL list -r "$region" --targets | jq -r ".[0].mappings[0].memdev")"
+	[[ -n "$mem0" && "$mem0" != "null" ]] || do_skip "no region target0 found"
+	mem1="$($CXL list -r "$region" --targets | jq -r ".[0].mappings[1].memdev")"
+	[[ -n "$mem1" && "$mem1" != "null" ]] || do_skip "no region target1 found"
 	echo "$region"
 }
 
@@ -153,12 +139,12 @@ test_poison_by_memdev_by_dpa()
 
 test_poison_by_region_by_dpa()
 {
-	inject_poison_sysfs "$mem0" "0x40000000"
-	inject_poison_sysfs "$mem1" "0x40000000"
+	inject_poison_sysfs "$mem0" "0"
+	inject_poison_sysfs "$mem1" "0"
 	validate_poison_found "-r $region" 2
 
-	clear_poison_sysfs "$mem0" "0x40000000"
-	clear_poison_sysfs "$mem1" "0x40000000"
+	clear_poison_sysfs "$mem0" "0"
+	clear_poison_sysfs "$mem1" "0"
 	validate_poison_found "-r $region" 0
 }
 
@@ -228,7 +214,7 @@ echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
 echo 1 > /sys/kernel/tracing/tracing_on
 
 test_poison_by_memdev_by_dpa
-create_x2_region
+find_auto_region
 test_poison_by_region_by_dpa
 [ -f "/sys/kernel/debug/cxl/$region/inject_poison" ] ||
        do_skip "test cases requires inject by region kernel support"
-- 
2.51.0

