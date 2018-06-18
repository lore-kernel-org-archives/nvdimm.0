Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C9EB5210F75BC
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 12:12:57 -0700 (PDT)
Date: Mon, 18 Jun 2018 13:12:56 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH] libnvdimm, pmem: Fix memcpy_mcsafe() return code
 handling in nsio_rw_bytes()
Message-ID: <20180618191255.GA4226@vverma7-mobl4.lm.intel.com>
References: <152934432951.24427.11070204367866836632.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152934432951.24427.11070204367866836632.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 06/18, Dan Williams wrote:
> Commit 60622d68227d "x86/asm/memcpy_mcsafe: Return bytes remaining"
> converted callers of memcpy_mcsafe() to expect a positive 'bytes
> remaining' value rather than a negative error code. The nsio_rw_bytes()
> conversion failed to return success. The failure is benign in that
> nsio_rw_bytes() will end up writing back what it just read.
> 
> Fixes: 60622d68227d ("x86/asm/memcpy_mcsafe: Return bytes remaining")
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/nvdimm/claim.c |    1 +
>  1 file changed, 1 insertion(+)

Ah good catch. Looks good to me.
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> 
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index 2e96b34bc936..fb667bf469c7 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -278,6 +278,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>  			return -EIO;
>  		if (memcpy_mcsafe(buf, nsio->addr + offset, size) != 0)
>  			return -EIO;
> +		return 0;
>  	}
>  
>  	if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
