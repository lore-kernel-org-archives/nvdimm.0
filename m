Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4FC2D29AA
	for <nvdimm@lists.linux.dev>; Thu, 11 Dec 2025 19:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765480289; cv=none; b=BMRolLkcwAbh89kTqsRat4taxLwuPkqU2C6C1JZqSEUjNjzbA3KWTMcHpD7CbjWvMZuuagrB0Eu9JmZnkElbSGCbxc8fBntHDT8KB1oSangPCAVX6bTwjYFCCIpgZHwLYqynV2008SSZOdsMhqxSJB0M/+Fom2K/y0pU+s3IQO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765480289; c=relaxed/simple;
	bh=KMiBewgHctJLXHmyHW03C4RmwjOt6YS3yWi/cifLCIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NyzOnnqS5eqayw6D0xBxmVR7v4j1YQO8VC/9Oc8+zmdWmRkKcFWuaX5NkcxWw9eGe/fwIZY3tkRSt8zbdkv8eIBDisA1h6FPc4ZGjKTF9JqumNR4oyYY6VrKctBQ5aefCUDQRTlE96dbV45ZxNkEhE5q5uMrEghgZw21+cSmHs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l7AfB8pU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l7AfB8pU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB83C2BCAF
	for <nvdimm@lists.linux.dev>; Thu, 11 Dec 2025 19:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765480289;
	bh=KMiBewgHctJLXHmyHW03C4RmwjOt6YS3yWi/cifLCIw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=l7AfB8pUAG8ihURo0HitO+yozQlQlQwsijnmrvns5NYo6H2kbyAyDxZCpZdI491cQ
	 oJDs3xjb5KwtdPC+smTBdCMk9xKGbxXqXaKNyxAEMYt3g5WZNb3uAQLehqgoZIBW8s
	 dfEgUmgtUu/nJaCkW4a4qozEuEMSRkV8hBxD+avqqrEJMBs7OTJefAWHBImxqQ6OBz
	 m571Ec3NBVQoR0zQkDhhdw/D4zkpUi23c/46k+IUbGZ6x1Wmv3ESeRrSYOOxI3bBRV
	 YGM6tSedvDZu0yqtuTtfC47iKi002KabeeLA36zCZ94kEGQOL5OtTKHlxB73qPcCiY
	 1rF4y0CZ82fcw==
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7c7660192b0so287035a34.0
        for <nvdimm@lists.linux.dev>; Thu, 11 Dec 2025 11:11:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUa4ew36ENNVGlsz/banQ4LREGaOVTT3K53zPX6OcIfqJV70yCbPqVn9FpM0aZZUwWFV4nD/Qs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLp9g2kOFTS1CrGR+LESYeDV2mObQklfIQEwFZzmqehzmZhSvK
	vdJG4uJzsxKq1v0JXzslhxLuOU6bp4zvAgJKnktiKZbAPvtmCkpGHhjorhrL3uHGD/QvsdJ7qE0
	SwObsHdDcaOOsy0TSQS+4xKHjgyGHX2c=
X-Google-Smtp-Source: AGHT+IE4gT4K/DVbShJR5+FOBwlkLAtnvHuJqYAPLnPHRe0a8K7KDPNSBmuIIVGkAIkSjV/ndG4kAnPsIfZy1/8nUco=
X-Received: by 2002:a05:6820:4cc1:b0:659:8350:61b6 with SMTP id
 006d021491bc7-65b2abc0bb7mr4041632eaf.6.1765480288171; Thu, 11 Dec 2025
 11:11:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <5066996.31r3eYUQgx@rafael.j.wysocki> <2028345.PYKUYFuaPT@rafael.j.wysocki>
 <aTsQKAJF5hpOixIR@aschofie-mobl2.lan>
In-Reply-To: <aTsQKAJF5hpOixIR@aschofie-mobl2.lan>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 11 Dec 2025 20:11:15 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0hWo=75tVGVZa5ARC3Nwtb5R_DR6s-V1X_e79S4E2RucQ@mail.gmail.com>
X-Gm-Features: AQt7F2rXNnsgFmv31s6uUV-q-25TB0-39LelfYxc82xAQH4IX0mBpDelNn3uQ_U
Message-ID: <CAJZ5v0hWo=75tVGVZa5ARC3Nwtb5R_DR6s-V1X_e79S4E2RucQ@mail.gmail.com>
Subject: Re: [RFT][PATCH v1 6/6] ACPI: NFIT: core: Convert the driver to a
 platform one
To: Alison Schofield <alison.schofield@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Linux PM <linux-pm@vger.kernel.org>, 
	Armin Wolf <w_armin@gmx.de>, Hans de Goede <hansg@kernel.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2025 at 7:40=E2=80=AFPM Alison Schofield
<alison.schofield@intel.com> wrote:
>
> On Thu, Dec 11, 2025 at 03:22:00PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > While binding drivers directly to struct acpi_device objects allows
> > basic functionality to be provided, at least in the majority of cases,
> > there are some problems with it, related to general consistency, sysfs
> > layout, power management operation ordering, and code cleanliness.
> >
> > Overall, it is better to bind drivers to platform devices than to their
> > ACPI companions, so convert the ACPI NFIT core driver to a platform one=
.
> >
> > While this is not expected to alter functionality, it changes sysfs
> > layout and so it will be visible to user space.
>
> Changes sysfs layout? That means it changes sysfs paths?
> Does it change paths defined in Documentation/ABI/testing/sysfs "What:"

No, it doesn't AFAICS.

It changes things like /sys/bus/platform/drivers/ for instance and the like=
.
