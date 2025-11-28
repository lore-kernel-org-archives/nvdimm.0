Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9466E2FC871
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 08:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318801; cv=none; b=gJHjbu9Mrh0pUWX+rlAdf8vtR0KmlvmjCHhcRUk9uWAvWNi6zWjMXwnPujnGuz2Vu9ObWcdX57CAwvXbiXEqMl1LbnmY1Atpn9mUUnUi2Kq9NPZquVfcZcsZwctfyrb1EwXE2lrO+GCOoGN5VZre39wLeoleQPJxkvce6Fd78AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318801; c=relaxed/simple;
	bh=Hfn+I4xKib6YHUNH+g6fjmCyECLvbavw8yPYoNL/5CA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dijvbtkWhee/iLK7CZ2nLB+tT+qSoh1/i6vAOfqvRTZFV+LEsBBjxccurF9tV9qWKrlGM6dAC9F07wec1mc++FKg2CVp+J2QevV/vzLUtORUfGr5ImexN83e//nq681A9iqd1ex+D8BjujspUCdd48PJpwHF5S8tpsnsghq3O0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E0aOLTiO; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E0aOLTiO"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7ba55660769so1359805b3a.1
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 00:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318799; x=1764923599; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdyx9mvaY+8x+eK9XImqi9TsYLR1v6CaCbGe/GD/N5s=;
        b=E0aOLTiOgeQw15qD+0lcu4SBgBMtSbwysfU6q8Elgic2p5citmMT9WtnTZU+exM/zf
         P1qxw9Hcsx4VPSUXKUAlJCd6rENwT+126hey4N9kTiGiM4rVxi2W4G5jzKuJgaybWweO
         BgKPYGZCxMno2xm+7DLIjhKtttyZZjpP439fUXOdNyQfOo/sTffV5ecd/mfQcsexYuXo
         fhIwOmGX4kxVJIqeqmh+K82VpTm4UrfkWuCL03irGEbeMfoK4vw9at5yDziodT4EG1LG
         fCmyYvMUjUoFO1XfPd+qGYSYowoDjij+HN7BxGTh2VMTfydt2qrTFpq/AxGdhPJDnRCW
         qs1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318799; x=1764923599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vdyx9mvaY+8x+eK9XImqi9TsYLR1v6CaCbGe/GD/N5s=;
        b=kgbNOYJf4qVmicaq9n5E1fbC7JwpzVajF1PM310bhKRq15Xw53SNd2IauexOZUVUyj
         srdhedSxtGUmnFVhmW+XFA01tyOrbp+wS4j8oO8VLk1xPS57IrtUVLwzuiSrvEsEl5rc
         2xzFPUQm3A6K3lF2MUf/kbpQ+bGPde0ELljaZD2aYtDy5uE4WflAVaPQ9J23YflTjra0
         0M/W62YZYgCz7chivkF5zqiO0IudLNiHpSTudDPXEe6FXhaFMeqsmcSQnsb5rqx+7fuF
         yxwS9WGb/Y8plCU5+l3jDSwOxMgLl6pRAy1elPkucu84zYSyCHslte78Hpk574bVbq8Q
         mTCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUn001ZQe5M5I7OXZDM5Zz8O5Q08JKLDfd/Lvw7RO5GdKqiJP/AcvrzCx/4JiafPlGpRd8ZpQk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxf0DPbE1MtoNJWFygkTdRZvdzBKTHe7E8dnn7xCs5yJE7RKBQ0
	SyMEYB8nmfDozuvf0zveyDxbQ7gzifQYkC++ZUTujbpKxjih6FfpLVkB
X-Gm-Gg: ASbGncuhJJGozX5uTyjU0X8EBFKAPkwHT+jjKYvlFdpFP361QyMkgIs22b14VIRO0Kt
	682xedv7YA3MUfzHG5sPiaL1At4uu3hWnkvgbcLWRjJjZrb1TbMgNIprA4qqgfpOL2vBF/B5rOC
	+UauqoUecxw6nQWrlS4evwz3XjrL6lSIjnTgal5oABp2K/Vm3sRn96X9o/GbdLSVSlYsODhfiZ3
	favbrBeOkXAmeNGIVwYoLrnxOirrn2z5ZZ8CL3xGQpQpqr3nM2e0zSXCRzISKZ+Mh3VyVJ3+neE
	H66cDLZWO7/sKACQDkHkVOuOksc/a5MmBzemiylg+jE4fB8zL5TZqWbdh5bCUY1Owh////HbLPl
	NaShNy7L1259Q3XCCyut8WckKcwl9v4dE2zyKGtN7dKHoD9XZmFbtZ+zyvCFvM/zjDCwj9Go1hC
	m7uDJWybD7QH5zCdHhTprj7lB9KQ==
X-Google-Smtp-Source: AGHT+IHKXq8x9elSCjEHks4N7hQUevj8WxDVP5HKi9llAEtlIQFfHNb05BLq+B1Nz6uA8fi9DHZiww==
X-Received: by 2002:a05:7022:671f:b0:119:e56b:91f2 with SMTP id a92af1059eb24-11c9d870411mr17436186c88.35.1764318798796;
        Fri, 28 Nov 2025 00:33:18 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:18 -0800 (PST)
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
Subject: [PATCH v2 08/12] block: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:15 +0800
Message-Id: <20251128083219.2332407-9-zhangshida@kylinos.cn>
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
 fs/squashfs/block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index a05e3793f93..5818e473255 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -126,8 +126,7 @@ static int squashfs_bio_read_cached(struct bio *fullbio,
 			if (bio) {
 				bio_trim(bio, start_idx * PAGE_SECTORS,
 					 (end_idx - start_idx) * PAGE_SECTORS);
-				bio_chain(bio, new);
-				submit_bio(bio);
+				bio_chain_and_submit(bio, new);
 			}
 
 			bio = new;
-- 
2.34.1

