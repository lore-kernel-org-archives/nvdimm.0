Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD202E416
	for <nvdimm@lists.linux.dev>; Tue, 16 Jan 2024 21:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705439846; cv=none; b=QKxXj6u3WQn3qtJJgDmzuzAPafggjba47JegOcyxWnRzgqQeETNvHtBcOG07HdmNiU/D1BkPa0VkuSfsblS3mpmuPQ3bgZkKG1xjnOvrRlSBFU6WOR0nJVL1154t/u8hE9Y/xM6G2ZklX8nYDPrj1boWo5C0Pwr9fhzGJdvRzoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705439846; c=relaxed/simple;
	bh=V5I2YuPENTomAj3Q6O2v7wNKB80h8VavChy48Mt+UOQ=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Subject:From:To:Date:
	 Message-ID:User-Agent:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=CsVjrELCyT0hBLdNwYQmy8ReAkbo8HlssFNCoKhXt5LPbwx8trDnfXy88LDWLv+LBpMtR5tK71/zQVdPfIavuqH9mV77JyK08TUJdDydCTTkc3gki2F83HR1VH4PqWKT3qmDUz9BTRimxdMH5K56TNKEdxZz36UjQjR+AHpfDzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yv9njNtH; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yv9njNtH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705439844; x=1736975844;
  h=subject:from:to:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V5I2YuPENTomAj3Q6O2v7wNKB80h8VavChy48Mt+UOQ=;
  b=Yv9njNtH+A4j5bCeZr2tAaHyZ6AzvL5IkCX4m6dIkMOuqxQujCAWc5ad
   Kk1RvOfsB6BCDhWytvNjJl+h8Jk0nVEzqhWS4D4ggnXZpRk0JoqYciAlL
   kpyKbld36RvPmBCoaaR/wNPvlHIf9v7FfYh1pBlc0hPz8nJ8u1ij38TSS
   wO5dZH2+MxaqPlq2s2Ot4yWVqVRTYimSsqne7FW17RAbfLFuvYF5i+1BU
   +F3TOctqZ3T1w72NTPicLX39HOA2jvLcSkhYm2QpCIE99Fx9KALrszGFB
   hBDWjzER5zJ7QPJAO/uBC5zAGrByiSQFHl/o2nYOYZTQejWhn2oUq3wlO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="6704692"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="6704692"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 13:17:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="957308518"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="957308518"
Received: from dbsheffi-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.54.167])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 13:17:23 -0800
Subject: [PATCH] tools/testing/nvdimm: Disable "missing prototypes /
 declarations" warnings
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Tue, 16 Jan 2024 13:17:23 -0800
Message-ID: <170543984331.460832.1780246477583036191.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Prevent warnings of the form:

tools/testing/nvdimm/config_check.c:4:6: error: no previous prototype
for ‘check’ [-Werror=missing-prototypes]

...by locally disabling some warnings.

It turns out that:

Commit 0fcb70851fbf ("Makefile.extrawarn: turn on missing-prototypes globally")

...in addition to expanding in-tree coverage, also impacts out-of-tree
module builds like those in tools/testing/nvdimm/.

Filter out the warning options on unit test code that does not effect
mainline builds.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/Kbuild |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 8153251ea389..91a3627f301a 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -82,4 +82,6 @@ libnvdimm-$(CONFIG_NVDIMM_KEYS) += $(NVDIMM_SRC)/security.o
 libnvdimm-y += libnvdimm_test.o
 libnvdimm-y += config_check.o
 
+KBUILD_CFLAGS := $(filter-out -Wmissing-prototypes -Wmissing-declarations, $(KBUILD_CFLAGS))
+
 obj-m += test/

