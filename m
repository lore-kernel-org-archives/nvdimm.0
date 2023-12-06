Received: from a8-18.smtp-out.amazonses.com (a8-18.smtp-out.amazonses.com [54.240.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D136C6EB64
	for <nvdimm@lists.linux.dev>; Wed,  6 Dec 2023 21:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="h/r7fKGw";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="UgfsXt6O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=rjayupzefgi7e6fmzxcxe4cv4arrjs35; d=jagalactic.com; t=1701896586;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=OCAlzX7SebA+j0HU4Sd7LjmJRCytQLzLNtjNPcYsg/M=;
	b=h/r7fKGwNyRQXQ/klZ0/fqeYYMmBzNl5n9mnuZL1ohKmcjySR0APw9WYzIRomCgm
	cvK++RoQJxfhIzH3u5eT+IMw3D3IcDf84JdaUMG1U5q2uDDALvgmvaDg6CPBYoT2gHK
	vQgc9fH23NGP5DuMD8LdntCcGHHIsnmCQCfF/XdI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1701896586;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=OCAlzX7SebA+j0HU4Sd7LjmJRCytQLzLNtjNPcYsg/M=;
	b=UgfsXt6Or2ojBf76Wxu+AjMwJLnevzWfnydHUHZV10RKwXRG8xZFAeT4f98ghuOO
	sZTChlvoCdJCkD9gWYrcZTnPHXFOZDoWVK1ey3FRvSdybHdgln6I4R5CAh8qfYanjMN
	GinrcGELwDU5KWuy10CRatFMrr5sUHnJOc04snqc=
Subject: [PATCH RFC 4/4] dev_dax_iomap: Add CONFIG_DEV_DAX_IOMAP kernel build
 parameter
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?Dan_Williams?= <dan.j.williams@intel.com>, 
	=?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?John_Groves?= <john@jagalactic.com>
Cc: =?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?nvdimm=40lists=2E?= =?UTF-8?Q?linux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40v?= =?UTF-8?Q?ger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Wed, 6 Dec 2023 21:03:06 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: <20231206210252.52107-1-john@jagalactic.com>
References: <20231206210252.52107-1-john@jagalactic.com> 
 <20231206210252.52107-5-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHaKIeW9Nsmb4x1TnOasHllAnJBRAAAASpN
Thread-Topic: [PATCH RFC 4/4] dev_dax_iomap: Add CONFIG_DEV_DAX_IOMAP kernel
 build parameter
X-Wm-Sent-Timestamp: 1701896584
X-Original-Mailer: git-send-email 2.39.3 (Apple Git-145)
Message-ID: <0100018c40f105c7-7e0d722c-4602-4956-8c3a-52f693e97e7c-000000@email.amazonses.com>
Feedback-ID: 1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2023.12.06-54.240.8.18

From: John Groves <john@groves.net>

Add CONFIG_DEV_DAXIOMAP kernel build parameter
---
 drivers/dax/Kconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index a88744244149..b1ebcc77120b 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -78,4 +78,10 @@ config DEV_DAX_KMEM
 
 	  Say N if unsure.
 
+config DEV_DAX_IOMAP
+       depends on DEV_DAX && DAX
+       def_bool y
+       help
+         Support iomap mapping of devdax devices (for FS-DAX file
+         systems that reside on character /dev/dax devices)
 endif
-- 
2.40.1

