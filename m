Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F76D33F4
	for <nvdimm@lists.linux.dev>; Fri, 13 May 2022 18:12:06 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id v10so8182104pgl.11
        for <nvdimm@lists.linux.dev>; Fri, 13 May 2022 11:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AQHNxzNN414eZp8P189ZQ6BtznoGX5WzFgyhmUmhxLc=;
        b=odZNRcN5j4TFvOlaSHEOke8UXoaaeuQMj/QZVnDc1RjArDcmwin7yOp62lRiJUZV0h
         EaAFTkr9ucGwiLskefzyRnxJZMCfso6OLkShGPnRaxHsee9R5W/FwC5lZVFXENH6o3XT
         Blfo2p6sADNDei77jX42SqyGT2oLegFgTu0cY7mhybidTQE0dksSt4XL1giF9VAKxvrU
         vykmGqhSIHk+yfie8s8NjTVSnSit/xTybzT08Y4sQEgVtsbh+spdRPQdkDAdOOPeZ4hv
         cNMKj7pHnKxMP/Xl6EV2JEKBnTFpI1p7XSTneeee1zc0qxsQaOeGqYPeviOdMzPWFBi6
         8LRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AQHNxzNN414eZp8P189ZQ6BtznoGX5WzFgyhmUmhxLc=;
        b=3VRGIkTb+4sZ6Pxv5im/FcCezlP65t/ZqpNRm5qtFbpQGXpJdUHl1JQyuoc2kbfzfU
         s+CLBzSak9rrTjpZ0kYi7WHx8/9dbdvYMUPrm6SdXGzvyYi+WQ02Nua/+MIwd8f1UEyj
         6SNAFtIOKNx8ZM0vOWTDqpuEvUhsEM79IxZLu40pI4FE4nOVNark1f7bYBc2QH3eJ2Jv
         yN+ezQWBnb5kMjXBC0T9VS1N3Kg6nV8rD5s0s3xxhPH2LP4TllPrn5PlbCQskmU8T92Q
         /NF0+U8sH9PC229ZnS04VKo+7fJIXuGLS8NwSCx8HcDqLlr7KybLGuzyiVFwPn2FJ6hd
         Z7fg==
X-Gm-Message-State: AOAM532r6deD73ga9tYx830vRm/vsCJmOLeCDzg0GsgYmcJcPmNXemLa
	HYpQK/VDqn1CD0T7koncRr5Y/DXns0V5MyQ3K14WHw==
X-Google-Smtp-Source: ABdhPJwYfPvjPhgQeYlMo89pHw9G6as3ItD4LgAIfvWf6lLd6SHCK76GOftM4u8dqAJmgMLNuK1o7A4ZlM0BAINTIMI=
X-Received: by 2002:a05:6a00:84e:b0:510:5fbc:7738 with SMTP id
 q14-20020a056a00084e00b005105fbc7738mr5928110pfk.86.1652465525671; Fri, 13
 May 2022 11:12:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <202205132332.jwmddrYX-lkp@intel.com>
In-Reply-To: <202205132332.jwmddrYX-lkp@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 May 2022 11:11:54 -0700
Message-ID: <CAPcyv4j8kh_1qNPg9AN6sgWBCvVrToX-6_YirzVt4_f6aM4FVw@mail.gmail.com>
Subject: Re: [nvdimm:libnvdimm-for-next 8/11] fs/fuse/virtio_fs.c:775:58:
 error: incompatible type for argument 4 of 'dax_direct_access'
To: kernel test robot <lkp@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>, kbuild-all@lists.01.org, 
	Christoph Hellwig <hch@lst.de>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

[ fix the nvdimm mailing list address ]


On Fri, May 13, 2022 at 8:45 AM kernel test robot <lkp@intel.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
> head:   866f841d312b95a3a0b2de104e8d9c02006e7953
> commit: 4676339a70746434e1acb678ffaea164d24dfc9c [8/11] dax: introduce DAX_RECOVERY_WRITE dax access mode
> config: x86_64-randconfig-a011 (https://download.01.org/0day-ci/archive/20220513/202205132332.jwmddrYX-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
> reproduce (this is a W=1 build):
>         # https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/commit/?id=4676339a70746434e1acb678ffaea164d24dfc9c
>         git remote add nvdimm https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git
>         git fetch --no-tags nvdimm libnvdimm-for-next
>         git checkout 4676339a70746434e1acb678ffaea164d24dfc9c
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash fs/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    fs/fuse/virtio_fs.c: In function 'virtio_fs_zero_page_range':
> >> fs/fuse/virtio_fs.c:775:58: error: incompatible type for argument 4 of 'dax_direct_access'
>      775 |         rc = dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
>          |                                                          ^~~~~~
>          |                                                          |
>          |                                                          void **

Jane? Looks like we all missed this conversion during the review. Can
you send an incremental fixup? For now I have re-wound the branch that
feeds into -next to drop this commit.
