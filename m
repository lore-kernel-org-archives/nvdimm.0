Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE5572
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 18:53:38 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10073"; a="237223970"
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="237223970"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 11:53:38 -0700
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="446066016"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 11:53:38 -0700
Subject: [PATCH v2] ACPI: NFIT: Fix support for virtual SPA ranges
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Jacek Zloch <jacek.zloch@intel.com>,
 Lukasz Sobieraj <lukasz.sobieraj@intel.com>, "Lee, Chun-Yi" <jlee@suse.com>,
 stable@vger.kernel.org, Krzysztof Rusocki <krzysztof.rusocki@intel.com>,
 Damian Bassa <damian.bassa@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Date: Wed, 11 Aug 2021 11:53:37 -0700
Message-ID: <162870796589.2521182.1240403310175570220.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162766355874.3223041.9582643895337437921.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162766355874.3223041.9582643895337437921.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Fix the NFIT parsing code to treat a 0 index in a SPA Range Structure as
a special case and not match Region Mapping Structures that use 0 to
indicate that they are not mapped. Without this fix some platform BIOS
descriptions of "virtual disk" ranges do not result in the pmem driver
attaching to the range.

Details:
In addition to typical persistent memory ranges, the ACPI NFIT may also
convey "virtual" ranges. These ranges are indicated by a UUID in the SPA
Range Structure of UUID_VOLATILE_VIRTUAL_DISK, UUID_VOLATILE_VIRTUAL_CD,
UUID_PERSISTENT_VIRTUAL_DISK, or UUID_PERSISTENT_VIRTUAL_CD. The
critical difference between virtual ranges and UUID_PERSISTENT_MEMORY,
is that virtual do not support associations with Region Mapping
Structures.  For this reason the "index" value of virtual SPA Range
Structures is allowed to be 0. If a platform BIOS decides to represent
NVDIMMs with disconnected "Region Mapping Structures" (range-index ==
0), the kernel may falsely associate them with standalone ranges where
the "SPA Range Structure Index" is also zero. When this happens the
driver may falsely require labels where "virtual disks" are expected to
be label-less. I.e. "label-less" is where the namespace-range ==
region-range and the pmem driver attaches with no user action to create
a namespace.

Cc: Jacek Zloch <jacek.zloch@intel.com>
Cc: Lukasz Sobieraj <lukasz.sobieraj@intel.com>
Cc: "Lee, Chun-Yi" <jlee@suse.com>
Cc: <stable@vger.kernel.org>
Fixes: c2f32acdf848 ("acpi, nfit: treat virtual ramdisk SPA as pmem region")
Reported-by: Krzysztof Rusocki <krzysztof.rusocki@intel.com>
Reported-by: Damian Bassa <damian.bassa@intel.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v1:
- Clarify the changelog (Jeff)
- Add a comment about why range_index is checked (Jeff)

 drivers/acpi/nfit/core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 23d9a09d7060..a3ef6cce644c 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3021,6 +3021,9 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
 		struct nd_mapping_desc *mapping;
 
+		/* range index 0 == unmapped in SPA or invalid-SPA */
+		if (memdev->range_index == 0 || spa->range_index == 0)
+			continue;
 		if (memdev->range_index != spa->range_index)
 			continue;
 		if (count >= ND_MAX_MAPPINGS) {

