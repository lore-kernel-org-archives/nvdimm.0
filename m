Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2281F3D52
	for <nvdimm@lists.linux.dev>; Fri, 23 May 2025 03:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747970124; cv=none; b=qatHlo6Nua2tJpEdDhcxjcNnefO0pt65N/sux5NM5jhmx2NAGO/HXyZPvRSvdIj6IzBY8A4y6JmHQ2WBqUymt71H1o0fe2hfucRrL/63oNJJb14NHdVHuciAA5pvvFAo2xyCyvZhlnmkfltsMU7D4DYzjDtiB1Iq9rhpmsuqiX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747970124; c=relaxed/simple;
	bh=ahlLJKwt5WUgyaPsMaUVfEV7gn6LitgRmwh4+SYI6iM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oO717nhj1ZohtWskXidB2YXv/sYvZhGmzyMpjK0ufZ+AhBaRkdEiPJfA7sF8d/RPL5UTWitpNKcIRvK5DXTn7uAWUG8AdSqzeUY8DWpeAZAfBOFomo02KJ/f17lGUyjr2QVAMSTnu8RCCoS7TQbG128U5yJZNqyX3oPau4n3Nx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HDxUb/8l; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HDxUb/8l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747970123; x=1779506123;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ahlLJKwt5WUgyaPsMaUVfEV7gn6LitgRmwh4+SYI6iM=;
  b=HDxUb/8lcIvsQgzn0QU2Vil8awKvhohMzSsnYHQfEnMsCyhzLdGrP1RH
   4VwUIArNLVT6lGyko1nPwn41JOk1nSDeUwdM4tSgNLSsXf/lYyy+8vDkv
   EJECukUwWmJk5VwbQ/4IRkRWOES90vKPSXyvm7Fg3agfGFM9Yxe9Q7TU0
   rESvi99+evPwCHE2jvJlgDZzVtcHZG3CSb+ZtRmVStCJ6qR2DF6cPewQN
   APbzOpWnTfsIcnYDCoAO9bW5c4awFQck4hoPz898rQTrLLarAWlj7BTDW
   Z77myYfEwypqlkdcxZjKaIVPIIvAekyhe55fAOT9+9oKUI2OILyje6HVn
   Q==;
X-CSE-ConnectionGUID: puNZpdRhRMG3Hu4ozmIlpg==
X-CSE-MsgGUID: tSD2u1CnSf2/cVGLMwVoMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="50166840"
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="50166840"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 20:15:23 -0700
X-CSE-ConnectionGUID: TIs2HPN2TWaI9sM1FgDgRQ==
X-CSE-MsgGUID: QHWuGe0CTpGlTpsVykltmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="141414014"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.202])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 20:15:22 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH] cxl/test: skip, don't fail, when kernel tracing is not enabled
Date: Thu, 22 May 2025 20:15:06 -0700
Message-ID: <20250523031518.1781309-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

cxl-events.sh and cxl-poison.sh require a kernel with CONFIG_TRACING
enabled and currently report a FAIL when /sys/kernel/tracing is
missing. Update these tests to report a SKIP along with a message
stating the requirement. This allows the tests to run cleanly on
systems without TRACING enabled and gives users the info needed to
enable TRACING for testing.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Noticed this behavior in Itaru's test results:
https://lore.kernel.org/linux-cxl/FD4183E1-162E-4790-B865-E50F20249A74@linux.dev/

 test/cxl-events.sh | 1 +
 test/cxl-poison.sh | 1 +
 2 files changed, 2 insertions(+)

diff --git a/test/cxl-events.sh b/test/cxl-events.sh
index c216d6aa9148..7326eb7447ee 100644
--- a/test/cxl-events.sh
+++ b/test/cxl-events.sh
@@ -13,6 +13,7 @@ num_info_expected=3
 rc=77
 
 set -ex
+[ -d "/sys/kernel/tracing" ] || do_skip "test requires CONFIG_TRACING"
 
 trap 'err $LINENO' ERR
 
diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 2caf092db460..6ed890bc666c 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -7,6 +7,7 @@
 rc=77
 
 set -ex
+[ -d "/sys/kernel/tracing" ] || do_skip "test requires CONFIG_TRACING"
 
 trap 'err $LINENO' ERR
 
-- 
2.37.3

