Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD67C210D97B7
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 12:54:48 -0700 (PDT)
Subject: Re: [PATCH] libnvdimm: fix ars_status output length calculation
References: <20180810192315.3471-1-vishal.l.verma@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <996c7e5e-8472-aa44-0a27-abfdd6b3c86e@intel.com>
Date: Fri, 10 Aug 2018 12:54:47 -0700
MIME-Version: 1.0
In-Reply-To: <20180810192315.3471-1-vishal.l.verma@intel.com>
Content-Language: en-US
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
To: Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
Cc: stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>



On 08/10/2018 12:23 PM, Vishal Verma wrote:
> Commit efda1b5d87cb ("acpi, nfit, libnvdimm: fix / harden ars_status output length handling")
> Introduced additional hardening for ambiguity in the ACPI spec for
> ars_status output sizing. However, it had a couple of cases mixed up.
> Where it should have been checking for (and returning) "out_field[1] -
> 4" it was using "out_field[1] - 8" and vice versa.
> 
> This caused a four byte discrepancy in the buffer size passed on to
> the command handler, and in some cases, this caused memory corruption
> like:
> 
>   ./daxdev-errors.sh: line 76: 24104 Aborted   (core dumped) ./daxdev-errors $busdev $region
>   malloc(): memory corruption
>   Program received signal SIGABRT, Aborted.
>   [...]
>   #5  0x00007ffff7865a2e in calloc () from /lib64/libc.so.6
>   #6  0x00007ffff7bc2970 in ndctl_bus_cmd_new_ars_status (ars_cap=ars_cap@entry=0x6153b0) at ars.c:136
>   #7  0x0000000000401644 in check_ars_status (check=0x7fffffffdeb0, bus=0x604c20) at daxdev-errors.c:144
>   #8  test_daxdev_clear_error (region_name=<optimized out>, bus_name=<optimized out>)
>       at daxdev-errors.c:332
> 
> Cc: <stable@vger.kernel.org>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Lukasz Dorau <lukasz.dorau@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Fixes: efda1b5d87cb ("acpi, nfit, libnvdimm: fix / harden ars_status output length handling")
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Applied.

> ---
>  drivers/nvdimm/bus.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 27902a8799b1..8aae6dcc839f 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -812,9 +812,9 @@ u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
>  		 * overshoots the remainder by 4 bytes, assume it was
>  		 * including 'status'.
>  		 */
> -		if (out_field[1] - 8 == remainder)
> +		if (out_field[1] - 4 == remainder)
>  			return remainder;
> -		return out_field[1] - 4;
> +		return out_field[1] - 8;
>  	} else if (cmd == ND_CMD_CALL) {
>  		struct nd_cmd_pkg *pkg = (struct nd_cmd_pkg *) in_field;
>  
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
