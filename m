Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B822A2F80
	for <nvdimm@lists.linux.dev>; Thu, 10 Jun 2021 22:25:59 +0000 (UTC)
IronPort-SDR: BF9BAq/pbIDcRAtVePABpIpK3k5uwAvpvh/HeHi100lkzsFedcm7gJDKmFQVRDqVhZrS9604VP
 u3wuAtB5dBUw==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="226830841"
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="226830841"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:25:58 -0700
IronPort-SDR: PkThYScbSj0g+5RZ2lwhwHWG6CyiPwTzjjYWDBkyFHpE4UcFRW9gMWcKNrkpeuYERq9uDYSwFm
 qMmEqcl19v8g==
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="486361110"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:25:58 -0700
Subject: [PATCH 0/5] cxl/pmem: Add core infrastructure for PMEM support
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, ben.widawsky@intel.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, linux-kernel@vger.kernel.org
Date: Thu, 10 Jun 2021 15:25:57 -0700
Message-ID: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

CXL Memory Expander devices (CXL 2.0 Type-3) support persistent memory
in addition to volatile memory expansion. The most significant changes
this requires of the existing LIBNVDIMM infrastructure, compared to what
was needed to support ACPI NFIT defined PMEM, is the ability to
dynamically provision regions in addition to namespaces, and a formal
model for hotplug.

Before region provisioning can be added the CXL enabling needs to
enumerate "nvdimm" devices on a CXL nvdimm-bus. This is modeled as a
CXL-nvdimm-bridge device (bridging CXL to nvdimm) and an associated
driver to activate and deactivate that bus-bridge. Once the bridge is
registered it scans for CXL nvdimm devices registered by endpoints.  The
CXL core bus is used as a rendezvous for nvdimm bridges and endpoints
allowing them to be registered and enabled in any order.

At the end of this series the ndctl utility can see CXL nvdimm resources
just like any other nvdimm bus.

    # ndctl list -BDiu -b CXL
    {
      "provider":"CXL",
      "dev":"ndbus1",
      "dimms":[
        { 
          "dev":"nmem1",
          "state":"disabled"
        },
        { 
          "dev":"nmem0",
          "state":"disabled"
        }
      ]
    }

Follow-on patches extend the nvdimm core label support for CXL region
and namespace labels. For now just add the machinery to register the
bus and nvdimm base objects.

---

Dan Williams (5):
      cxl/core: Add cxl-bus driver infrastructure
      cxl/pmem: Add initial infrastructure for pmem support
      libnvdimm: Export nvdimm shutdown helper, nvdimm_delete()
      libnvdimm: Drop unused device power management support
      cxl/pmem: Register 'pmem' / cxl_nvdimm  devices


 drivers/cxl/Kconfig        |   13 ++
 drivers/cxl/Makefile       |    2 
 drivers/cxl/acpi.c         |   37 +++++-
 drivers/cxl/core.c         |  281 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h          |   57 +++++++++
 drivers/cxl/mem.h          |    2 
 drivers/cxl/pci.c          |   23 +++-
 drivers/cxl/pmem.c         |  230 ++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/bus.c       |   64 ++++++----
 drivers/nvdimm/dimm_devs.c |   18 +++
 include/linux/libnvdimm.h  |    1 
 11 files changed, 697 insertions(+), 31 deletions(-)
 create mode 100644 drivers/cxl/pmem.c

base-commit: 40ba17afdfabb01688c61565dbe02a916241bc05
