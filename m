Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326231DED7A
	for <nvdimm@lists.linux.dev>; Mon,  7 Oct 2024 23:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343037; cv=none; b=SU6uoLTw5usimqx5jZ8dM86bxdOYW+t91yL/PlAO0v+aiA4Zqnawdw0cQ4wgfCEZSs17oefL2rFIiOcIYHbfzVj2qRsd9wm80LnbLMgaJqxSJu9Z/cTDAF6KgGaiptq0qmz8z2sIImw4uMLz/Fd04f6kD4y7ZVk4TK4lZAzUxiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343037; c=relaxed/simple;
	bh=5T9fYYkH+QE66nOJ/XDmqrgCNV5lOyJkK6gS3fdsJ9I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jR1HI0Y5QBYZdWPUNMP4JiCDYvMdF8JxldErh1RjJFGsuJJef0RFmVS5RhIdrWSNqrxF3bOqwVXiBUZw0pZNSghggEFZ4FV1zCD0WP+/F0tSVUM6WlctwQSOXbu+71SoJKjwjoCmL1HOofmQWMxR/wWyvT5wa1gwE8OZuJb+Mps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=avCIpmD6; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="avCIpmD6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728343035; x=1759879035;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=5T9fYYkH+QE66nOJ/XDmqrgCNV5lOyJkK6gS3fdsJ9I=;
  b=avCIpmD6AnNNkBqJD7fIGUiuEW3ANCEo/lYHYKbk59OZEJHhNP7L9xkT
   9lnAn/ObHr5+rJuMdLJrUE1AsUcNKyo28Mm4HYAlyjChbyHAMr5iAy5xY
   bAbW6/zgzMOhiVaSWJh5O1qz1bkStWqsHoesjOD5CGJLj+XCgnrKks9H8
   gZJ6sMNxgsqDREqMezdA35Kb1GNZDLJz3zuWYZ0RB2MC9hA7nThx9F2dV
   w8AxDxIaS9oV6XqhX0kfzRdSPPz7a5rNrQQedS4QbBH5aeG0QguINzv4/
   IZ+pUo/J8u6Mqrt/JzHcPPz6RkQnstPnwPUEhF9yQAIE5enoWBy5nkmrj
   A==;
X-CSE-ConnectionGUID: +m5XQuF/QVqfuLvkihtCuw==
X-CSE-MsgGUID: B5mQHCDfQ3u2iBUmiRYO8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="45036969"
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="45036969"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:17:04 -0700
X-CSE-ConnectionGUID: ydCewAnES/i9ESQqkhe9mw==
X-CSE-MsgGUID: u7QuGj/USnSk0EuW/GFe9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="75309164"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:17:02 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Mon, 07 Oct 2024 18:16:23 -0500
Subject: [PATCH v4 17/28] cxl/events: Split event msgnum configuration from
 irq setup
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241007-dcd-type2-upstream-v4-17-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org, 
 linux-doc@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=ed25519-sha256; t=1728342968; l=2746;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=5T9fYYkH+QE66nOJ/XDmqrgCNV5lOyJkK6gS3fdsJ9I=;
 b=ZpXXDhJfZpnl56KpYZebVeMti19Wd5x7Q4RjqpaSIq38yjleKrD1Lhz7I3BUmXbK4/N3BfyW2
 LQS2NStnLGbBhPDQInaV3iV1jSFxIzuADOkujs6v95Sc3lBoW9FmRMA
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Dynamic Capacity Devices (DCD) require event interrupts to process
memory addition or removal.  BIOS may have control over non-DCD event
processing.  DCD interrupt configuration needs to be separate from
memory event interrupt configuration.

Split cxl_event_config_msgnums() from irq setup in preparation for
separate DCD interrupts configuration.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/pci.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index fc5ab74448cc..29a863331bec 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -702,35 +702,31 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
 	return cxl_event_get_int_policy(mds, policy);
 }
 
-static int cxl_event_irqsetup(struct cxl_memdev_state *mds)
+static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
+			      struct cxl_event_interrupt_policy *policy)
 {
 	struct cxl_dev_state *cxlds = &mds->cxlds;
-	struct cxl_event_interrupt_policy policy;
 	int rc;
 
-	rc = cxl_event_config_msgnums(mds, &policy);
-	if (rc)
-		return rc;
-
-	rc = cxl_event_req_irq(cxlds, policy.info_settings);
+	rc = cxl_event_req_irq(cxlds, policy->info_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Info log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.warn_settings);
+	rc = cxl_event_req_irq(cxlds, policy->warn_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Warn log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.failure_settings);
+	rc = cxl_event_req_irq(cxlds, policy->failure_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Failure log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.fatal_settings);
+	rc = cxl_event_req_irq(cxlds, policy->fatal_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Fatal log\n");
 		return rc;
@@ -749,7 +745,7 @@ static bool cxl_event_int_is_fw(u8 setting)
 static int cxl_event_config(struct pci_host_bridge *host_bridge,
 			    struct cxl_memdev_state *mds, bool irq_avail)
 {
-	struct cxl_event_interrupt_policy policy;
+	struct cxl_event_interrupt_policy policy = { 0 };
 	int rc;
 
 	/*
@@ -777,11 +773,15 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 		return -EBUSY;
 	}
 
+	rc = cxl_event_config_msgnums(mds, &policy);
+	if (rc)
+		return rc;
+
 	rc = cxl_mem_alloc_event_buf(mds);
 	if (rc)
 		return rc;
 
-	rc = cxl_event_irqsetup(mds);
+	rc = cxl_event_irqsetup(mds, &policy);
 	if (rc)
 		return rc;
 

-- 
2.46.0

