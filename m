Received: from mta0.migadu.com (out-123.mta0.migadu.com [91.218.175.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AB9388878
	for <nvdimm@lists.linux.dev>; Sat, 17 Oct 2026 02:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792203966; cv=none; b=J782Q2Gla1iISmZ5EHrn0t0Th6wCRCj80sGLSyVoNPh/43EvUV6T5KVlXVVJ8PviZuQ1v/Axk3dt3iqXbdHoPT10lYrk+dxtMGkcvXYO5DSNPTqHFXmYZ8Sg4S0OvfmWOvnD5E1Nd5aXKOnfKgb7z8XlFbRFu/Oz2hMvns9r3lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792203966; c=relaxed/simple;
	bh=kT73SQ9qrNBz4JQaoCwZQm7pd4IOO4YKtSqNYA+Lw7U=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=RVhVsK4mwj8paFqq4tLiv6OF25YTDtnGnfU2SlE9aE3eeD1jRwdUhW0lImjLI6wru5mNYtoL4rd2zKt7AyEIc7XNtG32m1q3La2jC4SukgnOtXWH4P1YefHEn52JBmnG9G5qcd2xV1gKNZ6HjTbsMDe3fTmTjRp2TjMijqiExn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jPKauD8A; arc=none smtp.client-ip=91.218.175.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jPKauD8A"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kT73SQ9qrNBz4JQaoCwZQm7pd4IOO4YKtSqNYA+Lw7U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792203960; v=1; x=1792808760;
 b=jPKauD8AIHvxo3X9/Fm3sSHzHMe5+qfLBhsBokDqFJgwB7p862MKpb/YJ7V1l2E9evGlYDhV
 0chKnX1Yet1G4c4ffLv1DYC54l9N+3QZYvdLl7kRGz3hlIsiQ6LFR3iujOK/55R6K4j42hAeWAd
 Mvg2eqCCUP3XlHq5KwvhiV30=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta11.migadu.com with ESMTPS id 67a546fd69196711;
	Sat, 17 Oct 2026 02:26:00 +0000
X-Mizu-Trace-ID: 67a546fd69196711
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm: warn on unaligned compound zone device ranges
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261016192111.cf4b6477a13a711248a8a079@linux-foundation.org>
Date: Sat, 17 Oct 2026 10:25:42 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Mike Rapoport <rppt@kernel.org>,
 Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 linux-mm@kvack.org,
 nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <869C8763-FB8C-41B2-957E-0AD1B22FCC57@linux.dev>
References: <20261016131334.3419393-1-songmuchun@bytedance.com>
 <20261016192111.cf4b6477a13a711248a8a079@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 17, 2026, at 10:21, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Fri, 16 Oct 2026 21:13:34 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>=20
>> A compound page of order N must start at a PFN aligned to 2^N pages.
>> Therefore, a range used to initialize compound pages must start on a
>> compound-page boundary and contain an integral number of compound =
pages.
>>=20
>> Two recent Device DAX bugs were caused by ranges that violated this
>> invariant, but neither was detected by memmap_init_zone_device().
>>=20
>> Warn if the adjusted zone-device range violates this invariant so =
future
>> violations are reported when the compound pages are initialized.
>>=20
>> ...
>>=20
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -1142,6 +1142,8 @@ void __ref memmap_init_zone_device(struct zone =
*zone,
>> if (!nr_pages)
>> return;
>>=20
>> + 	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, =
pfns_per_compound));
>=20
> Would VM_WARN_ON_ONCE() suffice?

What I was thinking is that this function won't be called frequently, so =
it
won't encounter a large volume of log flushing. Therefore, I didn't use =
the
ONCE interface, and this way it can continue to catch similar issues.

I'm OK if you prefer VM_WARN_ON_ONCE() though. Let me know what you =
think.

Thanks,
Muchun

>=20
>> +
>> 	/*
>>  	 * Seed the reusable head-page template from the first real =
struct
>>  	 * page. The normal page-init and refcount helpers must operate =
on
>>=20
>> base-commit: 63562804f25cb5b6f5e4f5e3a9f0d1c3c6868596
>> --=20
>> 2.54.0


