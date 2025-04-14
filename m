Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9958C274FC8
	for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744647090; cv=none; b=vAp+bTT73lVc8eyLF+GB3lVh/EMqJcoQ3Esf44ZJDg3K9NqzrU/S1RA8lRgBvB5iEjkBbzRfgNX/hQ0b4D2U6B+JlTjn051NU0ZhFiJzEg4ciDcgC8d7DgU7hsWiRHCKZsZRHK+o4QCOPz3XWrOWLV+pVWtJgO82o1vnoHfFrHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744647090; c=relaxed/simple;
	bh=/DZrOtUiLIvB0RYHz3UInqX8rOp8TEQxO+c83g66qkU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPZVS+SjB92mBz6ZOIaNZPWYYz830jpUsO00A7UbG4OBhcEbvNfjv9ujfe15OLOcK/I6PLmM/eq/5ur6P1xkX/uszctwu0peqf+P2KOND6p4rR/Whcr5uAjkEGSg78txux/828id5Kgqw7POwn+nixu2nxGxsHf6W4Hrr6174bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V4/RbLdk; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V4/RbLdk"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-702628e34f2so37132387b3.0
        for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 09:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744647085; x=1745251885; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bqpk8SGR8teV3ZxFZ/rFHkAcX7lTSPF74ozTQzuv8ak=;
        b=V4/RbLdk6Gs+SZ8BIc+AlZGeMFlujgvAQCXrzhh9+NF9thAmmKXqlLSStCyHW4dc/t
         VKRlRyabWT46AGyDwq9yjBaOiICjZbTPiGs+XIpu8N3vmmsoiluO5NHSNiGCHCIasTyy
         7wiUcSM10jne5pze9NeroLDgqFURDQ54go409DBbogtbstE5NuNDnK03DCDRh77fjwBx
         wGIEZeDBdUS3D932bXJT4k7vx5Xd1tQ4EdQaV/BLjIncfdceholHrLwR4R0kdKVuChPF
         vVRlcxJColGTzaU7EUc717VlYV0Lm/mk+QwbdZv4JdFzGOFUNr3LCPAB59GJn4YI9kC7
         eOPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744647085; x=1745251885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bqpk8SGR8teV3ZxFZ/rFHkAcX7lTSPF74ozTQzuv8ak=;
        b=ct+oQFDwZre23M3Wb/TXEKpO7KyktceFZo/O/WvLF1IG3DCHWMH3CzT76kixlElhil
         hfpVum5gzIxk0pN388uDN1vpJPbOih5odK7n6wJ1qTYN9tKrqWhsRNIuQHTbALRIN2UF
         Py/N+s/r7bCANgA49hmY0gtrXXAbzDRW53l+Y8si9HPNSNqlgKhSL/yE/UXXXHTre51D
         Z0rPhEYnX1A4dEXpFINLuoh5AyHoFp31UYBS3WkxBQ/Rx2D9RhzFTeyVtr82zYNzcUJ0
         0bQPpfvrKUG9sY79yo+WxiUBEu2q53Hba9tXTWtFg1s3uYKh5OJRVBWkz24GpQNt5PNC
         2GvA==
X-Forwarded-Encrypted: i=1; AJvYcCUVtSG39PNazf+/JeTeylATIO7v8YxYN4hOLvVT8DxiNdNMmWN2vD/uibO4ZOy041AP5JQmc0I=@lists.linux.dev
X-Gm-Message-State: AOJu0YzUM6WLStvt/p2KStR9aLgYZ885xgcNVMb7UkBAjqBcdCk/fIJ8
	8Bzi4aMtdFI+0Pi7e6IYJuBbnEIkg9BnTUVjLqmgUCoNYMPQZx4O
X-Gm-Gg: ASbGncthcVhFS3koUvXMhHSldiN+090jB+VIjJnsHSjBThE+vtHQB4F/FeyA3/AaAdj
	5SqaBgi5EBjPD+Wec8F6Gy8+e77t7TH0fWDyT1oO0DU7L4a2wfZZVfOBBRIRjR/SOCSDa/ywJGn
	yyYdlmbTU4ksDRhfv/X5uluFSEi90hN/4gc2oVpLZxmk9bscOo7KvSdg4FHrRXrG2EQOW6SwEoz
	iM8OkUtlM+qQojGYXEEYql+vf4B2ylBI3ZtSVHKKh1WSZls+R9XvBuhO9QWUb5OJd1gAgEjOwkQ
	FD+ggrGZNFR4nVgvxdrOutLB8PjV9A==
X-Google-Smtp-Source: AGHT+IHUrrg/lT1214yxsnOp1hvAeZgKF8L2o9GlvAiaCxQNwDZIaF20RaSc34o3pOoSxUwgTKTvJw==
X-Received: by 2002:a05:690c:6e8e:b0:6fb:a251:2450 with SMTP id 00721157ae682-7055941baa5mr198096017b3.1.1744647085159;
        Mon, 14 Apr 2025 09:11:25 -0700 (PDT)
Received: from debian ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7053e138a1dsm31577287b3.61.2025.04.14.09.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 09:11:24 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Mon, 14 Apr 2025 09:11:20 -0700
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <Z_0v-iFQpWlgG7oT@debian>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>

On Sun, Apr 13, 2025 at 05:52:08PM -0500, Ira Weiny wrote:
> A git tree of this series can be found here:
> 
> 	https://github.com/weiny2/linux-kernel/tree/dcd-v6-2025-04-13
> 
> This is now based on 6.15-rc2.
> 
> Due to the stagnation of solid requirements for users of DCD I do not
> plan to rev this work in Q2 of 2025 and possibly beyond.
> 
> It is anticipated that this will support at least the initial
> implementation of DCD devices, if and when they appear in the ecosystem.
> The patch set should be reviewed with the limited set of functionality in
> mind.  Additional functionality can be added as devices support them.
> 
> It is strongly encouraged for individuals or companies wishing to bring
> DCD devices to market review this set with the customer use cases they
> have in mind.

Hi Ira,
thanks for sending it out.

I have not got a chance to check the code or test it extensively.

I tried to test one specific case and hit issue.

I tried to add some DC extents to the extent list on the device when the
VM is launched by hacking qemu like below,

diff --git a/hw/mem/cxl_type3.c b/hw/mem/cxl_type3.c
index 87fa308495..4049fc8dd9 100644
--- a/hw/mem/cxl_type3.c
+++ b/hw/mem/cxl_type3.c
@@ -826,6 +826,11 @@ static bool cxl_create_dc_regions(CXLType3Dev *ct3d, Error **errp)
     QTAILQ_INIT(&ct3d->dc.extents);
     QTAILQ_INIT(&ct3d->dc.extents_pending);
 
+    cxl_insert_extent_to_extent_list(&ct3d->dc.extents, 0,
+                                     CXL_CAPACITY_MULTIPLIER, NULL, 0);
+    ct3d->dc.total_extent_count = 1;
+    ct3_set_region_block_backed(ct3d, 0, CXL_CAPACITY_MULTIPLIER);
+
     return true;
 }


Then after the VM is launched, I tried to create a DC region with
commmand: cxl create-region -m mem0 -d decoder0.0 -s 1G -t
dynamic_ram_a.

It works fine. As you can see below, the region is created and the
extent is showing correctly.

root@debian:~# cxl list -r region0 -N
[
  {
    "region":"region0",
    "resource":79725330432,
    "size":1073741824,
    "interleave_ways":1,
    "interleave_granularity":256,
    "decode_state":"commit",
    "extents":[
      {
        "offset":0,
        "length":268435456,
        "uuid":"00000000-0000-0000-0000-000000000000"
      }
    ]
  }
]


However, after that, I tried to create a dax device as below, it failed.

root@debian:~# daxctl create-device -r region0 -v
libdaxctl: __dax_regions_init: no dax regions found via: /sys/class/dax
error creating devices: No such device or address
created 0 devices
root@debian:~# 

root@debian:~# ls /sys/class/dax 
ls: cannot access '/sys/class/dax': No such file or directory

The dmesg shows the really_probe function returns early as resource
presents before probe as below,

[ 1745.505068] cxl_core:devm_cxl_add_dax_region:3251: cxl_region region0: region0: register dax_region0
[ 1745.506063] cxl_pci:__cxl_pci_mbox_send_cmd:263: cxl_pci 0000:0d:00.0: Sending command: 0x4801
[ 1745.506953] cxl_pci:cxl_pci_mbox_wait_for_doorbell:74: cxl_pci 0000:0d:00.0: Doorbell wait took 0ms
[ 1745.507911] cxl_core:__cxl_process_extent_list:1802: cxl_pci 0000:0d:00.0: Got extent list 0-0 of 1 generation Num:0
[ 1745.508958] cxl_core:__cxl_process_extent_list:1815: cxl_pci 0000:0d:00.0: Processing extent 0/1
[ 1745.509843] cxl_core:cxl_validate_extent:975: cxl_pci 0000:0d:00.0: DC extent DPA [range 0x0000000000000000-0x000000000fffffff] (DCR:[range 0x0000000000000000-0x000000007fffffff])(00000000-0000-0000-0000-000000000000)
[ 1745.511748] cxl_core:__cxl_dpa_to_region:2869: cxl decoder2.0: dpa:0x0 mapped in region:region0
[ 1745.512626] cxl_core:cxl_add_extent:460: cxl decoder2.0: Checking ED ([mem 0x00000000-0x3fffffff flags 0x80000200]) for extent [range 0x0000000000000000-0x000000000fffffff]
[ 1745.514143] cxl_core:cxl_add_extent:492: cxl decoder2.0: Add extent [range 0x0000000000000000-0x000000000fffffff] (00000000-0000-0000-0000-000000000000)
[ 1745.515485] cxl_core:online_region_extent:176:  extent0.0: region extent HPA [range 0x0000000000000000-0x000000000fffffff]
[ 1745.516576] cxl_core:cxlr_notify_extent:285: cxl dax_region0: Trying notify: type 0 HPA [range 0x0000000000000000-0x000000000fffffff]
[ 1745.517768] cxl_core:cxl_bus_probe:2087: cxl_region region0: probe: 0
[ 1745.524984] cxl dax_region0: Resources present before probing


btw, I hit the same issue with the previous verson also.

Fan

> 
> Series info
> ===========
> 
> This series has 2 parts:
> 
> Patch 1-17: Core DCD support
> Patch 18-19: cxl_test support
> 
> Background
> ==========
> 
> A Dynamic Capacity Device (DCD) (CXL 3.1 sec 9.13.3) is a CXL memory
> device that allows memory capacity within a region to change
> dynamically without the need for resetting the device, reconfiguring
> HDM decoders, or reconfiguring software DAX regions.
> 
> One of the biggest anticipated use cases for Dynamic Capacity is to
> allow hosts to dynamically add or remove memory from a host within a
> data center without physically changing the per-host attached memory nor
> rebooting the host.
> 
> The general flow for the addition or removal of memory is to have an
> orchestrator coordinate the use of the memory.  Generally there are 5
> actors in such a system, the Orchestrator, Fabric Manager, the Logical
> device, the Host Kernel, and a Host User.
> 
> An example work flow is shown below.
> 
> Orchestrator      FM         Device       Host Kernel    Host User
> 
>     |             |           |            |               |
>     |-------------- Create region ------------------------>|
>     |             |           |            |               |
>     |             |           |            |<-- Create ----|
>     |             |           |            |    Region     |
>     |             |           |            |(dynamic_ram_a)|
>     |<------------- Signal done ---------------------------|
>     |             |           |            |               |
>     |-- Add ----->|-- Add --->|--- Add --->|               |
>     |  Capacity   |  Extent   |   Extent   |               |
>     |             |           |            |               |
>     |             |<- Accept -|<- Accept  -|               |
>     |             |   Extent  |   Extent   |               |
>     |             |           |            |<- Create ---->|
>     |             |           |            |   DAX dev     |-- Use memory
>     |             |           |            |               |   |
>     |             |           |            |               |   |
>     |             |           |            |<- Release ----| <-+
>     |             |           |            |   DAX dev     |
>     |             |           |            |               |
>     |<------------- Signal done ---------------------------|
>     |             |           |            |               |
>     |-- Remove -->|- Release->|- Release ->|               |
>     |  Capacity   |  Extent   |   Extent   |               |
>     |             |           |            |               |
>     |             |<- Release-|<- Release -|               |
>     |             |   Extent  |   Extent   |               |
>     |             |           |            |               |
>     |-- Add ----->|-- Add --->|--- Add --->|               |
>     |  Capacity   |  Extent   |   Extent   |               |
>     |             |           |            |               |
>     |             |<- Accept -|<- Accept  -|               |
>     |             |   Extent  |   Extent   |               |
>     |             |           |            |<- Create -----|
>     |             |           |            |   DAX dev     |-- Use memory
>     |             |           |            |               |   |
>     |             |           |            |<- Release ----| <-+
>     |             |           |            |   DAX dev     |
>     |<------------- Signal done ---------------------------|
>     |             |           |            |               |
>     |-- Remove -->|- Release->|- Release ->|               |
>     |  Capacity   |  Extent   |   Extent   |               |
>     |             |           |            |               |
>     |             |<- Release-|<- Release -|               |
>     |             |   Extent  |   Extent   |               |
>     |             |           |            |               |
>     |-- Add ----->|-- Add --->|--- Add --->|               |
>     |  Capacity   |  Extent   |   Extent   |               |
>     |             |           |            |<- Create -----|
>     |             |           |            |   DAX dev     |-- Use memory
>     |             |           |            |               |   |
>     |-- Remove -->|- Release->|- Release ->|               |   |
>     |  Capacity   |  Extent   |   Extent   |               |   |
>     |             |           |            |               |   |
>     |             |           |     (Release Ignored)      |   |
>     |             |           |            |               |   |
>     |             |           |            |<- Release ----| <-+
>     |             |           |            |   DAX dev     |
>     |<------------- Signal done ---------------------------|
>     |             |           |            |               |
>     |             |- Release->|- Release ->|               |
>     |             |  Extent   |   Extent   |               |
>     |             |           |            |               |
>     |             |<- Release-|<- Release -|               |
>     |             |   Extent  |   Extent   |               |
>     |             |           |            |<- Destroy ----|
>     |             |           |            |   Region      |
>     |             |           |            |               |
> 
> Implementation
> ==============
> 
> This series requires the creation of regions and DAX devices to be
> closely synchronized with the Orchestrator and Fabric Manager.  The host
> kernel will reject extents if a region is not yet created.  It also
> ignores extent release if memory is in use (DAX device created).  These
> synchronizations are not anticipated to be an issue with real
> applications.
> 
> Only a single dynamic ram partition is supported (dynamic_ram_a).  The
> requirements, use cases, and existence of actual hardware devices to
> support more than one DC partition is unknown at this time.  So a less
> complex implementation was chosen.
> 
> In order to allow for capacity to be added and removed a new concept of
> a sparse DAX region is introduced.  A sparse DAX region may have 0 or
> more bytes of available space.  The total space depends on the number
> and size of the extents which have been added.
> 
> It is anticipated that users of the memory will carefully coordinate the
> surfacing of capacity with the creation of DAX devices which use that
> capacity.  Therefore, the allocation of the memory to DAX devices does
> not allow for specific associations between DAX device and extent.  This
> keeps allocations of DAX devices similar to existing DAX region
> behavior.
> 
> To keep the DAX memory allocation aligned with the existing DAX devices
> which do not have tags, extents are not allowed to have tags in this
> implementation.  Future support for tags can be added when real use
> cases surface.
> 
> Great care was taken to keep the extent tracking simple.  Some xarray's
> needed to be added but extra software objects are kept to a minimum.
> 
> Region extents are tracked as sub-devices of the DAX region.  This
> ensures that region destruction cleans up all extent allocations
> properly.
> 
> The major functionality of this series includes:
> 
> - Getting the dynamic capacity (DC) configuration information from cxl
>   devices
> 
> - Configuring a DC partition found in hardware.
> 
> - Enhancing the CXL and DAX regions for dynamic capacity support
> 	a. Maintain a logical separation between hardware extents and
> 	   software managed extents.  This provides an abstraction
> 	   between the layers and should allow for interleaving in the
> 	   future
> 
> - Get existing hardware extent lists for endpoint decoders upon region
>   creation.
> 
> - Respond to DC capacity events and adjust available region memory.
>         a. Add capacity Events
> 	b. Release capacity events
> 
> - Host response for add capacity
> 	a. do not accept the extent if:
> 		If the region does not exist
> 		or an error occurs realizing the extent
> 	b. If the region does exist
> 		realize a DAX region extent with 1:1 mapping (no
> 		interleave yet)
> 	c. Support the event more bit by processing a list of extents
> 	   marked with the more bit together before setting up a
> 	   response.
> 
> - Host response for remove capacity
> 	a. If no DAX device references the extent; release the extent
> 	b. If a reference does exist, ignore the request.
> 	   (Require FM to issue release again.)
> 	c. Release extents flagged with the 'more' bit individually as
> 	   the specification allows for the asynchronous release of
> 	   memory and the implementation is simplified by doing so.
> 
> - Modify DAX device creation/resize to account for extents within a
>   sparse DAX region
> 
> - Trace Dynamic Capacity events for debugging
> 
> - Add cxl-test infrastructure to allow for faster unit testing
>   (See new ndctl branch for cxl-dcd.sh test[1])
> 
> - Only support 0 value extent tags
> 
> Fan Ni's upstream of Qemu DCD was used for testing.
> 
> Remaining work:
> 
> 	1) Allow mapping to specific extents (perhaps based on
> 	   label/tag)
> 	   1a) devise region size reporting based on tags
> 	2) Interleave support
> 
> Possible additional work depending on requirements:
> 
> 	1) Accept a new extent which extends (but overlaps) already
> 	   accepted extent(s)
> 	2) Rework DAX device interfaces, memfd has been explored a bit
> 	3) Support more than 1 DC partition
> 
> [1] https://github.com/weiny2/ndctl/tree/dcd-region3-2025-04-13
> 
> ---
> Changes in v9:
> - djbw: pare down support to only a single DC parition
> - djbw: adjust to the new core partition processing which aligns with
>   new type2 work.
> - iweiny: address smaller comments from v8
> - iweiny: rebase off of 6.15-rc1
> - Link to v8: https://patch.msgid.link/20241210-dcd-type2-upstream-v8-0-812852504400@intel.com
> 
> ---
> Ira Weiny (19):
>       cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
>       cxl/mem: Read dynamic capacity configuration from the device
>       cxl/cdat: Gather DSMAS data for DCD partitions
>       cxl/core: Enforce partition order/simplify partition calls
>       cxl/mem: Expose dynamic ram A partition in sysfs
>       cxl/port: Add 'dynamic_ram_a' to endpoint decoder mode
>       cxl/region: Add sparse DAX region support
>       cxl/events: Split event msgnum configuration from irq setup
>       cxl/pci: Factor out interrupt policy check
>       cxl/mem: Configure dynamic capacity interrupts
>       cxl/core: Return endpoint decoder information from region search
>       cxl/extent: Process dynamic partition events and realize region extents
>       cxl/region/extent: Expose region extent information in sysfs
>       dax/bus: Factor out dev dax resize logic
>       dax/region: Create resources on sparse DAX regions
>       cxl/region: Read existing extents on region creation
>       cxl/mem: Trace Dynamic capacity Event Record
>       tools/testing/cxl: Make event logs dynamic
>       tools/testing/cxl: Add DC Regions to mock mem data
> 
>  Documentation/ABI/testing/sysfs-bus-cxl |  100 ++-
>  drivers/cxl/core/Makefile               |    2 +-
>  drivers/cxl/core/cdat.c                 |   11 +
>  drivers/cxl/core/core.h                 |   33 +-
>  drivers/cxl/core/extent.c               |  495 +++++++++++++++
>  drivers/cxl/core/hdm.c                  |   13 +-
>  drivers/cxl/core/mbox.c                 |  632 ++++++++++++++++++-
>  drivers/cxl/core/memdev.c               |   87 ++-
>  drivers/cxl/core/port.c                 |    5 +
>  drivers/cxl/core/region.c               |   76 ++-
>  drivers/cxl/core/trace.h                |   65 ++
>  drivers/cxl/cxl.h                       |   61 +-
>  drivers/cxl/cxlmem.h                    |  134 +++-
>  drivers/cxl/mem.c                       |    2 +-
>  drivers/cxl/pci.c                       |  115 +++-
>  drivers/dax/bus.c                       |  356 +++++++++--
>  drivers/dax/bus.h                       |    4 +-
>  drivers/dax/cxl.c                       |   71 ++-
>  drivers/dax/dax-private.h               |   40 ++
>  drivers/dax/hmem/hmem.c                 |    2 +-
>  drivers/dax/pmem.c                      |    2 +-
>  include/cxl/event.h                     |   31 +
>  include/linux/ioport.h                  |    3 +
>  tools/testing/cxl/Kbuild                |    3 +-
>  tools/testing/cxl/test/mem.c            | 1021 +++++++++++++++++++++++++++----
>  25 files changed, 3102 insertions(+), 262 deletions(-)
> ---
> base-commit: 8ffd015db85fea3e15a77027fda6c02ced4d2444
> change-id: 20230604-dcd-type2-upstream-0cd15f6216fd
> 
> Best regards,
> -- 
> Ira Weiny <ira.weiny@intel.com>
> 
