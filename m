Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 49566223FCF24
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 16:39:12 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl. test: fix module-taint sanity-check
Date: Thu, 15 Mar 2018 23:45:34 +0000
Message-ID: <1521157532.28441.3.camel@intel.com>
References: <152114702911.748.6433135505529426881.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152114702911.748.6433135505529426881.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <C9D0F5BCA02B53469DDC6541F90A9115@intel.com>
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2018-03-15 at 13:50 -0700, Dan Williams wrote:
> nfit_test_init() validates that the libnvdimm modules that a test
> would
> use are the properly instrumented external versions. If module
> signing
> is enabled the sanity check will fail because the check expects only
> the
> 'O' flag, but unsigned external modules will have the 'O' flag and
> the
> 'E' flag set. Relax the constraint to just check for 'O'.
> 
> Fixes: 00fc65075c89 ("test: validate nfit_test modules...")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  test/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks good, queued.

> 
> diff --git a/test/core.c b/test/core.c
> index ca983e4913f7..4b36b2d14d7b 100644
> --- a/test/core.c
> +++ b/test/core.c
> @@ -195,7 +195,7 @@ retry:
>  				break;
>  			}
>  
> -			if (strcmp(attr, "O") != 0) {
> +			if (!strchr(attr, 'O')) {
>  				log_err(&log_ctx, "%s.ko: expected
> taint: O got: %s\n",
>  						name, attr);
>  				break;
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
