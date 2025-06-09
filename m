Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AA12459F2;
	Mon,  9 Jun 2025 13:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749475964; cv=none; b=We1lp6g+ELPgI35B1EbikAFjFVL2vtdRsqKKGgailXxCvS6px5si7QmNIZiQ8HRBlh4cGpiX2gFp0MHKKRh6R+7xTPBa+pRRAIrgI6U3LW+TVPxIlCK4iP5XDeHbmz5yev63lP5X68quQTTpvQsOXRbS9ieGW1hpCDSQzSCavEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749475964; c=relaxed/simple;
	bh=5oESMmppMFXd8TEqq9vCkUhwip6ndxkGlsvvYr4th2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fSosXdrj0JR2LdMzSJUMe8hxD+v40A0SYe+lUgHJl4zsH3r/4j8WA5og1O7Nk8+9T8Hg3Uls1IcWMGkKbkCycpDf0gglKXi/XfjZ77DvCrVI3GscdSNZdgbP85klJYzUlp1HmMrC30rXjht4uvxl3ht4lPxmx9fqsQ0Q4fRbD0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tRfUoG33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tRfUoG33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67837C4CEEB;
	Mon,  9 Jun 2025 13:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749475962;
	bh=5oESMmppMFXd8TEqq9vCkUhwip6ndxkGlsvvYr4th2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tRfUoG33P1n1MtXgaa0Ak+c+kp0bOQO4NiXWFfCOEdzFrbi7qs8ILhDOlM1WYo3k9
	 LR3xIHFEC5CUC/aB80sxCOGMqCyv8yrDuSYTCaOVU9T34AGocPhjlLojESExTigZAK
	 fUEqRk2NVC2td4B17Pc1MjZiB8SoROA/8EefFUx8W+kEGWLY96DyVTNM/wh0v4i1aL
	 tJP0Colwo0Zqczp6NH+x5GZpcXXl0CQeEKsMpyw1fa6CUKztGntjo93KYr1DPn3/uR
	 gbnIs18jKcLtacWl/d9NO2cCbGEPI1wSa4jTmDZfGdOImE5apd/2s/HSNEei8gKbeL
	 MBQua5l4d6cjA==
Date: Mon, 9 Jun 2025 08:32:41 -0500
From: Rob Herring <robh@kernel.org>
To: Drew Fustini <drew@pdp7.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev,
	Oliver O'Halloran <oohall@gmail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v3] dt-bindings: pmem: Convert binding to YAML
Message-ID: <20250609133241.GA1855507-robh@kernel.org>
References: <20250606184405.359812-4-drew@pdp7.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250606184405.359812-4-drew@pdp7.com>

On Fri, Jun 06, 2025 at 11:11:17AM -0700, Drew Fustini wrote:
> Convert the PMEM device tree binding from text to YAML. This will allow
> device trees with pmem-region nodes to pass dtbs_check.
> 
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Acked-by: Oliver O'Halloran <oohall@gmail.com>
> Signed-off-by: Drew Fustini <drew@pdp7.com>
> ---
> Dan/Dave/Vishal: does it make sense for this pmem binding patch to go
> through the nvdimm tree?
> 
> Note: checkpatch complains about "DT binding docs and includes should
> be a separate patch". Rob told me that this a false positive. I'm hoping
> that I can fix the false positive at some point if I can remember enough
> perl :)
> 
> v3:
>  - no functional changes
>  - add Oliver's Acked-by
>  - bump version to avoid duplicate message-id mess in v2 and v2 resend:
>    https://lore.kernel.org/all/20250520021440.24324-1-drew@pdp7.com/
> 
> v2 resend:
>  - actually put v2 in the Subject
>  - add Conor's Acked-by
>    - https://lore.kernel.org/all/20250520-refract-fling-d064e11ddbdf@spud/
> 
> v2:
>  - remove the txt file to make the conversion complete
>  - https://lore.kernel.org/all/20250520021440.24324-1-drew@pdp7.com/
> 
> v1:
>  - https://lore.kernel.org/all/20250518035539.7961-1-drew@pdp7.com/
> 
>  .../devicetree/bindings/pmem/pmem-region.txt  | 65 -------------------
>  .../devicetree/bindings/pmem/pmem-region.yaml | 49 ++++++++++++++
>  MAINTAINERS                                   |  2 +-
>  3 files changed, 50 insertions(+), 66 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/pmem/pmem-region.txt
>  create mode 100644 Documentation/devicetree/bindings/pmem/pmem-region.yaml
> 
> diff --git a/Documentation/devicetree/bindings/pmem/pmem-region.txt b/Documentation/devicetree/bindings/pmem/pmem-region.txt
> deleted file mode 100644
> index cd79975e85ec..000000000000
> --- a/Documentation/devicetree/bindings/pmem/pmem-region.txt
> +++ /dev/null
> @@ -1,65 +0,0 @@
> -Device-tree bindings for persistent memory regions
> ------------------------------------------------------
> -
> -Persistent memory refers to a class of memory devices that are:
> -
> -	a) Usable as main system memory (i.e. cacheable), and
> -	b) Retain their contents across power failure.
> -
> -Given b) it is best to think of persistent memory as a kind of memory mapped
> -storage device. To ensure data integrity the operating system needs to manage
> -persistent regions separately to the normal memory pool. To aid with that this
> -binding provides a standardised interface for discovering where persistent
> -memory regions exist inside the physical address space.
> -
> -Bindings for the region nodes:
> ------------------------------
> -
> -Required properties:
> -	- compatible = "pmem-region"
> -
> -	- reg = <base, size>;
> -		The reg property should specify an address range that is
> -		translatable to a system physical address range. This address
> -		range should be mappable as normal system memory would be
> -		(i.e cacheable).
> -
> -		If the reg property contains multiple address ranges
> -		each address range will be treated as though it was specified
> -		in a separate device node. Having multiple address ranges in a
> -		node implies no special relationship between the two ranges.
> -
> -Optional properties:
> -	- Any relevant NUMA associativity properties for the target platform.
> -
> -	- volatile; This property indicates that this region is actually
> -	  backed by non-persistent memory. This lets the OS know that it
> -	  may skip the cache flushes required to ensure data is made
> -	  persistent after a write.
> -
> -	  If this property is absent then the OS must assume that the region
> -	  is backed by non-volatile memory.
> -
> -Examples:
> ---------------------
> -
> -	/*
> -	 * This node specifies one 4KB region spanning from
> -	 * 0x5000 to 0x5fff that is backed by non-volatile memory.
> -	 */
> -	pmem@5000 {
> -		compatible = "pmem-region";
> -		reg = <0x00005000 0x00001000>;
> -	};
> -
> -	/*
> -	 * This node specifies two 4KB regions that are backed by
> -	 * volatile (normal) memory.
> -	 */
> -	pmem@6000 {
> -		compatible = "pmem-region";
> -		reg = < 0x00006000 0x00001000
> -			0x00008000 0x00001000 >;
> -		volatile;
> -	};
> -
> diff --git a/Documentation/devicetree/bindings/pmem/pmem-region.yaml b/Documentation/devicetree/bindings/pmem/pmem-region.yaml
> new file mode 100644
> index 000000000000..a4aa4ce3318b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pmem/pmem-region.yaml
> @@ -0,0 +1,49 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/pmem-region.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +maintainers:
> +  - Bjorn Helgaas <bhelgaas@google.com>

Drop Bjorn. He only did typo fixes on this.

> +  - Oliver O'Halloran <oohall@gmail.com>
> +
> +title: Persistent Memory Regions
> +
> +description: |
> +  Persistent memory refers to a class of memory devices that are:
> +
> +    a) Usable as main system memory (i.e. cacheable), and
> +    b) Retain their contents across power failure.
> +
> +  Given b) it is best to think of persistent memory as a kind of memory mapped
> +  storage device. To ensure data integrity the operating system needs to manage
> +  persistent regions separately to the normal memory pool. To aid with that this
> +  binding provides a standardised interface for discovering where persistent
> +  memory regions exist inside the physical address space.
> +
> +properties:
> +  compatible:
> +    const: pmem-region
> +
> +  reg:
> +    maxItems: 1
> +
> +  volatile:
> +    description: |

Don't need '|' here.

> +      Indicates the region is volatile (non-persistent) and the OS can skip
> +      cache flushes for writes
> +    type: boolean
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    pmem@5000 {
> +        compatible = "pmem-region";
> +        reg = <0x00005000 0x00001000>;
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ee93363ec2cb..eba2b81ec568 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13798,7 +13798,7 @@ M:	Oliver O'Halloran <oohall@gmail.com>
>  L:	nvdimm@lists.linux.dev
>  S:	Supported
>  Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
> -F:	Documentation/devicetree/bindings/pmem/pmem-region.txt
> +F:	Documentation/devicetree/bindings/pmem/pmem-region.yaml
>  F:	drivers/nvdimm/of_pmem.c
>  
>  LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
> -- 
> 2.43.0
> 
