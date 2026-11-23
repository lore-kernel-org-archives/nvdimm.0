Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442547;
	b=J3DhaoCd9+fnfaHnqz+53LROHiz7DjyHVMqgS1N6l+RRAiQtU+l8BtqxDQN7/E9KKZes
	 1ADhmaExhHt4IN4SmB+C1KYvJvNjuHKBkrc/+Vr8+KHeNC4gfYdDPUL4ETbMvwcvNsOdI
	 UuFBmEVgGHCJL6CmOFXpbfyvNMd44SK68Y7R5if6SZ0oJ/Hg0/n0N0yVnHEx/PgfXAW80
	 YlMzLsuPBBQOT1qCML87s1stSsLlmkRTvHp81cnqr/oOJ+RadlGVTAQcx81MtRc/43s7m
	 keT4CFbufzqEmPIgMFOX8A+Qrl6AQCK8mQddrLGVpiD0px3MMsu1rid9Qotxcgj1oVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442547;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=K3PKiWxJL5rA78k4RAfL19Ict6G9pZhcXRFYMUNqZcE=;
	b=ntqGegJ052O7bAB7m9PreenL95H7+utemMj4I6Pglp3fJVA3BJp+zT9wwxhPcy8BmdGr
	 AY8nhIz/dyBTFXbPlxTq1ZmLWAYGP+FfZ6O6pFmZ6uF09qNssup45U7ElRS0dxMUBOOyx
	 ttRldTXli4UNI19eKbpIKMhRV+FgrLvl8rmPiyJzD2Qc2aW2D0NfMKn1qSS0hQqhVFaOn
	 dnua7tTsDbsafjfttzavDaQuQvpe4GSy5ZJbt2qemRbcQQNQOPAnG/wAC0dyslPtMF75G
	 V3JRJXhL/dQ/8EuZA/j5BURSjHCeZat6GTXGaiajjFCtmpa/hNQirLLOjJZsiI/nAaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b="LTaa/hni";
	arc=none smtp.remote-ip=74.125.224.45
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF14606A33D
	for <nvdimm@lists.linux.dev>; Mon, 23 Nov 2026 14:02:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BF14606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=LTaa/hni
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-679a2b5fe87so3110081d50.3
        for <nvdimm@lists.linux.dev>; Mon, 23 Nov 2026 06:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795442545; x=1796047345; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=K3PKiWxJL5rA78k4RAfL19Ict6G9pZhcXRFYMUNqZcE=;
        b=LTaa/hnicT888v9SHEA5tGVCKN/z1DRTPjA4PbYn57zK1mAzsI2Gp/XK9LEY2cQx6k
         A8x1nF3+Eph9f8AGeyK30xpdqpr9SNV6LmmMYuCVOff78QtrhGrhZU5VxFt2RjLjzxiq
         5VU9Iha6qt+/0sBtVNExIvm837Yaf6G+aaKsVWv81KNHvTLp73W7WUie58esc4AOQ6tt
         twHyATo9XXBvOO72zI3cIMMRPes2jiIetO9o108JWTZE+LLTMU0gUgWgEgfJo6IVK1H8
         RnMPgRZZh5riqVbkR/nss2W2/CMGKLROw6mtVCmrpNsLrFK7TZJv5RAPvlpL1xhdhywb
         OgBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795442545; x=1796047345;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K3PKiWxJL5rA78k4RAfL19Ict6G9pZhcXRFYMUNqZcE=;
        b=W0hEIdbQX/Jmg+XXhpcI5aVEMK/BR/B0Q7n1bF1Hsc3ANZE0GuxaYyA5/Op3SlFhWr
         4PEBw4/f3rnFWV0zzD8vhAs6MsGBfKOUKu3XjbddWES2dA7XhsS8aahr6YGRQlD0zhDZ
         q1bM+GkBoLXUQRIjpRA5yT5WZ1rGmwA6u6RT0hsMfAejKbpa30/BaIqn754WR0IYe+US
         uF4B0WWIJCJnLADsRfuA+nz1ClNWXPhxCygB7FxIxKkfi0oOH3VZBLp01/x8G8vnN98q
         UYhsJ18QTxISzR1TWjXgJqIsN0sLfnW6t2sd/Utv7WEXwJrf8UrM2erPxF/32MfyKJ10
         BP3Q==
X-Forwarded-Encrypted: i=1; AL+hErFgGHKeq7WuMNuK5H3iSj8t1X/Opyzjk/DKmqWO0Z5M/U4uqxHVVMhilG2qmU2sXrrsb52I0eA=@lists.linux.dev
X-Gm-Message-State: APuU4Z/t+J66Rzm4xoYuYeHxuZ6Z6XvmbtsveIgniP2DvtadOrEY7wKv
	0Jll1W4c6kUKEe5Ely+btnVWP/6WDF9GgnxcK6BFAiZ3WBc5tWwiUTwFVD2MSCOlAv8=
X-Gm-Gg: AZFdTZfRuVjC1K/ilzWHwu0amGgtHhS4fqCNWdOhceHFMVn+a0tg47aeA4oQcpljMGU
	vjlDIC4qDyXXu0A7gYiftoAP1fdMsRCWJ6tKgE6LOJjm3+Ym64uC7IY+G7OVlL5tUC5oJiupiz2
	OMEw0G5LsWywxQcHneY07yiDXaEfXpOAO01Im1RVvpDH6G6+EP+y1+KAIcNBStM5s9X+nrCzUmf
	DV9ifjd2QOItWQdlphnO63k5wSWsv7xNfjRytZ8aqW6fDGMm2gih7DyXfJ0ELSWIb/XCQsFOT3A
	mKoQHt/gHYRyKpNsRqEh1FVlca8Ztbh7UDWbC2zovrMYGEtrh8BGspvrEM/IBOLC/Ne7aYfrJwy
	HmnA8QEJCH8rJ5wYbT/achdzReBLOwAbjyVr1Bw5Yrw3b/ozZCtWw1vq2r1tEC41q9n8WdL5Dfc
	Nt6wF8Bz3IIvjoIkFNLEQfcpoDi8E2+Gh39tVuzXaXp5lyRunHrDZ5d+fm8uPOOBb4GedjfJZK9
	aQkJB5v7EcfHPmz1HmTlOo7jIcLfbrHNb9KFaZJCxN6vg9aE0NOtLZGUmHMdSpgIaiX7dFwmfIO
	oJhX1YIVj0jF+CBp3QcKgLseXDPu13f6lCn7rizKBwN733gTFTs83cLUlvg5lbxHbVTQq35mTBf
	o9VZUwlk=
X-Received: by 2002:a05:690e:1449:b0:67c:b95:6753 with SMTP id 956f58d0204a3-67df451a476mr4209002d50.146.1795442545280;
        Mon, 23 Nov 2026 06:02:25 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9213515f467sm104854846d6.41.2026.11.23.06.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:02:24 -0800 (PST)
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
Subject: Re: [PATCH 18/60] mm/khugepaged: base the recommended
 min_free_kbytes on common memory
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
In-Reply-To: <awMbTMt2M876rTy9@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-18-74f5f9a115c2@gourry.net>
 <awMbTMt2M876rTy9@yury>
Date: Mon, 23 Nov 2026 09:02:22 -0500
Message-Id: <179544254257.412063.6102711886866280853.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-11-22 11:41 -0500, Yury Norov wrote:
> On Fri, Nov 20, 2026 at 01:09:09PM -0500, Gregory Price via B4 Relay wrote:
> > From: "Gregory Price (Meta)" <gourry@gourry.net>
> > 
> > set_recommended_min_free_kbytes() reserves two pageblocks per populated
> > zone to help THP allocations avoid fragmentation. The reserve serves
> > ordinary allocations, which use only common memory, so count only the
> > zones on N_MEMORY_COMMON nodes.
> > 
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > ---
> >  mm/khugepaged.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 2dc4245814df..a930d99f89da 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -3151,6 +3151,9 @@ void set_recommended_min_free_kbytes(void)
> >  	}
> >  
> >  	for_each_populated_zone(zone) {
> > +		if (!node_state(zone_to_nid(zone), N_MEMORY_COMMON))
> > +			continue;
> 
> This is the 2nd time you add this check. Maybe fold it into the
> for_each()? Assuming, you keep N_MEMORY meaning unchanged, that would
> look like:
> 
>  #define for_each_populated_zone_state(zone, state)            \
>          for (zone = (first_online_pgdat())->node_zones;       \
>               zone;                                            \
>               zone = next_zone(zone))                          \
>                  if (!populated_zone(zone) ||                  \
>                      !node_state(zone_to_nid(zone), state))    \
>                          ; /* do nothing */                    \
>                  else 
>  
>  #define for_each_populated_n_memory_zone(zone)                \
>             for_each_populated_zone_state(zone, N_MEMORY)
> 
> 

thats reasonable, thanks!

-- 
~Gregory

