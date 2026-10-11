Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7190836E49B
	for <nvdimm@lists.linux.dev>; Sun, 11 Oct 2026 06:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791701328; cv=none; b=BjUt8br2EqFU/GKmu++u5HHEWTrRkfkflysDJRFpZWU2HDDkwoRKdnYy8uU9iqEK4u/uavjl7LW2ZFx/bkGUY+Y3t0cl84lv8G3Rr34chTbIiigv7om1D123fDLjJEAcmgwfx9Un3O+wpSHEkaBFe1YXcjq82kzpFe6GpWyPEV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791701328; c=relaxed/simple;
	bh=12x4Fjiyi/4PbSLt4bmLyJ/B6akX95r8sgWYZNezRSU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UtJNGsE3nc8/Q2jwhUyzZk/FThZ31RgoTx9pDNs2X5b4MYW8oc/GmUkU14Kkf3i+bL+qRvpDSa+cQ/qDrXd5iQbwicXRQ4eo+gIImE4QCQ59QNP0/DbE6Z0dibliPlOyIkdVsrWFI0RiGyLoveWHhEduWZzFbs0oGMoMQlbx71w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OG2aaZWj; arc=none smtp.client-ip=74.125.229.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OG2aaZWj"
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-3538045633fso899579eec.0
        for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 23:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791701325; x=1792306125; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=koNO8fBOwK5rhKY5/q8SE/NGFcISiEzKzkHra3TeJ/M=;
        b=OG2aaZWjmhpY6W9U4D1y0hath6n9hvM4WiYocV6150HY1mlMMYg5ijXWjooswMNYgQ
         vS4BPiBjWA71fiFSNVum9W+5pMnI1FZvIdeDmqCfoBgrO3EHkxyRtOlj3eTFxIfeOlfO
         XVsVUzQGzPNIz7IMbBYCavphYChR2C5hbfHhKET3BHRZCcwnaTL/7hBwnw+xl8lpHZNp
         mj1Vs3gfWuZ12LVqg246sqCAicfifFjSKvJmren/QJK6VAHxx6J6ooC+AmbU4H9hIXfC
         lMot6VN6ktvuxv0htyD1ttgECg0FcAPm/YSJ8/rNhfOm1tGaS/GylpbNB0/n3Hjt/zbI
         X8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791701325; x=1792306125;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=koNO8fBOwK5rhKY5/q8SE/NGFcISiEzKzkHra3TeJ/M=;
        b=EmYmExycxNTuVqAuVbIzJ7L7xZiei3A2UueAl1zoBhLNRLyK3y4xhy48/y/uYd/oYh
         /0PYxgKTns/qf/M2qvyuECMao9GfnEnLZzNmR60Vd+TFeJaQ+uFgrbFghgEo3ogC4/8g
         qfsdCqvZi6byFiTsgJr2E43m69z/ogVvgIJ89qHUhr2v3b7WuYXggVZqrKfKUJ6g0lGa
         itaNnuYd6LBhMwoxG+EBZIC6+rx0mdN/iYayFk8ZUrhHrEiHGcpBnJxJP2/PHMlC9qVW
         o4AQco+xJBcr8l4viTZKNR1C9wMU+C8avstxWVxTADx4GFZ14T3qBAOKFbhETgRqbtsx
         6ZMw==
X-Forwarded-Encrypted: i=1; AKwUvBwTCigB1l2Z54Km5w/n9EHj9jIKGS2W7RpXom78bjzx1Ruh/WfTOIHgV+TCYxHbsveGsizj2Yc=@lists.linux.dev
X-Gm-Message-State: AFq9FYKfCWdNj/2xopqiTcX6yf2Oo+/0PvriaQv5MoTfH6FEFEjx43gV
	nKfZzWaCVoBifLZFGAV1qVIOLgj9l3cBJYRzaxFkUeK85HLkG68ERP2v
X-Gm-Gg: AYBFou1WBydesPGkRmvEmQiY/PZIprkhujVelZfv0Rw/N3hDXqU/TrTfMbCm2tCcrZa
	6bDWbCtUyR5BUi8gHJnWfK2kqJRy/ZaoIz9NI1oA9lA7dHb48kvg38Tusoi7d1WJU+NBS/HDGEc
	jAvceIsrUqazeIsGmQy9AakT6wUU4ofyC60J/77iIB3D4faMXpEFS8N0xmEcjnhUaopObj9nk9V
	N6ylHhFaLU18Mg5IvPTGlR/Td8RC6gUeMkzRHx41AVkQK53x/oPoQUgTrbZo5rq72AxbNF1NvH6
	9xQYhMJGgbHIXzh0l9zBWHChCAkFhCmwnmyi9EGOqPITfwDngKoWHkj9uhbF9k4duFkwo3TDZ6l
	/pS3y3YMh0vZ4Tind5iSPSt3M7x1TTvpi18mfZNSHlkA7Y16GcQ/CYJU2EEk1i5ZcJw7xKVI+LW
	dNNlqRTf9stzdaNSljHXXxhFPlOHPmg1of45GI/Ji4MJTSLAH8o18+vzQf7TVBhES6nRtEeCHLx
	moQONmO2/fxoY5bYC3QDNAkZWM7uviUoOPptY1YYwrJxc7PxsqzcdcxOeM=
X-Received: by 2002:a05:7300:2216:b0:351:28d9:4908 with SMTP id 5a478bee46e88-3537db99e8amr12245241eec.0.1791701325373;
        Sat, 10 Oct 2026 23:48:45 -0700 (PDT)
Received: from localhost (ec2-18-143-158-86.ap-southeast-1.compute.amazonaws.com. [18.143.158.86])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-359789fde97sm4534786eec.20.2026.10.10.23.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 23:48:44 -0700 (PDT)
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
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and infrastructure)),
	nvdimm@lists.linux.dev (open list:FILESYSTEM DIRECT ACCESS (DAX))
Subject: [PATCH v2] dax: fix dax_range_compare_iter() to use correct size and address offset
Date: Sun, 11 Oct 2026 14:48:39 +0800
Message-Id: <20261011064840.1296-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

dax_range_compare_iter() has two bugs in how it calls
dax_iomap_direct_access() and uses the returned addresses:

1. The size argument passed to dax_iomap_direct_access() is
   ALIGN(pos + len, PAGE_SIZE), which is an absolute file offset
   rather than a length. This causes the underlying dax_direct_access()
   to request a massively inflated nr_pages via PHYS_PFN(size).

2. The addresses returned by dax_iomap_direct_access() are page-aligned
   starting addresses, but memcmp() compares from saddr/daddr directly
   without adding the page-in-page offset of pos1/pos2. When pos1/pos2
   are not page-aligned, this compares the wrong data.

Fix the size by computing ALIGN(len + offset_in_page(pos), PAGE_SIZE),
matching the pattern used in dax_iomap_copy_around(). Fix the address
by adding offset_in_page(pos1)/offset_in_page(pos2) to saddr/daddr in
the memcmp() call.

Fixes: 6f7db3894ae2 ("fsdax: dedup file range to use a compare function")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---

Changes in v2:
- Add offset_in_page(pos1)/offset_in_page(pos2) to the saddr/daddr
  arguments in memcmp() to fix the page-in-page offset issue pointed
  out in the v1 review.
- Use offset_in_page() macro instead of (pos & ~PAGE_MASK) for
  consistency with the rest of the codebase.

v1: https://lore.kernel.org/lkml/20261010071453.6028-1-jianyungao89@gmail.com/

 fs/dax.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6ba50142eeb2..b08d408418bd 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2197,6 +2197,7 @@ static int dax_range_compare_iter(struct iomap_iter *it_src,
 	const struct iomap *dmap = &it_dest->iomap;
 	loff_t pos1 = it_src->pos, pos2 = it_dest->pos;
 	void *saddr, *daddr;
+	size_t size1, size2;
 	int id, ret;
 
 	len = min(len, min(smap->length, dmap->length));
@@ -2212,17 +2213,18 @@ static int dax_range_compare_iter(struct iomap_iter *it_src,
 	}
 
 	id = dax_read_lock();
-	ret = dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
-				      &saddr, NULL);
+	size1 = ALIGN(len + offset_in_page(pos1), PAGE_SIZE);
+	ret = dax_iomap_direct_access(smap, pos1, size1, &saddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
-	ret = dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
-				      &daddr, NULL);
+	size2 = ALIGN(len + offset_in_page(pos2), PAGE_SIZE);
+	ret = dax_iomap_direct_access(dmap, pos2, size2, &daddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
-	*same = !memcmp(saddr, daddr, len);
+	*same = !memcmp(saddr + offset_in_page(pos1),
+			daddr + offset_in_page(pos2), len);
 	if (!*same)
 		len = 0;
 	dax_read_unlock(id);
-- 
2.34.1

