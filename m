Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A1A3FC4
	for <nvdimm@lists.linux.dev>; Thu, 19 Aug 2021 21:56:01 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id s11so7194593pgr.11
        for <nvdimm@lists.linux.dev>; Thu, 19 Aug 2021 14:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oHbvW6UqiCTsRu5vWaf3qnfqFYd/iOMYaaPDkT+6n4k=;
        b=ZLTPQExqKJd8DCa2TyoJWa3XCbsUacLbIOl9KO7oHTE83PBtwK+t7km4R6MNyOTtZi
         SGiazJQsLWTBM7iseMRbLEv2+SegAraOApUKlAGLUjfvHejA0A5vc+V43eVlFy+zTsB9
         uAqCX7733MC+5i3lIosErzuEMthhPZvXXXIps3cRSMnuY8yZIAognhi1QZyoospV8DJm
         t/NY95OUxhJS1NokUENvcK0ev6TDCli4oVp0HinstyrA6hMUnGw1zDIth8EtIHjUh9RH
         nocO/p/V7QFexAOb9XnyfxfhZntIFJ6OEIea2ekTSxFWpQuI9o54TR+ak8fpwuBHCRpl
         Q4LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oHbvW6UqiCTsRu5vWaf3qnfqFYd/iOMYaaPDkT+6n4k=;
        b=X0y+XsVNThxp8PwFnjRbYEMvSMDuzxYpxyLwnO9r+usaT3C8v6eZm/27W246HKDxCU
         RHQq2NFDVKWhLEL6HOOgI4kDWHhRS41MzZ1oH+BcCrQH6Y5JoOkm5tCTfe90IPT4VUXC
         ciLr9rQIalolV2BDmKooAxRVQJSQoGugqx+C5/SiKHS/jRky8PGZfmuA78dAtaLGmzYV
         R1v+3fr9V5xqm417ymKSg7ANXjh233RVax8KK6g8hmId+C7gAEZZDODDjqHNp6j57F5H
         4TqEI2dt+bmUU9b9CNXkXqdrh5R6aXQu7SBFuItS78Vpk5DE/2c4uPvF8SBTZrCJcQsG
         FkrA==
X-Gm-Message-State: AOAM53255gBmV50WCUwkhT17icZtBI5BOz9Rdtbp6VIgxpk6VImS+Xyp
	QHm1TAusS8isTPN7xkDU+eyYajhGNazLDQgWbq87jg==
X-Google-Smtp-Source: ABdhPJy/B2hm2/hWvC7e67tV3MfHtjJtBBELucqps5FMrdqxqVA8mCj+nC4eNLvFYInr3AywzqexVgaoo2GPMcxThDI=
X-Received: by 2002:a63:311:: with SMTP id 17mr15684252pgd.450.1629410161397;
 Thu, 19 Aug 2021 14:56:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-24-hch@lst.de>
In-Reply-To: <20210809061244.1196573-24-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Aug 2021 14:55:50 -0700
Message-ID: <CAPcyv4jOh8qaTBVM5tRn1S1+Bp2QCW4eoj5Qi0xRw_EwJ0q0ww@mail.gmail.com>
Subject: Re: [PATCH 23/30] fsdax: switch dax_iomap_rw to use iomap_iter
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-btrfs <linux-btrfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Sun, Aug 8, 2021 at 11:33 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Switch the dax_iomap_rw implementation to use iomap_iter.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c | 49 ++++++++++++++++++++++++-------------------------
>  1 file changed, 24 insertions(+), 25 deletions(-)

Looks straightforward,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
