Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641CE3FC8
	for <nvdimm@lists.linux.dev>; Tue, 21 Sep 2021 18:26:23 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so2629923pjb.2
        for <nvdimm@lists.linux.dev>; Tue, 21 Sep 2021 11:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aqPnnkY/Q0ficiHSKKbu0LELMWPwq3RD+dyIOwx8Fzk=;
        b=zKQEJsdiJPPkLN0kjZblnkpEXdI3OyjSHMz9sUbnS7dqq3uE1Xf1jqvCBTu1040kSr
         XButXDeuETjOTT1ncj7eC2okelIHjI0YMY3ypuR3rDvROOrgd/5aPP/TyeI/yZC0Utgs
         QO5Fs6xzaB97TCVqkpCDEistgNWlLXqq5+nskeKJYUY/Xwan8SYbuQ7a8E7qr9+xspoA
         rwWwN4KQjRAnx2Dy7h3aGTDcoCn1ELQgvzthGsCh9cPU9+teev30s+5bnJx7vyI/MhC9
         vgcKY6VPzsU163mt0zT575ka9bQCqdm+9fHw1vlUY/Y4l6ihYnqpeGJki3mkNljvy0+J
         BPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aqPnnkY/Q0ficiHSKKbu0LELMWPwq3RD+dyIOwx8Fzk=;
        b=kPZvDlnqhxKDwucFzJtpjKlW15l/uA1nKID+Yd9AwzR+wFD77Zs7kY6KnahMKPSAxo
         oYLnYclj+lAo/bHmxdDvP2gdWz5FQdCF0FM9B8M4mJesNnEuhHQfPNlFFNulCvgZCBDZ
         8TtjgNg9y8cX5kB0BY051JI5JQXnuM8jGNFh25ViqVan/Kz8tT28qgEr8nub58Qr3WVX
         20GUKzIZmyT6Ta7hdcfCzlK8VVbvcuHR4VvUk5MA3hbLbVBD7BVbpdXq8ue1ugRVKFuY
         e2F0WWx4fe/9x9eHOqRiG+s175q5E9tFWRY7nmay//Oz9MERCMPF8qkF2iById8A2MSm
         2JaQ==
X-Gm-Message-State: AOAM530NTnwgDtw8zXmpH6poQj27+eXHzaP0aJ+CzMny6HJXHpM+sgOD
	QmOoEI8w6/ajNh+J1V8ZfuGng2HRMcZXCUeO7Qba8PVHObE=
X-Google-Smtp-Source: ABdhPJzlfLUqQbo9wWmR9Y052kLPWQw4maz4fDXqxlAjyLdnlDfgaQB3iCUMoZSrZESuV4MdpwuiAGfta8VA82GivG4=
X-Received: by 2002:a17:902:cec8:b0:13b:9ce1:b3ef with SMTP id
 d8-20020a170902cec800b0013b9ce1b3efmr28713499plg.4.1632248782586; Tue, 21 Sep
 2021 11:26:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210921082253.1859794-1-hch@lst.de>
In-Reply-To: <20210921082253.1859794-1-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 21 Sep 2021 11:26:11 -0700
Message-ID: <CAPcyv4j4VbQMBZou_=9JD5pZbBoFo_ccL=OLXofLPHHJY6JDAw@mail.gmail.com>
Subject: Re: [PATCH] mm: don't include <linux/dax.h> in <linux/mempolicy.h>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Linux MM <linux-mm@kvack.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 21, 2021 at 1:23 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Not required at all, and having this causes a huge kernel rebuild
> as soon as something in dax.h changes.

Looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
