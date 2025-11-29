Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BA622B5A3
	for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 09:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406899; cv=none; b=iFF8xWz2Z/1FUTO1fpT/acagYY4gAV5qyNbL/t2D1xIHw4/P8U9fCYbu6QkOH1pFBJrX2Z1WrX4tJt6jC3RQN2W8Ppozm2+VfmhCwkfd84jSLcKg9k5utBbVLZchx7JJlhNUmjMU2XblTzWGZvdh9TQ2cccDLMZqYP0x69cyuDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406899; c=relaxed/simple;
	bh=udx+3WBqGc/iZ7as5xnrvfqI/p1WkcIHAta6MoMWPi4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tYLxFMuBZqTn+lo/jDQKsjceGwQktVJpYTfXUvAaHOsRg/AEzUo+4OXHLt7FxXSLPTNpWj0aHrkxnRmfBEbps20xoiMF1p4+dC7vCFhSUFz6cd663TXTp1HPfn8OyYi3VzyTKjb/o5ohbftphKVKrkfr//QpCFfNGtlL789FZs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eMzu9w7Y; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMzu9w7Y"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-34101107cc8so2417096a91.0
        for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 01:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406895; x=1765011695; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zmb+ZHVry5p28b7GMkq+CDhLkRiYxaAasQNxk151Gb4=;
        b=eMzu9w7YhiNUOGW2+D9JlpGlfaeU1qODSV2VJE64HcWPXEU+DMlpD5upTnHsEZAyJL
         /LuzpfLqRgF3t/vO+IPdfxTQ96MmA51A5l/fgXBCASGksc4JvTwfFuwoGVu1aiQmYUHW
         KB0S3PUkPMqAUjU7NiImWDE8ADY5U2+lhHKL0Q8blvukWYhDSearr4Tc5VHdf++DYrMw
         07mZeYLjIZjrn18wLNcyOAknXZ1roBTF9J2u0ewu9j41PqG+glxkMyMF0mBXWc/hUgih
         1CJrpnaa70n43c2uKypgyfIYlGhAgE5XbMTKQdsjZFMFWi+KJmQ7WLCyQS8P1zZeYCGZ
         A60A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406895; x=1765011695;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zmb+ZHVry5p28b7GMkq+CDhLkRiYxaAasQNxk151Gb4=;
        b=BI0G27ORbZjbtyEwPcSNyRBrv0tpxFpgb9D86s3EZ7K3wIrjWyuJMIBtCRPXWU/JSf
         ebOL1aByAtUWHpr9R0b6i8mJEYeJ2D3R9QdCE3WicPA9vYGV/RpE+Oxaw40pSv8RQ5vn
         cbf0ASv4TwXf/FyQvPL/mzdNaJzYWn1poMeZESrfsaXDj4xbKsYKhXud47Ovkmu+J3w/
         2PeEm7powRmmC3N9opBEx9v3WwhYFw3mzQC35PQWC36OjUv5DAzC1/AXahBuER7NCn7r
         /0nNuNfl4CWBQzgaYFIzfy8kL5XqumXFVzXYeU+P3Bq5RD7lO3raiCefkvrZJxi4dJrH
         WWmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSJqRFU7a4ZQr0TW69n0P/33ajcThdbfNoFAMQIPpPSSCKi99x0MaOfOa1/p6iSV5+VucMxUs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyyk1bl0OOd2NvibAYADE/EP4dWrEW8wgxRfKQx8Dsw65SIG1Xp
	sth3H6kDLdJbwVqYlP7OnGovqz8Vf25MBu+hQ2tDUrIhlWkvwSFocfXG
X-Gm-Gg: ASbGncs6y/oyaUjrQ0rJry9EVFAFQOt6MKWCfzK8L8YFXdYStuM49vcwoBERof00Rvm
	qtau/Qtzwgtk12aVDaBEs6Qgn6M8YsP262VCwePDY4cgyA6DJ2gJVA2PRUfy4iOT5g8COTu53cR
	7RhqrFYIuotIIpm9yfW+2hnIbYq3uX2Kdm727KkwOvkBl5rFuuvfRVEBjnYaSDWelqpupocrGkx
	BdlCOKSFAH7pgV1EqWJfIpGQOUKZqNzKHvstHHOjMvl7ll2QIndYWc1Iv5njHTpmCwds57TNi/Y
	P5/8BeYoEgXj1ilbvs0JWVZqdgeS7fib4RyGI3wnFT3r2nVPOlHw1QHEBaj12ByBw1boCfF8QYa
	pf7a+EAmBxLK+K+b0gETTnZVJpi392u54yft3gwNj0vZVa5fB3MAa6kkBPSCeCt+R50euB8GDb+
	5k+Z1BRtwtgfprkRmhniE965ZLhw==
X-Google-Smtp-Source: AGHT+IE+fzqDQu1/Vmc8yqQsUeHiqyOOoex9+WFx6oQ8MiOIB4Rr8lIb32V7wQkpFMTkrQakUPAF2A==
X-Received: by 2002:a05:7022:ba9:b0:11a:49bd:be28 with SMTP id a92af1059eb24-11cb3ec36cdmr14203629c88.4.1764406895410;
        Sat, 29 Nov 2025 01:01:35 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:35 -0800 (PST)
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
Subject: [PATCH v3 0/9] Fix bio chain related issues
Date: Sat, 29 Nov 2025 17:01:13 +0800
Message-Id: <20251129090122.2457896-1-zhangshida@kylinos.cn>
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

Patches 1-3 fix incorrect usage of bio_chain_endio().
Patches 4-9 clean up repetitive code patterns in bio chain handling.

v3:
- Remove the dead code in bio_chain_endio and drop patch 1 in v2 
- Refined the __bio_chain_endio changes with minor modifications (was
  patch 02 in v2).
- Dropped cleanup patches 06 and 12 from v2 due to an incorrect 'prev'
  and 'new' order.

v2:
- Added fix for bcache.
- Added BUG_ON() in bio_chain_endio().
- Enhanced commit messages for each patch
https://lore.kernel.org/all/20251128083219.2332407-1-zhangshida@kylinos.cn/

v1:
https://lore.kernel.org/all/20251121081748.1443507-1-zhangshida@kylinos.cn/

Shida Zhang (9):
  md: bcache: fix improper use of bi_end_io
  block: prohibit calls to bio_chain_endio
  block: prevent race condition on bi_status in __bio_chain_endio
  block: export bio_chain_and_submit
  xfs: Replace the repetitive bio chaining code patterns
  block: Replace the repetitive bio chaining code patterns
  fs/ntfs3: Replace the repetitive bio chaining code patterns
  zram: Replace the repetitive bio chaining code patterns
  nvdimm: Replace the repetitive bio chaining code patterns

 block/bio.c                   | 12 +++++++++---
 drivers/block/zram/zram_drv.c |  3 +--
 drivers/md/bcache/request.c   |  6 +++---
 drivers/nvdimm/nd_virtio.c    |  3 +--
 fs/ntfs3/fsntfs.c             | 12 ++----------
 fs/squashfs/block.c           |  3 +--
 fs/xfs/xfs_bio_io.c           |  3 +--
 fs/xfs/xfs_buf.c              |  3 +--
 fs/xfs/xfs_log.c              |  3 +--
 9 files changed, 20 insertions(+), 28 deletions(-)

-- 
2.34.1

