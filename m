Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B28F1E767D
	for <nvdimm@lists.linux.dev>; Fri, 11 Oct 2024 02:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612561; cv=none; b=croC02w/o1NuAhvy/+iAa2q6jcMh6SGSA1ht+TTY+ju1HLPBg3Cuv48kBqieYB49xgaQ10e90Gl8cp/lU+QStK2RhiId8ZrJ04cCm+TGoIqoB+hDH0U5C2Te/67hVm/LRMrkFtyZ8Fh540jFYtO49FJvA4tN3Kk3Ezi5ZS/r0BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612561; c=relaxed/simple;
	bh=aI+kVo3JrrNJ7YGaRvYFfYl3G/dHWG/G4ayXbq9TxyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqOsac9DA5KDjqKUq0VYiNVHyVvkqn4lcTjUBFxfb8r0rfSiSd6j5o4LqOTdCWm8AqtYOFwpPx6QRUI1Qd8dRSPjXuATejOZm2DQ2ROaPvDN2UIKrYUvy66/L73l8acSyvMbYVo5lXtvxHQqx/XH6hir9zf1ldEFuMDtycP7ffc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VeoB20+1; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VeoB20+1"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2e2cc469c62so1121491a91.2
        for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 19:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728612560; x=1729217360; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HjWeD9HT47zkfpKbRTMi6no6+ST4z9rpRHbcw/ft7DA=;
        b=VeoB20+1wyjQMIjtn7hqK3QAh9SC/4ReUaL5pvts1alyd+tkWVqDpyPWjfv1nXmRD3
         mdmsTfNQDYiWI3a6xoNAGuABVabyyd4vDr+qAurvQYYmtMW/ZSr8jnIiK8taLPF4uNZT
         ou3QqyLGfzJ2sGAlzY/eKeE7VEOfgBVRvnK+OfuwKatMtI0okX9A6NBJOpFgNtyaMT9I
         GEC/GbdeyOWkUjCvc7UiIXmY4BXxBpt6z7xDTBC8uJAuRgyDWS5atwIebId15FsSvr6g
         mfVM6DRz724gMqaS9SS6ynUwRKE9mOgk+Ckji05g3uBKsFrJfS3+rn9HdI2utsLrvtTR
         1E9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612560; x=1729217360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HjWeD9HT47zkfpKbRTMi6no6+ST4z9rpRHbcw/ft7DA=;
        b=O4lheYxbcjAx4pI2BjbHx8IENHO+PBaCFOLievXWLDWVjl1ZJaZ8PvUyfBgGYxqC5P
         uO0i2XPWHuR8BSqLL1hbo9IcYg7hQRUlKof4plOOI4EcO22iDSUAR87isTcl8y2//1WA
         UaJjPHPVv7Jmhkruwlkqk+mYgyUBJu8oQ1gwDkxFuZaa+DjU9vZR/OvnoAVvG9YioZbk
         ZYtg/3NmScq8FDnnyMl9i4Z3Qd7JgACeCQ8/QJxrH/3eQh9jsTkLaKVs37Olfo+HIATu
         8t/p0GThZOAUfVgv7Cx8i2FgCQ8cV8KzmSs/YaZDiGgbXBs+hNI9gStkUr0IF43PbMHm
         7UwA==
X-Forwarded-Encrypted: i=1; AJvYcCUGHQOKY1CECKQ5qa535I1iWVkToiaZFkC6rMnhG222OxjTFBCV2R1jwRcut051o0GJk7WRORQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPrNWJs5qswL1JnbTqZKqvtbde2KbSU5wYX4NBlfw6s9iFEFiS
	MZrHtcZ2nZoNfCM4TqkV1xoNZOtJsFECR5POVgrcHYisilQV0Uh5M7/e3mIk
X-Google-Smtp-Source: AGHT+IGmMxiC+DaNWneEaWUXbx942+3srxh6SQiQYR1Tc2s2HP0uHw5IXb6QSGrhhTUBncneke8Rzw==
X-Received: by 2002:a17:90a:db15:b0:2e2:ba35:3574 with SMTP id 98e67ed59e1d1-2e2f0a7afecmr1668241a91.11.1728612559763;
        Thu, 10 Oct 2024 19:09:19 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e2d5df1ed0sm2122410a91.19.2024.10.10.19.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 19:09:19 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 3BB5C4374224; Fri, 11 Oct 2024 09:09:16 +0700 (WIB)
Date: Fri, 11 Oct 2024 09:09:15 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v4 02/28] printk: Add print format (%pra) for struct range
Message-ID: <ZwiIy-pIo_BPLtua@archie.me>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-2-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KmiAZmKUS8OFkhKJ"
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-2-c261ee6eeded@intel.com>


--KmiAZmKUS8OFkhKJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 07, 2024 at 06:16:08PM -0500, Ira Weiny wrote:
> +Struct Range
> +------------
> +
> +::
> +
> +	%pra    [range 0x0000000060000000-0x000000006fffffff]
> +	%pra    [range 0x0000000060000000]
> +
> +For printing struct range.  struct range holds an arbitrary range of u64
> +values.  If start is equal to end only 1 value is printed.

Do you mean printing only start value in start=3Dequal case?

Confused...

--=20
An old man doll... just what I always wanted! - Clara

--KmiAZmKUS8OFkhKJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZwiIxwAKCRD2uYlJVVFO
oxaVAP9PfgNhSqeNCS9x8Z3GR7wEInL1UyyJGOr6Rl+q58Kj0wEAl3ide8qht2EY
rGtPL8e03mtewkj3HecVC3pCWmSy/gc=
=a0GV
-----END PGP SIGNATURE-----

--KmiAZmKUS8OFkhKJ--
