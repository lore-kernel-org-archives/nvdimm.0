Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E612F49FF
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568659; cv=none; b=K2FAxKNC6LOZ0ftlEx9Sl2ynII/wY6vptMT7IEAmMJnpYos+lSA6ge2LqRar0l5Rl0hraogPHxrrdiWMj8DIcrPfB2WXPQGQBzSghLofXjcsvA/0WEJFND4c2JjzfaYjlpgCJuDoHbkuHaR3ldhTFSO+QgOXhVzu3V1K+a+zvH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568659; c=relaxed/simple;
	bh=9z/0+wP63OG5wXftLWkn27sSwdysRUwo3gRSnRSt66U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HMWHow8dL7Nns5Egqc9qxNYMqzqLi8nKN7iEixXOKWjvWA/RYBEefjJFywYdvMRcwkC77AMdRm4rkDY/Uf4ha/02ficMGrDV5czWfjbL2KyoTgKwmQx19TFqhJuZEXUlZWGNb8IdAw+o/yh5O1Ui/Zx2TZAJMLJV0p2k+u2k6jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KEKCyVJV; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KEKCyVJV"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-736f1953673so76584a34.0
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568657; x=1752173457; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHFHSP5AI7GYN3LviveRts2reQTV/UFJRypYogMzU4M=;
        b=KEKCyVJVg+//PJpBYLeMeilD7psVrieScCQ4foGIZ90bCRnHUGI4I7MlFe+N+j/cPf
         /Ci0Ztyhr/cFIxyusC/NkY6Drb0SgBPktBQgAFGf3e+WNxrQGCKYhANvRcnrfikpvt0e
         5Y//czAGdaDN+KHXPgWprQmage1FzGFxUz4u6Zd2UEZlMnf9mynuBeF76DOzEqugYu33
         wLU2QEfxbZy/xqKNxUcTe2VV/ryo0vog9QPNIMHFN0tXhWAV0el57WoOUSKv2XMzZ8++
         rELmgLRHaZoduLqT+eo5SBVRO6tHyWMOqS1szdlpyBqjs4IPrlZK//hiEAFrPweJbMoH
         5B5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568657; x=1752173457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jHFHSP5AI7GYN3LviveRts2reQTV/UFJRypYogMzU4M=;
        b=rvcjOmw6aYQQVNszxW5hTqlGWyPsLAgr+3Rp/qxkPTeT+rgSb4+0814ie2/L5JkJpS
         eTU3pWKvRIx37sZOPg1cKGRMTVVqQoVAFZii9JvmS4AKoZUwtEUKg8VA6kWXg7zHvcW1
         mA3xNkKaSVmWf9RdRuSOtGb2nUh9gYWrpIbjHCCa6lkVSsnP1jNrfrL0gt8B/lnZ/F7+
         Q/737pVAJNqEmu1a/iv2kgCnMJO9ZRqJOT5MJZ2gI+Wo4rUbN5iRn1tZ/e2gK+1dgHaY
         2To9P+OGAJ5NMsrE5cYpDp8OJ4UdMDtzv0KcuYZXB/tVu+TFNu4m9gjmS7fvsLO4ZwsA
         GgmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXM4+j2FLvjM3upHS9PrUAW/v0WUUdC38Cq+1Y0oMwEP+pE4+ADVDHxO1DhkS1bAQBC3BJWBGg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwEvANEjMuMqH1DTKxny8jMjvRy400FR901R1XL5Z+cFzQkSEpA
	YHevH274Epui+tLE2UxBTU2eFhF4Hdp2HkHGwfkZdFs7rP6/uUAT91Bb
X-Gm-Gg: ASbGncuNiF2xgony6zOtN2jOl+00EWtIwFxplOWBDESnTHQpPSJgH259xSsRE4cXZQt
	E23zSl/L13VMnti2oc9eJsIsIKfkUE07nRMdrWXfpx0c9Sr1nFEJhaR6HkFTqxJtMu1+5aC54QM
	1aOENsSQlx109YFLhS3btQ7C9O+iIxuwGfIuXgxtTiA5y+pstjVSJtaab2C1w8MAGkgTnhizah4
	tF4gwDr7SlvnB8vOG3Nvyrordwc66+ca6EI0NJ+2KDc5PfsoR5ATfD3YfJOOddj8r5C5ORuVZDJ
	tGv8yuIBGdsMvYYgF7nXusIVtaeNRuYXcen011nNQ1vImcMn+kEfcCh6vNM7UBGUC2mnRiXqoAs
	+G+mr/s63Rv0JAA==
X-Google-Smtp-Source: AGHT+IF0yW0ffG1FgWh4UvPzdITwKwUQUwagTaujR+MOBNLBlFUmukcBu+glnTJT7fKxI7YS3bMYPA==
X-Received: by 2002:a05:6830:440b:b0:72a:11aa:6ebd with SMTP id 46e09a7af769-73c897e113dmr3275732a34.23.1751568656688;
        Thu, 03 Jul 2025 11:50:56 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.50.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:50:56 -0700 (PDT)
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
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
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
Subject: [RFC V2 06/18] dev_dax_iomap: (ignore!) Drop poisoned page warning in fs/dax.c
Date: Thu,  3 Jul 2025 13:50:20 -0500
Message-Id: <20250703185032.46568-7-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250703185032.46568-1-john@groves.net>
References: <20250703185032.46568-1-john@groves.net>
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

