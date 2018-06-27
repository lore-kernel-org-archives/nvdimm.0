Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C92021B02845
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 15:23:48 -0700 (PDT)
Date: Wed, 27 Jun 2018 16:23:46 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [ndctl PATCH] Documentation: add a newline in namespace Theory
 of Operations
Message-ID: <20180627222346.GB9504@linux.intel.com>
References: <20180627221543.23586-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180627221543.23586-1-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 27, 2018 at 04:15:43PM -0600, Vishal Verma wrote:
> The first bullet in the modes description was merged in with the
> previous paragraph in the online version of the man pages. Fix by adding
> a newline before the bulleted list.
> 
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/ndctl/namespace-description.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/ndctl/namespace-description.txt b/Documentation/ndctl/namespace-description.txt
> index 1dd687e..94999e5 100644
> --- a/Documentation/ndctl/namespace-description.txt
> +++ b/Documentation/ndctl/namespace-description.txt
> @@ -21,6 +21,7 @@ area.
>  A namespace can be provisioned to operate in one of 4 modes, 'fsdax',
>  'devdax', 'sector', and 'raw'. Here are the expected usage models for
>  these modes:
> +
>  	- fsdax: Filesystem-DAX mode is the default mode of a namespace
>  	  when specifying 'ndctl create-namespace' with no options. It creates
>  	  a block device (/dev/pmemX[.Y]) that supports the DAX capabilities

Cool, thanks for fixing.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
