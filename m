Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABF62E613A
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 08:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318820; cv=none; b=ZC8RUUZZogmqgWLz9JcRjLlr+BGWmqMr9T7qHErbIwHxE8VZYE3hVP3OB1WewrfA3gWXz3VvAP+Nz+/vz6TW5tJ0McMowBQQxDLAjwB2E88Iumts+y2pKO6XYdCPbb46JCEI357vYAFd6HlATIWYx7amdwTgfWzUG+T4LRoAQuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318820; c=relaxed/simple;
	bh=MIUxfeIlXsLJb7D1x07khmxiQaV6FMQZLzsNI6cDMOY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i9yCmWbqag1/LLyUbwLNsM5naAeHwtG8nQIQpkA6HIttF9S5tWqGNT6zBbwxZN20pJWPgJ7ejCcLD/43kFDP5oCc/vRXxjsWieGfnN5UslmIt2hv9641fr/c/qdUbFR7x4a/qMO34lWXHvd1v6hj4iOZspK+YRh0Dj8Y0t6o52w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H97JsPo1; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H97JsPo1"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7aae5f2633dso1828376b3a.3
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 00:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318813; x=1764923613; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZsPDOjyUTRUehf6LhbOb026Dy93eapwVzPzgOc2prg=;
        b=H97JsPo1LV0dEJ3lm1aMvcWUzzRN9xS2cObapnNjcpA3VW9LbbgDmGMoiXLcZSoOpi
         JRyi7/VdLgs1QpfW5b1MEZ/EBaO0tfnwAIvAiGSEgI2SswH5RYqc0VhsC+KgeqS551bf
         1h1Xjso8J8yvtkuee3N5VTm9s1bFBoccdp0eflPRPCKijwWPPWmMG8KXmCS3pyWOpUgE
         D5q3O/GV5lK4A48yOVngdFyx5xRn1nriqI2bl0shQdRBlnlfZDx8jQKHjfqf/1Jm8vut
         2G93wRuffSM3+xsXnwEm4wTAZEAZD5bLOgCxvdtgEHYsDJTm6eln9M8RGVKPNqHhoVLG
         X/7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318813; x=1764923613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rZsPDOjyUTRUehf6LhbOb026Dy93eapwVzPzgOc2prg=;
        b=OeVkslAUIaUW2eL/SIX2qiHX1z9tZ3EfURGSCe0vrMWOaFBgSV6u5lYpe6mt28QVND
         vA3VflqSPyRXIUycxM3PJYQ7M5ejPYiYTGHa4XVYIGSXRVxjFDA5ae88d1QY30/DTYoU
         6cvxBYaUnRWgwrstzqSmWBRsq9fb1nKrsUdBiAIXzVMHAeCuTbZIERm4r4JNAS601Ru2
         zIH3vyiP2CYi0GM1gGYrgeKYE+AP6fr8soXFhSoCsSVlc/f6sEmMlidUkYCNrd6N2dVc
         8lOZruc5xwDmH2qRZTT+mvdMgFltggBS76wHWuLk7iskqXdeVsCk1B98/goZL5PXQ/7v
         Yiag==
X-Forwarded-Encrypted: i=1; AJvYcCUZYwK3N25Gi/4YQmf/RMry+IaP0mGmPpwFzzuJU7xX9sgQpJd+v32lp8g42zMSWxJJJQA6Taw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdwIJT7R442278AsPrggNEpgs/IrzJH2MQvV2fFzjZUva1oZIO
	O00bkDkFWCp0zTnPKcKVt4Z8kxkwkw/fTrACjeWX0Wx6AmWX5xm6JuSc
X-Gm-Gg: ASbGncvKsYdRTgZoS+/KJaAL4YtR2XA4XnHNyccAw5ZzamoQYapAnFxd7CfGoLkuHte
	7Gjtb8q1+VqvBqD3sEWHEtSxi6pVR4gwfm1y0jJyw6Ab2+4gwvojjHblRb+AE5unCfG2wpfgylF
	cz9ROoGFcZhmmP5kTX1Hq9MwYhAcD5Vc2l0MDX4NbZnrgJ57k+DUDuIHEvHjTsTx7arxUwL+wXX
	Pn5v4TssStDvx4fursIos+XYqqitdg2M+HLmUFqykq4I1+MmfklUs+tTL8gG1FzY1haGVfuzBnx
	d3tW6qoGWDWcoPjmshY5q8GwnOkTWxhytDfdblohhmsVIs5QElaPjV25u0F96TUi062cx/ggOnH
	XsCFWTeDcAnHsstJQlPU4zUXenXi0DZISg9MiBQB+aerzN96c//w1C9ipPs5gUvumffgMOa7c0M
	hLTPfOXZnSL3ADUsirNTj+3iwQPW17lY0eG7fk
X-Google-Smtp-Source: AGHT+IHqHdLof6s224+GbtnJAk22/n625R68t5gW5XXJrnH8NN05gDy1A3OVkHY/4+FwyWeG7e9t0g==
X-Received: by 2002:a05:7022:3886:b0:11b:9386:a3c8 with SMTP id a92af1059eb24-11c9d867ff0mr21572562c88.41.1764318813388;
        Fri, 28 Nov 2025 00:33:33 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:33 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	gruenba@redhat.com,
	ming.lei@redhat.com,
	siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v2 11/12] nvdimm: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:18 +0800
Message-Id: <20251128083219.2332407-12-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128083219.2332407-1-zhangshida@kylinos.cn>
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/nvdimm/nd_virtio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index c3f07be4aa2..e6ec7ceee9b 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -122,8 +122,7 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 			return -ENOMEM;
 		bio_clone_blkg_association(child, bio);
 		child->bi_iter.bi_sector = -1;
-		bio_chain(child, bio);
-		submit_bio(child);
+		bio_chain_and_submit(child, bio);
 		return 0;
 	}
 	if (virtio_pmem_flush(nd_region))
-- 
2.34.1

