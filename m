Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD7017D2
	for <nvdimm@lists.linux.dev>; Thu, 11 Aug 2022 01:30:13 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id f30so14887878pfq.4
        for <nvdimm@lists.linux.dev>; Wed, 10 Aug 2022 18:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=vgrt+f6C7vDMA7fP0gnoo9mRNdeDPoTHmnCHAuuEm/I=;
        b=cwilUqtZu1tCkta01u6M2Bfy2wfMstsvK8GvCsIhD8HAAMbuG3VkbCzscYWY9WQ+A1
         KdBgBL9I5wGd4sFcVQCCZrdpCbrpMUUQlMldagK1TepyH9skWEhyRivK+iUfghxg7C9u
         f1aAoIfYsF0ubHwIHHIVGcVgZjM4F2KQXW0Ofgy57y1uxvLSl0Eh6OdOkJNH9ZzjO16B
         Lm4ocKB9o7F4nc5lMHl4mtGaXurFfCf/QT/YwWdy+x4MmmRPKMBdSLGGMzOIe1dUVVMA
         I6+F2fk2ieIDnGDgauWHtiFW1A2JsrYJc7L7Y8n/YHqD3UT/64pBpZXJSfO/RRMTLNWB
         HfIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=vgrt+f6C7vDMA7fP0gnoo9mRNdeDPoTHmnCHAuuEm/I=;
        b=1O0D1d3ymu5oRWd7qqvIw/eYGCRp/YuB0qyPUAftJrE8arVZLCexDDUZ5qENKC6iVB
         EmbsG87MPdkoCXBBep9LDX47xxbwXJglBE7nqO4TiojrlJPEWtSraURa7WR1i5dxfYUb
         AY18DP+BbVqThda2wQr0lzPeYeLkKx9Wyo/A2OqgmRu48/pFnH3zC6mIlP8ge0CY4HMf
         XfEgsktMsIlZNMx6s3ljjpbIL/2cSlapJIarelLgptlMq4zs3yT9hNt/vb3otmmIKMUa
         OG4kk/djpukso7ReBIBDEXVzDl+/P6ygHl5JxVEPR8pFQN1hmTbFIG3kpGlYWj/5dqRr
         eR8A==
X-Gm-Message-State: ACgBeo2MARp/bn4ZWmvC3JThbiWvuUfj4Puzg6ydexVO03Mjlw9UdPZZ
	sgBvivEA+NiILTbpxQPBrao=
X-Google-Smtp-Source: AA6agR67dWQRktznGQutCEpJidj8BKQvvTvH36aC0hginqsmSTQSbNiBcT7dL8iENTZR8c3sEvhnXw==
X-Received: by 2002:a05:6a00:2289:b0:52f:9293:afec with SMTP id f9-20020a056a00228900b0052f9293afecmr11857468pfe.79.1660181412858;
        Wed, 10 Aug 2022 18:30:12 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g6-20020a170902c38600b0016d27cead72sm13516318plg.196.2022.08.10.18.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 18:30:12 -0700 (PDT)
From: cgel.zte@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To: dan.j.williams@intel.com,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	ye xingchen <ye.xingchen@zte.com.cn>,
	Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] nvdimm/region:Use the function kobj_to_dev()
Date: Thu, 11 Aug 2022 01:30:08 +0000
Message-Id: <20220811013008.15883-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ye xingchen <ye.xingchen@zte.com.cn>

Use kobj_to_dev() instead of open-coding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 drivers/nvdimm/region_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 473a71bbd9c9..8130a26dec32 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -721,7 +721,7 @@ REGION_MAPPING(31);
 
 static umode_t mapping_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct nd_region *nd_region = to_nd_region(dev);
 
 	if (n < nd_region->ndr_mappings)
-- 
2.25.1
