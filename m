Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60981173
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 21:20:21 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id o10so11004141plg.0
        for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 14:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Tta22g6TzCbS8+A5F3hRnTInZTNETaE2nytspmuyiI=;
        b=WmkNeRi7tFECQpCdiAmGDL4hHYzV9+5I3fYvoUDlepLk2e1dCoJMI6zB/qrgiW/KA8
         tjlG4bLQMDL/lTTTfR20oVNEgEEZ9SZi71LCMKYLmB9l7o0IKWQV3x99rHH9jrOdt/aQ
         KvCTbbVrru40KnJ4Ss45A2n6Y2tle0h2j1Fyp9R/qhfGrgpEmPMaySRW6/mu3K7iVXr5
         PxzRBeLG0yaFZc9b/9i/1w066LgdKUZn7jriSCoN6lLiH0EHg9NWUBuRKhMrDkvqUavH
         1ra/FqSzDumL4aMl8uZzZVoN/2mdgv0SPsnRwIrftWCnmVtCvSYcmYp/HvEhrMhW4u3g
         nk6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Tta22g6TzCbS8+A5F3hRnTInZTNETaE2nytspmuyiI=;
        b=SqAwgQqtfg1yOqPYPPEBzi3VZ3m12Wt6rYDGulzeGdJZAm4VpypbTTwDjyA39nD2xm
         qskbDZliVzyl7kpni4Tb8AEjdQcH7QKo1hfWYOCjxuEhTDlC/GSpdsFp8oaBSRoMPVnm
         Tnag+J72+zvfg6AjLCOCTu9loPtAJsWHJYb4rhv6k+/SKFrAS5hrl4alk/IJWRWXpKDy
         ryEO6lFiCYaS2s5blFxpLm86OGGTKV9A+1GswD94ls/POqfhpoygNaAZydyU/yAqzIFI
         x9mQdZ17mN3/SfWiZxqHhZSzgn10koRF4QOeO4dbbQML1ZKb4DPsXu/Js880OjViwDz3
         hoRA==
X-Gm-Message-State: AOAM530yyiRqLcB5Z4xEDImaI/lF+JCQ+OjeMdVTl5Mq/KEtngJlkqdq
	W07jENAReShqsF6SbdASQ9g6ny5Ca6nOg9YsQu4eHw==
X-Google-Smtp-Source: ABdhPJzdZDOlIEIUdEe/koFlzTPnIhrvJ+LvlXLPoKCXM8QxzZFIYVnDFkM1MxM7I34jVCC/VnQMg8JkpWiv08lsQpo=
X-Received: by 2002:a17:90b:23d6:: with SMTP id md22mr532829pjb.149.1629753620957;
 Mon, 23 Aug 2021 14:20:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-9-hch@lst.de>
In-Reply-To: <20210823123516.969486-9-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Aug 2021 14:20:10 -0700
Message-ID: <CAPcyv4jR7U2N0-fFE8FUL+fNdY+6f=FNs7ex56F5tsLztA_GJA@mail.gmail.com>
Subject: Re: [PATCH 8/9] xfs: factor out a xfs_buftarg_is_dax helper
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 23, 2021 at 5:44 AM Christoph Hellwig <hch@lst.de> wrote:
>

I wouldn't mind adding:

"In support of a future change to kill bdev_dax_supported() first move
its usage to a helper."

...but either way:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
