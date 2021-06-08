Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A7572
	for <nvdimm@lists.linux.dev>; Tue,  8 Jun 2021 11:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623151140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CBLtrFhiRKeFc7Q7qn/8AZzS8tEb5Usg8INInZ6WYCs=;
	b=NCgNublPpUc65Nv9VMJ1ZXh7G8ulTDOg+GeMHxs5AdLA5wdvFcVbC1riX+BPiVNsB1FrsM
	bnC+0xwjq5QRyorxATrmLJeJ+9atPcJONYGUkeK4ty51NCsaD10GHwoNsQYLa0rZLMLaHb
	stXbO8E4RkU/aCKdNnYhnSeQhE4W4a0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-WBXYlp0jOaqJpPAa1IzJIQ-1; Tue, 08 Jun 2021 07:18:59 -0400
X-MC-Unique: WBXYlp0jOaqJpPAa1IzJIQ-1
Received: by mail-wr1-f69.google.com with SMTP id q15-20020adfc50f0000b0290111f48b865cso9287394wrf.4
        for <nvdimm@lists.linux.dev>; Tue, 08 Jun 2021 04:18:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=CBLtrFhiRKeFc7Q7qn/8AZzS8tEb5Usg8INInZ6WYCs=;
        b=LF9AhLible5X5MeF79CZq3NyxPH1EdOYjpMvUO6Pm9Rj+UnrTd2Fo0mzsL0FwDDUOb
         cUVygS3e1EXrhewDlcRXoaqAaoJSUIWTVadblId1NzKg2HK4BK53IHyPTPoacg9pE4dJ
         75MyQvtrVxg/yGykqA9+CoIAPWoDj2TecUjK9g/9w4AE8XLLTBJLQcRZj8GjNA7DqQH2
         uSfDGwywdBHWXkpWr8h01pNIoY5smrQZ+0+fpaGdCrRrtfb4C/MrIk9q84MoLox1bJ6+
         sA1LZ4Ku0CbkgyWMP5yOK9y9z7iEbpM9cNJhLz5FQLsIaDCvEp6ah9m/zkv3vSr4pz+x
         Cq9w==
X-Gm-Message-State: AOAM530cBt+4jJfMgiOA7ycKNrLNcxnqmUzIhEZV+EzoWtOzBy7wRi7Q
	wsp1aAQQ0rwLO1M3er9fxT+bbOs44wMgiATT59qvDILMdAfpdWHQXhdrzxT2P2gAJQUaoQ5EKWJ
	Wa7MdCFAgsm005R4IBcQC0rZq/KuLdw1yIrTex5+jbgVSZ8LZ6ZgMNw3fDpya+yyY
X-Received: by 2002:adf:df86:: with SMTP id z6mr22061248wrl.255.1623151137822;
        Tue, 08 Jun 2021 04:18:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrB9z1bqXKLNgH1xZgLenFDxAm/18wrzcUUIce09tn+BporQC3UeSbXcvGrkz4TceLSHiMMw==
X-Received: by 2002:adf:df86:: with SMTP id z6mr22061199wrl.255.1623151137577;
        Tue, 08 Jun 2021 04:18:57 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c61cf.dip0.t-ipconnect.de. [91.12.97.207])
        by smtp.gmail.com with ESMTPSA id u2sm19236473wrn.38.2021.06.08.04.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 04:18:57 -0700 (PDT)
Subject: Re: [PATCH v1 05/12] mm/memory_hotplug: remove nid parameter from
 remove_memory() and friends
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
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <7463b3ed-07d3-7157-629d-a85a3ff558d6@redhat.com>
Date: Tue, 8 Jun 2021 13:18:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <87y2bkehky.fsf@mpe.ellerman.id.au>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 08.06.21 13:11, Michael Ellerman wrote:
> David Hildenbrand <david@redhat.com> writes:
>> There is only a single user remaining. We can simply try to offline all
>> online nodes - which is fast, because we usually span pages and can skip
>> such nodes right away.
> 
> That makes me slightly nervous, because our big powerpc boxes tend to
> trip on these scaling issues before others.
> 
> But the spanned pages check is just:
> 
> void try_offline_node(int nid)
> {
> 	pg_data_t *pgdat = NODE_DATA(nid);
>          ...
> 	if (pgdat->node_spanned_pages)
> 		return;
> 
> So I guess that's pretty cheap, and it's only O(nodes), which should
> never get that big.

Exactly. And if it does turn out to be a problem, we can walk all memory 
blocks before removing them, collecting the nid(s).

-- 
Thanks,

David / dhildenb

