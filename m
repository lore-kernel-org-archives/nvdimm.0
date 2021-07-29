Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41D772
	for <nvdimm@lists.linux.dev>; Thu, 29 Jul 2021 07:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627545564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7nDUOIF/JsfT4/fHJaQASN5rYHGU5Rj+oIbOobnebAM=;
	b=Bcv2AGrwnN7zpuaN9hQU47RiXogx7VeGYeiSitXD50McEx5GwTwwc/YNGD2VL30hFMhczz
	fqb7MGv0qAgX23F/NHi7dZIf39TyArHyOVwBFi2u1D5bMWGir9RehUuTrhvEFmTwC96as4
	yQaZep89Gtl8iAZpra6HrJeNMdzuvZg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-SSzOPgU_MNqUFlLy7Ro3jg-1; Thu, 29 Jul 2021 03:59:23 -0400
X-MC-Unique: SSzOPgU_MNqUFlLy7Ro3jg-1
Received: by mail-wm1-f70.google.com with SMTP id f25-20020a1c6a190000b029024fa863f6b0so1948887wmc.1
        for <nvdimm@lists.linux.dev>; Thu, 29 Jul 2021 00:59:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7nDUOIF/JsfT4/fHJaQASN5rYHGU5Rj+oIbOobnebAM=;
        b=pBQ853I6lthYC1PyFNzZVs5v8cUtK+kP0VOFVLYQvf+pmg4a6mNmWVdhuq1Uj90gza
         DjWiIT2ff9wqJ4un4jmCatQVmU9yYK7OURQjooowgeZApCKoQgTs8lsn4/ZL7C+1F22Y
         GPPaHTbLn5DP2AjTKM9iodoLz9KSprDbVRFPi0kwHZl5paZhmwyb/Y7ZZfDNuvUUTrRx
         47obR5yg69IUBjFY+CvnqGqpNE6RNHt3Amn48iYrtjIsvlRonnISJNBx9Ua4BNy7FYHC
         M2/f1R/U/2tasrE5xKjegOEKHLRfKCvH49iozK1xqD6RkgdfoasW29Wjat4VmtDKGqiL
         wzGA==
X-Gm-Message-State: AOAM532yHLYli1jlGdc8m7nwOztqtDFKTkUInw8OQBWSg4kJeOCht46P
	h3pSvAed41Fd/+0KYMdzqbFF1mGIFsnqhqugeqU8kPUkQRpCCdkn17RWRRKWdlG8b7NmGf9Xlhy
	9TYFq3ttQaziVJkHm
X-Received: by 2002:a05:600c:304a:: with SMTP id n10mr10134536wmh.79.1627545561750;
        Thu, 29 Jul 2021 00:59:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwja3dqB2JXnMi7QQvi6Yr4FWdfEmAOTIml73IaKBjzKspoUBQyTcifjGO4KTfwdMepC8ee3g==
X-Received: by 2002:a05:600c:304a:: with SMTP id n10mr10134524wmh.79.1627545561582;
        Thu, 29 Jul 2021 00:59:21 -0700 (PDT)
Received: from ?IPv6:2003:d8:2f0a:7f00:fad7:3bc9:69d:31f? (p200300d82f0a7f00fad73bc9069d031f.dip0.t-ipconnect.de. [2003:d8:2f0a:7f00:fad7:3bc9:69d:31f])
        by smtp.gmail.com with ESMTPSA id d5sm2352326wre.77.2021.07.29.00.59.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 00:59:21 -0700 (PDT)
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
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <f005a360-6669-1da6-5707-00b114831db2@redhat.com>
Date: Thu, 29 Jul 2021 09:59:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <AM6PR08MB437663A6F8ABE7FCBC22B4E0F7EB9@AM6PR08MB4376.eurprd08.prod.outlook.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Hi Justin,

>>>
>>
>> Note that this patch conflicts with:
>>
>> https://lkml.kernel.org/r/20210723125210.29987-7-david@redhat.com
>>
>> But nothing fundamental. Determining a single NID is similar to how I'm
>> handling it for ACPI:
>>
>> https://lkml.kernel.org/r/20210723125210.29987-6-david@redhat.com
>>
> 
> Okay, got it. Thanks for the reminder.
> Seems my patch is not useful after your patch.
> 

I think your patch still makes sense. With

https://lore.kernel.org/linux-acpi/20210723125210.29987-7-david@redhat.com/

We'd have to detect the node id in the first loop instead.

-- 
Thanks,

David / dhildenb

