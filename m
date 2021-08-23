Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1787C3FC0
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 20:21:14 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id g14so16356207pfm.1
        for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 13:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cRgi7oWfHECsTBz/HOJJYyhwTd/oY8CLDyaMGcnc5IA=;
        b=cT3oI7fsvWd9Kk4N5ASvVpaqvjiKDezL4ogdeKpSwtrBssY3I6QGps+2KtKeN2Sn1J
         ZLr208u/aGZ/u1b0I1PfHUiaX27fLPbIAEkKCaMlLJOi3qIkpIunPLcW0ObMb/pcC3jD
         aD+TM+MjjceBfRowI9i1Uwtf7qTY6ds4BXdTKGPvZ/OJlQIF5hT9mjOWdqse/25Hf2Vo
         IiiuS2tyJ6O5efKMPNzujsYKD7QUG1Ic0XYxqLNI7rzGxaafetGZ6NZ6eCsBAgKe5eyI
         rUG9ANffxeSUN3oBJ2pViDZgUQM1ufIMBTnGZVWVcg0Z/943ziAhLpK7nfk0cFEY5BhH
         m7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cRgi7oWfHECsTBz/HOJJYyhwTd/oY8CLDyaMGcnc5IA=;
        b=HfG00Kf9wNF+QkbfwrUuydUa/zNcO9/FnRuycSyZg+3WJAOI8WL4zflPd0lzCtWh5F
         eec9ome7xByrNEr6Go8PlT/29T2g7Iz/cXYYsuPRWd0hTky1UH3nkPXdTBVNCkGAJb5o
         G/jzUImuzKcN3CvQM3VeVQVnkSkVEW4bOm1Og3U5KiJF8vYzXPbwmrRpFQkhiYd1AwRr
         YoqvKKn1RN4ucxX9brGqnE/8b74P3ysolSwrBpl/2cV9l5u2uWOCNaN4BVvJJkCFNncq
         AjJHEQmBv2dLl4TFlAZYjojD2y4z1o9ThqflcMLZlEgbCrB6iKl6ibFzOFqum8hu2WLo
         D4HA==
X-Gm-Message-State: AOAM530aYyeoS5UgpNgk/lkLAc3k+XX4gj7pUDOWuo5Olu43FfcHTpbb
	hX6eYap6RJVoFiq2VvqDo19x/5Yz8awfNeQLJbNgLw==
X-Google-Smtp-Source: ABdhPJwo0ftFKtVJku5VlTYKzPAMAn2sKO4dCsEW5FRwAFVeufg7hV8XJ4EkKSmGuFTL4G0VIpsTraKBA0CyHvm5Tjk=
X-Received: by 2002:a65:6642:: with SMTP id z2mr21385344pgv.240.1629750073617;
 Mon, 23 Aug 2021 13:21:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210820054340.GA28560@lst.de> <20210823160546.0bf243bf@thinkpad> <20210823214708.77979b3f@thinkpad>
In-Reply-To: <20210823214708.77979b3f@thinkpad>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Aug 2021 13:21:03 -0700
Message-ID: <CAPcyv4jijqrb1O5OOTd5ftQ2Q-5SVwNRM7XMQ+N3MAFxEfvxpA@mail.gmail.com>
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-s390 <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 23, 2021 at 12:47 PM Gerald Schaefer
<gerald.schaefer@linux.ibm.com> wrote:
>
> On Mon, 23 Aug 2021 16:05:46 +0200
> Gerald Schaefer <gerald.schaefer@linux.ibm.com> wrote:
>
> > On Fri, 20 Aug 2021 07:43:40 +0200
> > Christoph Hellwig <hch@lst.de> wrote:
> >
> > > Hi all,
> > >
> > > looking at the recent ZONE_DEVICE related changes we still have a
> > > horrible maze of different code paths.  I already suggested to
> > > depend on ARCH_HAS_PTE_SPECIAL for ZONE_DEVICE there, which all modern
>
> Oh, we do have PTE_SPECIAL, actually that took away the last free bit
> in the pte. So, if there is a chance that ZONE_DEVICE would depend
> on PTE_SPECIAL instead of PTE_DEVMAP, we might be back in the game
> and get rid of that CONFIG_FS_DAX_LIMITED.

So PTE_DEVMAP is primarily there to coordinate the
get_user_pages_fast() path, and even there it's usage can be
eliminated in favor of PTE_SPECIAL. I started that effort [1], but
need to rebase on new notify_failure infrastructure coming from Ruan
[2]. So I think you are not in the critical path until I can get the
PTE_DEVMAP requirement out of your way.

[1]: https://lore.kernel.org/r/161604050866.1463742.7759521510383551055.stgit@dwillia2-desk3.amr.corp.intel.com

[2]: https://lore.kernel.org/r/20210730085245.3069812-1-ruansy.fnst@fujitsu.com
