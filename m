Received: from mail-43100.protonmail.ch (mail-43100.protonmail.ch [185.70.43.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1A130C163
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 05:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782279962; cv=none; b=YNsPbBVInrFtOz9OIkbULTCCDLs6V9EXNvTXmEF2Oa9ueKzoxAZI8VZzvTVhN4RFRlNczxYyv7OCEaXX2LEDSCtaMFAWFq+TPEv4EbXVbePrsWLhdrbrnAWUsE2SvWnpCxdjiu5WFC2SG5gMs3IwcSgaG4ML7RfWU3Tz14S5TR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782279962; c=relaxed/simple;
	bh=QxX7FqEdAL42tT448XuA2WcAZcPRHJrJHnUo7T4nawU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UDCqIZ83Gm+RXpO7EwaT2CB8Mpk3NkoVXXp7zH3pc9e+U2oGAPmBe1rbtOyKxMW5EoFmoa/6yoet8DDO7JSoIMjruoFrrFu9wHdsGML6ikJt5foLa96C3GkFX53nufGk031U+BVfluVjILKmkhnT0r5bDNAFGmMT5GGfOA+KFdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=kdFdtvpP; arc=none smtp.client-ip=185.70.43.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="kdFdtvpP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1782279947; x=1782539147;
	bh=Qv+1LEO8cOR+W8bqnhQVVCq1nXfaBqiWK9gHvcdCcjA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=kdFdtvpPkFv0+xUUPDBLiTY6yBchjtDaE8anPXcehzUpg3WgJS3uzHL9DMz5Scoaj
	 h/rY413dtJ5uYNYJap9QAQlCmqMMJ961KOEtQei0UzwhH4zGYa4qOvhKqFl4JuvpT4
	 ShnA/HRITeVpU+noS9jCarX0itTfuw2AwBVm45LwGqG4hO/h+KN4ktLpOEpzjBWHu+
	 kdEhIhX1MxwVvPwy9+1nGFUhiX2Usk34hyVrDtcpbdYuakvW4RuU6YZhoqGfVyxxDY
	 EZYm4LapPJSCCISdC4r4fMsX91BPS8AaEHpEyLouZQMi8rlYOZ3wXZg9UYP+wvpA35
	 Hs6JyAwuXUpQg==
Date: Wed, 24 Jun 2026 05:45:40 +0000
To: David Laight <david.laight.linux@gmail.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>, Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libnvdimm/labels: Prevent integer overflow in __nd_label_validate()
Message-ID: <20260624054533.531015-1-hexlabsecurity@proton.me>
In-Reply-To: <20260621112357.56a290bc@pumpkin>
References: <20260620-b4-disp-7f43b155-v1-1-0cfd8017f7a0@proton.me> <20260621112357.56a290bc@pumpkin>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 64f213e5dc5856fe511af42badaf79fa7062625e
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2026-06-21, David Laight wrote:
> The same could be done for nslot - any value above 64k is pretty much
> guaranteed to be garbage

I took that up in v2, but it does not hold against the code, so v3 drops it=
.

The allocation it was meant to bound -- ndd->data in nd_label_data_init() -=
-
is kvzalloc(config_size), not nslot-derived, so capping nslot shrinks nothi=
ng.
And the cap is unsafe: on ND_NSINDEX_INIT the kernel writes
nslot =3D nvdimm_num_label_slots(ndd) =3D config_size / label_size, which i=
s above
64K once config_size is past ~8.4MB.  A 64K cap then rejects labels the ker=
nel
itself wrote, so a freshly-formatted large device fails its own next probe.

The (u64) cast in patch 1 already makes the bound exact, so the overflow is
closed without the cap.  v3 keeps the cast; the labelsize-shift UB the revi=
ew
also turned up is a separate fix, not a stand-in for the cap.

Thanks,
Bryam

