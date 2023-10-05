Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADD026E20
	for <nvdimm@lists.linux.dev>; Thu,  5 Oct 2023 13:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ybBCb8L6"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-307d58b3efbso939428f8f.0
        for <nvdimm@lists.linux.dev>; Thu, 05 Oct 2023 06:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696514331; x=1697119131; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wn6Em+o0gkIpmb/ObfPSgCvA3m73Mu1ZDj4fK+nToG4=;
        b=ybBCb8L6xBFocI5z9PZEpxCvEbKntG35TtfcB6REpHiRC2iyFv9SZRw1TJnLZVDG8p
         T2Sx3hf3p/Xxc0s9vvosWVuKlluuN0CB+/DxgNBmgMWZlinUPf3v0jBbVs2GjflJPaCK
         tryq7sydmKfNMnbmWAiDWZETgYRJ8/n9Sxgq5hc0QfVezkknAEvmsapA5g5DpUMreuzx
         L0OYAZDOOSq68m6z2m6hU0dqhaSr1wdlKK1rm80e1W5oK9DHxlDKnqd6hWMgCUWf7Bm6
         qoUjPevn/k7RqxULc0fH9iJS2mG60Piv15bJqy4KZP8gAo7k7/nmu38c5meM+jNT+gFj
         kFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696514331; x=1697119131;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wn6Em+o0gkIpmb/ObfPSgCvA3m73Mu1ZDj4fK+nToG4=;
        b=LyCnV+KyMeVDfXA5BPGZMb5vmHC34+4rzSfOUmDdl9Es//tUcOjU+i7MegtVMTytw3
         jT9R9LlIrG4yKRsa90mL1ehIbeTeo/Q4p4fgZpRfA+pbPInA2ASPxyqGT8sXtDORtF/A
         clMRxbmUb5TwEJrd4rLP3GgRsRLCEcMt3W+7swvQ5kSplEx7pe6YmHOr7lxFL3u3NYFn
         yrX0L1WSa0tWmw1J5WQSwLRAYhAx8G89mjzXIUw0kMDuO1g/LhO0IcupbRqdCmpfCYez
         fHZ7fTnzX+Qcbdo/V5GU2Z/lpaTuxOpzOrB5D1J2EW/U0Uv0b4BwQ4TweTill/pluknN
         ZUDQ==
X-Gm-Message-State: AOJu0Yz7QMJQ60Gffvph6JjiSv13tdiX+MapSQkCEQfhxzmao1aWYo3u
	bp/+HNxmI8ZxM7wI7ffiK+sj4g==
X-Google-Smtp-Source: AGHT+IEm8BURx2Ll1byyK8uUf5yHWTqN0Cz1KB7q4EUDkoypWK0U6H3oDODp3tRIwZmxWiHDt38ZpA==
X-Received: by 2002:adf:e406:0:b0:31a:e6c2:7705 with SMTP id g6-20020adfe406000000b0031ae6c27705mr4615866wrm.50.1696514331718;
        Thu, 05 Oct 2023 06:58:51 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id v11-20020adfedcb000000b0031fd849e797sm1845899wro.105.2023.10.05.06.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 06:58:51 -0700 (PDT)
Date: Thu, 5 Oct 2023 16:58:48 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] dax: remove unnecessary check
Message-ID: <554b10f3-dbd5-46a2-8d98-9b3ecaf9465a@moroto.mountain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

We know that "rc" is zero so there is no need to check.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/dax/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1d818401103b..ea7298d8da99 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1300,7 +1300,7 @@ static ssize_t memmap_on_memory_store(struct device *dev,
 	dev_dax->memmap_on_memory = val;
 
 	device_unlock(dax_region->dev);
-	return rc == 0 ? len : rc;
+	return len;
 }
 static DEVICE_ATTR_RW(memmap_on_memory);
 
-- 
2.39.2

