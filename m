Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B8814D6FF
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 18:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711565208; cv=none; b=BSQsSlf3H6tn9gzzxpxY3w6+C+wCZnlin7RibYIsmb/IGqt8yaU2rdYfYGWnj/fEx3/KhVqE7xo1NdV3ZieBcVKmIe/ejd1cMctvysrwC8DccUbXa2PApTzXhlSfD+iG2oHt/Zuzr8j7YiQER9i4ilth3Du28abSI2jmWhAn9rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711565208; c=relaxed/simple;
	bh=acHxIpcTDFJzRAp2QbBpv+POxjsTO48jjMzXlTatR3A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SyR/MQaRBUdnq1LhQPFXIP7FK45jI1ZpxB5P7TQSZ8ebT9eA7tWUzonAK/2Sxuft0nDCOkR7i9PcDyepn4jGWMJHlQ/GlAce23bhZlmSwMTnVoabO/eQ9qP/hGmECI8c8VB3zD7gFNw1vu3Ahkae8DzjqZ6xSO8pfSX0wlcEkFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hSY1Vazq; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hSY1Vazq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711565207; x=1743101207;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=acHxIpcTDFJzRAp2QbBpv+POxjsTO48jjMzXlTatR3A=;
  b=hSY1VazqYfR7vV4XqI8EDmz2wu2khLXSLBbV8UM8nHWoN+xiYDOtdJRx
   CvyGKk4Mq3f3wq2ttkq057lO0WPNPn64DNxKUca6vG11wyidJcRGgFMKX
   50m9Ux32tWcLfC30r3cuXpoTA69ulKrOAs+MnXKgkElyisA+bROsDZf7n
   1nYAh8auBVy5UYktLgqC9de9JraGwfgZplA2ZsAKL361MkKVVPdjMgeh1
   1VpEsl/h2h8HIhM1B7YFhHPCsmfaneq2koW3SJuMW/p44kMDnnXULCz8S
   3V2mfdMAnCMnmTZ+nxKNe4FR8ZAheNOxE0ZQQ3pCfrHFGF7TGhU8Qt6e2
   A==;
X-CSE-ConnectionGUID: OOenL/ucS8el8Pe8q9FyRQ==
X-CSE-MsgGUID: ZBtcK1FjSVS+8OB3wCXpfw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="9652004"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="9652004"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 11:46:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="16785503"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.82.250])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 11:46:46 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH] cxl/test: use max_available_extent in cxl-destroy-region
Date: Wed, 27 Mar 2024 11:46:42 -0700
Message-Id: <20240327184642.2181254-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Using .size in decoder selection can lead to a set_size failure with
these error messages:

cxl region: create_region: region8: set_size failed: Numerical result out of range

[] cxl_core:alloc_hpa:555: cxl region8: HPA allocation error (-34) for size:0x0000000020000000 in CXL Window 0 [mem 0xf010000000-0xf04fffffff flags 0x200]

Use max_available_extent for decoder selection instead.

The test overlooked the region creation failure because it used a
not 'null' comparison which always succeeds. Use the ! comparator
after create-region and for the ramsize check so that the test fails
or continues as expected.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-destroy-region.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/test/cxl-destroy-region.sh b/test/cxl-destroy-region.sh
index cf0a46d6ba58..167fcc4a7ff9 100644
--- a/test/cxl-destroy-region.sh
+++ b/test/cxl-destroy-region.sh
@@ -22,7 +22,7 @@ check_destroy_ram()
 	decoder=$2
 
 	region="$("$CXL" create-region -d "$decoder" -m "$mem" | jq -r ".region")"
-	if [ "$region" == "null" ]; then
+	if [[ ! $region ]]; then
 		err "$LINENO"
 	fi
 	"$CXL" enable-region "$region"
@@ -38,7 +38,7 @@ check_destroy_devdax()
 	decoder=$2
 
 	region="$("$CXL" create-region -d "$decoder" -m "$mem" | jq -r ".region")"
-	if [ "$region" == "null" ]; then
+	if [[ ! $region ]]; then
 		err "$LINENO"
 	fi
 	"$CXL" enable-region "$region"
@@ -55,14 +55,14 @@ check_destroy_devdax()
 readarray -t mems < <("$CXL" list -b "$CXL_TEST_BUS" -M | jq -r '.[].memdev')
 for mem in "${mems[@]}"; do
         ramsize="$("$CXL" list -m "$mem" | jq -r '.[].ram_size')"
-        if [[ $ramsize == "null" ]]; then
+        if [[ ! $ramsize ]]; then
                 continue
         fi
         decoder="$("$CXL" list -b "$CXL_TEST_BUS" -D -d root -m "$mem" |
                   jq -r ".[] |
                   select(.volatile_capable == true) |
                   select(.nr_targets == 1) |
-                  select(.size >= ${ramsize}) |
+                  select(.max_available_extent >= ${ramsize}) |
                   .decoder")"
         if [[ $decoder ]]; then
 		check_destroy_ram "$mem" "$decoder"

base-commit: e0d0680bd3e554bd5f211e989480c5a13a023b2d
-- 
2.37.3

