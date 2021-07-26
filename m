Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915A32FB3
	for <nvdimm@lists.linux.dev>; Mon, 26 Jul 2021 06:09:17 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id m20-20020a05600c4f54b029024e75a15716so4526098wmq.2
        for <nvdimm@lists.linux.dev>; Sun, 25 Jul 2021 23:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IL1TsERkpfeL/Up3TsKMyalrufqRTmEKYRINP+hI3xg=;
        b=fr53vy8vVWxfCipACfzo6OlpNTVZxQhrskrTxm+c1isLJ0n1J59QY15jO/Be7EFU/o
         oD3sLh9dx0PNVPIDeFKxrBlcn9Wf/z89oMjAaRCCAGyn/a3lenC1WWmk7BbxqGtr1Aif
         WjL7qFFTFPhk00lXOSGcIrG9pfxwf2VSh0z43/vZmyga/ChF3+PIq1YzVRXPsR+Rw4rQ
         /kYsYa32EHoquXbPiW/XxjSeuEAKNp6+3DPCHR8FJl7F9hmtc8r4TeNdQCMu79ojILBY
         OJxlJZ9mwoMERlTys6gc6Yt4chF6i/FNvmBsgQGnXUA3fO+E0Oa8nnzCncp0Kh800uxe
         dK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IL1TsERkpfeL/Up3TsKMyalrufqRTmEKYRINP+hI3xg=;
        b=S1x4dGkrWHerDEEVepLsQVNbOh3pFQDK7PXOSFSUQ7SuM6TCKS/oLJ7ALnVSybYGav
         5YCQSRGM4PdT6HB4ksqaLc6DN+XIYc6p/cQLNw3qnBZlaQ1H2DQTRTo4W9mTMunS4w2G
         fwO2XltGPI91Mk1quJJfx6+WhsIyFq3sowUoDw4wFmIPc1krrXEA0L+AUBKxKSATr9y0
         VXtSBT//p7mu4ANnPScW4x/UAON+wK5ZgWZHaPH4+TxeA8LqBZ7hKD1WlS6mCO+lMNnV
         pzBwSB5xaLwvysZTRiQcub0g4RroJjkHRtx/7jAA2D3US9DqNW78twEdvvHBymvU/y7i
         /izQ==
X-Gm-Message-State: AOAM5315L2XRModrvUKhAsTtvmLRCfqx/XwC6lr8+YcUbbYPLUkD+hKT
	p/Mk3TY817Mk9CE9qYPxds3/VrnJ4A/KW1WR
X-Google-Smtp-Source: ABdhPJwmyKXLP9krJ3B0G0CWCA1t47tOg2fGWtfdbhZbG1Ckqr26Gw8QYAoFirIOiJtIS7WHYomgIw==
X-Received: by 2002:a1c:f003:: with SMTP id a3mr25841640wmb.82.1627279756045;
        Sun, 25 Jul 2021 23:09:16 -0700 (PDT)
Received: from lb01399.fkb.profitbricks.net (p200300ca572b5e23c4ffd69035d3b735.dip0.t-ipconnect.de. [2003:ca:572b:5e23:c4ff:d690:35d3:b735])
        by smtp.gmail.com with ESMTPSA id j2sm5817548wrd.14.2021.07.25.23.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 23:09:15 -0700 (PDT)
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
To: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com,
	jmoyer@redhat.com,
	david@redhat.com,
	mst@redhat.com,
	cohuck@redhat.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	pankaj.gupta.linux@gmail.com,
	Pankaj Gupta <pankaj.gupta@ionos.com>
Subject: [RFC v2 2/2] pmem: Enable pmem_submit_bio for asynchronous flush
Date: Mon, 26 Jul 2021 08:08:55 +0200
Message-Id: <20210726060855.108250-3-pankaj.gupta.linux@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726060855.108250-1-pankaj.gupta.linux@gmail.com>
References: <20210726060855.108250-1-pankaj.gupta.linux@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pankaj Gupta <pankaj.gupta@ionos.com>

Return from "pmem_submit_bio" when asynchronous flush is in
process in other context.

Signed-off-by: Pankaj Gupta <pankaj.gupta@ionos.com>
---
 drivers/nvdimm/pmem.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 1e0615b8565e..3ca1fa88a5e7 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -201,8 +201,13 @@ static blk_qc_t pmem_submit_bio(struct bio *bio)
 	struct pmem_device *pmem = bio->bi_bdev->bd_disk->private_data;
 	struct nd_region *nd_region = to_region(pmem);
 
-	if (bio->bi_opf & REQ_PREFLUSH)
-		ret = nvdimm_flush(nd_region, bio);
+	if ((bio->bi_opf & REQ_PREFLUSH) &&
+		nvdimm_flush(nd_region, bio)) {
+
+		/* asynchronous flush completes in other context */
+		if (nd_region->flush)
+			return BLK_QC_T_NONE;
+	}
 
 	do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
 	if (do_acct)
@@ -222,11 +227,13 @@ static blk_qc_t pmem_submit_bio(struct bio *bio)
 	if (do_acct)
 		bio_end_io_acct(bio, start);
 
-	if (bio->bi_opf & REQ_FUA)
+	if (bio->bi_opf & REQ_FUA)  {
 		ret = nvdimm_flush(nd_region, bio);
 
-	if (ret)
-		bio->bi_status = errno_to_blk_status(ret);
+		/* asynchronous flush completes in other context */
+		if (nd_region->flush)
+			return BLK_QC_T_NONE;
+	}
 
 	bio_endio(bio);
 	return BLK_QC_T_NONE;
-- 
2.25.1

