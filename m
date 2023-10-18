Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E673168DA
	for <nvdimm@lists.linux.dev>; Wed, 18 Oct 2023 10:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-57de3096e25so1371003eaf.1
        for <nvdimm@lists.linux.dev>; Wed, 18 Oct 2023 03:39:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697625597; x=1698230397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wtmjII0ee1f21HN24SIPEYP9xZN9qMse1/pApzruflA=;
        b=FmJ7SvhbhyYBXiEHzmsIW2H8V1WTt9WLh4BSoyqTCrIRZ+xCyjbPne1OHTTvckEU0X
         yaqCWiHGixVzYtvfwginJkeIv3Y56MgdvkIg5FnGgV+Fopl7h8xu2B5GHpNek7lMzXGJ
         uWkFMU4f2fWxrWaU+12Ax0ygzatuCpHn6YYAKcY0Skh576WYTDwqpSpWN3sws5qLXlgA
         To987frOkggoa097csBOTN4BIN9WXcVmpeYgnwf9fFyn7JbPz1WV12G2slwlWTMSx6yq
         fE8XdKqbAOfeym+hJcPQvJyhYW/zDC4rVZJjpURwFxuwVFOaQ5Db1HW1tkm10wDj2NQy
         HsuA==
X-Gm-Message-State: AOJu0Yyxsk5zsY9Qrynx70OAuTr0H19RMiX5dYB2jrdxBEQrSA7aZeNu
	a9EI1BoTjnFIS+e4nedo7SjuPPi4SItCIE6RhMY=
X-Google-Smtp-Source: AGHT+IFqHTgrARdc0q1r9FIddruvQnjJjU8onYjV7cSScx6lMxZRYIE772ygaGjJZnfdXpHVmL5HSXSsnZZYxUACNuE=
X-Received: by 2002:a4a:4f15:0:b0:581:e7b8:dd77 with SMTP id
 c21-20020a4a4f15000000b00581e7b8dd77mr3387616oob.1.1697625597298; Wed, 18 Oct
 2023 03:39:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231017082905.1673316-1-michal.wilczynski@intel.com> <652f5eddba760_5c0d29449@dwillia2-mobl3.amr.corp.intel.com.notmuch>
In-Reply-To: <652f5eddba760_5c0d29449@dwillia2-mobl3.amr.corp.intel.com.notmuch>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 18 Oct 2023 12:39:46 +0200
Message-ID: <CAJZ5v0g5buHjd+EqMsHtuN2vcJHSTCd-cCchvo-44iPi1cKk5A@mail.gmail.com>
Subject: Re: [PATCH v3] ACPI: NFIT: Use cleanup.h helpers instead of devm_*()
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Wilczynski <michal.wilczynski@intel.com>, nvdimm@lists.linux.dev, 
	linux-acpi@vger.kernel.org, rafael@kernel.org, vishal.l.verma@intel.com, 
	lenb@kernel.org, dave.jiang@intel.com, ira.weiny@intel.com, 
	linux-kernel@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18, 2023 at 6:28=E2=80=AFAM Dan Williams <dan.j.williams@intel.=
com> wrote:
>
> Michal Wilczynski wrote:
> > The new cleanup.h facilities that arrived in v6.5-rc1 can replace the
> > the usage of devm semantics in acpi_nfit_init_interleave_set(). That
> > routine appears to only be using devm to avoid goto statements. The
> > new __free() annotation at variable declaration time can achieve the sa=
me
> > effect more efficiently.
> >
> > There is no end user visible side effects of this patch, I was
> > motivated to send this cleanup to practice using the new helpers.
> >
> > Suggested-by: Dave Jiang <dave.jiang@intel.com>
> > Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> > ---
> >
> > Dan, would you like me to give you credit for the changelog changes
> > with Co-developed-by tag ?
>
> Nope, this looks good to me, thanks for fixing it up.
>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Are you going to apply it too, or should I take it?
