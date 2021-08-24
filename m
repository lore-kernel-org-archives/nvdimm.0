Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DFC3FC1
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 06:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1629787804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=smEbHzblXx6RDwsdPQ8zTE40MkkErt1zu2jIV9SRWO4=;
	b=HAb9O1PUA2T6YyDC/+398jNRBCA1gmST8klL4o9TEzZd+xqSA07S13kLz/I+XwnFkI5ctE
	xkGFTe0teSJ4Y25GtESV1aGOK6AMOX/Enj924eHHwu/t7GLZEQ6Agh0uXvKpl/M2k+tyc1
	JCOjNX3g/SrpO6zKfeeQfnhAHX8cDME=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-J95Y4PPCOpKU22g7ILb4vQ-1; Tue, 24 Aug 2021 02:50:02 -0400
X-MC-Unique: J95Y4PPCOpKU22g7ILb4vQ-1
Received: by mail-wm1-f69.google.com with SMTP id r11-20020a05600c35cb00b002e706077614so764999wmq.5
        for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 23:50:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=smEbHzblXx6RDwsdPQ8zTE40MkkErt1zu2jIV9SRWO4=;
        b=QSLFZJZdfn1nf1oiuhj7cK9rEmgpJD4dojZeeWGfNFVxI822npiY0c9ef90H/ckbxu
         vRcqSAaBOiqQ4Xciuhhz4ohiN8oNxHcfbQA8LV/hhBzb9c//zEY7HFbskDVk4nBVildJ
         QRKz+1URZ3++oWUkMBBTjqe5ZTLV6wkHouQ1oUv/wYiqEkGibqDByWqtloUcJP6hxTdt
         QSrE8dEMxCSF2wUnUPzP88KoNFXo+g6rIbvlSf9vpHwVSqrgdVvP+vvaZfLADMPm3hNk
         U6tGHbXW2h0nEMQOSurwndmOjOh6ljikBgUqvsAz8zAQCRCQbr2oSUybEniEg0selna3
         s64w==
X-Gm-Message-State: AOAM530KBQB4gceMNVrcD5oIbtdNCqCel/7E++7+fzbM6Ef7WvjxSndE
	dJudZqvI3ox97nYCqlo/GlMNO6/RN2zkp37O5vlNwQTo51+kMxpmOWbG3bEJpndTtLuazTjwDnF
	3xg+E9jlZNEmsUgSQ
X-Received: by 2002:a05:600c:19ce:: with SMTP id u14mr2576204wmq.12.1629787801466;
        Mon, 23 Aug 2021 23:50:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzL1/974TaRC4DVC7n3KRvEvlLa6nIPMFoGRrCmDENm2VXp4QK8Bf5jNXbnI/AdFA1V0Enzg==
X-Received: by 2002:a05:600c:19ce:: with SMTP id u14mr2576181wmq.12.1629787801219;
        Mon, 23 Aug 2021 23:50:01 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23c4d.dip0.t-ipconnect.de. [79.242.60.77])
        by smtp.gmail.com with ESMTPSA id g138sm611737wmg.34.2021.08.23.23.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 23:50:00 -0700 (PDT)
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Christoph Hellwig <hch@lst.de>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev,
 linux-s390@vger.kernel.org
References: <20210820054340.GA28560@lst.de> <20210823160546.0bf243bf@thinkpad>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <c186f1f4-0217-35b4-ba4a-6c20aece3d8f@redhat.com>
Date: Tue, 24 Aug 2021 08:49:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210823160546.0bf243bf@thinkpad>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 23.08.21 16:05, Gerald Schaefer wrote:
> On Fri, 20 Aug 2021 07:43:40 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
>> Hi all,
>>
>> looking at the recent ZONE_DEVICE related changes we still have a
>> horrible maze of different code paths.  I already suggested to
>> depend on ARCH_HAS_PTE_SPECIAL for ZONE_DEVICE there, which all modern
>> architectures have anyway.  But the other odd special case is
>> CONFIG_FS_DAX_LIMITED which is just used for the xpram driver.  Does
>> this driver still see use?  If so can we make it behave like the
>> other DAX drivers and require a pgmap?  I think the biggest missing
>> part would be to implement ARCH_HAS_PTE_DEVMAP for s390.
> 
> Puh, yes, that seems to be needed in order to enable ZONE_DEVICE, and
> then we could use devm_memremap_pages(), at least that was my plan
> some time ago. However, either the ARCH_HAS_PTE_DEVMAP dependency
> is new, or I overlooked it before, but we do not have any free bits
> in the pte left, so this is not going to work.
> 
> Would it strictly be necessary to implement ZONE_DEVICE, or would
> it be enough if we would use e.g. add_memory() instead of just
> adding the DCSS memory directly to the kernel mapping via
> vmem_add_mapping()? That way we might at least get the struct pages,
> but somehow it doesn't feel completely right.
> 

add_memory() is for adding system RAM. I don't think that's what you 
want in the case of DCSS. Supporting ZONE_DEVICE cleanly would be ideal.

-- 
Thanks,

David / dhildenb

