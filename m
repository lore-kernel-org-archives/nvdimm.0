Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CAE2356B1;
	Fri,  9 May 2025 16:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746808810; cv=none; b=o8JIcy1pMEKpjV/wQaatqH1VIaAYPADpKU4VopYfpkiX5oyfKxrDNN1oIlnyJCpCuDqVIU2jzMEBQPIzShrqBUIfVElFVwvd03UpytQyrJ/vuZwTiOCYYn7aULxQhbLfmmevRuQnS4+/tU9hmVOBxEPj1Jq3bU+cO/iD8qqPZIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746808810; c=relaxed/simple;
	bh=Y4KKETFPIiPNeO2rNQqkqZgMZy/CphLD9D8yEg25noc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OSqjoPDJkXfCHFM4M5uc5X13m5E8X1D7cBX+qUBKV0Gwr3UoMH83ridGbgGoTYncSNFfZiIYeIojmHx8wxBEDjyy0Bcs34D+CWZMIDd/EyDcvBBbFz0tNEnW5UfcS+EQL/BvdhQqKL1vcRb+aowNzYcr2UAsIKc/jSrgMAUW5JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E967C4CEE4;
	Fri,  9 May 2025 16:40:09 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com
Subject: [NDCTL PATCH v6 0/4] ndctl: Add support and test for CXL Features support
Date: Fri,  9 May 2025 09:39:11 -0700
Message-ID: <20250509164006.687873-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v6:
- Rename cxl-features.control.c back to fwctl.c. (Dan)
- Move features behind a meson option. (Dan)
- See individual commits for specific changes from v5.

v5:
- Add documentation for exported symbols. (Alison)
- Create 'struct cxl_fwctl' as object under cxl_memdev. (Dan)
- Make command prep common code. (Alison)
- Rename fwctl.c to cxl-features-control.c. (Alison)
- See individual commits for specific changes from v4.

v4:
- Adjust to kernel changes of input/output structs
- Fixup skip/pass/fail logic
- Added new kernel headers detection and dependency in meson.build

v3:
- Update test to use opcode instead of command id.

v2:
- Drop features device enumeration
- Add discovery of char device under memdev

The series provides support of libcxl enumerating FWCTL character device
under the cxl_memdev device. It discovers the char device major
and minor numbers for the CXL features device in order to allow issuing
of ioctls to the device. 

A unit test is added to locate cxl_memdev exported by the cxl_test
kernel module and issue all the supported ioctls to the associated
FWCTL char device to verify that all the ioctl paths are working as expected.

Kernel series: https://lore.kernel.org/linux-cxl/20250207233914.2375110-1-dave.jiang@intel.com/T/#t

Dave Jiang (4):
      cxl: Add cxl_bus_get_by_provider()
      cxl: Enumerate major/minor of FWCTL char device
      ndctl: Add features.h from kernel UAPI
      cxl/test: Add test for cxl features device

 Documentation/cxl/lib/libcxl.txt |  24 ++++
 cxl/fwctl/cxl.h                  |  56 ++++++++
 cxl/fwctl/features.h             | 179 ++++++++++++++++++++++++
 cxl/fwctl/fwctl.h                | 141 +++++++++++++++++++
 cxl/lib/libcxl.c                 |  90 ++++++++++++
 cxl/lib/libcxl.sym               |   8 ++
 cxl/lib/private.h                |   6 +
 cxl/libcxl.h                     |   7 +
 meson_options.txt                |   2 +
 test/cxl-features.sh             |  31 +++++
 test/fwctl.c                     | 439 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build                 |  19 +++
 12 files changed, 1002 insertions(+)

