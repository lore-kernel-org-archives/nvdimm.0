Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B273620AF8E
	for <nvdimm@lists.linux.dev>; Wed, 12 Feb 2025 15:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739374073; cv=none; b=K3krxUamwBVe3/VojbFTPkNfIEXhMAT6q+zGajeZvJflFNha32cRhUn330oTUXSwq5QsQa4Yb+UxQ4g5diAxdz0FGU0sI6/UyKsOch4R/VRX3VGgJwH+Yk8G7J+yx1Voh87dl4NyX6sz0+tNLOKzrXW/9fTNDr7K6cBChTbrjCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739374073; c=relaxed/simple;
	bh=nGOHHKMn8GtXJDicwnkL8tmz9VcKp2LxDT7FzaficDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nNj8QWKGtySGyQYECvfZ3S+prn4L5Tm+cYOVDpl33KyWZLfS+MAM5uurABg/0aZn8JVSQDrUQsX4hYhq+gk8rFGbwsNmo8//q7YlKDUQmFSwti1exXPGRp6DFw8F+nY6IsXh6Or9AEhBFg88/yEBblRv/oWux4T1Z/tJf4i1KiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pSFr5FjL; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pSFr5FjL"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ab7c81b8681so520243366b.0
        for <nvdimm@lists.linux.dev>; Wed, 12 Feb 2025 07:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739374070; x=1739978870; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gIK/hsLjBmZb4Q7phf+8q1FhCeVWqfbKwX81hLs6leU=;
        b=pSFr5FjLti38ip07/Ffu2pufTT9sKhX8zGuiFxfoiGdDGkhBsZNAnWTgPGEkMHVOUh
         XRtFmGXZeIjv7SYtNSCpHH89uv7q/1xPqghr8JWn48fBkNxV7SqfjF203nJjzZNf0cZ4
         MvYs/V3NFJQEd2xpHH6bTTd5ZJvmi3bRRr65eRiRzM8BnwwI1kiZ6WOPe80FLhjmTQ/B
         mVPtsIdnoWRMF5SzEdZgZexeg4Kb3DFgCkEfCJTfJgsHSASjaNBF/GlNkyBvTlN3h6z1
         XuI8gqUzk4cPmyw6FLkbdx3LtGtvjYPBZO59pql8LmWKihuuERzg/Lh6fvO8XBc/mIE9
         hY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739374070; x=1739978870;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gIK/hsLjBmZb4Q7phf+8q1FhCeVWqfbKwX81hLs6leU=;
        b=Q6tbfvDajlUvc9X0Bd0QwHmp4Hfn5EJ6A+bYphOIjJvotN0oDpt3rynf6aiU4SG0LS
         G+3029CJDdj2vJr5Alf0DqjCNDKxkD01fIhK5a9gdzommg5fZXan+tFVp+9GDFScE/bL
         Smm4sHU1BfERW10FzrSdCiRNT8zwlEF+IUHp5zpMyys4VB0oyUHrIU0PXgca/kro6TH7
         YirS73JezxXwvQqFTMyAOT3SFGgakcl396i7PmKkftZvdWODExFbhFh+OEhNq1SpPfvy
         GxdGI08DB//RCZQqcMGkhKbXbtzvuwpPoLc86GLRyfG2tV55WX6kNGkJq0IuGdkt3qen
         AtOg==
X-Forwarded-Encrypted: i=1; AJvYcCVNh1wlQJZayOYPexTPfg1hG9ft/Jl24aBvF+90YIhztubTR6FH9TuGNLH+5XtXeMh+N1Ui5Fo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDQQmEd0c3cqIWPTiAVPz0yA5TsOIMmiytMFariIbzRV8eokCZ
	N/Cpb2kv9kP4T6UTOVVbjezdMoVUxaY2Y55AbPq7SOFgQgKJq3Vy50eFtL8NDrg=
X-Gm-Gg: ASbGncuyAez8cCVqcoVCNHq1mRmfr9xiYGUcoBOx+Y35W9NeBu/IsEEvw2LA5rg2OVl
	XvnVY25W+m3lU3H1bDcWY+Eq4rkjBL/MZiDVHT1+uL5YYJOqX59phfWWUjxMWEMtTuZSQoJkTUd
	cxTrrq9QPmfdZOPiSk981/TV8d+HOzdb2BQdsHemSOb/dry287OQVUUVXoxVt3+turhxDXyF6Tj
	nychagjHkD6uimSqk0lZ0WLgBznSiYGWIZI8T21Nr5cPkGJqLhtpBEWzqdGbErJQhnCkf0kKpKH
	VsWt0vqv+VfmxTgtot4L
X-Google-Smtp-Source: AGHT+IFpL8Nw1g0cPCijD/OhpU2DBTaHM0/BqrJs7pa0K+2D+M9iqhuvdq5hwJqMDWlN3ZppYMHMIA==
X-Received: by 2002:a17:906:dc91:b0:ab7:eeae:b23b with SMTP id a640c23a62f3a-ab7f354ed67mr381322466b.0.1739374070037;
        Wed, 12 Feb 2025 07:27:50 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-ab79d9ced43sm967079866b.78.2025.02.12.07.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 07:27:49 -0800 (PST)
Date: Wed, 12 Feb 2025 18:27:46 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] fs/dax: Remove unnecessary check in dax_break_layout_final()
Message-ID: <ddd61469-637c-4a1f-a024-141574fd76a8@stanley.mountain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The "page" pointer is always NULL at this point.  Adding a check is
a bit confusing.  Delete it.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/dax.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9e4940a0b286..21a743996f90 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -987,8 +987,7 @@ void dax_break_layout_final(struct inode *inode)
 		wait_page_idle_uninterruptible(page, inode);
 	} while (true);
 
-	if (!page)
-		dax_delete_mapping_range(inode->i_mapping, 0, LLONG_MAX);
+	dax_delete_mapping_range(inode->i_mapping, 0, LLONG_MAX);
 }
 EXPORT_SYMBOL_GPL(dax_break_layout_final);
 
-- 
2.47.2

