Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794849404;
	b=G2a0EiAXH8NXhlNpJK81XP1NeLdAUV73JwWdHtO0YiXt0V54UKGk/TYx5SsFcvg7jto2
	 ZH60bkNEHTwgYXk51BxqCWCGZbwp5MFkjqY4WUAT4ED9x/PKZJq6Nk5ObM7tIeoxhk6ez
	 bTxqXWE4jzT6myz2zqgABZt87IJ3zpKeXRsARUR6mBVphuhgQXpoLhtb6wjPOfwz/UM1D
	 ue+PemQdkgFKjN7BVQe5TvQla4yU6z3sfAC5vrxLjoT4FyjQwf/5gBro18Ja6RbGaQb46
	 nxthb2xuzUybrxdzQ12noWi81qkmRZr73uX2SdYc8ZUgB0lRHsPmE7Xp5lwYog/b9Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794849404;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=mSvoaqmjg32ifr2UgUXPIKGNa+qRJ8bbbR9fyHQLo9g=;
	b=Ky0Bb8OlV58VYUjFRPV6ZvgvUbBdnMwOki2IBVeSrap4YGTv0Q8esD9DXxX0VmO3qlAV
	 /jERDqabs6WkYse38xZ06A/47LfqonlwLIs6CMgCESYK6s4W9PC7SZwHlnzIbiph33iOd
	 MnYSGRN7KROviQ3lu505M8UDeercmuVR79aqcs7OTa+W8goHbDAKoEOQeAx7U8JD1RMDy
	 1LDULQjOczU5eQ4fLNhxEjLA7Zg29LiaAS0w8ATS5aq0WOhEL7DMMQ6YosEM2AsNokIrn
	 zsLY6rv7M1MxTZC29qyS2FBYUsuAXaMvcwrqnctdIIZ3JWcdowvvdMtY1tLDDOZRhBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=baylibre.com;
	spf=pass smtp.mailfrom=baylibre.com;
	dkim=pass header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=E2n5PSRp;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0130F606A33E
	for <nvdimm@lists.linux.dev>; Mon, 16 Nov 2026 17:16:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0130F606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=E2n5PSRp
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a14so18672975e9.1
        for <nvdimm@lists.linux.dev>; Mon, 16 Nov 2026 09:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1794849401; x=1795454201; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mSvoaqmjg32ifr2UgUXPIKGNa+qRJ8bbbR9fyHQLo9g=;
        b=E2n5PSRpCBgRktk1cPbTD7XdAiCZCYJgSpY/8TwwaLudV42Pc3hiMZW35utXgrhilG
         CdVnkqEDBmAJr+A62uRBOCblri57osqld4EuxQMbpaHPAXI8UOmSe5qK3zmyRPOZLjA9
         hm+hQkr3C59iepp93HaLAdiyyEJzd0e4d2t9xjGyo9JYbmFYp7mLhOPAq1OhdswobTQd
         IMHm3TZRkaD3pC6VFtroc4zvKOUtzQNMnc7qRVfARVe1kodc2ZvB3E9tK+ChYMJbiBzL
         ZHaEuvyWOk+ImDGh0X4SPluxhxwsrJmD6tlk7JKA1BVyswwLkbktZzjKMmUFVJFlTNNQ
         Jw0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794849401; x=1795454201;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mSvoaqmjg32ifr2UgUXPIKGNa+qRJ8bbbR9fyHQLo9g=;
        b=dRJyvLmc1Ma9pe57rdeKWeIRgHlcs7WnKT17nf74hY1Nr8n/uIIoCl5NmJLGd5/hXV
         BJhwGjLpd1v8wo7VL+ecF7I7ZDgHEZ+AARQuYo2H4AM1sOIhXRa0F09S0u+hWK58795F
         QIm851/ieCrPzQvdNNUSCoScS8UwbLglqQ9NvTaTFX3GWqI3bvhe7iZkDB7rCwi0Fo0/
         a3fGZVpMkJ8Oc0tgTp8pcM53stIRPWVMRTw3tWaKHHsEGlz7wZr5T3Dk0VJvR6cMAvHB
         x34rRS10OpcYeC4LLe/BxLWj5K1X3pGbDS5dYut9QJC9FObW49PvslrTbAEvg1wnplRL
         3eQw==
X-Forwarded-Encrypted: i=1; AL+hErE+LxHKHkynpI5UaDWeObyldlSmhVRYNBhQQ1xRHN0V7olcDoG9LrZkGtRQduNlmNHmHtenCwo=@lists.linux.dev
X-Gm-Message-State: APuU4Z9qdo7VFMPXGS/rN+IeRWhykiM7oiVO8I80BoXNUEpT4KIULiBu
	HlDTixkMjuDX3j43qn2frUGKiE9+ajf413HRoaw7FvF3e265YYO4g4YTnqJyEis0Q8E=
X-Gm-Gg: AYBFou3Wj/Qir0DskVUPd8GO6bcTuTxpmENT30XI/fi8CAz6vbCv35xHVzNiDlsKVZL
	TvAA3T5SYTGQdVwQoAnQ3W2QAI6CGJLSCWL9hcCjos3LNCLBPNI+327EbdeW5Lq9avh/vOl2AuX
	q6XHxBPUuwTA5I1fri5303+f2KqHxblllrrWrjTAYU4JDQiqBR82Luiu44osy93SejKxz9p/aGU
	VW8rcGBXIIgbBR7OaYcNc1COmJ+wiOi1qaDH5k6IV3eBkLmphwLck0OTpyxuwGdUayinny2gH1Z
	qI+HxgEBbOCCXXz2Z3YxnDrQngbSI7gKvkAJ5e75e+d6YniqX1LN3oa9R95i0jtornpYQkW4AtQ
	eYuMua1FC+HA30XT9iAEPYeLfNRgKAJE1Oz2afAGDlSpOSXSHP80/ei/se1J+e26BMllyaummtX
	g/PweowdixaHSCUdDqlGqJCBJKeKOEyZ3kR7NfjhHfn/4YW2z/bh9pZsKjpuGpPdpZUDksg8Hkn
	FomLhyWH5KVfL6pE56mztyyGYDWyKPiM4J5JnO+2+ot9K0Xfzx5smlR9dJ7eaq/D+9dq+OIaP8+
	I35yD+eCvi868zYORHtjlBbr+lcjp0YhsQoDdVI7N7pbZ/PnO/xOW4yQTnD5+oPnBmifkmxkbXV
	DMQPbwHiif+GCmFVmEx97oAXjQAZqkmmlCaRcx2M=
X-Received: by 2002:a05:600c:3ba5:b0:4bb:741d:eba with SMTP id 5b1f17b1804b1-4bb741d1238mr63980765e9.13.1794849401463;
        Mon, 16 Nov 2026 09:16:41 -0800 (PST)
Received: from localhost (p200300f65f19a90439293c698a65b414.dip0.t-ipconnect.de. [2003:f6:5f19:a904:3929:3c69:8a65:b414])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-49c5fb58fefsm25945708f8f.26.2026.11.16.09.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 09:16:40 -0800 (PST)
Date: Mon, 16 Nov 2026 18:16:38 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
To: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Hanjun Guo <guohanjun@huawei.com>, Sudeep Holla <sudeep.holla@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Zhang Rui <rui.zhang@intel.com>, 
	"Mario Limonciello (AMD)" <superm1@kernel.org>, Saranya Gopal <saranya.gopal@intel.com>, 
	Gergo Koteles <soyer@irl.hu>, Jakob Riemenschneider <riemenschneiderjakob@gmail.com>, 
	Yauhen Kharuzhy <jekhor@gmail.com>, Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, nvdimm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Kai-Heng Feng <kaihengf@nvidia.com>, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Shuai Xue <xueshuai@linux.alibaba.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Chu Guangqing <chuguangqing@inspur.com>, Andy Shevchenko <andy@kernel.org>, 
	Mika Westerberg <westeri@kernel.org>
Subject: Re: [PATCH v1 0/4] ACPI: Use named initializers for acpi_device_id
 arrays
Message-ID: <avs5thXfoZA4TBnE@monoceros>
References: <cover.1794567577.git.ukleinek@kernel.org>
 <CAJZ5v0jC5YXsLgB6Qd55KNCU0oCsN86X5WpRfL+Ycz0MJ8vGqA@mail.gmail.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xs75une3ctdjt36i"
Content-Disposition: inline
In-Reply-To: <CAJZ5v0jC5YXsLgB6Qd55KNCU0oCsN86X5WpRfL+Ycz0MJ8vGqA@mail.gmail.com>


--xs75une3ctdjt36i
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v1 0/4] ACPI: Use named initializers for acpi_device_id
 arrays
MIME-Version: 1.0

Hey Rafael,

On Fri, Nov 13, 2026 at 05:17:30PM +0100, Rafael J. Wysocki (Intel) wrote:
> > Uwe Kleine-K=F6nig (The Capable Hub) (4):
> >   ACPI: Unify acpi_device_id list terminators
> >   ACPI: Drop unused .driver_data initializers in acpi_device_id arrays
> >   ACPI: Use named initializers for acpi_device_id arrays
> >   ACPI: Unify *_device_id list terminators
>=20
> All patches applied as 7.5 material, thanks!

While rebasing these patches (as part of my wip tree that contains a lot
more similar patches) to next-20261113 I hit some merge conflicts. If
you tell me where you applied it, I can take a look and provide my merge
conflict resolution to allow double checking.

Best regards
Uwe

--xs75une3ctdjt36i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmr7OnMACgkQj4D7WH0S
/k5UDgf/Zh/cCBQS3AfcJY+xVzINeExpvzUmIZMMajOqIRB1Ogb1iu0eC9qNdona
axu6POUJXrXH/4pRKQXevRF3+h/9JnryHBdTIe266MjPuRwUmMbGA8WFTkyAB4B1
QWyO8s+I+vnTdOB8Epy5gtqS4T4GHHGkl77vuo+C1qWDCVa9rLVrAvtFGSJ8ULGz
w1dFA50z67Fbkzs1CIqH/smn3i2pPtGjZvfJ3APm3MUbEXCY3U5vKugaE9w7fFF/
RnDbWck5jZ7cSr2Z4gmAk05o1kwfeDTGzRJ6/1zxIdAlPzXZFzMQWhDcgVE+3pQm
cX2okMKS7qwTP1K50XaZeXSwd0t3mA==
=+qin
-----END PGP SIGNATURE-----

--xs75une3ctdjt36i--
