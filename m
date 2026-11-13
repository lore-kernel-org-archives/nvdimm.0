Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794602082;
	b=AroG8cdyNglTRrMwv6HgtH9Mso5H1PWrAL1uALBCzCaLYuKDL0EZOy9QCsGjSCJQDtj0
	 dl1ewTLQKqnOUw5FO5bRkr6OukZsw8dJjy42rrXHwhZJTn9vD2M6irmrmiS5wkQMNtS12
	 XA+b3eTjN3N85MZzpFg6dvveYLPASTNlBnVV0ShqPC3mR8IGJ48t3CG2t89+/vySZ3bOj
	 CYPD9zv2H0JXiFnagQfKdzS36iShw/fPR569HjnG83X/DgpH3D0VWLRWWFLOVp8MmMRqF
	 CRMijzg6Ij+Rm4S4B9z0vQUPUx2R9roc3vSLWBuatUlJQeNWiKi3Ld+bbLESsf8RQiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794602082;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=xA/dHrB8DVHvhn8WCh7VdIDLIPRiACwfBEGFOII6u8o=;
	b=dMQXjn33r16aAhIMwun1eJCyMs11vcz3+uNBijn8uJ/ngob+MGeyjaMJ64fdaWoQfanl
	 v+5g/KHfqGQ6t8gpIvfw51Kr5smHffhhsprjQoDPZR0ceM5YgEjoh4G53LIlcaJZjIh9y
	 x76TldkQVwIKO1ttE4RBx6IVOgAS4uG3bPTWe4TnRNmkxZaGSB6AGWWIz732gyzuhGshk
	 OvT8h08+Cmd9ym1n0+JX6lonrSaxSnAQWdW+lmJnZ5usw2LfsoJlHDrSe3WDuiBNmkbyo
	 Bo4KGBkXLzP8Wp476h9yudXX2ZOE6/e9HOBGHhdLXVIBaQ1lO9wjDtbHeeX2+pwsF4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UV8SW5bu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A05A606A327
	for <nvdimm@lists.linux.dev>; Fri, 13 Nov 2026 20:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UV8SW5bu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC46C1F000C7
	for <nvdimm@lists.linux.dev>; Fri, 13 Nov 2026 20:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794602082;
	bh=xA/dHrB8DVHvhn8WCh7VdIDLIPRiACwfBEGFOII6u8o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UV8SW5busPS8VmXNfVtCA8Gy0bDmDzqHePhNmga+YXjs6tdgK4mMuY3lJA6UVrv6F
	 Og18/irl95YcHnECYzmIN6RGkJwoBP+CqhKwq/3OI0ttro56XVwFhud+FCAPccT+38
	 RM4VYeTnymaDrrkZRiYTT9YfbVr+rSmYkya8zngTI9Qlc2iIKOdx4TnNilsvSnrInK
	 xYftri6PomOsPSDloIpP4Vw42Eey7oq4zMBD4Vcy/RcHHRt6n7P0/ebU/1qpMjYds9
	 DZVon4ggKltPGFINtBlvW6Hgwv3MnyU6UQSbe4UTPwrmbU86XyQ9pOhFTZT4JP5NoA
	 pd9vv+I5nNgiQ==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3accd1ff4c3so17669511fa.0
        for <nvdimm@lists.linux.dev>; Fri, 13 Nov 2026 12:34:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErErbfaQu0ZJV2URYlPZcLcnRnXWthb7PuM9/oMqVH2/wPN+H7Rz5YnUPdRInNtLa2v+/tp0k5Y=@lists.linux.dev
X-Gm-Message-State: APuU4Z+geI8Z7a39c2B+7U20NVReyitTa2qwhQ4RQQuFKXfvz1eo2EyX
	NcUxW7bbvsIYEhMU83l+N8nGWnPgXoxkDtjdqRBGU/8foByNtB/TEnE8OMN2V3as6I4ZrB4xdre
	Bk9HzAv++b26ZChzQbiY/VQwgVKmo5wI=
X-Received: by 2002:a2e:bea8:0:b0:3ae:25c9:f5d1 with SMTP id
 38308e7fff4ca-3ae2b4cb695mr13163291fa.11.1794602079970; Fri, 13 Nov 2026
 12:34:39 -0800 (PST)
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
 <avdryC3GOqVNVF8s@monoceros>
In-Reply-To: <avdryC3GOqVNVF8s@monoceros>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Fri, 13 Nov 2026 21:34:26 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0jxB4-R2K6iQEh5BVeF1pDXFGn81jkXFCTMJLBAXoL8rA@mail.gmail.com>
X-Gm-Features: AclHuK98RV8mUx3a_eF9a_B1pqyxZw7Jy48hGkbo4K83RPSBSBvPbkBZkEPiro0
Message-ID: <CAJZ5v0jxB4-R2K6iQEh5BVeF1pDXFGn81jkXFCTMJLBAXoL8rA@mail.gmail.com>
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

On Fri, Nov 13, 2026 at 9:04=E2=80=AFPM Uwe Kleine-K=C3=B6nig (The Capable =
Hub)
<u.kleine-koenig@baylibre.com> wrote:
>
> On Fri, Nov 13, 2026 at 05:17:30PM +0100, Rafael J. Wysocki (Intel) wrote=
:
> > On Fri, Nov 13, 2026 at 12:14=E2=80=AFPM Uwe Kleine-K=C3=B6nig (The Cap=
able Hub)
> > <u.kleine-koenig@baylibre.com> wrote:
> > >
> > > From: Uwe Kleine-K=C3=B6nig <ukleinek@kernel.org>
> > >
> > > Hello,
> > >
> > > this series is about preparing drivers/acpi for a change to struct
> > > acpi_device_id. The idea is to replace .driver_data by an anonymous
> > > union, see
> > > https://lore.kernel.org/all/cover.1780048925.git.u.kleine-koenig@bayl=
ibre.com/
> > > for more details. (The linked example is about platform_device_id, I
> > > intend to apply it acpi_device_id and several others, too.)
> > >
> > > Before this union can be added, all initializers must use named
> > > initializers (C99 calls them designated initializers), which IMHO is =
a
> > > nice cleanup that can stand for itself as it makes the code easier to
> > > read.
> > >
> > > Pawel sent a similar series earlier, find it at
> > > https://lore.kernel.org/all/20260727-acpi-refactor-v1-0-ff900aa326ee@=
thegoodpenguin.co.uk/.
> > > Compared to that the patch splitting is done differently and the base
> > > here is newer.
> > >
> > > I checked for the other *_device_id and for these there is nothing to=
 do
> > > below drivers/acpi because the few instances already use named
> > > initializers.
> > >
> > > The last patch in this series is just some cosmetic to align the codi=
ng
> > > style. If you consider it churn, just drop it.
> > >
> > > It would be great to get this series in soon, as keeping it up to dat=
e
> > > for a later resend is an annoying effort. Thanks for your cooperation=
.
> > >
> > > Best regards
> > > Uwe
> > >
> > > Uwe Kleine-K=C3=B6nig (The Capable Hub) (4):
> > >   ACPI: Unify acpi_device_id list terminators
> > >   ACPI: Drop unused .driver_data initializers in acpi_device_id array=
s
> > >   ACPI: Use named initializers for acpi_device_id arrays
> > >   ACPI: Unify *_device_id list terminators
> >
> > All patches applied as 7.5 material, thanks!
>
> That's great, thank you.
>
> I fatfingered my author address in patch 2, so if someone wails that the
> author S-o-b is missing and your tree isn't set in stone yet, something l=
ike:
>
>         git filter-branch -f --env-filter 'if test "$GIT_AUTHOR_NAME" =3D=
 "Uwe Kleine-K=C3=B6nig (The Capable Hub)"; then GIT_AUTHOR_EMAIL=3Du.klein=
e-koenig@baylibre.com; fi' next/master..
>
> should fix it. Sorry!

Thanks for the heads-up, I fixed it up.
