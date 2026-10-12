Received: from mail-dy2-f2.google.com (mail-dy2-f2.google.com [74.125.229.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F53497B8F
	for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 14:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816572; cv=none; b=WnGnS47ipt0yl5PXceqBMVnjMArTAMBG89d9+BI1KoX6ptoD9y47Q2tTSWJXUyTcEOkIIBmcEHIXs/nZzKWkRAILuCR4wPEnwEqqxt2eVwmV8q8JaqaZFXvf0/oK5s6KmxLAplz/gQ4T2eWHuCYYbpX+MvROW0MLdIDyRXLHgmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816572; c=relaxed/simple;
	bh=c16ZXWH+GRMU9Gv5D5TMERR/RKlvixHWFMYKRCEvbV8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MmQuVSbAti40dDNGQxnOrLK37bzu63sSVN+noy2Q6vwbaof1o+SjmASSazJkGavh/DddbnuA/dTamJ2htuZ0OfyBpXw+GivLfH9GRzb1gb1QMtRbwPRHiG9P3UgAA/adq0kQTspo6I7u3gDa6QehAKUWohBAocGQQhqHI4TG06k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gwe+vgcH; arc=none smtp.client-ip=74.125.229.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gwe+vgcH"
Received: by mail-dy2-f2.google.com with SMTP id 5a478bee46e88-327b1d5824fso2226308eec.1
        for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 07:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791816570; x=1792421370; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SNefojtvKaPsWksx1KlDETs9fKwCel6Xh/eUYbsILEo=;
        b=Gwe+vgcHVdb0KeNEeM96UWXb/IqvXnlZKWOvOpEu7OMg6H3nSf/MnGZ2CMKpjfupoc
         jugnmwSwjgDgdTAYrLVOazbe73i2B+Qd6CZMNPov4kDs8LXEjLK9hIlvflQDzA9+HAjP
         aWtSLzZqQaXTEXYqcDRL7mUGBJvCt121DBrjBYLsYJYjJW8rRiiOsEp7VdiPM9cMSGbB
         gDuDIvZ77x6GcrZ4L3X2HJ1T3rARxRB6Z3H/DLW9MnReTFbeDD6vYiSQ/nlRuDxnouYI
         8mELG/zrLhGMtrWEI6Ft+9VduHmn+MiHyd1iCCu0yCSF1WX3LY/6XMGxnzDSjCZwAM2j
         1/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791816570; x=1792421370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SNefojtvKaPsWksx1KlDETs9fKwCel6Xh/eUYbsILEo=;
        b=Rz6NlcQ3S3knwzVqoO12tOGIRFW372fymjT0hF4TGbuumwNSXbvUatiJNZ5WjEFMF8
         IfbFZ7YJmW2y2hLiMUx8hDC8wszQzEtN2QbLEvyhOpLUZ5u9kOZj99DCPxfWg22RH3PC
         qIjd20QGyYce0HK4o4RE2r0oBGo2YA1WohCr1FnHYqJ/yX2h+aMJFKWfi5lSs5/3q1SX
         KRmKInqwkisEMZde04foTkGdpN/794XeHkO8vyXVe/MkCjiGT3Hcj67JbmhMeYR5c3BZ
         BN3AmrUW0GAoluv5d3dQ4b8N7ysHP0fwMMf6ZAJXqiBdTOkIumDc3lwUclR6oIXrdr1w
         JiAw==
X-Forwarded-Encrypted: i=1; AKwUvBxO1zdltruRwhR3AQH2CJ8UR74J2hHcksUhLiW/gE5dLBGWrYLP9/wL2K3LCnNYWjhuNt9eXB8=@lists.linux.dev
X-Gm-Message-State: AFq9FYK31F5JLj+N+PHEl/kTHMpccDwqRtX5mfCdQvS/FeHkoA0cHHtq
	zQVSBg1ipfefDOR9JS2bq1GcZ+a4FiOGj7Z+ljFh5ZKyzneLnLNk7bQE
X-Gm-Gg: AYBFou1EibnWgr1kvja5ps19SPu1+uMI/wAJqPOQZryKKrPUn63sX1ZkxmdAxxPQ2re
	yJI9u1wvGFP71e5UfTbBvj8EOfVGSu9qDHw+GWbrPGR43a5hJFOrJJhKyuvAICzjzsdSt+ajz3D
	nDzX5HfPnhw70H0dYlRllVEYaLRTIiAXOhckfuqgCevj+20GC4yj49ou3chlDELIXlgAlcvbvAZ
	mYDHypusX/eUhf+F2ZuJ6ninZ17zMId9SdJfCt3tfsluTV6WeTaxQwGgyv8HqAgz0NwIndQekpL
	2+kuUlgV+tulXVDT2PgSmSn7b6ZNNHzB8WnVU7ZQEzAVW+OfcLZb3/W6EaTaNaGwGTl6PYbgZ2H
	KU4PFif9zPTdULUWlRGA3f3jbekLfMCjSDD3t0ow+dgwZV1Ky2MnXtH8+iodqIx460Ax3b7O0bq
	Q6pdm7W6lAwpdSUO7y9eEx6Sa4uGy6uB3mPThrDTcUhrlK4AjEpAwK4w/7/wKPcCTi0NeuO5qSw
	ICwR5gdqUx2bywuJyKsiNnRLd9ZsT5o/bkT0AHgodLPGOcyFBl+K+PbiCw5+i3zDPJbqA==
X-Received: by 2002:a05:7300:a50a:b0:33b:f5b7:f494 with SMTP id 5a478bee46e88-3537df8cf05mr20301538eec.13.1791816569788;
        Mon, 12 Oct 2026 07:49:29 -0700 (PDT)
Received: from localhost (ec2-18-143-158-86.ap-southeast-1.compute.amazonaws.com. [18.143.158.86])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b29c2f861sm11272773eec.11.2026.10.12.07.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:49:29 -0700 (PDT)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-fsdevel@vger.kernel.org (open list:FILESYSTEM DIRECT ACCESS (DAX)),
	nvdimm@lists.linux.dev (open list:FILESYSTEM DIRECT ACCESS (DAX))
Subject: [PATCH v2] dax: fix wrong error code returned from dax_dedupe_file_range_compare()
Date: Mon, 12 Oct 2026 22:49:24 +0800
Message-Id: <20261012144925.6728-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

When dax_range_compare_iter() returns a negative error code (e.g. -EIO),
dax_dedupe_file_range_compare() incorrectly returns 'ret' which holds the
positive return value from iomap_iter() indicating more iterations remain.
This positive value leaks to the caller, where vfs_dedupe_file_range()
interprets it as success (bytes_deduped = len), causing userspace to
incorrectly believe deduplication completed.

Return 'status' instead to propagate the actual error code.

Fixes: 39eb05112987 ("dax: advance the iomap_iter on dedupe range")
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---

Changes in v2:
- Add Fixes tag and Cc stable
- Add Reviewed-by tag from Jan Kara

v1: Link: https://lore.kernel.org/lkml/20261010021010.19575-1-jianyungao89@gmail.com/

 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6ba50142eeb2..1f6a4fbb97bd 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2261,7 +2261,7 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		status = dax_range_compare_iter(&src_iter, &dst_iter,
 				min(src_iter.len, dst_iter.len), same);
 		if (status < 0)
-			return ret;
+			return status;
 		src_iter.status = dst_iter.status = status;
 	}
 	return ret;
-- 
2.34.1

