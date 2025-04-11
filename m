Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4D51F8BD6;
	Fri, 11 Apr 2025 18:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744397320; cv=none; b=aMjnkcKGaQdffhpvRW05WioaKxdwi1GG5TXQa76CyPhvOyyA7JGioxFYmVumcaBUkW9UDZc8EYQZc0W2y8e6Dw+XY7trVUi7YSyYV9OqYO1g1PJgg4sq9BSwQVvgkwvi3botEz5Yk1dqGjNNKUbzfyZXbuFn3tjUZGot5/pc8Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744397320; c=relaxed/simple;
	bh=41782EN71bNu2hX/0UNitih58KMQOjsx03F+mT3f4ns=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SQ8NkinjNIIFZvyp5R3Foir5U7IbexKuTWUqGvKVImAVtWP2bTyb/xcleOwgqKrE2PtHwHlmQwtyQmFmYZjmSSErGAd53ogTh4jTB8/y3x1L9GnkCUIO6G6tM2G2A09rw+Qm85HyqP9Auso1eSEWhdGAJRaUuzT8eedyZOi6Q30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47EBC4CEE2;
	Fri, 11 Apr 2025 18:48:39 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com
Subject: [NDCTL PATCH v5 0/3] ndctl: Add support and test for CXL Features support
Date: Fri, 11 Apr 2025 11:47:34 -0700
Message-ID: <20250411184831.2367464-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Dave Jiang (3):
      cxl: Add cxl_bus_get_by_provider()
      cxl: Enumerate major/minor of FWCTL char device
      cxl/test: Add test for cxl features device

 Documentation/cxl/lib/libcxl.txt |  23 ++++
 cxl/lib/libcxl.c                 |  89 ++++++++++++
 cxl/lib/libcxl.sym               |   8 ++
 cxl/lib/private.h                |   8 ++
 cxl/libcxl.h                     |   7 +
 test/cxl-features-control.c      | 439 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 test/cxl-features.sh             |  31 +++++
 test/cxl-topology.sh             |   4 +
 test/meson.build                 |  45 ++++++
 9 files changed, 654 insertions(+)

