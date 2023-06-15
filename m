Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C0F174F6
	for <nvdimm@lists.linux.dev>; Thu, 15 Jun 2023 22:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686866463; x=1718402463;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=lZ52Uyzr79J6u7Q25jSEHwxvL9rBOICrMhEJ+YQMfOE=;
  b=Eh1sevbzz7/2T+ExHknzctNl5B8xgLlblN5hY+osPAdwY4Q0+cgTHaUY
   pD/kJLPRI6g+QaZlO1y0uAT9v8z3dS0Pgl7zvar5zH1+Leo/umCp38+Q+
   vZURKzmEbzyG6lAK5Fdfhs4sFKz2Fhg/diKRpnB0vnkhtTHuqjMIpOlQW
   4HCJ8Dd9duDt+61J1IpnhPyuFbOIMUdMtLHDmnHWYfzHxBot8E57DZUzw
   cmGq9FRqWDQH56gyIfoKx2XkpoB9rpxRJATETVk0nJD+wBASABn+U3DcY
   qPEcEu1EmQsvinUr43X7lziKM0KMUfxezXRE49C+blmLZtmELYEQtdex9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="343791124"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="343791124"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 15:01:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="715770085"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="715770085"
Received: from smaurice-mobl.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.120.175])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 15:01:00 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 0/3] mm: use memmap_on_memory semantics for dax/kmem
Date: Thu, 15 Jun 2023 16:00:22 -0600
Message-Id: <20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPaJi2QC/x2NQQqDMBBFryKzdiAmVq1XKaXEOOpQEyWhQRDv7
 tDFX7wPj3dCosiUoC9OiJQ58RYEqrIAt9gwE/IoDFppo5rKYM749eQ/Mm93fNSdcd2oat0+QaT
 BJsIh2uAW0cJvXeXcI018/Cuv93XdGOiP7nUAAAA=
To: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 Huang Ying <ying.huang@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-02a79
X-Developer-Signature: v=1; a=openpgp-sha256; l=1518;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=lZ52Uyzr79J6u7Q25jSEHwxvL9rBOICrMhEJ+YQMfOE=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCndXXwTsly/77OW2O/flsjQd6vDyiTYSTTdw7JrgQJnk
 u7tqAkdpSwMYlwMsmKKLH/3fGQ8Jrc9nycwwRFmDisTyBAGLk4BmMiirYwM94uWCrD/T7tUVyQu
 /Z/rbMmOF5+f8nw51Lr5VmvUz2c2lQz/DI1u2T1KWqE1rY7z7stD/zPc3oVZTq58l/v2SgTHrpN
 JfAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The dax/kmem driver can potentially hot-add large amounts of memory
originating from CXL memory expanders, or NVDIMMs, or other 'device
memories'. There is a chance there isn't enough regular system memory
available to fit ythe memmap for this new memory. It's therefore
desirable, if all other conditions are met, for the kmem managed memory
to place its memmap on the newly added memory itself.

Arrange for this by first allowing for a module parameter override for
the mhp_supports_memmap_on_memory() test using a flag, adjusting the
only other caller of this interface in dirvers/acpi/acpi_memoryhotplug.c,
exporting the symbol so it can be called by kmem.c, and finally changing
the kmem driver to add_memory() in chunks of memory_block_size_bytes().

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Vishal Verma (3):
      mm/memory_hotplug: Allow an override for the memmap_on_memory param
      mm/memory_hotplug: Export symbol mhp_supports_memmap_on_memory()
      dax/kmem: Always enroll hotplugged memory for memmap_on_memory

 include/linux/memory_hotplug.h |  2 +-
 drivers/acpi/acpi_memhotplug.c |  2 +-
 drivers/dax/kmem.c             | 49 +++++++++++++++++++++++++++++++-----------
 mm/memory_hotplug.c            | 25 ++++++++++++++-------
 4 files changed, 55 insertions(+), 23 deletions(-)
---
base-commit: f1fcbaa18b28dec10281551dfe6ed3a3ed80e3d6
change-id: 20230613-vv-kmem_memmap-5483c8d04279

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

