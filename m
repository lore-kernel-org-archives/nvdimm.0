Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8AC4B1E73;
	Mon, 19 May 2025 20:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747684867; cv=none; b=o5e9e3Cy1sDdKVSY/5nHvN3nNoqRVcM5ZVpi1+NmjQCPGsnGmrKLnUtqkKJzccYjaPPG82YwRv9VAeg62MEubWuMK+dxHFSMs2NSEzKUWFtuHbfRdTUQ9Fgnyr8KliUSbez34MKGo7zb65E0qK1NPDF4FJJ4d/lVFjiUckDtG3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747684867; c=relaxed/simple;
	bh=dJ1Sv1Br8WMzR7ssC9Z3i6cZcfcxQmHzZGpf82b+Dxk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hdokouGukyR8AHN+AlMzqL2Gph3xt5Bp4UFOZDsAs09z3eOp3h+2+PE21y3FHiJSm8lmy5cP96DB0uK5dUoh5x0w5dheNGWb5SH2K/MYB5h9qXHJbZgigUKp+IioxShRN5HBJRg5xsjZV+6+xC3ryHmY7wfdYnJMXVWyr/0G/oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA398C4CEE4;
	Mon, 19 May 2025 20:01:06 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com,
	Dan Williams <dan.j.williams@intel.com>
Subject: [NDCTL PATCH v7 0/4] ndctl: Add support and test for CXL Features support
Date: Mon, 19 May 2025 13:00:50 -0700
Message-ID: <20250519200056.3901498-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v7:
- Move enumeration of fwctl behind meson option 'fwctl'. (Dan)

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

 Documentation/cxl/lib/libcxl.txt |  26 ++
 config.h.meson                   |   3 +
 cxl/fwctl/cxl.h                  |  56 ++++
 cxl/fwctl/features.h             | 179 +++++++++++++
 cxl/fwctl/fwctl.h                | 141 ++++++++++
 cxl/lib/libcxl.c                 |  92 +++++++
 cxl/lib/libcxl.sym               |   8 +
 cxl/lib/private.h                |   6 +
 cxl/libcxl.h                     |   7 +
 meson.build                      |   1 +
 meson_options.txt                |   2 +
 test/cxl-features.sh             |  31 +++
 test/fwctl.c                     | 439 +++++++++++++++++++++++++++++++
 test/meson.build                 |  19 ++
 14 files changed, 1010 insertions(+)
 create mode 100644 cxl/fwctl/cxl.h
 create mode 100644 cxl/fwctl/features.h
 create mode 100644 cxl/fwctl/fwctl.h
 create mode 100755 test/cxl-features.sh
 create mode 100644 test/fwctl.c


base-commit: 1850ddcbcbf9eebd343c6e87a2c55f3f5e3930c4
-- 
2.49.0

