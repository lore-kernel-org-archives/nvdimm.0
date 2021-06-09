Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDF72F80
	for <nvdimm@lists.linux.dev>; Wed,  9 Jun 2021 10:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623233108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RHwERDV3Ik2w6kA7FU7L2RqGuM08Lzd2/FD6Wyr2HFk=;
	b=RbEn/usyvqgwN3pAjR+qEc5ZRSu0UwnCuhQ8GyqLc3Q4Rzxqog7lCcPhKAlcYrB71vK+Oy
	2MDtuGr8julShqgXZ+JvQQGAh9rORfsiPpNxOa27TGM+GNM478B8XOVqqKY8kh2iCjTzGm
	DJxaNCp35vReM5gGlQeI2deV++1q55Q=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-crXiGRZmOeSqZFVpSHX5jw-1; Wed, 09 Jun 2021 06:05:05 -0400
X-MC-Unique: crXiGRZmOeSqZFVpSHX5jw-1
Received: by mail-wr1-f72.google.com with SMTP id z13-20020adfec8d0000b0290114cc6b21c4so10486600wrn.22
        for <nvdimm@lists.linux.dev>; Wed, 09 Jun 2021 03:05:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RHwERDV3Ik2w6kA7FU7L2RqGuM08Lzd2/FD6Wyr2HFk=;
        b=jPJp/D2i9F0QeMPjOizbyUE/273WZm6v6iCHZ6GJ34VvoA7Dnqz4BQdD2A0/09dk84
         0FmkRqouPryajionqhkiMnJ4McbaSGaglupl6OKYQCZew17hN9EiZaul+EL9ZjxtMYIS
         7/Cj5wH/A6Nex0y5mqkYG6VUugcdyBBf3zoo+iE83DtySMykUQWi/ZCwDItk/w2ycgA2
         JT7k6zUBIBL7cdiDChGoc88BZ3WLPrUPPdhQ7kPXpEq+VZXW5NUaKJRK8js51bps+X9g
         fdjtiZS9Px7umWpC7wZH4+L8Z+e1HHVWBA5kMEFxtikjPu4oRZhaa1TpTQFG926dAhQY
         Ym4g==
X-Gm-Message-State: AOAM530zlqqNg1fESy3Qd5/Aty++B9zbdwo5DUvhn7N3tM13wjkIPfKU
	zpZh3vMpJj0tZ8O1L16vgCzsfrgDsDhm5vr/rJy7RBdbwUt/iCDq+Xd80vxj+QHoleqVhO46LlA
	8/EzaX4g8PFdspF5df+uzlqpdz04k/rgG5gX83REGpOmk3zbaUBxN/ne2OmADSP9N
X-Received: by 2002:adf:d4cc:: with SMTP id w12mr26997719wrk.216.1623233103828;
        Wed, 09 Jun 2021 03:05:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxisdlmQ9hbEJc7XyIIogfmbAP40COfOWXq53QTDVV5O2yA236wwdWl7PrbHqWMhmbVzLyEcw==
X-Received: by 2002:adf:d4cc:: with SMTP id w12mr26997662wrk.216.1623233103520;
        Wed, 09 Jun 2021 03:05:03 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
        by smtp.gmail.com with ESMTPSA id l31sm9209629wms.31.2021.06.09.03.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 03:05:03 -0700 (PDT)
Subject: Re: [PATCH v1 05/12] mm/memory_hotplug: remove nid parameter from
 remove_memory() and friends
From: David Hildenbrand <david@redhat.com>
To: Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Marek Kedzierski <mkedzier@redhat.com>, Hui Zhu <teawater@gmail.com>,
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
 Wei Yang <richard.weiyang@linux.alibaba.com>,
 Oscar Salvador <osalvador@suse.de>, Michal Hocko <mhocko@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
 Len Brown <lenb@kernel.org>, Pavel Tatashin <pasha.tatashin@soleen.com>,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 linux-acpi@vger.kernel.org, Benjamin Herrenschmidt
 <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Nathan Lynch <nathanl@linux.ibm.com>, Laurent Dufour
 <ldufour@linux.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 Scott Cheloha <cheloha@linux.ibm.com>, Anton Blanchard <anton@ozlabs.org>,
 linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev
References: <20210607195430.48228-1-david@redhat.com>
 <20210607195430.48228-6-david@redhat.com> <87y2bkehky.fsf@mpe.ellerman.id.au>
 <7463b3ed-07d3-7157-629d-a85a3ff558d6@redhat.com>
Organization: Red Hat
Message-ID: <fe3e8d93-4e69-84c5-3dd3-ab4aca3317ab@redhat.com>
Date: Wed, 9 Jun 2021 12:05:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7463b3ed-07d3-7157-629d-a85a3ff558d6@redhat.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 08.06.21 13:18, David Hildenbrand wrote:
> On 08.06.21 13:11, Michael Ellerman wrote:
>> David Hildenbrand <david@redhat.com> writes:
>>> There is only a single user remaining. We can simply try to offline all
>>> online nodes - which is fast, because we usually span pages and can skip
>>> such nodes right away.
>>
>> That makes me slightly nervous, because our big powerpc boxes tend to
>> trip on these scaling issues before others.
>>
>> But the spanned pages check is just:
>>
>> void try_offline_node(int nid)
>> {
>> 	pg_data_t *pgdat = NODE_DATA(nid);
>>           ...
>> 	if (pgdat->node_spanned_pages)
>> 		return;
>>
>> So I guess that's pretty cheap, and it's only O(nodes), which should
>> never get that big.
> 
> Exactly. And if it does turn out to be a problem, we can walk all memory
> blocks before removing them, collecting the nid(s).
> 

I might just do the following on top:

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 61bff8f3bfb1..bbc26fdac364 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2176,7 +2176,9 @@ int __ref offline_pages(unsigned long start_pfn, unsigned long nr_pages,
  static int check_memblock_offlined_cb(struct memory_block *mem, void *arg)
  {
         int ret = !is_memblock_offlined(mem);
+       int *nid = arg;
  
+       *nid = mem->nid;
         if (unlikely(ret)) {
                 phys_addr_t beginpa, endpa;
  
@@ -2271,10 +2273,10 @@ EXPORT_SYMBOL(try_offline_node);
  
  static int __ref try_remove_memory(u64 start, u64 size)
  {
-       int rc = 0, nid;
         struct vmem_altmap mhp_altmap = {};
         struct vmem_altmap *altmap = NULL;
         unsigned long nr_vmemmap_pages;
+       int rc = 0, nid = NUMA_NO_NODE;
  
         BUG_ON(check_hotplug_memory_range(start, size));
  
@@ -2282,8 +2284,12 @@ static int __ref try_remove_memory(u64 start, u64 size)
          * All memory blocks must be offlined before removing memory.  Check
          * whether all memory blocks in question are offline and return error
          * if this is not the case.
+        *
+        * While at it, determine the nid. Note that if we'd have mixed nodes,
+        * we'd only try to offline the last determined one -- which is good
+        * enough for the cases we care about.
          */
-       rc = walk_memory_blocks(start, size, NULL, check_memblock_offlined_cb);
+       rc = walk_memory_blocks(start, size, &nid, check_memblock_offlined_cb);
         if (rc)
                 return rc;
  
@@ -2332,7 +2338,7 @@ static int __ref try_remove_memory(u64 start, u64 size)
  
         release_mem_region_adjustable(start, size);
  
-       for_each_online_node(nid)
+       if (nid != NUMA_NO_NODE)
                 try_offline_node(nid);
  
         mem_hotplug_done();



-- 
Thanks,

David / dhildenb

