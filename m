Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8CD72
	for <nvdimm@lists.linux.dev>; Wed, 18 Aug 2021 21:01:26 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id o2so3621317pgr.9
        for <nvdimm@lists.linux.dev>; Wed, 18 Aug 2021 14:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tsxhBVRZlO9and7DhCBUruAlzXa20bXVaKImjY48c7o=;
        b=zGGJKW23TpE7PPFJ4/n391OFSE+ePfB6XhKYr42xqQdacaGLoy/MLGcJOB9KJclibB
         29yQ1DLoZOq7YUGzImZJ1hjNXdcN4bUgBPPOpNCAUpQuExc321UUpjfAEZalmz/yrEmp
         QMBCgYswdRECqSZZszyKnB1/zOj6k9++ko8k9sPqN4YI0mQ+MpWE8w90ykG4GHsvonXj
         +NKnoDJPWaGnOUjnABohDzuGK/EN0y6cm+wAyrcNscAwRna0z/xgPtNqS+mR4HhFrKCd
         yR/73F6u/b1hWv+BHa6yM7WRf5HOfuotX6pcWtI2uqTJ6KkhqyfixiY4MEVxCLYod6oS
         Jj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tsxhBVRZlO9and7DhCBUruAlzXa20bXVaKImjY48c7o=;
        b=PRt6q3OMgb5R7FCBX3+xq2IRn6Eshear8UqYj/5aawXIgadsbDd7rvztSRfrLd5enR
         wejmoO/kENauRl99HcwZXWMmhHOtEkhS0OqzwWg13Wl5viH15r0/ssw+IQwvg6pmHovs
         CsuIYZYRyEZuj0IsEHxx9E3wGi4b3Idv+JE19aPiSYoaoZb5ROPS5y4EnpjUetLiwokk
         XiIQy0R9i/rfCg+MW2GDQZC3brhXvy+VHq2dN8Iqzb/+GbZUaV4c1dVHTNEiwKV1Jgyi
         LH3KYfd7A9CUWvmx+z+HQQuuN7L9i4uGvRi2XwOIygXUDpWUcOITQA04EYO4BFQWpRAR
         mp5w==
X-Gm-Message-State: AOAM531wYST2EcrGKli+97lpPHJ41In64nDVlN3TRAdzyN5ug3fWxu0h
	JYczdTVPL6OSChcWkqZYNiBeZj3KG1g+J4HbJSQmOA==
X-Google-Smtp-Source: ABdhPJyC7TVzou7MS10S9DHd4c6rf2rdDWgmDabraG+KHQy+8QVQinJv59B8c4LqBnwh3oILNYKei6BontbTyhivPwk=
X-Received: by 2002:a63:dd0e:: with SMTP id t14mr9090412pgg.279.1629320486279;
 Wed, 18 Aug 2021 14:01:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com> <20210816060359.1442450-2-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210816060359.1442450-2-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 Aug 2021 14:01:15 -0700
Message-ID: <CAPcyv4jUDGDK5nXiVhEgw_Pwkjf8D=O4Nbw0Gd1YdWUJEoifpQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/8] fsdax: Output address in dax_iomap_pfn() and
 rename it
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, 
	david <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Al Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>, Ritesh Harjani <riteshh@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, Aug 15, 2021 at 11:04 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> Add address output in dax_iomap_pfn() in order to perform a memcpy() in
> CoW case.  Since this function both output address and pfn, rename it to
> dax_iomap_direct_access().
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
