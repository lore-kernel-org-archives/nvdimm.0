Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA5F72
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 00:18:07 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id s18so4237243pgq.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 17:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4VJ3QvXXf1oCSZlmmZFCmW5HhP20GRBt05z5BXuB1vs=;
        b=uBduij+oYAOXEjH4jNqSZs7BixvrflL0IdUDoXUhFmhs1w/2WYw8ttEEGg0fN02eaK
         7jsxrQM6OVx8FmZm481U3WqWwFAVAui13aUjeAE1kfy6CAYU+LuqJOhRzoywQ2m84iXS
         B1nfeX/Ke9hDOud+8boi/Ki8fNat1B4XK5KyHFB5BT4fXGBAaEMEttGMHdCBq+3X7Rty
         ziJScIfev0Y8vKOVwePgJfib2PwmVGnXtzcGHuRrxCcTChd/GC8pmKw5xJOw9d0JLeB9
         KehMTZovWBH1NoSAnLm/xlmhl2DLXrMROI/NiJA33bK5WY9iZsdazO9f7mnP60FF15o/
         VHrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4VJ3QvXXf1oCSZlmmZFCmW5HhP20GRBt05z5BXuB1vs=;
        b=ttYik+WHSKwxRaHt7hsJytFcjIkmUBb4VijPtp8bN/BeL9UraZ5RHNPfknpce0WhCb
         CaBAoPjCkiqxm71pltpCuRZPnh6ilIaMjfhzr4O8Sn47ywQN09aewEXdtgJeNKn/V7Jl
         rr0Chn5ORHbXBy6d+iqDwVHjbhpTAE6yRLgV7yxLjmyvYY1voOL0I81vU+QBBSdgHQvo
         yUu/G07W+deNjEpUw/qN909zAVJ4uAneYnsrgUeb066IXq3mxF7rspMa+smEflXyllUa
         0JdrJ5GYRTGIMsF7+5ZoZGhXzdflhy9tz0dNSrDWYMCTgusv4RxHOmaAObBzKnOVtW7l
         LURg==
X-Gm-Message-State: AOAM533xIhebuCsPoSJuSPGTJXe3ZnAfWQjhpRTyX9beSaILWxySeCvq
	sSA/93Eicx6SXc2hAXd6vitc9ho0+5pTlWy/lwc1oA==
X-Google-Smtp-Source: ABdhPJyETQCPrQKAwXM3+Q+zFkI7GfSpzIc9Eemwwj5kBC+9lq+w0ZtFhIg9xVOKlT93NH9LOjq2bKHvYF+tqDg4OFk=
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id
 l6-20020a056a0016c6b029032de1909dd0mr811916pfc.70.1626308286912; Wed, 14 Jul
 2021 17:18:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-2-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-2-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Jul 2021 17:17:55 -0700
Message-ID: <CAPcyv4iSiTRN2QNYqWDUepFQdiDmBk24e420xUUUCZ_ON8j5SA@mail.gmail.com>
Subject: Re: [PATCH v3 01/14] memory-failure: fetch compound_head after pgmap_pfn_valid()
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> memory_failure_dev_pagemap() at the moment assumes base pages (e.g.
> dax_lock_page()).  For pagemap with compound pages fetch the
> compound_head in case a tail page memory failure is being handled.
>
> Currently this is a nop, but in the advent of compound pages in
> dev_pagemap it allows memory_failure_dev_pagemap() to keep working.
>
> Reported-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
