Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0820173
	for <nvdimm@lists.linux.dev>; Fri, 17 Dec 2021 18:08:29 +0000 (UTC)
Received: by mail-oi1-f177.google.com with SMTP id w64so4765769oif.10
        for <nvdimm@lists.linux.dev>; Fri, 17 Dec 2021 10:08:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XGCz2Mkb3xw6Ly/YEIrj+GpLhNUOPqPMSl/tYzJrkMg=;
        b=eLE3vJKY1NyBeqaf/VYgkEMnEhuVAQg2NRCyg3AVQv+c9peWrKbnvL1eMfuPffDhzt
         v16u+2YU4WEjh5e5b2QCEMeQiejyU5rbE8tXOgtfKSZt2BEz+M1RaojqGPZmEm/MEskd
         A00Hr8WDtVqeeatnLj1fJZI9wDSn+VsOCJXzbGbMQiETz072DRYXjYBKk+JzQe2N2x4G
         l3JMvCkxAGifwmZt/4Z+kDNgSrVR46fEkQ0fvmacOlo+BgZioZctemJZCr5DqyCN2xhb
         XNKIwPIXWPhGegwhDtzqRp3Or9xn6S7vI6puSIW+r9gOASv1tnTaCZHEIh+nEUTL6LpN
         Yb2Q==
X-Gm-Message-State: AOAM532/5ZWADy3VaVhtBcw/VGPTBOeaeMs7akY/IuR8oHX+yLcBbO45
	j3sppzoqEvYCiRp92+fhwUPhW/nK3aJzSRZFKic=
X-Google-Smtp-Source: ABdhPJzvcWJ4CbIp8GquSE1y4BVzbRL9LcXmxUSupzHHII7RqING+mGyTVf8dR4sJBAHZKUZGO8yGrju06v7Lm+hZgg=
X-Received: by 2002:a05:6808:14c2:: with SMTP id f2mr2981766oiw.154.1639764508924;
 Fri, 17 Dec 2021 10:08:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211213204632.56735-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20211213204632.56735-1-andriy.shevchenko@linux.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 17 Dec 2021 19:08:18 +0100
Message-ID: <CAJZ5v0jq=XdH+xeHs5=wMGsu28i+r3nzZbhCNMJkfdOi65N0Gg@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] ACPI: NFIT: Import GUID before use
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 13, 2021 at 9:46 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> Strictly speaking the comparison between guid_t and raw buffer
> is not correct. Import GUID to variable of guid_t type and then
> compare.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Dan, are you going to take care of this or should I?

> ---
>  drivers/acpi/nfit/core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 7dd80acf92c7..e5d7f2bda13f 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -678,10 +678,12 @@ static const char *spa_type_name(u16 type)
>
>  int nfit_spa_type(struct acpi_nfit_system_address *spa)
>  {
> +       guid_t guid;
>         int i;
>
> +       import_guid(&guid, spa->range_guid);
>         for (i = 0; i < NFIT_UUID_MAX; i++)
> -               if (guid_equal(to_nfit_uuid(i), (guid_t *)&spa->range_guid))
> +               if (guid_equal(to_nfit_uuid(i), &guid))
>                         return i;
>         return -1;
>  }
> --
> 2.33.0
>
