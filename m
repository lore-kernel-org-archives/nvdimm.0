Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB657485
	for <nvdimm@lists.linux.dev>; Thu, 19 Jan 2023 14:47:19 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id o17-20020a05600c511100b003db021ef437so1433287wms.4
        for <nvdimm@lists.linux.dev>; Thu, 19 Jan 2023 06:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qBdr6CvRTXDqztxS8w8Amt28GJOv4Ri8se7UX3qldf0=;
        b=Rlcd0foPpo0HC2tQTapxWVA6Ga1i1tUz28R8lL0TO+0CW7/5yQ/iTNRPP5QXdzNB+F
         a2iGNJPcx8F5Z8PVuvDxPTj8masQbhp7gvXiJzQMtnxRDEo6UbacI2Y3eQfve8AJ0bvl
         n1tPyYjwvqAiuhlu4qxddnhyWosapw5WFH5beG1V8NP7oISxZq47UfLuD+9hzzQAIQ0d
         gpkCrYz99hwXb/ZJ5R/Gom6BVOrlA2QW97Euu9fw+pOkhFqFNLI7ID+s/qxdijlj81a0
         2JvkmJD5k0OJCJpUgHeqjdQ4g62xtIaMFgoHOvxzdAWAIO1VQanrTfXJy9wrzPVxxgC6
         tneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qBdr6CvRTXDqztxS8w8Amt28GJOv4Ri8se7UX3qldf0=;
        b=ER9RE811VIXnayvyzxSEsEYCZuvpRujDhhXaGQDcqAIZtu4dx/YRrzvdK0leRhpwU3
         i3KFkH9/hxNDiDsMwIF/PGVDwtgWK+AkJPWzohM8+Qe57wwZItisf4QVwIzqSwQ9XJLm
         QqeWvRshhfNaUZD2u10bc4blzZs8CQkOCvqCUbAf/28s/giokBP9T/wfv6mUDohqkhTa
         R1PGQ28sw8MnsHizL9YHOSDAFULyPfbdgCus5g68IF86+F4cyPnOpugjZz6g60djpTaU
         m+qMfLSgycl79/R/Lcabhc+S99UVC6gbhLqxsyeOJx42SziBN4u4Hisl3eRsttC8qM7r
         LB/w==
X-Gm-Message-State: AFqh2kpBQFevXZxWQO9aguo/A/vrHW1pLjvW5InjwSGVddEknm/Kydgk
	DTG/EF8jHq+4XK04vT4JCfA=
X-Google-Smtp-Source: AMrXdXuPPvS8OnQHS/sRBKiM2PpTV40PNEhTNVTm09fiDdyyeEKvLn+CGTf+7kiDD3MI/en4rrwx+w==
X-Received: by 2002:a05:600c:1d8e:b0:3d9:efe8:a42d with SMTP id p14-20020a05600c1d8e00b003d9efe8a42dmr10503656wms.21.1674139637594;
        Thu, 19 Jan 2023 06:47:17 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id p18-20020a05600c359200b003db040f0d5esm5471979wmq.33.2023.01.19.06.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 06:47:17 -0800 (PST)
Date: Thu, 19 Jan 2023 17:47:13 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org, kernel-janitors@vger.kernel.org,
	cip-dev <cip-dev@lists.cip-project.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH] ACPI: NFIT: prevent underflow in acpi_nfit_ctl(
Message-ID: <Y8lX8bKPN6ObNN2i@kili>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The concern here would be that "family" is negative and we pass a
negative value to test_bit() resulting in an out of bounds read
and potentially a crash.

This patch is based on static analysis and not on testing.

Fixes: 9a7e3d7f0568 ("ACPI: NFIT: Fix input validation of bus-family")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Another idea would be that we could change test_bit() to not accept
bits higher than INT_MAX.

 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index f1cc5ec6a3b6..da0739f04c98 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -446,10 +446,10 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	const char *cmd_name, *dimm_name;
 	unsigned long cmd_mask, dsm_mask;
 	u32 offset, fw_status = 0;
+	unsigned int family = 0;
 	acpi_handle handle;
 	const guid_t *guid;
 	int func, rc, i;
-	int family = 0;
 
 	if (cmd_rc)
 		*cmd_rc = -EINVAL;
-- 
2.35.1

