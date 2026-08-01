Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6BB30E0DC
	for <nvdimm@lists.linux.dev>; Sat,  1 Aug 2026 15:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599426; cv=none; b=D/xRYNrNVlEtiYswjD5ESYuKCHHD4NJ5PLcMOZH+xKchcj1wfA4HJ4KK8CdESKCOePeykI49U0HKQJavVHuWv3T5lqmd4+ZHYbbZAzp5UWRpjNs2X6biSBMAARqwIQb4ws7VeF3ot7Q1iKu1r1nOLjjQ82WufohyTxmLtYKQpwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599426; c=relaxed/simple;
	bh=5jZAhWEaWbKaEJ0h/lpCMDFZsTZrSyaTXCzcWYUXgLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrWuqPus9QXA+M/paOdVLYpvZbxbE7zAbIY65DGC3aGadcYwTVPXlhhjc+IZVzz75o3bQC4fk9X1S3hSg7+ro3S+/K1foVgsQyoh0GbhYemSojCrjMtt+bOscUcpLpQ/XvUw8aJpIZtBaCOd2Bvu5fxQJv10gHxcJIxLxundHlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RyU55AZG; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RyU55AZG"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ced3386430so20023215ad.1
        for <nvdimm@lists.linux.dev>; Sat, 01 Aug 2026 08:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599424; x=1786204224; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UQw568s99USSdIytlPm2Vpoz5MduETOEjKRltqiPXcQ=;
        b=RyU55AZGOHouTX6TRVawlu29jtkJdUkpsS81FwSy7pIFog8JfRuKaHCG7/uBXEKCAT
         P4hAWiulxxdK9A7kOE3YpsSOp3kpJWmwjdD03pc2cUgfqX+9I4DAYn8kU4mLR9r9ipKY
         8cecG2sSAl3G2MLG3mo2aUj0uBYM3arOOc01i+LfJ1rMVUpu+0shnF/nMBPIOnz3dyDA
         xupJq8vnSwc5zb+8c26HJ+ve9bQBGKML6Mfl9tI5AQoy/MydTivw1Dayhuy+Y+Dk3/IY
         wqGKJn3SN7wnDJ72heY1TcNEm56QAohzXFzao3A9Mtlu4aM8vsO1z59dFAfjZ4wNoqV9
         b3Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599424; x=1786204224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UQw568s99USSdIytlPm2Vpoz5MduETOEjKRltqiPXcQ=;
        b=gEYxzARuRB33L3sVinJrE+8BsaPs+9aiIQF0KpgNqL3zOLEoDRntWpJflI+pOIXTxa
         BnKQA9S2QsGlWD2dhsWFuhgdock6CEx4B4+UArVLdG5RvgweyHCE0idkaEAt10UQZAwW
         aC/3ecVEPlqkV7dJ3aWmQkpaxCGC8mYtw2pMmrMOdX5GaKf4HxvmX5fnPC6SrRh0prdw
         Nw9dJnl0YiiwfX/Uf28tki+PAZ1qCnjfHVnJ0AkbhVuuFYMcmxxRcVHLJcwtrf3zJYaW
         /UYt+E8xeE6GzeMJRmXzjUpPzE+Ir9ZHNB+vel6mws94MGLRgsDnN4n8U5u54AqRr9li
         StUA==
X-Forwarded-Encrypted: i=1; AHgh+RqrzzN2gRRVSoxUL0FsogebSIEgzxdTT6eGaTUeKhxT91SGOaEUTqa7kXxiKQmS2dSRVQ5s7yo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAsydKWWT30egZviU5or7Jkw4JXnWjuytdydGG/r4yv9aqxEdZ
	djhTdYaKtdU1tiIS9qlM02jfqiBgKpkQvi7tpEsrVJ/al64oTLWKIBu0
X-Gm-Gg: AR+sD13v7ee6bGTezsvqF/wFTDtLloogxPUS3BCeg10L5zafySMTv/q4gtWnG1e8r1k
	JyBbxk7QLuzdvB20DrW9MkPsGoTQBR5fyjNowQQ9RQ47bSw0Qz9LvooBtZjIY04R4QKmjgdLgLN
	EqnlruDv34OFnPL5m+XcKWIOrcIXJwIbZ82npQ/pELVIW7vyuSx1I7rcUREWWpmrUXzwJzTOfn8
	jTDnwnS4zdAa6GU5Z4jB3sm0ehN5INDsvUtownVAsbpibWn1qhYRMrffSpHHuvmePixwfoxvQHb
	xnKQVUP4MwYVCwZ7K83H0Ncz5EfIXR0QFGOz5Km5qxwi1N76c7b2Gh8FImZacQzqFJXlVFpT6Vt
	HQpb8WAxNjPiggXS/QsT/g2XRvRSIXil5Ysp3mY+6F16MIl/woM+StHr/aGoS7R3kktsQOAgUDr
	+Qus3Eu7TAqW8iN9Ck3iNT7hO22wsST+7Pte1acIuXVCDCiTtRSG1gWigu8NLRhV7sU55hxVTWs
	zu0fPevcT80FNNsE2B6imVwPDB3IBikdWdeOum2BsaJF/OxogZcVJYOJw==
X-Received: by 2002:a17:902:d2cf:b0:2ca:a03a:29b2 with SMTP id d9443c01a7336-2d0521a5657mr42155635ad.8.1785599424386;
        Sat, 01 Aug 2026 08:50:24 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:50:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: [PATCH v5 10/16] nvme-pci: rename nvme_pci_sgl_set_data to nvme_pci_dma_iter_set_sgl
Date: Sat,  1 Aug 2026 16:46:22 +0100
Message-ID: <ff507b4895521074938d82fe2647e003359ec2be.1785596451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Anuj Gupta <anuj20.g@samsung.com>

Rename the blk_dma_iter based nvme_pci_sgl_set_data() to
nvme_pci_dma_iter_set_sgl().

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/pci.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5608ede6c479..7b8ed101a13b 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1287,7 +1287,7 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 	return BLK_STS_IOERR;
 }
 
-static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
+static void nvme_pci_dma_iter_set_sgl(struct nvme_sgl_desc *sge,
 		struct blk_dma_iter *iter)
 {
 	sge->addr = cpu_to_le64(iter->addr);
@@ -1317,7 +1317,7 @@ static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 	iod->cmd.common.flags = NVME_CMD_SGL_METABUF;
 
 	if (entries == 1 || blk_rq_dma_map_coalesce(&iod->dma_state)) {
-		nvme_pci_sgl_set_data(&iod->cmd.common.dptr.sgl, iter);
+		nvme_pci_dma_iter_set_sgl(&iod->cmd.common.dptr.sgl, iter);
 		iod->total_len += iter->len;
 		return BLK_STS_OK;
 	}
@@ -1339,7 +1339,7 @@ static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 			iter->status = BLK_STS_IOERR;
 			break;
 		}
-		nvme_pci_sgl_set_data(&sg_list[mapped++], iter);
+		nvme_pci_dma_iter_set_sgl(&sg_list[mapped++], iter);
 		iod->total_len += iter->len;
 	} while (blk_rq_dma_map_iter_next(req, nvmeq->dev->dev, iter));
 
@@ -1502,13 +1502,13 @@ static blk_status_t nvme_pci_setup_meta_iter(struct request *req)
 	iod->cmd.common.metadata = cpu_to_le64(sgl_dma);
 	if (entries == 1) {
 		iod->meta_total_len = iter.len;
-		nvme_pci_sgl_set_data(sg_list, &iter);
+		nvme_pci_dma_iter_set_sgl(sg_list, &iter);
 		return BLK_STS_OK;
 	}
 
 	sgl_dma += sizeof(*sg_list);
 	do {
-		nvme_pci_sgl_set_data(&sg_list[++i], &iter);
+		nvme_pci_dma_iter_set_sgl(&sg_list[++i], &iter);
 		iod->meta_total_len += iter.len;
 	} while (blk_rq_integrity_dma_map_iter_next(req, dev->dev, &iter));
 
-- 
2.54.0

