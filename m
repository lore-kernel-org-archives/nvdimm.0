Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5B55233
	for <nvdimm@lists.linux.dev>; Fri,  1 Dec 2023 04:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IzBOa4wg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701403575; x=1732939575;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=F8XZJNPPStE/v4ENn+4au7zLUmzAJAJ2GivmFhguYIY=;
  b=IzBOa4wgMU5djTSIPIN4Um0b20tT+7vu/xasNta6N31cRQ0ne3QS654X
   425QviAek/l+62gtwQ+GiZk2dGHnFFrcbN1DHccVCGyEq+Pzb/f7E5JTI
   2JlzOdlDDh+wXzCgsXjKS2aubNufNMeH+BqAFW5QfEQSlh6CIAj012WEi
   afQUHNc5CovmDa7UOFzNJtMpVvbg7HV8bcVvdY5ZT+E5mJocJlVBZUDjE
   WGPYsXqZ6XSk1RQSfDdHPdO65j4j864EHzpWxa+SwW0H1Pkk1OQBjSNY6
   eHweMgOg/PUh58ZMNRqSkTXJXWghtiaDZYwkjHJqzs+ywYOrTyL3a0GPC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="433264"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="433264"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 20:06:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="769540353"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="769540353"
Received: from iweiny-desk3.amr.corp.intel.com (HELO localhost) ([10.212.102.178])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 20:06:13 -0800
From: Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH ndctl RESEND 0/2] ndctl: Fix ups for region destroy
Date: Thu, 30 Nov 2023 20:06:12 -0800
Message-Id: <20231130-fix-region-destroy-v1-0-7f916d2bd379@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALRbaWUC/32OvQ6CMBSFX4Xc2WsoBUEnB1kddDQMhV6gibbml
 hAJ4d0trCaO5+fLOTN4YkMeTtEMTKPxxtkgxC6Cple2IzQ6aEjiRAohY2zNB5m6UENNfmA3oSo
 ypUWrqchrCGCtPGHNyjb9iv4Sa+nNFIJt+QG38l5eL1AFvzd+cDxth0axpf+2R4ExpvKYFSQpV
 +nhbOxAz33jXlAty/IF3H1WHuEAAAA=
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.13-dev-0f7f0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1701403573; l=881;
 i=ira.weiny@intel.com; s=20221222; h=from:subject:message-id;
 bh=F8XZJNPPStE/v4ENn+4au7zLUmzAJAJ2GivmFhguYIY=;
 b=uZy0R1Wd1mYqRifN3cHmWSBJwESfjylZb1+TMrQuL+ouYC0XJcc0NPZpuMm/G/b5RfG7GQMXX
 3/mOLDi4p9tAZfZBEIvQXZNAdFdAsz9SMmXiGYMzH3T7Dmv2oGEf0oz
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=brwqReAJklzu/xZ9FpSsMPSQ/qkSalbg6scP3w809Ec=

The patch to force device tear down on region disable caused a
regression for regions without system ram.

Add a test for such a case and a fix to the patch.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
[djiang: RESEND with proper mailing lists.]

---
Ira Weiny (2):
      ndctl/test: Add destroy region test
      cxl/region: Fix memory device teardown in disable-region

 cxl/region.c               |  3 ++
 daxctl/lib/libdaxctl.c     |  4 +--
 daxctl/lib/libdaxctl.sym   |  5 +++
 daxctl/libdaxctl.h         |  1 +
 test/cxl-destroy-region.sh | 76 ++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build           |  2 ++
 6 files changed, 89 insertions(+), 2 deletions(-)
---
base-commit: cbf049039482a56c2b66ede3e10d5e9c652890b7
change-id: 20231130-fix-region-destroy-a85ad1fde87b

Best regards,
-- 
Ira Weiny <ira.weiny@intel.com>

