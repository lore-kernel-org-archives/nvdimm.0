Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D84328610
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 22:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774303313; cv=none; b=cTHrJZxqFQA8WysKhkuL2DIRaIOHQJ7o2aOkuuZY+1iV0Qd0g4ugNO9FP9qUN9nKlPmpZNOpRqk1MEpKmAp/KhXaJ57u5OVNY3c5291FqUXnf0Mgp6ys1IbEFYPs2q2bxebnn5nV4GtdXT/wxJ9v8yrEv00sFmcIlM9Bo1wkbCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774303313; c=relaxed/simple;
	bh=+8rSN94GZiN9Oct5W3sB0FcNwCZNOAzS5O8e7weP9B8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sKvGsYdxmRlrN/9ZzV9NM/CToIT/Yb2HS/ZqCqKOM519YoDp+cvg9KxZiOY038hrAk/ATbVk6V+Atq7cIgvRVjVrCxw44xGKRQ/ZQx0Aew5w8vpvkn7RObg18WuQ5c6JMLX+rgtn7SS+oKyC3VX5D8hSJFWnmLSxdi4e1Lghczg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V7lMOfkE; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V7lMOfkE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774303312; x=1805839312;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+8rSN94GZiN9Oct5W3sB0FcNwCZNOAzS5O8e7weP9B8=;
  b=V7lMOfkEymiNmYeeLxk3pSEkVaUmrkBVhjMRRrlFupjgvZhnKhPF8jP5
   rwl8Z2tGgXbhoQbvxGrD+PQrnZEOd0vaWq6gO4bVMnbTkEskmfD6WzKjX
   xb8b1RMYFFHBuXwZhGfhR9DAHP7n8tC95P4rjE+qZXVc8SOgP0/rVM10A
   9m5PGT/EQFLsPpxdsG29quY9vVaf2Whxt+E1fsw949C9Ovy8SBOhozyDi
   QvHoLxG/olo8zUiI+a0Fh8MCXAW/X54APJ7QX4VaON2saFIgBV4mO0h3h
   JRjasuROLrCkT2srvAIKM12rilRqCqNTxm5OYcWULHetDVoiy7yQ2IFOo
   Q==;
X-CSE-ConnectionGUID: t2oMjdrXQwG7ZJ3ynSIwXg==
X-CSE-MsgGUID: Nm+MCVghTRqJatMzSPpdaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="75220424"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="75220424"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 15:01:52 -0700
X-CSE-ConnectionGUID: mt2+EDbsQ4eQWq0TYgvWvg==
X-CSE-MsgGUID: osSjAhw3SMGD71lihvfjRA==
X-ExtLoop1: 1
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.43])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 15:01:51 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] test/cxl-topology.sh: verify dax device creation for auto region
Date: Mon, 23 Mar 2026 15:01:44 -0700
Message-ID: <20260323220148.2620066-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The auto-discovered CXL region should create a dax device with
matching size and resource mapping. A recent regression in the
no-soft-reserved case broke this behavior without test coverage.

Expand the existing auto-region check to validate the dax device.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-topology.sh | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index d9475b1bae9c..170c9caf840b 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -22,12 +22,24 @@ rc=1
 # paired update must be made to this test.
 
 # validate the autodiscovered region
-region=$("$CXL" list -R | jq -r ".[] | .region")
-if [[ ! $region ]]; then
-	echo "failed to find autodiscovered region"
-	err "$LINENO"
-fi
+region_json=$("$CXL" list -R -u)
+[ -n "$region_json" ] || err "$LINENO"
+region=$(jq -r '.region // empty' <<<"$region_json")
+region_size=$(jq -r '.size // empty' <<<"$region_json")
+region_resource=$(jq -r '.resource // empty' <<<"$region_json")
+[ -n "$region" ] || err "$LINENO"
+[ -n "$region_size" ] || err "$LINENO"
+[ -n "$region_resource" ] || err "$LINENO"
 
+# validate the dax device created for the autodiscovered region
+dax_json=$("$DAXCTL" list -r "$region" -DMu)
+[ -n "$dax_json" ] || err "$LINENO"
+dax_dev=$(jq -r '.chardev // empty' <<<"$dax_json")
+dax_size=$(jq -r '.size // empty' <<<"$dax_json")
+dax_start=$(jq -r '.mappings[0].start // empty' <<<"$dax_json")
+[ -n "$dax_dev" ] || err "$LINENO"
+[ "$dax_size" = "$region_size" ] || err "$LINENO"
+[ "$dax_start" = "$region_resource" ] || err "$LINENO"
 
 # collect cxl_test root device id
 json=$($CXL list -b cxl_test)

base-commit: 99da468880dba2ec61ba2d9fdf8d48fc3bae085e
-- 
2.37.3

