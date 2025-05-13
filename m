Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6491991BF
	for <nvdimm@lists.linux.dev>; Tue, 13 May 2025 18:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747162526; cv=none; b=RAfB+WT9yOQ+uZRvnwhCTbU7/w9oRdI9Mnglrvk/hCvk0XiXsDPeM/pAFRSIrRaSvFhnh1grhHDlxuXijuLUUo+YErrqj50f+gDSaRFuRAYUQ82lLeYnsWsUN5h4r6p0ymYLlMzHBXH7gMNStK/0yXvrV9AuxSlo4vqSx6yS1f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747162526; c=relaxed/simple;
	bh=TTguu2JbGIVMAcxK9kEuwkfQx6NzLLY6u6wufqE0xJA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VNTnGVGROBG84+edcUc2AdaXHI0xx5yHhZ440zEstMIIM9pPGanHw0SdxkEyh5d/jz4jyZpypdHSuRGjaHsQCIF4wIccz45AEb7KQcgCk80mVJtBu8xg2iNOCcRBvscbWipf/j2XiwiBGqm2+yWjuEY16bJSVVavocH/RvOhdHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KkraQibb; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KkraQibb"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7423fadbe77so4551733b3a.3
        for <nvdimm@lists.linux.dev>; Tue, 13 May 2025 11:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747162523; x=1747767323; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Yk2y5YGo2DOU0RNvY2gdG/DmHVLPW3IlR/rIS3h+Kt0=;
        b=KkraQibb4U7CC/sNWtxNaOwTHqJKQRt8BitNhrp5IGqah5wadgyo7GerbEutkXdNXK
         D6psJAWNc/krApLZZleDDtoKTAiDZpoRMvh5vIQOjQiYBuPV6mz7Wp3781bu+y62/MQW
         QAUH1SmxW5K62E0bxifvkpDDIx4zcDSPVyMUk50HMQ94bWe65X1Om+mb6M7FFQwrZS2I
         WD4pYtnKMOApXkHOMr+Zp8Vm5kMbXE1/eHy/apv5NruT248BNNT1IDzDxFO/plwFjvfZ
         laLVKZVlWjEL8HW99rbHfJfv/b76+cNYTwiaEI6e4q0JTlwc0C+UWaeHZHYlO2MhxBK5
         /2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747162523; x=1747767323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yk2y5YGo2DOU0RNvY2gdG/DmHVLPW3IlR/rIS3h+Kt0=;
        b=OWrK3zKshP11UeXoN8ESzXA41ogRuFgCnb3NiALWY1uZFzGFIXPWAU+oE4flFTE+B2
         i+a0mMIVbyHYpHkUV62MJxsK0Sdg/H9WljyMSgZOuy6lPeup43TU0aMetbYQCJh2PaMm
         gOT+b6H6jxm1ziUe1GuG3uCrFg/Hx59W4L70ViXunSM4f00mmmsefr2Xn8LVM8pUyAUA
         mF5NasErERe9BKWzASC8i//rxdtHrgaZZw1kooOQxLKgygw2WH2XjbbELjPUNyun65MI
         8KguSP8T69uAthFoMKCp3IZK3kcUoEL3L08zh5ORfzA0ojQUbixNv0Mn3UoN/ETPQb13
         /AxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUflGUy633HxsI0q6f6O/Uod6ANLDGRPFLzn/UcFxdRMuD147eDpyC2t16C6HEOcoPF9XhJpI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwX1ajuyviEFz3uPT4Nr17DCRYeQSorZZTlMMMbvtk2bfV/KRK9
	yCxqlr0IC3osUQypc/a+m2IOMwhdR5hGetvV12JoVddITiHA22sn
X-Gm-Gg: ASbGncuc+hsts2FCOeDWsMO9LGmsXoEDToM/NDWRjmPiWtBJQRwEIc9Dp36M3SxBK6a
	ucfB5Ry8gpJhmjq8BkF8A++Vo5gbCFjB2Z6h4NCRwwOjegNQ/EdKAliW9KdvZt5uUMwYqI5RGW5
	46IPThDMVx/W6TinYGBKpXAwBjttsSi5N91bR9AWc2ohiFFV4Xq4elGOLhYjHtLt70HXywMTDGV
	TYdI/0GAgGhi4bRDO1PtkY5VPXu8f7O3yFoO8rymEqOXKx9Gt93OsFLAQ6qsP16EUZ1Nc9ZD6xS
	lbZtKw6PioJkpv6NvRSqhnTss+tBxa6QFqfCgpAZAcQNZJEoO+I851pP
X-Google-Smtp-Source: AGHT+IHLQwRReCgY7aIOeHAJHQYMI0cmXrzU8dOlD/MEy0lLlC2uKYx60wgDrNylciSFyZbiYMPCsA==
X-Received: by 2002:a17:903:120c:b0:215:8d49:e2a7 with SMTP id d9443c01a7336-231983e5c25mr5787055ad.50.1747162523433;
        Tue, 13 May 2025 11:55:23 -0700 (PDT)
Received: from debian ([2601:646:8f03:9fee:5e33:e006:dcd5:852d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82720a3sm84989285ad.149.2025.05.13.11.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 11:55:22 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Tue, 13 May 2025 11:55:20 -0700
To: Ira Weiny <ira.weiny@intel.com>
Cc: Fan Ni <nifan.cxl@gmail.com>, Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Li Ming <ming.li@zohomail.com>, anisa.su887@gmail.com
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <aCOVmOTerf9_XFyP@debian>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <Z_0v-iFQpWlgG7oT@debian>
 <67fdc64e3fa03_15df832946e@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67fdc64e3fa03_15df832946e@iweiny-mobl.notmuch>

On Mon, Apr 14, 2025 at 09:37:02PM -0500, Ira Weiny wrote:
> Fan Ni wrote:
> > On Sun, Apr 13, 2025 at 05:52:08PM -0500, Ira Weiny wrote:
> > > A git tree of this series can be found here:
> > > 
> > > 	https://github.com/weiny2/linux-kernel/tree/dcd-v6-2025-04-13
> > > 
> > > This is now based on 6.15-rc2.
> > > 
> > > Due to the stagnation of solid requirements for users of DCD I do not
> > > plan to rev this work in Q2 of 2025 and possibly beyond.
> > > 
> > > It is anticipated that this will support at least the initial
> > > implementation of DCD devices, if and when they appear in the ecosystem.
> > > The patch set should be reviewed with the limited set of functionality in
> > > mind.  Additional functionality can be added as devices support them.
> > > 
> > > It is strongly encouraged for individuals or companies wishing to bring
> > > DCD devices to market review this set with the customer use cases they
> > > have in mind.
> > 
> > Hi Ira,
> > thanks for sending it out.
> > 
> > I have not got a chance to check the code or test it extensively.
> > 
> > I tried to test one specific case and hit issue.
> > 
> > I tried to add some DC extents to the extent list on the device when the
> > VM is launched by hacking qemu like below,
> > 
> > diff --git a/hw/mem/cxl_type3.c b/hw/mem/cxl_type3.c
> > index 87fa308495..4049fc8dd9 100644
> > --- a/hw/mem/cxl_type3.c
> > +++ b/hw/mem/cxl_type3.c
> > @@ -826,6 +826,11 @@ static bool cxl_create_dc_regions(CXLType3Dev *ct3d, Error **errp)
> >      QTAILQ_INIT(&ct3d->dc.extents);
> >      QTAILQ_INIT(&ct3d->dc.extents_pending);
> >  
> > +    cxl_insert_extent_to_extent_list(&ct3d->dc.extents, 0,
> > +                                     CXL_CAPACITY_MULTIPLIER, NULL, 0);
> > +    ct3d->dc.total_extent_count = 1;
> > +    ct3_set_region_block_backed(ct3d, 0, CXL_CAPACITY_MULTIPLIER);
> > +
> >      return true;
> >  }
> > 
> > 
> > Then after the VM is launched, I tried to create a DC region with
> > commmand: cxl create-region -m mem0 -d decoder0.0 -s 1G -t
> > dynamic_ram_a.
> > 
> > It works fine. As you can see below, the region is created and the
> > extent is showing correctly.
> > 
> > root@debian:~# cxl list -r region0 -N
> > [
> >   {
> >     "region":"region0",
> >     "resource":79725330432,
> >     "size":1073741824,
> >     "interleave_ways":1,
> >     "interleave_granularity":256,
> >     "decode_state":"commit",
> >     "extents":[
> >       {
> >         "offset":0,
> >         "length":268435456,
> >         "uuid":"00000000-0000-0000-0000-000000000000"
> >       }
> >     ]
> >   }
> > ]
> > 
> > 
> > However, after that, I tried to create a dax device as below, it failed.
> > 
> > root@debian:~# daxctl create-device -r region0 -v
> > libdaxctl: __dax_regions_init: no dax regions found via: /sys/class/dax
> > error creating devices: No such device or address
> > created 0 devices
> > root@debian:~# 
> > 
> > root@debian:~# ls /sys/class/dax 
> > ls: cannot access '/sys/class/dax': No such file or directory
> 
> Have you update daxctl with cxl-cli?
> 
> I was confused by this lack of /sys/class/dax and checked with Vishal.  He
> says this is legacy.
> 
> I have /sys/bus/dax and that works fine for me with the latest daxctl
> built from the ndctl code I sent out:
> 
> https://github.com/weiny2/ndctl/tree/dcd-region3-2025-04-13
> 
> Could you build and use the executables from that version?
> 
> Ira

Hi Ira,
Here are more details about the issue and reasoning.


# ISSUE: No dax device created

## What we see: No Dax device is created after creating the dc region
<pre>
fan@smc-140338-bm01:~/cxl/linux-dcd$ cxl-tool.py --dcd-test mem0
Load cxl drivers first
ssh root@localhost -p 2024 "modprobe -a cxl_acpi cxl_core cxl_pci cxl_port cxl_mem"

Module                  Size  Used by
dax_pmem               12288  0
device_dax             16384  0
nd_pmem                24576  0
nd_btt                 28672  1 nd_pmem
dax                    57344  3 dax_pmem,device_dax,nd_pmem
cxl_pmu                28672  0
cxl_mem                12288  0
cxl_pmem               24576  0
libnvdimm             217088  4 cxl_pmem,dax_pmem,nd_btt,nd_pmem
cxl_pci                28672  0
cxl_acpi               24576  0
cxl_port               16384  0
cxl_core              368640  7 cxl_pmem,cxl_port,cxl_mem,cxl_pci,cxl_acpi,cxl_pmu
ssh root@localhost -p 2024 "cxl enable-memdev mem0"
cxl memdev: cmd_enable_memdev: enabled 1 mem
{
  "region":"region0",
  "resource":79725330432,
  "size":2147483648,
  "interleave_ways":1,
  "interleave_granularity":256,
  "decode_state":"commit",
  "mappings":[
    {
      "position":0,
      "memdev":"mem0",
      "decoder":"decoder2.0"
    }
  ]
}
cxl region: cmd_create_region: created 1 region
sn=3840
cxl-memdev0
sn=3840
Choose OP: 0: add, 1: release, 2: print extent, 9: exit
Choice: 9
Do you want to continue to create dax device for DC(Y/N):y
daxctl create-device -r region0
error creating devices: No such device or address
created 0 devices
daxctl list -r region0 -D

Create dax device failed
</pre>

## What caused the issue: Resources present before probing

<pre>
...
[   14.251500] cxl_core:cxl_region_probe:3571: cxl_region region0: config state: 0
[   14.254129] cxl_core:cxl_bus_probe:2087: cxl_region region0: probe: -6
[   14.256536] cxl_core:devm_cxl_add_region:2535: cxl_acpi ACPI0017:00: decoder0.0: created region0
[   14.281676] cxl_core:cxl_port_attach_region:1169: cxl region0: mem0:endpoint2 decoder2.0 add: mem0:decoder2.0 @ 0 next: none nr_eps: 1 nr_targets: 1
[   14.286254] cxl_core:cxl_port_attach_region:1169: cxl region0: pci0000:0c:port1 decoder1.0 add: mem0:decoder2.0 @ 0 next: mem0 nr_eps: 1 nr_targets: 1
[   14.290995] cxl_core:cxl_port_setup_targets:1489: cxl region0: pci0000:0c:port1 iw: 1 ig: 256
[   14.294161] cxl_core:cxl_port_setup_targets:1513: cxl region0: pci0000:0c:port1 target[0] = 0000:0c:00.0 for mem0:decoder2.0 @ 0
[   14.298209] cxl_core:cxl_calc_interleave_pos:1880: cxl_mem mem0: decoder:decoder2.0 parent:0000:0d:00.0 port:endpoint2 range:0x1290000000-0x130fffffff pos:0
[   14.303224] cxl_core:cxl_region_attach:2080: cxl decoder2.0: Test cxl_calc_interleave_pos(): success test_pos:0 cxled->pos:0
[   14.307522] cxl region0: Bypassing cpu_cache_invalidate_memregion() for testing!
[   14.319576] cxl_core:devm_cxl_add_dax_region:3251: cxl_region region0: region0: register dax_region0
[   14.322918] cxl_pci:__cxl_pci_mbox_send_cmd:263: cxl_pci 0000:0d:00.0: Sending command: 0x4801
[   14.326102] cxl_pci:cxl_pci_mbox_wait_for_doorbell:74: cxl_pci 0000:0d:00.0: Doorbell wait took 0ms
[   14.329523] cxl_core:__cxl_process_extent_list:1802: cxl_pci 0000:0d:00.0: Got extent list 0-0 of 1 generation Num:0
[   14.333141] cxl_core:__cxl_process_extent_list:1815: cxl_pci 0000:0d:00.0: Processing extent 0/1
[   14.336172] cxl_core:cxl_validate_extent:975: cxl_pci 0000:0d:00.0: DC extent DPA [range 0x0000000000000000-0x000000000fffffff] (DCR:[range 0x0000000000000000-0x000000007fffffff])(00000000-0000-0000-0000-000000000000)
[   14.342736] cxl_core:__cxl_dpa_to_region:2869: cxl decoder2.0: dpa:0x0 mapped in region:region0
[   14.345447] cxl_core:cxl_add_extent:460: cxl decoder2.0: Checking ED ([mem 0x00000000-0x7fffffff flags 0x80000200]) for extent [range 0x0000000000000000-0x000000000fffffff]
[   14.350198] cxl_core:cxl_add_extent:492: cxl decoder2.0: Add extent [range 0x0000000000000000-0x000000000fffffff] (00000000-0000-0000-0000-000000000000)
[   14.354574] cxl_core:online_region_extent:176:  extent0.0: region extent HPA [range 0x0000000000000000-0x000000000fffffff]
[   14.357876] cxl_core:cxlr_notify_extent:285: cxl dax_region0: Trying notify: type 0 HPA [range 0x0000000000000000-0x000000000fffffff]
[   14.361361] cxl_core:cxl_bus_probe:2087: cxl_region region0: probe: 0
[   14.395020] cxl dax_region0: Resources present before probing
...
</pre>

## Workaround (not a fix)

By chasing why the devres link list is not empty, or when add_dr() is called,
I located the code that caused the issue. The below hack is used to confirm
the issue is caused by the devm_add_action_or_reset() function call.

<pre>
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 4dc0dec486f6..26daa7906717 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -174,6 +174,7 @@ static int online_region_extent(struct region_extent *region_extent)
                goto err;
 
        dev_dbg(dev, "region extent HPA %pra\n", &region_extent->hpa_range);
+       return 0;
        return devm_add_action_or_reset(&cxlr_dax->dev, region_extent_unregister,
                                        region_extent);
</pre> 

## Output

<pre>
fan@smc-140338-bm01:~/cxl/linux-dcd$ cxl-tool.py --run --create-topo
Info: back memory/lsa file exist under /tmp/host0 from previous run, delete them Y/N(default Y): 
Starting VM...
QEMU instance is up, access it: ssh root@localhost -p 2024
fan@smc-140338-bm01:~/cxl/linux-dcd$ cxl-tool.py --dcd-test mem0
Load cxl drivers first
ssh root@localhost -p 2024 "modprobe -a cxl_acpi cxl_core cxl_pci cxl_port cxl_mem"

Module                  Size  Used by
dax_pmem               12288  0
device_dax             16384  0
nd_pmem                24576  0
nd_btt                 28672  1 nd_pmem
dax                    57344  3 dax_pmem,device_dax,nd_pmem
cxl_pmem               24576  0
cxl_pmu                28672  0
cxl_mem                12288  0
libnvdimm             217088  4 cxl_pmem,dax_pmem,nd_btt,nd_pmem
cxl_pci                28672  0
cxl_acpi               24576  0
cxl_port               16384  0
cxl_core              368640  7 cxl_pmem,cxl_port,cxl_mem,cxl_pci,cxl_acpi,cxl_pmu
ssh root@localhost -p 2024 "cxl enable-memdev mem0"
cxl memdev: cmd_enable_memdev: enabled 1 mem
cxl region: cmd_create_region: created 1 region
{
  "region":"region0",
  "resource":79725330432,
  "size":2147483648,
  "interleave_ways":1,
  "interleave_granularity":256,
  "decode_state":"commit",
  "mappings":[
    {
      "position":0,
      "memdev":"mem0",
      "decoder":"decoder2.0"
    }
  ]
}
sn=3840
cxl-memdev0
sn=3840
Choose OP: 0: add, 1: release, 2: print extent, 9: exit
Choice: 2
cat /tmp/qmp-show.json|ncat localhost 4445
{"QMP": {"version": {"qemu": {"micro": 90, "minor": 2, "major": 9}, "package": "v6.2.0-28065-g3537a06886-dirty"}, "capabilities": ["oob"]}}
{"return": {}}
{"return": {}}
{"return": {}}
Print accepted extent info:
0: [0x0 - 0x10000000]
In total, 1 extents printed!
Print pending-to-add extent info:
In total, 0 extents printed!
Choose OP: 0: add, 1: release, 2: print extent, 9: exit
Choice: 9
Do you want to continue to create dax device for DC(Y/N):y
daxctl create-device -r region0
[
  {
    "chardev":"dax0.1",
    "size":268435456,
    "target_node":1,
    "align":2097152,
    "mode":"devdax"
  }
]
created 1 device
daxctl list -r region0 -D
[
  {
    "chardev":"dax0.1",
    "size":268435456,
    "target_node":1,
    "align":2097152,
    "mode":"devdax"
  }
]
ssh root@localhost -p 2024 "daxctl reconfigure-device dax0.1 -m system-ram"
[
  {
    "chardev":"dax0.1",
    "size":268435456,
    "target_node":1,
    "align":2097152,
    "mode":"system-ram",
    "online_memblocks":2,
    "total_memblocks":2,
    "movable":true
  }
]
reconfigured 1 device
RANGE                                  SIZE  STATE REMOVABLE   BLOCK
0x0000000000000000-0x000000007fffffff    2G online       yes    0-15
0x0000000100000000-0x000000027fffffff    6G online       yes   32-79
0x0000001290000000-0x000000129fffffff  256M online       yes 594-595

Memory block size:       128M
Total online memory:     8.3G
</pre>



fan
> 
> > 
> > The dmesg shows the really_probe function returns early as resource
> > presents before probe as below,
> > 
> > [ 1745.505068] cxl_core:devm_cxl_add_dax_region:3251: cxl_region region0: region0: register dax_region0
> > [ 1745.506063] cxl_pci:__cxl_pci_mbox_send_cmd:263: cxl_pci 0000:0d:00.0: Sending command: 0x4801
> > [ 1745.506953] cxl_pci:cxl_pci_mbox_wait_for_doorbell:74: cxl_pci 0000:0d:00.0: Doorbell wait took 0ms
> > [ 1745.507911] cxl_core:__cxl_process_extent_list:1802: cxl_pci 0000:0d:00.0: Got extent list 0-0 of 1 generation Num:0
> > [ 1745.508958] cxl_core:__cxl_process_extent_list:1815: cxl_pci 0000:0d:00.0: Processing extent 0/1
> > [ 1745.509843] cxl_core:cxl_validate_extent:975: cxl_pci 0000:0d:00.0: DC extent DPA [range 0x0000000000000000-0x000000000fffffff] (DCR:[range 0x0000000000000000-0x000000007fffffff])(00000000-0000-0000-0000-000000000000)
> > [ 1745.511748] cxl_core:__cxl_dpa_to_region:2869: cxl decoder2.0: dpa:0x0 mapped in region:region0
> > [ 1745.512626] cxl_core:cxl_add_extent:460: cxl decoder2.0: Checking ED ([mem 0x00000000-0x3fffffff flags 0x80000200]) for extent [range 0x0000000000000000-0x000000000fffffff]
> > [ 1745.514143] cxl_core:cxl_add_extent:492: cxl decoder2.0: Add extent [range 0x0000000000000000-0x000000000fffffff] (00000000-0000-0000-0000-000000000000)
> > [ 1745.515485] cxl_core:online_region_extent:176:  extent0.0: region extent HPA [range 0x0000000000000000-0x000000000fffffff]
> > [ 1745.516576] cxl_core:cxlr_notify_extent:285: cxl dax_region0: Trying notify: type 0 HPA [range 0x0000000000000000-0x000000000fffffff]
> > [ 1745.517768] cxl_core:cxl_bus_probe:2087: cxl_region region0: probe: 0
> > [ 1745.524984] cxl dax_region0: Resources present before probing
> > 
> > 
> > btw, I hit the same issue with the previous verson also.
> > 
> > Fan
> 
> [snip]
