Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE211C27
	for <nvdimm@lists.linux.dev>; Sat,  3 Jun 2023 02:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685758171; x=1717294171;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=+pAIGJKvRh7qS+esVik2IqS8poW9McX9jF5Ma8+7Pj8=;
  b=Qz6Ws4X/6Cyurx2wvz/IQ4QmPjC0EnXvA/1bXkQx4XFYCqvVhbpLGRU0
   RN9v9Xc69SzVXfEK+65BrpBCiWK1HGnIdGR49lVhL/sby5A3Kfwiq20KD
   NqvOY3FZ2zHxC3T5mltuX/EwKWVw+JMZJ67hFx7cMoh5c+EiwGEUhkQQq
   /c8vrpYQaYmVycqu5b8s8tO/Gr9FJ0Z9H4A6CrRPfxH76XaTm7w/ADV69
   8RP7htmsofA4ELrYwr0dq514HbaQEwAf8uwXxjKW9p+vyoSQnsCf0Q6y7
   qc3VhBRbRGqfpFjX5xSNyIG99rB+hsAa11BbsSol22TAAZ7dZ4Hahtgvr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="340649437"
X-IronPort-AV: E=Sophos;i="6.00,214,1681196400"; 
   d="scan'208";a="340649437"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 19:09:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="852354411"
X-IronPort-AV: E=Sophos;i="6.00,214,1681196400"; 
   d="scan'208";a="852354411"
Received: from iweiny-mobl.amr.corp.intel.com (HELO localhost) ([10.212.97.230])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 19:09:29 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Fri, 02 Jun 2023 19:09:21 -0700
Subject: [PATCH RFC 1/4] dax/bus: Fix leaked reference in
 alloc_dax_region()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230602-dax-region-put-v1-1-d8668f335d45@intel.com>
References: <20230602-dax-region-put-v1-0-d8668f335d45@intel.com>
In-Reply-To: <20230602-dax-region-put-v1-0-d8668f335d45@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Joao Martins <joao.m.martins@oracle.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>, 
 Paul Cassella <cassella@hpe.com>, linux-kernel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.13-dev-9a8cd
X-Developer-Signature: v=1; a=ed25519-sha256; t=1685758165; l=1545;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=+pAIGJKvRh7qS+esVik2IqS8poW9McX9jF5Ma8+7Pj8=;
 b=23++xNTRjcMP4T5vDFqSFZUyo1YkZSoemfUGTjIUMhcqbFSXmYr5cAd6MW2Wr6cszXEqh1tkf
 NkYUKeFaToRARLPp8vO6Zk8hwWlXeXg+vJ7nCwlHcCYJKPsUiD/qPNW
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

kref_init() initializes the ref count to 1.  An extra kref is taken on
the dax_region to be used by the caller.  If devm_add_action_or_reset()
fails this extra reference is leaked.

Drop the extra reference on error.

Fixes: d7fe1a67f658 ("dax: add region 'id', 'size', and 'align' attributes")
Cc: Dan Williams <dan.j.williams@intel.com
Suggested-by: Paul Cassella <cassella@hpe.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/dax/bus.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 227800053309..899e29d107b4 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -583,6 +583,7 @@ static void dax_region_unregister(void *region)
 	dax_region_put(dax_region);
 }
 
+/* The dax_region reference returned should be dropped with dax_region_put() */
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct range *range, int target_node, unsigned int align,
 		unsigned long flags)
@@ -625,9 +626,13 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		return NULL;
 	}
 
+	/* Hold a reference to return to the caller */
 	kref_get(&dax_region->kref);
-	if (devm_add_action_or_reset(parent, dax_region_unregister, dax_region))
+	if (devm_add_action_or_reset(parent, dax_region_unregister,
+				     dax_region)) {
+		kref_put(&dax_region->kref, dax_region_free);
 		return NULL;
+	}
 	return dax_region;
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);

-- 
2.40.0

