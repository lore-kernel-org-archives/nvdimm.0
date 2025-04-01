Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F6F20AF69
	for <nvdimm@lists.linux.dev>; Tue,  1 Apr 2025 15:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743521358; cv=none; b=XLBfnllkJpQJdonu8Uyx+LOhAxuu13NIAJBnp16AjmSjNsmiC+3FacoZOmIR4uayEVYcy0dRyZvrBSC2IH+QUqQo67sckXGY5/+GnCF+VdtACR74ej/7+NesPqITluzhLy2bx86NVdyUez9CC6Xcpm01ak0gpPaMgfEntJULb2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743521358; c=relaxed/simple;
	bh=7csd6OtDvkgO9g6hDGoDH63fg6YM01Q1hsp4ItpDrFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RChLgz7nuFJfTnKze3LGGAWZPT661zN/EgYcGYoikvxUuNqOHLBu+y0zqYI+F3/K4TIPym6DHudy5pG13tNBLVkNZmPRAztwRJAS/QSfzLkyh+qK//ocR8zTO5otU4iGjGZTmm9y9FIV7bgzPnL3pk4OpRfdLCjGzq3koIqHg1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZZ1LDTgI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZZ1LDTgI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743521355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JKMWjD4/1UoJsnBJJbKHGGdwUYue0iaX5yE7uwOt2R4=;
	b=ZZ1LDTgIt3NMBYpTSvBf9hd2SeCMZGhRc4PsaNkPmU33o6HuplCAfNqMyo5UheCF4WvsgY
	t3KrdFRrXGBVcHAgldBeq7vmaLbcBhPnCJ4O5vfFw6n0VZQsoVQA4e7C+oTinDOrAah9tN
	7QU2TW3qPElOCjbORqalPlfdx2fvgis=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-PDexm8RUNtWdCaM76x6r1w-1; Tue, 01 Apr 2025 11:29:13 -0400
X-MC-Unique: PDexm8RUNtWdCaM76x6r1w-1
X-Mimecast-MFC-AGG-ID: PDexm8RUNtWdCaM76x6r1w_1743521352
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43d22c304adso29303205e9.0
        for <nvdimm@lists.linux.dev>; Tue, 01 Apr 2025 08:29:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743521351; x=1744126151;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JKMWjD4/1UoJsnBJJbKHGGdwUYue0iaX5yE7uwOt2R4=;
        b=HBchm5gOUjIH4FC7lzOOqYgXr+IdVOfN+8uAnF2buroPNyp9UjSkSA2UENfTxlp4sg
         GqaxCKurGP8G+94zQQTM4UpP5riBYpq2oufFgIqX9oWbRE9748l9nFJnBidg7CFBsv1t
         wkNO5DfKJRhuut8UPH1Qop/wXlKtziw43/HGJx9Ve9VPuqJaYgxLZDiWa1NunLe7feAB
         +n6oVIJwzi7ti6Og87rXkPAiIJt/5FJNqS6Lteo1KuuDlyohWJw2IRVFrM4L37EMZ/UL
         39XqOguQkvM1DpiEn4olLDqjaX+K/MnSC2jFf5Usc5TarW4BoPTCfJp3jbyuyjjSGTV+
         m2Rg==
X-Forwarded-Encrypted: i=1; AJvYcCVDuzARIGiFt5JqLgVSDtU+JeKwS+aaLNnEV7DYT2Tj6mJh+0wfI57JNWhnIOPEF3pn++Z7d2o=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYzxiGc+HpTlHKJrkUI9B9mxE41tqBiTb5UkN56qdbt+15M//o
	bewlKR+NS5IFSZDo3lSO2bpQjXTpBEhDmMG+udeKuua0XUSX3G/1fNs/9ldyBd6E0Xe6xg5wjOa
	K7qdmkn4X6/QR1dDRlP9FPuOhnkrb1cRdeA+ToUp6NYwfKLdXC3g8Cg==
X-Gm-Gg: ASbGncvcW/dbpsHX+lcDZhEPstswdyua3Y12g7Z/ooaN9EpZ+pdAzPm1Mcu7U2jY2NC
	23+n4fZN9rDUNi7OUM4YcdHNekmVuzwW5XUC2AAL4XQcGLjblVVWZpl7rzmrfzJjnXiKA3hLvrk
	8cXxoJai5d300yHfwmOLpwYfvnhW9EnFrtBXlioRHhkbcupo+tsfoAET42jzeidOQZn77O3L3gO
	tldKenpWj608IXD6/UFtXqh3PiWrJ4QFKNip7Nd81fOQMX4KDYiiWSlEXveiVMpSQwFEKgMthIH
	+vm2Sb+6V2k/LIk69tgGtOZE4+w0EUAG/RfO/Zx+yJg5gMcgxVUKaQIYpz9p/KyC2xeneJrs3xV
	aRAKy21lH5TeDgOuRjU9N0WT9/sb7QSg27Gr2g56t
X-Received: by 2002:a5d:5f50:0:b0:391:bc8:564a with SMTP id ffacd0b85a97d-39c27f31c47mr377404f8f.22.1743521351618;
        Tue, 01 Apr 2025 08:29:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEa2GAOlNF90dGbPyI4uliM2Z3nEo4kY5EmhxPgqtmwN+3cr+l41FVkCjIb27SnNn916HOrlA==
X-Received: by 2002:a5d:5f50:0:b0:391:bc8:564a with SMTP id ffacd0b85a97d-39c27f31c47mr377392f8f.22.1743521351280;
        Tue, 01 Apr 2025 08:29:11 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:4d00:6ac5:30d:1611:918f? (p200300cbc7074d006ac5030d1611918f.dip0.t-ipconnect.de. [2003:cb:c707:4d00:6ac5:30d:1611:918f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b7a422dsm14585442f8f.93.2025.04.01.08.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 08:29:10 -0700 (PDT)
Message-ID: <e818ddda-180d-4136-9dbb-f9af278db1e9@redhat.com>
Date: Tue, 1 Apr 2025 17:29:09 +0200
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
 <4d051167-9419-43fe-ab80-701c3f46b19f@redhat.com>
 <Z-wDa2aLDKQeetuG@gourry-fedora-PF4VCD3F>
 <a65fd672-6864-433c-8c82-276cb34636f9@redhat.com>
 <Z-wFm_zwDZy6jvVz@gourry-fedora-PF4VCD3F>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z-wFm_zwDZy6jvVz@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aDu4YsUs9bmEiUE6ElU_0sTSJ8S7Yo-8r9bOR6V60YY_1743521352
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01.04.25 17:26, Gregory Price wrote:
> On Tue, Apr 01, 2025 at 05:19:28PM +0200, David Hildenbrand wrote:
>>
>> Yes, it's valuable I think. But should it be a warning or rather an info?
>>
> 
> dev_warn, but yeah I think so?  A user expects to get their memory in
> full, that means we're slightly misbehaving.  I'm fine with either.

Fine with me :)

-- 
Cheers,

David / dhildenb

