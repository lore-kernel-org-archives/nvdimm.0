Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCB96106
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 14:28:59 +0000 (UTC)
Received: by mail-ot1-f52.google.com with SMTP id 94-20020a9d0067000000b0066c8d13a33dso10477271ota.12
        for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 06:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dW+j6vlBeIXuiItzPahHl5X8Hwnl4fG3Q+o+UI0piaY=;
        b=Yccn5EL+fuE5Ekgmdm/U+eFMQrvXsX0/bs3Fe3602EwJ9SDTAL4Rpl3DgHdIg9bGCP
         LOtwUJuSuy8arCkhsGnhDznVzvXcALniFn2X+Aknx7mmyKqMKGni0B7fjHb7C5qfPqqJ
         G5cKLXleGdvznZ1ASi8SmlpsGP84cecrM1Fwsw4DdZSeXyNZe0lS5+YvAGMihskNnN6Q
         Xg5sUOnjiaEPWSpIW6+FBTrIIoMIcXOTDI45qBPKxBAsOwBoL+mJMMY1NuiqCqCpWG8b
         eTIxZnXCBFn6gC3MPyAuYmye6c7E7uh22yLNVU35Q9S65eM7bKfJ/bpW8jhR/3T0Ysm/
         doFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dW+j6vlBeIXuiItzPahHl5X8Hwnl4fG3Q+o+UI0piaY=;
        b=K4E7LoZqBrgFTG4Ta+avL00seYfsbkcSzY91QoJD2Iav8Ik6TzJZ/eZcUUye7f0rOM
         FfF1onxroLX/vcSG2XG9MUNep73cFZdjUxlHmq4Jac/1rt0hoEPbmcM+vJvAHolpJeAV
         QaYDc+Aew54ahbF2IlS8YrDheVfOZ/ISH2PMfuxAgzTCR1KDbieYnPQnvrqgbcaXcD6E
         2sk8Am7VJZpfVkUQdYtnjXMr6btmaNzMwXq+J+rjCNHHo3Jze5sWH7AtzXnKgvJzzQsM
         jJQ0WyaxnJ7YPQOdNBJIUBQRi+v65gxIBD6buMG8i0kTQw7Hf694JIcgnBDnKjtM9lAb
         NqKg==
X-Gm-Message-State: ANoB5plq1PqiBHZ0U9SBfxnw6OYhZn8ow9yldvvuFN1zqMTvUPKu56t5
	UflOfxJ2qcEOpk5igHXrpY5sS/Nxboc9q/DDsv0=
X-Google-Smtp-Source: AA0mqf5yDqnDExppw74B0AFVkl99kubkthLQ2UtoLeQJpUu3tMAU43IHh3d3g8VXFgrD4JTJWiHJgXT4QpIOGbopB0s=
X-Received: by 2002:a9d:2483:0:b0:661:9fdf:fd7e with SMTP id
 z3-20020a9d2483000000b006619fdffd7emr10857351ota.250.1668608938634; Wed, 16
 Nov 2022 06:28:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221017171118.1588820-1-sammler@google.com> <CAM9Jb+ggq5L9XZZHhfA98XDO+P=8y-mT+ct0JFAtXRbsCuORsA@mail.gmail.com>
 <CAFPP518-gU1M1XcHMHgpx=ZPPkSyjPmfOK6D+wM6t6vM6Ve6XQ@mail.gmail.com>
 <CAM9Jb+hk0ZRtXnF+WVj0LiRiO7uH-jDydJrnUQ_57yTEcs--Dw@mail.gmail.com>
 <6359ab83d6e4d_4da3294d0@dwillia2-xfh.jf.intel.com.notmuch>
 <CAHS8izOYYV+dz3vPdbkipt1i1XAU-mvJOn6c_z-NJJwzUtWzDg@mail.gmail.com>
 <CAM9Jb+j3MDq_HpaZXYaMWmc4OhXob9hQiLLeSvaJfGa2LoPBDw@mail.gmail.com> <CAHS8izNgmwjwyTyFzXWKrM==nTO0CJEW3+mUoKmtYjPushL5-g@mail.gmail.com>
In-Reply-To: <CAHS8izNgmwjwyTyFzXWKrM==nTO0CJEW3+mUoKmtYjPushL5-g@mail.gmail.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Wed, 16 Nov 2022 15:28:46 +0100
Message-ID: <CAM9Jb+heC0nu6P+Pt-kH46Q0W3YSJvcV8VMgLCDSC7a8h6h7dg@mail.gmail.com>
Subject: Re: [PATCH v1] virtio_pmem: populate numa information
To: Mina Almasry <almasrymina@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Michael Sammler <sammler@google.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> > > > > > > > Compute the numa information for a virtio_pmem device from the memory
> > > > > > > > range of the device. Previously, the target_node was always 0 since
> > > > > > > > the ndr_desc.target_node field was never explicitly set. The code for
> > > > > > > > computing the numa node is taken from cxl_pmem_region_probe in
> > > > > > > > drivers/cxl/pmem.c.
> > > > > > > >
> > > > > > > > Signed-off-by: Michael Sammler <sammler@google.com>
> > >
> > > Tested-by: Mina Almasry <almasrymina@google.com>
> > >
> > > I don't have much expertise on this driver, but with the help of this
> > > patch I was able to get memory tiering [1] emulation going on qemu. As
> > > far as I know there is no alternative to this emulation, and so I
> > > would love to see this or equivalent merged, if possible.
> > >
> > > This is what I have going to get memory tiering emulation:
> > >
> > > In qemu, added these configs:
> > >       -object memory-backend-file,id=m4,share=on,mem-path="$path_to_virtio_pmem_file",size=2G
> > > \
> > >       -smp 2,sockets=2,maxcpus=2  \
> > >       -numa node,nodeid=0,memdev=m0 \
> > >       -numa node,nodeid=1,memdev=m1 \
> > >       -numa node,nodeid=2,memdev=m2,initiator=0 \
> > >       -numa node,nodeid=3,initiator=0 \
> > >       -device virtio-pmem-pci,memdev=m4,id=nvdimm1 \
> > >
> > > On boot, ran these commands:
> > >     ndctl_static create-namespace -e namespace0.0 -m devdax -f 1&> /dev/null
> > >     echo dax0.0 > /sys/bus/dax/drivers/device_dax/unbind
> > >     echo dax0.0 > /sys/bus/dax/drivers/kmem/new_id
> > >     for i in `ls /sys/devices/system/memory/`; do
> > >       state=$(cat "/sys/devices/system/memory/$i/state" 2&>/dev/null)
> > >       if [ "$state" == "offline" ]; then
> > >         echo online_movable > "/sys/devices/system/memory/$i/state"
> > >       fi
> > >     done
> >
> > Nice to see the way to handle the virtio-pmem device memory through kmem driver
> > and online the corresponding memory blocks to 'zone_movable'.
> >
> > This also opens way to use this memory range directly irrespective of attached
> > block device. Of course there won't be any persistent data guarantee. But good
> > way to simulate memory tiering inside guest as demonstrated below.
> > >
> > > Without this CL, I see the memory onlined in node 0 always, and is not
> > > a separate memory tier. With this CL and qemu configs, the memory is
> > > onlined in node 3 and is set as a separate memory tier, which enables
> > > qemu-based development:
> > >
> > > ==> /sys/devices/virtual/memory_tiering/memory_tier22/nodelist <==
> > > 3
> > > ==> /sys/devices/virtual/memory_tiering/memory_tier4/nodelist <==
> > > 0-2
> > >
> > > AFAIK there is no alternative to enabling memory tiering emulation in
> > > qemu, and would love to see this or equivalent merged, if possible.
> >
> > Just wondering if Qemu vNVDIMM device can also achieve this?
> >
>
> I spent a few minutes on this. Please note I'm really not familiar
> with these drivers, but as far as I can tell the qemu vNVDIMM device
> has the same problem and needs a similar fix to this to what Michael
> did here. What I did with vNVDIMM qemu device:
>
> - Added these qemu configs:
>       -object memory-backend-file,id=m4,share=on,mem-path=./hello,size=2G,readonly=off
> \
>       -device nvdimm,id=nvdimm1,memdev=m4,unarmed=off \
>
> - Ran the same commands in my previous email (they seem to apply to
> the vNVDIMM device without modification):
>     ndctl_static create-namespace -e namespace0.0 -m devdax -f 1&> /dev/null
>     echo dax0.0 > /sys/bus/dax/drivers/device_dax/unbind
>     echo dax0.0 > /sys/bus/dax/drivers/kmem/new_id
>     for i in `ls /sys/devices/system/memory/`; do
>       state=$(cat "/sys/devices/system/memory/$i/state" 2&>/dev/null)
>       if [ "$state" == "offline" ]; then
>         echo online_movable > "/sys/devices/system/memory/$i/state"
>       fi
>     done
>
> I see the memory from the vNVDIMM device get onlined on node0, and is
> not detected as a separate memory tier. I suspect that driver needs a
> similar fix to this one.

Thanks for trying. It seems vNVDIMM device already has an option to provide
the target node[1].

[1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg827765.html
