Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793257937;
	b=1y0qKlWNi4dgY1Nb+aUzOkF2fe0PxaBI9kyo6dD2Z9m2H6+LOuM8osxKDymPouUilses
	 2FHvQGsz1TMHbNbcocswvP07VG9xiEf9Xl/GKpxvObO55TypHL5hjNUKiYTc4X+kQdh8P
	 NAcif2sTD8QBoVVu96MWd+WZu1FbVvXbmpz1IvDLoWrKzGSfBcrlO7oUfLmir5ooPjXva
	 navhkPNufelnj+Ec2GJvyr9KXxFPDEhjLATfRHLC/R0rQcnumrbsvPfLisbyrhFLHnioW
	 idxw77DermMJ+8g2RIWpImnEVpaljXJdFdxl0hfqcaTu4ORDI0UgrqDnT62OqIlORGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793257937;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=q3Nd7r/hqjSFpCyfHdGuJldUGtTV8w8XJqRuLAQWCn8=;
	b=WSlBaC8Qw81A98LL6YS8yKGjsWgju8PmER6XeyN3Mjw3v7aA3ZAsjzvfsF6kf6sPnIcl
	 bTSSVl408dPNevxM+e3rRoLriREb19QofM+Tc7diT83i2yFBF4miFGIQVb2TlT+rQpg1X
	 orrjyUf1uHyHYECdZI+4+vang/s7/15RZmDEx8lsNUzciryI5dNCB2xqy7TSsIiNOiEQh
	 adhWvq4WjDoA7WjNtm7D2PfEY4VKIFiyttfrjzW20oGbzAdUXX0peeq7MyBmjmew3TF3A
	 e/leNa7d+JS7bKrr5m8wN8LVtnGAfZIc/73NxT/2OxHzr59sQoYSdZVZHMJ4Qbk3VxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ILsqyK2o;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91283606A31C
	for <nvdimm@lists.linux.dev>; Thu, 29 Oct 2026 07:12:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91283606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ILsqyK2o
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cd62c570b5dso1115599a12.2
        for <nvdimm@lists.linux.dev>; Thu, 29 Oct 2026 00:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793257937; x=1793862737; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q3Nd7r/hqjSFpCyfHdGuJldUGtTV8w8XJqRuLAQWCn8=;
        b=ILsqyK2om03v+OUGXJ8KQce9SVU983lMYHewRPnPpqq4IdroJcHJoPIkr4608N8aQ2
         y3hE5TqWYkK/Ue77m8TLCe0M2C0Hdj0UjkKbgXIvsMtJxnUiNVnSyfpXPCMPCxv4ceSn
         kpPFzF7xHkzjWQM2WPAmemA2K0Xt6+cwn2CdkaVoKIh6UfyB7Mf3G0I93Rsw7LQ7HHyh
         p+zwYyrtqd2Gzf7Nrq59izYFD4GepoZzHbqIdrM1CyMBFRISwWgmvfP+qPaxKAZfzTUL
         GF4AiqmluOKrYTp6G+oVA4+Vnjv7iBnQYu4qrueK0ia3JZPQ5kLwKX8x//HOLs04fXrz
         ptOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793257937; x=1793862737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q3Nd7r/hqjSFpCyfHdGuJldUGtTV8w8XJqRuLAQWCn8=;
        b=cHXY3GKjftluqzmXhAOBnoHSHTR4A6B8xRTLXD5O/lzKX6kvyYInJFO5HK9ZApzDHI
         0naLNZEjUc+3GW6u5FsbeA+XIKgUiEkiD05UTUJRHbbEkDA1PGzhTE0jUJDyYaRssM4Z
         eB3Wqj/7VR+bP/Fq2Ewx9ad1sNeSzbfCT1y8SMJArfYcM5QwjMgDQ+pfDu9ivvPdiuc7
         vWNrLStIjlmuoK6QwUWMfUcWa8KFZSISbBXNMIkjDDfsYDBLRxreR6OPnYGbKQCxgFs9
         iA0dTh9RYhq2onAEO9DRivusnmXhBSMHjWqBt8qRFpsvlGqNqnTNvpqbJfVbBB7vfL7V
         A9Tg==
X-Forwarded-Encrypted: i=1; AKwUvBwK3XKuawz3XpsV7PmJsxeMH7pDVwdQ5FHFC9VQh2EF+NKYHojwg7lQbKRfAsYF/nglH9SRwOg=@lists.linux.dev
X-Gm-Message-State: AFq9FYKVFwDklU4HR5M84I/Eks3eoEGyZga6kyBElzA7mSkgeDu+BMsX
	9/ulWRTCdSRBfmkDhwai1KucV9q6H1P4BDetXeJdIzdwca5xZVR3Wb+Z
X-Gm-Gg: AYBFou2G/Kx9Ib34OVELISa3VAfZypSio91vKzy40hd2Jn4uFyv7cJyTffD+BlAVS5j
	Ntt7gkwhwwS0wRHXGXzRCj+ESPPfK33bkU1qpZ5yQeRxuE0qKqcHCjpzJJ3/vryLaD6QY00KTR+
	WxESgiXjRBdlhItGRUyWb9hFMkEoqluQhziX01dFY65xp7/RYJ2OXbc5BizgWOf/Ww8vSPEMJd7
	ImDvJthtEFCuL1poDzJWRGJbrjIaBI83V4Bs1fBiIn7vvCzp3Bz61Uuqjd/5EDNgcgxgmYlzlfZ
	YQlPTyIa00JQzt3a5QUY1ndl0s6MlUWFDrYO+FaV11PXH3fReclINUTwYwFkAMc0X6xb8Eb327l
	fPFIfvG2fCOQBhuJamTj42LYYgy8w8ZduFy6WLHQtGhU88tiNTRo7JkB0V5h/5GJbnP4aAp/noX
	I7blQlPdLrPH8SPLhRM9Sf5b5DmgGI8fpnEttYYrryR29Ud8VT054/rcB4FTsOzTLw3XAbZZ2TQ
	EUX1g0w3sG73hwncVbaJ+6abM6RgoXyn8qGlgKcMON68Zr3f5+FhrAXCbYxcZLuupASkGraKOGZ
	mIrygMyYec9GI+CdNq4XlT0dr4bY677xEgZG5ds+S8hjKJ+GMZ99Ow==
X-Received: by 2002:a17:90b:3c8c:b0:3a4:ca46:8d44 with SMTP id 98e67ed59e1d1-3ae5819e58emr3799149a91.18.1793257936864;
        Thu, 29 Oct 2026 00:12:16 -0700 (PDT)
Received: from localhost.localdomain ([101.44.96.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6f01e8a5sm1180018a91.0.2026.10.29.00.12.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 00:12:16 -0700 (PDT)
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
Date: Thu, 29 Oct 2026 15:12:06 +0800
Message-Id: <20261029071206.19059-1-trilith.zheng@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <2E5C10CF-F3E0-4694-965C-B0E432A1A962@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com> <20260903122128.12264-4-songmuchun@bytedance.com> <20261027065723.66564-1-trilith.zheng@gmail.com> <4c9741cf-ac62-41d4-9c7a-7d5ceea4a8e1@linux.dev> <20261029030511.12004-1-trilith.zheng@gmail.com> <2E5C10CF-F3E0-4694-965C-B0E432A1A962@linux.dev>
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

I forgot to mention the tool execution case in my last mail. Those
microVMs start, run a small task, and exit. DAX is there to save
memory, but the vmemmap is allocated for the whole image. A 2 GiB
image pays 32 MiB of vmemmap even if a microVM only reads a few MB, so
for those microVMs the DAX setup can use more memory than the same
image on virtio-blk. That is also a case this series fixes for us.
