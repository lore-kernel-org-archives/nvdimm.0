Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB322C81
	for <nvdimm@lists.linux.dev>; Tue, 26 Oct 2021 01:43:02 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id x66so12666520pfx.13
        for <nvdimm@lists.linux.dev>; Mon, 25 Oct 2021 18:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e3QNntbi6F0Q5EQIPy2H7a8oNts2Eyp4p/Xn7HNIof4=;
        b=6I9ExCZXDjetUnWB97k4kiOjvXsb46qPrDkZKZEtP0yYIvx8GFEPOVESL8tETTem0s
         uMxYAvOYuVABEFafvkY+CfHrJhIxDvRe9M262+xBUmx1zsVSJMhWgzgtccK5H3xfSZ7o
         nqVxXoJ3pAOGeWyevOLIbM9sU15/was3trfrEXpHPaDYMLU2qcUAvmVm4mBqoQGLVzZi
         kfAFaTlu5+s76CRog1FBM7RWYrJZnG+EpPLJFn0c0GIaBfRvNspnRLEG1zhgrofS4aPq
         BYBoyZ3XjCWaSCwQqT6mLEwFgtBemVUOklCfwWfOBv/l6vq27zpEUfcnSJZy+r/gt600
         nnJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e3QNntbi6F0Q5EQIPy2H7a8oNts2Eyp4p/Xn7HNIof4=;
        b=K1tucA5YeVFA8JwLF29biIcbjyMKrN20o9cvoA0cPq+yCW1ha75oU31mIOkB6E3nRf
         gG0INj85fa2/vN06A81HtE+u2MgCcCkHmnSmFzRzG7TDB5a4HXx2F7J/BbJmOBnPJepm
         7SD92pYelKptqEuuXWW53N8UXqmg4rTjnxGe231sXPWgOI63avBkFP7RSzVUACUUeSL3
         YoEKS1HUBlYkMD8CS7gyGxLqwS5VH5gj++muuR/iyLdQc3T7/FotDPWbi4rq77KQDBHd
         pWBkzjarKLAc6Vvz+h6POmTgWVj3z+S43S2FHfmXzjs2rTyaltVJsa4kT88+JQFjDHoG
         WVfQ==
X-Gm-Message-State: AOAM532eCtIKrGr9ovO14ZPcNJeJrLitE6nNcX57ASJ3MwQXwhaDcCzN
	zX4dDyNmYg+fQg0qWWI2GWfB0JVTQIRQ4TRZfv0ojA==
X-Google-Smtp-Source: ABdhPJy1bgYCv5vnItFJsKHYvhi32488pwwKAHbT9aXBTMl76S4vhvH/WbPtblFWCNALYE4rFvqzmVg5ElJIAz3kVaM=
X-Received: by 2002:a05:6a00:15c8:b0:44d:9f7e:ece2 with SMTP id
 o8-20020a056a0015c800b0044d9f7eece2mr22508213pfu.86.1635212582401; Mon, 25
 Oct 2021 18:43:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211019073641.2323410-1-hch@lst.de> <20211019073641.2323410-3-hch@lst.de>
 <YXFtwcAC0WyxIWIC@angband.pl> <20211022055515.GA21767@lst.de> <CAPcyv4joX3K36ovKn2K95iDtW77jJwoAgAs5JSRMcETff=-brg@mail.gmail.com>
In-Reply-To: <CAPcyv4joX3K36ovKn2K95iDtW77jJwoAgAs5JSRMcETff=-brg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Oct 2021 18:42:51 -0700
Message-ID: <CAPcyv4gFCRs_OJ1TutBi-tmWWS2pU_D+bqJVwCcp=7dCMkhGEw@mail.gmail.com>
Subject: Re: [PATCH 2/2] memremap: remove support for external pgmap refcounts
To: Christoph Hellwig <hch@lst.de>
Cc: Adam Borowski <kilobyte@angband.pl>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Jens Axboe <axboe@kernel.dk>, 
	Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 22, 2021 at 8:43 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Thu, Oct 21, 2021 at 10:55 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Thu, Oct 21, 2021 at 03:40:17PM +0200, Adam Borowski wrote:
> > > This breaks at least drivers/pci/p2pdma.c:222
> >
> > Indeed.  I've updated this patch, but the fix we need to urgently
> > get into 5.15-rc is the first one only anyway.
> >
> > nvdimm maintainers, can you please act on it ASAP?
>
> Yes, I have been pulled in many directions this past week, but I do
> plan to get this queued for v5.15-rc7.

Ok, this is passing all my tests and will be pushed out to -next tonight.
