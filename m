Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2534B2BCF45
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 20:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770063776; cv=none; b=pXB54NS6tNii1kgb7uBsITAsX0XUrMvKBNn6gCguwdYDICmx8bIh9Zlyk9dfsg9HZFbuokHV67c779OWnPi2XSnGG5LaAhiv3qoq5WRzXXGHt7//Yii47ta9t2fnvkpLF+VAqt9X7tfds+8+8tyGDkkFIuspp/ED871PTBx8Eq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770063776; c=relaxed/simple;
	bh=JQfcfUUd8XuDiRHFdF+25+0jAwh/fTTxY7PfkjJ42ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uXda+tooUes24Cn60t7dBsQFRIFQM1bYOdrZ5bICuTeNlWd/FIo5wX3urAZdBX7X/aetPWKD9MjQf0t4/NnGTACMcSP7axRMLmv14mJSVMGNDv8QdJyc42UXZJmcSfK9fq09HBYSJTCPxxWX69QUs5INxlKwewXWXBE/EXe19Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=rRVv08pl; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="rRVv08pl"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-502acd495feso56369191cf.2
        for <nvdimm@lists.linux.dev>; Mon, 02 Feb 2026 12:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770063773; x=1770668573; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A5DQQ/80oIeISv/l0flaFn2oFu98ezlgiuT9SahjHUQ=;
        b=rRVv08plakymBv5PTWXnGV64CaLXNWJlBAQNmtglQCxSmumUcOjL782mqt0zT2yJhM
         FIwwdFHPpfDjWAr+BMbJEB0HVF5KaxZArWog9CO/eDXZTD3X3NVHc9HBstvO9FLMBjjZ
         x7cIOp4x/i/NabWq2DHoiFwlQ/ybTvPOsM3gXOZnpZU+RsR6onkuBzjm6ZpjmXTEG4yz
         pnIHpHfn/58zAxVRevGWSiQzQckv4uxjpMpJcERdaaxdDtCj6M/6jVQaf8FoHodW0vtL
         3bBzODCDoN9YzVlFEk4+s1RmSwQp9ohrdtVeve2hBtTBqnAi2cbzj6+3dYvxKbClj3tp
         V16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770063773; x=1770668573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A5DQQ/80oIeISv/l0flaFn2oFu98ezlgiuT9SahjHUQ=;
        b=EGvnwe98tkF4UXYU84mbj56KwEQ57Ou/mpMXOmY0yr5kHhjrKSDMmd91KRKqUkquxt
         tOdAeqsYZigfRnADHd5S8bwxA4ihn9V6AJ/LfQy++OViIg/EVRmhLapqunMxXNDgzpzj
         PinLlu5AH/7NdgtFIiPD5EtDEMFTE7xXE5WmnZkqeB8x1KdnS8NQdOcSZlkHC3UIJ1Di
         Z6FwBTXARVpxrmTozt2fGjk74hMjrQTLdSen5vqllwHV2y1EDYZE+6P6SW6GXRh4iAh0
         urTMoaP5xKa6vKw4g2MK4D6iWcyABa8Cjcl+pVUglb3xZEz0v0gAroDEGTHkt99R0iIv
         RQiQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4qtq8DC0mZQJGalVhCVM6y/LwWSE9wWImrJnj8qeilqNo2K0Fp5lVYeBvM0FLVqrsFzwUEjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKs/Bf8YDY/rBJSXnuzvegwi8pSwmRrrxyhUqRI6dW4huAdbEO
	NvzNaE3tSW+ljc0fWcDbykd6zgi90MRqMB7Xm64O9AoSNSQ76aqFSXVbo5ZVm2oe6CI=
X-Gm-Gg: AZuq6aJxt7Q/OuUEcxSsx5/VQGQuhG0PBiC/l+GO/HWegqa4KEL6jPdff1Jg+0aM5wR
	SrsZdPY3IFoZ9pYmoQnI2GgKDqEl/m9JSo0Z3caNsG9WifEIxKKtfX7Jw7usAkzG1eaDODJfIr5
	oAKigXR7D5Kt/n/apRWEUsl5zSBM0j3XkQrsc2Gw+V41vGBfUdMxty80H1SkhVoZLLhBRCorMdn
	V87gX/g7dkw7Zpg+wvd1NtUx8vQpPY9r4hnjuiulwcwl7NClBxEOeQ1Np86vTvts8eGUFL+Wakt
	KAIOUlTfxQe2LkbKPQqQc0dcH+0/rT9ji46Z9ame7cTsAms51BzI7FAGVhhTien1cNiqO9d+akV
	v9/MfiANL9Dp/cjlWwGz9arQ0ePZSRowUArFGG3m42BPPjjC2jXeKe2Nl8tTbp1sXi1kiWv1Z+b
	6L4kuFy0YAaPdtVa8b0wGOLPwo3mrEUv5OHEK5bCaZVxJbICF40/hZmzjqMLRZCp8pTqCDsg==
X-Received: by 2002:ac8:7d86:0:b0:4ee:c1a:f11f with SMTP id d75a77b69052e-505d22fa7ccmr153965971cf.84.1770063772904;
        Mon, 02 Feb 2026 12:22:52 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50337ba3981sm112708281cf.16.2026.02.02.12.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 12:22:52 -0800 (PST)
Date: Mon, 2 Feb 2026 15:22:50 -0500
From: Gregory Price <gourry@gourry.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <aYEHmjmv-Z_WyrqV@gourry-fedora-PF4VCD3F>
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

Extreme necro-bump for this set, but i wonder what folks opinion is on
DCD support if we expose a new region control pattern ala:

https://lore.kernel.org/linux-cxl/20260129210442.3951412-1-gourry@gourry.net/

The major difference would be elimination of sparse-DAX, which i know
has been a concern, in favor of a per-region-driver policy on how to
manage hot-add/remove events.

Things I've discussed with folks in different private contexts

sysram usecase:
----
  echo regionN > decoder0.0/create_dc_region
  /* configure decoders */
  echo regionN > cxl/drivers/sysram/bind

tagged extents arrive and leave as a group, no sparseness
    extents cannot share a tag unless they arrive together
    e.g. set(A) & set(B) must have different tags
    add and expose daxN.M/uuid as the tag for collective management

Can decide whether linux wants to support untagged extents
    cxl_sysram could choose to track and hotplug untagged extents
    directly without going through DAX. Partial release would be
    possible on a per-extent granularity in this case.
----


virtio usecase:  (making some stuff up here)
----
  echo regionN > decoder0.0/create_dc_region
  /* configure decoders */
  echo regionN > cxl/drivers/virtio/bind

tags are required and may imply specific VM routing
    may or may not use DAX under the hood

extents may be tracked individually and add/removed individually
    if using DAX, this implies 1 device per extent.
    This probably requires a minimum extent size to be reasonable.

Does not expose the memory as SysRAM, instead builds new interface
    to handle memory management message routing to/from the VMM
    (N_MEMORY_PRIVATE?)
----


devdax usecase (FAMFS?)
---- 
  echo regionN > decoder0.0/create_dc_region
  /* configure decoders */
  echo regionN > cxl/drivers/devdax/bind

All sets of extents appear as new DAX devices
Tags are exposed via daxN.M/uuid
Tags are required
   otherwise you can't make sense of what that devdax represents
---

Begs the question:
   Do we require tags as a baseline feature for all modes?
   No tag - no service.
   Heavily implied:  Tags are globally unique (uuid)

But I think this resolves a lot of the disparate disagreements on "what
to do with tags" and how to manage sparseness - just split the policy
into each individual use-case's respective driver.

If a sufficiently unique use-case comes along that doesn't fit the
existing categories - a new region-driver may be warranted.

~Gregory
