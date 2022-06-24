Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C60B28ED;
	Fri, 24 Jun 2022 04:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656044421; x=1687580421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LEnpiryl3EJtlzLZIRW5oeLAcKcKGsRDBy0eKrTmGME=;
  b=TQIecebyi3GOeh7KYwKOEgV8EwSZdWf/bCVV3Yl7f1XyDF2jfcb67jx/
   PiwcrYciLXr/5q7qYgQu5BKegmmhXFo8rXqsdtOqGWhWLMkqrQpXfP/PU
   +L25/n2EkTkKSgPoqqy4Phyj+Q2BwMBOnV851IankwESylrHnE9QjkpCF
   WoQBRcTgb1iCAOZo7lix0UWmOB6ypAC2Chl+5RqcjZxIe1LPtM145zXgt
   Jg+AHnqEwRVAcVQ5EmCh3KAvJzuhfY0nFYp+Tc5iF8xBlSJZoJNZ5f7B2
   xBsO6h83eAGBvwwyh7EjBkHjbEFUTBn7ys+d7U3UgjTxcL3g5bmsfUxgi
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344912824"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="344912824"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:16 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="645092965"
Received: from daharell-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.intel.com) ([10.209.66.176])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:15 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org,
	patches@lists.linux.dev,
	hch@lst.de,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 44/46] cxl/pmem: Delete unused nvdimm attribute
Date: Thu, 23 Jun 2022 21:19:48 -0700
Message-Id: <20220624041950.559155-19-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While there is a need to go from a LIBNVDIMM 'struct nvdimm' to a CXL
'struct cxl_nvdimm', there is no use case to go the other direction.
Likely this is a leftover from an early version of the referenced commit
before it implemented devm for releasing the created nvdimm.

Fixes: 21083f51521f ("cxl/pmem: Register 'pmem' / cxl_nvdimm devices")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/cxl.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 734b4479feb2..d6ff6337aa49 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -411,7 +411,6 @@ struct cxl_nvdimm_bridge {
 struct cxl_nvdimm {
 	struct device dev;
 	struct cxl_memdev *cxlmd;
-	struct nvdimm *nvdimm;
 };
 
 /**
-- 
2.36.1

