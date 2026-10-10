Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFD2381EB3
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 02:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791598223; cv=none; b=QORtGDT436z6APoC2jq7hPkyg1JNp0JdauqQimTaFhBQEionjTLD4Lnk1O7nTlEFLpKGAMhp1/03/G3H7RbBDl2NRevH4csqseKrTFakg0Vlvq3t0QXuPYYOKaXFAiRf+QJ3IQiS0CKLYq0EKqNjD8su/xYBkNjrWcVlRNB9ALw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791598223; c=relaxed/simple;
	bh=mXKTkYmURmAwcHDWL9qil/wt8AN1KXlNWVYThfkScHc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kTejBC+vU/6xf/JSM8ad3qlwOrhNRnuoFZZnTEMbhqNAG/Lr97Bz/kJDOj+XtgaPtLo7PwvuEPG94bPOavQV3eKgmLf0oxLQJ1rsV+OH2V1oEZPBPOk/nNqvAWTT1jEZObaYOMEedbDJ9siT3RN7Vmfh6thWZU2z3GQAqW0RBXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A2QRvtWq; arc=none smtp.client-ip=74.125.227.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A2QRvtWq"
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-3ab86ae9b80so48744a91.1
        for <nvdimm@lists.linux.dev>; Fri, 09 Oct 2026 19:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791598221; x=1792203021; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=X/Fh/Ja5bkpUIakz4GwSffeo/Fel3d9ODnCNeZEyn5Q=;
        b=A2QRvtWqzhTzoeUBEeZXPAfCg6Gzu/8MghjKeeUfXB1A9l7NRB3C7wyBQcMqHSHAvc
         yF26n2xpX+kGjL3PV/HaHhqimhoBX/c09r1voJS5PjY2C9Gnacy/8nh7bqQAosibFSpf
         dCkAgBfNovRU1B2bqmR/IKtgpA5yeF4WRAfuuvvg6A/bwe8PQ9QI/XDyxqvFaqX/V/Nr
         bCHDoxploRAeMjxQG2GEWqtgA7T/Zj86YTO6JqtoMcVN2V7Pb3X0TC0UPhSoUntVwuda
         yDA1kHSGxMb3cAHqig/tpAl4IbNl8L7ORI9/sYU6VcWcghYAhR39StN6/qhjqQLiPhtI
         An5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791598221; x=1792203021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X/Fh/Ja5bkpUIakz4GwSffeo/Fel3d9ODnCNeZEyn5Q=;
        b=AkASAniLLTl+E9FKDupCIiD2X/ltQRoptgwNbrSVHD5PUG1RkqTAR9VWrQz3HPyX6/
         8rkzacUnveqC70W94RqLWfrs/iSYrUzUMYuFV+7DUBw1D+rXXxVhYYm2EVq2+PtnuB7u
         gV+JNNzD7kGDohmzjthNKb6o45SpqoEG8+7P0TX6x5oAHhM+Ee+YUAGiS9Su0uxDsq+8
         W27tjdHfJ2zTvsFkJUONJZbgjronx0HoOEzCxkPG4rBKulo1mqLUSeVW6Poc7vjl6Ndt
         fh15g0ZJdMbfCuKy0oKQpZdPqVH5u24uVo5+OKKFiGTIc2/PEb1FXCIbvuzCWf4nJXXa
         tEoQ==
X-Forwarded-Encrypted: i=1; AKwUvBzfyIxi9tv+kQBEC8kB1LMLeM6apMV9kP/LoypHgMMzfSueppF1y8/BYHQgwrNcQbOZU4Im68M=@lists.linux.dev
X-Gm-Message-State: AFq9FYIW5Nt3ErO7CIfDV1KYRSt9wevh3NjBbE4iSp1k4VRZYyzrR10R
	k+PEhMzNwe5ajr/Gbu3A+uNGzZ1dbCEkx7XszCzFzcI0/6RtIPMFLvQs
X-Gm-Gg: AYBFou0qVSS5KmfnKR9txjm/rpfDufS19Or3BxeJqgEUSMR792TJPp+HSajJG2tRl1t
	uXweOau1ZV972RwwHiGoP0KQtIVPYTAJixPhlTBpd0icWyzYTq65B1FEHol/uZYiY7TNKwPUHXW
	vlBhyDPOGYMLiprXDWbNp2kAKhnriM3vz7pV4cmU+q1WYXfKhTntdpo11XfhWuZjUAm5TUekKC/
	gkdotqhZXg0oEAxj8I8R0pMSxF7O440nPncdjSzfWOi8MIY9kbEx67KxYBoq18OMB9V0D6/tJRr
	kpfBo5HEIpBWht1znwrvahZ2YMFefe3vLPHeJbUmc2CA5a0nopHJkP48LEF3rTNTn8X/Z3VPcNX
	uQkdLKHpIJ8Q0aX5KwsaTzf5c2hQ8HFcJukyneJGEf+2hZjZuXrr5GST2smD7jcibWaH5OS4hRG
	fUvJcsXlWwwZvV3aNosAGmIgJmlO82+WfUf2CKH2xTxiFVyC0ipYletWWkTnKQhfZC0kgCrC3Et
	WccfKJZaKYA0eaFb9tp3hR6wGlestBFpjA82Ke5lc2LGivpVwvcmppuYQuVJA==
X-Received: by 2002:a17:90b:2681:b0:3ab:189b:6981 with SMTP id 98e67ed59e1d1-3ab3a92f9f3mr2946771a91.48.1791598220531;
        Fri, 09 Oct 2026 19:10:20 -0700 (PDT)
Received: from localhost (ec2-13-124-149-247.ap-northeast-2.compute.amazonaws.com. [13.124.149.247])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab421566acsm3027977a91.3.2026.10.09.19.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 19:10:19 -0700 (PDT)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org (open list:FILESYSTEM DIRECT ACCESS (DAX)),
	nvdimm@lists.linux.dev (open list:FILESYSTEM DIRECT ACCESS (DAX))
Subject: [PATCH] dax: fix wrong error code returned from dax_dedupe_file_range_compare()
Date: Sat, 10 Oct 2026 10:10:09 +0800
Message-Id: <20261010021010.19575-1-jianyungao89@gmail.com>
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

Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
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

