Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F3D3F211AE8C3
 for <linux-nvdimm@lists.01.org>; Wed,  9 Jan 2019 08:15:53 -0800 (PST)
Subject: Re: [PATCH] libnvdimm/dimm: Fix security capability detection for
 non-Intel NVDIMMs
References: <154699705105.1135364.887652664638853916.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <303054ba-3f3a-cdfb-2aab-d4f61f98b411@intel.com>
Date: Wed, 9 Jan 2019 09:15:51 -0700
MIME-Version: 1.0
In-Reply-To: <154699705105.1135364.887652664638853916.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>



On 1/8/19 6:24 PM, Dan Williams wrote:
> Kees reports a crash with the following signature...
> 
>  RIP: 0010:nvdimm_visible+0x79/0x80
>  [..]
>  Call Trace:
>   internal_create_group+0xf4/0x380
>   sysfs_create_groups+0x46/0xb0
>   device_add+0x331/0x680
>   nd_async_device_register+0x15/0x60
>   async_run_entry_fn+0x38/0x100
> 
> ...when starting a QEMU environment with "label-less" DIMM. Without
> labels QEMU does not publish any DSM methods. Without defined methods
> the NVDIMM_FAMILY type is not established and the nfit driver will skip
> registering security operations.
> 
> In that case the security state should be initialized to a negative
> value in __nvdimm_create() and nvdimm_visible() should skip
> interrogating the specific ops. However, since 'enum
> nvdimm_security_state' was only defined to contain positive values the
> "if (nvdimm->sec.state < 0)" check always fails.
> 
> Define a negative error state to allow negative state values to be
> handled as expected.
> 
> Fixes: f2989396553a ("acpi/nfit, libnvdimm: Introduce nvdimm_security_ops")
> Cc: Dave Jiang <dave.jiang@intel.com>
> Reported-by: Kees Cook <keescook@chromium.org>
> Tested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  include/linux/libnvdimm.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 5440f11b0907..7315977b64da 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -160,6 +160,7 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
>  }
>  
>  enum nvdimm_security_state {
> +	NVDIMM_SECURITY_ERROR = -1,
>  	NVDIMM_SECURITY_DISABLED,
>  	NVDIMM_SECURITY_UNLOCKED,
>  	NVDIMM_SECURITY_LOCKED,
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
