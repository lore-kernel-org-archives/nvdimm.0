Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0175929D6
	for <nvdimm@lists.linux.dev>; Wed, 30 Jun 2021 08:10:07 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id x16so1659470pfa.13
        for <nvdimm@lists.linux.dev>; Wed, 30 Jun 2021 01:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0XSmPgSj0fdFBLsZJ/VblJqLDOdAGVIaBxvJNyRn2g4=;
        b=MJpMzqzlsJxICRx0u858aWlaqmetVD04LAxP+sMK1wBPvxziSKZFGEx4+BL8MIbjc3
         Hr5Ngd1NCyC06X5i6lH5VMc8hk7UphVLMfikFCWHZ276pk6hw9JPfSAh3bQE9CNIgMIf
         sp05lYhXKa3zFQejjsU9GEM9l7HvLDNqDcKttVhJ2hjEj/jmb5xDnlgn3qBP6oKnmFG6
         4+vfv4u0PNozX4Z4rl+VF38KXDQU8vvNkv1lb6sRDrTyiODuTTHNlZBE4OPDo74e1Tcc
         XppAX8ORyCeza9bfWfGlcF1JReo4GUP4k1BmjMxthENQZ5vBMyPbs1ffJrurmLQUjC+N
         dIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0XSmPgSj0fdFBLsZJ/VblJqLDOdAGVIaBxvJNyRn2g4=;
        b=myutw5SBB3XtNI/I9Xyo5MCclWO8b8yjtebNfwVxKArVunREAbYHqcgPuSGIS+eVwe
         wSxdoXz9DuctuiiYDc6PqtrWy+9offUpD00r88tXEZutEnfeobDPr0r0TCZIWHNhPrQm
         9nDtMXPen6k2fUZoLAzAWfGSKHPFITAvQF/iW3cpyZMlkfBHiB7XJWBJNJYAU9Jj2JgO
         FsG7x3sakHunz6bDlv+AU/NnYooL8zFFwNGLHFL5FWCXA6JJ1a/6iXqg/dJyhkxG1D59
         ++fryR46xO6DHZkKbHOCIC8W1KejeFlXjWLPe2Lsd36SuDkXrTn+qkj7+uU6WP9TNz+o
         PH1w==
X-Gm-Message-State: AOAM531yPfMIvbUgTj7j9rjYEMUGPXWg6fYnkt0brVTEOndJqxJXKRq7
	IcaHPUqEOuw6GNtMOeaaimA=
X-Google-Smtp-Source: ABdhPJxDXXSWiAxwVnsiIDiKm42GRoCNRJwceCMDQiOVS8U3kqdibHcpWBKF5VlTsGXyRItSTOMaig==
X-Received: by 2002:a65:5346:: with SMTP id w6mr19774241pgr.392.1625040607600;
        Wed, 30 Jun 2021 01:10:07 -0700 (PDT)
Received: from ubuntu.localdomain ([218.17.89.92])
        by smtp.gmail.com with ESMTPSA id 10sm20723080pgl.42.2021.06.30.01.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 01:10:07 -0700 (PDT)
From: gushengxian <gushengxian507419@gmail.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	gushengxian <gushengxian@yulong.com>
Subject: [PATCH] ndtest: Remove NULL test before vfree
Date: Wed, 30 Jun 2021 01:10:01 -0700
Message-Id: <20210630081001.1052396-1-gushengxian507419@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: gushengxian <gushengxian@yulong.com>

This NULL test is redundant since vfree() checks for NULL.
Reported by Coccinelle.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 tools/testing/nvdimm/test/ndtest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 6862915f1fb0..b1025c08ba92 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -487,8 +487,8 @@ static void *ndtest_alloc_resource(struct ndtest_priv *p, size_t size,
 buf_err:
 	if (__dma && size >= DIMM_SIZE)
 		gen_pool_free(ndtest_pool, __dma, size);
-	if (buf)
-		vfree(buf);
+
+	vfree(buf);
 	kfree(res);
 
 	return NULL;
-- 
2.25.1

