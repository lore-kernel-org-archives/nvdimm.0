Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73F5190
	for <nvdimm@lists.linux.dev>; Thu, 12 May 2022 01:17:12 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so6422360pjb.3
        for <nvdimm@lists.linux.dev>; Wed, 11 May 2022 18:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=91WjG8Xgx7zSwWUKmJ5ZSvjr4nPKvPOOCne/40ungPw=;
        b=iktCS3MFPTW3v9KcNEYcXrmVK23wGjhROQSXLkxw0YvX2V+iHCxWCRTIpcPAWSyEaT
         I2IW7NJ2Wmm99rzrcUYT19xGZcElkbm1jDi9MFV7bJIinywBGR30NFywf1fFl7silO2v
         Hafzvq03Z5tXwU8vPtEzBICethZwCdUxt+kN5FvXCEp006yCl5AcRt14hLt6yQ837Hzu
         SdK3KIoURq7EfuC52WwrLB5Y6YDyuMW0iGsOIRDsiYcFY472RMEboKGWiPWpqc2b9s71
         ESyXYoRo1SMCi0G86afjxtyMQ2rArCW24myG3ytAv1wcRcYFeXfNQHETJQiPXGYXX7hj
         CqSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=91WjG8Xgx7zSwWUKmJ5ZSvjr4nPKvPOOCne/40ungPw=;
        b=RkR2oBx0VLovDouf2zDkMSH331S4yxjBUNrbkFZQTFEiKyOo7Cmfk1lx6+LaDLZyUc
         yxBgxD+qVbGpoEcxmmLHNI9yy10wlcBam71scxuR1IbuiNwnCNh5UN4xMeLPk/bZhYMJ
         clpo0bHPHBkIaiNjXNuKdIHMvYw/bD/nRS0YxeeZ7r97wSpLDjnl+x8wQQgov5qkdD1N
         pYoGMRsk4ogElfHbQSf4i20zuwYhydnQuvkmUP9bBZq4MwMZdG2eXaVaAULZ94xf1XlT
         vb5gWAaDcUkE2PLWZ+gnJS0f80jCtRrBppmqIG19QWKFoulgq/YBrFYhE3+6meoCP1N/
         pQnQ==
X-Gm-Message-State: AOAM532shC4MVkhb4aw7eQdvfiHJ+sMaooRNb6vQltaGtJ/4ZP5sTocW
	CArQC8BBtbuto1KRJTz8n5U=
X-Google-Smtp-Source: ABdhPJx85MTQXdHNFwU36UFVAAIS/ICXp3PePnf5H5bIDcZeM48iGF15fix0phyLByLEpSVyb2ReDQ==
X-Received: by 2002:a17:90b:3851:b0:1dc:4f70:1cb with SMTP id nl17-20020a17090b385100b001dc4f7001cbmr8080318pjb.167.1652318232159;
        Wed, 11 May 2022 18:17:12 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h20-20020aa786d4000000b0050dc76281e4sm2396913pfo.190.2022.05.11.18.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 18:17:11 -0700 (PDT)
From: cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Minghao Chi <chi.minghao@zte.com.cn>,
	Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] libnvdimm/region: use kobj_to_dev()
Date: Thu, 12 May 2022 01:17:07 +0000
Message-Id: <20220512011707.1621619-1-chi.minghao@zte.com.cn>
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
 drivers/nvdimm/region_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 0cb274c2b508..d1bd82a3a500 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -720,7 +720,7 @@ REGION_MAPPING(31);
 
 static umode_t mapping_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct nd_region *nd_region = to_nd_region(dev);
 
 	if (n < nd_region->ndr_mappings)
--
2.25.1


