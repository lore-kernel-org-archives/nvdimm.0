Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A852417E0
	for <nvdimm@lists.linux.dev>; Mon,  5 Dec 2022 09:20:36 +0000 (UTC)
Received: by mail-wm1-f49.google.com with SMTP id m19so8229601wms.5
        for <nvdimm@lists.linux.dev>; Mon, 05 Dec 2022 01:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nfqa1/DcZe0r0B/XaN6wGfaWPmJF2FQC9eWV8YducM0=;
        b=NcRefKO5GW2oc76+9SIi4DsNdkaAj2EDR7CgEibSGrRq2RjwAzFj2+bU2GBeo1NqkJ
         IBIuR1cSVd8mQoJVr0norXvfLhhBFizG0sUJZGF1VSUr3FxXx3wcJGN9mE7Kv42Uq7Rx
         ggejGZcAOaRWiqv3pt8qMG4p5G/1mWUuS7DGFNeA1I3kdJL8ToUy2TyXEddolA/iuyPC
         gbkwPK2GqpQ3MdRVUHdaZoeIQ8a6QuhLKzwoUz7dh8Qxe3OaEOdxrLqGOfOqIEJBimPz
         wfHtaVchIcpisbK0L8P0jzoikQMyrjZTYfou0O9yZvH2QtH9jb16ReY75JjcnvEAzaIQ
         grsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nfqa1/DcZe0r0B/XaN6wGfaWPmJF2FQC9eWV8YducM0=;
        b=bIT+90q4jwh5x/LsAUA025Xc4jsyZoci+TbtGiUKcoACb9mB3TvXvb17K1uRSzv8Me
         rgOD9WmZ7PW6UT7a0lZjl6jd07DAy5ZOeQK4VhnkGo4HvdLsybYDZZCrIUP2wVzjgeYu
         BVI/n+svB7bxmd8VSGuSU8CsXAjoTtb1hiDf1BaK3jrGr5N4V+/Y0WDF4/cCHqHeaC0K
         yPsqDnUVeavwJdyymQyVauEAIMxAVlF2iZksnWMUQCUc9mjUU2E8yqFyRsgnvJfD19PK
         36pQZ65noa0vIW1LJxMha7tkj2EHn8H/c19N/FAYVEycGX7B2YyfKAtzCjTyPd0s59ny
         VmGw==
X-Gm-Message-State: ANoB5pkdK6JJDe1ui3rbCbs2sVsfp1JAELkq1fw+KvlnmENSjWIK8uMr
	qiDRN/IQgeMhcL3LI4vy9B0=
X-Google-Smtp-Source: AA0mqf46joosKsrX7Xpeewt/KqZGUwqtd/jDSD8o4ItpKe7tKVyvz+U0nM1UYkbuk7wHDafiO9HL5w==
X-Received: by 2002:a7b:cd88:0:b0:3d0:87d5:9e6a with SMTP id y8-20020a7bcd88000000b003d087d59e6amr8944600wmj.56.1670232034802;
        Mon, 05 Dec 2022 01:20:34 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id z2-20020a5d4402000000b00226dba960b4sm13531854wrq.3.2022.12.05.01.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 01:20:34 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nvdimm/region: Fix spelling mistake "memergion" -> "memregion"
Date: Mon,  5 Dec 2022 09:20:33 +0000
Message-Id: <20221205092033.1943769-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a dev_warn message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/nvdimm/region_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 83dbf398ea84..8f5274b04348 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -80,7 +80,7 @@ static int nd_region_invalidate_memregion(struct nd_region *nd_region)
 		if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST)) {
 			dev_warn(
 				&nd_region->dev,
-				"Bypassing cpu_cache_invalidate_memergion() for testing!\n");
+				"Bypassing cpu_cache_invalidate_memregion() for testing!\n");
 			goto out;
 		} else {
 			dev_err(&nd_region->dev,
-- 
2.38.1

