Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE192E6CC4
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 08:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318760; cv=none; b=IP2pVJzp+AnXvV8Uj17xg+64ooeK2viiGe+yxZVMZQxPtsxgj8E1wSiH74berffeIngBTEuTo3c3/Cns+RXSG8VSakugoHuxh0h0yS28QT3tppn/1IHNe6He7jc0rayTkVhMbO1bpZ6/h3MEaJzEH7+K8nKxfdidQdtpg8UFZGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318760; c=relaxed/simple;
	bh=nXmk28ARgCcn+VciidQA11ELnwMOW79oTG8rwah+rkY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NtFjSKBH3Hh7n5D25VT5sJxm/fmN8BNHRgFl9xRR0JdXJtFG76hztCLS7QnlRPrn6as4VBV9rmFNMoZGHtvx8u2kJByU74T7NujciZ/ReYZIIWj/aHe8FZJc1mb7scBvVype3qHF7NawBEYVNaNJZUyoxU4PFUvkxtROir5mkvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jUH8Kl5y; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jUH8Kl5y"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-bc2abdcfc6fso995137a12.2
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 00:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318758; x=1764923558; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NqrU9sAvwHlZJQNnImTr6s/wIfO8kcl//WUqMA/q7Cw=;
        b=jUH8Kl5yPbTHHmA8UhMI+1t5T/al5pZFyH+5kVWeLenfkKBtm2F6xkjJNrAiFL/qsJ
         G+tIkwkrreNF6FQCMhzcIGbd1kYEGeCGZVSmuT/AtKRQGe90kv1bnnt+720s+Mdj/Xvw
         dchkgOzrBmpfmRoBQUMlbwjKyZW5Ywap4VAfD71m0LTaKNHpyebv3nvwkIYakuPIbQ/H
         w7dF6XBScFFC5UxFPBQXxp+3+t7RX0w56csB1ZmRx10xm6NeHrxZLdvBPziqAmF9VruJ
         NquHmq8+Zt1XH56rB6TZxBnxIojG2LBj2np1sWQ2C99q2azy7ADhHZ9XY5OgWvSeRn+M
         tVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318758; x=1764923558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NqrU9sAvwHlZJQNnImTr6s/wIfO8kcl//WUqMA/q7Cw=;
        b=jlVbJ7JLEVqO/q8nsNT+SSamCW9vjWb1mOgkh3e/4IsPFBHK3BZZE22ljZCq7eJ1uz
         7dCsuxS6Nf4v6qWx5CCZNF4TLVDG69LVOkN+QT1PvrLPlwunbQM5Vf95gNy6AIccjRRq
         iwKWAxZwqQxn9lW9MWQOriav7fTizzNSfzaY1rhowx6s+ZVOvIVIJQgn6Q2PCL94VO9g
         HDRx0ej4+BxX5hOaVLrYbAB7p0GuLoGCCfjgfjO+fwolup02G1nWw5H8ts2L9ofVZlRs
         FQeJ76IGXJGmlBiqyHsViwpmvGFfDg659g6TkczMWIByc9E3N0bLnRdtppjbY36gf3zk
         f7Jw==
X-Forwarded-Encrypted: i=1; AJvYcCW0vYXca/Y43zB/fuUz4YruTeXMu4T6zCfv77NiGG6iOV6causf+PtWONGpCrXEa/WbwvH50B8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yytg7pNmWU6cOKQSi12VFM2YQ5HR5C80B3LL83c18MxzRRW1cWU
	qgYLJkOj6JbcjcwJbrUUgqKQ3k9NP/y7q+KUNw4m+qNohOISkC4t9hW+
X-Gm-Gg: ASbGncvh7OneeEokWfE1N4K2LjutUeeEQsgfG9KfCIgm2hOX82j9KkxFzYIqBOoZJMR
	kaT7qGtgK5CcUvXJdq+Vvz+MoKV2UvfjnyYEGPwZBta/X2sRJ0/bcymqWqVNB6Ty5694pSMevjJ
	rYFx9V/QPbLy9gHz8FBTUsPj8JLdmChPLf3yVNkCFjR5/qXORz3A1FB+O7y8fg3vVV6gWSYEBOM
	r70j1e6Q5Lw7SOWFLu8TwkijdXF6pZ2oeXzOblDkomUdMs+IkV9T0cOpdNdg3rFd93yN5TzgRoT
	uNI6l9nz0IvtjkM/PmQueIbaRm6AouCqih6lTq764M4esQZ1u/+IYBo86aJ0B1CD4BPY0a/MX4s
	l4iW+ENxHYr9qsD7Gi1buquBIPPoAfXzi61kc8D3hpGcLJEGWUYtIGUfMnBHLZ5vR8YZjS9BYKx
	9gRXar8IkMXzijuTgvm9kjklpKQQ==
X-Google-Smtp-Source: AGHT+IHdakmTE4ccsFNQ1yLU+VXJurH34ar1nC0le8zm5bpThSihG4vDxPqEawqzf6sYQkBphfQIBA==
X-Received: by 2002:a05:7022:ebc2:b0:11a:e610:ee32 with SMTP id a92af1059eb24-11c9d85f282mr16086363c88.25.1764318757636;
        Fri, 28 Nov 2025 00:32:37 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:37 -0800 (PST)
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
Subject: [PATCH v2 00/12] Fix bio chain related issues
Date: Fri, 28 Nov 2025 16:32:07 +0800
Message-Id: <20251128083219.2332407-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Hi all,

While investigating another problem [mentioned in v1], we identified
some buggy code in the bio chain handling logic. This series addresses
those issues and performs related code cleanup.

Patches 1-4 fix incorrect usage of bio_chain_endio().
Patches 5-12 clean up repetitive code patterns in bio chain handling.

v2:
- Added fix for bcache.
- Added BUG_ON() in bio_chain_endio().
- Enhanced commit messages for each patch

v1:
https://lore.kernel.org/all/20251121081748.1443507-1-zhangshida@kylinos.cn/


Shida Zhang (12):
  block: fix incorrect logic in bio_chain_endio
  block: prevent race condition on bi_status in __bio_chain_endio
  md: bcache: fix improper use of bi_end_io
  block: prohibit calls to bio_chain_endio
  block: export bio_chain_and_submit
  gfs2: Replace the repetitive bio chaining code patterns
  xfs: Replace the repetitive bio chaining code patterns
  block: Replace the repetitive bio chaining code patterns
  fs/ntfs3: Replace the repetitive bio chaining code patterns
  zram: Replace the repetitive bio chaining code patterns
  nvdimm: Replace the repetitive bio chaining code patterns
  nvmet: use bio_chain_and_submit to simplify bio chaining

 block/bio.c                       | 15 ++++++++++++---
 drivers/block/zram/zram_drv.c     |  3 +--
 drivers/md/bcache/request.c       |  6 +++---
 drivers/nvdimm/nd_virtio.c        |  3 +--
 drivers/nvme/target/io-cmd-bdev.c |  3 +--
 fs/gfs2/lops.c                    |  3 +--
 fs/ntfs3/fsntfs.c                 | 12 ++----------
 fs/squashfs/block.c               |  3 +--
 fs/xfs/xfs_bio_io.c               |  3 +--
 fs/xfs/xfs_buf.c                  |  3 +--
 fs/xfs/xfs_log.c                  |  3 +--
 11 files changed, 25 insertions(+), 32 deletions(-)

-- 
2.34.1

