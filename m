Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6855B27AC31
	for <nvdimm@lists.linux.dev>; Sat,  4 Apr 2026 01:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775266489; cv=none; b=PGLGQNGd6OLI0ZnYGNf+tcxwwtw49IXrDOnVnQCpxvVf7Qi5A0rFvxrjH7fVM7L8kUeKgurzrzZN9B+NhsBzWF2MyYhjWsFyPeH9JoJg7BEJ4hihFCHI8h40yCZ04PtwC18REy+DpTZ2ZAqn6YmZu7nMOKZQ14ekqbsJ5mm94Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775266489; c=relaxed/simple;
	bh=LmuMWTdDngsHlwrEIo/G6Eg4b2W2b3P+yGwIWGNeZ/8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A5ywNxBHx173qS+bVL9gu3sG9tRvJKni5vsUW10Y79jU04EtpTn5uEG/uUZWQGtdUJlq9NU58I/5wIlkMGjCYxxZU0D5pbhfagVR8O+ZTfwXUz2EdG1R9s3DerjW7duEYRqp/SJLERLoKBcMUUpdntTs2Z+2rqNgFGEMU7yVblM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gG58g1P0; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gG58g1P0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775266487; x=1806802487;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LmuMWTdDngsHlwrEIo/G6Eg4b2W2b3P+yGwIWGNeZ/8=;
  b=gG58g1P0xhYULaE6Z04ADPWbhqD/QAUeaSU3m1w2bfDyWPxQLbKu06lO
   vcFQHNLr6N5UxkQ0OpUtPHl3oyAL4tsfOzD2GrTZF6iUl+27VBED8bobm
   7N3mE8UbCvAhGDUQbptvuoa3O3mJI0sVjYXKP7VtD7rSQtUrwZhgBwXkn
   ljEd5JNxZrbA/T/L6SmHGSkHtYW7e3osxf+h1S+dd8WasxPSvRVepWp+7
   kU8B1VyXFiNf4+GJRC1QGmavrCwMPimuSzLKQdAoQm/S7FEATwM2NRi0V
   6Qs51S+QSVEcUVzwK51Y7zo7wEupKrBSD1KOMsq0x5oxYYk8/OUnFTLyM
   g==;
X-CSE-ConnectionGUID: PIekx8KkSNyOIxvqpyVIfg==
X-CSE-MsgGUID: avh6TTNCS265xHy6WjUMTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76218255"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76218255"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:34:47 -0700
X-CSE-ConnectionGUID: 53Xw3WKtQ5GT9J0QZlL6Gg==
X-CSE-MsgGUID: yocNes7VQdOt86T4N5q4aA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="257856865"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.12])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:34:47 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 1/3] test/cxl-destroy-region.sh: prevent false pass when no decoder found
Date: Fri,  3 Apr 2026 18:34:39 -0700
Message-ID: <c2eccb9b0e596820940bfc7ec839ff807f3ac613.1775265383.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The destroy-region test assumed a free decoder was available and
silently skipped execution when none could be found. When cxl_test
began creating an auto region on module load, it consumed the decoder
resource the test relied on, leading to false passes all the time.
This was recently noticed during review of test logs.

Clear all regions at test start to reclaim decoder resources. Fail
the test if no usable decoder is found and select the first match when
multiple decoders satisfy the query.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-destroy-region.sh | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/test/cxl-destroy-region.sh b/test/cxl-destroy-region.sh
index 3952060cf3e2..f03aa67e8b0d 100644
--- a/test/cxl-destroy-region.sh
+++ b/test/cxl-destroy-region.sh
@@ -16,6 +16,22 @@ modprobe -r cxl_test
 modprobe cxl_test
 rc=1
 
+assert_no_regions()
+{
+	regions_json="$("$CXL" list -b "$CXL_TEST_BUS" -Ri)"
+	[[ -n "$regions_json" ]] || err "$LINENO"
+	[[ "$(jq 'length' <<<"$regions_json")" -eq 0 ]] || err "$LINENO"
+}
+
+destroy_regions()
+{
+	if [[ "$*" ]]; then
+		"$CXL" destroy-region -f -b "$CXL_TEST_BUS" "$@"
+	else
+		"$CXL" destroy-region -f -b "$CXL_TEST_BUS" all
+	fi
+}
+
 check_destroy_ram()
 {
 	mem=$1
@@ -51,8 +67,15 @@ check_destroy_devdax()
 	"$CXL" destroy-region "$region"
 }
 
+# Get clean slate, including auto region resources
+destroy_regions
+assert_no_regions
+
 # Find a memory device to create regions on to test the destroy
 readarray -t mems < <("$CXL" list -b "$CXL_TEST_BUS" -M | jq -r '.[].memdev')
+[[ ${#mems[@]} -eq 0 ]] && err "$LINENO"
+
+found=0
 for mem in "${mems[@]}"; do
         ramsize="$("$CXL" list -m "$mem" | jq -r '.[].ram_size')"
         if [[ $ramsize == "null" || ! $ramsize ]]; then
@@ -63,13 +86,15 @@ for mem in "${mems[@]}"; do
                   select(.volatile_capable == true) |
                   select(.nr_targets == 1) |
                   select(.max_available_extent >= ${ramsize}) |
-                  .decoder")"
-        if [[ $decoder ]]; then
-		check_destroy_ram "$mem" "$decoder"
-		check_destroy_devdax "$mem" "$decoder"
-                break
-        fi
+                  .decoder" | head -n1)"
+	[[ -z $decoder || $decoder == "null" ]] && continue
+
+	check_destroy_ram "$mem" "$decoder"
+	check_destroy_devdax "$mem" "$decoder"
+	found=1
+	break
 done
+[[ $found -eq 1 ]] || err "$LINENO"
 
 check_dmesg "$LINENO"
 
-- 
2.37.3

