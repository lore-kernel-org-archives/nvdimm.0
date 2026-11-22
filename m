Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795374696;
	b=0ClZrZMTsvc+uSQmEd/xcoddr372lqWE29k8iJRf48lRzDx6AU/JEQu+dB6gVe+gZ8FK
	 Hh0jN7iq4qRXWcDH1GQbt8TavK62hhRl0stAPTDWmrkIjYBz2gCmATVn+xA/ijQV2KUqv
	 XXY9c0O3oFJf2I3vKvN51BGcJKfGI6pGScL38vQuyYlsVUssvypXRl5YCtEfuONALrMK0
	 yCUsx2B4iNmPQKINgG5b8JmsGozyBYP6lCYywxMhCHn58kxGaVItjqwkkJihcAcRQyJG/
	 YJtIAXRhzCQvQC4SG8N640fPpd1q0zIXvqXCNzUxP4/nq/J/UTKN4zGaR5qflb7wkxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795374696;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=oGsMa7wmHQHTRJX2QekmD3Y6Ja6uGmq6iEm7evLlQd4=;
	b=oPfdI8gg78hfLH6jFNj+Lvw7O5PvZ6q7BpZRoG8E13JJtT27nhZA9KnEM8MGlGtivomD
	 mbVx1EtWTFGTfsEaH3dx3xeiY04+oMvGJI5PEnIBSPJ8PRgXkmQ6SZJnq5KbfZm0O7mUZ
	 KtnDI0vk1WjtyHnCb1cMdV6/yKeoydygn4YHAcZvR1K/Je9ke4h4m4BEfF9alYBQ7LvQ+
	 aX1kCQKEMLx6WclkX9u7axIbKKo2SxDzsoDywVSEQYOw3RbQjXYZSa1yoU47NNBFF4nYA
	 2iauCZfFHzlLProB6VWXsQShu2cxGGBD5EXVK+8XPQCsAUEHwOFqpy+qPob4blgQXXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=K8iea7mw;
	arc=none smtp.remote-ip=209.85.222.169
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD87C606A331
	for <nvdimm@lists.linux.dev>; Sun, 22 Nov 2026 19:11:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD87C606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=K8iea7mw
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-94961d90b79so306567985a.3
        for <nvdimm@lists.linux.dev>; Sun, 22 Nov 2026 11:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795374695; x=1795979495; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oGsMa7wmHQHTRJX2QekmD3Y6Ja6uGmq6iEm7evLlQd4=;
        b=K8iea7mwyVESsZ8094DXtxwvucrDg/8tk0BjHr/6M9h3+i84is1KgpFNkEGLNRXh6v
         ccGknAgcT3UL4EMlFLzALeyajVZ+5FI0baGbbdrT/x1BAwUtoKDMp1ItpWhIrYvC1sLU
         e8WPS6B3Z5WXD8nlMiUvQf7aVv6TSJQ+HXXtx51uBxEe7HgpFk6pyAA4tv2MnNYhdNWS
         fltnmRXUVOVeNjqNhRQspuRVD18NXd3zK9nSNwSNSAxqMkfSWiKofFpHnjovpg9nVw5k
         xn4zmim80Qt4xYCCtN28A+ip3Xgo5HV5zMxtjrIZ0t6aPOHt1yxWQ5pabW58YnK/9tqG
         csvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795374695; x=1795979495;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oGsMa7wmHQHTRJX2QekmD3Y6Ja6uGmq6iEm7evLlQd4=;
        b=oYoYxUGJACQt2bXDGUwUbjql2mdxF49duOv0y0Vyw/7tsWt/HJMcK67s2816uQ7gos
         cZg7XiSmU9RvffOcCekvrN0jGOeQIns2luEdhSyB889NftESmiqVyqJUFBhSAZQuxDrd
         57hK3b+T2wz6MGmH5xJ7u5x5XfdoHACGpFkkYV32H+JGqmUfVFPBEhNolrlMn93iAaI5
         2NyBcKV1ab6UrI13SS5QMyCVN0UI4vPPRt6XjZFYsKuX3V2aRhsEZrsVAsaTfbKZwfYR
         i4we/gR8GQ/nC44GxqrPOUe+34E+Z/aXd96UsAYcO5coGy4WE9VRwwDM0QCXy4gRPMde
         YsEw==
X-Forwarded-Encrypted: i=1; AL+hErEbLzFyow8hJtVJ5nVhRsyyx9miFtD6HMXOZAv7eiANBPgE1s0ncOfG4angfaOS5GvNoOhfOlQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z/SEYzqz2hcD2ze5iL/jnAbWaYNAi37BJOns/THkwHswVfgvgEH
	mLyh17O9h+GWawQqc0ADMl/7taGr/gVz26JlDZeEogLW8MqxpimXbmF6NcGoyMUjyxQ=
X-Gm-Gg: AZFdTZeSz5RTLZJEM/icrHA68Dw2TVSincmhZmWGXJj/olBJBlBU55DQ/VoWB0TRACK
	YxmmZJRWDLiBqnnmaECgsK+Hd5236kAvQR5elSeCo11kj2O0mRQPoRRaKdu7nou+LG8sUO1RI2x
	oBXRMD16LjjTBS02aYvMFtHafBDWog59eKZD1nfYuiq+srKf08OGCTiJUlDDmdEPrL4gVwqIcSd
	/B0Bqu1FP9mw2jKPbY2rqWBl0pfsqG6KQFP18BKubK+r/5KnaChCUduyuU3uHCwK2nBqUfgY2ZR
	+QXFcoAWOGjFkK4b6WM/0z1ghuMbs7QKclB1sOISvcfAnkR5L7vg02+ehccykl3T/e0dDBpFLVi
	3gEXpc+9TEyhFcXKABL9ZDdSjodj30Uh+31l1GfCm/Y1TOr0wKGJmf/px3bUKyyEVbvr3XRug3W
	qyP4OP75V3i4HJfmiWLE736OZf+M/2FqkqMQyFdNAxyLfAUglmepHquiqbZGqsZZxG4DaMCnJ97
	3yOQbnM1aiwoiAA9/SNxKxpscnJPEGLx2WWlaW9v0GIOiqe30ZbpUczZcSkaKo6K8CCRy92yQS2
	hsYWQvaL5hA7DKsL2CQb3no/RmFlYbx88VrZveEDCUycx+p8oWV/zjkmRNPSDDDXctV8WTOR4OV
	9rEp1Wfk=
X-Received: by 2002:a05:620a:4727:b0:949:326f:bd2b with SMTP id af79cd13be357-949ba9aa37amr1639379885a.43.1795374694656;
        Sun, 22 Nov 2026 11:11:34 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb38c903sm651828485a.19.2026.11.22.11.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 11:11:34 -0800 (PST)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 00/60] Private NUMA nodes
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yury Norov <ynorov@nvidia.com>
Cc: gourry@gourry.net, Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org
In-Reply-To: <awMdeK8O-5mffg2m@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <awMdeK8O-5mffg2m@yury>
Date: Sun, 22 Nov 2026 14:11:31 -0500
Message-Id: <179537469194.412063.13456998694958645706.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-11-22 11:51 -0500, Yury Norov wrote:
> On Fri, Nov 20, 2026 at 01:08:51PM -0500, Gregory Price via B4 Relay wrote:
> > This is v6 of the Private NUMA node series. The series falls into four
> > parts, each building on the one before:
> > 
> >    1-18  mm: introduce N_MEMORY_COMMON
> 
> I walked through this part, mostly. It looks like you can substantially
> decrease the patch count if you keep N_MEMORY meaning unchanged, and
> add another type, like N_MEMORY_NOALLOC.
> 

I don't see how this would reduce the patch count substatially, you
still need to convert existing N_MEMORY users and need to differentiate
between general purpose memory nodes and private memory nodes.

And N_MEMORY_NOALLOC is not a good name.

-- 
~Gregory

