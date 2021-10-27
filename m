Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3492C9F
	for <nvdimm@lists.linux.dev>; Wed, 27 Oct 2021 22:03:29 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so3119314pjb.3
        for <nvdimm@lists.linux.dev>; Wed, 27 Oct 2021 15:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t4Hx7HuIToogFrpWvEndnhmu5FP0FfguH4MlN11vPPE=;
        b=r4O7O+D6bqWhbnfNK8GAK+O+V51sL8gQ71rKDmnAA3fZ320ss8g64pT5I4bw0Ty2W9
         TGiVpZlytWCPvqsnO2KP5mgjcvtWG32bPlTJSiDywz2eUzvbv14zKkXGrmqra8bYuVcX
         6eTzntuayCoe6FMfUlwppg7wtXGYJnRCccwyOD6BMW/cCSj5855vgtn7jPyqngLiNh96
         igHjZ8TKVN2e2xQDd7pHeELmJKOPqBo/gYXXJPRXVsdlZBFwujavWR+bA+YkVqvY/M8E
         xiafLQkvUuEAFIkRuAHaQc3YSU7PAJiw0NjeujUUWeonnrpA4patIFL2eOziiAOc+jWH
         kG3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t4Hx7HuIToogFrpWvEndnhmu5FP0FfguH4MlN11vPPE=;
        b=uTSIIvGBHAFaAkb/3fPjnKv/W8K5cOBdpDXVZdqFhCvtjhlnjKz70FRYnfq8wSjOxi
         Ozirr9GYGvStgK/jf4Y06UsWMC7iTIcS6QkaizFr/W1KC9bJFhj8JRV6HD5Kbs0fv+Ha
         k0fvOOeoGMUGnkUeCxuw4Jf5xklEEOla4s+VSiEyYZllkTGO23W/TtXffCFvFvmgUVPZ
         u6NqVKeEqHS+ypFwePfMrgsNibhnWPZcQOsmNk1+AfbrgOIsAHo9u8GEuc2wLeSut18o
         1YtWSQ+etNCPvkwuAnTuEcVklFxlLb9LAnEvaBRYqiMboMG5gFZkr3mhQtMEIrW4lcbu
         q2Ww==
X-Gm-Message-State: AOAM532IbM5TMFUGE4VjEj7e3/SHW7+VstJ/p6QNmn246nKVKokGMhgc
	Z9HUtelGA40tuu+P2/VssCTnEoVOXQo0KuSSYhvAdg==
X-Google-Smtp-Source: ABdhPJxS3XiFOqFhrRKU/byzauaRUixVOrqI145+D91dRw4A1+NV2JaZOBZF6ul8S7Q+44ceN6tvuQAEuN2PR4AM+3Q=
X-Received: by 2002:a17:90b:3b88:: with SMTP id pc8mr317033pjb.93.1635372208848;
 Wed, 27 Oct 2021 15:03:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de> <20211018044054.1779424-4-hch@lst.de>
In-Reply-To: <20211018044054.1779424-4-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Oct 2021 15:03:17 -0700
Message-ID: <CAPcyv4iM4RjrQj4Q4i+tXmq1QMC=_dy0TTCzvxqRc_miv40NGg@mail.gmail.com>
Subject: Re: [PATCH 03/11] dax: simplify the dax_device <-> gendisk association
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Replace the dax_host_hash with an xarray indexed by the pointer value
> of the gendisk, and require explicitl calls from the block drivers that

s/explicitl/explicitl/

I've fixed that up locally.

> want to associate their gendisk with a dax_device.

This looks good. 0day-robot is now chewing on it via the test merge
with linux-next (libnvdimm-pending).
