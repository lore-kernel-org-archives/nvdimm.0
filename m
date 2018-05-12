Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5AE99210E0FBB
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 18:46:07 -0700 (PDT)
Date: Fri, 11 May 2018 19:46:06 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v6 1/4] ndctl: convert namespace actions to use
 util_filter_params
Message-ID: <20180512014606.GA5765@linux.intel.com>
References: <152607009656.4523.5355287262776399070.stgit@djiang5-desk3.ch.intel.com>
 <152607028166.4523.7696454511543042282.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152607028166.4523.7696454511543042282.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 11, 2018 at 01:24:41PM -0700, Dave Jiang wrote:
> In preparation of moving to using util_filter_walk, moving parts of
> namespace params to util_filter_params.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/namespace.c |   41 ++++++++++++++++++++---------------------
>  1 file changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index fe86d826..e61f500c 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -40,14 +40,11 @@ static struct parameters {
>  	bool mode_default;
>  	bool align_default;
>  	bool autolabel;
> -	const char *bus;
>  	const char *map;
> -	const char *type;
>  	const char *uuid;
>  	const char *name;
>  	const char *size;
>  	const char *mode;

Why not use the 'mode' in uf_param as well?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
