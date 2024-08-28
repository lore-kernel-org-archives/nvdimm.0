Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF4A13B287
	for <nvdimm@lists.linux.dev>; Wed, 28 Aug 2024 03:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724814860; cv=none; b=HBoYRUfkdowwgTCXuSacbliSB9qTYmSxsOtm90fwH6ZQxFIiUeI5wcjHnW/G92DSDtyXtQYWX5ZMZgAHRXmFbr3FxHPCBHLYPU0U26WYkHvUHQdr7PHX1dY5IEqiXkEtptOOtiQ3Ds0vz1HBO7cExT+1EWZSQbF+LirlJ989T3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724814860; c=relaxed/simple;
	bh=s4GwAVKYhS6ciRiQ39FpVVGU3l4wRUq32sUyXRjbYNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hefuJAU92faFoRvca2ynp39TW2hc7z0RVxu9GorTnbc2UoUEqti1NRpUWXZ126UO7eff45a13Pl/TyPMpPDiMo/iZRPfx26AkM4QEFUP2VxEK4NypeWfRZ63r/7DEWale7n6zuWjEAfJBvH+6H6Edrp4tluyXSTmYHBZTaxqP6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HssX1XcA; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HssX1XcA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724814860; x=1756350860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s4GwAVKYhS6ciRiQ39FpVVGU3l4wRUq32sUyXRjbYNA=;
  b=HssX1XcA3iDsAzA2xYtevEZKARJuW7dShER2F5cl5VwBiKkJE/dc1d76
   kcWvd6wJgGXLg30xMkxogY4Jaw+tZAC5ekVR/jS7Z2ldE4OHTfFjc8hNN
   zyLQisgzOnnXG0KZgqryyWwBvdnZW8xlZDPXc37LiR3U3gs7K9ucxdhKv
   o20Qkys8Wu7bDMpsUQMM0tRd/IZ4Gq5RDUeklt4VexibhfeUn1NDV2z/7
   stMxA9Q2wuFbuswnjP49ZYi9OVSO0TOX/7WtYlvkEkx9Fkz6MLAWvxeRL
   eW1sSurV3IRwheo0ryhtfeGSWhc9qAnr/mRDhzRIUkTGuQkbchDmpsLz/
   g==;
X-CSE-ConnectionGUID: 3EFeY+kpSkO9b9ESp2/GTQ==
X-CSE-MsgGUID: VWdzZ5gtRCyz21aY5rqKkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11177"; a="23285730"
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="23285730"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 20:14:19 -0700
X-CSE-ConnectionGUID: drH3/R3rSwmgAX3KvUxLkQ==
X-CSE-MsgGUID: kk4j1yfPTbOAy/t+aNBq+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="63039286"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.111.50])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 20:14:19 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 2/2] test/daxctl-create.sh: use CXL DAX regions instead of efi_fake_mem
Date: Tue, 27 Aug 2024 20:14:05 -0700
Message-ID: <519161e23a43e530dbcffac203ecbbb897aa5342.1724813664.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1724813664.git.alison.schofield@intel.com>
References: <cover.1724813664.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

This test tries to use DAX regions created from efi_fake_mem devices.
A recent kernel change removed efi_fake_mem support causing this test
to SKIP because no DAX regions can be found.

Alas, a new source of DAX regions is available: CXL. Use that now.
Other than selecting a different region provider, the functionality
of the test remains the same.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/daxctl-create.sh | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/test/daxctl-create.sh b/test/daxctl-create.sh
index d968e7bedd82..1ef70f2ff186 100755
--- a/test/daxctl-create.sh
+++ b/test/daxctl-create.sh
@@ -7,6 +7,9 @@ rc=77
 
 trap 'cleanup $LINENO' ERR
 
+modprobe -r cxl_test
+modprobe cxl_test
+
 cleanup()
 {
 	printf "Error at line %d\n" "$1"
@@ -18,18 +21,10 @@ find_testdev()
 {
 	local rc=77
 
-	# The hmem driver is needed to change the device mode, only
-	# kernels >= v5.6 might have it available. Skip if not.
-	if ! modinfo dax_hmem; then
-		# check if dax_hmem is builtin
-		if [ ! -d "/sys/module/device_hmem" ]; then
-			printf "Unable to find hmem module\n"
-			exit $rc
-		fi
-	fi
+	# find a victim region provided by cxl_test
+	bus="$("$CXL" list -b "$CXL_TEST_BUS" | jq -r '.[] | .bus')"
+	region_id="$("$DAXCTL" list -R | jq -r ".[] | select(.path | contains(\"$bus\")) | .id")"
 
-	# find a victim region provided by dax_hmem
-	region_id="$("$DAXCTL" list -R | jq -r '.[] | select(.path | contains("hmem")) | .id')"
 	if [[ ! "$region_id" ]]; then
 		printf "Unable to find a victim region\n"
 		exit "$rc"
@@ -413,4 +408,5 @@ daxctl_test5
 daxctl_test6
 daxctl_test7
 reset_dev
+modprobe -r cxl_test
 exit 0
-- 
2.37.3

