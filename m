Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5BF41D4E9
	for <nvdimm@lists.linux.dev>; Thu,  8 Oct 2026 08:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791447982; cv=none; b=eW03O4l76LuJ87QOggwvm2WTCS7xX4aDcQlVmLpqAEi0sBWZ3Ghh6iHaqA/RscapdGj4b4ewQ2qq8T67JDTixwN5Bdm1pGiMQjdLuzhSMDieEmoNpQ2EVdoczOEk7L+okwrCPzGZzRoSs8lwuO59dYDrCrz1+4XbZHReD4begnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791447982; c=relaxed/simple;
	bh=tZlGcH7kdTHWEpSMO3QVfn4WCD4FT3cunBUkS42WjLA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAxzNV98+ydoLXIFEZ7Xz+2rGMoJZuNqUgoDOMZmHbd1Fm3yEPudZY9KmaJveMylDjzyoTW4K5zvPgG9nsXOsXq8k2llwMp41uiL4jCqzGLJIoRyB0Q7ZvJ0Fq2hLNQN/E3Gd3jyQNZTN8u6mEwAhJ1zISPHbEZRsUXCzhQY6fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TIfKfliK; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TIfKfliK"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3a4c80d3d5aso3021234a91.0
        for <nvdimm@lists.linux.dev>; Thu, 08 Oct 2026 01:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791447979; x=1792052779; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CS7qZDwIHCGcSr4m98IhvTEAv/dtevMpM6fVYctnKQg=;
        b=TIfKfliKlB+vcIp67hsiWMfIAgKaIbRXfzSnogE+ESrBNc8ThDhPdjrcmUAfKSFG0z
         241YE+HVsAqm265SeADaTiqAtEvjJGjTPRqZfrE7Ukvuu6S0u/6sifL3K0vVxCdttSMn
         j2zQZPc1JCNd4Ce/h0L4MYZ3l+Xf7mqIsl7KhiVB89zhKuLowkcyZwTqG28DII5hxXk5
         R/2xUYlaktaompXrmhlvOVSl6LUZq4iCsIewjjGDAin29TCr1E2NacLuwU/ICUEzr76m
         hoWLh7ofpNeppAz8CL8caP+ZasGRhAzviDEc5Hkuv3CKub5cNLmvTORCj0Cx5WUtThd5
         EstQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791447979; x=1792052779;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CS7qZDwIHCGcSr4m98IhvTEAv/dtevMpM6fVYctnKQg=;
        b=tHfvdPUPPIq1CH2exHPac+3ZaNni452EJXRewi7yzPnFNnB5Wn9P9Mryb+H4dYomKQ
         IJI7O5scKLzpE04UFRvm+4LY3TsvyN64NxQYlIZ0wLC6x0VAmXWzqzvC8irgrSBVhv5R
         Sl/HQjt+6KGQUQ2ake1iHTh20qBQ8CpI42DIPnInmAuNm6dCSx1frGTDKNlAKYuBmnbQ
         Xd7ZKc6Y48wsBlyliVJN1nKErvWtb/lSurIp/Q9AB6UxoBmbaie/OPWHRNGCgWQGIFwR
         FfbBzrdk8pHqSfzdQK71XHbjjSveYdoQJA9wRlmunvjSzcDI1R9rwMODXsvIXFBvhiwV
         FYPA==
X-Forwarded-Encrypted: i=1; AKwUvBzqKSbNSJU3NSUyoGTghR2apx1hHeJSngtfGFsomxBaVoPb/afr7VtO3AWLPlvwMjKZUcEFBN8=@lists.linux.dev
X-Gm-Message-State: AFq9FYJXSccLaZJhIGDxds1adN6PJwCKpp0QD3sI+T+XE1xVg1untxqg
	ofy/nEJo+8fsv3pmo4a3A5iyVevWI3zWpap2b1IIKHrcCXENrJLjKt0e
X-Gm-Gg: AYBFou2ErYtkhS37tivZo7x42ZklBelVY77HTOvQqQZeTLqSIeXRDfFpsSailXBlqxp
	qcL9U73rY9glqPDS2mgmLxlEcHA8SfuZovIoEbeoOS4sCh4yqRjig7PfXqruQB9Pb7Y6o0ERAAk
	U1Di4tcizJHWgygOgtil9ZGJEkmu1sT++ivwA9ETr0AUoW+I83rYkvwLT4vUgZDV9ik49uAWDGV
	b8DZpVMNpPJexwILfQ55StG9cHCOmrCITmCQCLS5wcSx0usmuYflL3CUfFc/SNoSJcL4yvDzOpA
	h4fBotadIDy5+2aoCsD7tG4U7FV+MK2olmSH3eFc+UmKKC2ydvJ/1R9rkZYLwnMgNtpfNxIjRUp
	1ShVF4O4PJkVmbvzgIQZO4I7nrLbt1BU47sYR+X86tIyJd8wRrHLF2OUoEDoz9cP4+V5QkF1UyL
	wIrbL3hjKr3wqLhuU9HpFa+N4V9rGSVU1Mcb0YfUfl/6HmfHEU7X4/TNDTGh3F/Kmv1iDt7rMH6
	Oi+/BPEhpRRNl4RY1fZRnQpqlOPvA8z63fg2i8FFW7zH+TlrnOBw0xGf/xruGN7Jt3LB2acUzcY
	7KD3LCIXYeCp3Q==
X-Received: by 2002:a17:90b:498e:b0:39e:6a80:b799 with SMTP id 98e67ed59e1d1-3a8a0f2599amr4163262a91.41.1791447979142;
        Thu, 08 Oct 2026 01:26:19 -0700 (PDT)
Received: from 4470NRD-ASU.ssi.samsung.com (c-24-19-224-150.hsd1.wa.comcast.net. [24.19.224.150])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a89d5ced5asm4299357a91.0.2026.10.08.01.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 01:26:18 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Thu, 8 Oct 2026 01:26:17 -0700
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>
Subject: Re: [PATCH v15 0/8] DCD Prep Series
Message-ID: <asdTqSxNO0OoHpOh@4470NRD-ASU.ssi.samsung.com>
References: <20261007201828.952-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007201828.952-1-anisa.su@samsung.com>

On Wed, Oct 07, 2026 at 01:16:33PM -0700, Anisa Su wrote:
> These are the first eight patches of the Dynamic Capacity Device (DCD)
> series. They set up: DCD enumeration, CDAT handling for DC partitions,
> the event interrupt plumbing, a preparatory refactor, and
> documentation of the DPA partition layout. They stand alone and keep DCD
> disabled. They are not dependent on the rest of the series.
> 
> Patch 1 detects the 48h command set and then leaves mds->dcd_supported
> false. The flag is only turned on by the series that adds DCD event
> handling, so every DCD specific path added here is shut off at runtime:
> cxl_configure_dcd() never runs, no DC partition is created, no DCD
> interrupt is armed, and the CXL_PARTMODE_DYNAMIC_RAM paths are
> unreachable. The intent is to land the enumeration and plumbing while
> the extent to DAX pipeline is still under review.
> 
> Based on v7.3-rc6
> 
> v14: https://lore.kernel.org/linux-cxl/20260918203049.7273-1-anisa.su@samsung.com/T/#m0b6ade9da2d4fefa8aab3bb7db7c29516bc3f955
> 
[snip] 
> Testing
> =======
> This series leaves mds->dcd_supported false on purpose, so
> cxl_configure_dcd(), cxl_dev_dc_identify() and cxl_dc_check() are
> unreachable at runtime as posted. The tests below are done with the rest
> of the series on top, otherwise testing would not yield any meaningful
> results.
> 
> HW:
> Waiting on results from partner team.
> 
For the series:

Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>

Test adding 1 extent/release to ensure interrupt configuration and DSMAS are
read properly.

FMAPI Add command is issued from BMC:
busctl call xyz.openbmc_project.MCTP_SMBus_PCIe_slot \
  /xyz/openbmc_project/mctp xyz.openbmc_project.MCTP.Base \
  SendReceiveMctpMessagePayload yayq \
  9 101 \
  8 0 72 0 0 0x53 88 0 0 0 0 0 0 \
  0 1 84 0 0 72 0 4 0x56 72 0 0 0 0 0 0 \
  0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 \
  1 0 0 0 \
  0 0 0 0 1 0 0 0 \
  0 0 0 0x80 0 0 0 0 \
  0x7a 0x1d 0x4e 0x90 0xc3 0xb2 0x4f 0x57 0x8e 0x6d 0x21 0x5f 0x9a 0xb0 0xc4 0xd3 \
  0 0 \
  0 0 0 0 0 0 \
  100

To add 1 extent with 2GB size, tag=7a1d4e90-c3b2-4f57-8e6d-215f9ab0c4d3 and
shared sequence num = 0.
The device is shareable, so adding fails without any tag or seq num.

[Thu Oct  8 16:59:57 2026] cxl_core:cxl_mem_get_event_records:1875: cxl_pci 0000:0b:00.0: Reading event logs: 10
[Thu Oct  8 16:59:57 2026] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x0100
[Thu Oct  8 16:59:57 2026] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[Thu Oct  8 16:59:57 2026] cxl_core:cxl_handle_dcd_event_records:1779: cxl_pci 0000:0b:00.0: DCD event add : DPA:0x100000000 LEN:0x80000000
[Thu Oct  8 16:59:57 2026] cxl_core:cxl_extent_dc_partition:230: cxl_pci 0000:0b:00.0: DC extent DPA [range 0x0000000100000000-0x000000017fffffff] (DCR:[range 0x0000000000000000-0x0000001fffffffff])(7a1d4e90-c3b2-4f57-8e6d-215f9ab0c4d3)
[Thu Oct  8 16:59:57 2026] cxl_core:cxl_extent_dc_partition:230: cxl_pci 0000:0b:00.0: DC extent DPA [range 0x0000000100000000-0x000000017fffffff] (DCR:[range 0x0000000000000000-0x0000001fffffffff])(7a1d4e90-c3b2-4f57-8e6d-215f9ab0c4d3)
[Thu Oct  8 16:59:57 2026] cxl_core:cxl_extent_dc_partition:230: cxl_pci 0000:0b:00.0: DC extent DPA [range 0x0000000100000000-0x000000017fffffff] (DCR:[range 0x0000000000000000-0x0000001fffffffff])(7a1d4e90-c3b2-4f57-8e6d-215f9ab0c4d3)
[Thu Oct  8 16:59:57 2026] cxl_core:__cxl_dpa_to_region:3100: cxl decoder9.0: dpa:0x100000000 mapped in region:region0
[Thu Oct  8 16:59:57 2026] cxl_core:cxl_add_extent:517: cxl decoder9.0: Add extent [range 0x0000000100000000-0x000000017fffffff] (7a1d4e90-c3b2-4f57-8e6d-215f9ab0c4d3)
[Thu Oct  8 16:59:57 2026] cxl_core:cxlr_add_extent:444: cxl_dax_region dax_region0: Alloc new tag group
[Thu Oct  8 16:59:57 2026] cxl_core:online_tag_group:732:  extent0.3: dc_extent HPA [range 0x0000000100000000-0x000000017fffffff] (7a1d4e90-c3b2-4f57-8e6d-215f9ab0c4d3)
[Thu Oct  8 16:59:57 2026] cxl_core:__cxlr_notify_extent:394: cxl_dax_region dax_region0: Trying notify: type 0 tag 7a1d4e90-c3b2-4f57-8e6d-215f9ab0c4d3
[Thu Oct  8 16:59:57 2026] cxl_core:__cxlr_notify_extent:411: cxl_dax_region dax_region0: Notify: type 0 tag 7a1d4e90-c3b2-4f57-8e6d-215f9ab0c4d3
[Thu Oct  8 16:59:57 2026] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x4802
[Thu Oct  8 16:59:57 2026] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 1ms
[Thu Oct  8 16:59:57 2026] cxl_core:cxl_clear_event_record:1080: cxl_pci 0000:0b:00.0: Event log '4': Clearing 9
[Thu Oct  8 16:59:57 2026] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x0101
[Thu Oct  8 16:59:57 2026] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[Thu Oct  8 16:59:57 2026] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x0100
[Thu Oct  8 16:59:57 2026] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[Thu Oct  8 17:00:07 2026] cxl_core:cxl_mem_get_event_records:1875: cxl_pci 0000:0b:00.0: Reading event logs: 10
[Thu Oct  8 17:00:07 2026] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x0100
[Thu Oct  8 17:00:07 2026] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[Thu Oct  8 17:00:07 2026] cxl_core:cxl_handle_dcd_event_records:1779: cxl_pci 0000:0b:00.0: DCD event release : DPA:0x100000000 LEN:0x80000000
[Thu Oct  8 17:00:07 2026] cxl_core:__cxl_dpa_to_region:3100: cxl decoder9.0: dpa:0x100000000 mapped in region:region0
[Thu Oct  8 17:00:08 2026] cxl_core:__cxlr_notify_extent:394: cxl_dax_region dax_region0: Trying notify: type 1 tag 7a1d4e90-c3b2-4f57-8e6d-215f9ab0c4d3
[Thu Oct  8 17:00:08 2026] cxl_core:__cxlr_notify_extent:411: cxl_dax_region dax_region0: Notify: type 1 tag 7a1d4e90-c3b2-4f57-8e6d-215f9ab0c4d3
[Thu Oct  8 17:00:08 2026] cxl_core:dc_extent_unregister:528:  extent0.3: DAX region rm extent HPA [range 0x0000000100000000-0x000000017fffffff]
[Thu Oct  8 17:00:08 2026] cxl_core:cxled_release_extent:70: cxl decoder9.0: Remove extent [range 0x0000000100000000-0x000000017fffffff] (7a1d4e90-c3b2-4f57-8e6d-215f9ab0c4d3)
[Thu Oct  8 17:00:08 2026] cxl_core:memdev_release_extent:1201: cxl_pci 0000:0b:00.0: Release response dpa [range 0x0000000100000000-0x000000017fffffff]
[Thu Oct  8 17:00:08 2026] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x4803
[Thu Oct  8 17:00:08 2026] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[Thu Oct  8 17:00:08 2026] cxl_core:cxl_clear_event_record:1080: cxl_pci 0000:0b:00.0: Event log '4': Clearing 11
[Thu Oct  8 17:00:08 2026] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x0101
[Thu Oct  8 17:00:08 2026] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[Thu Oct  8 17:00:08 2026] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x0100
[Thu Oct  8 17:00:08 2026] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms

> cxl_test:
> ndctl's cxl suite against cxl_test (7.3.0-rc6, CXL as modules)
> 16 of 17 pass, cxl-features.sh skips for lack of FWCTL, and
> cxl-dcd.sh passes.
> 
> QEMU:
> Tested extent add/release and DAX device create/destroy.
> Tested that expected errors are printed from malformed Get DC Configuration
> payload.
> 
> Anisa Su (1):
>   Documentation/cxl: Document DPA partition layout and ordering rules
> 
> Ira Weiny (7):
>   cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
>   cxl/mem: Read dynamic capacity configuration from the device
>   cxl/cdat: Gather DSMAS data for DCD partitions
>   cxl/events: Split event msgnum configuration from irq setup
>   cxl/pci: Factor out interrupt policy check
>   cxl/mem: Configure dynamic capacity interrupts
>   cxl/core: Enforce partition order/simplify partition calls
> 
>  .../driver-api/cxl/linux/cxl-driver.rst       |  35 +++
>  Documentation/driver-api/cxl/maturity-map.rst |   4 +
>  drivers/cxl/core/cdat.c                       |  97 +++++-
>  drivers/cxl/core/hdm.c                        |  24 +-
>  drivers/cxl/core/mbox.c                       | 285 ++++++++++++++++++
>  drivers/cxl/core/memdev.c                     |  94 ++++--
>  drivers/cxl/cxl.h                             |  14 +-
>  drivers/cxl/cxlmem.h                          |  88 +++++-
>  drivers/cxl/mem.c                             |   2 +-
>  drivers/cxl/pci.c                             | 176 +++++++++--
>  include/cxl/cxl.h                             |  29 +-
>  tools/testing/cxl/test/mem.c                  |   2 +-
>  12 files changed, 761 insertions(+), 89 deletions(-)
> 
> 
> base-commit: a90ee4305c4a5df72c11b31dacfdc76e00fcf78a
> -- 
> 2.43.0
> 
