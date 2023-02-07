Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08027480
	for <nvdimm@lists.linux.dev>; Tue,  7 Feb 2023 19:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675797413; x=1707333413;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=Cj2RALqAObYfvR8W+o15d2ZFKZgU2s7oBAZfRhTwT90=;
  b=PcADMr7M1i4/H7sD2WM2CMAex2w8AAMUyoZLxOFJL+41RJFdJ6rYpzCv
   h4jSBxbSrqJ2QK0t32cGv8KvncaoNpHb/SLsFGPF6FjWL38MFCLL7GSZq
   tb88R24lx8j1M/WqPY8P8elVX760k4y4Rl8JMGeTqVKlIxzr+WEuC9Mmv
   zhmzFdSuySnMFC9J6Vs9zE/HglMRFLSqWo28H++3beviIs0aeqDe6pM0W
   NO/SG6hKXxRkZ/dZoAbBAtCiCEYneSYIKbljnnc4v2JmfIEfw9mpDcu0a
   c/GYLkjXWDWXK4nSEErZuQA6dpmip9/cI8HwYAWLN6SkbahkhkAN2ygPp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="331733972"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="331733972"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="735649801"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="735649801"
Received: from fvanegas-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.209.109.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:52 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH ndctl 0/7] cxl: add support for listing and creating
 volatile regions
Date: Tue, 07 Feb 2023 12:16:26 -0700
Message-Id: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIqj4mMC/x2NQQqDQAxFryJZNxBHLNirlC7GMY4BiZKUQRDv3
 rHLx/uPf4KzCTu8mhOMi7hsWqF9NJCWqJlRpsoQKHTUBsJSsGxr/MrKaJzr3JGe3dBT4rkfCGo
 5RmccLWpa7nZnnUTzbXbjWY7/3/tzXT/a1m0JfwAAAA==
To: linux-cxl@vger.kernel.org
Cc: Gregory Price <gregory.price@memverge.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=2900;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=Cj2RALqAObYfvR8W+o15d2ZFKZgU2s7oBAZfRhTwT90=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmPFi8u89tU83H1g7mFwubfZygkPdfzb79nfk85zKBWa
 qHPgVrnjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEyEYwojw73VkqJcj8yzpBX9
 t8zkuRfUw5YWaLmRW0svoOMhQ3xKD8P/1GkXDSOuzg8/v25fbtm2Y/3TdzRPaPmacnj6vE+h0xx
 zWAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

While enumeration of ram type regions already works in libcxl and
cxl-cli, it lacked an attribute to indicate pmem vs. ram. Add a new
'type' attribute to region listings to address this. Additionally, add
support for creating ram regions to the cxl-create-region command. The
region listings are also updated with dax-region information for
volatile regions.

This also includes fixed for a few bugs / usability issues identified
along the way - patches 1, 4, and 6. Patch 5 is a usability improvement
where based on decoder capabilities, the type of a region can be
inferred for the create-region command.

These have been tested against the ram-region additions to cxl_test
which are part of the kernel support patch set[1].
Additionally, tested against qemu using a WIP branch for volatile
support found here[2]. The 'run_qemu' script has a branch that creates
volatile memdevs in addition to pmem ones. This is also in a branch[3]
since it depends on [2].

These cxl-cli / libcxl patches themselves are also available in a
branch at [4].

[1]: https://lore.kernel.org/linux-cxl/167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com/
[2]: https://gitlab.com/jic23/qemu/-/commits/cxl-2023-01-26
[3]: https://github.com/pmem/run_qemu/commits/vv/ram-memdevs
[4]: https://github.com/pmem/ndctl/tree/vv/volatile-regions

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Dan Williams (2):
      cxl/list: Include regions in the verbose listing
      cxl/list: Enumerate device-dax properties for regions

Vishal Verma (5):
      cxl/region: skip region_actions for region creation
      cxl: add a type attribute to region listings
      cxl: add core plumbing for creation of ram regions
      cxl/region: accept user-supplied UUIDs for pmem regions
      cxl/region: determine region type based on root decoder capability

 Documentation/cxl/cxl-create-region.txt |  6 ++-
 Documentation/cxl/cxl-list.txt          | 31 +++++++++++++
 Documentation/cxl/lib/libcxl.txt        |  8 ++++
 cxl/lib/private.h                       |  2 +
 cxl/lib/libcxl.c                        | 72 ++++++++++++++++++++++++++++--
 cxl/filter.h                            |  3 ++
 cxl/libcxl.h                            |  3 ++
 cxl/filter.c                            |  1 +
 cxl/json.c                              | 21 +++++++++
 cxl/list.c                              |  3 ++
 cxl/region.c                            | 79 ++++++++++++++++++++++++++++++---
 cxl/lib/libcxl.sym                      |  7 +++
 cxl/lib/meson.build                     |  1 +
 cxl/meson.build                         |  3 ++
 14 files changed, 229 insertions(+), 11 deletions(-)
---
base-commit: 08720628d2ba469e203a18c0b1ffbd90f4bfab1d
change-id: 20230120-vv-volatile-regions-063950cef590

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

