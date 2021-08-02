Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB2672
	for <nvdimm@lists.linux.dev>; Mon,  2 Aug 2021 15:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627919271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=di+y0xMvdbCrkaN5KumVgKe0pl3QX55ReR309IY2E68=;
	b=cDH6CHqNKrkVQnI1WM+w3+G3pEN1dvFT1TJLUiNZtwGTCrj+Xx9Khb2C+sdUPPI0oO5BdA
	V51UwbbL9LjlRt/E0EN9rYzGK+mgesCAHb3xntEPe/gskyU53gsujHxb9i1l/guJkxKhyh
	UrcdCR+8VZVjJOpoEa2VtSMSWVF30yI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23--qklPxfBN3WF_RDz4mbIAQ-1; Mon, 02 Aug 2021 11:47:49 -0400
X-MC-Unique: -qklPxfBN3WF_RDz4mbIAQ-1
Received: by mail-wm1-f72.google.com with SMTP id o26-20020a05600c511ab0290252d0248251so104123wms.1
        for <nvdimm@lists.linux.dev>; Mon, 02 Aug 2021 08:47:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=di+y0xMvdbCrkaN5KumVgKe0pl3QX55ReR309IY2E68=;
        b=mS8xx9F+i/bys3Bxd3zsvCdlAsQt6wdhOG8Nzp8nq3qtqs+7vOxNcZe6qsAlJSwneM
         uawbtX6adwiF55OhkQ+GUDosxA/SoV1CBmN3TwPMpOuiFhw2pydgQhANEfG33o6ll/Hy
         o02NgTB6PKqQInIXOaYyyxjIEq1BzrNkXVryR/5GY1iQj5Isug4Q+L6fijHxfyZIRGxS
         TnWidHqY6fG61Q/mWR/aCcUfKob6y4PPb2sMQ7TveUfBpV50Wz4NraAaTuMj7yzWS3fi
         9EZVQbTER5eSVx0KqcX6fdJPpMtogJbbr+XoafqgRuRoXZI6iMQENxOjqgv2vvZGT8xf
         TGoQ==
X-Gm-Message-State: AOAM5310KMzn2u6fQ7GawRoK/d8TeA2K0h47DSOuFzzC6IFfLWh2y5yV
	INxXU8OGGEQLb86wJu4ZDrqrqu87uPR0Mq8H4IT0RP1JWk+BcdOfhn7DkdSrsGTEjqQjTTi1Smd
	S5kcUDdOyx/cPORDc
X-Received: by 2002:adf:ffd1:: with SMTP id x17mr18205661wrs.391.1627919268618;
        Mon, 02 Aug 2021 08:47:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEmbb2zH0a3fy8LIe8wfQA4/Y23WkCq1MgwVEgZQua5UBPTWh4ebj7+H7vh1LKNBn5dVAnLA==
X-Received: by 2002:adf:ffd1:: with SMTP id x17mr18205644wrs.391.1627919268477;
        Mon, 02 Aug 2021 08:47:48 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c60af.dip0.t-ipconnect.de. [91.12.96.175])
        by smtp.gmail.com with ESMTPSA id t15sm8872923wrw.48.2021.08.02.08.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 08:47:48 -0700 (PDT)
Subject: Re: [PATCH] device-dax: use fallback nid when numa_node is invalid
To: Justin He <Justin.He@arm.com>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 nd <nd@arm.com>
References: <20210728082226.22161-1-justin.he@arm.com>
 <20210728082226.22161-2-justin.he@arm.com>
 <fc31c6ab-d147-10c0-7678-d820bc8ec96e@redhat.com>
 <AM6PR08MB437663A6F8ABE7FCBC22B4E0F7EB9@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <f005a360-6669-1da6-5707-00b114831db2@redhat.com>
 <AM6PR08MB43766A114DA6AE971697CA1CF7EB9@AM6PR08MB4376.eurprd08.prod.outlook.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <9fec6bd8-1dbe-1a34-3cc0-fab7645f84b4@redhat.com>
Date: Mon, 2 Aug 2021 17:47:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <AM6PR08MB43766A114DA6AE971697CA1CF7EB9@AM6PR08MB4376.eurprd08.prod.outlook.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 29.07.21 16:44, Justin He wrote:
> Hi David
> 
>> -----Original Message-----
>> From: David Hildenbrand <david@redhat.com>
>> Sent: Thursday, July 29, 2021 3:59 PM
>> To: Justin He <Justin.He@arm.com>; Dan Williams <dan.j.williams@intel.com>;
>> Vishal Verma <vishal.l.verma@intel.com>; Dave Jiang <dave.jiang@intel.com>
>> Cc: nvdimm@lists.linux.dev; linux-kernel@vger.kernel.org; nd <nd@arm.com>
>> Subject: Re: [PATCH] device-dax: use fallback nid when numa_node is
>> invalid
>>
>> Hi Justin,
>>
>>>>>
>>>>
>>>> Note that this patch conflicts with:
>>>>
>>>> https://lkml.kernel.org/r/20210723125210.29987-7-david@redhat.com
>>>>
>>>> But nothing fundamental. Determining a single NID is similar to how I'm
>>>> handling it for ACPI:
>>>>
>>>> https://lkml.kernel.org/r/20210723125210.29987-6-david@redhat.com
>>>>
>>>
>>> Okay, got it. Thanks for the reminder.
>>> Seems my patch is not useful after your patch.
>>>
>>
>> I think your patch still makes sense. With
>>
>> https://lore.kernel.org/linux-acpi/20210723125210.29987-7-
>> david@redhat.com/
>>
>> We'd have to detect the node id in the first loop instead.
> 
> Ok, I got your point. I will do that in v2.
> 
> Btw, sorry for commenting there about your patch 06 since I didn't
> subscribe lkml via this mailbox.

Sure, you really should subscribe :)

> > +	for (i = 0; i < dev_dax->nr_range; i++) {
> +		struct range range;
> +
> +		rc = dax_kmem_range(dev_dax, i, &range);
> +		if (rc) {
> +			dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
> +					i, range.start, range.end);
> +			continue;
> +		}
> +		total_len += range_len(&range);
> +	}
> You add an additional loop to get the total_len.
> I wonder is it independent on 2nd loop?
> If yes, why not merge the 2 loops into one?
> Sorry if this question is too simple, I don't know too much
> about the background of your patch.

We need total_len to register the memory group. We need the memory group 
to add memory. Therefore, we need a second loop to calculate total_len 
upfront.


-- 
Thanks,

David / dhildenb

