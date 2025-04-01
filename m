Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D3D1E47B3
	for <nvdimm@lists.linux.dev>; Tue,  1 Apr 2025 14:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743519047; cv=none; b=V26usKkU9DWb/wgWtFXSAEpkDYzEziHfCcf7FBfh6trFbAh5+IT6EJdaolI/GpP5dgm6FkWOsfO4WbD0MYH/xCdgxTDgHDkulZbUjkYbLdRgdcqCAHMIt59JGVgH7cDq5TPXc1VoJrgLLQ9ftanEonVf94oPDDUEBptIQS3Lgl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743519047; c=relaxed/simple;
	bh=b280XaO4lTQNVx0iVzFlnC/pJCCMPW7RC8adpvttMw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P06XyhdUNmZn/CsZ9tK+5Ir85RFjrLs5yIS543rmm7VwWCDD4vnOJXXU8wOnqrna/iAGGf/FK/En+hgi+nXb5sAZZz8U8CbJoi25Oiy8LdtzVAwnigVMpVDEFwYHARlVx2R0dFa0sk7zivr0rPFENg360CILf3Gr4NAeq6ckVS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D/c7tJt5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D/c7tJt5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743519044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YYGyGYzy2HN1yXYZfo8JaW2wVukUhyb7/MxytKSCqU4=;
	b=D/c7tJt5IyCMUk3o921H6RAQeVCE38M2MINpac91ZPbH83eP9TO05GaOIfMKy+uVT/BlAQ
	TbxlcuB0LrXhXeQFmTX6Dkvozyx/nULkNwnTg5ulgszLgk5DSdewCBSMRXIF7C1vTZvOgh
	f+AYvGe0LMrif6zp9E1/nKEdsEq0w6Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-DMJCZ13zPI-nJwmmisxSgg-1; Tue, 01 Apr 2025 10:50:43 -0400
X-MC-Unique: DMJCZ13zPI-nJwmmisxSgg-1
X-Mimecast-MFC-AGG-ID: DMJCZ13zPI-nJwmmisxSgg_1743519043
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3913b2d355fso2181440f8f.1
        for <nvdimm@lists.linux.dev>; Tue, 01 Apr 2025 07:50:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743519042; x=1744123842;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YYGyGYzy2HN1yXYZfo8JaW2wVukUhyb7/MxytKSCqU4=;
        b=qupztGbCtjuSr8l7gSyjlB/601Ie+PlaGXoLHyTJ1JyOZmpc5DfTW3GtAqvjkhXz7Y
         F3Oaukpw9JbKnaAeOe6sFU2u1vIXOGDZ0JDu5uNkdpeWr2JPsCe/Qk2zzhV1sWZ34DjD
         hyvkhUrX7+5SQQ1VoHnYMwmU3n/M0THcytftMKCAFg6bm1+MQoW0KtEAkgdfvABLN92i
         AXIthUDZaX3piIEMIVDTS3Vm42lTZve4cYfmQDVASROV2F6DXU/6qz2OTnPCjALBvMbS
         1vhs2CP81HrKACqis8WAP5QFqXWbI/mIJgcNNIeAhhclE8XAbNNjLxvEZt7yGPOC8dwm
         up/A==
X-Forwarded-Encrypted: i=1; AJvYcCU179bJNPoieCfmzZPFheTP1rR4DY076/PLr67V4V5DBw+XWXl4WR6UVgMDpkhuiIR7osmuiDk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yys10z+33EtoLKEYLKSwfjI8Ix+7QfxyAtEOtmEyOxnMEJAgXmL
	2ZVdd+Z5GyNyaHnDAi0Ki/rZRcE7AJKJyBjtz4ykmMEReYNHofGpJzxQ8qpAzK7kNwVSH7NKWyq
	JWlaKjm8UiRuK1eV4ZgzrQZAXOe8RRlsU1YvB/kArO6fHVGkOArxbpg==
X-Gm-Gg: ASbGncvTUMYGxWJDA6JgoRbgUpERKdGApYrLznADPlARHHtXp9KtJpt81amoNN1xves
	yHI6nvz2we07BUS/8QjhvM0JPfGqq87Qrds0O91OFF/sPjvRYkERs7bOaWytLeQhMSQRq+MniCD
	1nv/APsL0n23cBn3Ix387xeMbPFhvn5yUpDPgZgnRxL8/iMa6coaSym4YhKcnAy3+VB282Tz6F4
	3WFp1OE7t5tS/S9dtsWyt9wfEMEAJ6f94kB7VGnoqnwIgBGseXH6iMLhGAhaUWQt8TWk/0sDYAF
	w0rHPwfR1WPh+FBEzDTbwqD/pmOxrNMU+USF9PhCES2shlI/KyfFUgxzDAjBL39DlwTQ/3B8Y17
	gp5Z5fNy5HtdHhROqG0odmttwlTm9sOcrzLi2DBdJ
X-Received: by 2002:a5d:5984:0:b0:391:4095:49b7 with SMTP id ffacd0b85a97d-39c120e079amr10766404f8f.25.1743519042566;
        Tue, 01 Apr 2025 07:50:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGneUPIDd6lS071kINGiUx+FC/1faN4rQ9jfJJ+sOLSseYV4a77fCWS2WU/wxc0IDVzQHVHHw==
X-Received: by 2002:a5d:5984:0:b0:391:4095:49b7 with SMTP id ffacd0b85a97d-39c120e079amr10766381f8f.25.1743519042219;
        Tue, 01 Apr 2025 07:50:42 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:4d00:6ac5:30d:1611:918f? (p200300cbc7074d006ac5030d1611918f.dip0.t-ipconnect.de. [2003:cb:c707:4d00:6ac5:30d:1611:918f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d82e6ac9bsm199864675e9.12.2025.04.01.07.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 07:50:41 -0700 (PDT)
Message-ID: <4d051167-9419-43fe-ab80-701c3f46b19f@redhat.com>
Date: Tue, 1 Apr 2025 16:50:40 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] DAX: warn when kmem regions are truncated for memory
 block alignment.
To: Gregory Price <gourry@gourry.net>
Cc: dan.j.williams@intel.com, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, linux-cxl@vger.kernel.org
References: <20250321180731.568460-1-gourry@gourry.net>
 <Z-remBNWEej6KX3-@gourry-fedora-PF4VCD3F>
 <3e3115c0-c3a2-4ec2-8aea-ee1b40057dd6@redhat.com>
 <Z-v7mMZcP1JPIuj4@gourry-fedora-PF4VCD3F>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z-v7mMZcP1JPIuj4@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Eyk9CmFj0MZWBIpzOknUE4ZG8EXNKYEDPpVdbD_pC00_1743519043
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01.04.25 16:43, Gregory Price wrote:
> On Tue, Apr 01, 2025 at 11:33:59AM +0200, David Hildenbrand wrote:
>> On 31.03.25 20:27, Gregory Price wrote:
>>> We discussed [1] how this auto-sizing can cause 1GB huge page
>>> allocation failures (assuming you online as ZONE_NORMAL). That means
>>> ACPI-informed sizing by default would potentially be harmful to existing
>>> systems and adding yet-another-boot-option just seems nasty.
>>>
>>> I've since dropped acpi-informed block size patch[2].  If there are opinions
>>> otherwise, I can continue pushing it.
>>
>> Oh, I thought we would be going forward with that. What's the reason we
>> would not want to do that?
>>
> 
> It seemed like having it reduce block size by default would make 1GB huge
> pages less reliable to allocate. If you think this isn't a large concern,
> I can update and push again.

Oh, you mean with the whole memmap_on_memory thing. Even with that, 
using 2GB memory blocks would only fit a single 1GB memory block ... and 
it requires ZONE_NORMAL.

For ordinary boot memory, the 1GB behavior should be independent of the 
memory block size (a 1GB page can span multiple blocks as long as they 
are in the same zone), which is the most important thing.

So I don't think it's a concern for DAX right now. Whoever needs that, 
can disable the memmap_on_memory option.

-- 
Cheers,

David / dhildenb

