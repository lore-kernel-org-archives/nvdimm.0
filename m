Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AE3361657
	for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 17:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777052335; cv=pass; b=odWfO2uCTP/Y+bNtqgfVx6Y+qLg/L4LFKt+T3AbpTpioJ02fPMBCNfJQ4rnqeLbELImjqqkVgAv/kufaCftg5SVL2WEvgGaP8U6SUPnD9jDlNiK/+YY5PN/i+3dcm8cYoh0KzBKIWlrI1wFj0gLShIo7pnBBYauFeF7PJLq2mPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777052335; c=relaxed/simple;
	bh=b/xeCCC5W128UaMBbfsEO1lBBherMKdTDKmjJXAMNfc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XWY8c6OpcHL/m/OYbFOHBPWbYMHnCi3SEgQKVD2sD/Kx4ZvZUUcygaJQPWz5xCGRu77orqKYJH+VYntdtYzxiVTTC+u0ZyqmXlIcw/FxJQP6nmUr+OYH5xal/zXZEZesVl0UiQU5k6Bmn4GLHRl3NSSNUIIE/Av8knP4bS5aAKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vp8UtxPC; arc=pass smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vp8UtxPC"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4891ad5c074so758395e9.0
        for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 10:38:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777052332; cv=none;
        d=google.com; s=arc-20240605;
        b=E1Kk3aoEP7iza+8NczBmVSi8qZGdmGkaNjK8Dbp05Om7n0C00tKQkd2ypNrfDMTHmA
         f97CZAnWFsPAH6SDLspuzGUp96W/4rwUNovNuo+lCABE/3C4/Tej5Jxc8HjInxXgHmVX
         TCekb0vVyDD49QpK2ZtrC3ZD5wCyz9QHTOzp4MNK5diu1hEXQ/1RXfaRihKhpYq6sijw
         SFrft4NCKrO9woA44EQsKkY/hNqDx4A2SUV6IYiS9kEHeQLqlHX6wcT2Tv/dch+D+z1D
         aZJ0NBmtutbHtCKDO4ybt2sKc5EReN+0xkmLlL+3Xs85MlrsFz/OqzrCRKuqfYUEoAqv
         FQIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b/xeCCC5W128UaMBbfsEO1lBBherMKdTDKmjJXAMNfc=;
        fh=ORDETg2v5FXYzbjYXm5G6O17wGnAFBvoBuoLU0QDdkw=;
        b=XwP3XPYb5dvGTJR+h0PwrV3OkboApX/2pATtqBvSCVa6ka4rc50l+mhN2Ed/oztslV
         yJ54BihtlFmxesqbNvaZsn41fF2ByNF/gwqA4ZCxLUoG3bbVQrKOzWZPCUqBoZxnQ9P2
         GY2J2e2VSnTAgej22eJuwIcoXBAQIKDzmOEXlcrkfT+srfL3YL7NMzQ7pulmZTz3Rqi7
         M1ylvRwyjdmGhhK8x73ClZ0kEXuveyAcB07ftRwKJtKukurlHYl9A+UCzaKz1GHaY65O
         2rRq68GGETFfyyLJhcCwOW1b6Jwj7od4RCEsXn3xVoFrMgu9kG2/Tsta+cexvBjPeWsJ
         KZrw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777052332; x=1777657132; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/xeCCC5W128UaMBbfsEO1lBBherMKdTDKmjJXAMNfc=;
        b=Vp8UtxPC4YcVd2R5/wWDAO1RVw5QXWUT9HYIYnhaBUfgrFaF3WFfi/zkyrfE4z2h2f
         oLfyUO7ufPVPmiltHvKGrsL01LZs8xEq6uXYloWWzsQ2QW3AAmO4UAMxCgqgRxtIfUuj
         +qFehrq+5a6pWtNeQ30dz1JpRlAdZS1TBDhjBr87XX5HpW68mmI20Zf8d3Mb9ORRFnYf
         G2j/KFpWL0QH6HHAHm/fjtCFblBbo1qgedBucEc7JgA486z2MXPbk0x0y9hSBysjNcdX
         U39cDKNNL/z3K8JGXMQ/GLkVJ4sWQmdCdLm2kvJ2e+D47F8qAUjZz1D1uyBdgS2x1PWR
         c30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777052332; x=1777657132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b/xeCCC5W128UaMBbfsEO1lBBherMKdTDKmjJXAMNfc=;
        b=VrWbfK+wO6APkKtuuMBzFokTqhB0ORHet9Tpp9O1Meppr7sRJqpR1OiGU0EmMc4aT6
         nm1JRXTy9h7us8t0XPK9sGbbQVxmidwyF1i4wCcIVCf+S/rMictZWKsj19uvR1irFGeJ
         ZwkTZNYRDFtCRdU642Dh2ZmB95eojQRXcOAhbJ02d7JbeLiPCMcMrZOaiGoMRQ0TNquu
         crKybgxsVXDxOtyWx91uYrUzE2Bt+xbmvnsUCqjPTtWSPsPvKCh8uW9W8XrHUKVfIsn3
         trUojtNMyLjM1//Az5bNHf52/nwcH1nmrZWDzatCKCtRrR9+BrBBlwXo/ni/QeFImRZ7
         iBZA==
X-Forwarded-Encrypted: i=1; AFNElJ/ZgQPFoWmfLpkxIt9wx0UON3pYSjXKiZHMZjing2/OqRQGcWhd+WEVSl6MEQ3g38hAvMy+G08=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCqjbZpcDkgCEKBfgTu0g3cJBNI+Fm3eBFsUqxD9UYi6/0OE2B
	fm0xHjOrTqdId0UF1MoWhz7YiMVBzmDi7VxjiZddb04hHgao2kGJak/ZIuOhkWW6Ke48a/tF1LV
	7XnrZxdkJYjUn6ghN1PowqzOBJOMVxqWSjWEWRCz8
X-Gm-Gg: AeBDiet6w9p+g2mqTrHNMYwW59qIXd5EhgJG3d9vb8r1yW7GBqcYo36TgCj8dqRcQBX
	O7ckW9Edaq8DRzfBzTpENtJwr0FBP6i0IfyohZ82WPga5thK2asmT8X8ySMO8vJ8VTkTh1ZYuwc
	RgOTVl0rfEjSZOyja8h3nqICovlU6hWLtQiGAcQ26Lbw0S4SAl+RcPvNPhVuR1J8xgnVh/dIDDW
	0ka7m/QQRipZsftknAP8pzzh9OpB5lSLtUHRJgL0eRlsV9hGhF8nZwEnJl71e2R/0Jgph38n+AV
	Wl5ovuUOZnTaVgxQgQn82vBpNOqj
X-Received: by 2002:a05:600c:35c8:b0:485:b6e4:9808 with SMTP id
 5b1f17b1804b1-4890139c764mr8364715e9.1.1777052331512; Fri, 24 Apr 2026
 10:38:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260423170219.281618-1-dave.jiang@intel.com> <aerm4yDVYpOhxXEF@gourry-fedora-PF4VCD3F>
In-Reply-To: <aerm4yDVYpOhxXEF@gourry-fedora-PF4VCD3F>
From: Frank van der Linden <fvdl@google.com>
Date: Fri, 24 Apr 2026 10:38:39 -0700
X-Gm-Features: AQROBzDOaDaeRGYrRb7SiY3F0XElXTuplBC6pu5Adcv_74_sTvogE-uZI0FJx0I
Message-ID: <CAPTztWZwaCYwNp3d_SvRTUD9PwUqfOyRTjoqmq-DwqUVwK4QtQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
To: Gregory Price <gourry@gourry.net>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	djbw@kernel.org, iweiny@kernel.org, pasha.tatashin@soleen.com, 
	mclapinski@google.com, rppt@kernel.org, joao.m.martins@oracle.com, 
	jic23@kernel.org, john@groves.net, rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 23, 2026 at 8:43=E2=80=AFPM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Thu, Apr 23, 2026 at 10:02:07AM -0700, Dave Jiang wrote:
> > This RFC series is created as a proof of concept to connect device DAX =
to guest
> > memory by riding on top of guest memfd in order to prove out that devic=
e DAX
> > can be used as guest memory. The series seeks to jump start a discussio=
n on
> > if there are interests in creating a DAX bridge to utilize CXL memory f=
or guest
> > memory until the N_PRIVATE implementation by Gregory [1] is available u=
pstream
> > and DAX users are ready to move to the new scheme. Once there's an esta=
blished
> > consensus of interest, we can move the discussion to the best way to im=
plement
> > the DAX bridge and the future of device DAX as guest.
> >
> > I did the bare minimal to get the PoC to pass a modified version of KVM=
 gmem
> > selftest (guest_memfd_test) in order to prove out that DAX can go in th=
e gmem
> > path. A DAX char dev is created and the fd is passed in user space with
> > vm_set_user_memory_region2(). The DAX region is passed in as a whole wh=
en used
> > unlike memfd where any size can be passed in to be allocated.
> >
> > The folks on the cc line are people that Dan Williams has mentioned tha=
t may be
> > of interest to this.
>
> I see these as *mildly* orthogonal, but I think maybe you should propose
> a discussion at LSF to talk about this.
>
> guest_memfd in particular wants the host to never map the memory - and
> guests *generally* want 1GB huge page support (TLB go brrrrr).
>
> There's a real argument for just handing a physical memory region over
> to guest_memfd and making it manage the region manually, rather than
> doing a bunch of nonsense just so you can call alloc_pages_node()
>

Yes, I agree. I originally planned to do that as a project - I had a
prototype of a physical memory pool allocator that just sets memory
aside at boot. But I quickly concluded that you still need folios,
they are the currency of memory management, and hard to avoid (and
maybe they shouldn't be avoided).

So, I ended up hotplugging the memory in as ZONE_DEVICE memory, which
can then be used as a new backend allocator to guest_memfd.

I like the private node idea a lot, but for guest memory, you often
don't want the buddy allocator involved, like you mentioned.

I think there's room for both. Like I mentioned in my previous
message, if guest_memfd moves to a model where there can be registered
backend allocators, both could be used. E.g. a ZONE_DEVICE allocator
which hands out 1G, HVO-ed pages, and a private node allocator with
buddy and LRU functionality (which you may need if you're running
memory overcommitted VMs).

- Frank
