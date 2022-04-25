Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E3A7E
	for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 10:53:15 +0000 (UTC)
Received: by mail-qk1-f178.google.com with SMTP id b68so10438763qkc.4
        for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 03:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nng+cuOZXEHqgBLxg+EFCILX+xKl20bMRqTLzQmAT+U=;
        b=pHDouWVUlROIktaXFvN8miGDnrFxxKbLC4wFfNzrdcs7nhlsxn8uGOENdcPRua02x0
         r6W49/A7A3WcoC84dlyrB3ux2fUaXrDZtAGW9s+bC1qwTNTfNv1bLxp+p3voQNetpXKp
         WW6EPzErPQyHVbyfg37Nz8pekw6R4O2cCa9jOh6sSx2kOY6oDf497+IbjcTn22mpmrir
         zRPztjgffzc4o634TPWGJwOxLusEabIzkHxm4kONyUeWieObTOyXVFaSwXngSx+YmD0a
         jjS3NsRNVIC20ZEx9q4lmJ5yEJ2bhdJsbGSm3KYuNiwwn3O9h/6TFsxdKXGaIVNqIHt0
         DbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nng+cuOZXEHqgBLxg+EFCILX+xKl20bMRqTLzQmAT+U=;
        b=i0sCdZs8pesSqXppZVwU/9EMyX9J/6+Hdxo2tvJmJgkZ5NdoGfexLOoHqLzykjU1jd
         1D9r1T61hZp2iqJ5SeSx1YZV9TplRUi+w9qu2SC/Ib3sfiisPQi2zpQzOieNFZr2lIa0
         hCkSPonGp5bfi6D3FQt83FesBZrRjlBerYwtWv5U6oQV89kEN6KTm4ag5f1FZfFcneOv
         3DomGMG/j1kQvv//reVdMSZeIPORiZNbEfbZl/BZc7nKIe+/CLiBYVF6vNJ5/xQ2O5Ol
         0JmpoRUJaReuXxJxK7B4ANlg5vFQ8czQc9NEij1x9pJqgrSoRKAYZvka8NjOmIMTAMi2
         B1gQ==
X-Gm-Message-State: AOAM531eb7XPrjUs6XUU5EFE9VCuf+/zsD63FU64KJK8t/n3wlVvRcWJ
	PMU5O0UiwH5rhRAUGYdsFbE=
X-Google-Smtp-Source: ABdhPJw4mgvJV9J7kPiDJloD9/keX1rjWVz5uMEwpVFnuDTiR37Bbvktx8338MASzNtnoiv6tNU1Aw==
X-Received: by 2002:a05:620a:438e:b0:69f:5296:fac with SMTP id a14-20020a05620a438e00b0069f52960facmr2671788qkp.719.1650883994069;
        Mon, 25 Apr 2022 03:53:14 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h20-20020a05620a13f400b0069e7ed38857sm4679973qkl.103.2022.04.25.03.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 03:53:13 -0700 (PDT)
From: cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Minghao Chi <chi.minghao@zte.com.cn>,
	Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] device-dax: use kobj_to_dev()
Date: Mon, 25 Apr 2022 10:53:07 +0000
Message-Id: <20220425105307.3515215-1-chi.minghao@zte.com.cn>
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
 drivers/dax/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1dad813ee4a6..aebe884f5d99 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -512,7 +512,7 @@ static DEVICE_ATTR_WO(delete);
 static umode_t dax_region_visible(struct kobject *kobj, struct attribute *a,
 		int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj)
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 
 	if (is_static(dax_region))
-- 
2.25.1


