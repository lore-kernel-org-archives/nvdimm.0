Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD3813AEA
	for <nvdimm@lists.linux.dev>; Wed, 21 Jun 2023 13:02:59 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3090d3e9c92so6751557f8f.2
        for <nvdimm@lists.linux.dev>; Wed, 21 Jun 2023 06:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687352578; x=1689944578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p1snc3z/xTJ1VfTgS+xUuvVWJtWsmykCdplUwtlGRSE=;
        b=Lv4pPl5dm1tsCSiRwC/EEKizLn2tjonFfrmr7Oafj5RDquW7/Ldy5JXUJ8F0yhXkc1
         0ci9gANBVnN3QjvRMNMK9oBQ/9ET93rXCqnGxOmfxpUbEcicRtPwyOJ3wQ/wdSb6gIBQ
         VIZykLT714hMtjOr9RyqgpNHJw7xxpKzoL+oWLgPXcewKCg9e3Oz5cFWQ8X/CbUWVoKW
         A3T9SK5CRgsPQe1H5O7agHVTpp9ajp/9calCpm8iEXyCJdXOaGPhQh03ma1uaQ8E65jo
         nyyj9jZlBiIFuaegbONQDlVBg7UK/ZAMu0rXnzJY0Et/1eYjgw3Ur6ejQZbF1B68NfKk
         aYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687352578; x=1689944578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p1snc3z/xTJ1VfTgS+xUuvVWJtWsmykCdplUwtlGRSE=;
        b=OAYZc1s6Gt76HucTPNjG0DUI2SRBMEZMtbsoWSlXVPHpMdj6T0st0DE0reOpwGa3us
         WFPBkadaxKXjw2Ki0ISBXsMre+Qb1Bw+4RynFLlJPyLBcm4/uRqm5eBH9ii10XA6zTT0
         k9A/0IepEVnsyE+RWozOBIsVHpNz9wl4cTd2tuAUuYfV3+Za1Uq1UM3QIn+/zoF71X95
         GrXqggdPYoCTnFZYDnc0NVG9A2mTDAxthoysJecIv2Cg296WS0YMhTND/1UM8C3PyuuH
         NaIYFpOTcPg54pucmcUMwfAF0CBZW+thFHtJNPBQPTreoaSXuwVVViWA1RC0n4Yv/Hw4
         zNDA==
X-Gm-Message-State: AC+VfDwgKrvAsHqzIPvGOMtjKXH98Xs19a12nqT/6UurmPOwvQSSegFn
	mE4E8/7p5mnjm6ze4PzNXdE=
X-Google-Smtp-Source: ACHHUZ5rBNQwgTcud7BCqacDwmxN/UgQThg2UpRWHJDkiKd0tH6NmS6ySa/0h+ZN+TOtXqP9XTNOpw==
X-Received: by 2002:adf:f30b:0:b0:311:1390:7b55 with SMTP id i11-20020adff30b000000b0031113907b55mr14800141wro.68.1687352577531;
        Wed, 21 Jun 2023 06:02:57 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id w18-20020a5d6812000000b0030ae69920c9sm4413853wru.53.2023.06.21.06.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 06:02:56 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] fsdax: remove redundant variable 'error'
Date: Wed, 21 Jun 2023 14:02:56 +0100
Message-Id: <20230621130256.2676126-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

The variable 'error' is being assigned a value that is never read,
the assignment and the variable and redundant and can be removed.
Cleans up clang scan build warning:

fs/dax.c:1880:10: warning: Although the value stored to 'error' is
used in the enclosing expression, the value is never actually read
from 'error' [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 fs/dax.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 2ababb89918d..cb36c6746fc4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1830,7 +1830,6 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 	pgoff_t max_pgoff;
 	void *entry;
-	int error;
 
 	if (vmf->flags & FAULT_FLAG_WRITE)
 		iter.flags |= IOMAP_WRITE;
@@ -1877,7 +1876,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	}
 
 	iter.pos = (loff_t)xas.xa_index << PAGE_SHIFT;
-	while ((error = iomap_iter(&iter, ops)) > 0) {
+	while (iomap_iter(&iter, ops) > 0) {
 		if (iomap_length(&iter) < PMD_SIZE)
 			continue; /* actually breaks out of the loop */
 
-- 
2.39.2

