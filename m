Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 370EB203BEA2D
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 11:02:23 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl: warn on variables declared after statement
Date: Fri, 11 May 2018 18:02:21 +0000
Message-ID: <1526061739.4429.13.camel@intel.com>
References: <152606086348.37490.2328471829579138286.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152606086348.37490.2328471829579138286.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <59D8925A5D50FA4AA48558DFE3616FE1@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2018-05-11 at 10:47 -0700, Dan Williams wrote:
> Similar to the kernel, require all variables to be declared before
> statements.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  configure.ac |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/configure.ac b/configure.ac
> index 6dbfcee88f7d..da56c413bffd 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -148,6 +148,7 @@ my_CFLAGS="\
>  -Wstrict-prototypes \
>  -Wtype-limits \
>  -Wmaybe-uninitialized \
> +-Wdeclaration-after-statement \
>  -Wunused-result \
>  -D_FORTIFY_SOURCE=2
>  "
> 

Thanks Dan, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
