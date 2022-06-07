Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7030628FB
	for <nvdimm@lists.linux.dev>; Tue,  7 Jun 2022 15:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654616272; x=1686152272;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Zq4qMj7BmV5+vvcmcNdpEc9+svzoU+Bzr9zO/b/QpeA=;
  b=QPrLqyy/QqRG7mK+Z11+CZ1j9Aw/19s/qkAIu6ZIYaS8QoBQwvc5nrA2
   KDiCjd2/hestvUj++moObm5PAW2j2NeEmm+oAzR9Rc8hiA6kSnDXvfeNG
   ZolYsuNmb+uhONmM9eUUexDWjhWQYTZNfH/yiL9YHaIcEqzIoytNPwMw5
   qFQFV2NKPdkizwxBaQAS0J4+kT0qza/f6UCQp9bE7nmxNRm9Ydp7wLhq4
   ZIyvJKHtzEao+tHIvmNsFAwjqIDr/lCdvejHHiLti+yEorqGkUx844biQ
   jDpDaOKcA4br48jBdsJxr8wTS7wWhnvHrFLeQx2iU5IlPEmiVp1ed9gZx
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="256562883"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="256562883"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 08:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="579645368"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 07 Jun 2022 08:37:49 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id 83A36109; Tue,  7 Jun 2022 18:37:52 +0300 (EEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] nvdimm/namespace: drop unneeded temporary variable in size_store()
Date: Tue,  7 Jun 2022 18:37:50 +0300
Message-Id: <20220607153750.33639-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor size_store() in order to remove temporary variable on stack
by joining conditionals.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nvdimm/namespace_devs.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 3dae17c90e8c..0f863fda56e6 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -836,7 +836,6 @@ static ssize_t size_store(struct device *dev,
 {
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 	unsigned long long val;
-	uuid_t **uuid = NULL;
 	int rc;
 
 	rc = kstrtoull(buf, 0, &val);
@@ -850,16 +849,12 @@ static ssize_t size_store(struct device *dev,
 	if (rc >= 0)
 		rc = nd_namespace_label_update(nd_region, dev);
 
-	if (is_namespace_pmem(dev)) {
+	/* setting size zero == 'delete namespace' */
+	if (rc == 0 && val == 0 && is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
-		uuid = &nspm->uuid;
-	}
-
-	if (rc == 0 && val == 0 && uuid) {
-		/* setting size zero == 'delete namespace' */
-		kfree(*uuid);
-		*uuid = NULL;
+		kfree(nspm->uuid);
+		nspm->uuid = NULL;
 	}
 
 	dev_dbg(dev, "%llx %s (%d)\n", val, rc < 0 ? "fail" : "success", rc);
-- 
2.35.1

