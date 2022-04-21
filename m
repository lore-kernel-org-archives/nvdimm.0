Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB791FC0
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 15:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650555420; x=1682091420;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HRjWqKMI48PJpBkmXwqNCKGbFsNs0ocG1yVkfojUm7A=;
  b=APdEG5qKFgAES62+dvuTXOOAkxhrRyGYF9gjOIT1TrOHmyfapoubORCD
   haM+SnOkF4xVt/4YfJTMVGBRCyKeopJy/7WjZN1pXiCR6MUH2I65XbyP6
   7ZpRbcIB8h1YLzDmJTrP4EXj6bussUvqR4KavPLiIGOC5FRu28IUFVgiN
   mkJtp6Gil0YYyY7oV333Q0Gq9IT9wMybl4h0RZ0a1N865Oy6HO6+9p5a/
   VQTWnns8OR3pteUtWLQx0FTJ3MPso5q44MitNMHwnUcieE/wqspZuflP5
   9LMiErdGNxZzPZiNIhEOqLbvWuS3mXjyBPapKQ/kHpOPhQWRLf9h8l4kR
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264559086"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="264559086"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 08:33:08 -0700
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="593708723"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 08:33:08 -0700
Subject: [PATCH v3 0/8] device-core: Enable device_lock() lockdep validation
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ira Weiny <ira.weiny@intel.com>, Ben Widawsky <ben.widawsky@intel.com>,
 Will Deacon <will@kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Waiman Long <longman@redhat.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Date: Thu, 21 Apr 2022 08:33:08 -0700
Message-ID: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Changes since v2 [1]
- Use lockdep_set_class(), lockdep_set_class_and_subclass(), and
  lock_set_class() instead of a 'lockdep_mutex' in 'struct device'.
  (Peter and Waiman)
- Include a fix identifed by this new infrastructure

[1]: https://lore.kernel.org/r/164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com

The device_lock() uses lockdep_set_novalidate_class() because it is
taken in too many contexts that cannot be described by a single mutex
lock class. The lack of lockdep coverage leads to deadlock scenarios
landing upstream. To mitigate that problem the lockdep_mutex was added
[2].

The lockdep_mutex, however, is an unscalable hack that overlooks
advancements in the lockdep API to change a given lock's lock class [3].
With lockdep_set_class() a device subsystem can initialize a dedicated
lock class per device type at device creation time, with
lock_set_class() a device-driver can temporarily override a lockdep
class after-the-fact. Use lockdep class assignment APIs to replace the
usage of lockdep_mutex in the CXL and NVDIMM subsystems, and delete
lockdep_mutex.

[2]: commit 87a30e1f05d7 ("driver-core, libnvdimm: Let device subsystems add local lockdep coverage")
[3]: https://lore.kernel.org/r/Ylf0dewci8myLvoW@hirez.programming.kicks-ass.net

---

Dan Williams (8):
      cxl: Replace lockdep_mutex with local lock classes
      cxl/acpi: Add root device lockdep validation
      cxl: Drop cxl_device_lock()
      nvdimm: Replace lockdep_mutex with local lock classes
      ACPI: NFIT: Drop nfit_device_lock()
      nvdimm: Drop nd_device_lock()
      device-core: Kill the lockdep_mutex
      nvdimm: Fix firmware activation deadlock scenarios


 drivers/acpi/nfit/core.c        |   30 ++++++++-------
 drivers/acpi/nfit/nfit.h        |   24 ------------
 drivers/base/core.c             |    3 --
 drivers/cxl/acpi.c              |   15 ++++++++
 drivers/cxl/core/memdev.c       |    3 ++
 drivers/cxl/core/pmem.c         |   10 ++++-
 drivers/cxl/core/port.c         |   68 ++++++++++++++++------------------
 drivers/cxl/cxl.h               |   78 ---------------------------------------
 drivers/cxl/mem.c               |    4 +-
 drivers/cxl/pmem.c              |   12 +++---
 drivers/nvdimm/btt_devs.c       |   23 +++++++-----
 drivers/nvdimm/bus.c            |   38 ++++++++-----------
 drivers/nvdimm/core.c           |   14 +++----
 drivers/nvdimm/dax_devs.c       |    4 +-
 drivers/nvdimm/dimm_devs.c      |   12 ++++--
 drivers/nvdimm/namespace_devs.c |   46 ++++++++++++++---------
 drivers/nvdimm/nd-core.h        |   68 +---------------------------------
 drivers/nvdimm/pfn_devs.c       |   31 +++++++++-------
 drivers/nvdimm/pmem.c           |    2 +
 drivers/nvdimm/region.c         |    2 +
 drivers/nvdimm/region_devs.c    |   20 ++++++----
 include/linux/device.h          |   30 +++++++++++++--
 lib/Kconfig.debug               |   23 ------------
 23 files changed, 209 insertions(+), 351 deletions(-)

base-commit: ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e
