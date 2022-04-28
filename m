Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF93D7B
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 00:26:48 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id k14so2711940pga.0
        for <nvdimm@lists.linux.dev>; Wed, 27 Apr 2022 17:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MRuUNJV7gX0xYtM2Tpo1ftLBP5+GxruFiS3PUjERGmY=;
        b=glua9KfzaoM/vK2bmaMhx4Yx1qqfS9oorXu7lu2qg0ubY5HiAx7R3h4JSMYAZuzfAx
         GEm4t254ol4fJkiKYJphOCcCccMJ6JWsPOdvl7MEyL/E5h/c7oM0wU56OG0bJ2rEtoZ5
         78N3z5vZdS8Pgzb3ZFksPnJSYZ2uFJHP6smKAVP0INbQ2yW6I755b8ORIfwZZLoEBpTh
         7QipFTs5o0lFsRTRGNTF4CbXRG26tDruJiXoJU+HEGJeufJ4yxeCKb6RL5TZJwkgmcbN
         GA4Zz+6lWMTAfgXBfCxN/77H0/90HZCnAmK7z2hPHxhwHFrs8lPUGqmEHULSpqGj1nb/
         L2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MRuUNJV7gX0xYtM2Tpo1ftLBP5+GxruFiS3PUjERGmY=;
        b=AwZ5dK3CMsv9K8lsFgJNKZ3mgWF3xtwDX0e8SBF20ZuLnxWgCUV8m7DgkfCd2iPUTZ
         JYozGO57+y/aSpv7CGYiLscXOVpY+GAxFsYF0wMfuNHiS3VKM79zgKxoWA5XvxMlNqb1
         KbYdTtyiAQ7z0Nw1tQ+S1nBrr5kSfN0EFaTceK0hZW2CJp5bz/UN4xfLuUiAECsS4bd6
         YsEzys2GzmS6wKL3FPD9jTv9bnaZ3/922onptqilEHh/qTZ3Bg79atkjsKzIru7d6asW
         jjl3irBL6Iq5lCIfYWQBBlJ2i/M//vBFeD179qa2aSKojrd77hYSj+WhIty0Q80wXuOY
         M8sA==
X-Gm-Message-State: AOAM5337SQ/aM4etNerW2SkvOLTnT2MmgoeauYJKVV2Yq8Wdzj6fS6xW
	x2a8LctNXxpOvewNKXeJ4joY4nAYfxXMGI8Mqf2LU7qmicQ=
X-Google-Smtp-Source: ABdhPJyot/7q+y50FGo4fqvhm5bWnpopymk+1Pff4PrBGOWRUbRwrGuIbaMp5cqsCddc4fqMDni6TgL6u4ly9ElR864=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr25832886pgb.74.1651105608074; Wed, 27
 Apr 2022 17:26:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <PH0PR18MB50713BB676BBFCBAD8C1C05BA9FB9@PH0PR18MB5071.namprd18.prod.outlook.com>
 <CAPcyv4hGWAHBth+yF4DoEuyZN-O3-Tsfy4BU9PCyoTwaY-kKWw@mail.gmail.com>
 <PH0PR18MB50716D0F3A25CD25F8ED463BA9FA9@PH0PR18MB5071.namprd18.prod.outlook.com>
 <CAPcyv4hnj8zeLqZWXRkhVUovFKR-sj5X=P5WM=vwXxjc7qL64w@mail.gmail.com> <PH0PR18MB507124A7660C21A147B30AE1A9FA9@PH0PR18MB5071.namprd18.prod.outlook.com>
In-Reply-To: <PH0PR18MB507124A7660C21A147B30AE1A9FA9@PH0PR18MB5071.namprd18.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Apr 2022 17:26:37 -0700
Message-ID: <CAPcyv4gtnFQd46BH=Ng=3sL-yn9ctXrjwtThCFQ-AAo9DeO93A@mail.gmail.com>
Subject: Re: How to map my PCIe memory as a devdax device (/dev/daxX.Y)
To: An Sarpal <ansrk2001@hotmail.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 27, 2022 at 2:34 PM An Sarpal <ansrk2001@hotmail.com> wrote:
>
> Dan, thank you very much for the reply. I appreciate your time on this.
>
> I talked to my application developer and he said that he can work around the lack of coherency that you identified.

Best of luck.

>
> I was under the impression that PCIe memory physical ranges were always mapped as UC which obviously implies that they are not cacheable but I guess I am wrong there.

Not if you use memmap= to hack the memory map, that interface is
"garbage in / garbage out" from a safety perspective.

>
> With that said, I still would like to create a /dev/daxX.Y character device that would map to the PCIe BAR range.
>
> I am using driver/dax/device.c as my prototype.
> a) I added memmap=X@Y to the kernel command line. When I rebooted the kernel, I see /dev/pmem0. So far so good.
>               Ndctl list shows this memory with namespace0.0
> b) I then ran ndctl create namespace with --mode=devdax to convert from fsdax to devdax and noticed that the probe() routine in device.c was invoked as I expected.
>
> Now in my driver, I only have my PCIe function probe() routine. I was wondering if there is an obvious way for me to make this work just like PMEM (memmap).

No, the obscurity of APIs for this is deliberate. It's broken outside
of controlled scenarios, not something Linux will ever support in the
general case. See the CXL specification for the hardware capability
required to support memory over PCIe electricals.

>
> There is a lot of functionality provided in other source files of drivers/dax and it all seems to depend on having that namespace created and lots of initialization being done.
>
> I was wondering if there is an easier way for me to attach a struct dev_dax to my own pcie functionality. It does not look like there is an easy way but wanted to check with you

Correct, I do not have any recommendations to offer here.
