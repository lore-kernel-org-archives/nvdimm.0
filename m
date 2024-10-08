Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D07A213ECE;
	Tue,  8 Oct 2024 23:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728428842; cv=none; b=DXI1Xgk+OUZO1lcJ3npTkOXT1vHWT3FxA2oYumXCfRNvHifU7iDd4XSmWoZxvoQyG948+O8h+G53uPFxKskm0tT2evjZSjRWK34sXOvJRa1FSX+pTROI8IsmYZTsdTV5JZpgcJovQGJ6xoXSVM3JPZZXGrFe++OlZyigwGpnTf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728428842; c=relaxed/simple;
	bh=OmoPHSgASMtD1gosA+ADtS65dMQfGYgsiUZb2+ALFuc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqFwt53z6U6qtdYrEPRefsAtBPkjyPCdVhdEv05h7MYGyhmOmlvxhIP0Xmrt7ugtjHTyv34VjFDY658yFDJ9fEghDluG6qkmFpMye5ns1nUUUJKvFibrAW9UmaevJI2cisD1KJoaWSIZQNAvDJ9GjOLY7obe7W+Qf/3d21IE7Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a363EApi; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a363EApi"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-6de14e0f050so48517767b3.0;
        Tue, 08 Oct 2024 16:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728428839; x=1729033639; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oSgiK9Fkw7DRILt9N1WtbHHcLZGK3njFeJ6krkFXiYQ=;
        b=a363EApiZMbub1CTMNiYMYetrBnX6oDK4u39cfIy/meYTeq2Z9npWp3ReeKfugdh3B
         RflqNogK6TVbXeIlMpIjqzUbahimMAVh0i7G6ONRW1O19AB3391RWpgYU+rM655TYazg
         fmmwZ9hdZBihQCa46c15tQ2c9d1ONqVQr+Dz/RD+ppjP8UVNnmrqhvAe+6JOXW//TZ6J
         U+mwdrvRyjcszRA6yqchYxV8JcyiKa4HdptTFHLcjdfsqMqKsYlq0t9S4Xl+GUzcD4RS
         hkOo86LzRh7UpFPmfMKSPahGrx6b2Dg/339P79CdHDkvJkNHu8QpXJUsvQ2js4JUT4zD
         z+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728428839; x=1729033639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oSgiK9Fkw7DRILt9N1WtbHHcLZGK3njFeJ6krkFXiYQ=;
        b=D7CSxjFUu3NiwZXjpGq+T5zt8fyg6rt8kk9VIb2vT1cLB/AC1d5dz0/IRMfJpHGIN2
         D5dnIK9Y6qMixZrS4we4jCwKY5XW0D74TCiL5U73Er8RWHq6X4B1B9SHpL7arKy146I6
         jJrIoz1GL2PD143NUEDwZKSX9bTP9eYU08R0YJ46Lk6DA/RDF6J4mqkYogxtBMBIOljb
         eQQiVpPLTsZuRmKQeRORXYsITcxmKo7rlo9Bf2Qwx9pQasWD5oj/O/9VWG0yPgsw0S1z
         GbWFzjXxFBryGZOU3IM1pw9XJB8H2SZS5N3AI0JQgc1KbHAd2qeMU8ZWn4fy/zcpASWD
         IEFw==
X-Forwarded-Encrypted: i=1; AJvYcCWhHF/HwMuC0u+wtbaKAn7GnpzcKmZPa7NgQekcsOPhihoKyG1h7yTitOCQqOtPzElvH4pp/s6VpHEEdWM=@lists.linux.dev, AJvYcCWpyitsRjuvVWQ8G6hT9G/hokv4MIh/OZ35qdYPXB5ppXy8HiXGRdV79HTwJd6N+2fHKc292Tyo@lists.linux.dev
X-Gm-Message-State: AOJu0YyXhzzf8Hn/TG9iweOIp0Q7ed70i8ZsOqBCQFmxlQYy3wfd1uYR
	1B1wytNH8tuIDIFOcfkHGhBMV3aIHFjOMPhrPT/eKoeK7pMUa/uk
X-Google-Smtp-Source: AGHT+IFHPmpsI4+aM6o97Ud3p8SQfjjksWd1jhHOBNb66iOzskP/srmj8k9DLg/Rq7f8XOfxEPmpCA==
X-Received: by 2002:a05:690c:6981:b0:6b1:61e0:5359 with SMTP id 00721157ae682-6e322158397mr8677197b3.21.1728428839044;
        Tue, 08 Oct 2024 16:07:19 -0700 (PDT)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e2d9387dabsm16435997b3.63.2024.10.08.16.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 16:07:18 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Tue, 8 Oct 2024 16:06:59 -0700
To: ira.weiny@intel.com
Cc: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Li, Ming" <ming4.li@intel.com>,
	Robert Moore <robert.moore@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev
Subject: Re: [PATCH v4 00/28] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <ZwW7E2gSUM8SHAzo@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <ZwW4yQ11wYkaqdgx@fan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwW4yQ11wYkaqdgx@fan>

On Tue, Oct 08, 2024 at 03:57:13PM -0700, Fan Ni wrote:
> On Mon, Oct 07, 2024 at 06:16:06PM -0500, Ira Weiny wrote:
> > A git tree of this series can be found here:
> > 
> > 	https://github.com/weiny2/linux-kernel/tree/dcd-v4-2024-10-04
> > 
> > Series info
> > ===========
> > 
> 
> Hi Ira,
> 
> Based on current DC extent release logic, when the extent to release is
> in use (for example, created a dax device), no response (4803h) will be sent.
> Should we send a response with empty extent list instead?
> 
> Fan

Oh. my bad. 4803h does not allow an empty extent list. 

Fan

> 
> 
> > This series has 5 parts:
> > 
> > Patch 1-3: Add %pra printk format for struct range
> > Patch 4: Add core range_overlaps() function
> > Patch 5-6: CXL clean up/prelim patches
> > Patch 7-26: Core DCD support
> > Patch 27-28: cxl_test support
> > 
> > Background
> > ==========
> > 
> > A Dynamic Capacity Device (DCD) (CXL 3.1 sec 9.13.3) is a CXL memory
> > device that allows memory capacity within a region to change
> > dynamically without the need for resetting the device, reconfiguring
> > HDM decoders, or reconfiguring software DAX regions.
> > 
> > One of the biggest use cases for Dynamic Capacity is to allow hosts to
> > share memory dynamically within a data center without increasing the
> > per-host attached memory.
> > 
> > The general flow for the addition or removal of memory is to have an
> > orchestrator coordinate the use of the memory.  Generally there are 5
> > actors in such a system, the Orchestrator, Fabric Manager, the Logical
> > device, the Host Kernel, and a Host User.
> > 
> > Typical work flows are shown below.
> > 
> > Orchestrator      FM         Device       Host Kernel    Host User
> > 
> >     |             |           |            |              |
> >     |-------------- Create region ----------------------->|
> >     |             |           |            |              |
> >     |             |           |            |<-- Create ---|
> >     |             |           |            |    Region    |
> >     |<------------- Signal done --------------------------|
> >     |             |           |            |              |
> >     |-- Add ----->|-- Add --->|--- Add --->|              |
> >     |  Capacity   |  Extent   |   Extent   |              |
> >     |             |           |            |              |
> >     |             |<- Accept -|<- Accept  -|              |
> >     |             |   Extent  |   Extent   |              |
> >     |             |           |            |<- Create --->|
> >     |             |           |            |   DAX dev    |-- Use memory
> >     |             |           |            |              |   |
> >     |             |           |            |              |   |
> >     |             |           |            |<- Release ---| <-+
> >     |             |           |            |   DAX dev    |
> >     |             |           |            |              |
> >     |<------------- Signal done --------------------------|
> >     |             |           |            |              |
> >     |-- Remove -->|- Release->|- Release ->|              |
> >     |  Capacity   |  Extent   |   Extent   |              |
> >     |             |           |            |              |
> >     |             |<- Release-|<- Release -|              |
> >     |             |   Extent  |   Extent   |              |
> >     |             |           |            |              |
> >     |-- Add ----->|-- Add --->|--- Add --->|              |
> >     |  Capacity   |  Extent   |   Extent   |              |
> >     |             |           |            |              |
> >     |             |<- Accept -|<- Accept  -|              |
> >     |             |   Extent  |   Extent   |              |
> >     |             |           |            |<- Create ----|
> >     |             |           |            |   DAX dev    |-- Use memory
> >     |             |           |            |              |   |
> >     |             |           |            |<- Release ---| <-+
> >     |             |           |            |   DAX dev    |
> >     |<------------- Signal done --------------------------|
> >     |             |           |            |              |
> >     |-- Remove -->|- Release->|- Release ->|              |
> >     |  Capacity   |  Extent   |   Extent   |              |
> >     |             |           |            |              |
> >     |             |<- Release-|<- Release -|              |
> >     |             |   Extent  |   Extent   |              |
> >     |             |           |            |              |
> >     |-- Add ----->|-- Add --->|--- Add --->|              |
> >     |  Capacity   |  Extent   |   Extent   |              |
> >     |             |           |            |<- Create ----|
> >     |             |           |            |   DAX dev    |-- Use memory
> >     |             |           |            |              |   |
> >     |-- Remove -->|- Release->|- Release ->|              |   |
> >     |  Capacity   |  Extent   |   Extent   |              |   |
> >     |             |           |            |              |   |
> >     |             |           |     (Release Ignored)     |   |
> >     |             |           |            |              |   |
> >     |             |           |            |<- Release ---| <-+
> >     |             |           |            |   DAX dev    |
> >     |<------------- Signal done --------------------------|
> >     |             |           |            |              |
> >     |             |- Release->|- Release ->|              |
> >     |             |  Extent   |   Extent   |              |
> >     |             |           |            |              |
> >     |             |<- Release-|<- Release -|              |
> >     |             |   Extent  |   Extent   |              |
> >     |             |           |            |<- Destroy ---|
> >     |             |           |            |   Region     |
> >     |             |           |            |              |
> > 
> > Implementation
> > ==============
> > 
> > The series still requires the creation of regions and DAX devices to be
> > closely synchronized with the Orchestrator and Fabric Manager.  The host
> > kernel will reject extents if a region is not yet created.  It also
> > ignores extent release if memory is in use (DAX device created).  These
> > synchronizations are not anticipated to be an issue with real
> > applications.
> > 
> > In order to allow for capacity to be added and removed a new concept of
> > a sparse DAX region is introduced.  A sparse DAX region may have 0 or
> > more bytes of available space.  The total space depends on the number
> > and size of the extents which have been added.
> > 
> > Initially it is anticipated that users of the memory will carefully
> > coordinate the surfacing of additional capacity with the creation of DAX
> > devices which use that capacity.  Therefore, the allocation of the
> > memory to DAX devices does not allow for specific associations between
> > DAX device and extent.  This keeps allocations very similar to existing
> > DAX region behavior.
> > 
> > To keep the DAX memory allocation aligned with the existing DAX devices
> > which do not have tags extents are not allowed to have tags.  Future
> > support for tags is planned.
> > 
> > Great care was taken to keep the extent tracking simple.  Some xarray's
> > needed to be added but extra software objects were kept to a minimum.
> > 
> > Region extents continue to be tracked as sub-devices of the DAX region.
> > This ensures that region destruction cleans up all extent allocations
> > properly.
> > 
> > Some review tags were kept if a patch did not change.
> > 
> > The major functionality of this series includes:
> > 
> > - Getting the dynamic capacity (DC) configuration information from cxl
> >   devices
> > 
> > - Configuring the DC partitions reported by hardware
> > 
> > - Enhancing the CXL and DAX regions for dynamic capacity support
> > 	a. Maintain a logical separation between hardware extents and
> > 	   software managed region extents.  This provides an
> > 	   abstraction between the layers and should allow for
> > 	   interleaving in the future
> > 
> > - Get hardware extent lists for endpoint decoders upon
> >   region creation.
> > 
> > - Adjust extent/region memory available on the following events.
> >         a. Add capacity Events
> > 	b. Release capacity events
> > 
> > - Host response for add capacity
> > 	a. do not accept the extent if:
> > 		If the region does not exist
> > 		or an error occurs realizing the extent
> > 	b. If the region does exist
> > 		realize a DAX region extent with 1:1 mapping (no
> > 		interleave yet)
> > 	c. Support the event more bit by processing a list of extents
> > 	   marked with the more bit together before setting up a
> > 	   response.
> > 
> > - Host response for remove capacity
> > 	a. If no DAX device references the extent; release the extent
> > 	b. If a reference does exist, ignore the request.
> > 	   (Require FM to issue release again.)
> > 
> > - Modify DAX device creation/resize to account for extents within a
> >   sparse DAX region
> > 
> > - Trace Dynamic Capacity events for debugging
> > 
> > - Add cxl-test infrastructure to allow for faster unit testing
> >   (See new ndctl branch for cxl-dcd.sh test[1])
> > 
> > - Only support 0 value extent tags
> > 
> > Fan Ni's upstream of Qemu DCD was used for testing.
> > 
> > Remaining work:
> > 
> > 	1) Allow mapping to specific extents (perhaps based on
> > 	   label/tag)
> > 	   1a) devise region size reporting based on tags
> > 	2) Interleave support
> > 
> > Possible additional work depending on requirements:
> > 
> > 	1) Accept a new extent which extends (but overlaps) an existing
> > 	   extent(s)
> > 	2) Release extents when DAX devices are released if a release
> > 	   was previously seen from the device
> > 	3) Rework DAX device interfaces, memfd has been explored a bit
> > 
> > [1] https://github.com/weiny2/ndctl/tree/dcd-region2-2024-10-01
> > 
> > ---
> > Major changes in v4:
> > - iweiny: rebase to 6.12-rc
> > - iweiny: Add qos data to regions
> > - Jonathan: Fix up shared region detection
> > - Jonathan/jgroves/djbw/iweiny: Ignore 0 value tags
> > - iweiny: Change DCD partition sysfs entries to allow for qos class and
> >   additional parameters per partition
> > - Petr/Andy: s/%par/%pra/
> > - Andy: Share logic between printing struct resource and struct range
> > - Link to v3: https://patch.msgid.link/20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com
> > 
> > ---
> > Ira Weiny (14):
> >       test printk: Add very basic struct resource tests
> >       printk: Add print format (%pra) for struct range
> >       cxl/cdat: Use %pra for dpa range outputs
> >       range: Add range_overlaps()
> >       dax: Document dax dev range tuple
> >       cxl/pci: Delay event buffer allocation
> >       cxl/cdat: Gather DSMAS data for DCD regions
> >       cxl/region: Refactor common create region code
> >       cxl/events: Split event msgnum configuration from irq setup
> >       cxl/pci: Factor out interrupt policy check
> >       cxl/core: Return endpoint decoder information from region search
> >       dax/bus: Factor out dev dax resize logic
> >       tools/testing/cxl: Make event logs dynamic
> >       tools/testing/cxl: Add DC Regions to mock mem data
> > 
> > Navneet Singh (14):
> >       cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
> >       cxl/mem: Read dynamic capacity configuration from the device
> >       cxl/core: Separate region mode from decoder mode
> >       cxl/region: Add dynamic capacity decoder and region modes
> >       cxl/hdm: Add dynamic capacity size support to endpoint decoders
> >       cxl/mem: Expose DCD partition capabilities in sysfs
> >       cxl/port: Add endpoint decoder DC mode support to sysfs
> >       cxl/region: Add sparse DAX region support
> >       cxl/mem: Configure dynamic capacity interrupts
> >       cxl/extent: Process DCD events and realize region extents
> >       cxl/region/extent: Expose region extent information in sysfs
> >       dax/region: Create resources on sparse DAX regions
> >       cxl/region: Read existing extents on region creation
> >       cxl/mem: Trace Dynamic capacity Event Record
> > 
> >  Documentation/ABI/testing/sysfs-bus-cxl   | 120 +++-
> >  Documentation/core-api/printk-formats.rst |  13 +
> >  drivers/cxl/core/Makefile                 |   2 +-
> >  drivers/cxl/core/cdat.c                   |  52 +-
> >  drivers/cxl/core/core.h                   |  33 +-
> >  drivers/cxl/core/extent.c                 | 486 +++++++++++++++
> >  drivers/cxl/core/hdm.c                    | 213 ++++++-
> >  drivers/cxl/core/mbox.c                   | 605 ++++++++++++++++++-
> >  drivers/cxl/core/memdev.c                 | 130 +++-
> >  drivers/cxl/core/port.c                   |  13 +-
> >  drivers/cxl/core/region.c                 | 170 ++++--
> >  drivers/cxl/core/trace.h                  |  65 ++
> >  drivers/cxl/cxl.h                         | 122 +++-
> >  drivers/cxl/cxlmem.h                      | 131 +++-
> >  drivers/cxl/pci.c                         | 123 +++-
> >  drivers/dax/bus.c                         | 352 +++++++++--
> >  drivers/dax/bus.h                         |   4 +-
> >  drivers/dax/cxl.c                         |  72 ++-
> >  drivers/dax/dax-private.h                 |  47 +-
> >  drivers/dax/hmem/hmem.c                   |   2 +-
> >  drivers/dax/pmem.c                        |   2 +-
> >  fs/btrfs/ordered-data.c                   |  10 +-
> >  include/acpi/actbl1.h                     |   2 +
> >  include/cxl/event.h                       |  32 +
> >  include/linux/range.h                     |   7 +
> >  lib/test_printf.c                         |  70 +++
> >  lib/vsprintf.c                            |  55 +-
> >  tools/testing/cxl/Kbuild                  |   3 +-
> >  tools/testing/cxl/test/mem.c              | 960 ++++++++++++++++++++++++++----
> >  29 files changed, 3576 insertions(+), 320 deletions(-)
> > ---
> > base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
> > change-id: 20230604-dcd-type2-upstream-0cd15f6216fd
> > 
> > Best regards,
> > -- 
> > Ira Weiny <ira.weiny@intel.com>
> > 
> 
> -- 
> Fan Ni

-- 
Fan Ni
