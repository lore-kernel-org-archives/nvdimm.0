Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388F31110
	for <nvdimm@lists.linux.dev>; Sun, 13 Nov 2022 11:27:00 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id k5so8057780pjo.5
        for <nvdimm@lists.linux.dev>; Sun, 13 Nov 2022 03:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bwYxIawp/7otyMar5l7yZGIbqO8r/RtWl5Ye19uVvS4=;
        b=JyLu7BvM/6eV4Tqy2q3bfcpXIhAMTSBFulu/vrPgsdHcDzblDK7GF7ZJzCZDNSE68G
         d7OW9epr5z9ua0muUSqyiUMbCKWrq5dTTgrLD7+Pfrs0vT58s5nmUck2FSDaUoJqs86I
         K0U5Lm+1RjIeUXcXky9TAQ/USYmb0KmKfP/D8Ve7y0CfEvpkKJmdYezsqNGdg2Oq2vef
         wevzBM8h+iv8qrRxqPQK3XsL/rTNFPNoUU0O3Yf7quKxr57gNpmXNpM1Lv9MEhLXcpqI
         UBrz53cy047Fxx1imloqdLNRoxfhdQ1CWq9ldFa43roYjd2DwZp8/JVYemagb9pptQ4H
         AJ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bwYxIawp/7otyMar5l7yZGIbqO8r/RtWl5Ye19uVvS4=;
        b=tZNDEOMDnEEpPxMj23QMAdCZY5ri15kaMsTFpU2/IZS4uYfJfxyk9vvQuEOwj7TpLt
         981eJNewSYE5OQl1YLzzOE7iF/qECrQq1kgnv19b+5vqhUECntlX/tn8tS4AHFh9SV7C
         +iDPJgvvcC8hx+Vj/keRhrBZxWDmTmKFFgGG+PWSNOjQ4V1GK+IXrN+3j0g2Y4hZf1Wi
         ODqo4iUD4Dch6aTjTlkRKx1x2IgPeMjXdLZNTP2zaI3jnlL2B1mcnZmGAaVkDdqVbV32
         BS0RiCvuk6laxoWodr1qPXDNKYY0k19+CrDh1PhTrpDrNesB4Lu5mLpu7VVVwZTpi1ZD
         ZkIg==
X-Gm-Message-State: ANoB5pnCHOttgmpMmpeG+MuaB4GmcdpvL65Dx73JLU0C0S7mkcHkBmR0
	q9Ib1YYRNr0E42LlV8ZZSSI=
X-Google-Smtp-Source: AA0mqf7H+CJf5MvzFcQhoxypQ8iGjsmf5cz8eE4OZwgEgEQVLvG4bCntBtXERqKfwsxuiy1N++SOUA==
X-Received: by 2002:a17:903:483:b0:186:a7f1:8d2b with SMTP id jj3-20020a170903048300b00186a7f18d2bmr9345221plb.137.1668338819432;
        Sun, 13 Nov 2022 03:26:59 -0800 (PST)
Received: from localhost.localdomain ([14.5.161.132])
        by smtp.gmail.com with ESMTPSA id q8-20020a170902dac800b0018725c2fc46sm4973943plx.303.2022.11.13.03.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 03:26:58 -0800 (PST)
From: Kang Minchul <tegongkang@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Kang Minchul <tegongkang@gmail.com>
Subject: [PATCH] ndtest: Remove redundant NULL check
Date: Sun, 13 Nov 2022 20:26:53 +0900
Message-Id: <20221113112653.12304-1-tegongkang@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This addresses cocci warning as follows:
WARNING: NULL check before some freeing functions is not needed.

Signed-off-by: Kang Minchul <tegongkang@gmail.com>
---
 tools/testing/nvdimm/test/ndtest.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 01ceb98c15a0..de4bc34bc47b 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -370,8 +370,7 @@ static void *ndtest_alloc_resource(struct ndtest_priv *p, size_t size,
 buf_err:
 	if (__dma && size >= DIMM_SIZE)
 		gen_pool_free(ndtest_pool, __dma, size);
-	if (buf)
-		vfree(buf);
+	vfree(buf);
 	kfree(res);
 
 	return NULL;
-- 
2.34.1

