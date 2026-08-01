Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB552DECBA
	for <nvdimm@lists.linux.dev>; Sat,  1 Aug 2026 15:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599320; cv=none; b=q30/0ahA5msrfKzjGuyia/WZ1JaAFedMT6Eiz/qbF2M844xsmx0RgngTaqt49l/BEv0NfNgZWeHvrG4he5XVmP95pfX0H2o+ctsJuWXV5zTGHXg52goh6+oWkDx7MpVtNRIV4Sf+CybZLRki2kj0NCXOxsOuU5b3s36Q5aiwVVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599320; c=relaxed/simple;
	bh=1jBAtnFGRJ/F8gXs/co1VF+epb8VpkeomtOw2fyD9ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdoNMvHQcmNqu+3LqMrHwr1WpdbyB9+lpqXob033Mcj12zuQz7i4/gFm1gJujyKpaw0I8FiSIilWqL3aHp6cGaoDkdoGF0+uWC9GZwiayG54/ijxISuZ4YYhkfv0HkNu2LxIiLrbsmD5a1pikYKr1QTUWX9gA2t1KucAHK33na4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vdcr+oBJ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vdcr+oBJ"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2caced6038eso19726045ad.0
        for <nvdimm@lists.linux.dev>; Sat, 01 Aug 2026 08:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599318; x=1786204118; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fyuZF+rseQvIVevAALiITcY143h/8lAr4kofVhDXVW8=;
        b=Vdcr+oBJ2GQxBeBdGqhxA/M3VwdNr3yXmNDOxDBNdmwJppwpTYSk/JfHfkMeoUytj8
         5XhcmGd3oirL/ywU53GwhIpwmwomC9+K6FixvhMCwvynP3j+oSMRepy5VbNNtqeyCr7u
         2ZtaGceP628Wm2cZIVpJ27SOHjydlLFebSn8tDKUHaE1J+7bk2OWQaFdUBpdUI65V2cf
         3r+nyIeNbp/92HyzlJHRczIrVaEkGaNGs5xq9TYqFpW3Ar6qV3JS9UKO2jD5q2L+EJH6
         DcB3j7xkNNzDxZ0b2xFD0iMrQRV3PwxnHjx/U5r2FIRr24lSUYsIoYkuQ+ZWUIDN8+hR
         6nrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599318; x=1786204118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fyuZF+rseQvIVevAALiITcY143h/8lAr4kofVhDXVW8=;
        b=GHqDHBCricqrzJdUDTYMUXwVDe10NPdD/C3IKiS+3fCivgu2dpp5f6Fcn0jyfHAZ8r
         TQSKZQKSD/v/2DZbYisLHy6pBsgXodmoVdV0efQZfnunxMZ0ARUQ6oC2npnj8sh60EeD
         rc68SThHzlY8NXJgiIx2cf+oVZk2y9VzYHR7mZtXuAxIX0DJ3wZZg9FKc7z7StEWYrGf
         oHE9nYroVmsA2pNFO2wjzCtMWpu7nMbNtR3giKr42p+BFofvxWS+n7TdszYReKeWlecF
         5jsLVd3/aWcDiL3rNltyuRm6MCFvq7FWJYZqtQN3ayX77a+6LYDFb2RL4uLaqMUp+sQZ
         p9Dg==
X-Forwarded-Encrypted: i=1; AHgh+RqJiyfssT6Sa5qgIpCIWfTeXzVoNQevPs4mf1/GybQkZsHACX+mL6zHB2HivrJDEpBshpv96FU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yznjl9dR6gdQyCVLGdZxjscX1+NkwK8ELHyq2homRL0fkL2y+wi
	x6ESLCzaQnDe5QIk0Y+gZ6ESyQ/0USQjKC/S1DT2AcqNC5TaYxQG/IVT
X-Gm-Gg: AR+sD100qvR5NkZ0wpNVCzYDdJxLe6z6FSqj4Tf16rf3zNPpC96vRXs2zRVC7CQypL1
	qtjX7HkIBVaGfPUnscsvU/HG1HfH9tHzu/4QMocesJBVukJgs8vE/hxmMly4pbyKER2hTwScESJ
	+qMWMiC6mwZSY+dPEsPoT4BN5wCe9PJ0cmeCpzrJf62CLgEtdw+CKeMzqXBuIKpgQHVvPpBEfIO
	k1aGnJo94EYQDYaVQdyZVcQOI3tzf90uE/sOcS64i51TPxG+DYqkvWceXmn2F85egqwHMvIFVvO
	VPWvsysNcrKt64x26QTRn9VcklKOig7T6ZSfijJNIr2yethvId2tJWUvVoaJJjKhPwNRhn4FInj
	sj6p/qZ7muFTWO+BaHZAOFG7oQhOGYauXUP+ATWEbXdwUlnCB4jC9G9qqwpojrfdcoqWAH/fhWO
	bdXy4rVYXDbbVw/Jv5a8EUXnfJSfOkMH7uf+71MN4xNt/lLFovakHKHPFoyepYQvexCaBucuk4s
	9QZJunXTlEONXtp8UI3p/R2gIvaU8y0ihdZgzaUu1IEEuw=
X-Received: by 2002:a17:903:2c0d:b0:2c7:f5c6:c4a6 with SMTP id d9443c01a7336-2d0535b3b1amr33657505ad.7.1785599318082;
        Sat, 01 Aug 2026 08:48:38 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:48:37 -0700 (PDT)
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
Subject: [PATCH v5 05/16] block: move bvec init into __bio_clone
Date: Sat,  1 Aug 2026 16:46:17 +0100
Message-ID: <6ecfe8f9b1c6bfb8665fba7daf55d9ad7a8a3243.1785596451.git.asml.silence@gmail.com>
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

Consolidate bi_io_vec assignment for cloning in __bio_clone to keep any
further changes in one place.

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 4074a0496b93..00f99d03ac91 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -860,6 +860,7 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 	bio->bi_write_hint = bio_src->bi_write_hint;
 	bio->bi_write_stream = bio_src->bi_write_stream;
 	bio->bi_iter = bio_src->bi_iter;
+	bio->bi_io_vec = bio_src->bi_io_vec;
 
 	if (bio->bi_bdev) {
 		if (bio->bi_bdev == bio_src->bi_bdev &&
@@ -902,8 +903,6 @@ struct bio *bio_alloc_clone(struct block_device *bdev, struct bio *bio_src,
 		bio_put(bio);
 		return NULL;
 	}
-	bio->bi_io_vec = bio_src->bi_io_vec;
-
 	return bio;
 }
 EXPORT_SYMBOL(bio_alloc_clone);
@@ -923,7 +922,7 @@ int bio_init_clone(struct block_device *bdev, struct bio *bio,
 {
 	int ret;
 
-	bio_init(bio, bdev, bio_src->bi_io_vec, 0, bio_src->bi_opf);
+	bio_init(bio, bdev, NULL, 0, bio_src->bi_opf);
 	ret = __bio_clone(bio, bio_src, gfp);
 	if (ret)
 		bio_uninit(bio);
-- 
2.54.0

