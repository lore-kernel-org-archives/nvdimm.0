Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D367E143895
	for <nvdimm@lists.linux.dev>; Tue,  4 Mar 2025 00:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048646; cv=none; b=oxeeRm1iPUftWY13LQadGy8YQMA2bZkNmHziTZ35iMoAUoDUMvOeegnsCjiuM73LtuStfKhwvvCGykYXQV35LL5aGyO4JUeYOrlIQeEX3wPHLRRborBSjR5JBQy5yFAU0rJ9wJOR8wZNOTLj26C4TO9xsWcNy9qsdOda3/Nojls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048646; c=relaxed/simple;
	bh=ip3KFiej9WWi14440XhivtSdu74NlUvPodFuK5elP2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiXH4sl1FQuC1/E6wxCOvLWSkwomFGxevelk/VQZ+xC7q5UwbsSjvMRzCN0sP0rceHp8rmYfVMpZvG4B/D/MaU00IkeFgDS107sVdXMwmKPmbwtkI5Bo3CzJVjlgDkuO5zwiP3EWQB5TY9pDrQDd6JvJZtU0EPACY2zvCZiE11c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mx/2Oasd; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mx/2Oasd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741048645; x=1772584645;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ip3KFiej9WWi14440XhivtSdu74NlUvPodFuK5elP2c=;
  b=Mx/2Oasdjrhla0CahwnvkhyYXNCpC1fspcz3DLkmy/o9E1XC8hZQBMlJ
   mLN6+6Q1ZA3XGg/muxDsdRWG7LdD538M5ZI4qDVJwSBPYE2Z8vqfZ53t0
   8ZlBez9QBvj3Xyhlzen190NtLcLHmIZe2xJjPVVZvKXJWTzPhXpqz43Nd
   Qd/r3O8vns0me8m+G8vcp7WnSxrNKQAhMRCXcJnLJc0k7tsFvTUJW5YRp
   L5So3w4DyjtiwBxwB/AATnkLLlz0x9k58dsn/AcvBtYUikb/0u7lcTj9v
   eBKNFkYQwPyCBmh4zEmzCHE6N56JCoKYMGsFqxOMhAqaqy3J73eO0cBTk
   A==;
X-CSE-ConnectionGUID: r+uDf4GCStSnS67m1VVi1g==
X-CSE-MsgGUID: 0zPNU8YtTgqw+WeR3hlxUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41975323"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="41975323"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 16:37:24 -0800
X-CSE-ConnectionGUID: UgUraKQETdaqaqo+L0KPDg==
X-CSE-MsgGUID: o+ISXLzlSV2bkv1gWXTOmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="141427162"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.109.46])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 16:37:23 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 5/5] ndctl/namespace: protect against under|over-flow w bad param.align
Date: Mon,  3 Mar 2025 16:37:11 -0800
Message-ID: <3692da31440104c890e59b8450e4a6472f3eded8.1741047738.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1741047738.git.alison.schofield@intel.com>
References: <cover.1741047738.git.alison.schofield@intel.com>
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
---
 ndctl/namespace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 40bcf4ca65ac..3224c9ff4444 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -2086,7 +2086,11 @@ static int namespace_rw_infoblock(struct ndctl_namespace *ndns,
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

