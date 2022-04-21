Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D956E1FC0
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 15:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650555457; x=1682091457;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x3xS6cEt6lHXiNb+A1o9kWq7JklXoM+r+tP2gN5rJV4=;
  b=FvZ3IPImbhBy9ySPXiIu9SP/UeHnWiXU+229yo/2CgC+zyBxHq7NmT7S
   B/P7rxnp8AgmcRqJg8qTqZe3EEmr2R2p9MLDlzePSZBBud8sRA8Aesw5L
   z+IpU5PBXkorlzHi0P2Jho/+WEi+8rZRbjJC/fdLvubKe6e3PCTLsHK0m
   eb4QcW5rGv19StuSutWmadWekx935ZmmKjeDHuL+KNcaD0BPTE9T3LHIe
   glJxBLkuQ+/pS9RZ6wMc04ZASP5kcnjlHYml13rjTpxQQCjbQcy8LDaJZ
   6i7iDxdIMKGi/pQPwCAC7PmZhUgI7h3Ot1VJ/+FLxiPiHmuDqPotFaYUZ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="350833505"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="350833505"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 08:33:51 -0700
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="530353769"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 08:33:51 -0700
Subject: [PATCH v3 8/8] nvdimm: Fix firmware activation deadlock scenarios
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: peterz@infradead.org, vishal.l.verma@intel.com, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Thu, 21 Apr 2022 08:33:51 -0700
Message-ID: <165055523099.3745911.9091010720291846249.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
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
 drivers/nvdimm/core.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 144926b7451c..7c7f4a43fd4f 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -395,10 +395,8 @@ static ssize_t activate_show(struct device *dev,
 	if (!nd_desc->fw_ops)
 		return -EOPNOTSUPP;
 
-	nvdimm_bus_lock(dev);
 	cap = nd_desc->fw_ops->capability(nd_desc);
 	state = nd_desc->fw_ops->activate_state(nd_desc);
-	nvdimm_bus_unlock(dev);
 
 	if (cap < NVDIMM_FWA_CAP_QUIESCE)
 		return -EOPNOTSUPP;
@@ -443,7 +441,6 @@ static ssize_t activate_store(struct device *dev,
 	else
 		return -EINVAL;
 
-	nvdimm_bus_lock(dev);
 	state = nd_desc->fw_ops->activate_state(nd_desc);
 
 	switch (state) {
@@ -461,7 +458,6 @@ static ssize_t activate_store(struct device *dev,
 	default:
 		rc = -ENXIO;
 	}
-	nvdimm_bus_unlock(dev);
 
 	if (rc == 0)
 		rc = len;

