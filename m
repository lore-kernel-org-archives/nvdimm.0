Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC84E17F1
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 01:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663292105; x=1694828105;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mIHXnsOvdekewSe6mYzd3yIs+UBS133p9gdzBdK5lWI=;
  b=dfWwerHBa9NRhqNTSxwz7BJtvCcJoK74BPJiUEcwYUXiX9wNhRL+W4OP
   mrOcKrKYj8NezPizhSWDr7bYTa3EUkxwNpfBY2/kiICqonXqCYCluDEJk
   5Gs5o8SPEzqfHB/ARWlLhkNKKtoOV8Uc2nUT6widRNqPTNJQ2iLM0vPTo
   +ulGUKba57YwsM3b2/8Yp3jRw6U6Cfz6IhXeuFX0dzHnpOYWtXYSf7VsJ
   gqDG9p3L2pPgkb6GJ5oNZyzEMOgmuCxYwo0KViBULdvEUvpBtrxT24cbw
   I+X868R7Ch92WSPDJYKGImL2dtT+CoDRtIEYUN/R7Ak6eokM25/5jreVx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="300247778"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="300247778"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 18:35:05 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="743164747"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.120.139])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 18:35:05 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 0/2] Add CXL XOR region test
Date: Thu, 15 Sep 2022 18:35:00 -0700
Message-Id: <cover.1663290390.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

These patches, although not tied to each other, both depend upon
this cxl_test patch:
https://lore.kernel.org/linux-cxl/5a33e3d0b182308a3a783ac8685fd2728bb64a22.1663291370.git.alison.schofield@intel.com/

cxl/test: add cxl_xor_region test
	Depends on: tools/testing/cxl: Add XOR math support

cxl/test: allow another host bridge in cxl-topology check
	This patch syncs cxl-topology test with the cxl_test changes

Alison Schofield (2):
  cxl/test: add cxl_xor_region test
  cxl/test: allow another host bridge in cxl-topology check

 test/cxl-topology.sh   |   6 +-
 test/cxl-xor-region.sh | 126 +++++++++++++++++++++++++++++++++++++++++
 test/meson.build       |   2 +
 3 files changed, 131 insertions(+), 3 deletions(-)
 create mode 100644 test/cxl-xor-region.sh


base-commit: c9c9db39354ea0c3f737378186318e9b7908e3a7
-- 
2.31.1

