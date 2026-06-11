Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4019F40D593
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 00:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781137171; cv=none; b=snaBsDTzU2/+Z/td5URIAGerzAqja5Hmk97NR/w+/BCwqCBmZyTB6ekwj0xII7+Pd14kA9fvI6pKpNXAF/y/yWTeQX9SR8V469XKH4a+8Hft8vRiJQf3gf52BUnbJEpZVc7VkQij4Zgpa9aJBBxvIiZrcg0L9aJWv8ZPKllR2Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781137171; c=relaxed/simple;
	bh=OM2H03xapnWmxaxOKJYPF5B9mXJMBVNrTLr405dsEt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ubw5ESAhNe4wE8LQoGSJhPtef60O0rlfIxmcKwd6zWAbr0r1vcFZZNSXmFFZWHzWobEEPUnMFeGAyFZfvzgGsECjiiYTbyHXzQFktcAk2SLd3M1afUG8ey6nX4UK52hxr2usRAavOnOt/Mq8NppelEyB3ITYX8nCawMX34s71xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TsO6SIR7; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TsO6SIR7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781137168; x=1812673168;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OM2H03xapnWmxaxOKJYPF5B9mXJMBVNrTLr405dsEt0=;
  b=TsO6SIR743CIAX/YGqfox9aBnDLAOMQOjgYc0O1J0mRs8v2lATFofr75
   hjgCAzDy7bEVHpVk3zeg7drd/VLu/lZXmiImT43RmUOiqA8LKrCMiQe74
   fEqyeAWx3ZMp/qIhTpAhhoIr4vrv78w4jR4kFjjDrTDmKo86Ioq/5ik98
   YXcDuhq0wVN/EIUcrbmcHh2d9OaUpqdKQFIQt5wbUSR8IFDZiHvkKscbO
   U7HjwurgzOCKQ0z8HDEhmqyMNWAAmnTfdxAX56cHgi/L2aEeNweOjA3Iw
   pFh2pSUVIddc83s5/lY4g4masyQpANLJUCogpVG6u28JjSCDsUq5eAQze
   g==;
X-CSE-ConnectionGUID: qHq5Qe6wTcuJuxL4ciZoMg==
X-CSE-MsgGUID: IovQqlXiR7ueUafsqPeKjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="82054166"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="82054166"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 17:19:27 -0700
X-CSE-ConnectionGUID: P3QlFD5OQ4G+m8kSSAYrAg==
X-CSE-MsgGUID: sS+/fd9fRdqgHKMmdAlzZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="242181812"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.46])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 17:19:27 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 0/3] Add CXL region passthrough >16K gran test
Date: Wed, 10 Jun 2026 17:19:18 -0700
Message-ID: <cover.1781136221.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A companion kernel series,
    "cxl: Allow passthrough decoders with >16K granularity",
fixes region setup for valid topologies containing passthrough
decoders beneath a wide parent interleave and extends cxl-test with a
topology that exercises the issue.

This series consolidates and simplifies the existing region creation
tests, and then adds coverage for the new topology.

Based on: https://github.com/pmem/ndctl/tree/pending

Alison Schofield (3):
  test/cxl-create-region.sh: fold in XOR region coverage
  test/cxl-create-region.sh: deduplicate decoder and memdev lookups
  test/cxl-create-region.sh: add passthrough >16K granularity test case

 test/cxl-create-region.sh | 158 ++++++++++++++++++++++++++++++++++----
 test/cxl-xor-region.sh    | 129 -------------------------------
 test/meson.build          |   2 -
 3 files changed, 144 insertions(+), 145 deletions(-)
 delete mode 100644 test/cxl-xor-region.sh


base-commit: 5fcbbee57319e718bf522436ea6595bd0f71296c
-- 
2.37.3

