Received: from mail-yx2-f41.google.com (mail-yx2-f41.google.com [74.125.224.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6CB376A0B
	for <nvdimm@lists.linux.dev>; Mon, 28 Sep 2026 23:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790639182; cv=none; b=RtmSvmjL2b4ljwctNmTNb1+f3I1IrZfNIyPzkFl2R6FI4eKfD/Wsnmvlcq2mUZB6g0ji3aVxqyJW0k5jA5AIPD+E8dPOmGz6Rg8UbyLq6Hm3sQ9j/2U+qko+75cSqn99HUsa0RUaMSyLqK4BohP0tgaeRtQQH2qSlXcvIOguicM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790639182; c=relaxed/simple;
	bh=8OHbbiZkLx94md3sQMK00u04gK5Y5O5bMMixwGDd1tg=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D6ZqmttK82DTESGynl2OXknRzTskigGfY1Ubcqo8+NMhHnt+KcbzFS9edpEf06/jCDHlTnxwJ4rAubK497+zykTZevMGAUko5zOHGzak3yz2XEw+Q15JDrkYbPnWleybFPfhZyR9qCvQDlTfR6KNJ3+Lus9QBsDNh8Zf6Y7csac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RXY33aN/; arc=none smtp.client-ip=74.125.224.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RXY33aN/"
Received: by mail-yx2-f41.google.com with SMTP id 956f58d0204a3-6737f134de1so2364464d50.2
        for <nvdimm@lists.linux.dev>; Mon, 28 Sep 2026 16:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790639180; x=1791243980; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oYlEo7yXk7/pIBZiHMkUiSaKnUE72TG2PrHzVkxWnFw=;
        b=RXY33aN/NsZrIWDCU4OagBx0W8rBDccdPMCqtcMw3/0xL3FmMrM/JQ6hFfGVGDq8A6
         gtANHchRZBPKrAcifBJoRi7UnkJJmxAmax/GLv61YoxxR72E+8fiuhANvmrRoGplOuDp
         RXhu1PoDAib1UyTE7oJs89HxKY1z4zEKfj4Ditv89uXaqBnlsZIeHuiSGvDUaJFvUh6L
         N2gUCdYP4hMzuX+oDbHrLO82mTTkBrpP/oeSlO/C0y7LpaOADQicuUxHj0zqGLgswn8m
         ZruNKJrDk2CwS/XBVjJsjXxoHTRrxAG4XW7+mI1seAB1nO9gAKJGDTWOHVGl/kwrirGq
         p5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790639180; x=1791243980;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oYlEo7yXk7/pIBZiHMkUiSaKnUE72TG2PrHzVkxWnFw=;
        b=NRIxX0Dgcewh4sPqGGeZEb+nZNt/076y+MJzcIXsJjyzLZ2EHo7rMUg8FULCbQasLT
         MDIFO5LSXKLD2ZBon4jEUlNle1X5qggbP+o4pCSTPiY19tawOSbsZkC/HzfD3v25PkgN
         kvmBo+GEEvOgZ1FaiNvPZzPmdIeOs3tnJymiCcYG2OhD79/y+lN/0k3ycDXzp+YxJTt3
         SvY02n0Csxs6QPfSb85ci/UGeiTEjw21Qxe/jPxn11Lu8mQBwchDUCqGZ1GFnHhhh3lq
         Bz12O5j+TSzNP3vnKuZJAAPoCaobg96PYj2R2z51Ugu9qyKEv3FpmXAH2kD4CGJj/YNU
         cWKA==
X-Forwarded-Encrypted: i=1; AKwUvByzlKNVc4IzGVIPnLIsyu/2/UljzYTgIHCge+R7DBe3RERY7a94Pp6JaNvbdnS9zRXdT29Wr8Q=@lists.linux.dev
X-Gm-Message-State: AFq9FYJMeOfyI2wNI54Crs3qZo7QaHWDigDi90kp6WrASSRibpbNmVwJ
	4g1z6WrJMppKTA0NztZEOYsDPWWB4WC/uYIOWwKcX9oySYijl3a/Shv9fbOhwQ==
X-Gm-Gg: AYBFou2ilAJEbuprj7v06sKSAqXR31ZgJ6ZsTIWbmv/RBn7wPMP3yzfWcTdqZatM+P4
	p5jJi9IsS9A2t9D0xFM41uX/B7GKTE4STBBvx0YVZXANbmrRps2BdKOYTTFVeHoNBVqijRz0GsG
	ZtcK5yHvr4it5me9AB1ufp/CMmZ1q9hM6zYqqehElblzMaT+bKnbTWp6SZfppgAPEnNdG3JTMIM
	cMTzg79APHHz2DhhoSl05pA4FrfNe8u+Q3dQJ7Fv04dsJ6Gixa7Mtq04SNMolZYTCs1J5yIEiKg
	EAEymZSN8KqK5+s7FyDHg8sy3r01TN7DGC9LwzvPgKRGV2xA5WbVynCKvHdcGlpoYdiFA4pT/A9
	jyR1Tudts5ku/eISK3UeHixTF9wQUiEAbgoR+mvJVP6UznJ7kc8YDLUZ+/HkD1YJigGFh0HWXc2
	jgYJthZzHYddkplWvTy16Gky2Wfo6BBYxk9RYtMFlxIKUA1Tx4cb7cVz47cgcH5f3P1e3KwFt+/
	UR88tsIggvJoO1d+aUUza0oom34OCN9XgDpmqGPq4+wJj/K3yftq2PPch2z
X-Received: by 2002:a05:690e:e8b:b0:674:1336:7d5b with SMTP id 956f58d0204a3-67413368232mr3568896d50.52.1790639179917;
        Mon, 28 Sep 2026 16:46:19 -0700 (PDT)
Received: from 4470NRD-ASU.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6740ef7de00sm5414705d50.15.2026.09.28.16.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 16:46:19 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Mon, 28 Sep 2026 16:46:17 -0700
To: Jonathan Cameron <jic23@kernel.org>
Cc: Anisa Su <anisa.su887@gmail.com>, sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v12 3/8] cxl/cdat: Gather DSMAS data for DCD partitions
Message-ID: <arr8ScmcSiuq8RIH@4470NRD-ASU.ssi.samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-4-anisa.su@samsung.com>
 <20260731090250.0C8DE1F000E9@smtp.kernel.org>
 <20260804010748.7f9f8174@jic23-huawei>
 <anL0mD3DKfwJh4UY@AnisaLaptop.localdomain>
 <20260922003402.5134db4a@jic23-hlaptop>
 <arSnRvG0VGSMHSBM@4470NRD-ASU.ssi.samsung.com>
 <20260925201932.292f1451@jic23-hlaptop>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925201932.292f1451@jic23-hlaptop>

On Fri, Sep 25, 2026 at 08:19:32PM +0100, Jonathan Cameron wrote:
> On Wed, 23 Sep 2026 21:29:58 -0700
> Anisa Su <anisa.su887@gmail.com> wrote:
> 
> > On Tue, Sep 22, 2026 at 12:34:02AM +0100, Jonathan Cameron wrote:
> > > On Wed, 5 Aug 2026 01:30:16 -0700
> > > Anisa Su <anisa.su887@gmail.com> wrote:
> > >   
> > > > On Tue, Aug 04, 2026 at 01:07:48AM +0100, Jonathan Cameron wrote:  
> > > > > On Fri, 31 Jul 2026 09:02:49 +0000
> > > > > sashiko-bot@kernel.org wrote:
> > > > >     
> > > > > > Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> > > > > > - [Medium] The commit message claims to extract and store the 'read only' attribute from DSMAS tables, but this logic is completely missing from the code.    
> > > > > 
> > > > > Given it will make a lot of difference to a user if they think they have writeable
> > > > > memory that isn't - I think we probably do want to have readonly here.
> > > > >     
> > > > I did some digging: it seems in v8, the read only flag was gathered and
> > > > exposed in sysfs, but dropped during the region -> partition rework.
> > > > 
> > > > v8 of this commit used to do:
> > > >     dent->read_only = dsmas->flags & ACPI_CDAT_DSMAS_READ_ONLY;
> > > >     ...
> > > >     mds->dc_region[i].read_only = dent->read_only;
> > > > 
> > > >     https://lore.kernel.org/all/20241210-dcd-type2-upstream-v8-6-812852504400@intel.com/
> > > > 
> > > > and a following patch exposed it, with a documented ABI:
> > > > 
> > > >   https://lore.kernel.org/all/20241210-dcd-type2-upstream-v8-7-812852504400@intel.com/
> > > > 
> > > >     /sys/bus/cxl/devices/memX/dcY/size
> > > >     /sys/bus/cxl/devices/memX/dcY/read_only
> > > >     /sys/bus/cxl/devices/memX/dcY/shareable
> > > >     /sys/bus/cxl/devices/memX/dcY/qos_class
> > > > 
> > > > In v9 dynamic capacity moved from its own dc_region[] array and dcY/
> > > > sysfs directory to the generic partition model:
> > > > 
> > > >   https://lore.kernel.org/all/20250413-dcd-type2-upstream-v9-3-1d4911a0b365@intel.com/
> > > > 
> > > > size and qos_class survived that move because ram and pmem already have
> > > > them. read_only and shareable did not, because the generic partition
> > > > model had nowhere to put attributes that only dynamic capacity has, but
> > > > the commit message survived the rework.
> > > > 
> > > > More specifically, read_only was dropped from both the sysfs commit and
> > > > this commit. shareable was dropped only from the sysfs commit, but still
> > > > read from the DSMAS entry in v9 of this commit. Not sure why though; I
> > > > didn't see any consumers of the attribute. Oh well... We use it now
> > > > since shared extents are supported to check if an extent marked shared
> > > > is actually in a shared partition.
> > > > 
> > > > So TLDR; I've removed the "read only" part from the commit message. But
> > > > let me know if you think it should be re-introduced?
> > > > 
> > > > I agree with what you said about it being important for a user to know
> > > > whether a partition is read only. Some things to consider:
> > > > 
> > > > - The partition model has no precedent for a DC only attribute.
> > > >   dynamic_ram_1/ currently exposes size and qos_class, the same two that
> > > >   ram/ and pmem/ expose. Adding read_only there would be the first
> > > >   attribute that exists for one partition mode and not the others.
> > > > 
> > > > - shareable is in exactly the same position. It is gathered and used
> > > >   internally but not exposed anywhere, so if we are adding one of these
> > > >   back we should probably decide about both.  
> > > 
> > > I vaguely recall the discussion on this ending up with we'd call the
> > > partition something different to reflect the extra property.  
> > > 
> > > dynamic_readonly_1 / dynamic_sharedram_1 maybe?  Argument being
> > > that these properties are as different from normal RAM as persistent
> > > memory is.
> > >   
> > Yeah I think we discussed making it its own partition mode but I don't think there
> > was a strong consensus, just that we agreed it should be exposed somewhere,
> > somehow...
> > 
> > I am leaning towards just putting it under dynamic_ram_1 even though
> > these attributes would only exist for dynamic_ram mode:
> > 
> > /sys/bus/cxl/devices/memX/dynamic_ram_1/shareable
> > /sys/bus/cxl/devices/memX/dynamic_ram_1/read_only
> > 
> > Mainly because if we go up to 8 partitions, we would have
> > (dynamic_ram, dynamic_shared, dynamic_readonly, dynamic_shared_readonly) * 8.
> > And NDCTL would have to know how to handle creating each type.
> > 
> > I also don't see anything in the code that makes it terrible:
> > - each partition mode has its own attribute array and visibility callback
> >   function, so it doesn't affect ram/pmem modes
> > 
> > I brought it up because I wasn't sure if there was a specific reason why
> > shareable and read_only weren't carried over after the partition
> > rework. From a code standpoint, it seems fine to me?
> > I assumed it was so all partitions would share common sub-attributes
> > but I guess I shouldn't have assumed...
> 
> I think this needs another discussion. I agree there were differences
> of opinion but thought we'd ended up with the different names rather
> than attributes for each one.
> 
I might have misremembered. Let me ask for some eyes on this.

Here's my case for adding shareable and read_only as a sub-attribute:

Shareable and read-only are independent bits, and a DC region can be
both, so we have 4 possibilities: dynamic_ram, dynamic_shared, dynamic_readonly, dynamic_shared_readonly.
Every consumer of the mode string grows with it: the memdev group
names, the decoder mode store, the mode-name helper in hdm.c, the
region mode description, cxl_test, QEMU and ndctl. If a third
property comes up later (but probably not?), it would double again.

What it would look like for new modes:

enum cxl_partition_mode {
 	CXL_PARTMODE_RAM,
 	CXL_PARTMODE_PMEM,
 	CXL_PARTMODE_DYNAMIC_RAM_1,
+	CXL_PARTMODE_DYNAMIC_SHARED_1,
+	CXL_PARTMODE_DYNAMIC_READONLY_1,
+	CXL_PARTMODE_DYNAMIC_SHARED_READONLY_1,
 };
 
+static inline bool cxl_partmode_is_dc(enum cxl_partition_mode mode)
+{
+	return mode >= CXL_PARTMODE_DYNAMIC_RAM_1;
+}

static const char *cxl_mode_name(enum cxl_partition_mode mode)
 		return "pmem";
 	case CXL_PARTMODE_DYNAMIC_RAM_1:
 		return "dynamic_ram_1";
+	case CXL_PARTMODE_DYNAMIC_SHARED_1:
+		return "dynamic_shared_1";
+	case CXL_PARTMODE_DYNAMIC_READONLY_1:
+		return "dynamic_readonly_1";
+	case CXL_PARTMODE_DYNAMIC_SHARED_READONLY_1:
+		return "dynamic_shared_readonly_1";
 	default:
 		return "";

If support for partitions 2-8 is added later, this multiplies by 8.

NDCTL would also need to support 4 modes of region creation:

cxl create-region ... -t dynamic_ram_1/dynamic_shared_1/dynamic_readonly_1/dynamic_shared_readonly_1

Counter argument:
Shareable and read_only are different enough from "regular" DC that
they should be their own modes. Since PMEM isn't expressed as a adding
a "persistent" attribute under ram/, the same should apply for shareable
and read_only. Especially since pmem can't be onlined as system RAM
through the normal path, the logic should also apply to
shareable and r_o.

If we prefer separate partition modes, I can do that, but we gotta decide
now because partition setup is in the prep series.

> > 
> > > > 
> > > > - I don't think the DSMAS Flags bit 6 (read only) is specific to DCD?  
> > > 
> > > In theory yes, in practice there isn't a path for non DCD to actually
> > > get the data in place and transtion to read only so maybe an expensive
> > > source of zeros?  So yes allowed but not much use to anyone so we
> > > won't see it.  
> > >   
> > Mmm very true. You might just clarifying this point here but just to make
> > sure we're on the same page: I dropped the R_O part of the series and deferred
> > it for the future because it includes implementing write rejection for
> > r_o partitions which IMO can be done after the core functionality is in.
> 
> Why do we need to reject writes?  The device just drops them. Maybe
> it is a nice to have to prevent the mapping path setting up writeable mappings
> and so fault earlier but I'm not sure it is necessary.
> 
I see. I thought it would be better to do it since the dropped write
is silent?

CXL r4.0 Section 9.13.3 "If the host issues a write to any DPA in a
read-only DC Region, the device shall drop the write and send an NDR
(see Section 3.3.9) as a response". I assume the rc is an ordinary Cmp,
which is returned for "completions for writebacks, reads and
invalidates" (Section 3.3.9 Table 3-50).

So any user that that maps the dax device writable thinks its stores
landed which seems not very good.

Anisa

> > 
> > Thanks,
> > Anisa
> > > >   It describes any device scoped memory range, so a read only ram or pmem
> > > >   partition is expressible in CDAT today and the driver ignores it.
> > > >   Maybe it should be exposed in sysfs for every partition
> > > >   rather than only on dynamic_ram_1? Which probably makes it a generic CDAT/partition
> > > >   patch rather than something for this series.
> > > >   
> > > Jonathan
> > >   
> 
