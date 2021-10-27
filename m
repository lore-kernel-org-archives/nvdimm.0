Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624062C87
	for <nvdimm@lists.linux.dev>; Wed, 27 Oct 2021 12:09:48 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="290980302"
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="290980302"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 05:09:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="486650038"
Received: from dev01.bj.intel.com ([10.238.158.57])
  by orsmga007.jf.intel.com with ESMTP; 27 Oct 2021 05:09:45 -0700
From: Huaisheng Ye <huaisheng.ye@intel.com>
To: dan.j.williams@intel.com,
	hch@lst.de,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Huaisheng Ye <huaisheng.ye@intel.com>
Subject: [PATCH 3/4] libnvdimm/blk: implement ->set_read_only to hook into BLKROSET processing
Date: Wed, 27 Oct 2021 20:09:36 +0800
Message-Id: <20211027120937.1163744-4-huaisheng.ye@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211027120937.1163744-1-huaisheng.ye@intel.com>
References: <20211027120937.1163744-1-huaisheng.ye@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the ->set_read_only method for nd_blk.

Signed-off-by: Huaisheng Ye <huaisheng.ye@intel.com>
---
 drivers/nvdimm/blk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 088d3dd6f6fa..9d76980ebff7 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -226,6 +226,7 @@ static int nsblk_rw_bytes(struct nd_namespace_common *ndns,
 static const struct block_device_operations nd_blk_fops = {
 	.owner = THIS_MODULE,
 	.submit_bio =  nd_blk_submit_bio,
+	.set_read_only = nd_set_ro,
 };
 
 static void nd_blk_release_disk(void *disk)
-- 
2.27.0

