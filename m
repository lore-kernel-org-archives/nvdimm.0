Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE96199AE
	for <nvdimm@lists.linux.dev>; Mon, 20 Nov 2023 15:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3b2e08526b9so935273b6e.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Nov 2023 07:12:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700493125; x=1701097925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S+m0kC6g1pw6dndsJtMqNEaQgc0zf06MzggkuivSPh0=;
        b=WzfrrIHTU++YHFMDMllLmtfkasDODYay+36pR0yC0rHMbofJBMlgNgUbWSEa5jjpLl
         5Llaw+LpshYRvgNe3arzI1HlPV/DENgqq4M1ytG16L7yM//vsxc7U/geoT+ZRPw3zyq4
         YauMBvfEffZA010g6Swrb8uS89//pFmzjNpsw93RF6bpnD4crfKoKzVbtBiwSk2zt4pd
         gXcyS7x7glNZfSQPaxGd+nGp5CmhCUcE37Om6Aon9NTEaLcodo3DwrOG8iO6gw633E/M
         R3IWNBFtVzUpB7scj0sbUH7rEl1osDH0HAt8utRmhQGR92efontLQdQyqU1zEDFW5AF1
         qI6g==
X-Gm-Message-State: AOJu0YxvsqlwYaM2tiHRr7DMrKw/vjpHLBuz9zsmHgS2/dcq8QIJeAnx
	Hpp6EgdHdvf6BxU9LlWSn4eXGylelfgqsQgwXnM=
X-Google-Smtp-Source: AGHT+IHSUSPPFTcw8FMSSNGm1jay0/0THjIE7X5TrQf4EMgupzCk+cjrGR4G9U3eM/ZKrCfPpjKg98MAciT1ixshXxs=
X-Received: by 2002:a4a:d44c:0:b0:584:1080:f0a5 with SMTP id
 p12-20020a4ad44c000000b005841080f0a5mr6925354oos.1.1700493125450; Mon, 20 Nov
 2023 07:12:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231002135458.2603293-1-andriy.shevchenko@linux.intel.com>
 <6531d1e01d0e1_7258329440@dwillia2-xfh.jf.intel.com.notmuch> <ZVt1J_14iJjnSln9@smile.fi.intel.com>
In-Reply-To: <ZVt1J_14iJjnSln9@smile.fi.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 20 Nov 2023 16:11:54 +0100
Message-ID: <CAJZ5v0hk2ygfjU7WtgTBhwXhqDc8+xoBb+-gs6Ym9tOJtSoZ4A@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] ACPI: NFIT: Switch to use acpi_evaluate_dsm_typed()
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Michal Wilczynski <michal.wilczynski@intel.com>, nvdimm@lists.linux.dev, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 20, 2023 at 4:03=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Thu, Oct 19, 2023 at 06:03:28PM -0700, Dan Williams wrote:
> > Andy Shevchenko wrote:
> > > The acpi_evaluate_dsm_typed() provides a way to check the type of the
> > > object evaluated by _DSM call. Use it instead of open coded variant.
> >
> > Looks good to me.
> >
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>
> Thank you!
>
> Who is taking care of this? Rafael?

I can apply it.
