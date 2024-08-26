Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDC6199FB0
	for <nvdimm@lists.linux.dev>; Mon, 26 Aug 2024 21:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724708138; cv=none; b=H6bL0uZbpfFlSAbwQp55HOqgSOtbj1fdFuskLd53eIhzEuTeilI/j5iFQmrpVkhe6Z48fvdXe3/Noh4IN4kJsDCApwVPlY80c/5N5tuM1UslbESCv8qr2jgQp2LfT7uVFn5g59iNiZh6uMQaFlquiHxO2Ifx1ghL3ve7QWIFB84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724708138; c=relaxed/simple;
	bh=y3bTwWiAvBcr8xpfUU+F1eoqSM/33mMGjdhkV+RrYk4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G4j53a/Pu+o19wCdGzsSXTeGUDwyZIRPtgQHr9PUgd/3cUE3j9aAgb4w4sWvupzGdc17n2VzoZP9e0j/SVAwijGkpIdKP8KhQkJ0YshYdT8Ward6xZrtMXpj76U3kkPgOaWfKoh/nEpBUi+85xq7orw9pDBqqq0poybbRQAy/28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MhU075mk; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MhU075mk"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-84305a83b06so1447336241.2
        for <nvdimm@lists.linux.dev>; Mon, 26 Aug 2024 14:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724708135; x=1725312935; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XeMKiOOWPXVPZaxetALQ00I6J7fyRUHujLp8LvoZwXg=;
        b=MhU075mk2dr7pBwr7VbdAI+rz+yN6+yJw8a8frqs97j6Y+Eg8liHu/f/i1DUmGEwgK
         FOh8xEljaIDjFxzNpSnlAc/pmEfhfWIiOrG0vlI4302IfKwE1HCyNQxLD6ItyrdYFGaj
         0qWI6nUk7ZmH5azTtfeylYv+cFc0VJZnTB6Et7DGGC7SA3pYImBIeWnu1CoT6CNQwfRD
         5esgJYQKyEyIyoOgQcB3e1cESuDpC1I4REiqWdhuQuWuGIyAZlQ89oxmjClntZsV7+Ts
         /KQxI6hyjMCh9OdCVCZMD/XJvTm4NwvHLihPsLtQbWVaJRdTL7g80tPltVBGrr/oXHPh
         PAqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724708135; x=1725312935;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XeMKiOOWPXVPZaxetALQ00I6J7fyRUHujLp8LvoZwXg=;
        b=v2Dc8+Ar535+4BvKmDt+vDddOAy72aWYpsVoM4JDjWG4HFlgYa2VWZLENt+zzhSWDc
         edKzcqmu0FvhG8b/l15iY5nIyE1JsMI2j77vepJHS/fx5pt3laFi+APCgJTgAbNgu/dj
         7A/ijZ4EN+DdmlOekbuvryrphfJQ1zySdYKHgFeULAOAm5Or6q6DBK3s/iY9h/aDOpIM
         SICNt3RJw7wv5hmkAbUEdZUVQ91LnPKG3JLCIQuoEl7UiZfzJ5Gq3P8uYg5nCq1oHqfO
         3HMxAaWcHUA+GzVIi6wn5Iqr7AV2GXMYQL2Le0auP9d6x1FbrDmU8QVzRPVw0+mnQi86
         b4Vg==
X-Forwarded-Encrypted: i=1; AJvYcCXXX9f8g3L8IMWgselJiPjwo9dqqLU23m98fGxI60KnRuX3y4rTb+vZDmx+ykELiO8kAOgUNjI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyY4ytCD9wu03hDQu2UGRYsIBUchonHAS/W/hJee5cL5MEhCWe4
	LNTOOxGfHOB5GkxH6ms6TbqJrZjPzmiNN5+eWApwVwfXEJEnNH9gW2vyFYO9aNl60vAa3FJQr7g
	9X4LslmZQALPLMV4xiY9cZlUl7IMRxE6QYWGi
X-Google-Smtp-Source: AGHT+IFahHCeuJlDlaa5/eCHItPH4qVMJYdtrrT4au2DWbduZ36ZOWkktQQxYZjPExV2o/UzTy6gpYMEXZF8JXmpOv4=
X-Received: by 2002:a05:6102:4427:b0:498:e22a:433f with SMTP id
 ada2fe7eead31-498f451fb7bmr15509004137.3.1724708135341; Mon, 26 Aug 2024
 14:35:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240814205303.2619373-1-kevinloughlin@google.com> <0bae453d-b4a8-3132-9fd0-bca0eece6a74@amd.com>
In-Reply-To: <0bae453d-b4a8-3132-9fd0-bca0eece6a74@amd.com>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Mon, 26 Aug 2024 14:35:24 -0700
Message-ID: <CAGdbjmLVFZJq7OJv2OwM3knmwfb-j8nZP7G_ownFA3kd3fYbVA@mail.gmail.com>
Subject: Re: [PATCH] device-dax: map dax memory as decrypted in CoCo guests
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, changyuanl@google.com, pgonda@google.com, 
	sidtelang@google.com, tytso@mit.edu, pasha.tatashin@soleen.com, 
	thomas.lendacky@amd.com
Content-Type: text/plain; charset="UTF-8"

> How can I test this? Can I test it with virtio-pmem device?

Correct. Assuming the CoCo guest accesses some virtio-pmem device in
devdax mode, mmapping() this virtio-pmem device's memory region
results in the guest and host reading the same (plaintext) values from
the region.



>
> Thanks,
> Pankaj
> >
> > Signed-off-by: Kevin Loughlin <kevinloughlin@google.co > ---
> >   drivers/dax/device.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> > index 2051e4f73c8a..a284442d7ecc 100644
> > --- a/drivers/dax/device.c
> > +++ b/drivers/dax/device.c
> > @@ -11,6 +11,7 @@
> >   #include <linux/fs.h>
> >   #include <linux/mm.h>
> >   #include <linux/mman.h>
> > +#include <linux/cc_platform.h>
> >   #include "dax-private.h"
> >   #include "bus.h"
> >
> > @@ -303,6 +304,8 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
> >
> >       vma->vm_ops = &dax_vm_ops;
> >       vm_flags_set(vma, VM_HUGEPAGE);
> > +     if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
> > +             vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
> >       return 0;
> >   }
> >
>
