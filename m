Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771D72C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 17:09:48 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id k4so8282993plx.8
        for <nvdimm@lists.linux.dev>; Thu, 04 Nov 2021 10:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lNyydAPmThKRUdg31x+k+COmC1bbnlFs2j6MKupn5YY=;
        b=plizExIT/KNqOnpA/SM7imsDwzcb0bMCx9vve9EIJ4izfCxz9A8/Kpi5fUDBWSYcRR
         j76iA/o4iw/8l6PjvfZbMr7MLGSujIVEH+W/SPjMkk+sXAW3BdE7L7Oc+eRjg3FdKFMh
         2X+gt/N5cQiuU0760BIbgm1bRywFVE76O8AACnifjgpOAHfqvOm/trVKWPtKy5SJ06PI
         WKGnHDJVd0YsK6V5ycX7amQUkcSoWA6VB/VraXzysYKpySziVUNzETSmHRPSi87CGEZR
         9uR4kXVP8++fHVkmz86WLxttzJvdl121qWAzFn0pXHDvDAzSAPaBE2zCFbxfiOhxUHBW
         MCfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lNyydAPmThKRUdg31x+k+COmC1bbnlFs2j6MKupn5YY=;
        b=ssjWKfcUsBo3ZpeIXkToitcajKz7byWLtBr16dTu92x6jL35tF02x7mTP0bEMqzZec
         sMwe3svms1qTOSyFEdk5k8Tv4NNfOYKfzwA27HVfVlXP4y+1UbYzJCyTViJPA6ITwuz8
         FJxN70SsVgUjanSbtSjDXklSPC/I+wo8EH5xAuJAab1FAaqldCrkB+ZdWjSfwxPGM6qQ
         t07HIeqt3gwVBBzO5QYowgZqN+Fe/hLg9fVJCw2xnIgqcnFDgGrYh7A1QKIeok5uQ+Rk
         SsGkpetSYahI6IIC/uiSZuhRPfI1JRdmFAEjOKoLqEAg9ry+ALZPBV7ql8KEw3zUqv83
         ENDQ==
X-Gm-Message-State: AOAM531/ztetsglwCCwBmFXxpUqtFsM4wZtj80Rr0c3a7HqNufM+pMVG
	V4TOKFMVk2rvxYDLDv0t1WAHg3aZo7HJxcLV9xnXMmUGU8c=
X-Google-Smtp-Source: ABdhPJzJROFcqMbXIEouzfR1t7ILdq48fZofa+mIv5G11BQe+f4ZBUd/y0TEfWOAXfnSYXUSlyOmxJAQzNa1hS8RQvs=
X-Received: by 2002:a17:902:b697:b0:141:c7aa:e10f with SMTP id
 c23-20020a170902b69700b00141c7aae10fmr33140673pls.18.1636045787934; Thu, 04
 Nov 2021 10:09:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YYOLRW7yx9IFn9mG@infradead.org> <CAPcyv4hU+dFYc3fXnGhBPAsid03yFYZSym_sTBjHeUUrt6s5gQ@mail.gmail.com>
 <YYQEfxpVlxWjXgAU@infradead.org>
In-Reply-To: <YYQEfxpVlxWjXgAU@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 10:09:37 -0700
Message-ID: <CAPcyv4hZ1+pEd0A1y2oqSsMjCh2phJxukBB8ZBwbN0ax-Gni9Q@mail.gmail.com>
Subject: Re: qemu-emulated nfit devices disappeared
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 4, 2021 at 9:04 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Nov 04, 2021 at 09:00:01AM -0700, Dan Williams wrote:
> > > Any idea what might be missing in the attached config?  This seems to
> > > be independent of the tested kernel version (5.14, 5.15, master).
> >
> > Can you share your qemu command line
>
> qemu-system-x86_64 -enable-kvm \
>         -machine pc,nvdimm=on \
>         -m 4096,slots=8,maxmem=32G \
>         -smp 4 \
>         -kernel arch/x86/boot/bzImage \
>         -append "root=/dev/vda1 console=ttyS0,115200n8" \
>         -nographic \
>         -drive if=virtio,file=/home/hch/images/jessie.img,cache=none \
>         -object memory-backend-file,id=mem0,mem-path=/home/hch/images/test.img,share=yes,prealloc=no,align=128M,size=10G \
>         -device nvdimm,id=nvdimm0,memdev=mem0,slot=0,label-size=2M \
>         -object memory-backend-file,id=mem1,mem-path=/home/hch/images/scratch.img,share=yes,prealloc=no,align=128M,size=10G \
>         -device nvdimm,id=nvdimm1,memdev=mem1,slot=1,label-size=2M \
>
>
> > and the output of:
> >
> > ndctl list -vvv
>
>
> [
>   {
>     "provider":"ACPI.NFIT",
>     "dev":"ndbus0",
>     "dimms":[
>       {
>         "dev":"nmem1",
>         "id":"8680-57341200",
>         "handle":2,
>         "phys_id":0
>       },
>       {
>         "dev":"nmem0",
>         "id":"8680-56341200",
>         "handle":1,
>         "phys_id":0
>       }
>     ],
>     "regions":[
>       {
>         "dev":"region1",
>         "size":10603200512,
>         "available_size":10603200512,

Hmm, so the driver has 2 modes "labeled" and "label-less", in the
labeled mode it waits for an explicit:

    ndctl create-namespace

...to provision region capacity into a namespace. In label-less mode
it just assumes that the boundaries of the region are the boundaries
of the namespace. In this case it looks like the driver found a label
index block with no namespaces defined so it's waiting for one to be
created. Are you saying that the only thing you changed from a working
config with defined namespace to this one was a kernel change? I.e.
the content of those memory-backend files has not changed?


>         "max_available_extent":10603200512,
>         "type":"pmem",
>         "iset_id":52512795602891997,
>         "mappings":[
>           {
>             "dimm":"nmem1",
>             "offset":0,
>             "length":10603200512,
>             "position":0
>           }
>         ],
>         "persistence_domain":"unknown",
>         "namespaces":[
>           {
>             "dev":"namespace1.0",
>             "mode":"raw",
>             "size":0,
>             "uuid":"00000000-0000-0000-0000-000000000000",
>             "sector_size":512,
>             "state":"disabled"
>           }
>         ]
>       },
>       {
>         "dev":"region0",
>         "size":10603200512,
>         "available_size":10603200512,
>         "max_available_extent":10603200512,
>         "type":"pmem",
>         "iset_id":52512752653219036,
>         "mappings":[
>           {
>             "dimm":"nmem0",
>             "offset":0,
>             "length":10603200512,
>             "position":0
>           }
>         ],
>         "persistence_domain":"unknown",
>         "namespaces":[
>           {
>             "dev":"namespace0.0",
>             "mode":"raw",
>             "size":0,
>             "uuid":"00000000-0000-0000-0000-000000000000",
>             "sector_size":512,
>             "state":"disabled"
>           }
>         ]
>       }
>     ]
>   }
> ]
