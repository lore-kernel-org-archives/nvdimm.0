Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FFE208A9
	for <nvdimm@lists.linux.dev>; Sat, 22 Mar 2025 01:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742606993; cv=none; b=uqiH/CkLgIwBrGDvOMTwP+AlUcpfvnx4PdNoMcQsbAhrps9v/ZawAw47feaftxgU+YDXWKQI+ilpDA1Y7tDtOw34v5kKhW2yYR7q25sWpsKfnJd3MuP8+TzDf/dJQKh2z+E8rV/l1VyK+w95Y97xrsRcghvlNA9ZeWpQN3s9cE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742606993; c=relaxed/simple;
	bh=HVkLtybCp22DSP+LlJqjzHsADUQ4oXkuntZ2fNbdJLI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WGmdHMVzhTB53oskfDhVGX/qwga6C6QGKuTn6VorsxLqwJEc68TIEScO15pVCDx/RsPOol20l3T6ThPgxDQrAAOiyw6VXB3clViZraYB25I39b6LMN0PYVnJ+UzNbsr5rTSiTckMggBp9kRF9Zug306/5+BapO1Zxr2ct4hjjy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JLodpa2X; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JLodpa2X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742606991; x=1774142991;
  h=date:from:to:subject:message-id:mime-version;
  bh=HVkLtybCp22DSP+LlJqjzHsADUQ4oXkuntZ2fNbdJLI=;
  b=JLodpa2XWsuSSQkonMfYVpcQX9YD3B+XnBErvCjF9HQF9pO6pFIDdcus
   dtysWuDZcuU7xT/bdGJbjBrXg1cgXZysl181QYGOSN0yyyEZ4yxhhcKuD
   OpWWM/OOqZfrgBYY5HJ06kErngpfBR47eizQ/tza7Dj1G5Psgf1/UMAS3
   ORq0Cgx2j+0MSxrbwAYDAelISVZDPda/DRhz/RjQKSU8IDsQIcR0KSnUg
   Mi0Q5zLeLdQz0i2Oxg7GwxtGYM5iOEt9IUuorv2VDaVpB+wbtW/AdQr+r
   LlnNvijsVVUn2YOGsfzXcXGeaYEKYgFjQWid/rleH4+u3xt568mS9AAV8
   g==;
X-CSE-ConnectionGUID: 6WgnpHabSU2TMUf3ZnNWyQ==
X-CSE-MsgGUID: KFyC4vDWSlKDMS9lD7cA5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="61280785"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="61280785"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 18:29:50 -0700
X-CSE-ConnectionGUID: r4uI1zWPSA+uCUxyLr5lzw==
X-CSE-MsgGUID: 1IkBISTWRx64Fe0/zT7dFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="154556487"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.110.203])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 18:29:49 -0700
Date: Fri, 21 Mar 2025 18:29:48 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: [ANNOUNCE] ndctl v81
Message-ID: <Z94SjF0ngf4Nlhhq@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

A new ndctl release is available[1].

Highlights are usability improvements in daxctl and region creation
and listing. Namespace creation gets more robust parameter handling
and unit tests are improved.

A shortlog is appended below.

[1]: https://github.com/pmem/ndctl/releases/tag/v81


Alison Schofield (7):
      cxl/lib: remove unimplemented symbol cxl_mapping_get_region
      util/strbuf: remove unused cli infrastructure imports
      ndctl/namespace: avoid integer overflow in namespace validation
      ndctl/namespace: close file descriptor in do_xaction_namespace()
      ndctl/dimm: do not increment a ULLONG_MAX slot value
      ndctl/namespace: protect against overflow handling param.offset
      ndctl/namespace: protect against under|over-flow w bad param.align

Donet Tom (1):
      ndctl/list: display region caps for any of BTT, PFN, DAX

Ira Weiny (2):
      cxl/region: report max size for region creation
      test/cxl-events.sh: do not fail test until event counts are reported

Li Ming (1):
      daxctl: output more information if memblock is unremovable

Li Zhijian (3):
      test/monitor.sh: convert float to integer before increment
      test/monitor.sh: make shell variable handling more robust
      test/security.sh: add jq requirement check

Michal Suchanek (1):
      cxl/json: remove prefix from tracefs.h #include

