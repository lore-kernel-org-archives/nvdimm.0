Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D4D3FB09
	for <nvdimm@lists.linux.dev>; Thu, 12 Oct 2023 21:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DJVwZh6F"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1c746bc3bceso3979795ad.1
        for <nvdimm@lists.linux.dev>; Thu, 12 Oct 2023 14:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697147951; x=1697752751; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2bRmsNjujjr87IHjRkMLVF3EP+IER+0qQMW+fpMjLQg=;
        b=DJVwZh6FUe7rN28N0PMDCvjR+NXVJflcbL0kS8QA8t+LczrL7Tpag5ygRpqFtfLhzo
         dPNnkeEilr5oC2yK+oCy46f1PgxTKQhg++f2U6uaAh/dPqrO6UMK5uZPRLZTW0eVUim+
         kyYte5HmLS9LURbQf0yEXdqeX0x7fFbl+usNUKP0gjGxzNBV8LAO0tN1fVS57yWGMcZd
         oqObXfckV+wikicu7ozMRQc2JEMAPLuqxvpaVQDE/5b6WiTibjQBh+EzKWndpM8pLcL8
         viwcqTOQjaxdV/5qJ9u1r8FLJC1VFnVMgVsC7h8LCFaweS06mEjAeryOn9BESxtKDdjX
         eiRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697147951; x=1697752751;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2bRmsNjujjr87IHjRkMLVF3EP+IER+0qQMW+fpMjLQg=;
        b=pUP8/J0yYDWfi2zD7weZG3hhWa9qW/6UztTlz9jDCdZ2BQVlPSchQ++sF//8t37b0L
         4nXTtMFF+CGok0Z2I06C0PBQzYXxK1I0O1no97SILIfjQESSYNadmUQEnm4og0T/aUnr
         5s1tMjEvMjEfiEdzp4IGPsdfbQ4qybf+iCv5+zFzysl4I26uToKwxAr0FG2OrxC7okqC
         wNUZYZfW0RHH7uY19f+y6RV4GeJXq/TPPi7n6UeXrWlNBH+089W7PVUF+zQlBCFmRkU4
         gAgr0Z4e6FkIoWTUQqGJ4MkXaXjV2KFfw/HbqfB+AIlRTDIIovMephrF+4Jl3ZupqJ/w
         p2uA==
X-Gm-Message-State: AOJu0Yzb9bZUCAaRvn+lJir8vyKyRItGRcxxqrfvQfq96X53or/WOgcr
	VKdYi6L4Sm3t6Q8KjYkF1DI=
X-Google-Smtp-Source: AGHT+IEJ5AnfE0+n1T0JHCM+RVwVG1qkIZvLRGfH9TlJVR5npNnpa4dd1sYhMzJW9LCyM0so1ZGDLw==
X-Received: by 2002:a17:90a:9f83:b0:27c:fbf8:6c43 with SMTP id o3-20020a17090a9f8300b0027cfbf86c43mr7314082pjp.1.1697147950948;
        Thu, 12 Oct 2023 14:59:10 -0700 (PDT)
Received: from localhost.localdomain ([140.116.154.65])
        by smtp.gmail.com with ESMTPSA id 5-20020a17090a198500b0027768125e24sm2489295pji.39.2023.10.12.14.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 14:59:10 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Cc: rafael@kernel.org,
	lenb@kernel.org,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH] ACPI: NFIT: Optimize nfit_mem_cmp() for efficiency
Date: Fri, 13 Oct 2023 05:59:03 +0800
Message-Id: <20231012215903.2104652-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The original code used conditional branching in the nfit_mem_cmp
function to compare two values and return -1, 1, or 0 based on the
result. However, the list_sort comparison function only needs results
<0, >0, or =0. This patch optimizes the code to make the comparison
branchless, improving efficiency and reducing code size. This change
reduces the number of comparison operations from 1-2 to a single
subtraction operation, thereby saving the number of instructions.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 drivers/acpi/nfit/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index f96bf32cd368..eea827d9af08 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1138,11 +1138,7 @@ static int nfit_mem_cmp(void *priv, const struct list_head *_a,
 
 	handleA = __to_nfit_memdev(a)->device_handle;
 	handleB = __to_nfit_memdev(b)->device_handle;
-	if (handleA < handleB)
-		return -1;
-	else if (handleA > handleB)
-		return 1;
-	return 0;
+	return handleA - handleB;
 }
 
 static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
-- 
2.25.1

