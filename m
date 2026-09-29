Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29CC3F23BD
	for <nvdimm@lists.linux.dev>; Tue, 29 Sep 2026 05:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790660231; cv=none; b=Pwk4pWa+mZhh9z5SOzQcDb4+1UQxQryKNYye7KV/ji8UX6DMWjDlZX44DUpjkscgdGok8h9BY0EalOBOBkoY3/w12B5bGIw3/bxLS4hQeEpj4ofUq2I06EIhauvDSyLutfGn/me29LcLaxxgY+jGaQ1vztMBVa+MQyZKyIz3y08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790660231; c=relaxed/simple;
	bh=m7JQKFlbjiS7WePXrLpmMkujKGWCHnHFP4o14RLKbDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8p2RPbNREIZ/ZNDHoVYG2ouC2bOAuk32s1EgM+58rT2OW6MSifOJ06PsUs97GYoV+9YpQbCaAOx8PkI0AA9gzvZt3+a6ZsZTL6fTuFDaURWEsG9g0MkDKdoSVJlliBQ2cjOCouAcW0ouZ2vg+ujnMoQ9380ud9EwPApqJY74SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ki2HTtZa; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ki2HTtZa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790660229; x=1822196229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7JQKFlbjiS7WePXrLpmMkujKGWCHnHFP4o14RLKbDE=;
  b=Ki2HTtZaWbtDG17ekwSXXPxYJEI4gp0xq3Bi1dJJXYfpQoPKyXaCxHAy
   FZ4A144hCFdBLU66kf1s084IPYUH5Fx7qTVDWhwgO9OMNas2Vgmg3MuzO
   kSGaqjcA+Ww/xYfN8cs73bDGP9yE4GAch2VjOmnrrryd0LiChQa1MBs+N
   R7xWcUE4AYrsGO7vre0tUwvKxh4ynGtOeYqMdiffl+Bc5msDrwqz34Iu4
   WXvfletGixh3IEGLtVop2X6AGlwuHcD01uftnXwkiEPQqg9k83zf4uGj/
   nZWuD08e44tPYUjkLw5xB+7/qeTP2lV0iBGkjj8O2oP4Sadu+Ypmgt4gk
   A==;
X-CSE-ConnectionGUID: C7aR/laZT4GaS4jKQdBJvQ==
X-CSE-MsgGUID: DLKhKpwQSE6rM7WwIBCjSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="100700070"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="100700070"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 22:37:07 -0700
X-CSE-ConnectionGUID: RDm/hNXoScusyoSlUyZXMQ==
X-CSE-MsgGUID: az5LuCIMTAKa1N8iwpGZrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="304767476"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.149])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 22:37:07 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 4/7] cxl/region: reject duplicate or unknown target memdevs
Date: Mon, 28 Sep 2026 22:36:56 -0700
Message-ID: <6d6e1cecbda379a7499ed146c434cf99bcbfa5be.1790658549.git.alison.schofield@intel.com>
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

Target filtering silently drops unknown names and collapses overlapping
matches. cxl create-region can therefore build a smaller region than the
target list requested, or report only a ways mismatch.

Validate the target list against the resolved memdevs. Reject unmatched
targets and memdevs claimed by more than one target filter, while allowing
one filter to select multiple memdevs.

Fixes: 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-region targets")
Assisted-by: LLM
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/region.c              | 65 +++++++++++++++++++++++++++++++++++++++
 test/cxl-create-region.sh | 45 +++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/cxl/region.c b/cxl/region.c
index 43c228f2f999..2bb3b90940b0 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -222,6 +222,66 @@ static int memdev_sort(const void *a, const void *b)
 	return a_pos - b_pos;
 }
 
+/*
+ * Reject unmatched target names and overlapping target filters.
+ * A single filter may match multiple memdevs.
+ */
+static bool validate_target_list(struct json_object *jmemdevs, const char *csv)
+{
+	int i, nr_memdevs = json_object_array_length(jmemdevs);
+	const char *arg, *sep = which_sep(csv);
+	struct json_object *jobj;
+	struct cxl_memdev *memdev;
+	bool valid = true;
+	char *list, *save;
+	int *claims;
+
+	claims = calloc(nr_memdevs, sizeof(*claims));
+	if (!claims)
+		return false;
+
+	list = strdup(csv);
+	if (!list) {
+		free(claims);
+		return false;
+	}
+
+	for (arg = strtok_r(list, sep, &save); arg;
+	     arg = strtok_r(NULL, sep, &save)) {
+		int matched = 0;
+
+		for (i = 0; i < nr_memdevs; i++) {
+			jobj = json_object_array_get_idx(jmemdevs, i);
+			memdev = json_object_get_userdata(jobj);
+			if (!util_cxl_memdev_filter(memdev, arg, NULL))
+				continue;
+			claims[i]++;
+			matched++;
+		}
+
+		if (!matched) {
+			log_err(&rl, "no active memdev matches target '%s'\n",
+				arg);
+			valid = false;
+		}
+	}
+
+	for (i = 0; i < nr_memdevs; i++) {
+		if (claims[i] < 2)
+			continue;
+		jobj = json_object_array_get_idx(jmemdevs, i);
+		memdev = json_object_get_userdata(jobj);
+		log_err(&rl, "%s is named %d times in the target list\n",
+			cxl_memdev_get_devname(memdev), claims[i]);
+		valid = false;
+	}
+
+	free(list);
+	free(claims);
+
+	return valid;
+}
+
 static struct json_object *collect_memdevs(struct cxl_ctx *ctx,
 					   const char *decoder, int *count,
 					   const char **mems)
@@ -251,6 +311,11 @@ static struct json_object *collect_memdevs(struct cxl_ctx *ctx,
 	}
 
 	if (csv) {
+		if (!validate_target_list(jmemdevs, csv)) {
+			json_object_put(jmemdevs);
+			jmemdevs = NULL;
+			goto out;
+		}
 		sort_context.csv = csv,
 		json_object_array_sort(jmemdevs, memdev_sort);
 	}
diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
index 6fc845c7d382..6ffe36b852a2 100644
--- a/test/cxl-create-region.sh
+++ b/test/cxl-create-region.sh
@@ -296,6 +296,50 @@ create_csv_targets()
 	fi
 }
 
+list_regions()
+{
+	$CXL list -b cxl_test -R | jq -r ".[]? | .region" | sort | tr "\n" " "
+}
+
+# Verify failure occurs without creating a region and reports @expect.
+create_expect_fail()
+{
+	expect="$1"
+	shift
+
+	regions_before="$(list_regions)"
+
+	if out=$($CXL create-region -b cxl_test "$@" 2>&1); then
+		echo "create-region $*: expected failure, created a region"
+		err "$LINENO"
+	fi
+
+	if ! grep -Fq -- "$expect" <<< "$out"; then
+		echo "create-region $*: expected '$expect', got:"
+		echo "$out"
+		err "$LINENO"
+	fi
+
+	if [[ "$(list_regions)" != "$regions_before" ]]; then
+		echo "create-region $*: refused, but left a region behind"
+		err "$LINENO"
+	fi
+}
+
+refuse_bad_target_list()
+{
+	if ! setup_interleave_shape; then
+		echo "skipping bad target list refusals"
+		return
+	fi
+
+	create_expect_fail "$pos0 is named 2 times in the target list" \
+		-d "$x2_decoder" -m "$pos0,$pos0"
+
+	create_expect_fail "no active memdev matches target 'nomemdev'" \
+		-d "$x2_decoder" -m "$pos0,nomemdev"
+}
+
 # test region creation on devices behind a single-port host-bridge
 create_single
 
@@ -310,6 +354,7 @@ for mem in ${mems[@]}; do
 done
 
 create_csv_targets
+refuse_bad_target_list
 
 # Repeat x1/x2/x3/x4 region creation with XOR interleave arithmetic.
 load_cxl_test interleave_arithmetic=1
-- 
2.37.3

