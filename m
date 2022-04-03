Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1AA1FBD
	for <nvdimm@lists.linux.dev>; Sun,  3 Apr 2022 05:41:25 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id x2so5692098plm.7
        for <nvdimm@lists.linux.dev>; Sat, 02 Apr 2022 22:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qCp2b48ULThIjDs7kZ69Cjh0BLYiJwB01qLpS62xP+w=;
        b=lwrBARs+/7DTDJPCPDkO87hzSIKPt6GQ3BJuVqyr1LMMRf0ELecQkoLiSNJjbiZdpd
         OOw8+jdaEjkrKEkQOCmLvwQJzHLz27JTlGJ5zE2dn5Jip53qlttwM0FkCYZueUeb7zeF
         RVGdSY44kEkFd3NNdpkbB9EPEooKpn6V9VAwbVH27fUkD5jUhTGJPGtIrzGx+IUgXU/O
         uu1GRfpRmgRGEwvWhRZtaM7CW/f27In9HxOfBsluDtGcV56/sxLL1FJ//gEuOidep45r
         /RAHUxBOsm5BUtauhEFj88JE1ydBVybi1r2rzExNbwhHo6EWG1darzCFI36vXEKt9WKC
         z0qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qCp2b48ULThIjDs7kZ69Cjh0BLYiJwB01qLpS62xP+w=;
        b=jwIM+E6Wd4nbMKvvGQ4yJbcczQ322EUzJYydst8e0/xDNaG75fPiQtH1SD9qnS4b+h
         u0E/pOZU8G+ffiE4y2gRFvNvp/+JxU3lLo/6Zu8CKzK1nT+o9PogwP66OZajG0/Oniys
         58XiXOh17ur1uBL1OhUYBGLZj675iIyicYmRpbhIVNUyTw6UtWZqX6Pyd+2LLqYh7uGZ
         Spqc2ENv3e5ocH5We4cPkTQHB+3M1Rq+doyoMYTXoi4CZGtJeth1CXoVIrpFgi3LA0an
         viZJuruZKz9ey9DG+1ZoN1sDPe8UkujFd4qt+uNxM+qixuC3dVrzE7EMeLwoYG7qPkid
         2WsA==
X-Gm-Message-State: AOAM531xUT8NwLyicuruUPWox/7LERiQ5YEt9U2hzk6aWSWvnLRh0PkS
	2sOFYtyCDvc8jvRmxr1Q+x28WA==
X-Google-Smtp-Source: ABdhPJwPE+R5M1c944zWgzZX/rK39iXrxGm2KhaVKut5BUEWAAHDPdGQ5lQJXH1Kcs/14QSL7BveZw==
X-Received: by 2002:a17:90b:4b42:b0:1c7:3f6a:5d97 with SMTP id mi2-20020a17090b4b4200b001c73f6a5d97mr19591035pjb.27.1648964484666;
        Sat, 02 Apr 2022 22:41:24 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.245])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f70d5e92basm8262479pfx.34.2022.04.02.22.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 22:41:24 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	shy828301@gmail.com,
	rcampbell@nvidia.com,
	hughd@google.com,
	xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com,
	zwisler@kernel.org,
	hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	duanxiongchun@bytedance.com,
	smuchun@gmail.com,
	Muchun Song <songmuchun@bytedance.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v7 2/6] dax: fix cache flush on PMD-mapped pages
Date: Sun,  3 Apr 2022 13:39:53 +0800
Message-Id: <20220403053957.10770-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220403053957.10770-1-songmuchun@bytedance.com>
References: <20220403053957.10770-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
However, it does not cover the full pages in a THP except a head page.
Replace it with flush_cache_range() to fix this issue.  This is just a
documentation issue with the respect to properly documenting the expected
usage of cache flushing before modifying the pmd.  However, in practice
this is not a problem due to the fact that DAX is not available on
architectures with virtually indexed caches per:

  commit d92576f1167c ("dax: does not work correctly with virtual aliasing caches")

Fixes: f729c8c9b24f ("dax: wrprotect pmd_t in dax_mapping_entry_mkclean")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 67a08a32fccb..a372304c9695 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -845,7 +845,8 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
 			if (!pmd_dirty(*pmdp) && !pmd_write(*pmdp))
 				goto unlock_pmd;
 
-			flush_cache_page(vma, address, pfn);
+			flush_cache_range(vma, address,
+					  address + HPAGE_PMD_SIZE);
 			pmd = pmdp_invalidate(vma, address, pmdp);
 			pmd = pmd_wrprotect(pmd);
 			pmd = pmd_mkclean(pmd);
-- 
2.11.0

