Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8949A8472
	for <nvdimm@lists.linux.dev>; Wed, 22 Nov 2023 02:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZRKYjcND"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700619533; x=1732155533;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WBH1Pl8ZGp0ZAf6roXuYe/DXhp2k2xDn+eUEN7NDQO4=;
  b=ZRKYjcNDEg3AZBo9bLkEAn1Nut1lfFK3+VC/EAF8CsSSHTqfginWX7Y/
   QgO9xrKipld0kCqtpj4AxtPvlfcab1llMVxzS4Hz0X5mQsW0Jo7aa6yDS
   iQRMb1Zn4y6Q9x3QAbOMjvyWxJrXfl5nvai6MDJB3lDF+p3LsNym0zhCF
   pw+ZVyLdwF2Kujx0kAANJN9p15zPBnHtw3LmdbIU5U5dPyv+2BR268JES
   P+A/kow180h3x6I3sHTPZ86TsIF9v4LICTi5mWVsrwsFt/w21fqyOfulf
   bezPXyukizuYzcUdrCelonj7lgSgw3mzJqPoniUHksySikKAqNUdk/295
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="10635125"
X-IronPort-AV: E=Sophos;i="6.04,217,1695711600"; 
   d="scan'208";a="10635125"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 18:18:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="910649214"
X-IronPort-AV: E=Sophos;i="6.04,217,1695711600"; 
   d="scan'208";a="910649214"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.90.75])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 18:18:52 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH] cxl/test: validate the auto region in cxl-topology.sh
Date: Tue, 21 Nov 2023 18:18:49 -0800
Message-Id: <20231122021849.1208967-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The cxl-test module sets up a region to be autodiscovered in
order to test the CXL driver handling of BIOS defined regions.
Confirm the region exists upon load of the cxl-test module.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

The region does survive the ensuing shenanigans of this test.
The region state moves from committed to disabled and back
again as the memdevs, ports, and host bridges are disabled
and then re-enabled. Although that was interesting, it's not
clear that this test should be doing region error recovery
testing. 
Let me know if you think otherwise?


 test/cxl-topology.sh | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index 89d01a89ccb1..e8b9f56543b5 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -21,6 +21,14 @@ rc=1
 # tools/testing/cxl/test/cxl.c. If that model ever changes then the
 # paired update must be made to this test.
 
+# validate the autodiscovered region
+region=$("$CXL" list -R | jq -r ".[] | .region")
+if [[ ! $region ]]; then
+	echo "failed to find autodiscovered region"
+	err "$LINENO"
+fi
+
+
 # collect cxl_test root device id
 json=$($CXL list -b cxl_test)
 count=$(jq "length" <<< $json)

base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
-- 
2.37.3

