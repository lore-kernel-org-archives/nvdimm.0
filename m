Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF39E8462;
	Thu, 23 Apr 2026 00:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776903005; cv=none; b=RJjOyHMndnpNSPi8gkyHfQ933HE/rLD7feMLOGsjHZSiiMLNKptDdt25/ZWlqRo5qANEPQd8gILKdPSLxVaW/smOq/RoMGvm41dYWz8mH+fNA+AeT377KG3cJ8whSSY97rJh5lJSg7ZBVwO6oL0hLgCmDLh2UqSTIyPjozpQtt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776903005; c=relaxed/simple;
	bh=vuS7CvfIXFhj658WHe5NKyP4jNxVaWHosXgn3eZ89UY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pPDRbiE2fKWW9avgiOQsP7UXp4mA80JXG+9zBtc6H+G3K+91V/FwOpblr4Lq1M8U3CYyGSVvUE5nAciHVYpvlI8+u2177jHifbNu9QnUb+XIKpzYHiBXsTcDm6WbA7n8jkGHI/RUjGP/wP/iPtz4QO5mo04VERJsSg608EAKseU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84050C19425;
	Thu, 23 Apr 2026 00:10:05 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: alison.schofield@intel.com,
	ira.weiny@intel.com,
	djbw@kernel.org
Subject: [PATCH] MAINTAINERS: Add maintainer info for libnvdimm and DAX
Date: Wed, 22 Apr 2026 17:10:03 -0700
Message-ID: <20260423001003.2887295-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Alison Schofield to libnvdimm and DAX maintainer.

Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Ira Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <djbw@kernel.org>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 MAINTAINERS | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c9b7b6f9828e..6c16f7b22349 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7298,6 +7298,7 @@ DEVICE DIRECT ACCESS (DAX)
 M:	Dan Williams <djbw@kernel.org>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
+M:	Alison Schofield <alison.schofield@intel.com>
 L:	nvdimm@lists.linux.dev
 L:	linux-cxl@vger.kernel.org
 S:	Supported
@@ -14683,6 +14684,7 @@ LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dan Williams <djbw@kernel.org>
 M:	Dave Jiang <dave.jiang@intel.com>
+M:	Alison Schofield <alison.schofield@intel.com>
 L:	nvdimm@lists.linux.dev
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
@@ -14693,6 +14695,7 @@ LIBNVDIMM PMEM: PERSISTENT MEMORY DRIVER
 M:	Dan Williams <djbw@kernel.org>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
+M:	Alison Schofield <alison.schofield@intel.com>
 L:	nvdimm@lists.linux.dev
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
@@ -14712,6 +14715,7 @@ M:	Dan Williams <djbw@kernel.org>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Ira Weiny <ira.weiny@intel.com>
+M:	Alison Schofield <alison.schofield@intel.com>
 L:	nvdimm@lists.linux.dev
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/

base-commit: 2e68039281932e6dc37718a1ea7cbb8e2cda42e6
-- 
2.53.0

