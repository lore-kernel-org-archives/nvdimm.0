Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586665;
	b=mGQmaZITmROSv29qzRnM6EaRG95sEuBeTiLM2fSJqp5skyfmcLLrK43C55qKXWvqtopm
	 R+eNZ+BuBxVeynViZcDJocS5DMCKCkZ+MSgP0gG3b8nuUx58Cwq9MAT2/6qOqpuSVWc/L
	 Kj8BXds5FRE9yGwvt8PPct9zKKFp+x6wMkjrugwA1HSI8dQseFbzNrTGUZi2WIFi5ZLoy
	 D8Bw3vlPUwZFUymiPH2hUiIANz6bsmdj20c4c8qeTqZXVB9VUrEi01uWcmpZJFRQYpL56
	 +pNpKL5QxUSsoD0CKNUjdQYITnZoXBLArsLZuXCumKc71wk6rUbB46J72dZQKnLwjDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586665;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=07DDAqi5jXuAZ5tD6WNu4TNE10HQBGSmuS9KSWqF5f0=;
	b=OSbOlo8o8M+/uncTHtjdRz9P0gXhWW4u3g14Ao0HQHjp69X+UuyhsTd7xRnRB2d+nd/z
	 OKyKVsvLR1KY4+obh2KWGSNZ7taafVIg30johIjtqwLICeJoYAx99ELNFF1AFvqVCTA1l
	 uG7t3buBNqM6k67R3PrrRdWKFk4RsyVO3H86A5GsFEFfkZVeHgGHVe9A2FtUEFmS7aP5n
	 5Gi8Lj9ZvNYysLk2v7sdmXlN8SzkUJwgaecpLnTXX2s7Dgy0239zq7mVQevfNqavh5xEG
	 NJc2116Rd+EJhnQiyvtedcbZ9WDE44p5ZfNnM0qfS2Axk3M15ePrc+aMTiv6PLNTavw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UP3iRfnN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5722606B2FE
	for <nvdimm@lists.linux.dev>; Fri, 13 Nov 2026 16:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UP3iRfnN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9448E1F000C6
	for <nvdimm@lists.linux.dev>; Fri, 13 Nov 2026 16:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794586665;
	bh=07DDAqi5jXuAZ5tD6WNu4TNE10HQBGSmuS9KSWqF5f0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UP3iRfnNQrQGSiNIp6w+6flT9KSUoUMKC0Z5owz+KWHvq+o7kwFCw34OanpEGcufS
	 LhCj1yLWeHggKugNkQGiKAEqgG3h52h4cHDaIuqQn9Zfq9r7r6LPTR5vzjPtl4B2QA
	 BelwHsJJJbcQu9eYuAP5LkLrOyIRJnRmAo2xCJSjQxZ8SW3PESdWCKHc4Yepar1ujo
	 YP5GQo80I63bHz3Sq7um7txMqk6jCOesu8ZnB+tz23IodrTiUk4qPBRCzgPztImjAe
	 EpUZljGI+IJgOxbRNxTbrkbWoFp/e9pPPZDVrWhFTI/h+yKDmPQTFXvMvI76csYJnp
	 uefCeo9JPBSRQ==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3adfe77d336so16675741fa.1
        for <nvdimm@lists.linux.dev>; Fri, 13 Nov 2026 08:17:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEjWcZG1G8sbpntpyc4WGv7aLos8MIazmnrXq00dpl8f8+xr7Cv7v4BGiHwRCLEEG0f863c7Ws=@lists.linux.dev
X-Gm-Message-State: APuU4Z9UEmIgGHyiHa0/UDK6DK2RqpqLdxA1u1kBPzHTWk50qbpDoWLN
	DlUFP0WPL/GPXUTruJ3ubWYIWDDTACDB4FsCEghwHAvsCibztGMTQ5/TYVB8RgGLJrAKhz6UrhH
	+91sSn03vVPynF+hGV61D+R2LqoDU/H8=
X-Received: by 2002:a05:651c:41d1:b0:3ab:1207:bd2f with SMTP id
 38308e7fff4ca-3ae2b4bad8cmr14071971fa.11.1794586663709; Fri, 13 Nov 2026
 08:17:43 -0800 (PST)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <cover.1794567577.git.ukleinek@kernel.org>
In-Reply-To: <cover.1794567577.git.ukleinek@kernel.org>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Fri, 13 Nov 2026 17:17:30 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0jC5YXsLgB6Qd55KNCU0oCsN86X5WpRfL+Ycz0MJ8vGqA@mail.gmail.com>
X-Gm-Features: AclHuK8x25sOZXVMSbQCD89ASNTaRnpnKVCTik8ql8SNDsY_N4yuXW7y6aXTE5U
Message-ID: <CAJZ5v0jC5YXsLgB6Qd55KNCU0oCsN86X5WpRfL+Ycz0MJ8vGqA@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] ACPI: Use named initializers for acpi_device_id arrays
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@kernel.org>, 
	Len Brown <lenb@kernel.org>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Hanjun Guo <guohanjun@huawei.com>, Sudeep Holla <sudeep.holla@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Zhang Rui <rui.zhang@intel.com>, 
	"Mario Limonciello (AMD)" <superm1@kernel.org>, Saranya Gopal <saranya.gopal@intel.com>, 
	Gergo Koteles <soyer@irl.hu>, Jakob Riemenschneider <riemenschneiderjakob@gmail.com>, 
	Yauhen Kharuzhy <jekhor@gmail.com>, Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, nvdimm@lists.linux.dev, 
	linux-pci@vger.kernel.org, Kai-Heng Feng <kaihengf@nvidia.com>, 
	Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Shuai Xue <xueshuai@linux.alibaba.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Chu Guangqing <chuguangqing@inspur.com>, Andy Shevchenko <andy@kernel.org>, 
	Mika Westerberg <westeri@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13, 2026 at 12:14=E2=80=AFPM Uwe Kleine-K=C3=B6nig (The Capable=
 Hub)
<u.kleine-koenig@baylibre.com> wrote:
>
> From: Uwe Kleine-K=C3=B6nig <ukleinek@kernel.org>
>
> Hello,
>
> this series is about preparing drivers/acpi for a change to struct
> acpi_device_id. The idea is to replace .driver_data by an anonymous
> union, see
> https://lore.kernel.org/all/cover.1780048925.git.u.kleine-koenig@baylibre=
.com/
> for more details. (The linked example is about platform_device_id, I
> intend to apply it acpi_device_id and several others, too.)
>
> Before this union can be added, all initializers must use named
> initializers (C99 calls them designated initializers), which IMHO is a
> nice cleanup that can stand for itself as it makes the code easier to
> read.
>
> Pawel sent a similar series earlier, find it at
> https://lore.kernel.org/all/20260727-acpi-refactor-v1-0-ff900aa326ee@theg=
oodpenguin.co.uk/.
> Compared to that the patch splitting is done differently and the base
> here is newer.
>
> I checked for the other *_device_id and for these there is nothing to do
> below drivers/acpi because the few instances already use named
> initializers.
>
> The last patch in this series is just some cosmetic to align the coding
> style. If you consider it churn, just drop it.
>
> It would be great to get this series in soon, as keeping it up to date
> for a later resend is an annoying effort. Thanks for your cooperation.
>
> Best regards
> Uwe
>
> Uwe Kleine-K=C3=B6nig (The Capable Hub) (4):
>   ACPI: Unify acpi_device_id list terminators
>   ACPI: Drop unused .driver_data initializers in acpi_device_id arrays
>   ACPI: Use named initializers for acpi_device_id arrays
>   ACPI: Unify *_device_id list terminators

All patches applied as 7.5 material, thanks!
