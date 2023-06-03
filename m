Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60FA847F
	for <nvdimm@lists.linux.dev>; Sat,  3 Jun 2023 06:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685772840; x=1717308840;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FZ29ASs5+8CWYl1hUfDTQ0pBL9/BQYO8+XxZeO/2ZBY=;
  b=JHIE7DmTI0RcoKMP4/HmMOa7iDsdHs/+moOBEzJNVbvU1Bbj51uo2ncJ
   H8bhPUl9fP1KRKWgzqHdyolp6YKWD8H9RGVcs/I3RjbZUoI0A8oCVT6ZO
   thLAU4eDMy4fXyhC9ahDhT5fcAQRmsbOFXCQlwE5gjmHrOGgP+yrZ0r/c
   FPg6bF0hcBzOx/ct5ZqpKk78kuOX8xwqa/X39Ej5Ts7wcXvT5Zxy6cX0j
   IIyGUpZHEIlvJsj4HmqNtcvkv1h7ussNqJ1nK9eT3LCBSfS52FQQ1f4bI
   Fsc5aW4DuGM/pSlASOZU0FcswXv7JFpe4p+RUjcch/+QlXZBkwW/ZcGUv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="442417606"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="442417606"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 23:14:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="711211566"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="711211566"
Received: from rjkoval-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.230.247])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 23:14:00 -0700
Subject: [PATCH 2/4] dax: Use device_unregister() in unregister_dax_mapping()
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
Date: Fri, 02 Jun 2023 23:13:59 -0700
Message-ID: <168577283989.1672036.7777592498865470652.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Replace an open-coded device_unregister() sequence with the helper.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/bus.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index aee695f86b44..c99ea08aafc3 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -657,8 +657,7 @@ static void unregister_dax_mapping(void *data)
 	dev_dax->ranges[mapping->range_id].mapping = NULL;
 	mapping->range_id = -1;
 
-	device_del(dev);
-	put_device(dev);
+	device_unregister(dev);
 }
 
 static struct dev_dax_range *get_dax_range(struct device *dev)

