Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1C517D2
	for <nvdimm@lists.linux.dev>; Thu, 11 Aug 2022 01:31:11 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id f65so15862483pgc.12
        for <nvdimm@lists.linux.dev>; Wed, 10 Aug 2022 18:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=H/UbhZCA4vtX3WV2ns3tNyJm9u7rXeCUnbxwgbwS87E=;
        b=aZnBkTJ4qhQZ8MUJC2G8I+SKtxDgbskAJHDh/lPAnWiMVa+z3G8zmbuufrWCjebTUw
         rFlg9pnnz9c+V5DWJai+AwRHe0xw/c88aWdbtoEGeUBxSellpxFi6N92X4+oUeY4ZFeA
         4Vlpe0kJnNxWzWAyu5fKmRSI+aEOWBElY5zviy/Vf+B94QLJ9QK7Mor6mK8bBVTCpYiA
         d3FUF6lG1sdbPMv29EWV7ZReRegig5c+ZXyeqYjl1CP9b/TVUWGj+Skfmyi9RaY2Pj6h
         oVBshdGsGqOSt43y33WDEKYHYOfGd/RX1d+Rb2+r/qQSGZIYHhNOmEjtrA7uZ5WWH5ij
         1phg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=H/UbhZCA4vtX3WV2ns3tNyJm9u7rXeCUnbxwgbwS87E=;
        b=z6C5iekUDekFzP8WRZMyUFttS/dLbIiZsp7RWe7GqgBiRTdVeYd1kUcQCaLQiKTJeB
         6SLCftW770IpLMGfc/5cWVvApgBd2TO9mOib9zs0nXP4NbCi9H5WZ9MMWbx4nB82+ssa
         jBLbyJ/+p3rz66WdlsaJKR9WKKCnsrKyhswP1lTQYKi56gdANlVwbjfk/6wtmYLhkU9A
         J8sPjEMdP3T0cqFEQqo5H92fSdXyfQTeJdDgjHw0ib96YZVejaMsPpXkcNQKeRywA6KT
         EHdUearR3utTllb0yNsWiY/GZUq4NNRm+O7myYm/bAjjjYH/zhqsU7z2o1XqyCMj27ei
         9pLQ==
X-Gm-Message-State: ACgBeo3lHS6mbhZ6tONVXOhjY9ozFyEVOZqlFvEDn0WQTmF6fvf4IteC
	gLztj4Hf30fp3QIp85DEsiE=
X-Google-Smtp-Source: AA6agR6z/FsHg7kuQQRSqZewFwxTq5QNowomAfLhVXkjDPa/xg6WujlpI54PdpEu+TQF51hbvvW8Wg==
X-Received: by 2002:a05:6a00:1813:b0:52d:cccf:e443 with SMTP id y19-20020a056a00181300b0052dcccfe443mr29591570pfa.81.1660181471123;
        Wed, 10 Aug 2022 18:31:11 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id a188-20020a624dc5000000b0052b29fd7982sm2658768pfb.85.2022.08.10.18.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 18:31:10 -0700 (PDT)
From: cgel.zte@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	ye xingchen <ye.xingchen@zte.com.cn>,
	Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] nvdimm/namespace:Use the function kobj_to_dev()
Date: Thu, 11 Aug 2022 01:31:06 +0000
Message-Id: <20220811013106.15947-1-ye.xingchen@zte.com.cn>
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
 drivers/nvdimm/namespace_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index dfade66bab73..fd2e8ca67001 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1372,7 +1372,7 @@ static struct attribute *nd_namespace_attributes[] = {
 static umode_t namespace_visible(struct kobject *kobj,
 		struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 
 	if (is_namespace_pmem(dev)) {
 		if (a == &dev_attr_size.attr)
-- 
2.25.1
