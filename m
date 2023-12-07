Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE474F8B5
	for <nvdimm@lists.linux.dev>; Thu,  7 Dec 2023 21:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0yeJZBhF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hL5xjtU3PgLOkzLLg6qbcOrjWytwsj2hMsOpXV2FUmM=; b=0yeJZBhFkG8ngQQvMfVExW/jp8
	SeFkdvbr8W4FQ7BKuXRv0C7BcVS518cWcbaC7GwkLXIGo6LUcN84BAGzZVRiAvjfzd0DP/8B95vY3
	1bkW1L2UddS8fVrYuRl0eH1QsYsJQOZGKm0Ne9CSNuIvO+KqWNIid/IfWy6y8dXS9ht9wXFuRvI06
	lInAStxFQV/QRK8JEFQuivvfywPfAtSfHGUolM/cIxnhrgkBIeLvB4lNE/RDB/7nEt9QJBdFi84Iz
	0GxI8e0gPw2WcrvV3yU+NBDTdE8oAfPp2ShyWwe0Q6VK/3C2hImatmEoQEdPcXhQbHhJMQZ0n87Vj
	y+9zlfQw==;
Received: from [50.53.46.231] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rBLZ6-00Duw1-1E;
	Thu, 07 Dec 2023 21:05:48 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH 3/3] nvdimm/namespace: fix kernel-doc for function params
Date: Thu,  7 Dec 2023 13:05:45 -0800
Message-ID: <20231207210545.24056-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231207210545.24056-1-rdunlap@infradead.org>
References: <20231207210545.24056-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adjust kernel-doc notation to prevent warnings when using -Wall.

namespace_devs.c:76: warning: No description found for return value of 'nd_is_uuid_unique'
namespace_devs.c:343: warning: No description found for return value of 'shrink_dpa_allocation'
namespace_devs.c:668: warning: No description found for return value of 'grow_dpa_allocation'
namespace_devs.c:958: warning: No description found for return value of 'namespace_update_uuid'
namespace_devs.c:1665: warning: Function parameter or member 'nd_mapping' not described in 'create_namespace_pmem'
namespace_devs.c:1665: warning: Excess function parameter 'nspm' description in 'create_namespace_pmem'
namespace_devs.c:1665: warning: No description found for return value of 'create_namespace_pmem'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev
---
 drivers/nvdimm/namespace_devs.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -- a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -71,6 +71,8 @@ static int is_namespace_uuid_busy(struct
  * nd_is_uuid_unique - verify that no other namespace has @uuid
  * @dev: any device on a nvdimm_bus
  * @uuid: uuid to check
+ *
+ * Returns: %true if the uuid is unique, %false if not
  */
 bool nd_is_uuid_unique(struct device *dev, uuid_t *uuid)
 {
@@ -337,6 +339,8 @@ static int scan_free(struct nd_region *n
  * adjust_resource() the allocation to @n, but if @n is larger than the
  * allocation delete it and find the 'new' last allocation in the label
  * set.
+ *
+ * Returns: %0 on success on -errno on error
  */
 static int shrink_dpa_allocation(struct nd_region *nd_region,
 		struct nd_label_id *label_id, resource_size_t n)
@@ -662,6 +666,8 @@ void release_free_pmem(struct nvdimm_bus
  * allocations from the start of an interleave set and end at the first
  * BLK allocation or the end of the interleave set, whichever comes
  * first.
+ *
+ * Returns: %0 on success on -errno on error
  */
 static int grow_dpa_allocation(struct nd_region *nd_region,
 		struct nd_label_id *label_id, resource_size_t n)
@@ -951,6 +957,8 @@ static ssize_t uuid_show(struct device *
  * @dev: namespace type for generating label_id
  * @new_uuid: incoming uuid
  * @old_uuid: reference to the uuid storage location in the namespace object
+ *
+ * Returns: %0 on success on -errno on error
  */
 static int namespace_update_uuid(struct nd_region *nd_region,
 				 struct device *dev, uuid_t *new_uuid,
@@ -1656,8 +1664,10 @@ static int select_pmem_id(struct nd_regi
 /**
  * create_namespace_pmem - validate interleave set labelling, retrieve label0
  * @nd_region: region with mappings to validate
- * @nspm: target namespace to create
+ * @nd_mapping: container of dpa-resource-root + labels
  * @nd_label: target pmem namespace label to evaluate
+ *
+ * Returns: the created &struct device on success or -errno on error
  */
 static struct device *create_namespace_pmem(struct nd_region *nd_region,
 					    struct nd_mapping *nd_mapping,
