Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.231
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794917849;
	b=B6AjZJ4NLIWerFOmcXG6UnxIbJ2ascwmdN9SBX5OKQHC0o1RA3Wvh9kATPdd/Sn2s7tR
	 kHE2tE7lnwzuXTYFWvTMevM4XGYxeU/LPEa9DZyKhN/8NXdPcbSlpSazU6JG6Tjbn7Q1O
	 zAU1fzxZz0yoTG+8AdkPF4vpsOpuBtsjqcs13GI/N2IWP9VCYXBbwdunVh02ED+YkAoh2
	 pIxf6WfcCjsl318dEcO6Xvks/PUVLN6SzIe9Ts32oL2NqvKBhMD41nxB3zpNb5zeIKn0J
	 bb9oF4CztVbvxiB6g6rZXp/2Lryonn/Q+mfswOFrdcqd7ECu7RREWL77xWO3WROFumA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794917849;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=AXXxMPEgt9eEKJpgwYhNgOqc1sWnNe7LivV80ncHudk=;
	b=q4yydmEk2wgj9W3kkAnUglLC2Nx+uycWnZD57rhRXjfq2NVptlZI96MLDTDpntgvYTjf
	 5V6fJVx42yTEF5tbQIY7Nub5CNHOoviBIZ3yxLNFBTaxOBFqyWbJo+0XOEZxZBfbhwDxY
	 yZNXDiZ3kXNS3D+Uup/dHzqsMs/8LCos9gHPFlyNFF4A49W4HYBpR5e6gQLiLjMMKek4k
	 Gd/uZg32sw88XPfyPMrlaPVUcsrKewtpjys44LvtkXwpswueyfsZ5bVuaJUv7oe62hvR0
	 EHFUTwa85EeGsyr+P8hkQHYc7dGK8lvNLgMvXfeVqp4kGvcf8K71fsYShN/hi1fLfiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=BEJ1Gyie;
	arc=none smtp.remote-ip=203.205.221.231
Received: from out203-205-221-231.mail.qq.com (out203-205-221-231.mail.qq.com [203.205.221.231])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F9D606A33B
	for <nvdimm@lists.linux.dev>; Tue, 17 Nov 2026 12:17:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3F9D606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=BEJ1Gyie
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794917839; bh=AXXxMPEgt9eEKJpgwYhNgOqc1sWnNe7LivV80ncHudk=;
	h=From:To:Cc:Subject:Date;
	b=BEJ1Gyieg1w+Ffqka4yDC1j4x+ap2Fe7avg0rYAIIEGN3ZdM/xAXjm2WDNXiukfwt
	 iqdhdaG9ywvkL5FAQWd2VlniDn/VH1iNAWpmQYQdE1WprQhik2RmetyrDsCw+dOUd2
	 R9X28WQ/gPi2ghHHuruW7rUkJXD991p7DEtAxNg0=
Received: from DESKTOP-6LNKCJL.localdomain ([114.245.39.251])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 44B0D697; Tue, 17 Nov 2026 20:17:11 +0800
X-QQ-mid: xmsmtpt1794917831tpiumovc5
Message-ID: <tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com>
X-QQ-XMAILINFO: NnYhxYSyuBnLvq4fxmrGrK5xu0mwsez5ZuhTDd2o4ZBNgLhhOOzPQ5wyJ55GxV
	 A8vIc3TP23UGZcbrhJTNUNir9aPWa5PDRCyqycClygB3gvob2AObLneoeSYaTdTNhOKMTl+8Yn0y
	 4JWrmJvMIt/JashDPWeHRJ9fwNh78wJqCqB4thDn2Dh4302Fv7EDGe6BFk9QBv637p5fl3UA+i9+
	 NS2EtaovVYmJi2MwYnXQJMJeM7mpFSXwsQe9/ZKddA7jyqtl2vCio0cRQouos7BLQ7ErcldPzNdh
	 +6UI+WFMVjrfWiv0DlP5YuqyBqa7Iu2BkjKoCQx3JVAWd0kIz02ceovlxu/Gy++kt3CmWxqHqCc5
	 wglQYM2R+zFpyQ12NYh5xqu5uqeypWku/+zSfSpIzv24L6mIH0rCYwqhtwYfUOz4BRppoLdQT5iN
	 jcHqvf4rGDyKsyOLxzgOjAxliXv58+yoF6W14KMbGXWTCeHP2n7e15FHm15MttiIlhDzVnYRxs3w
	 GO4bNtI0ev/jtKqPr2kkzu2HY+lOi03P0Tns9IKAUc96iB0Q3P5dpHEXqXp7QG7nMMOJErUECUUw
	 +4d0UeF3YG9/JLfGzZaYGhc4woSoc3rDYxw+tPObJsBPjuWRcIzW/r2DXOYXjKvrt7Qz0lE7PpcA
	 ivTs9nRruDDq9vyqXpsOoTg7yzxpo2S353+WM3PdsPsf2dkeqZJbhzZa1X/oBFzPgIDRS4NCwmd5
	 U1rWGkjPFaBY4gelj6Y1DltOWxOYn+OtzPVkOY+fxV9AYVXu/BqrEOSnQfxq6FeLCIVYa+NBghke
	 x6V7MfenCXbvvEERXFntMPHdGYy4i8IRk9L+n+bOkWx5rdi2NTQmTPaEBUjHgLuS85ppzrS1x76I
	 UZynA/2FONdyKSLmOjMHrDH0w7HdDbNHpG7+Mgj0GXfXyQKf1MsJdbCX6GQlPx2ZQgyMKRvyaEel
	 qfh8f1keNjLG3R0ufduobkf9M8jBjOMiVk/Js89mhexr1/Lu47+ZQSzIjCKcKgln/kVF0Ve3DrAG
	 SYoWZSox0WBLypJHlbXBKNruCPncvXAIi5FdgsYWg+3jujI4DOsl3UodFZ5twQZUhSa621x0sGPj
	 f68vQpo2h8hd72LSoJXwcEY6V0MQ==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Jingyi Sun <1045704958@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>
Cc: Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] mm: uffd-wp marker on a DAX file mapping: SIGBUS on write, endless refaults on read
Date: Tue, 17 Nov 2026 20:17:11 +0800
X-OQ-MSGID: <20261117121711.1088-1-1045704958@qq.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

On a DAX-mounted file, a uffd-wp PTE marker installed with
UFFD_FEATURE_WP_ASYNC is treated as an already-mapped page when the
page is later faulted in, which makes writes fail with SIGBUS and
reads refault forever.

Path (v7.3-rc2, unchanged in v7.4-rc3 and mm-unstable):

  handle_pte_marker()
    pte_marker_handle_uffd_wp()
      do_pte_missing()
        ext4_dax_huge_fault() -> dax_iomap_fault() -> dax_fault_iter()
          vmf_insert_page_mkwrite()
            insert_page_into_pte_locked()

insert_page_into_pte_locked() only checks !pte_none(pteval) to decide
that something is already mapped. The uffd-wp marker is non-present
but not none, so:

 - write fault (mkwrite == true): pte_pfn() is called on the marker,
   which does not hold a PFN; the comparison with page_to_pfn(page)
   fails, WARN_ON_ONCE(!is_zero_pfn(...)) fires and -EFAULT is
   returned, so the task gets SIGBUS;
 - read fault (mkwrite == false): -EBUSY is returned, which becomes
   VM_FAULT_NOPAGE, the marker is never replaced and the task refaults
   on the same address forever (about 3.5 million faults in 20s in our
   test). The task stays killable.

vma_can_userfault() allows any memory type when only WP is requested
together with UFFD_FEATURE_WP_ASYNC, so DAX VMAs can get these markers.
Programs using async uffd-wp for dirty tracking (e.g. with
PAGEMAP_SCAN) on DAX files are therefore killed or stuck.

Reproducer (x86_64 in QEMU, v7.3-rc2, memmap=256M!512M as /dev/pmem0,
ext4 mounted with -o dax=always):

 1. create and fsync a file on the DAX mount (some pages written, one
    page left as a hole by ftruncate);
 2. mmap() it MAP_SHARED, PROT_READ|PROT_WRITE, without touching the
    pages;
 3. userfaultfd with UFFD_FEATURE_WP_ASYNC, UFFDIO_REGISTER with
    UFFDIO_REGISTER_MODE_WP over the mapping, then UFFDIO_WRITEPROTECT
    (MODE_WP) over the whole range; /proc/self/pagemap now shows
    uffd-wp=1, present=0 for the pages;
 4. write to a page: WARNING at mm/memory.c:2495 and SIGBUS (3/3 runs,
    both for an allocated block and for the hole);
    read from a page: the task never returns from the fault (3/3).

Controls behave normally on the same kernel: the same steps on DAX
without userfaultfd, and with userfaultfd on shmem instead of DAX.

As an attribution experiment only, treating a non-present PTE as none
in insert_page_into_pte_locked() makes both symptoms go away, but that
drops the write-protect state, so it is not a proposed fix. A proper
fix probably either installs the page while keeping the uffd-wp bit
(pte_mkuffd_wp()) when replacing a uffd-wp marker in the DAX insert
paths, or refuses uffd-wp on DAX VMAs in vma_can_userfault(). The
same !pte_none() pattern exists in insert_pfn() and in the PMD-level
insert path; those were not tested.

A similar present check was proposed in "mm: compare pfns only if the
entry is present when inserting pfns/pages" (RFC, June 2025), which
described the pte_pfn() on a non-present entry as not expected to cause
harm in practice; that hunk is not in mainline. The reproducer above
shows a user-visible effect. Note that returning -EBUSY for a
non-present entry alone would only turn the SIGBUS into the same
endless refault as in the read case.

Link: https://lore.kernel.org/all/20250617154345.2494405-4-david@redhat.com/

The issue was found with a research static analyzer for
cross-architecture dependency bugs (it flags calls to helpers such as
pte_pfn() that are only defined for present entries) and confirmed
with the QEMU reproducer above. I can share the full reproducer
program.

Thanks,
Jingyi Sun

