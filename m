Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795200119;
	b=foL7rQRIaLp+SvHoJ7ZMH1rjZ5ng64d5iFfeqjPuYRMhGeOW3Lpo5xhncWFVmvOOu6ZR
	 lui0rhPzVnxlVZW6JuX1xsDyNZcwQOrKlAcsfD43y+582QGUgOfiTFHWUK42fwkBTgZOT
	 Lh6E/ACZlcL95ESs3+5HlEqziIvxx2qr1uoIE3ZluC3U80gYDaddQKw82oD4uWRCH25ri
	 xpSE7fxEI9kosTMR/WjAPvXVIlqpVGDtzlL9AYknHVK7TvtE6pYMlpON0w/amIBVug0vY
	 FjDu3u/btkbbrv3WwDOa3i3B4X9MUTuqrGAkbvSLbDBouXudEnNK2vEDctTkhatjPBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200119;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=ZZVKFrUy8TyPqGvyWghVYdubKdFhARMdxJahZ4dEGHE=;
	b=OBXLmNvOrJpaZvZ/GmREw/14AYare0HiG8Jyt2nKh2hRbOdFShzr6vb7WLMlBB4GOV70
	 bWypmzHLa4jbgOFV+AEksSiJ0XwWn55ML7LQZCC/aGMLAhRh4Qm8Ykb5wgtt9Sh02JxpD
	 64MeobjlqgiUWYGH3YlthQgLdj3qo1WAFQXvzXrckAjUhXgpbUgzkm+Xo5zsKv9tTuFEr
	 7V46h3HbXelfxk14rf6XjpcCHeOIdvM+Qf53O88M3HMg5UbXz4oSzFDGNcE0tLOYkOsRG
	 PtIOLNBaiIL6ZRNPEP6+QI4RAGwOcoL9lB/0rJv8uvqgpWVA09ygdKhXcN3AdwXJkgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=S85FuChe;
	arc=none smtp.remote-ip=209.85.219.54
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC86606A334
	for <nvdimm@lists.linux.dev>; Fri, 20 Nov 2026 18:41:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AC86606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=S85FuChe
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-921365696d9so8657016d6.1
        for <nvdimm@lists.linux.dev>; Fri, 20 Nov 2026 10:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795200117; x=1795804917; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZZVKFrUy8TyPqGvyWghVYdubKdFhARMdxJahZ4dEGHE=;
        b=S85FuChedWCSpx/4vvUIgmAvfPfZ9YCrPEfHA3jgJRHFW4tsKpklFtQZ/3k5lBLcD3
         Rwnod4+lZMuNQHGt49eKI6RZpRK2Abk6LQIJ1hOZqk8ZUj4ZBhX0ZwmIs/ZNd5dti70H
         tWf/qYyIgzHJ7zhlZYlRz8Xz3JlERKfjNIiKJhPKG8yTWNxP3U4ZTam+KbqbBJdisQc3
         RE3m/dizk/8uE4dXCfwJyouEVAHbrQIUII/OHTg8xKZUANYLGTdQFR8CQ39umhedHILK
         JwnmI65vRuX2MWZi//NR5w6s7ice7kSDh5dA9GfZxFIaGxtpMKu3MOVt+lLQBggHJMGG
         Oesw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795200117; x=1795804917;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZZVKFrUy8TyPqGvyWghVYdubKdFhARMdxJahZ4dEGHE=;
        b=jKpzuYfIltpBwJCeDxG+xMJz5ue7uyK0X+xsROhCT3Lwc4kx1Cmogry3DQbaidSXwt
         xuFqZYFBk/MbJQjwggm1hGAIBvTfhbT3Zw+vrgpPXS07is4Qq2GzmwiBiYaMRKR0QMxL
         p0vTceI4ma5FV4TN9FwFU9+hp7bBVoCMfSsvj7Bu1+WWojRpfkz/C0qj1zKLwXCCxcuo
         nFS0VqoTku4cmH62BpgbcA0ub5GwLbupsUXbaDOktCoxKqV3X6B7Bs1JDqW+jBYJc5tB
         uUB9jcYUCr6ZHjCBEiAx/ThPkBATJOCwH3hYISBxy6z2CfJz8iF8KwHvI69WxtvG2R2Z
         nZtw==
X-Forwarded-Encrypted: i=1; AL+hErFiI2mBcGKDnPYL4Lh/UXdQQXNOntR+Eg2xlIpRiIIVcycJZ8PIY65BokK6ok0yXaD+8GVsY7w=@lists.linux.dev
X-Gm-Message-State: APuU4Z8IUZtPbzuZC6LfEaPW+HluyRmvRKe5xp+8NeWrN1PjLeve+5ry
	NdkKMcLEiDBuk2oTC7JY8JSkVb2CTYGvhVDkarZGdoFvdT5XhFMSh+lWxiSboAtxehU=
X-Gm-Gg: AZFdTZc185UVrpGwkohZUxe0PxbmotbRZcPdyyrW5V9LD90nVV6UbnjwPs1X60dxHiY
	nbPLeTj/QhAS5b/IF2zrDktugzQ2K5OIKpxH+qS9j61dgd8mO6TY5dtvFUPP4wziGPlH3m8J8Ph
	HqsqhH8ZLqMbct6avakGweS2DE0d79oAnsm3lU7ZXEMh8WdYOl3Uqc4NCPfYfiQUarkLjxXDoUs
	sHJUmCLRo48fRrVpRPXKef9mAEX1y/Iay+inm3HwPnGwxFpugDUp25jF7FuQjPk1HQcacj3Kl+Z
	bVKEARMXnmpHiv9jdaI8mPO+Y6ufOziPfubK8V/5YI6wrnlKij4nxna/DEhcHgrsaO1kpho8YSb
	6qPXkKL0GxdCJbLN8DRNmdX1Lps545ZlzvzvkRrrPljk0L7/+KtdkNbSI5ObetvRRGVsCMSFotT
	QV/xgALKAfPXY/bj6ECdcja80SymfUvPtzAaLfQxy8Smfchym80EqH7X4r7BDPfqgcbEbwsNzfy
	mV6z2OXl7kD95BiLEKljslzWmyaVGUefZGEXkV+0cMqvIxvuRWnWWhHKC6WFSTNLqWs9zUbjx+Y
	Lpb3W8mRDF31+3oJqVyBnS36ZvhaxmNhcJu5e6LhyCpBLtsHLwpkDLi6277OCxtiaFLfu4qoD96
	ORMg/qDERCN8XA9KMjNlm7kotBy2K
X-Received: by 2002:a05:6214:8207:20b0:921:33f6:8a51 with SMTP id 6a1803df08f44-92134b3e14cmr55307796d6.49.1795200116964;
        Fri, 20 Nov 2026 10:41:56 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349d14d1sm33275916d6.18.2026.11.20.10.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 10:41:56 -0800 (PST)
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
Subject: Re: [PATCH 47/60] mm/vmscan: restrict reclaim to N_MEMORY_RECLAIM
 instead of N_MEMORY_COMMON
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: sashiko-reviews@lists.linux.dev
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, 
 Yury Norov <yury.norov@gmail.com>, 
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
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, damon@lists.linux.dev, nvdimm@lists.linux.dev
In-Reply-To: <sashiko-outbox-225854@kernel.org>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-47-74f5f9a115c2@gourry.net>
 <sashiko-outbox-225854@kernel.org>
Date: Fri, 20 Nov 2026 13:41:54 -0500
Message-Id: <179520011480.412063.14337787866519317378.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-11-20 18:38 +0000, sashiko-bot@kernel.org wrote:
> > @@ -7907,7 +7907,7 @@ static int __init kswapd_init(void)
> >  {
> >  	int nid;
> >  
> > -	for_each_node_state(nid, N_MEMORY_COMMON)
> > +	for_each_node_state(nid, N_MEMORY_RECLAIM)
> >   		kswapd_run(nid);
> >  	register_sysctl_init("vm", vmscan_sysctl_table);
> >  	return 0;
> 
> [Severity: High]
> Can starting kswapd on a private N_MEMORY_RECLAIM node trigger a global
> OOM kill when MGLRU min_ttl_ms is set?
> 
> When kswapd runs balance_pgdat() -> kswapd_age_node() ->
> lru_gen_age_node() and every generation on the private node is younger
> than lru_gen_min_ttl (or all lruvecs on the node are too small or below
> memory.min), lru_gen_age_node() invokes out_of_memory() with an
> unconstrained oom_control:
> 
> mm/vmscan.c:lru_gen_age_node() {
> 	...
> 	if (!reclaimable && mutex_trylock(&oom_lock)) {
> 		struct oom_control oc = {
> 			.gfp_mask = sc->gfp_mask,
> 		};
> 
> 		out_of_memory(&oc);
> 
> 		mutex_unlock(&oom_lock);
> 	}
> }
> 
> Because oc.zonelist and oc.nodemask are NULL, out_of_memory() selects the
> highest-scoring process across the entire system, even if that process
> only uses common memory and holds no pages on the private node.  Should
> the out_of_memory() block in lru_gen_age_node() be restricted to
> N_MEMORY_COMMON nodes?
>

I haven't been able to generate this condition, but I can adjust the oom
control here accordingly.  This should be trivial to adjust.

-- 
~Gregory

