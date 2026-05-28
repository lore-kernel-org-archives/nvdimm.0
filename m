Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF3D405C33
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 19:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779997471; cv=pass; b=OTH5+wo8AzahVnLBeHVxFwrTiPbS6qSLU/eVte76v1af2UH/tNgDXb1JyfT0QvEyJV18rzYPvbMonCEpY+Ib63v3Z9RE8UYM0Hza9J9z9F9dm2rb0Z+oDrpLnWhHgqDKujGXqaqHPc5rpvr4OTk6SmvDBFl++Zbi4WUjLkmOrmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779997471; c=relaxed/simple;
	bh=PggOqUDZGTqaCUwLJ5yG3wgs9SWaOxkXoLqlLnJNbms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cl5bYvoXW5TFieToQaCgs7OEwcWslf/r3+krXt4TQMuHr5JLqXe2CHp4FY8fXXUodBGuelsCNlGjjtk1H+x33P4YZm42AgsZGi2sxlLwFTlYHE4vA+ua8GMEyNQURQFvTIMEbyzY2youMxiDLaOgbFPbStp+LAN8u1IGNIhdV1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nkDW9wwY; arc=pass smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nkDW9wwY"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b46da8c48eso2695ad.1
        for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 12:44:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779997468; cv=none;
        d=google.com; s=arc-20240605;
        b=YUiB6vivKm1AKZkw7+3MJjZCE6WNditkh4RpCmQlOyWqzCYoFdMmZNUGOAwFsXg+rV
         j/Kozy7ZH/tqj2tD91gUs2ldiuung2negvkwJulub8eytx0Qxh37szGXt9ECjZ8btojI
         MzNiVgu3RAB4NQVys1RrZkraMaXZEdrmyGmfrmWTsdVR/+lfH44au2E4WreCy3ZGrX1r
         9obLkjh+1+jU0f1o6cd8P5eaApAFon03DrNfcsVL3N6/moNvzR+UWyEelAIE4gvRXpti
         MDr5Ia/7k7w7gVGwzrEyrNbygaEtm1JfZay2/c9xRPcCfzFuJLkbILY3fAhn6qup7vyV
         zsBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8IynHu/DX5NF0G96SeXwK1qnUut5hZzt9g6fKpDU65E=;
        fh=Fn65Ezqv3Rw9sbRvycsU3n/+Lr3wi0WLN3b9fPud+WU=;
        b=kSMw2c9IY/bQfX/jJ3+0ldCVggTqDLjEr8FsLss61YhYji7R/rDkh/Te/wmFaA1Ph/
         taGjGDv+IUiZBi9wmZZLQo8waqKPpKoWLR+feqbh31Dsb/b2770iZRmHZ0HqR7dokwiN
         SkvZawFLJ60z0A9xFhyCeU8WwUGUkFFTAet6uhm5O8lxVMGxLYQagRI+tURQam8vet1t
         rEb6/o1L13lDeECA+yirLVs4GWXc+HOipJ/qRv8S4e9O6Dwx7p3WnjXsiEL7MkUjGwbq
         P+8DtKATD0dSkea3cniyvUlXH4Ms7CvmiZyjukdci4GUNyM5uBGdhkVRyQjPjU53DBsh
         4EbA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779997468; x=1780602268; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8IynHu/DX5NF0G96SeXwK1qnUut5hZzt9g6fKpDU65E=;
        b=nkDW9wwYj55lL7hMzW5T5lMr679Bx6AyU6aGHx5ZxsJg85YBzYSUUSkRWaFKPDhqdl
         8C3s5HDzDMDtOVOJFBh1sPNVVHhLj84RbsS3kCCJLz1GuuNCSkhil1FDoY99NYJ0UoLy
         Iyqqk9fnq6Bwx1euzUhv0DC2OcpDCmdNjBKmnSLI2TDe1hyiq8K6pxSIDTxqmeA7poHi
         jG8MC69J/qZERvCs8Y2o8EdzfNM16aST6Z2xeg92eG1WefKNrhY+ewWDqNjOeXQJ8f0P
         cIExQYFtb+VBtM31nrDjK2goKIDEKpprsjA3OMk80GauZXpjV8UKm1oxF91busEygM6Z
         DINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779997468; x=1780602268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8IynHu/DX5NF0G96SeXwK1qnUut5hZzt9g6fKpDU65E=;
        b=eO+cn442CnsZm71Hs01aCO88OlyleepFloZwKQ7s8+4SDOoNnliiEWp1qdllssnSub
         KfnNn9OU5P11yeNKkhm7S//Xn1DK3mRthuEzKr3GmzQQxGdudCAWHk3vt/RnLsY1ZXLx
         7thPIzc08INsjvqdOTe3uidLQacatu0obG3v/9CGifqq06o5hiDHSFKRfS4GDfYJc8Vq
         TarkwnH6kgRuJ15bAiIlp7d3n5sxYS14uVUpbftu2cCbmz7Jm7OL5y8bqAc3FrW7SD0E
         CEtOAAwJWwYyHqeUAfMWGWhhR1uXQZJruLU1oaWNRCuLDlHpDubYZyB0CYBMl3ALo6fK
         JQmw==
X-Forwarded-Encrypted: i=1; AFNElJ/QYKf17fnok+jAk2bl1ci0CqmMQf1haV4vOqC3E2N7XA6qvtbReXeS2ErOniII/G/GpROEhrY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzT2wTK1uUajZcmTWwSD7nQgoVYT4p6XMcgWkkYY4hLd2yvXqs0
	3lYMoYpBBOuSn8V4KT8GHrcrL443kqfyI2JlVJr0luINrmMJ55rynw3e0l1SJjeVHWxK7NyVkb7
	eyWacRrNLA1E7KrsDTyZewT5F5LQR70eVENFl+ka3
X-Gm-Gg: Acq92OEKhMp6hJIQtLVXWhmDHLE67w3j8GK2VrsUPj5qEV9eCbTRfPTx83QyZrAPko7
	gXTOeyFZrMHFqBORL0hY1yWvYCFdvW6i+9d7LjdSYvPZacg4sBNf9vcWIUYkZwcNDsiVd+kSOQS
	+H78gDJkKT4ogQnkYkxLkd4B5CwzUt3vM4yLgDKuLJldHZOPMiUe+rgcCMcX9GZYVAGMY/308CQ
	awBTVtZSDA7KDyrsZx36hCIYVc+S452O5FZePXezds8MKUFtsONt/ltakealvnb13d6M65qBsrH
	ZF55JpMzvkGYHfaIBj8=
X-Received: by 2002:a17:902:f64b:b0:2bd:3bfd:74f1 with SMTP id
 d9443c01a7336-2bf1fb9d40amr92235ad.2.1779997467341; Thu, 28 May 2026 12:44:27
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260528183625.870813-1-ynorov@nvidia.com> <20260528121806.2b54606ba6e42f7f371d95c3@linux-foundation.org>
 <ahiW5LKLiPMC6il_@yury> <20260528122903.cf74cf905418ab2d144607c3@linux-foundation.org>
 <ahiYUr0dO_dhOHTU@yury>
In-Reply-To: <ahiYUr0dO_dhOHTU@yury>
From: Ian Rogers <irogers@google.com>
Date: Thu, 28 May 2026 12:44:15 -0700
X-Gm-Features: AVHnY4KU3_bl6PIogc_loULa1uZ5IugP9iETmiYVnKICvK-frgUxDB4nRARXI20
Message-ID: <CAP-5=fXXg+PqH7EZ8X599CKYFWCwQgyH2H-4-+5M3_b9w_dTNw@mail.gmail.com>
Subject: Re: [PATCH 00/16] lib/cpumask: get rid of cpumap_print_to_pagebuf()
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Russell King <linux@armlinux.org.uk>, Frank Li <Frank.Li@nxp.com>, 
	Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix Kernel Team <kernel@pengutronix.de>, 
	Fabio Estevam <festevam@gmail.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Danilo Krummrich <dakr@kernel.org>, 
	Chanwoo Choi <cw00.choi@samsung.com>, MyungJoo Ham <myungjoo.ham@samsung.com>, 
	Kyungmin Park <kyungmin.park@samsung.com>, Heiko Stuebner <heiko@sntech.de>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>, 
	Moritz Fischer <mdf@kernel.org>, Yicong Yang <yangyicong@hisilicon.com>, 
	Jonathan Cameron <jic23@kernel.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Shuai Xue <xueshuai@linux.alibaba.com>, Will Deacon <will@kernel.org>, 
	Jiucheng Xu <jiucheng.xu@amlogic.com>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Kevin Hilman <khilman@baylibre.com>, Jerome Brunet <jbrunet@baylibre.com>, 
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>, Robin Murphy <robin.murphy@arm.com>, 
	Jing Zhang <renyu.zj@linux.alibaba.com>, Xu Yang <xu.yang_2@nxp.com>, 
	Linu Cherian <lcherian@marvell.com>, Gowthami Thiagarajan <gthiagarajan@marvell.com>, 
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>, Khuong Dinh <khuong@os.amperecomputing.com>, 
	Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
	Lukasz Luba <lukasz.luba@arm.com>, Yury Norov <yury.norov@gmail.com>, Kees Cook <kees@kernel.org>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Aboorva Devarajan <aboorvad@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Ilkka Koskinen <ilkka@os.amperecomputing.com>, Besar Wicaksono <bwicaksono@nvidia.com>, 
	Ma Ke <make24@iscas.ac.cn>, Chengwen Feng <fengchengwen@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-perf-users@vger.kernel.org, linux-acpi@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-fpga@vger.kernel.org, 
	linux-rdma@vger.kernel.org, nvdimm@lists.linux.dev, linux-pci@vger.kernel.org, 
	linux-amlogic@lists.infradead.org, linux-cxl@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2026 at 12:32=E2=80=AFPM Yury Norov <ynorov@nvidia.com> wro=
te:
>
> On Thu, May 28, 2026 at 12:29:03PM -0700, Andrew Morton wrote:
> > On Thu, 28 May 2026 15:26:28 -0400 Yury Norov <ynorov@nvidia.com> wrote=
:
> >
> > > On Thu, May 28, 2026 at 12:18:06PM -0700, Andrew Morton wrote:
> > > > On Thu, 28 May 2026 14:36:07 -0400 Yury Norov <ynorov@nvidia.com> w=
rote:
> > > >
> > > > > cpumap_print_to_pagebuf() is the equivalent for the "&*pb[l]" not=
ation
> > > > > in printk-like functions. In some cases, it makes people to creat=
e
> > > > > temporary buffers for the printed cpumasks, where it can be avoid=
ed.
> > > > >
> > > > > Get rid of it in a favor of more standard printing API.
> > > > >
> > > > > Each patch, except for the last one, is independent and may be mo=
ved with
> > > > > the corresponding subsystem. Or I can take it in bitmap-for-next,=
 at
> > > > > maintainers' discretion.
> > > > >
> > > > > On top of bitmap-for-next.
> > > >
> > > > Sashiko doesn't attempt bitmap-for-next, so it couldn't apply this =
series.
> > > >   https://sashiko.dev/#/patchset/20260528183625.870813-1-ynorov@nvi=
dia.com
> > >
> > > OK... What should I do about that?
> >
> > Rebase onto something which Sashiko *does* attempt.  Mainline, a few
> > mm.git branches.  Maybe linux-next.
>
> Is Sashiko a new mandatory requirement now? Documentation doesn't even
> mention the bot.
>
> > Roman, is there a list of trees/branches which Sashiko tries to apply
> > series to?
>
> Hi Roman,
>
> Can you add bitmap-for-next in the list?

Fwiw, you can see the list of branches attempted and the SHA they are
at in the Baseline drop down:

Baseline Status Log
tip/x86/core (0f61b1860cc3f52aef9036d7235ed1f017632193) Failed View Log
powerpc/HEAD (6916d5703ddf9a38f1f6c2cc793381a24ee914c6) Failed View Log
chanwoo/HEAD (7fd2df204f342fc17d1a0bfcd474b24232fb0f32) Failed View Log
linux-arm/HEAD (dd6c438c3e64a5ff0b5d7e78f7f9be547803ef1b) Failed View Log
linux-pm/HEAD (e7ae89a0c97ce2b68b0983cd01eda67cf373517d) Failed View Log
linux-fpga/HEAD Failed View Log
pci/HEAD (254f49634ee16a731174d2ae34bc50bd5f45e731) Failed View Log
linux-pm/thermal (21c315342b81526874acfa311f11b3f72bed4e14) Failed View Log
rdma/HEAD (67464f388d52ec172be62c99fc43697437ffa384) Failed View Log
linux-next/HEAD (f7af91adc230aa99e23330ecf85bc9badd9780ad) Failed View Log
HEAD (917719c412c48687d4a176965d1fa35320ec457c) Failed View Log

Thanks,
Ian
