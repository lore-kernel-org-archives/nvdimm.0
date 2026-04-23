Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E6034887E;
	Thu, 23 Apr 2026 17:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963754; cv=none; b=C0M3IWsRZCXfAtM99WNJaLUl0QmsBX12Ckvn5KCkWvEG+a6Ww+UtAL/1DfyDkQa8vDf8/oBfdibE4zVuHxQPNuv/rDFNC4Zja7NR/72y2jnVaoAGZjbrAcFnMg5RMkyS4jfpe7tnTRz/1HM4DYKQ1LMr7irM+qnYjKFPvrZKpU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963754; c=relaxed/simple;
	bh=FA9kNMH2b29WOFUXBgDtPsfQzdr1Len/4S78YdL440M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCto4kxs3IG2kEA2pjGtlJu8+hlmx7psJsTzbKDr/nlY0Zb2cXGlDcG4+Hhts/+E32epJIOG0HWhVerqWC5yjZZ2NyPPSTqQD19E/hlCvCJfSW8eQizU9fDk3bTZw3yL+wYzVTquuI/ueVGcg21jV2TYDiK9WHulvH2wlWV/ZJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306D8C2BCAF;
	Thu, 23 Apr 2026 17:02:34 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: djbw@kernel.org,
	iweiny@kernel.org,
	pasha.tatashin@soleen.com,
	mclapinski@google.com,
	rppt@kernel.org,
	joao.m.martins@oracle.com,
	jic23@kernel.org,
	gourry@gourry.net,
	john@groves.net,
	rick.p.edgecombe@intel.com
Subject: [RFC PATCH 09/12] dax: Add dax_get_dev_dax() helper function
Date: Thu, 23 Apr 2026 10:02:16 -0700
Message-ID: <20260423170219.281618-10-dave.jiang@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423170219.281618-1-dave.jiang@intel.com>
References: <20260423170219.281618-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For callers that need to get the dev_dax struct from a dax_device in
order to call DAX APIs, add a dax_get_dev_dax() helper.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/bus.c   | 6 ++++++
 include/linux/dax.h | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 759163722e4c..a99db3739e45 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1515,6 +1515,12 @@ static int dev_dax_zero_page_range(struct dax_device *dax_dev,
 	return 0;
 }
 
+struct dax_device *dax_get_dev_dax(struct dev_dax *dev_dax)
+{
+	return dev_dax->dax_dev;
+}
+EXPORT_SYMBOL_GPL(dax_get_dev_dax);
+
 static long dev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 				  long nr_pages, enum dax_access_mode mode,
 				  void **kaddr, unsigned long *pfn)
diff --git a/include/linux/dax.h b/include/linux/dax.h
index a5e1a3ca1a0d..da1413c8a21f 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -62,6 +62,9 @@ void set_dax_nomc(struct dax_device *dax_dev);
 void set_dax_synchronous(struct dax_device *dax_dev);
 size_t dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i);
+struct dev_dax;
+struct dax_device *dax_get_dev_dax(struct dev_dax *dev_dax);
+
 /*
  * Check if given mapping is supported by the file / underlying device.
  */
@@ -122,6 +125,10 @@ static inline size_t dax_recovery_write(struct dax_device *dax_dev,
 {
 	return 0;
 }
+static inline struct dax_device *dax_get_dev_dax(struct dev_dax *dev_dax)
+{
+	return NULL;
+}
 #endif
 
 struct writeback_control;
-- 
2.53.0

