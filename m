Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5BA3FC8
	for <nvdimm@lists.linux.dev>; Thu, 23 Sep 2021 02:47:20 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id k23-20020a17090a591700b001976d2db364so3833674pji.2
        for <nvdimm@lists.linux.dev>; Wed, 22 Sep 2021 19:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=agoq3Fxpf+zW/Ee2I2bgAzZKmWuzEcBcM6Muz18xBqA=;
        b=nArOwzsUXZXiLe4TziLWZHrpKd/FHn28RSC5txzbzzV63fl08WSYEZJk5Co82LRG5B
         Od3/IPPQ6Z/J1EOCZDk+ArlrvAQS4I0GbZkqIxZtvILtaZl1vD/+qdjZ+4huB5tDIWJc
         jDzYkhYFe5ongcQ3TG/5wWuUfcEmG4VtpHRBJp/BvRKamoZUnqauDwpgPq3t7xjETL+t
         Tn6gclF7CmkQc2CvjxCveFNbleM1amUDpI16LpYb0LiUdE5HvhsNI+ohqhldjBapX8+2
         nRT4eUFUoQMb3Vrq17ICqZv6+9EnZ+zfqDpWQJxewiTkEL8jHvchW0BA/5oklVfiST1w
         A2ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agoq3Fxpf+zW/Ee2I2bgAzZKmWuzEcBcM6Muz18xBqA=;
        b=vXi/qzBDIm4OgyoHwwo6uZ6VbskBFesGhpa4cFKFbeGwg4Q11gjFTGblIaKfPI6tem
         FFQBw+mlsXNBFDRrKLpdYNcdbAY+lNJfoOeAWYzD/7/79CRL+p2ORAQIt+N3huiMBT39
         cuL4doalxY+2uOIJ6xwQug8hLlYRITadGcXC9A2URUNp6hLYzyfGFpZtuahe00cMStMh
         F6EgqiszSYI/J+UBY6KaadC3O0BGMI1f5Xn6kXSCxWgEPr5TS67r/v30ux4o1Why6nC1
         QsfSfTIByacmyWRg7CturGzJSk54QkngozC1SAwX9SQHYeRHlWK1tyYnqRjf7sevJjUx
         xolw==
X-Gm-Message-State: AOAM5305wEjiAUzqrELa1N/YH21L6O2l8rm370aTBmDSOWT4tvOhCBqu
	vGH6Dyb6VSaZkJGvK7ZfXYkVcpAJajR97d1IcnnXgw==
X-Google-Smtp-Source: ABdhPJxHihhVA4u7nhquDosGs4ysGyAjAjUQ2tJKKYjWJpFwQBjiy7jfO5CRdxC27m6u5DJu3irBHSwc4NJg+F940dk=
X-Received: by 2002:a17:902:bd8d:b0:13a:8c8:a2b2 with SMTP id
 q13-20020a170902bd8d00b0013a08c8a2b2mr2084104pls.89.1632365239539; Wed, 22
 Sep 2021 19:47:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210923010915.GQ570615@magnolia>
In-Reply-To: <20210923010915.GQ570615@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 22 Sep 2021 19:47:08 -0700
Message-ID: <CAPcyv4i5xYHFkW55eGi8L6mfoPwuMhcH3eFhDTAqzrTNvwTt4A@mail.gmail.com>
Subject: Re: [PATCH] dax: remove silly single-page limitation in dax_zero_page_range
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Mike Snitzer <snitzer@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 22, 2021 at 6:09 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> It's totally silly that the dax zero_page_range implementations are
> required to accept a page count, but one of the four implementations
> silently ignores the page count and the wrapper itself errors out if you
> try to do more than one page.
>
> Fix the nvdimm implementation to loop over the page count and remove the
> artificial limitation.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  drivers/dax/super.c   |    7 -------
>  drivers/nvdimm/pmem.c |   14 +++++++++++---
>  2 files changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index fc89e91beea7..ca61a01f9ccd 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -353,13 +353,6 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>  {
>         if (!dax_alive(dax_dev))
>                 return -ENXIO;
> -       /*
> -        * There are no callers that want to zero more than one page as of now.
> -        * Once users are there, this check can be removed after the
> -        * device mapper code has been updated to split ranges across targets.
> -        */

It's device-mapper that's the issue, you need to make sure that every
device-mapper zero_page_range implementation knows how to route a
multi-page operation. This is part of the motivation to drop that
support and move simple concatenation and striping into the PMEM
driver directly.
