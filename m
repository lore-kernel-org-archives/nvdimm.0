Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F96136358
	for <nvdimm@lists.linux.dev>; Tue,  6 Jan 2026 03:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767671537; cv=none; b=llCJInPP6iqZetx1IRxHx7FaZnbHHCV9C4lWYHcnKM/5CWxYMoBYpSHcjNDEmgoTqbXyYPKjm4lqKGlMOLNkhk6B3FkecvgP4YhRLxczOjbylJvJlc3wjV15BjMhig9vNKwVu2O6KFxbNu4fGW8ZdKxOomyhlX4rc5H2lrLbbcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767671537; c=relaxed/simple;
	bh=pUWJLgBx7pHR9sw6BfB7hxPLapf4ZXsAA1L5bmobPbs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dvtyQMtmlC2Zmv4lVc3trxm6Oh3BniCbbQKb4duiUwnnAwqZxm9ODtBDVWRJpYBVOpJNPj9LIRLvCTCX2V8QagAZP1vLnX18jW2dgzNNtVOIQE/83t3MZuZgXSz3dT/A/Yx4bJDl9Mqk2dFFKjNm4qojZ7tf2GLCcXvaMo7dhEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GMpkxynT; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GMpkxynT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767671537; x=1799207537;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pUWJLgBx7pHR9sw6BfB7hxPLapf4ZXsAA1L5bmobPbs=;
  b=GMpkxynTIv6YCkhcAdM9EPxiny4gkxpBBoDoLQg48JFgZvnC9rzZcGkr
   4ghzO/Re39n4yZSO2qfvaLAwiC6hYvaM3Tl6K0e4X7NkRJ+Ixzoe/A+wC
   rcSx5NH78kYDsIUVyhLrEDmRw6V71cCVIVpA6nij7JXhH9NG5KzDRfKBu
   vo/qB5A2isnyeDW6me8UMuifG/UEujocGgZzbT72dDmv63qvirVNiwZgZ
   Ynpde8itCuIaAILgndWSGD3Pz2bONPkcPwpHYTJvBgYbkVU0j+vXqEuNU
   CTm3+mFIY0EvxLQQkXiVJIsDZEpBWeqyY1uNTAxrEi36PNMwf8mjMkDB9
   Q==;
X-CSE-ConnectionGUID: LdtylgnbS1qsOM+rTHy1gw==
X-CSE-MsgGUID: EQns17fPQcSezAVguFtrqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="91693569"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="91693569"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 19:52:16 -0800
X-CSE-ConnectionGUID: J/jV729zRFeKsZ8G9ku4jg==
X-CSE-MsgGUID: pt1q4HIpR2m/7FUzjlvyxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="203520737"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.18])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 19:52:15 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	Cristian Rodriguez <yo@cristianrodriguez.net>
Subject: [ndctl PATCH] ndctl/lib: move nd_cmd_pkg with a flex array to end of structures
Date: Mon,  5 Jan 2026 19:52:04 -0800
Message-ID: <20260106035209.322010-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Placing nd_cmd_pkg anywhere but at the end of a structure can lead to
undefined behavior for the flex array member. Move nd_cmd_pkg to the
end of all affected structures.

Reproduce using Clang:
~/git/ndctl$ rm -rf build
~/git/ndctl$ CC=clang meson setup build
~/git/ndctl$ meson compile -C build

../ndctl/lib/hpe1.h:324:20: warning: field 'gen' with variable sized type 'struct nd_cmd_pkg' not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]

Reported-by: Cristian Rodriguez <yo@cristianrodriguez.net>
Closes: https://github.com/pmem/ndctl/issues/296
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 ndctl/lib/hpe1.h      | 2 +-
 ndctl/lib/hyperv.h    | 2 +-
 ndctl/lib/intel.h     | 2 +-
 ndctl/lib/msft.h      | 2 +-
 ndctl/lib/papr.h      | 2 +-
 ndctl/libndctl-nfit.h | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/ndctl/lib/hpe1.h b/ndctl/lib/hpe1.h
index bc19f72ca8d0..99d8f57eb8e0 100644
--- a/ndctl/lib/hpe1.h
+++ b/ndctl/lib/hpe1.h
@@ -321,8 +321,8 @@ union ndn_hpe1_cmd {
 };
 
 struct ndn_pkg_hpe1 {
-	struct nd_cmd_pkg gen;
 	union ndn_hpe1_cmd u;
+	struct nd_cmd_pkg gen;
 } __attribute__((packed));
 
 #define NDN_IOCTL_HPE1_PASSTHRU		_IOWR(ND_IOCTL, ND_CMD_CALL, \
diff --git a/ndctl/lib/hyperv.h b/ndctl/lib/hyperv.h
index 45741c7cdd17..9157f1563632 100644
--- a/ndctl/lib/hyperv.h
+++ b/ndctl/lib/hyperv.h
@@ -31,8 +31,8 @@ union nd_hyperv_cmd {
 } __attribute__((packed));
 
 struct nd_pkg_hyperv {
-	struct nd_cmd_pkg	gen;
 	union  nd_hyperv_cmd	u;
+	struct nd_cmd_pkg	gen;
 } __attribute__((packed));
 
 #endif /* __NDCTL_HYPERV_H__ */
diff --git a/ndctl/lib/intel.h b/ndctl/lib/intel.h
index 5aee98062a84..09f8cf7745ce 100644
--- a/ndctl/lib/intel.h
+++ b/ndctl/lib/intel.h
@@ -141,7 +141,6 @@ struct nd_intel_lss {
 } __attribute__((packed));
 
 struct nd_pkg_intel {
-	struct nd_cmd_pkg gen;
 	union {
 		struct nd_intel_smart smart;
 		struct nd_intel_smart_inject inject;
@@ -154,6 +153,7 @@ struct nd_pkg_intel {
 		struct nd_intel_fw_finish_query fquery;
 		struct nd_intel_lss lss;
 	};
+	struct nd_cmd_pkg gen;
 };
 
 #define ND_INTEL_STATUS_MASK		0xffff
diff --git a/ndctl/lib/msft.h b/ndctl/lib/msft.h
index 8d246a5ed137..65789950abe1 100644
--- a/ndctl/lib/msft.h
+++ b/ndctl/lib/msft.h
@@ -41,8 +41,8 @@ union ndn_msft_cmd {
 } __attribute__((packed));
 
 struct ndn_pkg_msft {
-	struct nd_cmd_pkg	gen;
 	union ndn_msft_cmd	u;
+	struct nd_cmd_pkg	gen;
 } __attribute__((packed));
 
 #define NDN_MSFT_STATUS_MASK		0xffff
diff --git a/ndctl/lib/papr.h b/ndctl/lib/papr.h
index 77579396a7bd..4f35bc60017f 100644
--- a/ndctl/lib/papr.h
+++ b/ndctl/lib/papr.h
@@ -8,8 +8,8 @@
 
 /* Wraps a nd_cmd generic header with pdsm header */
 struct nd_pkg_papr {
-	struct nd_cmd_pkg gen;
 	struct nd_pkg_pdsm pdsm;
+	struct nd_cmd_pkg gen;
 };
 
 #endif /* __PAPR_H__ */
diff --git a/ndctl/libndctl-nfit.h b/ndctl/libndctl-nfit.h
index 9ec0db55776d..020dc7384a98 100644
--- a/ndctl/libndctl-nfit.h
+++ b/ndctl/libndctl-nfit.h
@@ -77,13 +77,13 @@ struct nd_cmd_ars_err_inj_stat {
 } __attribute__((packed));
 
 struct nd_cmd_bus {
-	struct nd_cmd_pkg gen;
 	union {
 		struct nd_cmd_ars_err_inj_stat err_inj_stat;
 		struct nd_cmd_ars_err_inj_clr err_inj_clr;
 		struct nd_cmd_ars_err_inj err_inj;
 		struct nd_cmd_translate_spa xlat_spa;
 	};
+	struct nd_cmd_pkg gen;
 };
 
 int ndctl_bus_is_nfit_cmd_supported(struct ndctl_bus *bus, int cmd);
-- 
2.37.3

