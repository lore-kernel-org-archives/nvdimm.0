Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC9628489A
	for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 09:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406925; cv=none; b=s+vdbCFhSH62Vj9IUf5QkBJh5KqOj31IPmLI82OIp0wrGTM5iLzKIQ3aPirqkAyFpPnJc9YnlJET0uyR2EI0Ik/3YsQn3HzOicj4IupRjbdgifgxuZYJLUTculZf7Fm2DpInH1T5KZ+dBhPkMR96D+HEdCdzYIfzzqLGph5JPSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406925; c=relaxed/simple;
	bh=Hfn+I4xKib6YHUNH+g6fjmCyECLvbavw8yPYoNL/5CA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rntlOcI1lV0aJxx3bq8WThUQRJJB+RPyAaC6Sqto+YTxcAVur1MIpkZnAVVZpKhPG3KSARLk8L61h4KCX3nlBsJCdyebDl2WBMiycJExGRwt0EM2dnm73E1qfYdp/YGcz+lx9XdQ0w84uN8y6RCD8+C2/IFGVmrJc+44I1uvVQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZfIc55w+; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZfIc55w+"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso2967985b3a.2
        for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 01:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406923; x=1765011723; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdyx9mvaY+8x+eK9XImqi9TsYLR1v6CaCbGe/GD/N5s=;
        b=ZfIc55w+a51cFLAUC4IJD5VNeR61k2Y8R+MLZZDmnhO6vkW920NBIORavsHlIyehub
         GlXK2e1DFIz0Rd5vLqV3GBeIhzo4btZ1aekgoSQkZZB26o3DDQvxeue/L2uL/2knKTzP
         ov1dyj1Y+4mB0mObpHfrFNwEmGOBjxthq1eix6nNWqX/OiIFr3x3MGJlRhtHASlfNXsa
         myB6y2KS1yq+ZhXMHescMbPOhKmqyVbTFxC0N1QmTkUOJvw2Yj0TviFtBiyjRSRuOrD+
         tcpp3m0gdGYFm5b06y4ermKEP+u36Ox/glrXbqkDKQLFGHh7a7iMgw7ZWJJBvm7TxRqr
         WKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406923; x=1765011723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vdyx9mvaY+8x+eK9XImqi9TsYLR1v6CaCbGe/GD/N5s=;
        b=mBNlxhnWLKFQUf3/Y4zsViu278yFsaxU+li+CTiJpLB04jiQFeZrnaT/v/HhdrMRdD
         H7fkl+O+xViJz3l1HzVgm90zh24rketrih3I0WtKaw15OdBg80wks+exVTMsMQc5hw/P
         Kz3sA+qg0v12Y5lXR8dhTSFKnHPAmfKiEhbe7KbinBum8UpYvEDW2xdIQo0qb2Rr9s8T
         uIM03sQTJodaBo//KqOklSNsA+sL8EGyaeKvIrKGXZ09/Snl8Wo0xcI2RNt5dz0vHmGa
         SvOEpfCclk4OHeu/t68yF2UQMVEIThjcUZK/GVlK+SugUriuNRBNVwhhCg950z3lijAC
         4F1g==
X-Forwarded-Encrypted: i=1; AJvYcCUTXv2froxGRe+xHsblrh2QGTwRFz0dg+KsHymJYstt7v4NI24XQ6sGgsFKfHxOMzuU68dKo5Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1JAt9s9EfSFc5sS4W03nyz4hCveLy+gxoYKwCPbRkRzQnEcfS
	0Akb8CbguOnPJqC5SjesXJx/O7BPRNLryBft68jJoR7OIvW1V1IKqJ1f
X-Gm-Gg: ASbGncvXIJl/bNLNqf+3c5uY3iMvI+HmfhCuoQRowBUc2Z9cm+sXNVen+vQ+62cYcyY
	vi+qoFUk8qLL9HA9ZBWQG3qFJywPeoL6ZgMj0w0z0l9wy0zxAUqDsXScH1CWk6Ho3l2D+AMEROU
	sqvyPr4dTzDe8s3ck5GmOdtMNPbu5F4Rcb+RfyCDLgT/geFWFEIqw4lzS9TLLvH8KBLzrdbgcYG
	9urRqXUsTiEYMurHzdISLs9xYSywe5z69vMW6rJ5bjnDWSo3dn0yJ2U+TBGsJYDjdJ+Tn6F+TfO
	az39cyC5Q0J+VN11lmByM8kwl/x1xtLSDt3qNwU9Vxh3iiG+ZAcBLPTM/Gfsk+cZx8ffMAn9L+R
	doCiyV8WqU0ZlzMLH2WUng/hnGjQxK6Yvuxk0S/wyPhttdWyGPoJr3tcCLFj7YEI7/v27WP2pkd
	gKZr5uptIq9X6x+NaHZgkzoVOiW5igPNOOpEnI
X-Google-Smtp-Source: AGHT+IH/QH6JeY8zEnnFSEp2edvSj4WvW2OiftF5ahPSC2LjhfBX3UeSnFliqzhG5QTteUkJDEx/bA==
X-Received: by 2002:a05:7022:ebc2:b0:119:e56b:957d with SMTP id a92af1059eb24-11c9d6127f9mr19966464c88.2.1764406923339;
        Sat, 29 Nov 2025 01:02:03 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:02:03 -0800 (PST)
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
Subject: [PATCH v3 6/9] block: Replace the repetitive bio chaining code patterns
Date: Sat, 29 Nov 2025 17:01:19 +0800
Message-Id: <20251129090122.2457896-7-zhangshida@kylinos.cn>
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

