Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C2627F4DD
	for <nvdimm@lists.linux.dev>; Thu,  6 Mar 2025 23:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741305025; cv=none; b=unkANfJ6kNVj9Qf23zIy1fO2dN9fhmTwWm65xj/PhMHDl+O4i++E6Naq7xNKNnximgoY7xGKi3GOOz2oJ5PVJ6zqU4LbYiUeOK4J2J8Q1wblCpSjqnzOq/YJgI0lZpzeXtu3paLQsE3sHmucVn8SEWgyielOLrfI5712N5jAABE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741305025; c=relaxed/simple;
	bh=JZk5PtUv4rBJbKlmbceIqvgHXrWy7tsqGjIyhgvhNIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9hPiR9DHygieCEXgpPB75EgkNOc74eKByx2HnjwqLS1DHgDN3wLIVMt8PrjbA4kyw7cA6dbq9t1QFoiFiBR+FZyBo24kDGb5XSzeM9nJRn7C7WSdYVz3uNCwwb5YPg5xyE4/lfWrYro8KB0Gj2+UcFmBa73HInDuIGNQLdybXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pt7mUyYX; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pt7mUyYX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741305024; x=1772841024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JZk5PtUv4rBJbKlmbceIqvgHXrWy7tsqGjIyhgvhNIQ=;
  b=Pt7mUyYX0l+eBlClekZHaV+Vb/TGD0cyqiB0g5A4n1NH58x4CXZnO3Wu
   nm2ZHKUHaTpPG7DMAJgtv4hS5/gKuuovbvwE8M+B4eapUltNCpHkfDLX/
   PpneoC80+OVNYCkWk45EytKF+TvKN3aJpzTPea4MzEENTCsRgpXdOqHc9
   AnyVbObKKzPmryn/XRR69j53Fx3BgEiYEBiGAIlEUTgtZj0sxjzc8YcBb
   uq1O3AYqWVFIWOiSX6FuSYEEoEnc5s671pCBry6WHbkP6DZc6YhwQVrpl
   K+ClzSEBEIf4JssMmmsZqPEFKg1ROpI18assMCSZ/UT0twueqp30PyMpV
   Q==;
X-CSE-ConnectionGUID: 3Aqgy8ojSCaYE3z9YrbEgQ==
X-CSE-MsgGUID: Esp25SyCR+Owx6kUjPv1fw==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="45150088"
X-IronPort-AV: E=Sophos;i="6.14,227,1736841600"; 
   d="scan'208";a="45150088"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 15:50:24 -0800
X-CSE-ConnectionGUID: ZtU+kcNxRti96ObumzK9/Q==
X-CSE-MsgGUID: xolm0kYnTKejc3wkAVf2qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="123358738"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.63])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 15:50:23 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v2 5/5] ndctl/namespace: protect against under|over-flow w bad param.align
Date: Thu,  6 Mar 2025 15:50:14 -0800
Message-ID: <5f8a8a6cf332ec9ceb636180b9dd5cbf801f1e6e.1741304303.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1741304303.git.alison.schofield@intel.com>
References: <cover.1741304303.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

A coverity scan highlighted an integer underflow when param.align
is 0, and an integer overflow when the parsing of param.align fails
and returns ULLONG_MAX.

Add explicit checks for both values.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/namespace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 2cee1c4c1451..e443130a5a93 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -2087,7 +2087,11 @@ static int namespace_rw_infoblock(struct ndctl_namespace *ndns,
 			unsigned long long size = parse_size64(param.size);
 			align = parse_size64(param.align);
 
-			if (align < ULLONG_MAX && !IS_ALIGNED(size, align)) {
+			if (align == 0 || align == ULLONG_MAX) {
+				error("invalid alignment:%s\n", param.align);
+				rc = -EINVAL;
+			}
+			if (!IS_ALIGNED(size, align)) {
 				error("--size=%s not aligned to %s\n", param.size,
 					param.align);
 
-- 
2.37.3

