Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A804F170A0B
	for <nvdimm@lists.linux.dev>; Wed, 14 May 2025 18:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747249033; cv=none; b=PNxIGir60eP5iofVf0sgBIwz820r10ApUzm2fWyIBgeoWpNm2uk920lG1Em77YeTxwj9vhneFdIEX8V//3wes0qvKjujuI6KKrL9J/UDADV7PL8av0RfshVisUecTLXDiSF8CgaePNPdVqKyE0pnxO/F9judhOkv+Gx1KV7QyAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747249033; c=relaxed/simple;
	bh=qBq3QqQ4CIqMXLglZw/B21CIV/w8jZaKlK96XZspK6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D01Ikbw87BVYcqBeASR2RV0tpT7Zd1NduDsiqhbyItzN04HFhR1G+fRYUxdom3Haq2NozeGKj1rScUtUBM+WQcgsaJEMiUNKDEmKEazqaxAhr5LuYgIiIUoEWLVqwCeMd/DR22Zu/nQt51nMVjn/OADEnySc+C5kPfAvcnNhmcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HotASnDB; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HotASnDB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747249032; x=1778785032;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qBq3QqQ4CIqMXLglZw/B21CIV/w8jZaKlK96XZspK6Y=;
  b=HotASnDB1xXdr4Cpm4fG0Bc6Ie7xieWdfZ9UD7YXCTNtrz9Av/VTFeHe
   pDlekW3roWDHbwMUM2KCZqW0XykV4nUjcLd0cBJD+C8kH1xccPfAZLjmr
   QmMHQF2mb4Q8P0U9rXYbhmjO4U+/eeAC2vteu6XtPB7P33z4yzeEjRQfy
   gLw13Xe58sjcT9iuQMVl/dI9gedd1mYMwbEgS1piqodm59XgwYL5fNW5h
   8785VuRmgMOUh+3BEDhQ243LCf6oIKuHQ442xbEF5MEMvfQQwowufnbWF
   z5GZxC78dGidrGH6TBIhG4ei64WXOzT1kRjur0dKAvVb9U5XUK+MWsOkd
   Q==;
X-CSE-ConnectionGUID: bnJu6heuRIyP8SWKdn6RRQ==
X-CSE-MsgGUID: 5NICZlT0S8CjJYS2dJW4Iw==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="48274711"
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="48274711"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 11:57:10 -0700
X-CSE-ConnectionGUID: UuF9trKIQGigbc5c6moa3Q==
X-CSE-MsgGUID: zI++eB80R32LPWbFm6pjcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="142900044"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.124])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 11:57:09 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] test/meson.build: use the default POSIX locale for unit tests
Date: Wed, 14 May 2025 11:57:05 -0700
Message-ID: <20250514185707.1452195-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

A user reported that unit test inject-smart.sh fails with locale
set to LANG=cs.CZ-UTF-8.[1] That locale uses commas as separators
whereas the unit test expects periods.

Set LC_ALL=C in the meson.build test environment to fix this and
to make sure the bash scripts can rely on predictable output when
parsing in general.

This failing test case now passes:
LANG=cs.CZ.UTF-8 meson test -C build inject-smart.sh

Tidy up by moving the test_env definition out of the for loop.

[1] https://github.com/pmem/ndctl/issues/254

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/meson.build | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/test/meson.build b/test/meson.build
index 2fd7df5211dd..774bb51e4eb2 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -235,6 +235,15 @@ if get_option('keyutils').enabled()
   ]
 endif
 
+test_env = [
+    'LC_ALL=C',
+    'NDCTL=@0@'.format(ndctl_tool.full_path()),
+    'DAXCTL=@0@'.format(daxctl_tool.full_path()),
+    'CXL=@0@'.format(cxl_tool.full_path()),
+    'TEST_PATH=@0@'.format(meson.current_build_dir()),
+    'DATA_PATH=@0@'.format(meson.current_source_dir()),
+]
+
 foreach t : tests
   test(t[0], t[1],
     is_parallel : false,
@@ -252,12 +261,6 @@ foreach t : tests
     ],
     suite: t[2],
     timeout : 600,
-    env : [
-      'NDCTL=@0@'.format(ndctl_tool.full_path()),
-      'DAXCTL=@0@'.format(daxctl_tool.full_path()),
-      'CXL=@0@'.format(cxl_tool.full_path()),
-      'TEST_PATH=@0@'.format(meson.current_build_dir()),
-      'DATA_PATH=@0@'.format(meson.current_source_dir()),
-    ],
+    env : test_env,
   )
 endforeach
-- 
2.37.3

