Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C92317D1
	for <nvdimm@lists.linux.dev>; Sun, 24 Apr 2022 06:27:10 +0000 (UTC)
Received: by mail-qt1-f180.google.com with SMTP id ay11so8384480qtb.4
        for <nvdimm@lists.linux.dev>; Sat, 23 Apr 2022 23:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nMH61CDrzHjVCAmffJ1E5ukdJqDirmydINDBSwLoEeM=;
        b=ePFqeKOPBVP1IgwKDcs8a5gG/WXvSei4WF0uhoJYObIPAGgpJxMaMHfXupx5x6sl3s
         ul3o5PsOnMH/s8GH3UWU9VzRNJ0JYi+m0I1Tkj+X8v29o0g+L+UZEez6UrzyrPfinJvu
         EQ3KUDwB/H6pBGbtvsSjkqX/MKwYlbk/Sm8C042aGwIoURianr10qmPxXV3SkU/ZbwVF
         K1qgwlvCb+Bam4Mumi8B8vToX6gcFDTk2cX91363ZMKEMUZUY+Pw8PEq/Xi0AgMzSFQ/
         3jTctM4Dsj2qX/YaWUvp0YOArdQpkh9SGCBYooN352vFpjAZSU/f8lnIRvFk0v5B5+CS
         Alww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nMH61CDrzHjVCAmffJ1E5ukdJqDirmydINDBSwLoEeM=;
        b=Um0cRHPbQVn0B1aAsWqxbNAy+m1QQQ0Qj03ZF4on/BuTPZbYpUEwVO2C7gL8+MPgzH
         fzaiwACFMFcAYy+PRWb+IdCkfv2yXVmeop8JrbqJtAbdfETLPZX5yQkrOpx3V1qEzD7S
         bWCJQYNGVZWpZGBbwLM7N6kPCrv14JOXknNp98LWh1jMMsVe1p7JxOBahY8jfAd5IgMr
         jrscNlNYLP7u0S6wdCj2o5hP3D/NUeWsLmSeBZgw0BX7zLPRc3lAOqofeLMsmriF/9zq
         hs9Lw6RCnrvdGQtmOGr0knlD4JPuEBC+Dty2iSbBG3ltiOQMB+eeJvNNAJddIzH5EpX0
         eIpg==
X-Gm-Message-State: AOAM532JhEMi3u6KvKfjUBHxeymcRApcG8vsYllh3Mn5kYs3MS5lTJkS
	oAgvjJ+1yrPnL3KjPT/1Sug=
X-Google-Smtp-Source: ABdhPJzj7qkYuWbc8UK3DttS34N77zsB4aKhmCUyFz6bdHwvpD5pcHKo5QDWeRd81trfAwY3xxDrRw==
X-Received: by 2002:ac8:5a47:0:b0:2ed:13d6:bd60 with SMTP id o7-20020ac85a47000000b002ed13d6bd60mr8011675qta.371.1650781629633;
        Sat, 23 Apr 2022 23:27:09 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id q9-20020a05622a04c900b002f357a420dfsm4107432qtx.16.2022.04.23.23.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 23:27:08 -0700 (PDT)
From: cgel.zte@gmail.com
X-Google-Original-From: ran.jianping@zte.com.cn
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	ran.jianping@zte.com.cn,
	jane.chu@oracle.com,
	rafael.j.wysocki@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] tools/testing/nvdimm: remove unneeded flush_workqueue
Date: Sun, 24 Apr 2022 06:26:55 +0000
Message-Id: <20220424062655.3221152-1-ran.jianping@zte.com.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ran jianping <ran.jianping@zte.com.cn>

All work currently pending will be done first by calling destroy_workqueue,
so there is no need to flush it explicitly.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ran jianping <ran.jianping@zte.com.cn>
---
 tools/testing/nvdimm/test/nfit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 1da76ccde448..e7e1a640e482 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -3375,7 +3375,6 @@ static __exit void nfit_test_exit(void)
 {
 	int i;
 
-	flush_workqueue(nfit_wq);
 	destroy_workqueue(nfit_wq);
 	for (i = 0; i < NUM_NFITS; i++)
 		platform_device_unregister(&instances[i]->pdev);
-- 
2.25.1

