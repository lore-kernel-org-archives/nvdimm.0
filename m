Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 98EC9210DA7A9
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 12:26:26 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl, documentation: Clarify the dimm id for ndctl
 list d option
Date: Tue, 7 Aug 2018 19:26:25 +0000
Message-ID: <1533669983.18175.29.camel@intel.com>
References: <20180806212130.1605-1-msys.mizuma@gmail.com>
In-Reply-To: <20180806212130.1605-1-msys.mizuma@gmail.com>
Content-Language: en-US
Content-ID: <78CD59E2D18686498D772E60EDE1F219@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "msys.mizuma@gmail.com" <msys.mizuma@gmail.com>
Cc: "m.mizuma@jp.fujitsu.com" <m.mizuma@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Mon, 2018-08-06 at 17:21 -0400, Masayoshi Mizuma wrote:
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> 
> User may be confused the dimm id description of ndctl list -d
> option because ndctl list says id, but the id is not useful to
> d option.
> 
> ]# ndctl list -d nmem7 | jq -r .id
> cdab-0a-07e0-fefffeff
> ]# ndctl list -d cdab-0a-07e0-fefffeff
> ]#
> 
> The appropriate id here is X in 'nmemX' (Above example, X is 7).
> Let's clarify the description.
> 
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> ---
>  Documentation/ndctl/ndctl-list.txt | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Looks good, Applied.

> 
> diff --git a/Documentation/ndctl/ndctl-list.txt
> b/Documentation/ndctl/ndctl-list.txt
> index 13ebdcd..1b5882a 100644
> --- a/Documentation/ndctl/ndctl-list.txt
> +++ b/Documentation/ndctl/ndctl-list.txt
> @@ -64,9 +64,10 @@ include::xable-region-options.txt[]
>  
>  -d::
>  --dimm=::
> -	An 'nmemX' device name, or dimm id number. Filter listing by
> -	devices that reference the given dimm. For example to see
> all
> -	namespaces comprised of storage capacity on nmem0:
> +	An 'nmemX' device name, or dimm id number. The dimm id
> number
> +	here is X in 'nmemX'. Filter listing by devices that
> reference
> +	the given dimm. For example to see all namespaces comprised
> +	of storage capacity on nmem0:
>  ----
>  # ndctl list --dimm=nmem0 --namespaces
>  ----
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
