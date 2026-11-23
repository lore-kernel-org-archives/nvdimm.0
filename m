Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442486;
	b=oSUcccvs8iv24qpeVwYPeTXQw0biGUJ1osy3LZNAvbJAvMuYQ2jjofTMh86opP3uTUfK
	 ci2H6cP8o9gkzC4mafKgwq3Zsrn27pqEGvV+n8qo9ZqnUJOUhNVgdD+N4jwSb95YAhjqV
	 kF10xDWs4zqwdc/BCJQebtYD1Xi43ufdgXxnSoHq7/SwVtcBdm9OlLi588lvMZP06hDUb
	 IzDfdAf/vTHCJRZlsMnUH4po4UrlTpLDJuYfEbPBSFmmq2pm4b6DSMQqbBJoK6IH5G0By
	 AUnL+8NT4fBRKQRns4cB1BKxZ0K5jvEvKj2gc9aKLax+8DzSvNJWD1NvU/ztr0ypj1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442486;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=vG8DGIHiY7DMGeo+eA0u14jrv8r12vq2uH5/qp0e+4w=;
	b=j2fttcGsNTSGz5dFZFioErAreY1Af7qjLDqqSx8ws9cLL7XwhMHZsiAtAN4lhy6UYcbS
	 JEBJ/pCjMvxf7+dmL7nwwSnoDdcd6HuqKD6Q7U4r3xhUbYbXALdIR7vc80/YSSpgF0oYw
	 Q9VkzYZog5LkT/ZkCUYFsW2b2J4E6qsQexStSiYQ42TY1OZjMO81UxtCjxdMD22JJay3S
	 hcTxYZIBuM+PlbxG8C0/xybbk/Pv7ceItKmBsB7x26KVxJn6++GdCe/+H/KFLR0KgH8a/
	 etbOUKMYctgB1kn5JkPn92BcO10dFeCYLPUVmFo19b5T8Uw4hLBHNshz/Bd/GlEC2Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=q8bGqa60;
	arc=none smtp.remote-ip=209.85.160.173
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C38606A334
	for <nvdimm@lists.linux.dev>; Mon, 23 Nov 2026 14:01:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05C38606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=q8bGqa60
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5495d549924so38072291cf.1
        for <nvdimm@lists.linux.dev>; Mon, 23 Nov 2026 06:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795442485; x=1796047285; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vG8DGIHiY7DMGeo+eA0u14jrv8r12vq2uH5/qp0e+4w=;
        b=q8bGqa60ntCrElCV5H+yJq6B03U7STKlFxrqE0EGnfgaHxfULq4p+WeDBY9wBqL7Vw
         JQOzbIyvs+iby1BRj/RhQnM2pg0ZoRUNKomO+UzmOAfYudOzLYNOebuDrWahy2txalcW
         RsDdrr355wKIm9lC3fbnZt71fo1nT+WBkYOnN3y8TYTD8At/QMt3TFQC7BmvDD4B2m51
         ZDcTxw4+qPnBb/UQgx9i9rFJOTvClGIiyuGhuQsvCTbu/LfolHgmcwMu5lpnfa+h1gaZ
         AdePO2lZM/bQVfhwGRhCCkiGU+Kwwhxzs6gwQ75KT6WOt/3bbn17VyrOQyYOOBtghONh
         yIPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795442485; x=1796047285;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vG8DGIHiY7DMGeo+eA0u14jrv8r12vq2uH5/qp0e+4w=;
        b=pWuMUlbptDB8i0UXakhPHeV8cYh068jRNqlu0/x0rjrWK3KpVi5/gDTYh/lQFIY2AW
         3zw72brVEaZr2Kx6iI/5a08Vnv/VSvg8luZq0bVSlwygmZzuoqQHpz0+pR+Qgv51eU7o
         u+H059HYaKnAKuGc7dEOdJCTYyF0phFIAJpdStfAVh/S/le+po4oQjsD3LoRp1IhVwaZ
         Sv1fiCjRsbOYc251JVEXc4KOAweEfmTk5pZL6Nvk7zA7MYn0tio0l0SawymdvMhiTqAa
         GJftNTT1GCVUXWL0nGwEuv00M7MygNKjvSnRyZ0/qvP3FjPUCxdx4nCe7h3GOMI/ZKmx
         qX8Q==
X-Forwarded-Encrypted: i=1; AL+hErEyBaJL0j1mvigu69OAov7oqRaidwP14qGqISYlbPx3lFSlS3tWqso6hq0LIzpmRkagQQEA9to=@lists.linux.dev
X-Gm-Message-State: APuU4Z8ng22Yism/+pVR3Y5+tTwfgKzEVMMOjzC+gEDG6xp3LM9onNFv
	Co/tx84WMBvPjs2Dy8Rf1Ut9D2cQiAW8HEPEk87BNSmJgWDfBUGjRPPqmEsRZ60Z91k=
X-Gm-Gg: AZFdTZenxW1/zoKCaIJRSKDiDnI/GN+M7RiMMVQB76wC8TSwEwQ+wDr/84L0Qf3BdT0
	51+uekYLwJuts3YOBARA92DegwKKnq31Qpby99/4yOn7EvvE4pZjAX5i0BWK0XExYsVaqEhOAfw
	QuzEa2dgyV+QOV84fmuf+UlnGWM4Hp3ZhzpcN+62zL9og2oAwXXKqSH9Yux+2GW0isSP8LqfG5J
	5huWoYo6bvzt8JbOG3Rl4AuDdxeoW5E4AnZ1kHiiTo1JCLo7lD1sd7oUSFOR16P20KF9WK+pRPc
	1sAw+SxgWq5WWPlIN/SGanD6XAAuDcBkw2Z1Mx7GdarQ1ZFwoC2iErvuycPuYXdNklL8INRZorB
	TzVrybZACUtP3DVrkVGy7b17ia4S05Upu/iV52uKDoZcz9m6DTodoJKN1F175/73hPJZxHeFnVJ
	rvzqIvt+3vt0yPgoXeOXgzFSc3JbUatk4Ifrlzy/jy7oh1/Kclk9kO1nLIBV1r2aL98S3JnPT1b
	4Gm0jSn3RLYSZ64T+ISYAUSr0/2rDJYLHMp5gIDT1w9Qha8XPAVdedXmH5+EENf3JPKTGi8QH31
	KO48Ry9C37uY4VLj8hyZQwTWZiIM/CxY/4wzIo2ZDMQgLqPQGW97ZNzL291XQHWDU7W8EfrwBJQ
	mifD515c=
X-Received: by 2002:a05:622a:8413:10b0:55d:8475:aafb with SMTP id d75a77b69052e-55d8475ad43mr113506371cf.71.1795442484804;
        Mon, 23 Nov 2026 06:01:24 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788074desm99999281cf.7.2026.11.23.06.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:01:24 -0800 (PST)
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
Subject: Re: [PATCH 01/60] nodemask: add node-state iterators
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
In-Reply-To: <awMK9V6TbU9Xtzn9@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-1-74f5f9a115c2@gourry.net>
 <awMK9V6TbU9Xtzn9@yury>
Date: Mon, 23 Nov 2026 09:01:22 -0500
Message-Id: <179544248227.412063.16491857533875192357.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-11-22 10:32 -0500, Yury Norov wrote:
> On Fri, Nov 20, 2026 at 01:08:52PM -0500, Gregory Price via B4 Relay wrote:
> > From: "Gregory Price (Meta)" <gourry@gourry.net>
> > 
> > Add first_node_state() and next_node_state(), so callers can walk any
> > node state the way first_memory_node and next_memory_node walk N_MEMORY.
> > 
> > Add for_each_node_mask_state(), which iterates a nodemask intersected
> > with a node state using the bitmap intersection helpers, without a
> > temporary nodemask.
> > 
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > ---
> >  include/linux/nodemask.h | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> > index 607373bd83ee..90bdcffa42ea 100644
> > --- a/include/linux/nodemask.h
> > +++ b/include/linux/nodemask.h
> > @@ -411,6 +411,11 @@ enum node_states {
> >  
> >  extern nodemask_t node_states[NR_NODE_STATES];
> >  
> > +/* Iterate the nodes in a mask that also belong to the specified state. */
> > +#define for_each_node_mask_state(node, mask, state)			\
> 
> for_each_node_state_and? We've got for_each_node(), and we've got
> for_each_node_state(), so let's figure out consistent naming.
> 
> Did you check the codebase for exsisting candidates for this helper?
> 

for_each_node_mask_and() would be more consistent, change just requires
passing node_state[N_MEMORY_X] instead of just the node state bit.

> > +	for_each_and_bit(node, nodes_addr(mask),			\
> > +			 nodes_addr(node_states[state]), MAX_NUMNODES)
> > +
> 
> Please use nr_node_ids instead of MAX_NUMNODES.
> 

I followed for_each_node_mask() which uses MAX_NUMANODES but let me
look.

> >  #if MAX_NUMNODES > 1
> >  static __always_inline int node_state(int node, enum node_states state)
> >  {
> > @@ -435,6 +440,12 @@ static __always_inline int num_node_state(enum node_states state)
> >  #define for_each_node_state(__node, __state) \
> >  	for_each_node_mask((__node), node_states[__state])
> >  
> > +#define first_node_state(state)	first_node(node_states[state])
> > +static __always_inline unsigned int next_node_state(int nid, enum node_states state)
> > +{
> > +	return next_node(nid, node_states[state]);
> > +}
> 
> At least the following {first,next}_{online,memory}_node must be
> switched to the new helpers. Can you check through the rest of the
> kernel to make sure all candidates of the proposed helpers are
> converted?
> 

I originally intended to delete first/next_memory_node, to make
usage of N_MEMORY a bit more obviously, but dropped it to save an
extra patch or two.  I will probably add that back in.

But yeah i can update these otherwise.

-- 
~Gregory

