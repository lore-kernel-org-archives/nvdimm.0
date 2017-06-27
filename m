Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id 55C0521AE2652
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 03:42:49 -0700 (PDT)
Date: Tue, 27 Jun 2017 11:43:28 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC 2/4] libnvdimm: Add a device-tree interface
Message-ID: <20170627104328.GD30002@leverpostej>
References: <20170627102851.15484-1-oohall@gmail.com>
 <20170627102851.15484-2-oohall@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170627102851.15484-2-oohall@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Oliver O'Halloran <oohall@gmail.com>
Cc: devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,

On Tue, Jun 27, 2017 at 08:28:49PM +1000, Oliver O'Halloran wrote:
> A fairly bare-bones set of device-tree bindings so libnvdimm can be used
> on powerpc and other, less cool, device-tree based platforms.

;)

> Cc: devicetree@vger.kernel.org
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
> The current bindings are essentially this:
> 
> nonvolatile-memory {
> 	compatible = "nonvolatile-memory", "special-memory";
> 	ranges;
> 
> 	region@0 {
> 		compatible = "nvdimm,byte-addressable";
> 		reg = <0x0 0x1000>;
> 	};
> 
> 	region@1000 {
> 		compatible = "nvdimm,byte-addressable";
> 		reg = <0x1000 0x1000>;
> 	};
> };

This needs to have a proper binding document under
Documentation/devicetree/bindings/. Something like the reserved-memory
bdings would be a good template.

If we want thet "nvdimm" vendor-prefix, that'll have to be reserved,
too (see Documentation/devicetree/bindings/vendor-prefixes.txt).

What is "special-memory"? What other memory types would be described
here?

What exacctly does "nvdimm,byte-addressable" imply? I suspect that you
also expect such memory to be compatible with mappings using (some)
cacheable attributes?

Perhaps the byte-addressable property should be a boolean property on
the region, rather than part of the compatible string.

> To handle interleave sets, etc the plan was the add an extra property with the
> interleave stride and a "mapping" property with <&DIMM, dimm-start-offset>
> tuples for each dimm in the interleave set. Block MMIO regions can be added
> with a different compatible type, but I'm not too concerned with them for
> now.

Sorry, I'm not too familiar with nonvolatile memory. What are interleave
sets?

What are block MMIO regions?

Is there any documentation one can refer to for any of this?

[...]

> +static const struct of_device_id of_nvdimm_bus_match[] = {
> +	{ .compatible = "nonvolatile-memory" },
> +	{ .compatible = "special-memory" },
> +	{ },
> +};

Why both? Is the driver handling other "special-memory"?

Thanks,
Mark.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
