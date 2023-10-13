Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D0D15E85
	for <nvdimm@lists.linux.dev>; Fri, 13 Oct 2023 12:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FmCuoofI"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-69361132a60so395603b3a.1
        for <nvdimm@lists.linux.dev>; Fri, 13 Oct 2023 05:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697199764; x=1697804564; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2zx15p0SmnRH09BE0u4PUAnqk7+Zw8rJ36gokTY/TP8=;
        b=FmCuoofISfYg5hgGOp27CKEC0N/B3ZAzRPRf+JV0rwA6iu7hx5wrfIxG7pyyGOQFqk
         kXPVhJpavfdr+ub8w6ELp4u8YTUIKWUq7mXqcwrvwq6tbKx2LkCb+3ndVUVbXxZE6ivV
         TaC1oLv5MKkPRJ7eXmCjqV3yUwac8yD96qJZV4ZeODPAwWBZMpuUSAujwvtHEeQKC+Cj
         zqsVwjuYe9u+wxYjzmXRiwsKnFCQUdhxU7sR8MTiypa0oGeC2ZnpSvinoLl2Oz2w0Off
         wO6YloYNCAwwK7uj/tEYhsgaXMZAkLvusmuWGlv7s+XmwO0jBj5klUKuXK0CU5ZJAHBP
         WrBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697199764; x=1697804564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2zx15p0SmnRH09BE0u4PUAnqk7+Zw8rJ36gokTY/TP8=;
        b=c58H9FnxVkonXh1fFocCbDSngrSIiQ8PQVGeXueWJPV7+dnWpX8tYUCMjxVcyaBCZa
         IF/JHU+v5bjwblDSUp2BNYvsn1FLSmSXFNSO7kEl/XHuWncI4zpDEklBgOfWJuDrEcnm
         jGdhNG+KAN6vQ82ou5CzTDWoWbCWfhIDzu2b3o0gaHZuLWf3xQO10qDPrVpYEJGNTbxc
         qM86eUWPbIuf2jrVUqnJVrx1U/etrOdeyTwc/QnnF9sn7jmNp1ixQzBoZGC/xFWglh1z
         zEdKgRawMESXDcx0DiuKYjZJ06cer79JLh8d+7jy6EWD2r39aBN3r3Vo0bD1LyMeacN3
         YJMw==
X-Gm-Message-State: AOJu0YxkU6Jv52TCLkzuwz19ePq/QP1LtGL1LAwFZ/h6gtkHdhO1S30R
	O/Wc5RmvPnYGzPpYRsgFCs0=
X-Google-Smtp-Source: AGHT+IGjkU4JcHIHWn7TBKy/+945CIIvrTtnhePZe+9GlhF00RheFqtdVD3cHO93AVyexdwWn60ibQ==
X-Received: by 2002:a05:6a20:4407:b0:133:6e3d:68cd with SMTP id ce7-20020a056a20440700b001336e3d68cdmr36263214pzb.3.1697199764020;
        Fri, 13 Oct 2023 05:22:44 -0700 (PDT)
Received: from localhost.localdomain ([140.116.154.65])
        by smtp.gmail.com with ESMTPSA id jd22-20020a170903261600b001bc930d4517sm3781802plb.42.2023.10.13.05.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Oct 2023 05:22:43 -0700 (PDT)
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
Subject: [PATCH v2] ACPI: NFIT: Optimize nfit_mem_cmp() for efficiency
Date: Fri, 13 Oct 2023 20:22:36 +0800
Message-Id: <20231013122236.2127269-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231012215903.2104652-1-visitorckw@gmail.com>
References: <20231012215903.2104652-1-visitorckw@gmail.com>
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
v1 -> v2:
- Add explicit type cast in case the sizes of u32 and int differ.

 drivers/acpi/nfit/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index f96bf32cd368..563a32eba888 100644
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
+	return (int)handleA - (int)handleB;
 }
 
 static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
-- 
2.25.1

