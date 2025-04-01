Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6592080FD
	for <nvdimm@lists.linux.dev>; Tue,  1 Apr 2025 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743520776; cv=none; b=pjD9w7BbEio7p/z69Y3qNn6b79YvyPnXxP2Bztfr09tLdIPOFyiMRZG5HrT3HOHJDEQApx8X7VWERKG55pSqRX/CeQdSFNTAtl5iFpAoZFo9SMhdckqlL0lVKPJdF2OH6CvatbsIT8MH3eLdE1xdi8oiHA3DmmldH6Cad8GX+BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743520776; c=relaxed/simple;
	bh=AlwF81TVaadw7+lfzB8oXdJi9rghk+QCYdTIw26yof8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mk4kxoUEB7At1d0vyLVmkpwBgGhKQ+6imZSY70F/hX2r9BMUJI3Sg+VPb8XB/dJxpAwrr37DzVqB6sPOX3vE59cKy+DfBYI2TCBOkyiAoNQH2z2FvzHAlZHPOBkGIOh+NnBquV6GVkHOF+nSNO15hJDlZaNQM9CGBKhZfiffR7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RDT6djC5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RDT6djC5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743520773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MUCYBC8QpFNkON1Pl6QWuPX91KW2SZMzJn1Z+ZAlxp8=;
	b=RDT6djC5V6vE+uJpngdIpe4yU3umpPcyDQWCn1O81Jt0iI3jpU+gQnV/1NsgMH8jMmmO1G
	Z07EmW9dYfEiiVKL+VoWRqMuNwGa5oFoMhpc/UE6kWrI2iEcHTramRkJzzwEVpI2KpuQMP
	5A6JKWX8z/sPAZ7I1UHiePRH2DXhyVw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-cIBU7VFMPg-QEsciNwEJ2g-1; Tue, 01 Apr 2025 11:19:31 -0400
X-MC-Unique: cIBU7VFMPg-QEsciNwEJ2g-1
X-Mimecast-MFC-AGG-ID: cIBU7VFMPg-QEsciNwEJ2g_1743520770
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39979ad285bso3193467f8f.2
        for <nvdimm@lists.linux.dev>; Tue, 01 Apr 2025 08:19:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743520770; x=1744125570;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MUCYBC8QpFNkON1Pl6QWuPX91KW2SZMzJn1Z+ZAlxp8=;
        b=A8SfH7vWuOZAUlymdUi9z2ApWr6PoHmAKerUwEMWX9H+2GIrelJZn+1BSrTLp6A/pu
         4Nz2bq9GazkVX6yf4Wp2GW/yVLaA1aeMRZSWnRibU01kADegcRubChqphhdmQJYp7GJs
         MIR2dzFidQRk8a2q03+CBpOfQV0NYR1226ZrduDUEyIeQTA3h7IIUbBra+igvsC1ttes
         /ZDNMoMBSHprJ3wunnjBDrNLwgrR+s10PmaKLRilmpBtWerF6MOtfs+Eml5km6L+7foe
         gSP0+gP+Qgx/xFZuPYnrUzqcbPZ/z5ma2KfdRftkwKXo5iZOM9fYtyKcFup4WH3t84J6
         DG7g==
X-Forwarded-Encrypted: i=1; AJvYcCUS/kokF4Dr1BgcbiMotXbaq+o8L7pHldCKuog8Tt6PuQ02P6YCXfdIYPfhL7Po9T7P0PI/eOE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCKgjOYQV1ccSEMJ+N+iyLKt+0uf6S9knUGviitUOexaPJbVNk
	zMsfQptm9S4TLBtX1NKcaDBjkBsQancvaCeXTAn3bukppfJd8Y+J2Op9o1NSQUkakAVdbVgau+e
	wak2uNhDunStDJymdQxbLvme0tpBeRf7NhzEf8I4BBaI+AELXhD8OqMVAazAY+fNx
X-Gm-Gg: ASbGnctkRKsR4OWG3Ty7eiVqLSdO22y+9afyb0Q4uUho/yf/yndbc43qpLkR8NuHkpu
	o6fYpJJd7oLSzlqM2ZbPLKfvDUDwhYtLC/wzIBqACDNRWoWVsnFFF5I94V6QKpm+slvG/3f/Yg3
	M86qLLimujw0H9b/V5X7yGu4PfqbGF3RGOe0Ij3lJoXDpR+h+BEH6W9AvUvsehpsjDRfBqFaUkd
	45pYmKs7QKvpy69Eol47r0wheZdvS9dStnsCRaUmBQ3ljmmSskGmMxMfiKoM3C6vkGzisgLaZ3M
	pN9on9t2gfAdC2aLjcOHJixtSY+sQPmpGuELQgnHj5GWrYmx/UoLg3NwTcLuUHGpcuorqp2VYJX
	xXzB0SugWuM9HkXxV4Pil16gDlFlbec08cim92zUW
X-Received: by 2002:a5d:5848:0:b0:391:47d8:de25 with SMTP id ffacd0b85a97d-39c12114f9dmr8971178f8f.41.1743520769980;
        Tue, 01 Apr 2025 08:19:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfNR8FT5G+JkuhA9jfULCTCiIdc30yoCh0axaHw+nTV+29uzdY0WekzNR63m+lDaoPsny10A==
X-Received: by 2002:a5d:5848:0:b0:391:47d8:de25 with SMTP id ffacd0b85a97d-39c12114f9dmr8971149f8f.41.1743520769600;
        Tue, 01 Apr 2025 08:19:29 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:4d00:6ac5:30d:1611:918f? (p200300cbc7074d006ac5030d1611918f.dip0.t-ipconnect.de. [2003:cb:c707:4d00:6ac5:30d:1611:918f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d82e6ab48sm205670065e9.10.2025.04.01.08.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 08:19:29 -0700 (PDT)
Message-ID: <a65fd672-6864-433c-8c82-276cb34636f9@redhat.com>
Date: Tue, 1 Apr 2025 17:19:28 +0200
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z-wDa2aLDKQeetuG@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: utUkOPDFVwk3UC0EEGxQNTQRdXiP0oGSiEp-j7un3N4_1743520770
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01.04.25 17:16, Gregory Price wrote:
> On Tue, Apr 01, 2025 at 04:50:40PM +0200, David Hildenbrand wrote:
>>
>> Oh, you mean with the whole memmap_on_memory thing. Even with that, using
>> 2GB memory blocks would only fit a single 1GB memory block ... and it
>> requires ZONE_NORMAL.
>>
>> For ordinary boot memory, the 1GB behavior should be independent of the
>> memory block size (a 1GB page can span multiple blocks as long as they are
>> in the same zone), which is the most important thing.
>>
>> So I don't think it's a concern for DAX right now. Whoever needs that, can
>> disable the memmap_on_memory option.
>>
> 
> If we think it's not a major issue then I'll rebase onto latest and push
> a v9.  I think there was one minor nit left.
> 
> I suppose folks can complain to their vendors about alignment if they
> don't want 60000 memoryN entries on their huge-memory-systems.
> 
> Probably we still want this warning?  Silent truncation still seems
> undesirable.

Yes, it's valuable I think. But should it be a warning or rather an info?

-- 
Cheers,

David / dhildenb

