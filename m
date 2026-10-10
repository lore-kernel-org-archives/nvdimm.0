Received: from mail-pj2-f5.google.com (mail-pj2-f5.google.com [74.125.227.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9D31E8332
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 07:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791616503; cv=none; b=F7hDN4F5LJeTQUP11YqQHJQ6/PElQI/mXK3wvzfOn272bLwGV7paqdJkMzr0G4L0J4NAGuaAznz7KRdRT0ha5gn8zM7/1GU0d86zvwxuJF/R35TROXC9l6q7/udp0DUUBWF/w+ahJ6JOFsj57R7zIAY81cWS6ABznlL3OASR9Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791616503; c=relaxed/simple;
	bh=AgqPawQLsHErmF3nORcLRMqaINWXlnncdcFbCC+PyuM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GL4EY9AWeC5W/tDhTMBWlEOfXYg7jpBFGMddKh2b71X4YdqhB4YVudg71xXIMq8Nq/VYstb0fKezATIpiIVh4Lc6iW2KC05D9Uotz5i1xIJLvIFXn/SFVVFPK6XIzvbK8GRNLQfqQoGRWXvYW1AUfOoOi6T446UPqeUjT80odFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WQ8ZHSGL; arc=none smtp.client-ip=74.125.227.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WQ8ZHSGL"
Received: by mail-pj2-f5.google.com with SMTP id d9443c01a7336-2e7c8213b09so1576645ad.0
        for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 00:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791616501; x=1792221301; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=959yGHgkihQFutwKGlb/mZ/n3GWGE1NHJJyd2mFaKLM=;
        b=WQ8ZHSGLDClAOO0zWEGTvMXcZrFY0OMBYkB2kkumHB1DzLu5WszjvcG2vf3ETUPNnJ
         55RCSGWj3J74pbMN4lYhOdF6tdC5CMsPZlnnOiePZHA0UHh15bMhPyEgVCWo/onlm8QQ
         ypY5+BnEDH3kuUzrmCnmvZvySU4hD+Egg9H5tkpx2cFFyDSVj2Xfj0CR0GKXKO7Ht2Wq
         NWof1jROE76FpZBad7vlZHSQn+AlEIEP30jxYu8leSMbKkXT9Yy8MoVwWbhtBpuh5ICB
         B/CbqxnmVjf/B2mssIRWFA0L3IsHkhxHlt71vzj9lRO1QdM1VOhqsVN5miYNHY7gG8Hm
         zZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791616501; x=1792221301;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=959yGHgkihQFutwKGlb/mZ/n3GWGE1NHJJyd2mFaKLM=;
        b=APjAhoqw2Ft6CO95uwJTrKd6UdGuxvhJf9kBKnZzRnJfkGirtnZ48CkGss8X0VZaxr
         e79p6otX7C9H2GDSxeMnVAP5kRsgoELa9gvJccDkads8ofQ7sFclX9Zbi83NNIJIvpUz
         glkSx12Pmf6Wpiuvi9LKctwDB5smMwqsIu3bfJri4SIGFacjGugxE9Piy68+FREcmq7x
         ryA4WAbPdB9pJGp/qB5YS9qRT4aWaXHP4GHMR6LKa/d11YVG7ofXoqP8cZa4XTlRZwNh
         oqRseof8XAjD+H00vFqhU+Yy6iRF/m0jDZVxl/dYwHM6pr+3qAxSZ9204wkf4Q1dRX8B
         HR2w==
X-Forwarded-Encrypted: i=1; AKwUvBzICGQ/kNaK1lZWh4Rhsm6p4Uo5hHIHfTa4Jx+4tFKKT3C4zNuv9hIp8bseG+Mtx47QTpixy5M=@lists.linux.dev
X-Gm-Message-State: AFq9FYKAbMxYwOGPFG4rgUm4RFJHTEFfuYONV7I8HinEZL83+ExLqsE1
	QLNHPNZs2x9Pq95AoUudhpBHfXzHpoN5yY42e5j0/OBMRmNsILgvcXQZ
X-Gm-Gg: AYBFou3C4BRaHCRzWijSiKLnjYl3IxJkXZHj7aoliXwLNpIqO7C/NF+d4qWz4kOomhq
	Vya7g3QFMC99rHNFQXJwUTJSWI8TldDfTdN8nouRRwmNviWYCB0U68P9k7jWyUG12uqsMROVvMB
	IGBdA3e0zHDL7R/sna505HW5dQXXWDtvMOCrt9/FL/AGkz1J41YumhOwBvjnji+hdpL8M3hFfH8
	+RLKXssHfpKgA8clDwozgl8MSl9RnB9YybIdFGyDMftSU7pOjrBgkrLgrB6w8ediqRhfUmabLEy
	ZpdGn1GEqrWemfLmMRcpHYUsaZJXbvhBARLaqh9pp67+mZs4mgP4pZCvEnqKnFy8L+DFfca+cNl
	zqCU2fF/moLbsysu58hIsm9o9379Fap6wYDU2xBfbmKxDfvMGcn6IFbdCjxTWDAbopPRdDsBe7p
	/B5Yf2n85LDh3wNSqlCXye2cpSmAxCF3hjHq1LxxobKl+ASmRxPVxxy8+O2gpI5D0jEUg9XpdQV
	NHh12/g8MA7h5gG1cLN1vheijDqFGnw/R37oMXHroe2tXufVjpdr6tcH+3wKVQ=
X-Received: by 2002:a17:902:e88a:b0:2e3:1776:278f with SMTP id d9443c01a7336-2e842bcd141mr39945135ad.42.1791616501197;
        Sat, 10 Oct 2026 00:15:01 -0700 (PDT)
Received: from localhost (ec2-18-183-150-125.ap-northeast-1.compute.amazonaws.com. [18.183.150.125])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b15ffsm20468025ad.36.2026.10.10.00.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 00:15:00 -0700 (PDT)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	stable@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Goldwyn Rodrigues <rgoldwyn@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and infrastructure)),
	nvdimm@lists.linux.dev (open list:FILESYSTEM DIRECT ACCESS (DAX))
Subject: [PATCH] dax: fix wrong size passed to dax_iomap_direct_access() in dax_range_compare_iter()
Date: Sat, 10 Oct 2026 15:14:53 +0800
Message-Id: <20261010071453.6028-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

dax_range_compare_iter() passes ALIGN(pos + len, PAGE_SIZE) as the size
argument to dax_iomap_direct_access(), but this is an absolute file
offset rather than a length. This causes the underlying
dax_direct_access() to request a massively inflated nr_pages via
PHYS_PFN(size), leading to unnecessarily large access ranges and
potential spurious -EHWPOISON from driver badblock scans.

Fix by computing the correct aligned size:
  ALIGN(len + (pos & ~PAGE_MASK), PAGE_SIZE)

which accounts for the page-in-page offset of pos, matching the pattern
used in dax_iomap_copy_around().

Fixes: 6f7db3894ae2 ("fsdax: dedup file range to use a compare function")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 fs/dax.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6ba50142eeb2..213b1c9e197c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2197,6 +2197,7 @@ static int dax_range_compare_iter(struct iomap_iter *it_src,
 	const struct iomap *dmap = &it_dest->iomap;
 	loff_t pos1 = it_src->pos, pos2 = it_dest->pos;
 	void *saddr, *daddr;
+	size_t size1, size2;
 	int id, ret;
 
 	len = min(len, min(smap->length, dmap->length));
@@ -2212,13 +2213,13 @@ static int dax_range_compare_iter(struct iomap_iter *it_src,
 	}
 
 	id = dax_read_lock();
-	ret = dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
-				      &saddr, NULL);
+	size1 = ALIGN(len + (pos1 & ~PAGE_MASK), PAGE_SIZE);
+	ret = dax_iomap_direct_access(smap, pos1, size1, &saddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
-	ret = dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
-				      &daddr, NULL);
+	size2 = ALIGN(len + (pos2 & ~PAGE_MASK), PAGE_SIZE);
+	ret = dax_iomap_direct_access(dmap, pos2, size2, &daddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
-- 
2.34.1

