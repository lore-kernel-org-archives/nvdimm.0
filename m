Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D0730CEE
	for <nvdimm@lists.linux.dev>; Tue, 26 Sep 2023 18:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695753943; x=1727289943;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wALDOfDch1TypPPb0YRrudhRYM25aDx55qWGrSyEGzQ=;
  b=Ym4U5hAeiXWwJYSui0uEbTryVbf88GNp2gJXPOogG+X64OjARZp1gpkW
   iDnGtao8D2y0VIW+H2j/MI7GRk5pPRL/jI3ql5R8mZsOQAwf+zRZkaGAD
   Qe/SQcfDbCdEekIV4jihXxO8CVPP7qCGweN6l438Oh6gjk0XdPHnf1Lqs
   5+8ZgkYeQLMmIjeBKY+noFlnczM9qeUQMrr+E89ZEtFk1sNfdbuL/VCnY
   Kg01BBjeDLnU4N2ACONmAtt6wXMYjLIObqztPDt+Jfgqsgzel4Ji5Qm/2
   pCMGSz9KKwdyrwUzCC789cMGY3nukF34spjftqsW+U4TYmTSsAVnRujD2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="378920253"
X-IronPort-AV: E=Sophos;i="6.03,178,1694761200"; 
   d="scan'208";a="378920253"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 11:45:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="752279630"
X-IronPort-AV: E=Sophos;i="6.03,178,1694761200"; 
   d="scan'208";a="752279630"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 11:45:28 -0700
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: rafael.j.wysocki@intel.com,
	andriy.shevchenko@intel.com,
	lenb@kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH v1 0/2] Fix memory leak and move to modern scope based rollback
Date: Tue, 26 Sep 2023 21:45:18 +0300
Message-ID: <20230926184520.2239723-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In acpi_nfit_init_interleave_set() there is a memory leak + improper use
of devm_*() family of functions for local memory allocations. This patch
series provides two commits - one is meant as a bug fix, and could
potentially be backported, and the other one improves old style rollback
with scope based, similar to C++ RAII [1].

Link: https://lwn.net/Articles/934679/ [1]

Michal Wilczynski (2):
  ACPI: NFIT: Fix memory leak, and local use of devm_*()
  ACPI: NFIT: Use modern scope based rollback

 drivers/acpi/nfit/core.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

-- 
2.41.0

