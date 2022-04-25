Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768197E
	for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 10:54:17 +0000 (UTC)
Received: by mail-qt1-f178.google.com with SMTP id f22so9960367qtp.13
        for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 03:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VE7hLnL2JzRWXBL+x2KNohSUhmDWu5UxatJoTC8eSZw=;
        b=l2FcOdRwsh6qq4j24xk78eBC9Z8WD4+I4ThlceSG6NfKkURxWys6zBSGDcC+3Yxrgs
         6IfTQnSbiP6D7EhuiMICx3ZuYnNSwTkHGCGkpwQGnSIhcPtvoZSJHmDBvYHUhJXB7xy3
         bD8/z/m5I3WDL7bymmNvWNcwknlqlkqUxDCV4E0lffylHyR9UN6lKz9ZmbYOiNuzI8hQ
         3Z+SGYFuAwV98LDtZtzhGgjdLfav5+C2w/p+CqNqZ+NLwIxCNcuvrn7fsZY6iF6VD3ps
         QMEWPFzcp1KzPd0aX5J6YvYR9Fd2Z2A9nA65ssz0gbiLRfdyIDKdhSY00XUqFQvmGxix
         /KZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VE7hLnL2JzRWXBL+x2KNohSUhmDWu5UxatJoTC8eSZw=;
        b=3ZRNmliqeeDxwbnS0v4cb/OVhRtQdhA7c2gO3QzEE5HgQWVkS1eEbbm26LcS8lJn3k
         ISwfkMPGcUXCVGUOWFnIiIKl+RkdlMYLPgwBrc/66lnFzrx7lY1UnF+620TsFlZrw7eM
         X5IVQq28UNfPTkriiReG5EoID7mIyRuHaaVPH1q5ysJXO6YF7r1kbjcht9F6wROShIY1
         dsrNRXYDBIuTcXoLxUN2YaNvwnQklqkD5zqEDQ+hFXckHw8CGzB39U7z8Q/R5bHqH91j
         wbcDiM+pUJEswalnV1q1fWPec/ULBjuVG9CWYeeB4ZNsOsqujuzn662flnB/WhuBnzB7
         dYMA==
X-Gm-Message-State: AOAM531DcAqMZVWn+TJr3cWseBZ8V148yz7ng7A+JUR3mbtn251tARR2
	BNQcoJ3uhKiorzeK7uMGipcvgniBvig=
X-Google-Smtp-Source: ABdhPJxK8392ELC/VE00huZoYudJKEZoU3OodsWWeiGYf+b55ZMR4GSr+F6YXtPGed3PR+ijfJyt7Q==
X-Received: by 2002:a05:622a:144:b0:2f3:3bbd:3db5 with SMTP id v4-20020a05622a014400b002f33bbd3db5mr11540024qtw.95.1650884056495;
        Mon, 25 Apr 2022 03:54:16 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g4-20020ac87d04000000b002e06b4674a1sm6423576qtb.61.2022.04.25.03.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 03:54:15 -0700 (PDT)
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
Subject: [PATCH] libnvdimm: use kobj_to_dev()
Date: Mon, 25 Apr 2022 10:54:09 +0000
Message-Id: <20220425105409.3515505-1-chi.minghao@zte.com.cn>
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
 drivers/nvdimm/namespace_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 62b83b2e26e3..e9f021da743c 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1380,7 +1380,7 @@ static struct attribute *nd_namespace_attributes[] = {
 static umode_t namespace_visible(struct kobject *kobj,
 		struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 
 	if (is_namespace_pmem(dev)) {
 		if (a == &dev_attr_size.attr)
-- 
2.25.1


