Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF757C
	for <nvdimm@lists.linux.dev>; Sat, 23 Apr 2022 21:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650748939; x=1682284939;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tWkequjSYEh30bCG4fPlkdokflxW/XwwcXiDxXk3wWw=;
  b=ZLkL8bd7zu/z9JmRsQMuuejFr7DMXDUAZBV3v+PSQVY8Z8Ws81rtEqKw
   /B+ebigwfeppDi6Y4Ijw+sI1bgdoyQDrmnQV+tbR3sq7V/mVkzrqGHIDZ
   nOFyVrtpJAFW8jjjnxHHztcjmXyzG6AB/TTlG/9H2RyQUmI1/Lvyd5vCQ
   6pEPc9athS88K3rjuUMY6hdZy8TQlA8pS3S38dA/6UZhIeKXQpyfb3GJG
   EVRyjaDb41oGbALWUJLhU3vXMcGwAN96OX3GJAaUowW55p99y5NIOa9up
   S26U7qVS223yBWUN0s5HQg5Z+eO1cdON6X1GFRu9isVxCdiS1u6PWVfMH
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="325417699"
X-IronPort-AV: E=Sophos;i="5.90,285,1643702400"; 
   d="scan'208";a="325417699"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 14:22:18 -0700
X-IronPort-AV: E=Sophos;i="5.90,285,1643702400"; 
   d="scan'208";a="557009140"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 14:22:18 -0700
Subject: [PATCH v4 8/8] nvdimm: Fix firmware activation deadlock scenarios
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev
Date: Sat, 23 Apr 2022 14:22:18 -0700
Message-ID: <165074883800.4116052.10737040861825806582.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165055523099.3745911.9091010720291846249.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <165055523099.3745911.9091010720291846249.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Lockdep reports the following deadlock scenarios for CXL root device
power-management, device_prepare(), operations, and device_shutdown()
operations for 'nd_region' devices:

---
 Chain exists of:
   &nvdimm_region_key --> &nvdimm_bus->reconfig_mutex --> system_transition_mutex

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(system_transition_mutex);
                                lock(&nvdimm_bus->reconfig_mutex);
                                lock(system_transition_mutex);
   lock(&nvdimm_region_key);

--

 Chain exists of:
   &cxl_nvdimm_bridge_key --> acpi_scan_lock --> &cxl_root_key

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&cxl_root_key);
                                lock(acpi_scan_lock);
                                lock(&cxl_root_key);
   lock(&cxl_nvdimm_bridge_key);

---

These stem from holding nvdimm_bus_lock() over hibernate_quiet_exec()
which walks the entire system device topology taking device_lock() along
the way. The nvdimm_bus_lock() is protecting against unregistration,
multiple simultaneous ops callers, and preventing activate_show() from
racing activate_store(). For the first 2, the lock is redundant.
Unregistration already flushes all ops users, and sysfs already prevents
multiple threads to be active in an ops handler at the same time. For
the last userspace should already be waiting for its last
activate_store() to complete, and does not need activate_show() to flush
the write side, so this lock usage can be deleted in these attributes.

Fixes: 48001ea50d17 ("PM, libnvdimm: Add runtime firmware activation support")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v3:
- Remove nvdimm_bus_lock() from all ->capability() invocations (Ira)

 drivers/nvdimm/core.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 144926b7451c..d91799b71d23 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -368,9 +368,7 @@ static ssize_t capability_show(struct device *dev,
 	if (!nd_desc->fw_ops)
 		return -EOPNOTSUPP;
 
-	nvdimm_bus_lock(dev);
 	cap = nd_desc->fw_ops->capability(nd_desc);
-	nvdimm_bus_unlock(dev);
 
 	switch (cap) {
 	case NVDIMM_FWA_CAP_QUIESCE:
@@ -395,10 +393,8 @@ static ssize_t activate_show(struct device *dev,
 	if (!nd_desc->fw_ops)
 		return -EOPNOTSUPP;
 
-	nvdimm_bus_lock(dev);
 	cap = nd_desc->fw_ops->capability(nd_desc);
 	state = nd_desc->fw_ops->activate_state(nd_desc);
-	nvdimm_bus_unlock(dev);
 
 	if (cap < NVDIMM_FWA_CAP_QUIESCE)
 		return -EOPNOTSUPP;
@@ -443,7 +439,6 @@ static ssize_t activate_store(struct device *dev,
 	else
 		return -EINVAL;
 
-	nvdimm_bus_lock(dev);
 	state = nd_desc->fw_ops->activate_state(nd_desc);
 
 	switch (state) {
@@ -461,7 +456,6 @@ static ssize_t activate_store(struct device *dev,
 	default:
 		rc = -ENXIO;
 	}
-	nvdimm_bus_unlock(dev);
 
 	if (rc == 0)
 		rc = len;
@@ -484,10 +478,7 @@ static umode_t nvdimm_bus_firmware_visible(struct kobject *kobj, struct attribut
 	if (!nd_desc->fw_ops)
 		return 0;
 
-	nvdimm_bus_lock(dev);
 	cap = nd_desc->fw_ops->capability(nd_desc);
-	nvdimm_bus_unlock(dev);
-
 	if (cap < NVDIMM_FWA_CAP_QUIESCE)
 		return 0;
 

