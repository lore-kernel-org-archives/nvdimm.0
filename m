Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C80672
	for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 23:36:16 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id h3-20020a17090a580300b0019ce70f8243so617989pji.4
        for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 16:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IBRyYiFkqDi2caQiqujCQacHdwzqbQqJJTWz3cL4aYc=;
        b=u+hPjgHDtGIWQ8TWndPhOSqYbZzX6zjEaCWa3k/TRAtGNz3tYxhw9vJNCz2mGZpCI6
         MZXTeit42TdmYTb65kQT6Uo4b9spmeo1nbCStCKhL95EetHFKY+SXYY3nWet4NiDae0E
         wkyiHkn4y+irZdIImkHjRpQI1UiZ66jQDuBs0IlduZDJps5kt5uui8nHeOhqAEIWXCKE
         +SrP33uMT/bYtcVOtvWMWjNwO7ulp65R0hK/0wvK397QnRVARAm3aF0pzeD4ABhmxrr2
         whj4G9nTeVhj+mN4sa+0xAZQFXUFYJvZQ9EIJ2b5rv8DKQUj5uQ2F5RPMbNKoTtl9prY
         6KiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IBRyYiFkqDi2caQiqujCQacHdwzqbQqJJTWz3cL4aYc=;
        b=bAThHcOiPyuaYmzu2PE4051LZQl2s4fRvN9tcUz3I3iX2nsDCw3rnfAccLWpWSFo8u
         0RfSrVMKlLKXb7b76EP+xh0DdXhFcrGw+YWfhb3xzxhwWVdzbtMaiaF+v/0qyPpSYlD0
         QzXW88cD74Fua840PCQ90fCL2hqR9OsB24nHdxfzGPfUaZv77b/ijKkybzUJl0oFv7aK
         2s3MRDDogLhGEM/SpkFcFqWLSf6WgD1VLMLLXWABvFwZ2gqmwjdlYNhRkkr7z2dDUxI2
         ZCik+HK47AhLfCVCZ1xe9BtI4ZcGeSLvfVXro/PIC8OmQS61ArQyaSoMvnSNyEGNcloW
         sOCw==
X-Gm-Message-State: AOAM532MZ1zCFCPCPIyaXyE8BWVlURM1cczwDnWJeMklfMun1REPHxHN
	AXUCUVavDGx6mjzHxSlkb656ov+DxaWgYVIBqWoOFg==
X-Google-Smtp-Source: ABdhPJwRKj0qu9RA5olCLKgAzMQU9EQvIzxEKw48Hu/LzbfLKZ72sH6hS8OKB+ZUBqbRq1PcxhFMZNagZ2HuHUCYOds=
X-Received: by 2002:a17:90a:d686:: with SMTP id x6mr1793440pju.8.1632180976495;
 Mon, 20 Sep 2021 16:36:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210920072726.1159572-1-hch@lst.de> <20210920072726.1159572-3-hch@lst.de>
 <20210920225125.GY3169279@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20210920225125.GY3169279@iweiny-DESK2.sc.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 20 Sep 2021 16:36:05 -0700
Message-ID: <CAPcyv4jn=HJRSMKPCFZzHmMoWD2x2EGjWr0O8mB63RFHj_jDvg@mail.gmail.com>
Subject: Re: [PATCH 2/3] nvdimm/pmem: move dax_attribute_group from dax to pmem
To: Ira Weiny <ira.weiny@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, linux-block@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 20, 2021 at 3:51 PM Ira Weiny <ira.weiny@intel.com> wrote:
>
> On Mon, Sep 20, 2021 at 09:27:25AM +0200, Christoph Hellwig wrote:
>
> ...
>
> > diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> > index ef4950f808326..bbeb3f46db157 100644
> > --- a/drivers/nvdimm/pmem.c
> > +++ b/drivers/nvdimm/pmem.c
> > @@ -328,6 +328,49 @@ static const struct dax_operations pmem_dax_ops = {
> >       .zero_page_range = pmem_dax_zero_page_range,
> >  };
> >
> > +static ssize_t write_cache_show(struct device *dev,
> > +             struct device_attribute *attr, char *buf)
> > +{
> > +     struct pmem_device *pmem = dev_to_disk(dev)->private_data;
>
> I want to say this should be dax_get_private()...  However, looking at the use

No, this wants to do from @dev to @dax_dev. dax_get_private() assumes
that @dax_dev is already known. Also, in this case @dev is the gendisk
device, so this is a gendisk-to-dax-device with special knowledge that
the gendisk is for a pmem device.

> of dax_get_private() not a single caller checks for NULL!  :-(

All the callers are correctly assuming that their usage is before kill_dax().

>
> So now I wonder why dax_get_private() exists...  :-/

It exists so that the definition of 'struct dax_device' can remain
private, as no one should be directly mucking with dax_device
internals outside of the provided APIs.

> A quick history search does not make anything apparent.  When the DAXDEV_ALIVE
> check was added to dax_get_private() no callers were changed to account for a
> potential NULL return.
>
> Dan?

I double checked, but this all looks ok to me.
