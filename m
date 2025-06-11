Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16837215F72
	for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749661899; cv=none; b=FfErfzhUX3aKtEJOKe7Gm8K1iBCzzoUZbrnOlLupdUcGmATwLSNQqbcMUhnwcBD0e8bX5R5PguE/cFTDDPLXBW2INFn7rpElP3IJPMecI3DCtuSpt+gPnc0rPufD+exRkaSaq2vWVvS1QWxFe3/7q82g2M+lQT7juqMMuigN0qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749661899; c=relaxed/simple;
	bh=0rrg/j7xfhTAkqxbkBAoMJ5H3OvvTULkSZkoAyObnB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h38kyadrHM2kdDSp1RDV2LF2bHkOjczvT7B5b7c/eX1KHbLNugDaHN1WqbXmXpvmLU9Hv77yn76XE+1tEDcJH0vCD1p0+H26E9sp2dr3LFflL+J7CvPEx+arsdvQP5WRdvPzPRDOMNgcxIgeAqn1KWy0059S80m1uexkJ4hGRHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com; spf=none smtp.mailfrom=pdp7.com; dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b=uw7t25XI; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=pdp7.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b="uw7t25XI"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-742c3d06de3so163537b3a.0
        for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 10:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pdp7-com.20230601.gappssmtp.com; s=20230601; t=1749661894; x=1750266694; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DucyK9ccxpyapq2woQL0qei/WtX3FmKICxB9cQHabrs=;
        b=uw7t25XIqfZFswMVB7vy/SGbIYP0BUbJtChPLj/j9H53xq4MOipoInjIC43X6AV/p/
         y4d1hh8bLqIoARec2D10LnscAZBhW40QZIpIOIbJNijemI9WCUZ4yStOEKUqCbU61gK1
         kRgQE7uB1+rn7PlqeP17blnW20ng0r9QI3VLfI4namwPYnzG4HpvQUIMeYhxXo8FrCuV
         mgkQBZAGncuQB0OVj9RNBW75rBfvrV+hVXEe4AOd8TpBuCJ6KBF2slmDXMPomI7PYiEe
         FBwAH7Adjr9wO+Nc5XFyRTwKFTpa6wRKoqBU62LcDwEuawxNqZ3bUZkBXqW85V4nD0gE
         DBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749661894; x=1750266694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DucyK9ccxpyapq2woQL0qei/WtX3FmKICxB9cQHabrs=;
        b=wYKeVx+/pcytD2vJtjLDLdr3OS2KhJFJ5/PKw/kl+D/ALur0LBGAZUAI7zt2yzyinx
         sw0Fs3rEtmfXMiasWS7lh14rbBHFGvcvOwRrHDLfIASsCxqX3h89TT28byQyrSEEjfmz
         NiiSmbqFUjzutjDZ6i6Kgejt3S7qCaD3E6hOQCMXKPOcjGXgG1Qu1/pcDmKUVKQ+b4Vj
         3ZiiEo47JvOGGJ36mfY/+kBtgeGc2HHpI7GpyV5rC8fzM7Htj2g+OdemZyB8Pv680zWr
         LROSLajyQgL//nkzMPN1bLs0iG63jIYEy+BUC/hV/yXVtdDyypxygAfFw/J8uwKIOewi
         saNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcDBmVlgLbQMyBGY+ztRbk9H98K18VNHHqp6Zyy2cgzV0yUuMy0IKTeiXjUr2S/IZFpWz3g+c=@lists.linux.dev
X-Gm-Message-State: AOJu0YwB+Qua+CN5szb+57KMikkknR1N1IvagYkOj9699rfKhKQ94H+j
	y/TUYVSqC9WSY+bd69l0Oue5VC8h+iQp0jBuxuFEDhEHEFu0NB2iUo0N1BfPp1k/0UI=
X-Gm-Gg: ASbGncvyjI9S2rgMItrMfvpe328CpzM1uec45m0S6w5J75nvZJvpDmsOgkRssk3oIUM
	T3Q9RwI743IId2320cQymH3A603GOAnzpzPp9uZZ9yJhNhsBHOSIYG0KnFdt788oZQFjybu0TTf
	aGX5Fei6nw668aZ14ObOMvTaRmQLjS2lUtb6CWySYs/3msYpYpRjNEstp6nAb3FjuCf+4HiNYkv
	55xXcjL5t6dq9q7Dk1JBI4hbRNv2HSiZ/D+cbmnFaqKHKbvB9NK594vS+0HVPpKx+2DE/xqsC2L
	X3mAFSwwk/jxokF7YbZXxiX7JuY12pwKaMhiIvdy/QHnZO0j0MdMb6TuP/PW7o9oW1NTYW4gfw=
	=
X-Google-Smtp-Source: AGHT+IHPKfiVh9BBq/DHFeVf8RX9T6viUqIN5WUKbWYGpanTpWtdV+/1EZm0Ddh9RKSSQMvhDeO7Ig==
X-Received: by 2002:a05:6a21:998a:b0:1f5:9d5d:bcdd with SMTP id adf61e73a8af0-21f97753907mr937975637.1.1749661894141;
        Wed, 11 Jun 2025 10:11:34 -0700 (PDT)
Received: from x1 (97-120-245-201.ptld.qwest.net. [97.120.245.201])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482b083f05sm9373821b3a.89.2025.06.11.10.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 10:11:33 -0700 (PDT)
Date: Wed, 11 Jun 2025 10:11:31 -0700
From: Drew Fustini <drew@pdp7.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Rob Herring <robh@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev,
	Oliver O'Halloran <oohall@gmail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v3] dt-bindings: pmem: Convert binding to YAML
Message-ID: <aEm4wztFPMY0KKC4@x1>
References: <20250606184405.359812-4-drew@pdp7.com>
 <20250609133241.GA1855507-robh@kernel.org>
 <aEh17S0VPqakdsEg@x1>
 <684993ad31c3_1e0a5129482@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <684993ad31c3_1e0a5129482@iweiny-mobl.notmuch>

On Wed, Jun 11, 2025 at 09:33:17AM -0500, Ira Weiny wrote:
> Drew Fustini wrote:
> > On Mon, Jun 09, 2025 at 08:32:41AM -0500, Rob Herring wrote:
> > > On Fri, Jun 06, 2025 at 11:11:17AM -0700, Drew Fustini wrote:
> > > > Convert the PMEM device tree binding from text to YAML. This will allow
> > > > device trees with pmem-region nodes to pass dtbs_check.
> > > > 
> > > > Acked-by: Conor Dooley <conor.dooley@microchip.com>
> > > > Acked-by: Oliver O'Halloran <oohall@gmail.com>
> > > > Signed-off-by: Drew Fustini <drew@pdp7.com>
> > > > ---
> > > > Dan/Dave/Vishal: does it make sense for this pmem binding patch to go
> > > > through the nvdimm tree?
> > > > 
> > > > Note: checkpatch complains about "DT binding docs and includes should
> > > > be a separate patch". Rob told me that this a false positive. I'm hoping
> > > > that I can fix the false positive at some point if I can remember enough
> > > > perl :)
> > > > 
> > > > v3:
> > > >  - no functional changes
> > > >  - add Oliver's Acked-by
> > > >  - bump version to avoid duplicate message-id mess in v2 and v2 resend:
> > > >    https://lore.kernel.org/all/20250520021440.24324-1-drew@pdp7.com/
> > > > 
> > > > v2 resend:
> > > >  - actually put v2 in the Subject
> > > >  - add Conor's Acked-by
> > > >    - https://lore.kernel.org/all/20250520-refract-fling-d064e11ddbdf@spud/
> > > > 
> > > > v2:
> > > >  - remove the txt file to make the conversion complete
> > > >  - https://lore.kernel.org/all/20250520021440.24324-1-drew@pdp7.com/
> > > > 
> > > > v1:
> > > >  - https://lore.kernel.org/all/20250518035539.7961-1-drew@pdp7.com/
> > > > 
> > > >  .../devicetree/bindings/pmem/pmem-region.txt  | 65 -------------------
> > > >  .../devicetree/bindings/pmem/pmem-region.yaml | 49 ++++++++++++++
> > > >  MAINTAINERS                                   |  2 +-
> > > >  3 files changed, 50 insertions(+), 66 deletions(-)
> > > >  delete mode 100644 Documentation/devicetree/bindings/pmem/pmem-region.txt
> > > >  create mode 100644 Documentation/devicetree/bindings/pmem/pmem-region.yaml
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/pmem/pmem-region.txt b/Documentation/devicetree/bindings/pmem/pmem-region.txt
> > > > deleted file mode 100644
> > > > index cd79975e85ec..000000000000
> > > > --- a/Documentation/devicetree/bindings/pmem/pmem-region.txt
> > > > +++ /dev/null
> > > > @@ -1,65 +0,0 @@
> > > > -Device-tree bindings for persistent memory regions
> > > > ------------------------------------------------------
> > > > -
> > > > -Persistent memory refers to a class of memory devices that are:
> > > > -
> > > > -	a) Usable as main system memory (i.e. cacheable), and
> > > > -	b) Retain their contents across power failure.
> > > > -
> > > > -Given b) it is best to think of persistent memory as a kind of memory mapped
> > > > -storage device. To ensure data integrity the operating system needs to manage
> > > > -persistent regions separately to the normal memory pool. To aid with that this
> > > > -binding provides a standardised interface for discovering where persistent
> > > > -memory regions exist inside the physical address space.
> > > > -
> > > > -Bindings for the region nodes:
> > > > ------------------------------
> > > > -
> > > > -Required properties:
> > > > -	- compatible = "pmem-region"
> > > > -
> > > > -	- reg = <base, size>;
> > > > -		The reg property should specify an address range that is
> > > > -		translatable to a system physical address range. This address
> > > > -		range should be mappable as normal system memory would be
> > > > -		(i.e cacheable).
> > > > -
> > > > -		If the reg property contains multiple address ranges
> > > > -		each address range will be treated as though it was specified
> > > > -		in a separate device node. Having multiple address ranges in a
> > > > -		node implies no special relationship between the two ranges.
> > > > -
> > > > -Optional properties:
> > > > -	- Any relevant NUMA associativity properties for the target platform.
> > > > -
> > > > -	- volatile; This property indicates that this region is actually
> > > > -	  backed by non-persistent memory. This lets the OS know that it
> > > > -	  may skip the cache flushes required to ensure data is made
> > > > -	  persistent after a write.
> > > > -
> > > > -	  If this property is absent then the OS must assume that the region
> > > > -	  is backed by non-volatile memory.
> > > > -
> > > > -Examples:
> > > > ---------------------
> > > > -
> > > > -	/*
> > > > -	 * This node specifies one 4KB region spanning from
> > > > -	 * 0x5000 to 0x5fff that is backed by non-volatile memory.
> > > > -	 */
> > > > -	pmem@5000 {
> > > > -		compatible = "pmem-region";
> > > > -		reg = <0x00005000 0x00001000>;
> > > > -	};
> > > > -
> > > > -	/*
> > > > -	 * This node specifies two 4KB regions that are backed by
> > > > -	 * volatile (normal) memory.
> > > > -	 */
> > > > -	pmem@6000 {
> > > > -		compatible = "pmem-region";
> > > > -		reg = < 0x00006000 0x00001000
> > > > -			0x00008000 0x00001000 >;
> > > > -		volatile;
> > > > -	};
> > > > -
> > > > diff --git a/Documentation/devicetree/bindings/pmem/pmem-region.yaml b/Documentation/devicetree/bindings/pmem/pmem-region.yaml
> > > > new file mode 100644
> > > > index 000000000000..a4aa4ce3318b
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/pmem/pmem-region.yaml
> > > > @@ -0,0 +1,49 @@
> > > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > > +%YAML 1.2
> > > > +---
> > > > +$id: http://devicetree.org/schemas/pmem-region.yaml#
> > > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > > +
> > > > +maintainers:
> > > > +  - Bjorn Helgaas <bhelgaas@google.com>
> > > 
> > > Drop Bjorn. He only did typo fixes on this.
> > > 
> > > > +  - Oliver O'Halloran <oohall@gmail.com>
> > > > +
> > > > +title: Persistent Memory Regions
> > > > +
> > > > +description: |
> > > > +  Persistent memory refers to a class of memory devices that are:
> > > > +
> > > > +    a) Usable as main system memory (i.e. cacheable), and
> > > > +    b) Retain their contents across power failure.
> > > > +
> > > > +  Given b) it is best to think of persistent memory as a kind of memory mapped
> > > > +  storage device. To ensure data integrity the operating system needs to manage
> > > > +  persistent regions separately to the normal memory pool. To aid with that this
> > > > +  binding provides a standardised interface for discovering where persistent
> > > > +  memory regions exist inside the physical address space.
> > > > +
> > > > +properties:
> > > > +  compatible:
> > > > +    const: pmem-region
> > > > +
> > > > +  reg:
> > > > +    maxItems: 1
> > > > +
> > > > +  volatile:
> > > > +    description: |
> > > 
> > > Don't need '|' here.
> > 
> > Rob - Thanks for the feedback. Should I send a new revision with these
> > two changes?
> 
> I can do a clean up as I have not sent to Linus yet.
> 
> Here are the changes if you approve I'll change it and push to linux-next.
> 
> Ira
> 
> diff --git a/Documentation/devicetree/bindings/pmem/pmem-region.yaml b/Documentation/devicetree/bindings/pmem/pmem-region.yaml
> index a4aa4ce3318b..bd0f0c793f03 100644
> --- a/Documentation/devicetree/bindings/pmem/pmem-region.yaml
> +++ b/Documentation/devicetree/bindings/pmem/pmem-region.yaml
> @@ -5,7 +5,6 @@ $id: http://devicetree.org/schemas/pmem-region.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
>  maintainers:
> -  - Bjorn Helgaas <bhelgaas@google.com>
>    - Oliver O'Halloran <oohall@gmail.com>
>  
>  title: Persistent Memory Regions
> @@ -30,7 +29,7 @@ properties:
>      maxItems: 1
>  
>    volatile:
> -    description: |
> +    description:
>        Indicates the region is volatile (non-persistent) and the OS can skip
>        cache flushes for writes
>      type: boolean

Thanks for fixing it up. That looks good to me.

Drew
