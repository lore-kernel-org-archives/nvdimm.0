Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458D04A3412
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576157; cv=none; b=e/NWoTcG2Ma/2wLp5gxk2zHUOgw9RpWJ8e0uUhImgizav4jcqVsuD7surcYHDr2C9ev/xT1vAWI0+/tRKPvyHUlKQIFjZ5wo/G96ZVleBpgkrNzepyhrRW6U6njBOW0YqQPeMjI+u+Bba3fc16QxXLjG9p7qLFpEAUca0pAQBvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576157; c=relaxed/simple;
	bh=d6pCHtBqoNKDq4P4c/ZFNHldTuhwFRB86ulVg/xnwxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVR/D8qLNaciGv+P3qPYWgUabKODUH9rTh6YyPjKHXO6a9gzwB4TXsyPY88XxP+KD58easfN3gBGdNj4Md1ULWmM1VVSgzMQ/bqJHWPeNg7A3BiSLXLwOzuTsAStxj9tWAlZQ/0sKfYoyry/hfb088Ak+gKCKRUW85bGAP2kNFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=TiX71lti; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="TiX71lti"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e6c4a867cso465802185a.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576151; x=1785180951; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hwwcrXiYs5LXY1nHNJcH4eGwqAhaBzqBMJWfc0nxcvk=;
        b=TiX71lti/fGfGqI1Nq0o4bMWi1T16hMzawXuMTsk4cmVwvbIFFz8ekkpZXZxb/xbr1
         nAi/jnDKtoKLA7CSVfizAykTJKfCQRIBv0ewKO+1KZxxSuDnVyoLw6NxsSJ99+DG9OfO
         hegJ0mSqZjMgU8lC15QQkKKGtJVt4kuzjAfBqhfq+0cwt4gxRms27urAw6Rbj031Ev0z
         TfTwbhOi2/7tbUVVolw03M4lSeXS/PCTz49fgkDcy1CNwVt4b/BHnJXKEyu2F54u1yC/
         AXF0liVQ1Y/OwGGUAO3fQclDK70oGHNy4vNvzimrhP5uDYKq7Lnb1k9lVNqw7B3TEYbB
         NY8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576151; x=1785180951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hwwcrXiYs5LXY1nHNJcH4eGwqAhaBzqBMJWfc0nxcvk=;
        b=eXzsL/YDcaX+MYcpbU4muqya7uCppyX+IJ6zGfLXa0kckQeI12KLC/lNFskLy19CX/
         M2otCMc3GzQtlQJHAZfNTDXbLkOMFTFp6QV+BjHXpK6KXtaKpg9BKg3ErIMH+gtF7KML
         5y+wJxZl+JUMTBgfWw0rkwoIkcCXZzxXeSTVBl3aj52hVNbjH0tlwYRZji3CLDL/m+N4
         uALeX0s6NA8yaqkJYt4YGw2GUi44hlg7T0b1SmxDe5ZoCEcMsdXcwqmT78/mlquBz1iH
         qvpwxiXYzNDsMODXrJfPm4J0jdZAirrr+GGJlPFSfAsfjI7ib3oFESkDblGwZrN85k0d
         wDRQ==
X-Forwarded-Encrypted: i=1; AHgh+RrHUFzITdsCCs4Q/MYN476Kivop5NHJbKIsWX243aFXPTCZk0f+Mv0TW6n1X5vxjS/CqVAW+34=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz45bYBZ1SXcCo/aP4hmREMQoo474YOO4eJSz9FeZJH0HkhnD6T
	s2LHvctfQt4krZIRmGk6Pou7/6jgNe3VKdImUNfKgTqOtbZ77Q1onRsvKct7L9kb+8E=
X-Gm-Gg: AfdE7cnMVqN5S3ctJYO5V8a/NAc6CFsbaOl56dR2c0TbpGgkmPqP58/LNEnBTPxYoSK
	Iph6BzqWSZxqxFu1l2Phj/jT3LUzLyrE1FAKo7J948w9FNaCZNgXuB/DwZopllskJ04W6adUfDl
	NAt+dPfg7Wbpb6NC+LsQ9fz8ydXa9DXgBANtmYOtOCjX8naMgWi7TZPkSvE0i2htxtMYrjCa6DI
	yB2vDb0g9UtxAfgkTZ2L5tC2wHPsn8uCxOzw798LYacZpeOjPJaX8NTftXm3kE2TLTPJfFWGFlf
	jB0OxyvkiD1HBWduPfj/SWk5oqaE9zDkCfHSh1SGtqfW0rMrWVAm3M0WDz4g0mGJimYTzxaXMaK
	g70nn5pIFRHuvz64r9ZzIO/jQYLO/oCK+vfcIj+zeGuPcBz/m8Cb6UHl7D9YIBHlKnVJu05MwRL
	QlxCKsXLprhCkC3FL9q8kpYGpgkuWLA4UIHdu6Qz/uRvURi9NuHgKHJnTsxQ4Kz/k=
X-Received: by 2002:a05:620a:370e:b0:930:9a84:d90b with SMTP id af79cd13be357-930b416db01mr1583254785a.50.1784576151483;
        Mon, 20 Jul 2026 12:35:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:51 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 28/36] mm: add NODE_PRIVATE_CAP_HOTUNPLUG for opted-in private nodes
Date: Mon, 20 Jul 2026 15:34:22 -0400
Message-ID: <20260720193431.3841992-29-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add CAP_HOTUNPLUG, which allows memory_hotplug to migrate a private
node's folios for the purpose of hotunplugging memory.

Without this, hotunplug fails if any folio on the node is allocated.

Add node_allows_hotunplug() - which returns true for any normal node
and private nodes with CAP_HOTUNPLUG.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/node_private.h | 26 ++++++++++++++++++++++++++
 mm/memory_hotplug.c          |  4 ++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 655fe9ec5cb61..7b617b1fa9c28 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -14,6 +14,7 @@ struct page;
  */
 #define NODE_PRIVATE_CAP_RECLAIM	(1UL << 0)	/* allow mm reclaim */
 #define NODE_PRIVATE_CAP_USER_NUMA	(1UL << 1)	/* allow mempolicy */
+#define NODE_PRIVATE_CAP_HOTUNPLUG	(1UL << 2)	/* allow hot-unplug */
 
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
@@ -97,6 +98,26 @@ static inline bool node_allows_user_numa(int nid)
 	return ret;
 }
 
+/**
+ * node_allows_hotunplug - may hot-unplug migrate this node's folios?
+ * @nid: the node to test
+ *
+ * True for normal nodes and private nodes opted into CAP_HOTUNPLUG.
+ */
+static inline bool node_allows_hotunplug(int nid)
+{
+	struct node_private *np;
+	bool ret;
+
+	if (!node_state(nid, N_MEMORY_PRIVATE))
+		return true;
+	rcu_read_lock();
+	np = rcu_dereference(NODE_DATA(nid)->node_private);
+	ret = np && (np->caps & NODE_PRIVATE_CAP_HOTUNPLUG);
+	rcu_read_unlock();
+	return ret;
+}
+
 #else /* !CONFIG_NUMA */
 
 static inline bool folio_is_private_node(struct folio *folio)
@@ -124,6 +145,11 @@ static inline bool node_allows_user_numa(int nid)
 	return true;
 }
 
+static inline bool node_allows_hotunplug(int nid)
+{
+	return true;
+}
+
 #endif /* CONFIG_NUMA */
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1f42ed303366c..e9573f90e0dcd 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1943,8 +1943,8 @@ static int do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 			goto put_folio;
 		}
 
-		/* Private node folios cannot migrate, fail outright */
-		if (folio_is_private_node(folio)) {
+		/* Fail outright on private nodes w/o hotunplug support */
+		if (!node_allows_hotunplug(folio_nid(folio))) {
 			pr_info_ratelimited("memory offline refused: node %d pfn %lx\n",
 					    folio_nid(folio), pfn);
 			folio_put(folio);
-- 
2.53.0-Meta

