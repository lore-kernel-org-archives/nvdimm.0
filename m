Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7AA101F9
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 04:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TdCDvzH8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701144711; x=1732680711;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s23M8GQJ0QGy6Tw/q4SmIxShJcKb+Z5G+O+sswjlU30=;
  b=TdCDvzH8Wi4N5+JceZYtaoI2Xn0UMC9BGm5P3CWZcxpIRWcvuoXyugE1
   eRCeyDcP02OTIBeZIr3kg8Q+RS7kuPBlAYvn8ZdWTBDFuNRbyZ1sJBu34
   NzWTyuxdvnzF+ZEjzSCCC+hoNmsBybWPbKyWemI9dIsZYxn/5IFwF3pRN
   GGgzBU11HW4Pef7c2iqIA5oApwF9+kZoNyIQKB56c4GK9ePThI1SEXnXt
   vsU4T39Epg5uR/6NsMJP2Dk9JQ2/VgOxF5Lwxo5uO4myjznRsC84GB4wV
   eT+IEe4Z1fSnvBMJdEB/nNvHpkHuKLo3o9zTZ7aAZ6GAm6X3yLpEAJbRm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="390001070"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="390001070"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 20:11:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="891948442"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="891948442"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.170.56])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 20:11:46 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 3/3] cxl/test: use an explicit --since time in journalctl
Date: Mon, 27 Nov 2023 20:11:42 -0800
Message-Id: <1802cf15f22fe5c284167a9186eba8f2cd3c31c6.1701143039.git.alison.schofield@intel.com>
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

Using the bash variable 'SECONDS' plus 1 for searching the
dmesg log sometimes led to one test picking up error messages
from the previous test when run as a suite. SECONDS alone may
miss some logs, but SECONDS + 1 is just as often too great.

Since unit tests in the CXL suite are using common helpers to
start and stop work, initialize and use a "starttime" variable
with millisecond granularity for journalctl.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/common | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/test/common b/test/common
index c20b7e48c2b6..93a280c7c150 100644
--- a/test/common
+++ b/test/common
@@ -156,7 +156,7 @@ check_dmesg()
 cxl_check_dmesg()
 {
 	sleep 1
-	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
+	log=$(journalctl -r -k --since "$starttime")
 	# validate no WARN or lockdep report during the run
 	grep -q "Call Trace" <<< "$log" && err "$1"
 	# validate no failures of the interleave calc dev_dbg() check
@@ -175,6 +175,7 @@ cxl_common_start()
 	check_prereq "dd"
 	check_prereq "sha256sum"
 	modprobe -r cxl_test
+	starttime=$(date +"%T.%3N")
 	modprobe cxl_test "$1"
 	rc=1
 }
-- 
2.37.3

