Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB4713AC9
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 16:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686934254; x=1718470254;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JV3Ih4xi78ad21rCtTYTfrA/GPg5mfGBUmug2pPsszI=;
  b=DAVz64YLape/nV15P9iBdyuQ6SZBR4ji+6V+MacfKMqSg/E5Dx8AP8JT
   /uXE2SOxO/yQswkUpi5trsPNmozoTM6jjJqgeynw8BpNq2BCIKGRck7Wm
   +a/Q7bwNixhe+DyHqot7TgDD7iY3VqhUIVHPkSSGpIhh5d3Jkm3MEoiK5
   AyxAIrA3+L6G6Kwx0CWIuxizZXesmRnbv9u9mxmkHdASKefNrJwmWYevU
   Y//pUWB8Yx+lbw/iNxgb3nuPqU6Xa+XgDuC0D8BSibNLpdobDOCOox39M
   uc0Ru5DyN+1zSgdhWI+X3bt93deB93dFS6FoF3LPlAn9QjqF5Jr0Md87q
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="422912931"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="422912931"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:50:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="707154075"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="707154075"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:50:49 -0700
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: linux-acpi@vger.kernel.org
Cc: rafael@kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	lenb@kernel.org,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	rui.zhang@intel.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH v5 00/10] Remove .notify callback in acpi_device_ops
Date: Fri, 16 Jun 2023 19:50:24 +0300
Message-ID: <20230616165034.3630141-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

*** IMPORTANT ***
This is part 1 - only drivers in acpi directory to ease up review
process. Rest of the drivers will be handled in separate patchsets.

Currently drivers support ACPI event handlers by defining .notify
callback in acpi_device_ops. This solution is suboptimal as event
handler installer installs intermediary function acpi_notify_device as a
handler in every driver. Also this approach requires extra variable
'flags' for specifying event types that the driver want to subscribe to.
Additionally this is a pre-work required to align acpi_driver with
platform_driver and eventually replace acpi_driver with platform_driver.

Remove .notify callback from the acpi_device_ops. Replace it with each
driver installing and removing it's event handlers.

v5:
 - rebased on top of Rafael changes [1], they're not merged yet
 - fixed rollback in multiple drivers so they don't leak resources on
   failure
 - made this part 1, meaning only drivers in acpi directory, rest of
   the drivers will be handled in separate patchsets to ease up review

v4:
 - added one commit for previously missed driver sony-laptop,
   refactored return statements, added NULL check for event installer
v3:
 - lkp still reported some failures for eeepc, fujitsu and
   toshiba_bluetooth, fix those
v2:
 - fix compilation errors for drivers

[1]: https://lore.kernel.org/linux-acpi/1847933.atdPhlSkOF@kreacher/

Michal Wilczynski (10):
  acpi/bus: Introduce wrappers for ACPICA event handler install/remove
  acpi/bus: Set driver_data to NULL every time .add() fails
  acpi/ac: Move handler installing logic to driver
  acpi/video: Move handler installing logic to driver
  acpi/battery: Move handler installing logic to driver
  acpi/hed: Move handler installing logic to driver
  acpi/nfit: Move acpi_nfit_notify() before acpi_nfit_add()
  acpi/nfit: Improve terminator line in acpi_nfit_ids
  acpi/nfit: Move handler installing logic to driver
  acpi/thermal: Move handler installing logic to driver

 drivers/acpi/ac.c         | 33 ++++++++++++++++++++++++---------
 drivers/acpi/acpi_video.c | 26 ++++++++++++++++++++++----
 drivers/acpi/battery.c    | 30 ++++++++++++++++++++++++------
 drivers/acpi/bus.c        | 30 +++++++++++++++++++++++++++++-
 drivers/acpi/hed.c        | 17 ++++++++++++++---
 drivers/acpi/nfit/core.c  | 32 ++++++++++++++++++++++----------
 drivers/acpi/thermal.c    | 28 ++++++++++++++++++++++------
 include/acpi/acpi_bus.h   |  6 ++++++
 8 files changed, 163 insertions(+), 39 deletions(-)

-- 
2.41.0

