Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-f68.google.com (mail-oi0-f68.google.com
 [209.85.218.68])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E31E21F85E6F
 for <linux-nvdimm@lists.01.org>; Mon, 26 Mar 2018 15:18:13 -0700 (PDT)
Received: by mail-oi0-f68.google.com with SMTP id 126-v6so11522858oig.0
 for <linux-nvdimm@lists.01.org>; Mon, 26 Mar 2018 15:24:50 -0700 (PDT)
Date: Mon, 26 Mar 2018 17:24:48 -0500
From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 6/6] doc/devicetree: NVDIMM region documentation
Message-ID: <20180326222448.l7ukrslvccvrjnjf@rob-hp-laptop>
References: <20180323081209.31387-1-oohall@gmail.com>
 <20180323081209.31387-6-oohall@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180323081209.31387-6-oohall@gmail.com>
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

On Fri, Mar 23, 2018 at 07:12:09PM +1100, Oliver O'Halloran wrote:
> Add device-tree binding documentation for the nvdimm region driver.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
>  .../devicetree/bindings/nvdimm/nvdimm-region.txt   | 45 ++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/nvdimm/nvdimm-region.txt
> 
> diff --git a/Documentation/devicetree/bindings/nvdimm/nvdimm-region.txt b/Documentation/devicetree/bindings/nvdimm/nvdimm-region.txt
> new file mode 100644
> index 000000000000..02091117ff16
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/nvdimm/nvdimm-region.txt
> @@ -0,0 +1,45 @@
> +Device-tree bindings for NVDIMM memory regions
> +-----------------------------------------------------
> +
> +Non-volatile DIMMs are memory modules used to provide (cacheable) main memory

Are DIMMs always going to be the only form factor for NV memory?

And if you have multiple DIMMs, does each DT node correspond to a DIMM? 
If not, then what if we want/need to provide power control to a DIMM?

> +that retains its contents across power cycles. In more practical terms, they
> +are kind of storage device where the contents can be accessed by the CPU
> +directly, rather than indirectly via a storage controller or similar. The an
> +nvdimm-region specifies a physical address range that is hosted on an NVDIMM
> +device.
> +
> +Bindings for the region nodes:
> +-----------------------------
> +
> +Required properties:
> +	- compatible = "nvdimm-region"
> +
> +	- reg = <base, size>;
> +		The system physical address range of this nvdimm region.
> +
> +Optional properties:
> +	- Any relevant NUMA assocativity properties for the target platform.
> +	- A "volatile" property indicating that this region is actually in
> +	  normal DRAM and does not require cache flushes after each write.
> +
> +A complete example:
> +--------------------
> +
> +/ {
> +	#size-cells = <2>;
> +	#address-cells = <2>;
> +
> +	platform {

Perhaps we need a more well defined node here. Like we have 'memory' for 
memory nodes.

> +		region@5000 {
> +			compatible = "nvdimm-region;
> +			reg = <0x00000001 0x00000000 0x00000000 0x40000000>
> +
> +		};
> +
> +		region@6000 {
> +			compatible = "nvdimm-region";
> +			reg = <0x00000001 0x00000000 0x00000000 0x40000000>

Your reg property and unit-address don't match and you have overlapping 
regions.

> +			volatile;
> +		};
> +	};
> +};
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
