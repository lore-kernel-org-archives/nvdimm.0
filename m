Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E463ABD8D
	for <nvdimm@lists.linux.dev>; Fri,  4 Sep 2026 02:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788490384; cv=none; b=pYxx6C0tlC5wFBo6sWIUfYQKbQZHFNHg9DETzVFnbUnt2wvNCJpl9fR5SOWeT8gn9P1hzZDvSuMaPOtWHg2gQiMhI/DQjt4vhXOtRUiWtk7I/llf7u4+J/6tvONyrpXxyV7zgqtYVzNXlgwWgGRLLqq2pIQthZazHPJBMYTz/I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788490384; c=relaxed/simple;
	bh=0YKmmc1DE6iYSsgiwqyOIHDw+8gNMRRWBb/vqPg+aWs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YLskveNcNhf+sJ5M09rf9legUPhlLZWhmtZNQRmGpfGbjd6jABw+OJPeQYEBHpx0X9mgiunD4YVqxUltNsVXSaqXeJdMXhgXhaPEZcX53rrWdnVVYoP5YWS8v3tO9o2exbMqniEvqUNrPntSwE4+ULMm6ukBOREYHNga7h53L4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fwbAi25i; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fwbAi25i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788490382; x=1820026382;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0YKmmc1DE6iYSsgiwqyOIHDw+8gNMRRWBb/vqPg+aWs=;
  b=fwbAi25iHMeE5p4TOcYq9bPHUFENY1Cg0R0ScuyHe/vOAqRzazEIeyif
   Zy6OmJzYybAyVzXxm8KpFpY0UFQrmN2FfDHqdG1ibSKpsoke9Tk36MKIL
   gffN6k/6RF5/bJNPu9bwJttVhzOa0DHiMdV09TvZVBm2GG1BJ3QKPOerZ
   RRsQzq/vBE99GiUzGvcji5o7p4Vyfj3GZCN7RLwx8KrXeRFRiS4gVl8tL
   F5l9dYV/WHIToqbpEV8jBLt35KF01fEiyDMbvGwDWo08rejHy1wBx31VY
   WEXndM5AruHG7Nprm22MkhFMF7+nGtjNnvyXoonUT+vdgRQtxBQrKgo5Y
   w==;
X-CSE-ConnectionGUID: dG87OUI/TeWTeurFlWhymA==
X-CSE-MsgGUID: +aUys2ZKQPyDkr8g7k1a7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88915023"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88915023"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 19:53:01 -0700
X-CSE-ConnectionGUID: xUQaI1HhTCOCHme3uIxdxg==
X-CSE-MsgGUID: A6sRHbwUTsO7iodZbl8zOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="271865662"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.10])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 19:53:00 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v2 0/3] Add CXL region passthrough >16K gran test
Date: Thu,  3 Sep 2026 19:52:54 -0700
Message-ID: <cover.1788489571.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change in v2:
- Skip immediately if test decoder not present


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

 test/cxl-create-region.sh | 163 ++++++++++++++++++++++++++++++++++----
 test/cxl-xor-region.sh    | 129 ------------------------------
 test/meson.build          |   2 -
 3 files changed, 149 insertions(+), 145 deletions(-)
 delete mode 100644 test/cxl-xor-region.sh

-- 
2.37.3

