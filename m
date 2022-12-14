Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD61DAD5C
	for <nvdimm@lists.linux.dev>; Wed, 14 Dec 2022 22:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671055222; x=1702591222;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b9nInYNWF4V2VIcLTOuK4u3ys24BJarN841RdTs0F60=;
  b=ivP85nO2q7793p5YDxPm5d3JzDm+QIRg+34ItH2RQvzwAaptyAjJ1Vux
   flpx5Or3OJZCJxSGHA5o0drSfCt8T5aIw46SSnEmSF8NU2jbET5Nvg4bI
   JostG8nTvejEGS171dOmFDpwn0foks92cGVqgwqJgFjRCCy05xJ8/2JFh
   dWAuJP1ND5NPSgRx6W/GANC37HJ+TQIq5jsb2zjQD0MOuDCVW6+JhFdm8
   Rb+PPSsp67vqeJpT4IIy2fNTFqVvYFSm0n6IAYiBEvT//NaMmqoWhSDlM
   FZA7Oy9Y+koSTUIoz4BjoI4jfcrHO9O6rlf7cE3dsEDLvTZC4TvGU75wR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="316159192"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="316159192"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 14:00:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="679907578"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="679907578"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 14:00:18 -0800
Subject: [ndctl PATCH v2 0/4] ndctl: Add security test for cxl devices through
 nvdimm
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Date: Wed, 14 Dec 2022 15:00:18 -0700
Message-ID: 
 <167105505204.3034751.8113387624258581781.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

This ndctl series add support to test cxl pmem devices through the nvdimm
interface. A new shell script is added for security test due to the
discovery of cxl_test dimms are different than nfit_test based dimms.
Common code are shared between nfit and cxl security testing.

v2:
- Fix commit logs (Vishal)
- Share common code for test (Vishal)
- Add test to cxl suite (Dan)

---

Dave Jiang (4):
      ndctl: add CXL bus detection
      ndctl/libndctl: Add bus_prefix for CXL
      ndctl/libndctl: Allow retrievng of unique_id for CXL mem dev
      ndctl/test: Add CXL test for security


 ndctl/lib/libndctl.c   | 87 ++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |  1 +
 ndctl/lib/private.h    |  1 +
 ndctl/libndctl.h       |  1 +
 test/common            |  7 ++++
 test/cxl-security      | 40 +++++++++++++++++++
 test/cxl-security.sh   |  5 +++
 test/meson.build       |  6 ++-
 test/nfit-security     | 40 +++++++++++++++++++
 test/nfit-security.sh  |  5 +++
 test/security.sh       | 70 ++++++++++++---------------------
 11 files changed, 216 insertions(+), 47 deletions(-)
 create mode 100644 test/cxl-security
 create mode 100755 test/cxl-security.sh
 create mode 100644 test/nfit-security
 create mode 100755 test/nfit-security.sh

--

