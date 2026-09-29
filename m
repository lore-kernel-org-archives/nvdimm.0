Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1403F12D3
	for <nvdimm@lists.linux.dev>; Tue, 29 Sep 2026 05:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790660229; cv=none; b=d3kdyR9HRcjcFbzg0M9cu5IHmq5qS/Ig8DD7zPKVfRXoPA6lLM5+Zi0uf3Jvb7AqeLTBJcjO3StoZgvMajGEix5NcBxcjUC4/8o0r1iLToNCIC8Y5F5POGvCQc4jVbCiW1COLsJlUI6tKgc7zLW4/yc609rW7aiQ5lu2nY+GKg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790660229; c=relaxed/simple;
	bh=VM9OM/Jipei1p2ggJbxoXiZuVLMq+0NcSk0UCT2QTjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otyEXHWbGqJti5HA5lTqENM0w4dphw+CXVGw4G0nsa0URx8zlbwuFwop+1cNZ31a5V9CgDNG9fwy3EgUZGqlf7NPhTQc78vApBQI5lxdQBfbyRG701DqtzPEQu6NQI6sqIo+3q+X3Ypv1lQ0L70oz4Qgub7FEwTVgNsDf4dlRao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZWsBm2yg; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZWsBm2yg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790660227; x=1822196227;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VM9OM/Jipei1p2ggJbxoXiZuVLMq+0NcSk0UCT2QTjI=;
  b=ZWsBm2yge+Wl2dRpYGEI9bYFgqxR7g9c+xFIj+fWybaJLOUV++a1LzA8
   zvbMxM+2NfppAwgm71IhshAN8rQDAc5bo0ONSC8GTd1lnxhDHAlwikNdX
   JbtbaO+jz36+B4OreOrjeIQnF9CpWyZCnZrpo7R+3sQVXjKtzxE6O+efK
   1ipfK0TST50Z6nQ2E02kwJ2kdjEoZdYJY9IA9zytHuZoJ3X/Yyvfm1kLj
   xdx2w+gpF3yfLxcosExlkVY+WMKCZNyVBXJJqLVG4WC2SQkIwJsDIY9dm
   r7MkvUB1R+fjnP65MaTAqdSLoXDhQQR9hz+5xc8CwdQSM3174XbS76//e
   A==;
X-CSE-ConnectionGUID: KXnZriN1Rlmdgt1h6NP7mw==
X-CSE-MsgGUID: Ci/o/rikQ26j7dUjLX7EEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="100700067"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="100700067"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 22:37:06 -0700
X-CSE-ConnectionGUID: 9R8VsYiSQyOr5QxK/NIjrA==
X-CSE-MsgGUID: ejo1O1CsRiecut3qBQTcvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="304767473"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.149])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 22:37:06 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 3/7] cxl/region: parse comma-separated target lists
Date: Mon, 28 Sep 2026 22:36:55 -0700
Message-ID: <6cfb02216cb0bad45eb7eb7fb40e921fecb423a1.1790658549.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1790658549.git.alison.schofield@intel.com>
References: <cover.1790658549.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A comma-separated target list can be miscounted, causing cxl create-region
to reject a valid multi-target request when --ways is omitted. The
generated filter can also acquire a trailing comma.

This happens because the separator is re-evaluated after tokenization has
already modified the input.

Choose the separator before tokenizing and use the target count when
emitting the flattened list.

Fixes: 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-region targets")
Assisted-by: LLM
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/region.c              | 21 +++++++-----
 test/cxl-create-region.sh | 72 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 9 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index 85d4d9bb54f2..43c228f2f999 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -124,24 +124,25 @@ static const struct option destroy_options[] = {
 static const char *to_csv(int *count, const char **strings)
 {
 	ssize_t len = 0, cursor = 0;
+	int i, new_count = 0, emitted = 0;
 	char *csv, *list, *save;
-	int i, new_count = 0;
-	const char *arg;
+	const char *arg, *sep;
 
 	if (!*count)
 		return NULL;
 
 	for (i = 0; i < *count; i++) {
 		/*
-		 * An entry in strings may itself by a space or comma
-		 * separated list, so decompose that for the final csv
+		 * An entry may itself be space- or comma-separated. strtok_r()
+		 * modifies @list, so choose the separator before tokenizing.
 		 */
 		list = strdup(strings[i]);
 		if (!list)
 			return NULL;
 
-		for (arg = strtok_r(list, which_sep(list), &save); arg;
-		     arg = strtok_r(NULL, which_sep(list), &save)) {
+		sep = which_sep(list);
+		for (arg = strtok_r(list, sep, &save); arg;
+		     arg = strtok_r(NULL, sep, &save)) {
 			len += strlen(arg);
 			new_count++;
 		}
@@ -161,10 +162,12 @@ static const char *to_csv(int *count, const char **strings)
 			return NULL;
 		}
 
-		for (arg = strtok_r(list, which_sep(list), &save); arg;
-		     arg = strtok_r(NULL, which_sep(list), &save)) {
+		sep = which_sep(list);
+		for (arg = strtok_r(list, sep, &save); arg;
+		     arg = strtok_r(NULL, sep, &save)) {
 			cursor += snprintf(csv + cursor, len - cursor, "%s%s",
-					   arg, i + 1 < new_count ? "," : "");
+					   arg,
+					   ++emitted < new_count ? "," : "");
 			if (cursor >= len) {
 				csv[len - 1] = 0;
 				break;
diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
index 927edf4c17d4..6fc845c7d382 100644
--- a/test/cxl-create-region.sh
+++ b/test/cxl-create-region.sh
@@ -226,6 +226,76 @@ setup_x3()
 	memdevs="$mem0 $mem1 $mem2"
 }
 
+# Build a 4-way target list over an x2 root in interleave position order.
+setup_interleave_shape()
+{
+	x2_decoder=$($CXL list -b cxl_test -D -d root |
+		     jq -r ".[] |
+		     select(.pmem_capable == true) |
+		     select(.nr_targets == 2) |
+		     .decoder")
+
+	if [[ ! $x2_decoder ]]; then
+		echo "no pmem capable x2 root decoder found"
+		return 1
+	fi
+
+	pos0=$(find_memdev "$x2_decoder" 0 0)
+	pos1=$(find_memdev "$x2_decoder" 1 0)
+	pos2=$(find_memdev "$x2_decoder" 0 1)
+	pos3=$(find_memdev "$x2_decoder" 1 1)
+
+	if [[ ! $pos0 || ! $pos1 || ! $pos2 || ! $pos3 ]]; then
+		echo "$x2_decoder: no memdev pair for each interleave position"
+		return 1
+	fi
+}
+
+# A comma-separated target list must preserve its count and order.
+create_csv_targets()
+{
+	if ! setup_interleave_shape; then
+		echo "skipping comma separated target list"
+		return
+	fi
+
+	if ! json=$($CXL create-region -b cxl_test -d "$x2_decoder" \
+		    -m "$pos0,$pos1,$pos2,$pos3"); then
+		echo "$x2_decoder: refused $pos0,$pos1,$pos2,$pos3"
+		err "$LINENO"
+	fi
+
+	region=$(jq -r ".region" <<< "$json")
+	ways=$(jq -r ".interleave_ways" <<< "$json")
+	if [[ $ways -ne 4 ]]; then
+		echo "$region: interleaves $ways ways, expected 4"
+		err "$LINENO"
+	fi
+
+	targets=$(jq -r "[.mappings | sort_by(.position) | .[].memdev] |
+		  join(\" \")" <<< "$json")
+	if [[ "$targets" != "$pos0 $pos1 $pos2 $pos3" ]]; then
+		echo "$region: targets '$targets', expected '$pos0 $pos1 $pos2 $pos3'"
+		err "$LINENO"
+	fi
+
+	destroy_regions "$region"
+
+	# Also verify a rejected filter is echoed without a trailing comma.
+	if out=$($CXL create-region -b cxl_test -d "$x2_decoder" \
+		 -m nomemdev0,nomemdev1,nomemdev2 2>&1); then
+		echo "create-region accepted names that are not memdevs"
+		err "$LINENO"
+	fi
+
+	if ! grep -Fq -- "filter: nomemdev0,nomemdev1,nomemdev2" <<< "$out" ||
+	   grep -Fq -- "nomemdev2," <<< "$out"; then
+		echo "target list echoed back as:"
+		echo "$out"
+		err "$LINENO"
+	fi
+}
+
 # test region creation on devices behind a single-port host-bridge
 create_single
 
@@ -239,6 +309,8 @@ for mem in ${mems[@]}; do
 	create_subregions "$mem"
 done
 
+create_csv_targets
+
 # Repeat x1/x2/x3/x4 region creation with XOR interleave arithmetic.
 load_cxl_test interleave_arithmetic=1
 
-- 
2.37.3

