Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2082CA3
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984301; x=1674520301;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EqVKQ5U04jbeKgEnG55nQ7byEl0Rvm9oJ+OQpJT8NmA=;
  b=itQUYDKsTOS89Y/Oye9e4usRVU5nkO8rRW3MLETtN+o6/2hOd+EEv1m0
   KopZhVO9U4ykVxHHR1ZMcbfHwHWr+IPTkKT9zJsInhk+dRP73RjFz79o1
   JZm0ol7Ga+xNLvINdqCOnmRtJcfl+mHz1Mspu9sHg7SZLg8OO3Ph0uRRt
   zaeFIBatKYyli5D/wWcZ9slOf8AmQYKiNJihDFOe18sDGt5dnI1SnmlnN
   45KjCZeHBo656UzF23EqvskFIsu2oGfeDb5BiW85zHzYHSHwckU0dpAWQ
   zlAyX3K8DkdY2QnAouRY9kOU2XZDTJlP8H05RgMcUWwlXw3wfz2w2qpSi
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="246151774"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="246151774"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:31:41 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="695240397"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:31:41 -0800
Subject: [PATCH v3 34/40] cxl/core: Move target_list out of base decoder
 attributes
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:31:41 -0800
Message-ID: <164298430100.3018233.4715072508880290970.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for introducing endpoint decoder objects, move the
target_list attribute out of the common set since it has no meaning for
endpoint decoders.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/port.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 13027fc2441d..39ce0fa7b285 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -186,7 +186,6 @@ static struct attribute *cxl_decoder_base_attrs[] = {
 	&dev_attr_start.attr,
 	&dev_attr_size.attr,
 	&dev_attr_locked.attr,
-	&dev_attr_target_list.attr,
 	NULL,
 };
 
@@ -199,6 +198,7 @@ static struct attribute *cxl_decoder_root_attrs[] = {
 	&dev_attr_cap_ram.attr,
 	&dev_attr_cap_type2.attr,
 	&dev_attr_cap_type3.attr,
+	&dev_attr_target_list.attr,
 	NULL,
 };
 
@@ -215,6 +215,7 @@ static const struct attribute_group *cxl_decoder_root_attribute_groups[] = {
 
 static struct attribute *cxl_decoder_switch_attrs[] = {
 	&dev_attr_target_type.attr,
+	&dev_attr_target_list.attr,
 	NULL,
 };
 

