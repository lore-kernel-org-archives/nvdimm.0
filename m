Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27077A
	for <nvdimm@lists.linux.dev>; Sat, 14 May 2022 14:26:24 +0000 (UTC)
Received: by mail-lf1-f44.google.com with SMTP id u23so18988979lfc.1
        for <nvdimm@lists.linux.dev>; Sat, 14 May 2022 07:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=Li6/tQDXHzv8kZiOpKUQD1TPJCVlsntTcNVJC7DZIzE=;
        b=Kotfmd59T2vwKoH6qJP7H7l9uJqBl4fvklMdaJmEksj2Hc2/NE0Q/bFCFcQRipTg50
         gWoPxS8tp+9YBXdLbEdFKp4dNu3+ECSYOiv3E63hYcBSm4oEHOtgE1TIAjkYkXu4c0zV
         QFoLt5LtKLO/qBTEJ0e566ZyqeuGymbwkbwq1HnmkuMnOzDvFvrJRKmYmhD5tD1gwleZ
         KBvcKVuZZlEFwkqsdsTIzRn9ByRm81I5XWGw0FrSFGjv25l1dzLHqhMwD+XSV3hTE6lQ
         ssPP6XT1mDkzEUND+/7zc84awYm1BczkR73aLT5GUdQHzSsgP2RYrAJiTAODHffOGiz9
         Ytzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=Li6/tQDXHzv8kZiOpKUQD1TPJCVlsntTcNVJC7DZIzE=;
        b=deamPDfrRg/QJ/m3OSWHC3AgHTQ57RENY2U1XLgSxqfXHDNJAVffbu4GxervO5KrCE
         4V8l6CoMJZrtoOXIiwguKv1nfFDxvsFf3Mporim5aPYsvVB6v7Hl8pF++nuk75+/Z6bi
         7VTXxgunlPJRcUulUuZH40+dwfChoYSVwXgcHfPKLqQCthWZ1dO5F8wyzyM88aQV1oBk
         JkrieGMirzvuTRCX4+0Rg3VWwG9JdzcOxGqgtd1A1gIifCzSdkUGHgTjSirEkIvp8h0q
         M6nWBzzPKGQ5QU0FNA9N9z59CprGrOK5XgE6iJESX+ac6GqBogiqjQUPuLGqmGKcMfRs
         qkMA==
X-Gm-Message-State: AOAM533ic93cXEZGVM5+mkz03BPNDgKHGtAnh5x0mV4HQraXiYNccvHg
	OpT7jXG4BKMk92LouTZK8vjB9Q==
X-Google-Smtp-Source: ABdhPJx20/rdz5gh/QUmWaR3qdzEbffKnh5fGQECoYVJthQjwM0Qnnpm5/Eygnyzr8pA3B6MQmmy/A==
X-Received: by 2002:a05:6512:a92:b0:45c:6b70:c892 with SMTP id m18-20020a0565120a9200b0045c6b70c892mr1034464lfu.124.1652538382834;
        Sat, 14 May 2022 07:26:22 -0700 (PDT)
Received: from [192.168.1.65] ([46.188.121.177])
        by smtp.gmail.com with ESMTPSA id d15-20020ac25ecf000000b0047255d210f7sm727847lfq.38.2022.05.14.07.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 May 2022 07:26:22 -0700 (PDT)
Message-ID: <cf47f8c3-c4f3-7f80-ce17-ed9fbc7fe424@openvz.org>
Date: Sat, 14 May 2022 17:26:21 +0300
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From: Vasily Averin <vvs@openvz.org>
Subject: [PATCH] sparse: use force attribute for vm_fault_t casts
To: Dan Williams <dan.j.williams@intel.com>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Cc: kernel@openvz.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Fixes sparse warnings:
./include/trace/events/fs_dax.h:10:1: sparse:
    got restricted vm_fault_t
./include/trace/events/fs_dax.h:153:1: sparse:
    got restricted vm_fault_t
fs/dax.c:563:39: sparse:    got restricted vm_fault_t
fs/dax.c:565:39: sparse:    got restricted vm_fault_t
fs/dax.c:569:31: sparse:    got restricted vm_fault_t
fs/dax.c:1055:41: sparse:
    got restricted vm_fault_t [assigned] [usertype] ret
fs/dax.c:1461:46: sparse:    got restricted vm_fault_t [usertype] ret
fs/dax.c:1477:21: sparse:
    expected restricted vm_fault_t [assigned] [usertype] ret
fs/dax.c:1518:51: sparse:
    got restricted vm_fault_t [assigned] [usertype] ret
fs/dax.c:1599:21: sparse:
    expected restricted vm_fault_t [assigned] [usertype] ret
fs/dax.c:1633:62: sparse:
    got restricted vm_fault_t [assigned] [usertype] ret
fs/dax.c:1696:55: sparse:    got restricted vm_fault_t
fs/dax.c:1711:58: sparse:
    got restricted vm_fault_t [assigned] [usertype] ret

vm_fault_t type is bitwise and requires __force attribute for any casts.

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 fs/dax.c                 | 22 +++++++++++-----------
 include/linux/mm_types.h | 30 ++++++++++++++++--------------
 2 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 67a08a32fccb..eb1a1808f719 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -560,13 +560,13 @@ static void *grab_mapping_entry(struct xa_state *xas,
 	if (xas_nomem(xas, mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM))
 		goto retry;
 	if (xas->xa_node == XA_ERROR(-ENOMEM))
-		return xa_mk_internal(VM_FAULT_OOM);
+		return xa_mk_internal((__force unsigned long)VM_FAULT_OOM);
 	if (xas_error(xas))
-		return xa_mk_internal(VM_FAULT_SIGBUS);
+		return xa_mk_internal((__force unsigned long)VM_FAULT_SIGBUS);
 	return entry;
 fallback:
 	xas_unlock_irq(xas);
-	return xa_mk_internal(VM_FAULT_FALLBACK);
+	return xa_mk_internal((__force unsigned long)VM_FAULT_FALLBACK);
 }
 
 /**
@@ -1052,7 +1052,7 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
 			DAX_ZERO_PAGE, false);
 
 	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
-	trace_dax_load_hole(inode, vmf, ret);
+	trace_dax_load_hole(inode, vmf, (__force int)ret);
 	return ret;
 }
 
@@ -1458,7 +1458,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	void *entry;
 	int error;
 
-	trace_dax_pte_fault(iter.inode, vmf, ret);
+	trace_dax_pte_fault(iter.inode, vmf, (__force int)ret);
 	/*
 	 * Check whether offset isn't beyond end of file now. Caller is supposed
 	 * to hold locks serializing us with truncate / punch hole so this is
@@ -1474,7 +1474,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 	entry = grab_mapping_entry(&xas, mapping, 0);
 	if (xa_is_internal(entry)) {
-		ret = xa_to_internal(entry);
+		ret = (__force vm_fault_t)xa_to_internal(entry);
 		goto out;
 	}
 
@@ -1515,7 +1515,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 unlock_entry:
 	dax_unlock_entry(&xas, entry);
 out:
-	trace_dax_pte_fault_done(iter.inode, vmf, ret);
+	trace_dax_pte_fault_done(iter.inode, vmf, (__force int)ret);
 	return ret;
 }
 
@@ -1596,7 +1596,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	 */
 	entry = grab_mapping_entry(&xas, mapping, PMD_ORDER);
 	if (xa_is_internal(entry)) {
-		ret = xa_to_internal(entry);
+		ret = (__force vm_fault_t)xa_to_internal(entry);
 		goto fallback;
 	}
 
@@ -1630,7 +1630,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		count_vm_event(THP_FAULT_FALLBACK);
 	}
 out:
-	trace_dax_pmd_fault_done(iter.inode, vmf, max_pgoff, ret);
+	trace_dax_pmd_fault_done(iter.inode, vmf, max_pgoff, (__force int)ret);
 	return ret;
 }
 #else
@@ -1693,7 +1693,7 @@ dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
 		put_unlocked_entry(&xas, entry, WAKE_NEXT);
 		xas_unlock_irq(&xas);
 		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,
-						      VM_FAULT_NOPAGE);
+						      (__force int)VM_FAULT_NOPAGE);
 		return VM_FAULT_NOPAGE;
 	}
 	xas_set_mark(&xas, PAGECACHE_TAG_DIRTY);
@@ -1708,7 +1708,7 @@ dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
 	else
 		ret = VM_FAULT_FALLBACK;
 	dax_unlock_entry(&xas, entry);
-	trace_dax_insert_pfn_mkwrite(mapping->host, vmf, ret);
+	trace_dax_insert_pfn_mkwrite(mapping->host, vmf, (__force int)ret);
 	return ret;
 }
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 8834e38c06a4..57cc4918b1b1 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -745,20 +745,22 @@ enum vm_fault_reason {
 			VM_FAULT_SIGSEGV | VM_FAULT_HWPOISON |	\
 			VM_FAULT_HWPOISON_LARGE | VM_FAULT_FALLBACK)
 
-#define VM_FAULT_RESULT_TRACE \
-	{ VM_FAULT_OOM,                 "OOM" },	\
-	{ VM_FAULT_SIGBUS,              "SIGBUS" },	\
-	{ VM_FAULT_MAJOR,               "MAJOR" },	\
-	{ VM_FAULT_WRITE,               "WRITE" },	\
-	{ VM_FAULT_HWPOISON,            "HWPOISON" },	\
-	{ VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" },	\
-	{ VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
-	{ VM_FAULT_NOPAGE,              "NOPAGE" },	\
-	{ VM_FAULT_LOCKED,              "LOCKED" },	\
-	{ VM_FAULT_RETRY,               "RETRY" },	\
-	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
-	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
-	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" }
+#define faultflag_string(flag) {(__force unsigned long)VM_FAULT_##flag, #flag}
+
+#define VM_FAULT_RESULT_TRACE			\
+	faultflag_string(OOM),			\
+	faultflag_string(SIGBUS),		\
+	faultflag_string(MAJOR),		\
+	faultflag_string(WRITE),		\
+	faultflag_string(HWPOISON),		\
+	faultflag_string(HWPOISON_LARGE),	\
+	faultflag_string(SIGSEGV),		\
+	faultflag_string(NOPAGE),		\
+	faultflag_string(LOCKED),		\
+	faultflag_string(RETRY),		\
+	faultflag_string(FALLBACK),		\
+	faultflag_string(DONE_COW),		\
+	faultflag_string(NEEDDSYNC)
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
-- 
2.31.1

