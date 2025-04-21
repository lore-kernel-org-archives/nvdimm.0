Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF2683A14
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199258; cv=none; b=a/IMN2P/gdjhN4ZpXwDDNKAWUhQVYzWL8tRo1BdlkYVBH9P+5/nn9TmSidNnc/hLez8BPed/So1ikKUsFhwb1tkDyQSx/l99ybG9Zqf4vLR4pUgjq+0m0NG28zzC7ckI20vWa7rZyTt41sNCXU1ix3XyJn94O250Lp/I3n6S7Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199258; c=relaxed/simple;
	bh=9z/0+wP63OG5wXftLWkn27sSwdysRUwo3gRSnRSt66U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rxILmxQSch31tgjkswneotGOjBm9qdiarvQQ5uYA8fPSQc6gVIeSf4NTYkgS1Ty7/O2IPyrum5A1boonQ6x1O4pWjquUQGG5LXgJA9LdIeIIdHgPUK2l6mwGlVXikQWKn2tQXvoy8b3crZeKWsyNxWW6iGzeT7+qfOBGNVGuUbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HnyXuEdt; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HnyXuEdt"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-72ecb4d9a10so2163932a34.3
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199254; x=1745804054; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHFHSP5AI7GYN3LviveRts2reQTV/UFJRypYogMzU4M=;
        b=HnyXuEdtOcn3GiuIhr0pCA9HF+m+zt6xjXZa5CKN8UrTaxH0TRlk2FXOx6xyucG+rm
         63uwCU/kJDpkdWThqiK+jlRrkrlG8ZhmCiLcdFGXn8u8D1xdH5CzT4F4K7iOcGRjijSA
         gOzw7n2UQ8EuaanV/WP0iVwTW7Iac+E5f/JKljMI0SU50JMU+zHlcK0zSLhMe3pvQ6nx
         pwvOb1A9DRBsxvvvY4AlSlbzGjBg7Pvfi6C7tQjSTIYqj2MMXz/yjsKczHh4bMmIpKfK
         YSsb2Xxsxu7T+cmbuDvcVHEu3mmkP1XGrFGXBF60zovdUXG0lX5ObfYCqmzLsf9RJrek
         3GfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199254; x=1745804054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jHFHSP5AI7GYN3LviveRts2reQTV/UFJRypYogMzU4M=;
        b=hXMjjyPw7oC2H1EQVEAuzRrXXAxZ1SI0yj+X98PPjhLr1r1OzjTbR7V5/Kfa760voU
         4r4xc6FpJbXlHd/XTHzpfRHjPcLff22HIAv7PEZOVdaOWomUwt6jGkT3EcKIGPAs9956
         Sbpv1g0PhF7mJZ6Gk4ZH2DO8F4XFyh/piszDBoyAA7eiBLIYQj80gw2R2+I5AkP/vtqg
         h6RHmcPoS6bCgvY72fOzT+qAzzRXNR9QZ773obtJd30T1jcmA02f55XQb/GdZGVneHiA
         uYwvrezqBjlxHbRHT+IYkwOC+wJGQpsbYBIAt2bu5d9ko5DEpR8eZ4jh0Z0mVhFUNvZn
         Nztw==
X-Forwarded-Encrypted: i=1; AJvYcCUGStPxJ4TfFcvOOkvZz1GtS7wJK/XmdJQBRE1mqY2P24Sw0gQoEHPUQ0VR43lbjF0uHARHfeo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRo1V3JfSvgDXw/IUDeQ1zFbFIP0Pw8Yg1aVtC5ebmaQALB3s9
	KCQCAHE8bgA+sHkOJvQnRtONAdNqZCZSK0ulbUPSsoLiR4dt1lmV
X-Gm-Gg: ASbGncvM5aQEOUobZNhZ/FWaCdkWS75q8gF4cvD/EKnpKGaFjC03abM0jBdLQlltuCl
	1+G7Vvjk6xQRO1oosCTalCAN64t0/kAATNNfMv6DGfkv1qFGaGiZz1wszL+n3qD/xO7gGLyfAdn
	K8p8FfKxtr+K7uD0uOmGUl19YdbH1MK8nhYDCfVTC43pVIc7JojazT7nmBtbIwkXoFN5oOPhjAZ
	id7UzsjZ76Z578PHebJzO2Ly1xHbQH55NCN51eC+IgAhVCAKvR9i6xCN9CiKiqBVOuquUHK5Uf/
	aiH+vSf/EHnOhDdjwk5m/Kx9sNnaMrnaHKpaq/b3fqd+W1hZTCWTObe0RY+10NhfiCuR2YXpJaO
	Dond6
X-Google-Smtp-Source: AGHT+IFU3nJijIBNsm6B3bDuLSoCNQ73pwfzPnYiqQH6OAqYrzMNb3svUhszpN80Fdd0UtVEY411YA==
X-Received: by 2002:a05:6830:618d:b0:72b:946e:ccc7 with SMTP id 46e09a7af769-730060b501amr6213415a34.0.1745199254417;
        Sun, 20 Apr 2025 18:34:14 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:14 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Miklos Szeredi <miklos@szeredb.hu>,
	Bernd Schubert <bschubert@ddn.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Luis Henriques <luis@igalia.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Vorel <pvorel@suse.cz>,
	Brian Foster <bfoster@redhat.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	John Groves <john@groves.net>
Subject: [RFC PATCH 06/19] dev_dax_iomap: (ignore!) Drop poisoned page warning in fs/dax.c
Date: Sun, 20 Apr 2025 20:33:33 -0500
Message-Id: <20250421013346.32530-7-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250421013346.32530-1-john@groves.net>
References: <20250421013346.32530-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This just works around a the "poisoned page" warning that will be
properly fixed in a future version of this patch set. Please ignore
for the moment.

Signed-off-by: John Groves <john@groves.net>
---
 fs/dax.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 21b47402b3dc..635937593d5e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -369,7 +369,6 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 		if (shared) {
 			dax_page_share_get(page);
 		} else {
-			WARN_ON_ONCE(page->mapping);
 			page->mapping = mapping;
 			page->index = index + i++;
 		}
-- 
2.49.0

