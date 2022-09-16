Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E19C20EA
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 03:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299379; x=1694835379;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qfzx5y9B9XHcY/WNGZvpd9adYJw1q+hyjxJ0sZQS8JA=;
  b=UWkDoIN58QLaf23iwgQ8TVrtWWEelnW4dSmu/4vTvrFoXXRZwHFfSH52
   cn8Jf0eRrUl5glbET2Lql6CVqkQ565f7+t8R8A0sNpjtHKDaXqX/1v3nR
   i+MP1i8uyZFh9lD6dv8fA+HizKoYillO90Iq2gnPDEsDf+0YrZm2Rdf/z
   3JikRJhiKBNfy+Vuo+CQ1yieMvV0TRSrgE9qeOp8z+0wNkDMBRiCuYBEC
   4uGMy/I4s0aqzlioI7jMLsI2l/hjdIIYsD9J/wVpE7bjbJ8SIQ+ZKV/3j
   ZTRjwTJsaoAFS1PMPLImxCqLXyiAodcfLZ5rsa7WMR2IZdzoqnA8zzmKb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="285943257"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="285943257"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:36:13 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="648099963"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:36:13 -0700
Subject: [PATCH v2 11/18] devdax: Minor warning fixups
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Date: Thu, 15 Sep 2022 20:36:13 -0700
Message-ID: <166329937313.2786261.6805174536617254263.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
References: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Fix a missing prototype warning for dev_dax_probe(), and fix
dax_holder() comment block format.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax-private.h |    1 +
 drivers/dax/super.c       |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 1c974b7caae6..202cafd836e8 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -87,6 +87,7 @@ static inline struct dax_mapping *to_dax_mapping(struct device *dev)
 }
 
 phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff, unsigned long size);
+int dev_dax_probe(struct dev_dax *dev_dax);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline bool dax_align_valid(unsigned long align)
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 9b5e2a5eb0ae..4909ad945a49 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -475,7 +475,7 @@ EXPORT_SYMBOL_GPL(put_dax);
 /**
  * dax_holder() - obtain the holder of a dax device
  * @dax_dev: a dax_device instance
-
+ *
  * Return: the holder's data which represents the holder if registered,
  * otherwize NULL.
  */

