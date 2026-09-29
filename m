Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBB63F0767
	for <nvdimm@lists.linux.dev>; Tue, 29 Sep 2026 05:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790660232; cv=none; b=IdtrzVKCKuSAeDJdMr2xwVVA4QsPMiuWRC7pbBPz5TWxljUwKLxa8Q/EMsS/IOAh/WlMYhIUfU0St6DjN6YBsD74DxgY4K4C8pd8YYkRxE6ad1UcDYL8PHZxbBhHaUGZ6d9Y/6bhcBAi/amyIY5uZhESbIg8rvnSK4wrg4jAuD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790660232; c=relaxed/simple;
	bh=Anyrt+dm/HWrWOvkKfMVvjWBCkkSPEKJGeiLPnwGqec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8peiesMDqasNdqrFwQS7BJofFkOA0MBvn0ftGISycHSFZOx6eyk5glMYyT3Lrfii9NBNDz09SGBAIY48dOql9YtCc6uCQ0aSOQwAqM+i0WZDiGJVsa5p9eJGv12Up0Z4WjAckPI9OiMazNZFZ0W9Xu0aV/8pnQSj1Y/mEebBzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SrkVvvAQ; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SrkVvvAQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790660230; x=1822196230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Anyrt+dm/HWrWOvkKfMVvjWBCkkSPEKJGeiLPnwGqec=;
  b=SrkVvvAQpvRipQEDJ5Bc1L2i1ap5TBkRNQFSd7ZoQgVxqa8C6xp6w8QE
   zQMW42Dc/q4N6OKwzZ12g0CloEHLUKOqnlZsTwj0w345pZDT+v6iBJswn
   M+D2VzOSQqyNtHQ05MUnb/SAGVCe7uZW18sJ1XDpScn0GAc+7PVMBja/H
   hfPMls3tYtD7DvLyTgRrOdXRlePqZo/YmPm68wjjBbRdFGC0UGJdTCdhk
   A4f0iJlf4vtq/dZrZpVcloyhhvoztvAOM7MWdp/039FjYRAAT8Xsqk8M5
   TAUp7ZINnUHxlVqCCYLkzwsjya6ibVHVa3Y7CDKe46pNWrq3o3LBPbSx3
   w==;
X-CSE-ConnectionGUID: CtU8o2kJTbqMtes9Rh00zQ==
X-CSE-MsgGUID: W034CQjpSk+TfYGWSWJqRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="100700072"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="100700072"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 22:37:08 -0700
X-CSE-ConnectionGUID: sq7FcyZ9TOCZdWlG/bPRvw==
X-CSE-MsgGUID: g/Ik7U1QToSN3RHtRSPXLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="304767484"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.149])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 22:37:08 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 5/7] cxl/region: release reserved DPA when region creation fails
Date: Mon, 28 Sep 2026 22:36:57 -0700
Message-ID: <25f79d6842ac453c65834f17bda04629d7bf4958.1790658549.git.alison.schofield@intel.com>
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

A cxl create-region failure after reserving endpoint DPA deletes the
region but leaves those reservations behind. Later creates can fail with
ENOSPC on capacity stranded by the earlier attempt.

Track reservations made by the current create and release them after
deleting the failed region.

Fixes: 21b089025178 ("cxl: add a 'create-region' command")
Assisted-by: LLM
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/region.c              | 35 ++++++++++++++++++++++++--
 test/cxl-create-region.sh | 52 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index 2bb3b90940b0..e4fc8bb2942c 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -712,14 +712,30 @@ static int cxl_region_determine_granularity(struct cxl_region *region,
 	return -EINVAL;
 }
 
+/* Delete the region before releasing its endpoint DPA. */
+static void unreserve_dpa(struct cxl_decoder **ep_decoders, int nr)
+{
+	int i, rc;
+
+	for (i = 0; i < nr; i++) {
+		rc = cxl_decoder_set_dpa_size(ep_decoders[i], 0);
+		if (rc)
+			log_err(&rl, "%s: failed to release dpa: %s\n",
+				cxl_decoder_get_devname(ep_decoders[i]),
+				strerror(abs(rc)));
+	}
+}
+
 static int create_region(struct cxl_ctx *ctx, int *count,
 			 struct parsed_params *p)
 {
 	unsigned long flags = UTIL_JSON_TARGETS;
+	struct cxl_decoder **ep_decoders;
 	struct json_object *jregion;
 	struct cxl_region *region;
 	bool default_size = true;
 	int i, rc, granularity;
+	int nr_reserved = 0;
 	u64 size, max_extent;
 	const char *devname;
 
@@ -775,6 +791,12 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 
 	devname = cxl_region_get_devname(region);
 
+	ep_decoders = calloc(p->ways, sizeof(*ep_decoders));
+	if (!ep_decoders) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
 	rc = cxl_region_determine_granularity(region, p);
 	if (rc < 0)
 		goto out;
@@ -810,6 +832,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 			try(cxl_decoder, set_mode, ep_decoder, p->mode);
 		}
 		try(cxl_decoder, set_dpa_size, ep_decoder, size/p->ways);
+		ep_decoders[nr_reserved++] = ep_decoder;
 		rc = cxl_region_set_target(region, i, ep_decoder);
 		if (rc) {
 			log_err(&rl, "%s: failed to set target%d to %s\n",
@@ -842,8 +865,16 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 
 out:
 	json_object_put(p->memdevs);
-	if (rc)
-		cxl_region_delete(region);
+	if (rc) {
+		int delete_rc = cxl_region_delete(region);
+
+		if (delete_rc)
+			log_err(&rl, "%s: failed to delete: %s\n", devname,
+				strerror(abs(delete_rc)));
+		else
+			unreserve_dpa(ep_decoders, nr_reserved);
+	}
+	free(ep_decoders);
 	return rc;
 }
 
diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
index 6ffe36b852a2..02358af7837a 100644
--- a/test/cxl-create-region.sh
+++ b/test/cxl-create-region.sh
@@ -340,6 +340,57 @@ refuse_bad_target_list()
 		-d "$x2_decoder" -m "$pos0,nomemdev"
 }
 
+# Snapshot endpoint DPA reservations.
+reserved_dpa()
+{
+	$CXL list -b cxl_test -D -d endpoint -i |
+	jq -r ".[] |
+	select((.dpa_size // 0) > 0) |
+	\"\(.decoder) \(.dpa_size)\"" | sort
+}
+
+# Fail after earlier targets reserve DPA and verify it is released.
+release_dpa_on_failure()
+{
+	if ! setup_interleave_shape; then
+		echo "skipping dpa release on failure"
+		return
+	fi
+
+	# an x1 window over position 2's host bridge, to fill it through
+	decoder=$(find_x1_decoder "$pos2")
+
+	if [[ ! $decoder ]]; then
+		echo "no x1 pmem decoder over $pos2, skipping dpa release"
+		return
+	fi
+
+	filler=$($CXL create-region -b cxl_test -d "$decoder" -m "$pos2" |
+		 jq -r ".region")
+	if [[ ! $filler ]]; then
+		echo "$decoder: unable to fill $pos2"
+		err "$LINENO"
+	fi
+
+	dpa_before="$(reserved_dpa)"
+
+	# Force the failure into endpoint DPA setup; default sizing would
+	# reject the request before reserving anything.
+	size=$((256 << 20))
+	create_expect_fail "set_dpa_size failed" \
+		-d "$x2_decoder" -m "$pos0 $pos1 $pos2 $pos3" \
+		-s $((size * 4))
+
+	dpa_after="$(reserved_dpa)"
+	if [[ "$dpa_after" != "$dpa_before" ]]; then
+		echo "dpa left reserved by the failed create:"
+		diff <(echo "$dpa_before") <(echo "$dpa_after") || true
+		err "$LINENO"
+	fi
+
+	destroy_regions "$filler"
+}
+
 # test region creation on devices behind a single-port host-bridge
 create_single
 
@@ -355,6 +406,7 @@ done
 
 create_csv_targets
 refuse_bad_target_list
+release_dpa_on_failure
 
 # Repeat x1/x2/x3/x4 region creation with XOR interleave arithmetic.
 load_cxl_test interleave_arithmetic=1
-- 
2.37.3

