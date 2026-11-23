Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795421219;
	b=hHrROm7Gtrn6+S4yJtR+6eTvP0VXCZSbae8mIQEG0qkECthlkh39U/owFL5ziTVmG6+A
	 gdYxJfZfi858J7GglHyipcqmykR501O1bbk+N8uCBZmYS566XRYRsHQYN4rY4Njz+V4X1
	 PeMXtYmsaHJ6XsoC88hbC/9L84gCaXcBBC0HRiWK71KfJwDDB7wCO66/nHBSbX8K831Wo
	 8ABfPtrucjLnjuARa507sAcIq6YMIn1gDPhTnds73L56376fnicd1ih+kmV/SHpj1gxaH
	 YZYI3gULEWrUGhILFPr25tTAsoKqsFGvrW5hPYsxFeGTF7450EJnay0UhWcCcOG5esQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795421219;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=GdWbto/GYuZDXyTvm+7T3nEGrjgUlN0uIoNMYNUd3jo=;
	b=UBFPMWrFVPeXpdkx+EjL5vrsvyI7ffrBUv9RiScVS80thCKQ4dOe5qdmhAwgwbDYYCgY
	 mHUou2oBGz0+xI1V5LLw33N6HJ3iU1aTVd9UIn29+WjYhpl+/+L/Aya1DNjSDGkN6U+u9
	 oHNequVj4EOE9pRW9plfmGcLCbVa5/Tgny/m1XKQ2sRFhf7b4Gm//2lICRj3W1spjuaGA
	 ucpVcnRnaEsT+JNqf2ML8DhkuQBhIQcM1ClbA1pEJWCja/ZkLoQTqPT/HRpbabDmLq7WT
	 u8LfqE+r1FYu4iqsEoJ/fuYd6PJ/v8kKXymQ7QG/YAXmoxisvtuVOaxSJTtXOz1eRYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ES8E77xy;
	arc=none smtp.remote-ip=209.85.222.178
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531AC6071513
	for <nvdimm@lists.linux.dev>; Mon, 23 Nov 2026 08:06:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 531AC6071513
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ES8E77xy
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9496473b511so374274285a.0
        for <nvdimm@lists.linux.dev>; Mon, 23 Nov 2026 00:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795421218; x=1796026018; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GdWbto/GYuZDXyTvm+7T3nEGrjgUlN0uIoNMYNUd3jo=;
        b=ES8E77xy5J1mjqu9PTHksdjWWzSIiFOs0ddnHmx5o2/LzXeSps8NRvVkRdhPVLrORs
         u5qVn3FIieSxsm306FgK/RwC8mAdOw1orpXMFh14uCNq9xP/17n82y83nmVw6SGPU7uP
         KaCJ2t95xolF1X9nHa9OmhYt9kzupzCTMTiYU/SxkQQB2uwTAoOdB/lsT8nU6cCTD9KH
         X3LLZCQXEtyUI4TQX1bjss/sd6scWd/PrsKTuniKZMdjWtqaLfmdt9Aj3BMoCgq+nbel
         pCI4cY2G3vb9l8BrvYh+WtZV1C7lHTmV2vHU7kZ/msMBk5VT5MeNIj9aBGZ9fW/1/4Ie
         3XaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795421218; x=1796026018;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GdWbto/GYuZDXyTvm+7T3nEGrjgUlN0uIoNMYNUd3jo=;
        b=0PRNCnmfbLWn/OhD1PiFbu8I2+yXvN2Hm+MuwTJ/VyFMJoeJrYbUJdbrF6cPfTAUDS
         cWSpM1aqRvXM4/njgzMHH+GsUFAsqJjxWDkbf677mqtVicKd+4JcNzXlG1RIL4R/X2Xm
         yHPRxSfJm7YGmlmPs30ThXJXRCPHF75YYysebxs2DzWNcfmqE4DUsa1bNgSdypSAmkLT
         xah7Xv0z/GwgC+GhbLiusu9XlUYYfnUl1TbsDU2p6aTuQY6PCQOzzyVUHcSx2kVowDTE
         E5fJ6n1WJkOg3HfiN+RLllelmT/BNAFwmTT2rvTqOn53MSd8v6lsI2+2I30qYvh0JuRx
         ZjEw==
X-Forwarded-Encrypted: i=1; AL+hErFddrIR2g2EabKzUZZijUg009HGR8HxZ1Nymf1Z5+u7QbLTN9l2RnIIXO8aOyIG+vbdfJMIFLA=@lists.linux.dev
X-Gm-Message-State: APuU4Z/eHS/MIIVr3OPB4+Vf650WP0Q5/szqDCXThxnc1SKE8qBkOKWx
	Klm7giUtv9FZLIkYnwqGczq6ld/oAs4RmqrSLn5U3vKGx6b9XWR3Fw4AIKmcZQCLPsM=
X-Gm-Gg: AZFdTZch45Ge7+QrWNCj2Ghw9uSqaWdrd0+Ge6KiqId3B/aYtkSrgVZ5bStYD0FMg/2
	MS6530Y8aUs/DZenJFglB8pLrzaLOEPrBZaCGxSRMsLqLuLHnc4WkOHh1Y18hdxJs09ICA9AG5n
	uqhV1Wwf7QzJkEdOfkh3BA8wafWmFxrYxB0nCt4HQ1JGe5z4encm8tjsRJ/FUfAVLV2rjAty7P+
	J4Ktc128YAgAXeP2hb82Xlp9rjHt37YzTBCF1qvSRgHQvzeC3F8Dvd/5LkQdzLMzslRzoqeXf7/
	etK7cUNq8UKjPCNAe6ZaoTiCpoBxmw9x0Jff8EM6Yj3lEFRFXHnY4facnteK1Gp5z6NHSO0j25u
	vbuCoElFPxTDCgWm8Kv0Zm1t2unbI9NOE0hgO4zFRmEphukBa9Xu9bhJ7q69FVUgVJxCzZs0CqZ
	gsJr6J1T1906KCQtK4jrAX+9u1OrHysHad7ERbKSTXhxde8siUz33Isxp4UGeIEW4bYEZRPboKH
	695V38j8rWXy55ra/h1L3yipSXyQk+L8SqFur1qI8vuMPaZlRZ3pDRQCXYfVdhOvMy2ac9PLcb6
	5gJrpr0eceiT8ulFZOYpJXYYLFpXdagV6alBNts5b/s6hSTnBBE18kNJhAiU2+8q3N1+yy637Kx
	BNQDodBEYBh+kdDhnjNXcknRGHZmn
X-Received: by 2002:a05:620a:4481:b0:93f:2571:bb6d with SMTP id af79cd13be357-949bab32ff9mr1727268685a.39.1795421218145;
        Mon, 23 Nov 2026 00:06:58 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb349db3sm745619285a.7.2026.11.23.00.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 00:06:57 -0800 (PST)
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
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org
In-Reply-To: <awNavE8dAGr-amfQ@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <awMdeK8O-5mffg2m@yury>
 <179537469194.412063.13456998694958645706.b4-reply@b4>
 <awNavE8dAGr-amfQ@yury>
Date: Mon, 23 Nov 2026 03:06:55 -0500
Message-Id: <179542121527.412063.3452837736734095837.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-11-22 16:12 -0500, Yury Norov wrote:
> On Sun, Nov 22, 2026 at 02:11:31PM -0500, Gregory Price (Meta) wrote:
> > On 2026-11-22 11:51 -0500, Yury Norov wrote:
> > > On Fri, Nov 20, 2026 at 01:08:51PM -0500, Gregory Price via B4 Relay wrote:
> > > > This is v6 of the Private NUMA node series. The series falls into four
> > > > parts, each building on the one before:
> > > > 
> > > >    1-18  mm: introduce N_MEMORY_COMMON
> > > 
> > > I walked through this part, mostly. It looks like you can substantially
> > > decrease the patch count if you keep N_MEMORY meaning unchanged, and
> > > add another type, like N_MEMORY_NOALLOC.
> > > 
> > 
> > I don't see how this would reduce the patch count substatially, you
> > still need to convert existing N_MEMORY users and need to differentiate
> > between general purpose memory nodes and private memory nodes.
> 
> Please check this quick attempt with my codex. The patch count is reduced
> to 52:
> 
> https://github.com/norov/linux/tree/private-nodes-v6-n-memory-folded
> 
... snip ...

Patch count is not what we want to be optimizing for here.

Your branch carries the same code (+3 lines net actually).

The patch reduction comes from squashing the per-subsystem conversions
into one 16-file commit.

It also broke get_mempolicy(MPOL_F_MEMS_ALLOWED) - it now returns
memoryless nodes even if the system doesn't have a private node.

> The more important thing is that N_MEMORY and the proposed N_MEMORY_NOALLOC
> is a disjoint, contrary to N_MEMORY and N_MEMORY_COMMON.

The proposal here is not novel - version 5 was also disjoint:
https://lore.kernel.org/linux-mm/20260720193431.3841992-5-gourry@gourry.net/

   N_MEMORY and N_MEMORY_PRIVATE are mutually exclusive states.

I moved away from that because it changes the definition of N_MEMORY.

The subset model is easy to understand

N_MEMORY               - a node has memory
 -> N_HIGH_MEMORY      - subset of N_MEMORY
 -> N_NORMAL_MEMORY    - subset of N_MEMORY
 -> N_MEMORY_COMMON    - subset of N_MEMORY
 -> N_MEMORY_PRIVATE   - subset of N_MEMORY
                         (COMMON and PRIVATE partition N_MEMORY)
 -> N_MEMORY_<FEATURE> - subset of N_MEMORY
                         all N_MEMORY_COMMON
			 some N_MEMORY_PRIVATE

It's additive. Users pick the set of nodes they want for their purpose
and don't have to cobble sets together or remember special helpers.
Users don't even need to know about private nodes most of the time
(mempolicy being the one major exception here).

In the disjoint model, N_MEMORY no longer means "has memory". Recovering
that set requires new helpers, and the meaning changes silently for
every in-tree and out-of-tree user. Anything that wanted "has memory"
quietly misses private nodes.

Either way you have to audit each N_MEMORY reference and decide whether
it wants that state or a feature variant (N_MEMORY_RECLAIM, COMPACTION).

The difference is how a missed site fails. In the joint model the
zonelist and the common-memory folio checks backstop allocation and
access, so a missed placement site costs some additional work.

In the disjoint model a missed site silently drops a node from stats
and accounting - or worse fails to allocate per-node meta data.

So no, I do not think we should go back to the disjoint model.

> > And N_MEMORY_NOALLOC is not a good name.
> 
> Sure, I'm not attached to any particular name. Although,
> N_MEMORY_COMMON nothing better to me. It answers the question
> 'what for this thing' even worse.
> 

happy to wordsmith the names here.

N_MEMORY_GENERAL? _DEFAULT?  _COMMON felt intuitive but I am happy
to rename it whatever.

-- 
~Gregory

