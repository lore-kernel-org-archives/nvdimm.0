Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.244
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792896773;
	b=PAT00FBlzwAvqYqpdphtT3geeLO0UZOX9sFuwvLgutvmHcWcqvMHQDRF5T0wjrhuUeVe
	 dIFVPAmgSGBpoI0BDDeazVpQUfRrp0AdTE8Z1o1gxhxrXVuz9PsPBT0wbqlWQ8YQHEDax
	 /An9ADrSjQk0ejk+M3bnfTIbDSv4STfZ3pWiljk7NPcm1T4BAd+Y/8p65kKpZl3vuTw8o
	 WfTvIIwwo89q0c0FFEizvnpuFL6E7vAWz7KQO3HsfZ9nDTXw0Q9UpsFD6NrpJtP0rInz+
	 6mXQcUSv2ENHccNEWSrcfPG1YqJ7cs5gkCrqhPyN139oJeMofvDYmco6zD3yYMegPBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792896773;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=HLOt41l/QWC0fEiGeX8Tnz6uBnCfl8WR/5GPhpD68hE=;
	b=3ieWTJB7STBTPAuxrVNW8MEAeWok1JB6TxpM7/38EGMv5b5/sAJxOJz1oGeP52AJGN2q
	 LFQE36H/YifPBv/CDjoeJs8OqV0wboNZlPJ53JrQMaCTCDUwrkcRKTBqBfagzBPgVP2b4
	 KW9G6+Eor9f59B1J6JqS3uk9cp7KUfUMfC28FoNkzAUz3yRQjCRx2QNcv8/pCIePY2BMG
	 pFWZ6PLYyo0ybE5wxwBULQzlrzq75Yf8l+w5QqnslA589sHeZAEatQHXEt+yciNGSTqf/
	 S/WOiDMOx4u0lV4EEfqwPsJJ97gd0Xc2IINGW97Sg7+Fib/aIjO6iEKm33czxyAJ8HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VnaMzf5p;
	arc=none smtp.remote-ip=91.218.175.244
Received: from mta0.migadu.com (out-244.mta0.migadu.com [91.218.175.244])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BE3606A31E
	for <nvdimm@lists.linux.dev>; Sun, 25 Oct 2026 02:52:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45BE3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VnaMzf5p
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=WwzTK24epbuB+saadzHwyBUTb+kgdJ1j3wLcauZFEws=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792896768; v=1; x=1793501568;
 b=VnaMzf5pP3Dolmqi+66MHJL/fPyN+GrmDU63AeVASk3zjwFHOWk9+fUUekuYO5bIq4AL+N0W
 TTpc/GyPXOStjk4DZHeTmD7zheTL7w7jOCSobVda8+JBXlxWtMG4CR2oYj/HD7TMDalmUYzyEE0
 rpUmsgMDP/XwtlphkrLbNM6s=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 8cc735b5c8cf76cd;
	Sun, 25 Oct 2026 02:52:48 +0000
X-Mizu-Trace-ID: 8cc735b5c8cf76cd
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v5] dax/bus: Fix Device DAX range alignment validation
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261024183853.6803ce81788636e94d8c16a4@linux-foundation.org>
Date: Sun, 25 Oct 2026 10:52:29 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5AFA3B1F-48C6-49FF-A6FF-7D71153671CF@linux.dev>
References: <20261024112555.2476001-1-songmuchun@bytedance.com>
 <20261024183853.6803ce81788636e94d8c16a4@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 25, 2026, at 09:38, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Sat, 24 Oct 2026 19:25:55 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>=20
>> Only range sizes are currently validated against dev_dax->align. A
>> dynamic device can therefore select a large-page alignment and =
allocate a
>> range whose start is not naturally aligned.
>>=20
>> Sashiko found that memmap_init_zone_device() could then initialize =
the
>> struct pages with a large-page order for a physical range that is not
>> naturally aligned. A subsequent write to a userspace mapping then
>> triggered a kernel panic in testing.
>>=20
>> The automatic resize path can also split a size-aligned request =
across
>> arbitrary free gaps. When devices with different alignments fragment =
a
>> region, this can extend a range by less than the device alignment. A =
later
>> allocation then fails, leaving the failed resize partially applied.
>>=20
>> Initialize the device alignment before its first allocation. Validate =
both
>> the start and size of allocated and adjusted ranges. Use the same
>> aligned-gap iterator for free-space accounting and range allocation =
so the
>> pre-check and allocation path cannot diverge. Skip unusable gaps and
>> serialize size validation with alignment updates.
>>=20
>> Static Device DAX already has a pre-populated pgmap whose full range =
was
>> validated against memremap_compat_align(). Its usable data range may =
begin
>> after namespace metadata, so require only dev_dax->align for static
>> devices. Dynamic Device DAX builds its pgmap from the allocated =
ranges and
>> must continue to satisfy both alignments.
>=20
> Thanks.  This is now a must-have for 7.4.
>=20
> I suggest that the changelog mention that the bug becomes hittable =
once

Let me explain this issue in more detail. Without my patch set, the
problem was not hidden=E2=80=94it was simply shifted to the second =
stage.

DAX device usage is divided into two stages:
1) Device DAX initialization
2) When user space maps a Device DAX device.

Without my patch set, this problem would trigger a kernel panic during
stage 2). After applying my patch set, the problem is caught during the
first stage (with the current prerequisite that CONFIG_DEBUG_VM is
enabled; if it is not enabled, the problem still occurs in the second
stage).

Therefore, there is already a serious problem that will trigger a panic
when users use it.

> your series "mm: Unify device DAX and HugeTLB vmemmap population =
paths"
> exposes it.  That's=20
>=20
> 4b77739fe789 ("mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX").
>=20
> I intend to send this to Linus next week.
>=20
> Maybe also a Fixes: 4b77739fe789.  That series didn't create the bug,
> but this data provides notification to people who are backporting this
> series (unlikely) "hey, you need to add this fix as well".

Based on the above info, do you think it is necessary to include this
commit as a Fixes tag? My inclination is to exclude it, because the
issue is still there. It's just that it gets triggered earlier when the
debug kernel is enabled.

>=20
> Also
> Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Closes: https://lore.kernel.org/wlrkqqvg.ritesh.list@gmail.com

This is a similar issue to the one reported by Ritesh, but it was =
reported
by Sashiko.

Thanks,
Muchun

>=20
> I don't believe that Ritesh has tested this?  He wasn't cc'ed...


