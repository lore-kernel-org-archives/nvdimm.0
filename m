Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6C12C87
	for <nvdimm@lists.linux.dev>; Wed, 27 Oct 2021 12:09:41 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="290980263"
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="290980263"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 05:09:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="486649975"
Received: from dev01.bj.intel.com ([10.238.158.57])
  by orsmga007.jf.intel.com with ESMTP; 27 Oct 2021 05:09:38 -0700
From: Huaisheng Ye <huaisheng.ye@intel.com>
To: dan.j.williams@intel.com,
	hch@lst.de,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Huaisheng Ye <huaisheng.ye@intel.com>
Subject: [PATCH 0/4] add ro state control function for nvdimm drivers
Date: Wed, 27 Oct 2021 20:09:33 +0800
Message-Id: <20211027120937.1163744-1-huaisheng.ye@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libndctl failed to pass for the reason of writing pmem disk when running
ndctl testing.

Here is the error message below,

    namespace6.0: failed to write /dev/pmem6
    check_namespaces: namespace6.0 validate_bdev failed
    ndctl-test1 failed: -6

Commit 98f49b63e84d4ee1a5c327d0b5f4e8699f6c70fe removes set_device_ro and
e00adcadf3af7a8335026d71ab9f0e0a922191ac adds a new set_read_only method
to allow for driver-specific processing when changing the block device's
read-only state.

Current drivers nd_pmem, nd_blk and nd_btt don't have the capability to
enable or disable write protect (read-only) state. Without that,
blkdev_roset just modifies the value of bd_read_only of struct block_device
and returns success to ioctl of block device. Error would happen when writing
read-only disk next.

Add ro state control function in libnvdimm for this purpose, and implement
set_read_only for BLKROSET.

Huaisheng Ye (4):
  libnvdimm: add a ro state control function for nvdimm
  libnvdimm/pmem: implement ->set_read_only to hook into BLKROSET
    processing
  libnvdimm/blk: implement ->set_read_only to hook into BLKROSET
    processing
  libnvdimm/btt: implement ->set_read_only to hook into BLKROSET
    processing

 drivers/nvdimm/blk.c  |  1 +
 drivers/nvdimm/btt.c  |  1 +
 drivers/nvdimm/bus.c  | 17 +++++++++++++++++
 drivers/nvdimm/nd.h   |  1 +
 drivers/nvdimm/pmem.c |  1 +
 5 files changed, 21 insertions(+)

-- 
2.27.0

