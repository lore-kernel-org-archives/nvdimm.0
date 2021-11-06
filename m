Received: from smtp.smtpout.orange.fr (smtp07.smtpout.orange.fr [80.12.242.129])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C49E2C85
	for <nvdimm@lists.linux.dev>; Sat,  6 Nov 2021 17:34:52 +0000 (UTC)
Received: from pop-os.home ([86.243.171.122])
	by smtp.orange.fr with ESMTPA
	id jPTFmPYWZ2lVYjPTFmWJjr; Sat, 06 Nov 2021 18:27:14 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 06 Nov 2021 18:27:14 +0100
X-ME-IP: 86.243.171.122
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] nvdimm/pmem: Fix an error handling path in 'pmem_attach_disk()'
Date: Sat,  6 Nov 2021 18:27:11 +0100
Message-Id: <f1933a01d9cefe24970ee93d741babb8fe9c1b32.1636219557.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If 'devm_init_badblocks()' fails, a previous 'blk_alloc_disk()' call must
be undone.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is speculative. Several fixes on error handling paths have been
done recently, but this one has been left as-is. There was maybe a good
reason that I have missed for that. So review with care!

I've not been able to identify a Fixes tag that please me :(
---
 drivers/nvdimm/pmem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index fe7ece1534e1..c37a1e6750b3 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -490,8 +490,9 @@ static int pmem_attach_disk(struct device *dev,
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
 			/ 512);
-	if (devm_init_badblocks(dev, &pmem->bb))
-		return -ENOMEM;
+	rc = devm_init_badblocks(dev, &pmem->bb);
+	if (rc)
+		goto out;
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
 	disk->bb = &pmem->bb;
 
-- 
2.30.2

