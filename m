Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5283F3FDA
	for <nvdimm@lists.linux.dev>; Fri, 24 Sep 2021 13:11:32 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AnLf3K6M9Hxwb5sfvrR3OlsFynXyQoLVcMsFnjC/?=
 =?us-ascii?q?WdVLq02hx3z1WxjAYDW6PO/eKa2vwedt+PN6+oRwDv8KHm99gGjLY11k3ESsS9?=
 =?us-ascii?q?pCt6fd1j6vIF3rLaJWFFSqL1u1GAjX7BJ1yHiK0SiuFaOC79CEtj/3QH9IQNca?=
 =?us-ascii?q?fUsxPbV49IMseoUI78wIJqtYAbemRW2thi/uryyHsEAPNNwpPD44hw/nrRCWDE?=
 =?us-ascii?q?xjFkGhwUlQWPZintbJF/pUfJMp3yaqZdxMUTmTId9NWSdovzJnhlo/Y1xwrTN2?=
 =?us-ascii?q?4kLfnaVBMSbnXVeSMoiMOHfH83V4Z/Wpvuko4HKN0hUN/kSiAmctgjttLroCYR?=
 =?us-ascii?q?xorP7HXhaIWVBww/yRWZPQaqeaYfSXl2SCU5wicG5f2+N1iBV83MaUW4OFyBnt?=
 =?us-ascii?q?E9OBeIzcIBjiDjOKewbS1UOBgi80vas7xM+s3tnhmizOfEvciRZHKRr7i5NlE0?=
 =?us-ascii?q?TN2jcdLdd7SZdUebzVHbxnaZRBLfFANB/oWmOaum2m6djhwq0ycrqlx5HLcpCR?=
 =?us-ascii?q?3zrTsNd/9ft2RWd4Tmkeeu3KA82nnajkYPdqSjzGF71qrnObEmS69U4UXfJW89?=
 =?us-ascii?q?/h3kBid3WAeFhASfUW0rOP/iUOkXd9bbUsO9UIGqak06VzuTdTnWRC8iGCLswR?=
 =?us-ascii?q?aWNdKFeA+rgaXxcL85wefG3hBXjBaQMIpudVwRjEw0FKN2dTzClRSXBe9IZ6G3?=
 =?us-ascii?q?u7M62rsZm5OdilfDRLohDAtu7HLyLzfRDqTJjq7LJOIsw=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AkCYRAqAxvwrNDcDlHelI55DYdb4zR+YMi2TC?=
 =?us-ascii?q?1yhKJyC9Ffbo8fxG/c5rrCMc5wxwZJhNo7y90ey7MBbhHP1OkO4s1NWZLWrbUQ?=
 =?us-ascii?q?KTRekIh+bfKn/baknDH4VmtJuIHZIQNDSJNykZsS/l2njEL/8QhMmA7LuzhfrT?=
 =?us-ascii?q?i1NkTQRRYalm6AtjYzzraXFedU1XA4YjDpqA6o5irzqkQ34eacO2HT0rRO7Gzu?=
 =?us-ascii?q?e77q7OUFoXAQI98gmSgXeN4L7+KRKR2RATSHdu7N4ZgBD4rzA=3D?=
X-IronPort-AV: E=Sophos;i="5.85,319,1624291200"; 
   d="scan'208";a="114917452"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 24 Sep 2021 21:10:24 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 083E74D0DC7A;
	Fri, 24 Sep 2021 21:10:22 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 24 Sep 2021 21:10:17 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 24 Sep 2021 21:10:15 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>
Subject: [PATCH v7 4/8] pagemap,pmem: Introduce ->memory_failure()
Date: Fri, 24 Sep 2021 21:09:55 +0800
Message-ID: <20210924130959.2695749-5-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924130959.2695749-1-ruansy.fnst@fujitsu.com>
References: <20210924130959.2695749-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 083E74D0DC7A.A3E5F
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

When memory-failure occurs, we call this function which is implemented
by each kind of devices.  For the fsdax case, pmem device driver
implements it.  Pmem device driver will find out the filesystem in which
the corrupted page located in.

With dax_holder notify support, we are able to notify the memory failure
from pmem driver to upper layers.  If there is something not support in
the notify routine, memory_failure will fall back to the generic hanlder.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 drivers/nvdimm/pmem.c    | 11 +++++++++++
 include/linux/memremap.h |  9 +++++++++
 mm/memory-failure.c      | 14 ++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 72de88ff0d30..0dfafad8fcc5 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -362,9 +362,20 @@ static void pmem_release_disk(void *__pmem)
 	del_gendisk(pmem->disk);
 }
 
+static int pmem_pagemap_memory_failure(struct dev_pagemap *pgmap,
+		unsigned long pfn, size_t size, int flags)
+{
+	struct pmem_device *pmem =
+			container_of(pgmap, struct pmem_device, pgmap);
+	loff_t offset = PFN_PHYS(pfn) - pmem->phys_addr - pmem->data_offset;
+
+	return dax_holder_notify_failure(pmem->dax_dev, offset, size, flags);
+}
+
 static const struct dev_pagemap_ops fsdax_pagemap_ops = {
 	.kill			= pmem_pagemap_kill,
 	.cleanup		= pmem_pagemap_cleanup,
+	.memory_failure		= pmem_pagemap_memory_failure,
 };
 
 static int pmem_attach_disk(struct device *dev,
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index c0e9d35889e8..36d47bacd46d 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -87,6 +87,15 @@ struct dev_pagemap_ops {
 	 * the page back to a CPU accessible page.
 	 */
 	vm_fault_t (*migrate_to_ram)(struct vm_fault *vmf);
+
+	/*
+	 * Handle the memory failure happens on a range of pfns.  Notify the
+	 * processes who are using these pfns, and try to recover the data on
+	 * them if necessary.  The flag is finally passed to the recover
+	 * function through the whole notify routine.
+	 */
+	int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
+			      size_t size, int flags);
 };
 
 #define PGMAP_ALTMAP_VALID	(1 << 0)
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 8ff9b52823c0..85eab206b68f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1605,6 +1605,20 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	if (!pgmap_pfn_valid(pgmap, pfn))
 		goto out;
 
+	/*
+	 * Call driver's implementation to handle the memory failure, otherwise
+	 * fall back to generic handler.
+	 */
+	if (pgmap->ops->memory_failure) {
+		rc = pgmap->ops->memory_failure(pgmap, pfn, PAGE_SIZE, flags);
+		/*
+		 * Fall back to generic handler too if operation is not
+		 * supported inside the driver/device/filesystem.
+		 */
+		if (rc != EOPNOTSUPP)
+			goto out;
+	}
+
 	rc = mf_generic_kill_procs(pfn, flags, pgmap);
 out:
 	/* drop pgmap ref acquired in caller */
-- 
2.33.0



