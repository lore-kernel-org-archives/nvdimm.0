Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B39C138
	for <nvdimm@lists.linux.dev>; Wed, 24 Apr 2024 02:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713927251; cv=none; b=tN0AE7LTl2vyD6em+6QuRq7l06w5wOLklYkfhyZNuNC95KoKtaEdCBZbAEKwMehy8RZ0L7Hqj6Mupp6uFXPRb8DVHkbrLIlu+vqoWcWypEfsSAnnbX7gLYe1eyOEfLmXgQeQEIQe/ldr+Ql71myYmcAZfvVVtHULWUo5aH/SJmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713927251; c=relaxed/simple;
	bh=ngiUceOQLYYdNsZ+EDolnhP1o4zaDBgUI92guB+rlHU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pE+Gwgs7e440sD9+pM34TwJJgZKW7TXH2EOjfpRXE1sMtDentJ+adUqaSjSDBxa2ObN3LlYL3KE9mkuyThW9U6X8nw/XCSEhXgFTeSaPCYsYn7AfZaBmAX4YTVDF9T0cK2uA0bDedrLSgYhiMDzZ7vcqNpdl4qOruuCdcn+aQjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LlZBCrry; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LlZBCrry"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713927250; x=1745463250;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ngiUceOQLYYdNsZ+EDolnhP1o4zaDBgUI92guB+rlHU=;
  b=LlZBCrryrVaFrqA8uJzY1ly5w0lUBNcgDBeT0TX/72ZRwOVkOIDRE7AX
   3hUMgFxQ/jXKwvD9yFflJ/Hpme524T1mgVUBh6V2uKbEmLLu3t2s3PvdP
   JNc5w8O4g4hwiF9u8CXO5cdMNvR145TwQdbDmNEHibEf+pdQ2SeZLDoGu
   0f2I6VzyG8C1tRRF89sN15OGt6ZEsymufToOWXWxr7E8RTktGkhaOZRza
   jhcRQyz0lHAQsexS+vp5VTXEBZY9HfFb3egm90ORsc22eU3pEX39jXLCO
   DPDU6+MNOGjiP/r0VjIONkYM93TLPllwn8WalgbqAib4HQRKcK0oZ+EZ+
   A==;
X-CSE-ConnectionGUID: g5Rt62QFQ8ifsO41H7+1+g==
X-CSE-MsgGUID: QbwvaWtrQDeEfRq2pWwCdg==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="10079835"
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="10079835"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 19:54:09 -0700
X-CSE-ConnectionGUID: YIJATbA2Qk+IdjaU0ffGug==
X-CSE-MsgGUID: suHFNe9aTVO6Qt8S8UUx6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="29205907"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.29.57])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 19:54:08 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2] cxl/test: use max_available_extent in cxl-destroy-region
Date: Tue, 23 Apr 2024 19:54:03 -0700
Message-Id: <20240424025404.2343942-1-alison.schofield@intel.com>
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

The test overlooked the region creation failure because the not 'null'
comparison succeeds when cxl create-region command emits nothing.
Use the ! comparator when checking the create-region result.

When checking the ram_size output of cxl-list add a check for empty.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Changes in v2:
- Check ram_size json output for null or empty (Vishal)


 test/cxl-destroy-region.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/test/cxl-destroy-region.sh b/test/cxl-destroy-region.sh
index cf0a46d6ba58..3952060cf3e2 100644
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
+        if [[ $ramsize == "null" || ! $ramsize ]]; then
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

