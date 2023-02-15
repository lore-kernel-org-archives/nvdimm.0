Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADF17B
	for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 16:51:06 +0000 (UTC)
Received: by mail-qt1-f180.google.com with SMTP id cr22so22429086qtb.10
        for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 08:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fbBnZ1g82/FRYV3IwBX90wHGlDsg+VX071r9sNu9jyY=;
        b=X/iWk+pGxMAPZo/p8jyuMjzB5qHl5qdNe65BhJJpWUosrUDSXyDIw/Rc03tji5EI+J
         wEhuFvgFTDV28X27HXF8cBuLygcTGQbhyWUAmAd72G9hkF9FoJ0OB9tdT/9g2O5jmnia
         md+aFtDa6JU5VwvK/ToO+vS496U3e8BkuuDh09oxwr22oEz9Ayn9ikvQJvQhGzy9aheH
         TpAxo6+oSzGeF7skOuwnNsPcoC1wEpPmOowcas0HfZ/NcjaEJtHnnK/GWXsxXpTN5WA2
         tcIgZhJF0xTYKhcPCOCjEX9nFIQ0IhcEb7k7fBPv7Q0Wu6slIgfBI1a+wlfz/WRRydZz
         BXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fbBnZ1g82/FRYV3IwBX90wHGlDsg+VX071r9sNu9jyY=;
        b=fEn7tK+YbZd3ot1dVfPz4AbSY4WupqpDJG8vsH/4rxW9EDXF8BR+hDHJvvmxn0Fyk2
         2jNfuj1DBxJaqvoAvQVnLYLdzTKZwzzqHW1lHLs+4s3Y5VwlirQoBz90imG0weTBv3bW
         Ek0q57qTlW8KhggYXEMG6gfJPRW3wnfpOUvx08WVIXi36RUbTWc5cecQi29c7QB+QUU4
         akSbxXtDRdKya0tVrjK5c68c7GYRzMgqSm00r30rKxxCSMlFrng8jHRh/F21tkOrEcqN
         1QhU1Ib5NaF/TI56J544nrme7EsH/xnnz5flB5yMgMrAJkYrFBaC0c3ajXH5mdzv9FYO
         HVqA==
X-Gm-Message-State: AO0yUKUjnz/Wl8BQ5exoN+xqzD6P1vzF6qjJzf2o8HCrzvgE+kN5K4Xd
	bnimJqWMsa+biz8mxaumHsYOyl0iC+Fk4MIUUkUhx26LwobLTkAjmUPqAP+mqDw8TBQH1gaOHFK
	zGwI9ClfS88G2q83LzAwgJlTs9fowDW94DERfF71w28lsRMxc6g8l6GGAM+rtpRjCVC8m
X-Google-Smtp-Source: AK7set+j8UUvfLNhOnhfQ5/4bKKL+67r+nrDZWjSuYAeJtIMmVOmqDR/EG6AvDw3ITXdGzOsI+C12g==
X-Received: by 2002:a05:622a:190b:b0:3b8:67c4:b11d with SMTP id w11-20020a05622a190b00b003b867c4b11dmr3451702qtc.49.1676479864650;
        Wed, 15 Feb 2023 08:51:04 -0800 (PST)
Received: from testm50.mav.ixsystems.net ([38.32.73.2])
        by smtp.gmail.com with ESMTPSA id y10-20020ac8128a000000b003b68ea3d5c8sm13353529qti.41.2023.02.15.08.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 08:50:41 -0800 (PST)
From: Alexander Motin <mav@ixsystems.com>
To: nvdimm@lists.linux.dev
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexander Motin <mav@ixsystems.com>
Subject: [ndctl PATCH 1/4 v3] libndctl/msft: Remove NDN_MSFT_SMART_*_VALID defines.
Date: Wed, 15 Feb 2023 11:49:28 -0500
Message-Id: <20230215164930.707170-1-mav@ixsystems.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smart_get_flags method returns set of globaly defined flags, that
don't need to be redefined for the specific NVDIMM type.

Signed-off-by:	Alexander Motin <mav@ixsystems.com>
---
 ndctl/lib/msft.c | 5 ++---
 ndctl/lib/msft.h | 5 -----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
index 3112799..22f72dd 100644
--- a/ndctl/lib/msft.c
+++ b/ndctl/lib/msft.c
@@ -80,9 +80,8 @@ static unsigned int msft_cmd_smart_get_flags(struct ndctl_cmd *cmd)
 	}
 
 	/* below health data can be retrieved via MSFT _DSM function 11 */
-	return NDN_MSFT_SMART_HEALTH_VALID |
-		NDN_MSFT_SMART_TEMP_VALID |
-		NDN_MSFT_SMART_USED_VALID;
+	return ND_SMART_HEALTH_VALID | ND_SMART_TEMP_VALID |
+	    ND_SMART_USED_VALID;
 }
 
 static unsigned int num_set_bit_health(__u16 num)
diff --git a/ndctl/lib/msft.h b/ndctl/lib/msft.h
index 978cc11..c462612 100644
--- a/ndctl/lib/msft.h
+++ b/ndctl/lib/msft.h
@@ -12,11 +12,6 @@ enum {
 	NDN_MSFT_CMD_SMART = 11,
 };
 
-/* NDN_MSFT_CMD_SMART */
-#define NDN_MSFT_SMART_HEALTH_VALID	ND_SMART_HEALTH_VALID
-#define NDN_MSFT_SMART_TEMP_VALID	ND_SMART_TEMP_VALID
-#define NDN_MSFT_SMART_USED_VALID	ND_SMART_USED_VALID
-
 /*
  * This is actually function 11 data,
  * This is the closest I can find to match smart
-- 
2.30.2

