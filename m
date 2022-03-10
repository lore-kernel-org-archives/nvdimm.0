Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A807A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 03:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646884188; x=1678420188;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zuLq0j0QluqQstMS5jLUVRl9HizLQhz8nCQqtScJQrc=;
  b=Zvr7CEmUjKGmbL6Nv32uVH8Ju6coVYrrMQFyMgJ7wjttwy6odXfdCX9j
   Eqmwh8ccaK8YlDDlZERTd0ITF5gdvx7v+tilw39RzYhlDskpJDJv5jTz+
   V2ZIsfZs8uXttBWc+c91rQg5/mxjE1irMHRhi4H5Eio1RvsyzTS6zFCS2
   z+w/nGPJ/OiDudeRGX73Ei95O2YR7yh94xKBzcK82BHN1+hTd+Ph1xJaB
   FBDzSAwpSWonBbTWrMrr1bgilY86TIuAyvvTY77/zJT7imQTAbPEf9MNw
   HF3OzNjtu95cQWebnZ3scfZ+Cb0S1h2okk6TrW0FYYClBKJkkg5nlBsqU
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="235760026"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="235760026"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 19:49:27 -0800
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="538287010"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 19:49:16 -0800
Subject: [PATCH 0/6] libnvdimm: Jettison block-aperture-window support
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: robert.hu@linux.intel.com, vishal.l.verma@intel.com, hch@lst.de,
 linux-acpi@vger.kernel.org
Date: Wed, 09 Mar 2022 19:49:16 -0800
Message-ID: <164688415599.2879318.17035042246954533659.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The block-aperture-window mechanism was originally conceived as a
mechanism for NVDIMM devices to offer a block-device-like error model
whereby poison consumption within a given transaction window could elide
a machine check and instead set a bit in a status register. This
mechanism was abandoned in favor of just teaching software to handle the
machine-check exception (see copy_mc_to_kernel()).

Given there are no known shipping platforms with this capability.
Jettison this code to make room for incoming integrations of CXL
Persistent Regions with LIBNVDIMM Regions.

---

Dan Williams (6):
      nvdimm/region: Fix default alignment for small regions
      nvdimm/blk: Delete the block-aperture window driver
      nvdimm/namespace: Delete blk namespace consideration in shared paths
      nvdimm/namespace: Delete nd_namespace_blk
      ACPI: NFIT: Remove block aperture support
      nvdimm/region: Delete nd_blk_region infrastructure


 Documentation/driver-api/nvdimm/nvdimm.rst |  406 +++++-----------------
 drivers/acpi/nfit/core.c                   |  387 ---------------------
 drivers/acpi/nfit/nfit.h                   |    6 
 drivers/nvdimm/Kconfig                     |   25 -
 drivers/nvdimm/Makefile                    |    3 
 drivers/nvdimm/blk.c                       |  335 -------------------
 drivers/nvdimm/bus.c                       |    2 
 drivers/nvdimm/dimm_devs.c                 |  204 +----------
 drivers/nvdimm/label.c                     |  346 -------------------
 drivers/nvdimm/label.h                     |    5 
 drivers/nvdimm/namespace_devs.c            |  506 ++--------------------------
 drivers/nvdimm/nd-core.h                   |   27 -
 drivers/nvdimm/nd.h                        |   13 -
 drivers/nvdimm/region.c                    |   31 +-
 drivers/nvdimm/region_devs.c               |  157 +--------
 include/linux/libnvdimm.h                  |   24 -
 include/linux/nd.h                         |   26 -
 include/uapi/linux/ndctl.h                 |    2 
 tools/testing/nvdimm/Kbuild                |    4 
 tools/testing/nvdimm/config_check.c        |    1 
 tools/testing/nvdimm/test/ndtest.c         |   67 ----
 tools/testing/nvdimm/test/nfit.c           |   23 -
 22 files changed, 181 insertions(+), 2419 deletions(-)
 delete mode 100644 drivers/nvdimm/blk.c
