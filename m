Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3726121A143EF
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 15:59:21 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 2/2] ndctl: Add 'list' verbose documentation
Date: Tue, 26 Jun 2018 22:59:17 +0000
Message-ID: <1530053956.27147.34.camel@intel.com>
References: <20180626204649.7665-1-keith.busch@intel.com>
 <20180626204649.7665-2-keith.busch@intel.com>
In-Reply-To: <20180626204649.7665-2-keith.busch@intel.com>
Content-Language: en-US
Content-ID: <AE2587FBCBCEC249B87A0DEDD5DE1933@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Busch, Keith" <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-06-26 at 14:46 -0600, Keith Busch wrote:
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  Documentation/ndctl/ndctl-list.txt | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 

I think this can all just go in the first patch?

> diff --git a/Documentation/ndctl/ndctl-list.txt
> b/Documentation/ndctl/ndctl-list.txt
> index 13ebdcd..791638c 100644
> --- a/Documentation/ndctl/ndctl-list.txt
> +++ b/Documentation/ndctl/ndctl-list.txt
> @@ -200,6 +200,18 @@ include::xable-region-options.txt[]
>    ]
>  }
>  
> +-v::
> +--verbose::
> +	Increase verbosity of the output. This can be specified
> +	multiple times to be even more verbose on the informational and
> +	miscellaneous output, and can be used to override the flags for
> +	showing specific information.

Should we detail here what verbosity level enables which flags? Or is that
too much upkeep in case things change..

> +
> +[verse]
> +ndctl list -v
> +ndctl list -vv
> +ndctl list -vvv
> +
>  include::human-option.txt[]
>  
>  ----
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
