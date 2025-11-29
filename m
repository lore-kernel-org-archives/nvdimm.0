Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29522882B2
	for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 09:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406940; cv=none; b=kZDexOZUD5CEd2fTV3p1uYo4qK5BEMMPBdRPH1kk+90hvoLdqNSHQTpKqiUPlA33nkHpfc8qc7vrhx39dYTrMGCqWmWLm8zrBSuX8Hts4GLwlwIJADrJgaRzPgMKVW2V1vkZUktOim9+/1mxJ64l7DHy3D4gEwerramq9nJ/nig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406940; c=relaxed/simple;
	bh=MIUxfeIlXsLJb7D1x07khmxiQaV6FMQZLzsNI6cDMOY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EIX7S9zsVhKzizBpEptHkyyZM45oL9XHk0W4GvFY0nXthJyt92DuFU18iWKcriZckMvIbdnsuJ3yHZERSjw3eIuWO4Ex0dwrXlWsFZzN1gSyxqCojZ88BQop1TkH8UNafdLfneoCnWBjAFS3+RUNQGh55FJXOwKzLrLvyVASSSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=edi+kDxG; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="edi+kDxG"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso3025916b3a.1
        for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 01:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406937; x=1765011737; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZsPDOjyUTRUehf6LhbOb026Dy93eapwVzPzgOc2prg=;
        b=edi+kDxGL0EMaI7WEOHwrRf20vjVBAODQbesfTsti9d6+1PnbxAjuFVoQlfsDaUA7v
         8vQC5/gP0i/p/g54odY8ktSzYcTWbyQ4ufIH2/ufRm4cJtLjObAiDV9NYbgnx2EbTI4D
         I5B2amzXsL07OPTtxp893JNBq2fvQYAhKYi4XXEuca3FBQ2sQqBk4q8JHVwAttDELUSz
         818gwvr92RigWMRoI+iJr0PRxSzXTLWBJojHFGencsjjwVgGzf4sf2roAKwzq3zb6Lzj
         RoTy35wLP2pes7bHvZAfz/j2097jGvuVYMTeN3Kxn06BzH6zt5ZUweqlQfVoqAfwm0cK
         tkHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406937; x=1765011737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rZsPDOjyUTRUehf6LhbOb026Dy93eapwVzPzgOc2prg=;
        b=Fbcx6RT6TGzdZt1HW63g6//bLp7RezpXPDThZVLsO+VVihDCMrV8JTF/EffqNRGfmz
         sAhIy58r121wdfjuvinaqNrX1lT90pF5UdDAo4lh+V+oomB3P9C1869YSAWHr/auY0a+
         US9XGjmqBDdRl3Q31WcveH+ORcsrhr7xntjiYwusmk1D/1cfSZENhEaRYh9YAfE5Vo5L
         Ss1QBcuVlrs9DdhMCRzeGLuYJRAjINvCHbCWTkk/8zU/NCmEdsvUQu4EAJDSZwnkBRMJ
         JNrJVzQ11OQ9ebyAGEXholgpoK+uHGp2YSwLQQhqIs+b6kx4jtHWycR/vuJdcSID5P3s
         FVoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTuJDO+OzG9yp72X6kqHnTuoS3bf+YWE+mvIGLXgaI/9PSWQ2WtIuxX+ltEX6Htm64qlIQ87E=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmKceQj+iQB8PydNJ0siJ17WMmubIQQQa3XC/nHxlDEvITQisS
	cL29VmDw5r+WEnbj4oOulqcMY00Ucxz6aT7RKQp6HV/Dlj45c2p3JgQf
X-Gm-Gg: ASbGncshwzTSY///bZHdeqaakuW5+Q6tEwx9Ntju6yPnBBHVjhWzUytoJTFOT8jB7rB
	ULHKK8AYbwk5vaKMopNWqmjyd/UQ7X+ax8Co25qUCvZLI/rjwHEZpervOZDV+fkCbFCZHVZUhgK
	j86fsbOqwVxreWL+jrTCY+ljb/dwVH/uFVFxQBlON0gRrM9NlBv4FquAcGqbMSiuv+6hqkUS5z0
	o2IkT9zimpjUnQ2D5n/Hl+2YmCPn5/KMWuZqKLyr6vhgeJQTtk32TVeYlSsxsJ4bxQwTodl7dfm
	C1o+WZz3g2+HlxgEbDUmxGDWumlpu8zXQo/YxkvyHKxHSus09Mzz+Fg6XMQtWOsZs0lELr/3YDz
	9fdXqkSzNfODrC/fj8lZ57XQylcLUMLnoeZwTDHKLFj9MmQz42tPaSCkeuiq7GVG62MqLC7BSSz
	KTI4gnNLq8a/ZaRMCfrMVzw/6u7vBovWF7fd/F
X-Google-Smtp-Source: AGHT+IHpE1uuYkahAmmHKZA5JS6JfSHwBl8orO/VCsXf8iMEXJ8J7PutjW87+hKd6ib1GUoYGhEBPQ==
X-Received: by 2002:a05:7022:41:b0:11b:b1ce:277a with SMTP id a92af1059eb24-11c9d8482b1mr17984181c88.28.1764406937164;
        Sat, 29 Nov 2025 01:02:17 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:02:16 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 9/9] nvdimm: Replace the repetitive bio chaining code patterns
Date: Sat, 29 Nov 2025 17:01:22 +0800
Message-Id: <20251129090122.2457896-10-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251129090122.2457896-1-zhangshida@kylinos.cn>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
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

