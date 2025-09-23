Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E24258CDA
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 17:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649220; cv=none; b=pAWjx1tfNLtIh8sr3EV3iPphb1tfcdmvqfrCA+DCeU7CaOJoIPSTAhHMXNyir7rMP00gkVFrX0H6jhXb8OIDjKPme5JlNsA1P4HOFZfUU6Qdxooj/pEcuQjyzqF8Uwk0Yw1g0ey1cVwzt32xwQNPAogu3EcNPvNfAL0CTQSU+44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649220; c=relaxed/simple;
	bh=X40KqSm4JoBkLYFbUXezNh0z0LQEhJsb7eAveqGX3SI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pJvtCZWaB+wlCzKR/+0iQiu68fterjNMC66A7sHanN8BfatvoXj2kFxB2C0eYQlFNQf2JIEXhPtWB/ICWTHwRrmc4v9LGStFFSC5p/p2kGqNWt4+qYGlCfA/c7ZNM0fPGzCN1gNmCUSvKIfe9LeVqEQI5UyoZyfkLSguWe2fkdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34B0C4CEF5;
	Tue, 23 Sep 2025 17:40:19 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: nvdimm@lists.linux.dev
Cc: ira.weiny@intel.com,
	vishal.l.verma@intel.com,
	dan.j.williams@intel.com,
	jonathan.cameron@huawei.com,
	s.neeraj@samsung.com
Subject: [PATCH v2 0/2] nvdimm: Introduce guard() for nvdimm_bus_lock and clean up usages
Date: Tue, 23 Sep 2025 10:40:11 -0700
Message-ID: <20250923174013.3319780-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The series introduces a guard() function to manage the nvdimm_bus_lock,
and convert code using nvdimm_bus_lock()/unlock() to use guard() instead.

v2
- Move __nd_ioctl() cleanup to a separate patch and remove all gotos. (Dan)
- Fix various changes from Jonathan's feedback

# <REPLACE>cover letter body:
# NOTE: nvdimm-guard/0000-cover-letter.patch will add diffstat and base-commit to this template

# Dave Jiang (2):
#       nvdimm: Introduce guard() for nvdimm_bus_lock
#       nvdimm: Clean up __nd_ioctl() and remove gotos
#
#  drivers/nvdimm/badrange.c       |   3 +-
#  drivers/nvdimm/btt_devs.c       |  24 +++-----
#  drivers/nvdimm/bus.c            |  71 ++++++++----------------
#  drivers/nvdimm/claim.c          |   7 +--
#  drivers/nvdimm/core.c           |  17 +++---
#  drivers/nvdimm/dax_devs.c       |  12 ++--
#  drivers/nvdimm/dimm.c           |   5 +-
#  drivers/nvdimm/dimm_devs.c      |  48 ++++++----------
#  drivers/nvdimm/namespace_devs.c | 117 +++++++++++++++++++--------------------
#  drivers/nvdimm/nd.h             |   3 +
#  drivers/nvdimm/pfn_devs.c       |  61 +++++++++------------
#  drivers/nvdimm/region.c         |  14 ++---
#  drivers/nvdimm/region_devs.c    | 118 +++++++++++++++++-----------------------
#  drivers/nvdimm/security.c       |  10 +---
#  14 files changed, 216 insertions(+), 294 deletions(-)
# </REPLACE>


Dave Jiang (2):
  nvdimm: Introduce guard() for nvdimm_bus_lock
  nvdimm: Clean up __nd_ioctl() and remove gotos

 drivers/nvdimm/badrange.c       |   3 +-
 drivers/nvdimm/btt_devs.c       |  24 +++----
 drivers/nvdimm/bus.c            |  71 +++++++------------
 drivers/nvdimm/claim.c          |   7 +-
 drivers/nvdimm/core.c           |  17 +++--
 drivers/nvdimm/dax_devs.c       |  12 ++--
 drivers/nvdimm/dimm.c           |   5 +-
 drivers/nvdimm/dimm_devs.c      |  48 +++++--------
 drivers/nvdimm/namespace_devs.c | 117 +++++++++++++++----------------
 drivers/nvdimm/nd.h             |   3 +
 drivers/nvdimm/pfn_devs.c       |  61 +++++++----------
 drivers/nvdimm/region.c         |  14 ++--
 drivers/nvdimm/region_devs.c    | 118 ++++++++++++++------------------
 drivers/nvdimm/security.c       |  10 +--
 14 files changed, 216 insertions(+), 294 deletions(-)


base-commit: 07e27ad16399afcd693be20211b0dfae63e0615f
-- 
2.51.0

