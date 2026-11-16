Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794852963;
	b=47rPrs9mXbytBiQj/iz97QY8Z53GLakAr9mcGz1mLMqtZ/57JjjJPg7YyGvJz3Yzx5Zg
	 NAYys4ZCNA4C/4xFb/e5pIuch9Zr+CVFSQ1yKUK8+qxpRV0YEGeswMaymWJrcaAgLvwqh
	 IxsJqlLFN1ZBGewf8GKN6YkbDNUBx0HFc2NiH9MgBVDndYnBmGmPjPyZfNLDEOagnbmpr
	 mIUxVsyQTB/XcLAj0zL61iVsMJyvs9ep+GkgQ/7zqFaClUKAtCxv1ULX8LxZ6KKFUm4UD
	 s8M+k3+wsNNtsPvZIclKXHaOpHd+6mzptOwLHlbB94ZwSdreiq3rmrCIcYSCMOUNJWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794852963;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ZzX9V4TTBmSlkYz6J8Lbn80e+REH2S26Di72JYTGVqM=;
	b=CMFLgIci6X5HkZvH7weagAsxOvO7Vdc3gHRY1hcKwzKsDgUvTW8mik9ZHwhl16QZsU++
	 we4Fq1F/e+ZD3vc3yWcqWGllEYJan2C75Pt3YkC6hRxlx7V9VqriBthOxhNwxYcK4FBG3
	 fjp69w/sa9pIOFqfRFjAGNr4Wlmo050QUQOf3T5Mwgi38NmbLKI12+1fakASXmICv7Skn
	 T/XKgXN5Zmnt11hxhYywSmuYfa7rBIggUdjUdJbVhPpFXpXdf1znUGfZZvGWaH6WS1iVj
	 abl1g/eOOwfVrU+wjGPz1VGDFBa/8v/VC9bD5ZEGwEQZIfrItSYePM7rUhA61hArR2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mCzVDl+y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F38606A323
	for <nvdimm@lists.linux.dev>; Mon, 16 Nov 2026 18:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mCzVDl+y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0D31F000D2
	for <nvdimm@lists.linux.dev>; Mon, 16 Nov 2026 18:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794852963;
	bh=ZzX9V4TTBmSlkYz6J8Lbn80e+REH2S26Di72JYTGVqM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mCzVDl+yp3QvxGGoIjHphlloyP6gjkTnuxpM2RxkYOo/ep9guqhucHVwPPvPJGxNA
	 rtFCxx/KcWPxELoKUCqQmsifn4XZnuibROwGxzkD/eROMt7okJNbOUHiTSzIBS10BV
	 iuGOXWSM0bno7C9iqM5+X7rB12dJ0XEvDTdUkNPDfd1Bywm3i/KWbUz3xFxtgJwV0Z
	 NgBEGKNWYmWkeEf+0x6MLhZ1voYpMXemD8SmaBqjrLIHfzV62AEbTTrweiex8JfjNW
	 TTrx9UjJQhRWWpos6Di4eagD4qqGz66bOjSOLYQKSq/os5JQJki75W1b9OapwBZIsY
	 td6rcOdbZlyTw==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-3ae2ab35d82so31385781fa.0
        for <nvdimm@lists.linux.dev>; Mon, 16 Nov 2026 10:16:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFwi8qzGdeAtXLeLtNVgU3dvud3G3CHLXfXdZuV6+M/Ew7jTXBHAd9bpj9tUI/TqrPDBkekMks=@lists.linux.dev
X-Gm-Message-State: APuU4Z/SlCvIX5oGCa0GD9Z+a2yHLAm0I/g/AZAq9J666gK39rKOZfL0
	ywVbvYL/uJGhGgDlWLMhiPfPGVkuzZDvnbRdyCkHkK54JpxL956ClhQ9nfrpw52fHHR3i6MwBTC
	co5AZI9MAhwlH1Y9ctlu9SPe30PoeOrc=
X-Received: by 2002:a05:651c:e0a:b0:3ab:3bf3:1604 with SMTP id
 38308e7fff4ca-3ae2b522732mr39554201fa.26.1794852961071; Mon, 16 Nov 2026
 10:16:01 -0800 (PST)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <cover.1794567577.git.ukleinek@kernel.org> <CAJZ5v0jC5YXsLgB6Qd55KNCU0oCsN86X5WpRfL+Ycz0MJ8vGqA@mail.gmail.com>
 <avs5thXfoZA4TBnE@monoceros>
In-Reply-To: <avs5thXfoZA4TBnE@monoceros>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Mon, 16 Nov 2026 19:15:48 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0iSJVszOCLCuK+ifCzTgx1RgDAExaYUbij=jaWmaTsb8Q@mail.gmail.com>
X-Gm-Features: AclHuK94GxXVADZ_eYaxYKF2omkpVW60DdECEGw9yQWKt3TSZ2-Rx4HqR0isNuY
Message-ID: <CAJZ5v0iSJVszOCLCuK+ifCzTgx1RgDAExaYUbij=jaWmaTsb8Q@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] ACPI: Use named initializers for acpi_device_id arrays
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Hanjun Guo <guohanjun@huawei.com>, 
	Sudeep Holla <sudeep.holla@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Zhang Rui <rui.zhang@intel.com>, 
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

On Mon, Nov 16, 2026 at 6:16=E2=80=AFPM Uwe Kleine-K=C3=B6nig (The Capable =
Hub)
<u.kleine-koenig@baylibre.com> wrote:
>
> Hey Rafael,
>
> On Fri, Nov 13, 2026 at 05:17:30PM +0100, Rafael J. Wysocki (Intel) wrote=
:
> > > Uwe Kleine-K=C3=B6nig (The Capable Hub) (4):
> > >   ACPI: Unify acpi_device_id list terminators
> > >   ACPI: Drop unused .driver_data initializers in acpi_device_id array=
s
> > >   ACPI: Use named initializers for acpi_device_id arrays
> > >   ACPI: Unify *_device_id list terminators
> >
> > All patches applied as 7.5 material, thanks!
>
> While rebasing these patches (as part of my wip tree that contains a lot
> more similar patches) to next-20261113 I hit some merge conflicts. If
> you tell me where you applied it, I can take a look and provide my merge
> conflict resolution to allow double checking.

I've rebased a couple of patches on some material merged previously.

Please see

https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git/commit/=
?h=3Dlinux-next&id=3D58d4ba8979133c41cd491dff1dab40626daa924a
