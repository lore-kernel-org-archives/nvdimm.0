Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A59C22318;
	Fri, 23 May 2025 16:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748018805; cv=none; b=JqKRgl0Zu856GclY2BSGAxb52cQnkYdLoW05nVFiRgyzGRDtp9tiS04UlaDGaKrhXaw+2sZxl7kMBhcVQewkdEFVvEDXnDuJx21lOTrJiSjbQaopp5KSay03j1ZhPbC8Dyka58ybosQqYmdsiFwMpRxGvcIyNUGXVUzZFz9bVlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748018805; c=relaxed/simple;
	bh=f2GdJGdH1qO/ZnwkcVTPFHVWaViizZ+H0qDOU+LvK+E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CSWlW10xCMtams0mJNDbS3en9CaVLRtSGTcK9IJrJ3kpScZCZ2PEbMkgMLvPDkBRnFftSo/Ch5TGMMnQstbLAlLpXPKXPkCO87p0JZOEGIlYbNovsn4JomO42f/IJDlgN8TwEoQRJd3EC62chf1BVgsScwQRZtP37zV7HY9IYbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511C3C4CEE9;
	Fri, 23 May 2025 16:46:44 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com,
	Marc.Herbert@linux.intel.com,
	Dan Williams <dan.j.williams@intel.com>
Subject: [NDCTL PATCH v9 0/4] ndctl: Add support and test for CXL Features support
Date: Fri, 23 May 2025 09:46:35 -0700
Message-ID: <20250523164641.3346251-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v9:
- Move script body to main(). (Marc)
- Remove uuid dep for test module. (Marc)
- Remove removal of error trap. (Marc)

v8:
- Stash fwctl discovery functions behind ifdef (Alison)
- Deal with old compilers and __counted_by(). (Alison)

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
 cxl/fwctl/features.h             | 187 +++++++++++++
 cxl/fwctl/fwctl.h                | 141 ++++++++++
 cxl/lib/libcxl.c                 |  94 +++++++
 cxl/lib/libcxl.sym               |   8 +
 cxl/lib/private.h                |   6 +
 cxl/libcxl.h                     |   7 +
 meson.build                      |   1 +
 meson_options.txt                |   2 +
 test/cxl-features.sh             |  37 +++
 test/fwctl.c                     | 439 +++++++++++++++++++++++++++++++
 test/meson.build                 |  18 ++
 14 files changed, 1025 insertions(+)
 create mode 100644 cxl/fwctl/cxl.h
 create mode 100644 cxl/fwctl/features.h
 create mode 100644 cxl/fwctl/fwctl.h
 create mode 100755 test/cxl-features.sh
 create mode 100644 test/fwctl.c


base-commit: 1850ddcbcbf9eebd343c6e87a2c55f3f5e3930c4
-- 
2.49.0

