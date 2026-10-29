Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793243122;
	b=w3XCUOEBsF1VgBJA/C6KfIWdIDxwqHUJoRaxw76yAiy5GwBujM6OtY7Zq1OcMNAiGvcz
	 yiw2MebTLs4aIXytaUQQhiqKX360mllxt1HA3uiEI3PGZvev+zCjzrdAAvAH58wSEz2JP
	 4cSq1ECeh3yttw6yBOc5svjoav7u3O4A4J6bskQpPiVG/JFPhZ3p7FYeEEGDoIfCQI58m
	 9zPJAa7FbHz7EAqFA0n2FnbglRoPulc6rc498OWYMNtl4FFeGNLAvs5rnbWpx1gFtom/K
	 TDGnnl6Cta0UMJPuLraICZOREBnqm0MPwclG2VU0zf/oNgYzNl89Qk4l2IkTlk9OgtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793243122;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=Qt+rBjELLMxb0qTKo9uNTiwBY/+V4YZH/Ya3Tn3lncw=;
	b=bbfNb6esGmJ4iZ5FOtyiu1pQdTZ6ubrBsP2Sbh5DFizo4Tzt1chozN7q+SHlFl7962BG
	 HCBIFCnLiCEa2ukEJW6QGRgxmxpmIIvf655I8JnmVXFvGZUZUG4nZaMb7XxkN8kTZPuS4
	 P1Booe113HGdpl4ri2w/GVXrIOBu69YXqEvElp6OlJnXOwgelOaH+hVEU2UyY3VFgaHkJ
	 dhxM1MLCyilvI+DjHx3WrQaOUUbiABbNyssnqDWgH1IwfuMrWabVnShxrW+y4JRoeSpB+
	 M/U+60f625jQ4fC62OgAw4RhhtDLESGTC8gnLFfvnsVf+UlQ5uizsf0WbfH0bGJGiiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n3YcqQOE;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2E8606A31A
	for <nvdimm@lists.linux.dev>; Thu, 29 Oct 2026 03:05:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B2E8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n3YcqQOE
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc4be0e5351so726606a12.0
        for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 20:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793243122; x=1793847922; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qt+rBjELLMxb0qTKo9uNTiwBY/+V4YZH/Ya3Tn3lncw=;
        b=n3YcqQOEePvs5SCjyeOmEe+dfUMuByhzDYuwlSY/GtwLD0oZdldkEJdMuJSXIt243R
         1hmYnfhtjO8yQYOO2q23LfpMQEWiliDJlM8+JcZHX1Eln59JUhWQNG5XPZMESwRV25uC
         xn1yfCwb5duv6gdSmDvzoDtUcpa/cYaSc4dG67Ls/FfkkO++7yLpHhPZJNnTAdloV0gg
         1hZcR4jSKSYWfPQRvxRozNZliCgii2AxacJ4FtuvWt5j12DWdV6iveepz3zGZZW7Kkbo
         e1u3Z88vh4NDvlYUmg7bw2Jap8xCvIx5+P+Xe7lAk12o21gv6qUan0F4YYNm941YjdRJ
         i0iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793243122; x=1793847922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qt+rBjELLMxb0qTKo9uNTiwBY/+V4YZH/Ya3Tn3lncw=;
        b=IyJ6JuPT1MBoNMAWLt2jESJAcUW4oJlZQklfjtOk+5Gt7MVqzQ/RFXsYtyXcvsX50c
         DHyk4UJrGThOUGCXdF5FXyF9/ZV+Cf9rmy/KZ+dskpCCqQnLi7krdtiwMobhabUKjEI3
         NAKKADEKLRsMqL4Lz+ZRU+aLZFc6UulSLSjZw144MSRLDjJcWBfDN5vTr+i0ymtInVvM
         1gtEoF06x0qlrYQ2FWTv/NbvF+PzdLjj3vAQYw1uWxgizZCmFatSnXN9ZGmcjEFqL6Rc
         yCGDTcgk2ljzQj26K+avu/rMWk/TrkyLcMVZlWXHGFFTYGR9P2qjDIQPU6r98XI0XeKl
         yPaw==
X-Forwarded-Encrypted: i=1; AKwUvBySYtQWizuyiJg+gEFxL3NpLmV/7DfNK1XC3lJquZZRFR7405c86XcF3I14ujDqLbRYcWwz4dI=@lists.linux.dev
X-Gm-Message-State: AFq9FYLmI0CJWSvDx5/wu7nNy9LHg9wjB+BC7gPV/F2eGCDOvaZ8JpWz
	vFEXIU/hp8b2aDNrh4YVyFx1EHbk1S1iH87xcwF5mLeQtNbky5Lo6yTb
X-Gm-Gg: AYBFou2nGD9K1QOz+OImv/UE79QiAZsurV5a9UvBUfJruM/N3POtlvy+FA0W9RTfai+
	z8ojVlxNMmbdroJly5dgJzFmGuUkV7kUdL8rXn0WK3qfrUC6sUyi4oGhtRGKwUtJ4esyMzE5dQx
	jeiZFgHOUfqKxn21p1KKmzYepUXoTPdT/1K3m66OnbdDAaHAZT7NFfSA1wRs1MFmePhme510tuT
	XN7BT9BHWW4drOlvS7pEuNqr0fDBBVOse1Ddm3iBb3rXrPcmWM0xDhb865R5FCoF8ltu37sKB5z
	MzqiAc0rvpl/tOTxoW3YJ1NITwpYpz+b1Zu1ZpvBHqTz6plYA1y80Uo0hto3+VITfeoid/epVoH
	+VBLJShkad7UzHtXxr81MYFSQ1x//81DnFqDQpqdCqZRR+Hm/oC6lV3+eDuaB97UXyi31PIm5Yk
	c9hjNjoQoVtcXolqUF+eJ+QECNFHJlZthBBaPFK9iWfXayJkAq92rjw97FfxcQzyDFAgxkfyeq3
	GPZWUNl/H/L76jPNLZN7+ETtREgahu8ZOX1hDu0EHohkk91Xa0OXn08vbTCLvXJL85jJ1/tFB7u
	H/kZI1bS7Xn34R/9Zz+GihusIC8IXVm3Q5aPS5lyFQxn4HRK6d6Fvw==
X-Received: by 2002:a17:90b:3810:b0:3ac:b08a:ed2c with SMTP id 98e67ed59e1d1-3ae5822fb8amr3357641a91.40.1793243121828;
        Wed, 28 Oct 2026 20:05:21 -0700 (PDT)
Received: from localhost.localdomain ([101.44.96.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e9583c1sm1932931a91.10.2026.10.28.20.05.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 20:05:21 -0700 (PDT)
Sender: Yilei Zheng <trilithzheng@gmail.com>
From: Yilei Zheng <trilith.zheng@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
Date: Thu, 29 Oct 2026 11:05:11 +0800
Message-Id: <20261029030511.12004-1-trilith.zheng@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <4c9741cf-ac62-41d4-9c7a-7d5ceea4a8e1@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com> <20260903122128.12264-4-songmuchun@bytedance.com> <20261027065723.66564-1-trilith.zheng@gmail.com> <4c9741cf-ac62-41d4-9c7a-7d5ceea4a8e1@linux.dev>
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

Hi Muchun,

> Thank you very much for the test, so in your scenario, this is also
> the behavior of your real workload (mainly read/write-based, rather
> than mmap), right?

Yes. We mount read-only rootfs images over virtio-pmem and FS-DAX. Most
file access goes through normal read/write. mmap is only used for
loading binaries and shared libraries at startup, which is a small part
of the image.

> To be fair, it does fix the issue, but it's not very clean. I might
> do some code cleanup first to solve this more gracefully. I want to
> move the initialization to where the template page is allocated,
> similar to what section-based vmemmap optimization does.

Makes sense. Initializing it at allocation time is cleaner.

> Thanks for the analysis and suggestions. However, the reason I
> haven't sent out v2 yet is that I've been trying to refactor the
> vmemmap optimization logic to make FS_DAX support cleaner. I think
> I'll probably do some code refactoring first.

Understood. It would also help if the refactor could support subsection
(2 MiB) alignment, so any 2 MiB-aligned device can use the optimization
without padding to a 128 MiB multiple.

> I'cc you next time if you'd like to help me test.

Sounds good. Please Cc me when you post v2 and I'll be glad to test.

Best regards,
Yilei
