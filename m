Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3718E27CB16
	for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 12:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749643625; cv=none; b=bb4eWylUGTsxJZ8GTBvokbRB96+3tL8PTNR9rJUznFj0xKqdxCiABqKTh/jA2BaviJ4ty1ASqZfWmf/rweVx71eFdSwl/5F0x1KO8IBFp1g5zU5H3+7P3seYqefcOBf+RDcp39kDdwHMomy66/DsYcImj+N8zIcECZ4d7eWGrIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749643625; c=relaxed/simple;
	bh=h6QGnb8zTCnhmMnnsmFX1orisHdA4F9SQbVi0UTlgeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=Rm1pajI3pjoq8D1kJtYqRg56CyHuU7J+HI09ew3wLCheBKEYMLBhbCiKchjp3wEWQFIC4v04jiUAy9G6VePG78DNbxUJ4GSDygWR+RA9tKPRx/849/IGSmsloRcXG6BpwuO/hLNpRg2ecCFeRac1/pGZYxctGGp06PrwWWKV4PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IV1/Wlt0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IV1/Wlt0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749643622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=e6LfLWwblq0nS0hH5xaHOxT0zDNtTct6Zz6olIqQVMs=;
	b=IV1/Wlt0BtKfgzfmMC0L3jjbAo7nMGqm9x7K83MU1BF9il5JBewRoG7MZBE0hZfyo+NSqf
	Drj4QtoqcRgAeOCnHW9P4xdFbkh86+S2zBgRSOjCSzqUqegx2Oxiz1vwqrgsZN/UGcCnmz
	VjOucqXAU20GAyKQP7HwGv6jfa58yGI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-XVQjtpcqNn6ysm9ye4HnVg-1; Wed, 11 Jun 2025 08:07:00 -0400
X-MC-Unique: XVQjtpcqNn6ysm9ye4HnVg-1
X-Mimecast-MFC-AGG-ID: XVQjtpcqNn6ysm9ye4HnVg_1749643620
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7d09ed509aaso1158274985a.3
        for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 05:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749643620; x=1750248420;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e6LfLWwblq0nS0hH5xaHOxT0zDNtTct6Zz6olIqQVMs=;
        b=iwKtJvPR4d5up5Lac8OvqCq9iKDa7RcpEAxvZXCC0XG6olP62rCVskL3/pFqTE0Z2X
         wD79Ap7hYOEGI3jBDgoUk4XVTS9HZ+GINlfL/ckYu3RdKE+kpGS3xwPDlt/yBklhj8S5
         ydGFbHjTjJ7YSQOa49+AVbzxJAQP2QDw7ibygnmvSRKxSaO46QYi/qwCjG2trl70CqRA
         MjEoin5UBKkquNreEx8Y8wMjw6vsIWPcxkjagX/4qosIX+2e2h+QBLUIdsegsbJiQ+E+
         Yipc0BbgaNUzjI3Q+eat0Qtc1qsVtX7DE4uE7BxdSPWCII7I8oJshQblqzC+dANDRgGN
         0wjA==
X-Forwarded-Encrypted: i=1; AJvYcCWZNF5LO+GujLihlVZtN90g+FsQbSk4UDMnOlzpEHWXktrRDfHU0Yn+e6Qdq77bVOsF6GAphTg=@lists.linux.dev
X-Gm-Message-State: AOJu0YziDhR22VpoGCvLpp1GMObE/3hzLgsYpfQpqEIVds60RX6b6yp2
	JHeF+gGO+wMJADQ7GpTC7oJbh1V8FlkIqT3NFrNiyDoxC2dvtGAHaJIzVvHR74lof+wLcfEy5mi
	OWl19aa7BH+Cywvi5M/+3xaznKqLvcP3lhftmBjXnGvw02VZwTWvLUdpFEQ==
X-Gm-Gg: ASbGncugPZ8OKd/FZEW6GCzkTyaSnReyEXgh8dX9JtKCqCCpB9yAdgAb29SXCnSgkSr
	ANX2faIlul5zIepjIijZy9V7Gd70D/CLghRCn0b9CWAgjSMeKm2oSh7rkAeFQe0nJczJRoudHs6
	Wu9rKHz/ORFmFy8X4MowyaCRbRqghmlHa1xU72m9mqVlaKLBOlnpYS/ABBonHoJk2eiaPhX3o1K
	AIJ0lewfFmhVRiOTCoXfPaxjkBj5CJIcQXdZFwu74B7QPLxrLt65fN3/nZnJ/2judZB9w+43rWU
	7yJmSYYekjjnPAaUdzBVJnBfiKpMJwGDwg+awZbqFg==
X-Received: by 2002:a05:620a:1707:b0:7d3:a6e3:769 with SMTP id af79cd13be357-7d3a8a023camr487205685a.54.1749643620057;
        Wed, 11 Jun 2025 05:07:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+nvpy4eZgQ3IggiGnz01S9n6WnULoMe0QCjNT4gmRa+I93C9/yB+cBKGgJVnp79XMZ/tWiQ==
X-Received: by 2002:a05:620a:1707:b0:7d3:a6e3:769 with SMTP id af79cd13be357-7d3a8a023camr487198585a.54.1749643619433;
        Wed, 11 Jun 2025 05:06:59 -0700 (PDT)
Received: from localhost (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-7d25a608ff5sm855840885a.76.2025.06.11.05.06.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jun 2025 05:06:58 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH v2 0/3] mm/huge_memory: vmf_insert_folio_*() and vmf_insert_pfn_pud() fixes
Date: Wed, 11 Jun 2025 14:06:51 +0200
Message-ID: <20250611120654.545963-1-david@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _lCv3SC1KtEgT-hruAV2wCMGCPVgK1ZVd8pSmb3eDMo_1749643620
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This is v2 of
	"[PATCH v1 0/2] mm/huge_memory: don't mark refcounted pages special
	 in vmf_insert_folio_*()"
Now with one additional fix, based on mm/mm-unstable.

While working on improving vm_normal_page() and friends, I stumbled
over this issues: refcounted "normal" pages must not be marked
using pmd_special() / pud_special().

Fortunately, so far there doesn't seem to be serious damage.

I spent too much time trying to get the ndctl tests mentioned by Dan
running (.config tweaks, memmap= setup, ... ), without getting them to
pass even without these patches. Some SKIP, some FAIL, some sometimes
suddenly SKIP on first invocation, ... instructions unclear or the tests
are shaky. This is how far I got:

# meson test -C build --suite ndctl:dax
ninja: Entering directory `/root/ndctl/build'
[1/70] Generating version.h with a custom command
 1/13 ndctl:dax / daxdev-errors.sh          OK              15.08s
 2/13 ndctl:dax / multi-dax.sh              OK               5.80s
 3/13 ndctl:dax / sub-section.sh            SKIP             0.39s   exit status 77
 4/13 ndctl:dax / dax-dev                   OK               1.37s
 5/13 ndctl:dax / dax-ext4.sh               OK              32.70s
 6/13 ndctl:dax / dax-xfs.sh                OK              29.43s
 7/13 ndctl:dax / device-dax                OK              44.50s
 8/13 ndctl:dax / revoke-devmem             OK               0.98s
 9/13 ndctl:dax / device-dax-fio.sh         SKIP             0.10s   exit status 77
10/13 ndctl:dax / daxctl-devices.sh         SKIP             0.16s   exit status 77
11/13 ndctl:dax / daxctl-create.sh          FAIL             2.61s   exit status 1
12/13 ndctl:dax / dm.sh                     FAIL             0.23s   exit status 1
13/13 ndctl:dax / mmap.sh                   OK             437.86s

So, no idea if this series breaks something, because the tests are rather
unreliable. I have plenty of other debug settings on, maybe that's a
problem? I guess if the FS tests and mmap test pass, we're mostly good.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>


v1 -> v2:
* "mm/huge_memory: don't ignore queried cachemode in vmf_insert_pfn_pud()"
 -> Added after stumbling over that
* Modified the other tests to reuse the existing function by passing a
  new struct
* Renamed the patches to talk about "folios" instead of pages and adjusted
  the patch descriptions
* Dropped RB/TB from Dan and Oscar due to the changes

David Hildenbrand (3):
  mm/huge_memory: don't ignore queried cachemode in vmf_insert_pfn_pud()
  mm/huge_memory: don't mark refcounted folios special in
    vmf_insert_folio_pmd()
  mm/huge_memory: don't mark refcounted folios special in
    vmf_insert_folio_pud()

 include/linux/mm.h |  19 +++++++-
 mm/huge_memory.c   | 110 +++++++++++++++++++++++++++------------------
 2 files changed, 85 insertions(+), 44 deletions(-)

-- 
2.49.0

