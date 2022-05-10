Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45A37B
	for <nvdimm@lists.linux.dev>; Tue, 10 May 2022 10:55:55 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 15so14333809pgf.4
        for <nvdimm@lists.linux.dev>; Tue, 10 May 2022 03:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BDpr4fgOnvVyQYrFekFWe52UirgkPK8wiEQGbAdUq4g=;
        b=IQ59VPtA88LWqzTp7fRTwZwyfdBWVvFMqHuZ0jsgBBPzROR5O6cPm28KDvKuVB6j1p
         BHnONpOyhh5X4j4B8Ar2QJ90KsSkk2om0KEQyKzgdnPmezHr4ijzfJe8chcXGOlPTLyb
         7HU6hcMDqqRV28YwhMMZhccuscV2hFqEe7nsM799XTMrOfiFmAs3pCTjnL41g427bVCY
         v2iV8u/r+tkzFXPXLEaEB3/sGloqNKxIanhVAYx9wLvWi3xp0nmqoREIbtYzT1ozeTiH
         lvWNzFUrxcZTzCq63zhY53fjjAP174at7Fm6GZioxGxIi8dX7q/09Yt7tcrbVMJW/ysS
         gkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BDpr4fgOnvVyQYrFekFWe52UirgkPK8wiEQGbAdUq4g=;
        b=qlzpDCWZduHYxknUDMEwAS7rFL3Prt0LyPIfY/OFkka0/9QF1VMtH9+/f2xlVBYH/F
         fnpSmieJohRQvkEk4TfGWgTtJP43WJWEb6hjbIiiAM1F4JmVbuMN5nTv2r4r0V9+PqCK
         e8C4JU+oXx8/cucaqMQjtCYnuneJtgM0xxJcfRAUpj9CjLVvUf1v0mpoZo0AGnp7i5RN
         V+GFn8FeBP6Ezn/px921xCWBIwK0jggJbPSloMKrmEhy2BGEbrgkXqtZvzkllq2vsxWb
         CRgyPHuRKENK6IRHFtleCxayMkXef3Ep68UiDzZwtJAkymHtTOAApQaW1Uy/5Y5QB50T
         oLlg==
X-Gm-Message-State: AOAM530PwFylNJoJQKIIfLlGeCW1D5ZZ7BiqOl6M93MDJgRIOWmYeQ3Y
	ma/LMZPPihWPOsrRKC7wy50=
X-Google-Smtp-Source: ABdhPJxIq7oyNrunIkIE6opFYDusf+6BjoTkzofLq9YkNdo883HyN1gIEhfwWtVNj1Y6Zavx6CNyMA==
X-Received: by 2002:a63:3dc9:0:b0:3c6:4085:9de0 with SMTP id k192-20020a633dc9000000b003c640859de0mr16741051pga.57.1652180155296;
        Tue, 10 May 2022 03:55:55 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id ls6-20020a17090b350600b001dcf9fe5cddsm1526501pjb.38.2022.05.10.03.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 03:55:54 -0700 (PDT)
From: cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Minghao Chi <chi.minghao@zte.com.cn>,
	Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] dax: use kobj_to_dev()
Date: Tue, 10 May 2022 10:55:51 +0000
Message-Id: <20220510105551.1352798-1-chi.minghao@zte.com.cn>
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
 drivers/dax/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1dad813ee4a6..f0f45962005d 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -512,7 +512,7 @@ static DEVICE_ATTR_WO(delete);
 static umode_t dax_region_visible(struct kobject *kobj, struct attribute *a,
 		int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 
 	if (is_static(dax_region))
@@ -1241,7 +1241,7 @@ static DEVICE_ATTR_RO(numa_node);
 
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 	struct dax_region *dax_region = dev_dax->region;
 
-- 
2.25.1


