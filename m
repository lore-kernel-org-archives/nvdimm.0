Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5C222576E
	for <nvdimm@lists.linux.dev>; Thu, 30 Apr 2026 02:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777515527; cv=none; b=QaKtyMRgE6/fUd+epK2of5ZyXPJfrbHp+kJ2tBaeD1sGntDV/eQ+8sXuGe9f3Hjzi047n5DgU5DXQfAqj50jCkiS9A09h18WCSeIeJ93qjr0CdxwPVxbvLSiwhxq7pN42aquUgUx2tzFtI6IQNhfj8oMKlLD45jH9Tlcl3vYCVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777515527; c=relaxed/simple;
	bh=9bFuJ3L1xhzPN1R3334uPYw6cT1Lge07nyoomT+b84c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sw5Lxm4E6HyXjswnUeScES3qSblL167KGWuY17btA4xTeX6llqBy96dB7y+lhS2qaob5r4pb8TYUU3QsmZcitcsG1dB4n+sFa6KJ98kR0KXx/oVfdvLy/hSkQACBvbCKexQTK2OyXIleFnmX7NOEq0ppWsWueTtPnRl49VfNviA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q/O6JS8l; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q/O6JS8l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777515526; x=1809051526;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9bFuJ3L1xhzPN1R3334uPYw6cT1Lge07nyoomT+b84c=;
  b=Q/O6JS8lkGp6BXvRmnu3fU9tX8aV5z1IYXEdZIDDHQ/6lqZNr/TKwzeO
   idNYNZ4Bbg+TLYrMSyo4iw1S6MWquxGWrAWPm6nwl1g2GxbhXBuaHUbI+
   yY1SksXvvrAzGdM1Jtd3yUZAywvgwk1eQU4m9+M4MTkqxlCvb5Xsgnc5N
   G9Ra7neYTV1XV8uwG/cqA1DYuWJXUWhbb7pWdZwsW55n93vWxkk7eibbm
   PxUj0sPazyHSk28wMKUeNrEGidw8o864Es+lfTingiS2iixSmkpNFyboP
   TaBXuQJhDDNyld9EweutUjiM7yIouCOBCumbf0aY97xZVoPn1rizT1zIh
   Q==;
X-CSE-ConnectionGUID: ZlUyhKreRyCrbfTpvAJ2Iw==
X-CSE-MsgGUID: 6Kvq2vn/TfqC44yfd64CQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89551159"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="89551159"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 19:18:46 -0700
X-CSE-ConnectionGUID: tPA/SXInS5GoK7KglQgaiA==
X-CSE-MsgGUID: k9PytQwGS7ykjRhSoUsgHw==
X-ExtLoop1: 1
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.255])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 19:18:45 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] test/cxl-sanitize: avoid sanitize submit/wait race
Date: Wed, 29 Apr 2026 19:18:39 -0700
Message-ID: <20260430021843.3919334-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This test verifies that wait-sanitize blocks for the programmed
timeout after issuing sanitize on an inactive memdev.

The sanitize request is issued in the background and wait-sanitize
is called immediately after. In cxl_test, sanitize completes
asynchronously via delayed work, and the sysfs write does not block.
This creates a race where wait-sanitize may run before sanitize is
observed and return immediately.

This test has been reliable since its introduction, but recently
started failing consistently in one environment, suggesting a
timing sensitivity. It fails here:

  ((SECONDS > start + 2)) || err $LINENO

Add a short delay after backgrounding the sanitize write to make
sure that wait-sanitize can observe the in-progress operation.

A sysfs-based synchronization was considered, but no in-progress
state is exposed to user space.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-sanitize.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/test/cxl-sanitize.sh b/test/cxl-sanitize.sh
index 9c161014ccb7..d1ed598f3663 100644
--- a/test/cxl-sanitize.sh
+++ b/test/cxl-sanitize.sh
@@ -68,6 +68,9 @@ done
 set_timeout $inactive 3000
 start=$SECONDS
 echo 1 > /sys/bus/cxl/devices/${inactive}/security/sanitize &
+
+# Allow background sanitize to start before wait-sanitize can observe it
+sleep 1
 "$CXL" wait-sanitize $inactive || err $LINENO
 ((SECONDS > start + 2)) || err $LINENO
 
-- 
2.37.3

