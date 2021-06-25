Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57322FB2
	for <nvdimm@lists.linux.dev>; Fri, 25 Jun 2021 17:41:53 +0000 (UTC)
IronPort-SDR: 6VJDd+hgy7aJs60OrU+avMhmhGiqiCyHs5EFgAwth41m3aOMinUpOwBSK43PoJjCbDAO1hDkiY
 kMju7xT9NTHQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="271571935"
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="271571935"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 10:41:50 -0700
IronPort-SDR: y+zZJUuUktTWp0baZaYD7IMxqtb/RtRBCiJBYQdZkGw1HTGpkSzMi2LF/HlAlm4qhu+SIlMyNK
 Fcn1TvWBOqdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="624584369"
Received: from alison-desk.jf.intel.com ([10.54.74.53])
  by orsmga005.jf.intel.com with ESMTP; 25 Jun 2021 10:41:49 -0700
Date: Fri, 25 Jun 2021 10:37:10 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: 13145886936@163.com
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: Re: [PATCH] tools/testing/nvdimm: NULL check before vfree() is not
 needed
Message-ID: <20210625173710.GA14491@alison-desk.jf.intel.com>
References: <20210625072700.22662-1-13145886936@163.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625072700.22662-1-13145886936@163.com>
User-Agent: Mutt/1.9.4 (2018-02-28)


Hi Gushengxian,

The code change looks good.  A couple of cleanups noted below...
(same feedback on next patch too)


On Fri, Jun 25, 2021 at 12:27:00AM -0700, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> NULL check before vfree() is not needed.

The commit message needs to say what was done, not the why.
Example: "[PATCH] tools/testing/nvdimm: Remove NULL test before vfree"

Then, the commit log explains why this should be done.
Example: "This NULL test is redundant since vfree() checks for NULL."

Coccinelle reports this vfree() case. If you did use Coccinelle
to find it, please mention that in the commit log.
Example: "Reported by Coccinelle."

> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>

The email addresses don't match (13145886936@163.com,
gushengxian@yulong.com) and it's not clear that you are using your
full, legal name in the 'name line.

You can find more info on this feedback at:
https://kernelnewbies.org/FirstKernelPatch
https://www.kernel.org/doc/html/latest/process/submitting-patches.html

Alison

> ---
>  tools/testing/nvdimm/test/nfit.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index 54f367cbadae..cb86f0cbb11c 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -1641,8 +1641,8 @@ static void *__test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma,
>   err:
>  	if (*dma && size >= DIMM_SIZE)
>  		gen_pool_free(nfit_pool, *dma, size);
> -	if (buf)
> -		vfree(buf);
> +
> +	vfree(buf);
>  	kfree(nfit_res);
>  	return NULL;
>  }
> -- 
> 2.25.1
> 
> 
