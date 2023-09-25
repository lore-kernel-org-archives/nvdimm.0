Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3A71B26E
	for <nvdimm@lists.linux.dev>; Mon, 25 Sep 2023 14:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695653355; x=1727189355;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gebFhBd7+C1Oa0Fn1vhA4oEjdQYj+1hrnPocAsiX/Ro=;
  b=aw+GjLvUOFkhf22syHJygP8QZ1aJnXWELxI/Y74xYaz26WfmzQ7K+CS4
   NYGI3DQ+b89MN47RylDzSE4yBJl+p1IlgSe6My/uoTu9peQnR9OSxrZNx
   3YbnJLPOCMlVEDq++U7N5jH5eXAeHpSztn7hIjoK0eRPGIY9qnNJH/kRp
   Kdl3Xovd4MF1NkE0WlQA5I44ASSrOxBKTz/5eoNcfQmcAlOceH73+DIed
   OBzywEdZhlczDVcdF6xFSeiZkEKWcOQ4BxEd3sV95kF/KYELoXgwK2vxt
   zUGerr2Wu6Vo7zdhxJY82CQJSEtRw0VWqoeRc7/FpIGOqBRmbwpwABC3u
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="378547968"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="378547968"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 07:49:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="995409401"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="995409401"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 07:49:10 -0700
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: rafael.j.wysocki@intel.com,
	andriy.shevchenko@intel.com,
	lenb@kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	rui.zhang@intel.com,
	Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH v1 0/9] Replace acpi_driver with platform_driver
Date: Mon, 25 Sep 2023 17:48:33 +0300
Message-ID: <20230925144842.586829-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently there is a number of drivers that somewhat incorrectly
register themselves as acpi_driver, while they should be registering as
platform_drivers. acpi_device was never meant to represent actual
device, it only represents an entry in the ACPI table and ACPI driver
should be treated as a driver for the ACPI entry of the particular
device, not the device itself. Drivers of the devices itself should
register as platform_drivers. Replace acpi_driver with platform_driver
for all relevant drivers in drivers/acpi directory. This is just the
first part of the change, as many acpi_drivers are present in many files
outside of drivers/acpi directory.

Additionally during internal review we've decided that it's best to send
the relevant patches sequentially, in order not to overwhelm the reviewers.
So I'm starting with NFIT and AC drivers.

This change is possible thanks to recent .notify callback removal in
drivers/acpi [1]. So flow for the remaining acpi_drivers will look like
this:

1) Remove .notify callback with separate patchset for drivers/platform
   and other outstanding places like drivers/hwmon, drivers/iio etc.
2) Replace acpi_driver with platform_driver, as aside for .notify
   callback they're mostly functionally compatible.

Most of the patches in this series could be considered independent, and
could be merged separately, with a notable exception of the very first
patch in this series that changes notify installer wrappers to be more
generic. I decided it would be best not to force the user of this
wrappers to pass any specific structure, like acpi_device or
platform_device. It makes sense as it is very often the case that
drivers declare their own private structure which gets allocated during
the .probe() callback, and become the heart of the driver. In that case
it makes much more sense to pass this structure to notify handler.
Additionally some drivers, like acpi_video that already have custom
notify handlers do that already.

Link: https://lore.kernel.org/linux-acpi/20230703080252.2899090-1-michal.wilczynski@intel.com/ [1]

Michal Wilczynski (9):
  ACPI: bus: Make notify wrappers more generic
  docs: firmware-guide: ACPI: Clarify ACPI bus concepts
  ACPI: AC: Remove unnecessary checks
  ACPI: AC: Use string_choices API instead of ternary operator
  ACPI: AC: Replace acpi_driver with platform_driver
  ACPI: AC: Rename ACPI device from device to adev
  ACPI: NFIT: Replace acpi_driver with platform_driver
  ACPI: NFIT: Remove redundant call to to_acpi_dev()
  ACPI: NFIT: Don't use KBUILD_MODNAME for driver name

 .../firmware-guide/acpi/enumeration.rst       |  13 +++
 drivers/acpi/ac.c                             | 108 ++++++++----------
 drivers/acpi/acpi_video.c                     |   6 +-
 drivers/acpi/battery.c                        |   6 +-
 drivers/acpi/bus.c                            |  14 +--
 drivers/acpi/hed.c                            |   6 +-
 drivers/acpi/nfit/core.c                      |  42 +++----
 drivers/acpi/thermal.c                        |   6 +-
 include/acpi/acpi_bus.h                       |   9 +-
 9 files changed, 103 insertions(+), 107 deletions(-)

-- 
2.41.0

