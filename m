Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F254D2237A4CE
 for <linux-nvdimm@lists.01.org>; Fri,  2 Feb 2018 15:50:30 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl: add options to update firmware manpage
Date: Fri, 2 Feb 2018 23:56:07 +0000
Message-ID: <1517615766.8128.37.camel@intel.com>
References: <151761526035.7565.535231308729807997.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151761526035.7565.535231308729807997.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <6065BF1A23BF034F95067B51612DB512@intel.com>
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
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2018-02-02 at 16:47 -0700, Dave Jiang wrote:
> update firmware is missing the long/short option in the manpage.
> Adding
> the missing sections.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/ndctl-update-firmware.txt |   17
> +++++++++++++++++
>  1 file changed, 17 insertions(+)

Looks good, I have folded it in to the original patch.

> 
> diff --git a/Documentation/ndctl/ndctl-update-firmware.txt
> b/Documentation/ndctl/ndctl-update-firmware.txt
> index d742302..dd90612 100644
> --- a/Documentation/ndctl/ndctl-update-firmware.txt
> +++ b/Documentation/ndctl/ndctl-update-firmware.txt
> @@ -10,6 +10,23 @@ SYNOPSIS
>  [verse]
>  'ndctl update-firmware' -f <firmware_file> -d <dimm name>
>  
> +EXAMPLES
> +--------
> +
> +Updating DIMM nmem0 with firmware file name firmwarefile.bin.
> +[verse]
> +ndctl update-firmware -f firmwarefile.bin -d nmem0
> +
> +OPTIONS
> +-------
> +-f::
> +--firmware=::
> +	The path and name of the firmware file to be updated.
> +
> +-d::
> +--dimm=::
> +	The DIMM name to be updated.
> +
>  COPYRIGHT
>  ---------
>  Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
