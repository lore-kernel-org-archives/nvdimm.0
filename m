Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0484621D3C0
	for <nvdimm@lists.linux.dev>; Tue, 15 Apr 2025 02:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744685263; cv=none; b=iVHtGpKmhXNResJr/P8TUBsD7CslOHKjfAksg1rxeFMiodkznMhBjP542UfLgG8HzDlzdXjW+9pLGHbhlWdQeJs1TzHkNorZAWJlcwoCtkT9EaLDxtuvW3pS3/jQTwKoGAEnxsVJqoPxK3Pu0cGIhwiDtjzwJ5rr5jfXVtOJ9gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744685263; c=relaxed/simple;
	bh=nGGYa/bok5qJ8KVw7OSMgHlxCvXTiVuD2OOmgM0FeYU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sGCEZGppQw01ljIMsIz86wv71HMCFU9qnvb9gWrf9xnz/juC878NWYSTmpw2T1ggXZX+eb2R4uRPA2qqrCImcF1fhtdjp8MC0HR2YMbwxTc2bhNvdq1u6PjHHJCsqaZCyjRIM7yEzxJD5Hn0UY846m8ByZV4JOuZvJneudFWeVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pu3te+TT; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pu3te+TT"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2255003f4c6so51563005ad.0
        for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 19:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744685261; x=1745290061; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cWvpma1dORIiySs5jF5nA8uB3wDE1U9RthmOs2kPK+Y=;
        b=Pu3te+TT4uI5Vb7Gns6Ucd7bP6ww+ptFqLpczLz4U9s0J7BGLzGHIKZaCv3dYNLrar
         ttGkEgVyBdQ7v4H02WIuEaaufLfxrYQZqfbQeju5+e1hn3AWI3GMWu4iDcxzFhsucmqQ
         UUd7yeAniXLj47We3g5uOkzDi3GdqD51z9Fi/WOdiYRwIaoKmV5gS+lTcPaRfoONNWAf
         Pf28DtiDLAdZR8azugG67Ex1Dg8Q0hXLnIYkRpJ2Dk9AgaHymIiYdkUawK6wVstgqghn
         sFmpqnzwbf5qT2OA0Kla5vC1trNV3J7ur4m6o2bRmfqkuG90nV3UcWUetOb8rabhvAZd
         zGpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744685261; x=1745290061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cWvpma1dORIiySs5jF5nA8uB3wDE1U9RthmOs2kPK+Y=;
        b=Os8HhDA54Eiwe4HeePlQl3CzHUGTLGgRMGr715i6qU16u8rOVc6MmCIQi79YXpNdkI
         AJp8XpXODMcuszTipRVvS97rlG/aGYlcufgteDfatz5Vz9/RAttK9Z7jsfM5VsHTNem+
         JhdthVLCgcgOMHDzqH8B1wKfVCcTbY3/Z3E3/HgyMoTlL26xPPjNGHmtoAIJd9OciGeI
         mLxAK/HbGOioCKAJp4FOTTL/RkGWDXpkCnABYvhBZo9wJm/SA6jFvZD2ELN+QZXi51Zr
         88uwXQ1xpq8suzTheFuYxmtV1xfcd+lNVGecssarBI3WEmZDAzwq0lio5J1JyEgnN6EQ
         pZvw==
X-Forwarded-Encrypted: i=1; AJvYcCXjPfvD35LBRbKa9MnrJjK24GhAScCv3fXpVJ150TnQ/D5/LxkHI7YaRYY4DLzYElfTT/022L8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyB9SaG2LC2qLXvpomrYc/RyhM4e5gnJ48aXVCyW1oUYvlIz4OT
	urnH4kyR8P71ASBpAs+bnHg84ss1kOSHOCV9VmMbZMxnMz++Bbfw
X-Gm-Gg: ASbGncvfNiWQmip03c6l5x6Mt3RCmSiVuf1PmIjX126MsKRtHmdv+tb5Q5DBznlS2IP
	/ljHghcNxiU0bVSBl4F6l2AwypIocg/ztJcXvugotcPdyox6fvmtfH8PWKGByszo6Npc+7TRY0I
	q/HvAD7KxBQ0PIuYufDx4L6WhT/Mu8NcIm7/xJYScuDNRPBdLdH5BsYIMrYDH7769wOlopYsYAu
	Hl8FyO4RYgu0gncjQyAVpm+vNudMNX9HnUA8yoE0r2HcZJeahb3zmL6AscSokuah0B7cjgM1djz
	yAHCD7S1zyjmqhgdKkWOypqI/RrDxTLvoa5U
X-Google-Smtp-Source: AGHT+IHBix5KPP3nRhmwiVvvlwa79tN2lYjB87B7Yo6JZ4XsMjjb6cCLThbByHf08kY8KD0bEF4xHQ==
X-Received: by 2002:a17:903:3c44:b0:223:517c:bfa1 with SMTP id d9443c01a7336-22bea4efa84mr222013945ad.38.1744685261112;
        Mon, 14 Apr 2025 19:47:41 -0700 (PDT)
Received: from debian ([2601:646:8f03:9fee:5e33:e006:dcd5:852d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22ac7c97298sm106915325ad.138.2025.04.14.19.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 19:47:40 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Mon, 14 Apr 2025 19:47:38 -0700
To: Ira Weiny <ira.weiny@intel.com>
Cc: Fan Ni <nifan.cxl@gmail.com>, Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <Z_3Iyk7oj-EiJWgX@debian>
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

That is my setup.

root@debian:~# cxl list -r region0 -N
[
  {
    "region":"region0",
    "resource":79725330432,
    "size":2147483648,
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
root@debian:~# cd ndctl/
root@debian:~/ndctl# git branch
* dcd-region3-2025-04-13
root@debian:~/ndctl# ./build/daxctl/daxctl create-device -r region0 -v
libdaxctl: __dax_regions_init: no dax regions found via: /sys/class/dax
error creating devices: No such device or address
created 0 devices

root@debian:~/ndctl# cat .git/config 
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
[remote "origin"]
	url = https://github.com/weiny2/ndctl.git
	fetch = +refs/heads/dcd-region3-2025-04-13:refs/remotes/origin/dcd-region3-2025-04-13
[branch "dcd-region3-2025-04-13"]
	remote = origin
	merge = refs/heads/dcd-region3-2025-04-13


Fan

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
