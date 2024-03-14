Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C653274E21
	for <nvdimm@lists.linux.dev>; Thu, 14 Mar 2024 20:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710449085; cv=none; b=UeYlHX00ih3xHzcOZU9WfMcTlF1cuMVwSl8uLOP2xtqEqZhdETd5MIpfRgdkHCcZ2OLhALF8Lmb2rpW4nYIKHPDxPg71IUrCWDlYl9d0om9vekkH9yM3spJ6vLzfFGb47u4/VP8kV6gy/NTT2tGET97vjXJWj0+g7zGwHAeK+o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710449085; c=relaxed/simple;
	bh=i2rDrm0Zgz1naDuEpMCfUyWS1aCirICQkO3HjTprWPM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=q98NbnGpjPgc8LBfOkEehz9mC/CssDRRfQVNbBTMA9XduTzqOsQqVnj88fq/E0kvLN96IeDu0fPE3tKbUUea/lSFyCXSeimvF11HFO2tFocKDSsoYjekAWz4yvl2rLVc9xbSQu/2y5cM6pTlDzUCZTheF59HCpEbYi6i3MINpwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TUBGYY02; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TUBGYY02"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710449082; x=1741985082;
  h=message-id:date:mime-version:from:subject:to:cc:
   content-transfer-encoding;
  bh=i2rDrm0Zgz1naDuEpMCfUyWS1aCirICQkO3HjTprWPM=;
  b=TUBGYY02XXD5M9R/Lk1hOROP6GQBoD+Ed77pr8D+ICXOQHGuysybE3jT
   W9xVhJ9dU9Cq66JxcCz1bhVyiwevaOlB778MTvHcYdtK4/ZxfiPGzAzuH
   12oIzLgoNMDGkuIJWJ4jVLKoihZdyOxjxNpY1LiMvY+C8oc54BEihTENP
   Hys/8cDZR4iNIozOq6sflPl8BHTD4SeKK4b7G4x1mptoIAMLhUQc6LNf0
   ZPhWso8KFOYBwNP8QaaMIn58QtC8AJY6gKXeC4kQHVTAiYF6JF2qWEA0X
   G2GB3CGHOR6TeCjMXKPdZZoO2W92WU8jKOthQkfvVP8ob4/msktmZRf8J
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5422977"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="5422977"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 13:44:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="16895578"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.168.70]) ([10.213.168.70])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 13:44:40 -0700
Message-ID: <6ea8ea30-9a6b-4ed1-bccc-96b0171a3dd2@intel.com>
Date: Thu, 14 Mar 2024 13:44:39 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
Subject: [GIT PULL] NVDIMM//DAX changes for 6.9
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.9

... to get updates to the nvdimm tree. They are a number of updates to interfaces used by nvdimm/dax and a documentation fix.

Doc fixes:
	ACPI_NFIT Kconfig documetation fix

Updates:
	Make nvdimm_bus_type and dax_bus_type const
	Remove SLAB_MEM_SPREAD flag usage in DAX

They have all been in the -next for more than a week with no reported issues.

---

The following changes since commit 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478:

  Linux 6.8-rc3 (2024-02-04 12:20:36 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.9

for you to fetch changes up to d9212b35da52109361247b66010802d43c6b1f0d:

  dax: remove SLAB_MEM_SPREAD flag usage (2024-03-04 09:10:37 -0700)

----------------------------------------------------------------
libnvdimm updates for v6.9

- ACPI_NFIT Kconfig documetation fix
- Make nvdimm_bus_type const
- Make dax_bus_type const
- remove SLAB_MEM_SPREAD flag usage in DAX

----------------------------------------------------------------
Chengming Zhou (1):
      dax: remove SLAB_MEM_SPREAD flag usage

Peter Robinson (1):
      libnvdimm: Fix ACPI_NFIT in BLK_DEV_PMEM help

Ricardo B. Marliere (2):
      nvdimm: make nvdimm_bus_type const
      device-dax: make dax_bus_type const

 drivers/dax/bus.c      | 2 +-
 drivers/dax/super.c    | 2 +-
 drivers/nvdimm/Kconfig | 2 +-
 drivers/nvdimm/bus.c   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)
