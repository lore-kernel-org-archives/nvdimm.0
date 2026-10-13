Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D10613957E
	for <nvdimm@lists.linux.dev>; Tue, 13 Oct 2026 04:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791864883; cv=none; b=a3r9FkomUr1SFxZ9FBB3xMdQuoemiNClY0uzXwYqJ9RTG41dQBRl9IEznOtvBnuweET4cwQsAKjCKpvV8LMIvtcrHxDmH5PS33KjzqGYy3TO8jM830mGKTFtlvOO9on1kVeUAGlmjbvm55TldJE+23YcDmfFit9+YqoEEWkTqUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791864883; c=relaxed/simple;
	bh=S8cxel6X6Yq6iuz94Fu5jjzj8UhGTkl9CDSP2dDr4Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jXizeaCsjrPmotNcyZdSez3XAZs+3vUqemRIeZoZHCLQ/0Owk4hRhK3Q+LQ8aALh+EmJV5U8erxSk61J67W4ZqO0VzMQxM4tN8dqEoLMtRBD8uhhrksuP4svsFx3oR9NUFJ/2h/27LVVsS6+wW02EimtHo+bK46Prge0r74BMBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y1rjZBK6; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y1rjZBK6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791864882; x=1823400882;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=S8cxel6X6Yq6iuz94Fu5jjzj8UhGTkl9CDSP2dDr4Ko=;
  b=Y1rjZBK6yZP/cP3StsXXA8UCgICvNGRxKZHeyd9+4A8fa1QKWUOnGxFX
   Qj9XdxSYc3/xqsbm50iRBG7VJsJ4vu2Xp9G3X2CfPKtrvXvJTwFsgCIe9
   16uibO5VxbFIqHHn555Q1inESFlv+SnxFerrtdPj/6ecS+qAvIAYSdENa
   kDRqUIabl1EaBUhyEa91S9PyuGZyj4yy8/Thc00NZ4U5LjX2S2fpfJvUu
   Tg2RUsWOnmEbNpxTrrdyiQ5IKdUE1cQQKU9u/qidJqvTWgqi15qExlRpy
   yO04vsSI2Uw2eEwwStQxf9I0IUyO5b+ix+5SzkDlURQLzi9H1liggDf9r
   g==;
X-CSE-ConnectionGUID: 6Di9Y3y8QoKS959n1tGF6Q==
X-CSE-MsgGUID: nRPuZBUsTHigEZi0wN74qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="468512"
X-IronPort-AV: E=Sophos;i="6.27,155,1787036400"; 
   d="scan'208";a="468512"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 21:14:42 -0700
X-CSE-ConnectionGUID: mnC+yj5uRIGslPnfLYf2xQ==
X-CSE-MsgGUID: 1gcUm0jhTj2zJgSbxHC57Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,155,1787036400"; 
   d="scan'208";a="1388983"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.102])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 21:14:41 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v3 0/3] cxl: support region granularities finer than the root
Date: Mon, 12 Oct 2026 21:14:32 -0700
Message-ID: <cover.1791863817.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

*** Use to be cxl: Support mixed-granularity region interleaves *** 

Changes in v3:
- Reframe series to match kernel series which now describes the feature as
  region granularity finer than the root, refining monotonically toward the
  endpoints. Drop the term "mixed-granularity" from the patch subjects,
  commit messages, code comment, and man page
- Rename test/cxl-region-mixed.sh to test/cxl-region-finer-gran.sh and load
  cxl_test with the renamed finer_gran_regions module param.
- cxl-create-region man page: describe the levels below the root as refining
  monotonically toward the region granularity, rather than interleaving at it
- Patch 1 is unchanged
v2: https://lore.kernel.org/nvdimm/cover.1788469004.git.alison.schofield@intel.com/

Changes in v2:
Patch 1: cxl/region: round default region size within root decoder extent
- New patch to fixup the ALIGN_DOWN usage that doesn't always work
Patch 2: cxl/region: allow mixed-granularity regions
- Reject a granularity that is not power of 2
- Update man page -g section
Patch 3: test/cxl-region-mixed.sh: test mixed-granularity region creation
- Cover the third pmem window, a 3-way at 1KB across 3 HBs
- Add two test cases, a 6-way and 12-way, for more spec defined coverage
- Select endpoints by walking hierarchy instead of handbuilding lists per case
- Assert 2 switches below each HB and 2 EP below each switch
- Require negative test cases to fail at first target write
- Skip rather than fail when kernel has no registry
- Drop selector walk language to align with kernel language
v1: https://lore.kernel.org/all/fa5c109f08824180f58341ebd9055545a2ff3142.1780099216.git.alison.schofield@intel.com/


Alison Schofield (3):
  cxl/region: round default region size within root decoder extent
  cxl/region: allow region granularity finer than the root
  test/cxl-region-finer-gran.sh: test region granularity finer than the
    root

 Documentation/cxl/cxl-create-region.txt |  21 +-
 cxl/region.c                            |  39 ++-
 test/cxl-region-finer-gran.sh           | 413 ++++++++++++++++++++++++
 test/meson.build                        |   2 +
 4 files changed, 462 insertions(+), 13 deletions(-)
 create mode 100644 test/cxl-region-finer-gran.sh

-- 
2.37.3

