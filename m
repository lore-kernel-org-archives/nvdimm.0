Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37293128CA
	for <nvdimm@lists.linux.dev>; Wed,  6 May 2026 20:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778099008; cv=pass; b=iHwcBvCMC7+V+BEzTuZ1SN+LaEIW/S35MIYbsHoLZa3mPIpSBODfYhNZL5DAh7C8yiix8OBqjf5CSyPxC6rOLetBJflRAYZXrQCD0Da7Ma5XQQtFE0KWR/ua3bBQRxFO426QWNIgm4+2+g98RbdS2m3sJVDcJvrYQkmDKsSzb+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778099008; c=relaxed/simple;
	bh=l2qvs/OpiAY7DahdxZ+FXBkHDAj1ng953bhsOXn6/98=;
	h=From:In-Reply-To:MIME-Version:Date:Message-ID:Subject:To:Cc:
	 Content-Type; b=LWhlUYmoRabpOCE8mjaAfOxOm7VO/ZuEXh3u4U2hnIkKmWRF/vc4+3/4uDpiJRl7Gbzc5oDP/EBlGd3SMTgsIDTmD3NWzMQcWK5Q4+NcPYZzrWFfA3tCLSFy7wyYIlXKmeNZgL5pL+yOQfuqCCzdqb/Xb3M6/7VDPZm45moBMOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tASplOQV; arc=pass smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tASplOQV"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-62f418d01d2so65556137.0
        for <nvdimm@lists.linux.dev>; Wed, 06 May 2026 13:23:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778099006; cv=none;
        d=google.com; s=arc-20240605;
        b=KtEVCBht2WP1TcFFLRpd1FiYb2JCnsj+nYEIM4PypOuZL5LXRr2gI5X8sz8vft6zKv
         235GCesGofDehGLV3871ByDnuvN9yrxHCNCSqjNlu8S3LBOQAXCdsgviYWtz2B9zkVht
         0D3hTkWmnSqJ/bMK1msmEozq5Zjo9awIX87bwjUT9vQeocKnuvSxwLaPQfXZYmdug85+
         WWpjnre3L54R6ZOxwTnN3HR/ukR0diwf4AOV7IJKKdmqQet9xcU3hFVamqhkfrddbv+r
         ftXHHgQJGwi70VlNSPsSAftvrNtQFkEYSwL67vqv2wPn1tNmmYkuGjH/NyYEnwfNsfIi
         AMlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:in-reply-to:from:dkim-signature;
        bh=l2qvs/OpiAY7DahdxZ+FXBkHDAj1ng953bhsOXn6/98=;
        fh=S4F9xUq22ct8LVsuv6JE4SRPlHbxCE+E7s+TNfqKPCI=;
        b=c1cHFektdzrgIRhRcnhvst5J8zJYrEqJSTjl1a1TJ9akjJ+lkc27yrQj0fHo9aTZQV
         QOIzP/TgGBp89NryoHrD7CALcny+fTj8KWJYQDy8kdB8/0/GFpZEyIIPs9ew1xBxbJlW
         ff4WKCgiIeYeXeLjhzjaJ7XNSfNWoadQAK9y0aE860ls9lAYjss2GRdD+QvmMUvxF35c
         1rPPjIxQQD5hcECaVQOJqiDN3ljgQXHnS4uqAsxV2zQieMH+NauzEhfoz4ZawHqgoT/V
         4DQdCDJ+wu+foUlQf4aBsmQ2p7qKoDC/TzPiQgg9D1qLCT2LDEQTzcsOXtH23OJy9Gg+
         BavQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778099006; x=1778703806; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:in-reply-to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l2qvs/OpiAY7DahdxZ+FXBkHDAj1ng953bhsOXn6/98=;
        b=tASplOQVkjcxgGX8JPdhEX0+BV+j60VePfvzyBupKCYIp5rtt5XPRMxr4HlOsawQpM
         /37gNwejVtRIprEGhH7zCt05/sZunzaS8TtGPjUwLpNvaO90KbNInxzoAnC96wLVbIfO
         MHwzBZKwpU1PbmSi7mQMLvYIBCJIZuwtCxN91YINGgNqFwDut70PvPxxrZwk7DKlmUk2
         7FgQEILAGmMceUhR2PRCb6nhoy8i67b5urNOSRxzlVjoQHn0/6B7XMQYkvhHs2tF8sVP
         qLin351pDYCP4AmWQKTVZPg7qIWmTtuJErpb0GWCd0UgOndOn/y/vWL7TkpIJ9tQ1fzx
         f17g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778099006; x=1778703806;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l2qvs/OpiAY7DahdxZ+FXBkHDAj1ng953bhsOXn6/98=;
        b=RD24x7Gp0Cu5nXPqsJlqyo3DQ9nsoyDlhMS/xXnjZ3CzGIGUE42BjnCtoncNIXdvhG
         FfPGB5rrci6I7+zUjZgc5N3tL7DsI1eDQOYhJkQJZT83VZ6YwN1VPS4TOsPacQnBHVMb
         l22z/dV4rVM0vPdpkWZNTTEiuP6QHvrRs+7oW4uMZmqs7dLdRlP50azzj7RkpHjQvN2Y
         /yN8nANCJ5wRO6xaeQjdiIiaMPgT/i+wPR2VI8P0epyV6OoxZGYkZKFzshNeZBaMW0at
         k0/WuXqD/HYxzrcP7dNVwwsw36zvE6015dLzmWDONtxQoBbX2C9fmrKLmFfiGbIDQvUI
         yUaQ==
X-Forwarded-Encrypted: i=1; AFNElJ//wjz0Y/IqEzLCM37QNGdY3G0lGStNFN/TuSMY+EliRMVCU11AsdU6uaHnxDNQ4/oxWGQOw54=@lists.linux.dev
X-Gm-Message-State: AOJu0YxTY1PTHiBtN2iOmfzcWxhbdrSIdFMQr5rbX64zBie3huOoEz0h
	CTEjqag/g24Qs+VlILFDVFzTBJUBdWP6NQjqvJNMYenI+RBStVAm3RfdpoUTztqyfp3JyefxvDw
	4kwiMMUvqIBRZEkQ1K2kLjQhvMGMWqdpR0920xaIw
X-Gm-Gg: AeBDiesmVHqb9xn24BdEc752c3vsFKZ2mRaz4X1CabwjDqerDBnti/uc0EeU9ot6yvg
	adZkRNyMyKuWI0tyrTK6o8OJhB19wvNeFZmZeY1VlwSGHUXLbldHKODmsFKh9IdVpPaypFPaKFf
	TrBg7esmyJ1edkPj78PazFTL4W1AR5IcWbxMB6jab/Rv7KumKMpJxzHaQ8++pDAiRZtki+7V0sf
	GBFrZxaqpNyFgBls8l/HpB5Cydhi2dISJra/AlmkJqie3tUnm+meBi8DeEGGn2u59M834jxX1nI
	mKCCnyUlYmishe1NF9kD4Q3lUsnEFAwtPHMJjieXf++kqhi1+WQhChX0JOioVd5ZfwftuT3+14q
	LHJGPslivrC9WKA==
X-Received: by 2002:a05:6102:374d:b0:611:a5b6:f4d6 with SMTP id
 ada2fe7eead31-630f8ff141fmr2407196137.18.1778099005276; Wed, 06 May 2026
 13:23:25 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 6 May 2026 13:23:24 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 6 May 2026 13:23:24 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <0e831045-3b01-4934-bf43-b3ef01ce0158@intel.com> (message from
 Dave Jiang on Fri, 24 Apr 2026 11:23:09 -0700)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 6 May 2026 13:23:24 -0700
X-Gm-Features: AVHnY4IJAbobQd1jI1QFhsLlfJKxJLWrWZnikjZTL2Cfiw0_frRcrImPr17kfIg
Message-ID: <CAEvNRgE3ifAvgVS4bLeNp_eVp0=6b3p+myYEXSfyS+Qrw5mrtw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
To: Dave Jiang <dave.jiang@intel.com>
Cc: fvdl@google.com, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	djbw@kernel.org, iweiny@kernel.org, pasha.tatashin@soleen.com, 
	mclapinski@google.com, rppt@kernel.org, joao.m.martins@oracle.com, 
	jic23@kernel.org, gourry@gourry.net, john@groves.net, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dave Jiang <dave.jiang@intel.com> writes:

> On 4/24/26 10:13 AM, Frank van der Linden wrote:
>> Dave Jiang <dave.jiang@intel.com> wrote:
>>> This RFC series is created as a proof of concept to connect device DAX =
to guest
>>> memory by riding on top of guest memfd in order to prove out that devic=
e DAX
>>> can be used as guest memory. The series seeks to jump start a discussio=
n on
>>> if there are interests in creating a DAX bridge to utilize CXL memory f=
or guest
>>> memory until the N_PRIVATE implementation by Gregory [1] is available u=
pstream
>>> and DAX users are ready to move to the new scheme. Once there's an esta=
blished
>>> consensus of interest, we can move the discussion to the best way to im=
plement
>>> the DAX bridge and the future of device DAX as guest.
>>>
>>> I did the bare minimal to get the PoC to pass a modified version of KVM=
 gmem
>>> selftest (guest_memfd_test) in order to prove out that DAX can go in th=
e gmem
>>> path. A DAX char dev is created and the fd is passed in user space with
>>> vm_set_user_memory_region2(). The DAX region is passed in as a whole wh=
en used
>>> unlike memfd where any size can be passed in to be allocated.
>>>
>>> The folks on the cc line are people that Dan Williams has mentioned tha=
t may be
>>> of interest to this.
>>>

Thanks for the PoC! I've been working on guest_memfd HugeTLB and I'm
glad there is interest in other "backends" for guest_memfd :)

>>> [1]: https://lore.kernel.org/linux-cxl/aeWV1CvP9ImZ3eEG@gourry-fedora-P=
F4VCD3F/T/#t
>>
>> One of the main ideas behind guest_memfd is that the memory is managed
>> by the kernel only, so it knows what it has and that it can trust
>> the memory. This RFC passes an fd in via the ioctl(), which I think
>> breaks that model.

Yup! One of guest_memfd's core purposes is to be able to block host
accesses to guest private (in the CoCo sense) memory.

>
> Don't we issue KVM_CREATE_GUEST_MEMFD ioctl to get a fd in userspace to b=
e passed to KVM_SET_USER_MEMORY_REGION2 ioctl later? We are just passing in=
 a DAX fd instead of a guest mem fd.
>

This RFC is passing a DAX fd instead of a guest_memfd when creating a
memslot, so it's not really using guest_memfd, it's just reusing the
functions that were first created for guest_memfd to support another
kind of fd.

What's the use case you're shooting for? Why not mmap() from the DAX
fd and then pass the userspace address to KVM when setting up a memslot?

Is there a requirement to have the DAX memory usable by CoCo guests as
well, and hence requiring guest_memfd-style protection from host
accesses for private DAX memory?

>>
>> Since there is interest for several different allocation backends
>> (default, hugetlb, zone_device), it might be better to use a model
>> where guest_memfd has the option for backend allocators to register
>> themselves in the kernel. The ioctl can then select one by their
>> id/name (could be just a string). They can be configured using
>> e.g. sysfs (like hugetlb already is).
>>
>> This would also allow easy experimentation with new allocators,
>> having an allocator with BPF control, etc.
>
> Agreed. Although my main intent is to see if there's interest with provid=
ing something to the usages already on the DAX path an ease of transition u=
ntil something like what's proposed above shows up. But if what I proposed =
will be a security issue then maybe not.
>
>>
>> - Frank
