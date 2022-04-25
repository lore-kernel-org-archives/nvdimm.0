Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAD27E
	for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 10:56:15 +0000 (UTC)
Received: by mail-qk1-f172.google.com with SMTP id d198so10422413qkc.12
        for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 03:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oDOO1VMKAFSvRA+jbY7XrQpvEA7oAfz0Z+1NK5bO8FY=;
        b=KJv8igdiiZufNLVMSZZt2ISU+Ufbg4Y5Wc23m64y3yHYylsk1aSmkpHZEMSSWlATOM
         7YmTFBoMEurJd3ZCoqvMos0FO1E7htItiRpACDs/fc3t8ymL4m2T6Iwfvna33QX2kp8l
         wiR3wqc7xaD6VXY1knNCL5/T5X8kpj5ldDmGDwiw5btgHuXsaUqiHnB3bohg7kpWIu6s
         vBERqsW6/nhYrzIhiOiLIG2NMJZUkjJ6J27c7B4GSOzagtvopS4otR5wyX90Ybq10TYa
         Zv83lqtpNPsyVgHdhrjPT2b7hcMbAQKpZSugd7lS3gc+VYdrx3NZSnC+g2zI3ewNGMLb
         zwuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oDOO1VMKAFSvRA+jbY7XrQpvEA7oAfz0Z+1NK5bO8FY=;
        b=29ZcP0pxLaj3pu++CJ2LeSzISkMzAubOLEYRIQ6hMPZVgtqciceQsEmXhYdBU0frb+
         raJopS2V7Kymuta43WOHmKLsoxYeXsyLd9cYlNqE9Pcv4uFsoFl94/t2ofF/kXGBUMzQ
         tIyk6KdWDoEQLuOt1ZBvTT7U5QWxcYGP/v76vvXOyZY4Zhd5CB8SxpJRKBaJwqNl5dVW
         5A1/V3ETJXAz4TqNvcEwPGhcAiu64+r1+trAo3NIOz9xNPOOY/CnSkfuB15YoUgxRoum
         A957rCDB5vWyciXFfm1HwYHumhJMAI0y8QyLW4qOzOQu8N0EqmX2xNLrmkgOvaY8YRis
         e13g==
X-Gm-Message-State: AOAM530bBjEs0K8XT1BGTfMgYWP0VQoogSUnAKpdGH7JkkTfcVrtqii2
	TFfKgb4PHVE6qYhWbD+wtFZnEk1vw7Q=
X-Google-Smtp-Source: ABdhPJwKYoo+D+f18HGcHSdbt3nOkwr+JitifQR9BtifSH2hLs5zSHXuEoBrb3IEnL05jkz7fvBhHw==
X-Received: by 2002:a05:620a:408e:b0:69f:5b92:8356 with SMTP id f14-20020a05620a408e00b0069f5b928356mr2206864qko.562.1650884173222;
        Mon, 25 Apr 2022 03:56:13 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id r7-20020a05622a034700b002f337000725sm5870146qtw.42.2022.04.25.03.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 03:56:12 -0700 (PDT)
From: cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Minghao Chi <chi.minghao@zte.com.cn>,
	Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] ndtest: use kobj_to_dev()
Date: Mon, 25 Apr 2022 10:56:07 +0000
Message-Id: <20220425105607.3515999-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Minghao Chi <chi.minghao@zte.com.cn>

Use kobj_to_dev() instead of open-coding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 tools/testing/nvdimm/test/ndtest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 4d1a947367f9..b32ee76e0c17 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -725,7 +725,7 @@ static DEVICE_ATTR_RO(format1);
 static umode_t ndtest_nvdimm_attr_visible(struct kobject *kobj,
 					struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 	struct ndtest_dimm *dimm = nvdimm_provider_data(nvdimm);
 
-- 
2.25.1


