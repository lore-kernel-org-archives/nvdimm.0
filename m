Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C65101EA
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 04:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="csDxmb54"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701144711; x=1732680711;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ip5PyEhyvYbbRH/6U5LIUuhALeMlHi0XxMtqRdbksTc=;
  b=csDxmb54tZBgDiHZisze626eiUi8uMKWf38pwjAk0zbf+XsoLbazlsQz
   tWyrkt7hncy1Vxq3ARxGvH0PKOC9wDXrgKSBnazQHewpIntShNtc6ZIQa
   zZEMYLMb53AZgINN14zg7G0AYuUOGsyb556ju0MG+qTX+dydqKV865ryp
   ApWp97Ny0PkS9JXlNDosqz3LLkW/g8PMX+r8PgMAFkeCyhYzG6vX8Sea3
   Ko/87SD3t0fSWQh5cbdeJM/Dk3QOFV1VTwNBMiSQu5v+aYDwzZYbmyova
   KM1VHWS9B8yRrF+sIrnwzHRHgJX0B8/FbgZs8n2AUvQjo5o+L+azCDBIu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="390001067"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="390001067"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 20:11:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="891948439"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="891948439"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.170.56])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 20:11:45 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 2/3] cxl/test: add a cxl_ derivative of check_dmesg()
Date: Mon, 27 Nov 2023 20:11:41 -0800
Message-Id: <39c11efdefeb12c3c928f36e9c59eeb40a841e72.1701143039.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1701143039.git.alison.schofield@intel.com>
References: <cover.1701143039.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

check_dmesg() is used by CXL unit tests as well as by a few
DAX unit tests. Add a cxl_check_dmesg() version that can be
expanded for CXL special checks like this:

Add a check for an interleave calculation failure. This is
a dev_dbg() message that spews (success or failure) whenever
a user creates a region. It is useful as a regression check
across the entire CXL suite.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/common | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/test/common b/test/common
index 7a4711593624..c20b7e48c2b6 100644
--- a/test/common
+++ b/test/common
@@ -151,6 +151,19 @@ check_dmesg()
 	true
 }
 
+# cxl_check_dmesg
+# $1: line number where this is called
+cxl_check_dmesg()
+{
+	sleep 1
+	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
+	# validate no WARN or lockdep report during the run
+	grep -q "Call Trace" <<< "$log" && err "$1"
+	# validate no failures of the interleave calc dev_dbg() check
+	grep -q "Test cxl_calc_interleave_pos(): fail" <<< "$log" && err "$1"
+	true
+}
+
 # cxl_common_start
 # $1: optional module parameter(s) for cxl-test
 cxl_common_start()
@@ -170,6 +183,6 @@ cxl_common_start()
 # $1: line number where this is called
 cxl_common_stop()
 {
-	check_dmesg "$1"
+	cxl_check_dmesg "$1"
 	modprobe -r cxl_test
 }
-- 
2.37.3

