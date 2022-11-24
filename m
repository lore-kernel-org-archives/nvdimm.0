Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B741723AE
	for <nvdimm@lists.linux.dev>; Thu, 24 Nov 2022 10:20:38 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id 5so958389wmo.1
        for <nvdimm@lists.linux.dev>; Thu, 24 Nov 2022 02:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rnU65IZVW7Ew6pXFCL1FtPt2utdOW4krxPUWMRLq6dI=;
        b=EgMvq8mHE7e9oJjxfwGGMI0X6RsU/hnpmrya0a46qA+IRz44kL+ygVKseMw8/tu+kf
         DrbXwSab0lsyvQKswhXK9kEI+f8Yq976XJcnaE2mLQ5o04rud4i9rmG5x0YaK+CtFA6Z
         uYSl3zKMTyIjQ1p7tiU1NHMqCHbKfOStQ/C0CimShiFhTItfIU5CrnCZoWkElSV7F4N/
         hCx1YHbGHZvwycPG31H0Q5MX1Auvf7cou9SgYnu9dMyiiD1hPP4kWtO3eC6kGaB6E3X3
         HfAsALjTF+NQjuVHCOtm5FlQ4WtwNFgIrXNZW2p91GOkQzUVhH0pe+uBCw7esVsEcrt3
         ZFJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rnU65IZVW7Ew6pXFCL1FtPt2utdOW4krxPUWMRLq6dI=;
        b=o8kk+O6T4Ia0aw41LZc4ipRJLlenQi3jl+RfLhmd1HoOgTPl29KQ8HFHcTEZNn5XW8
         ZY4jFWh7jCCnryeIWYb/wvDXz7N/deY8shNVzjfn9Kfpapeq941/eaEBQu37ozsJld3k
         Hp1Vc3a0K1eawon02Z9iCHDuqZzcwujim1pk0P6i49juWC9VZBD+2IbYzWvg2XfoSVlI
         4bY29PUdhPjvYsHneVZAa/NJ9kmnfYtgAu6+HbogTuGKWDrDKhvY974DbAaieSsX45FJ
         /Ntjv045W+OU06BZbAAPbEQB4ppMYgHg2WT3hwCPg6ZqErrkhsd7DUiTre2HiDyMIrBS
         XUug==
X-Gm-Message-State: ANoB5pn2ES8TTKLC7W1+aZ6PEroF7dHEW5mcJ6+EY6ZvkVN/ekyCkylm
	yEBHJ6L/+bQxJ1ycBt/Rk3U=
X-Google-Smtp-Source: AA0mqf7ia4WrQ4g+SdUZVhm18xb1EDYT2SKib81dQozI+h18g4Sgieac0ayfG6ouLIMxwe3cUPnzOw==
X-Received: by 2002:a05:600c:3107:b0:3c6:e1b5:71c2 with SMTP id g7-20020a05600c310700b003c6e1b571c2mr9475161wmo.94.1669285236811;
        Thu, 24 Nov 2022 02:20:36 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id y7-20020a1c4b07000000b003b4c979e6bcsm4940983wma.10.2022.11.24.02.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 02:20:36 -0800 (PST)
Date: Thu, 24 Nov 2022 13:20:30 +0300
From: Dan Carpenter <error27@gmail.com>
To: dan.j.williams@intel.com
Cc: nvdimm@lists.linux.dev
Subject: [bug report] libnvdimm: fix mishandled nvdimm_clear_poison() return
 value
Message-ID: <Y39FbkGEvQ8TcS1d@kili>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Dan Williams,

The patch 868f036fee4b: "libnvdimm: fix mishandled
nvdimm_clear_poison() return value" from Dec 16, 2016, leads to the
following Smatch static checker warnings:

    drivers/nvdimm/claim.c:287 nsio_rw_bytes() warn:
    replace divide condition 'cleared / 512' with 'cleared >= 512'

    drivers/nvdimm/bus.c:210 nvdimm_account_cleared_poison() warn:
    replace divide condition 'cleared / 512' with 'cleared >= 512'

drivers/nvdimm/claim.c
    252 static int nsio_rw_bytes(struct nd_namespace_common *ndns,
    253                 resource_size_t offset, void *buf, size_t size, int rw,
    254                 unsigned long flags)
    255 {
    256         struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
    257         unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
    258         sector_t sector = offset >> 9;
    259         int rc = 0, ret = 0;
    260 
    261         if (unlikely(!size))
    262                 return 0;
    263 
    264         if (unlikely(offset + size > nsio->size)) {
    265                 dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
    266                 return -EFAULT;
    267         }
    268 
    269         if (rw == READ) {
    270                 if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align)))
    271                         return -EIO;
    272                 if (copy_mc_to_kernel(buf, nsio->addr + offset, size) != 0)
    273                         return -EIO;
    274                 return 0;
    275         }
    276 
    277         if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
    278                 if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)
    279                                 && !(flags & NVDIMM_IO_ATOMIC)) {
    280                         long cleared;
    281 
    282                         might_sleep();
    283                         cleared = nvdimm_clear_poison(&ndns->dev,
    284                                         nsio->res.start + offset, size);
    285                         if (cleared < size)
    286                                 rc = -EIO;
--> 287                         if (cleared > 0 && cleared / 512) {
                                                   ^^^^^^^^^^^^^
Smatch suggests changing this to "&& cleared >= 512" but it doesn't make
sense to say if (cleared > 0 && cleared >= 512) {.  Probably what was
instead intended was "if (cleared > 0 && (cleared % 512) == 0) {"?

    288                                 cleared /= 512;
    289                                 badblocks_clear(&nsio->bb, sector, cleared);
    290                         }
    291                         arch_invalidate_pmem(nsio->addr + offset, size);
    292                 } else
    293                         rc = -EIO;
    294         }
    295 
    296         memcpy_flushcache(nsio->addr + offset, buf, size);
    297         ret = nvdimm_flush(to_nd_region(ndns->dev.parent), NULL);
    298         if (ret)
    299                 rc = ret;
    300 
    301         return rc;
    302 }

regards,
dan carpenter
