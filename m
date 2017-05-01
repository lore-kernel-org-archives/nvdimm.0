Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 727C821A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 15:06:13 -0700 (PDT)
Received: from G4W9120.americas.hpqcorp.net (g4w9120.houston.hp.com
 [16.210.21.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g9t5009.houston.hpe.com (Postfix) with ESMTPS id B1B0254
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 22:06:12 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3] ndctl: add clear error support for ndctl
Date: Mon, 1 May 2017 22:06:10 +0000
Message-ID: <1493676369.30303.30.camel@hpe.com>
References: <149367376823.14721.16804310177322088175.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149367376823.14721.16804310177322088175.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <D82B7D8DCDC9324EA4C4801F0C6CA81E@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2017-05-01 at 14:23 -0700, Dave Jiang wrote:
 :
> +++ b/Documentation/ndctl-clear-error.txt
> @@ -0,0 +1,37 @@
> +ndctl-clear-error(1)
> +====================
> +
> +NAME
> +----
> +ndctl-clear-error - clear badblocks for a device
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl clear-error' [<options>]
> +
> +EXAMPLES
> +--------
> +
> +Clear poison (bad blocks) for the provided device
> +[verse]
> +ndctl clear-error -f /dev/dax0.0 -s 0 -l 8
> +
> +Clear poison (bad blocks) at block offset 0 for 8 blocks on device
> /dev/dax0.0
> +
> +OPTIONS
> +-------
> +-f::
> +--file::
> +	The device/file to be cleared of poison (bad blocks).
> +
> +-s::
> +--start::
> +	The offset where the poison (bad block) starts for this
> device.
> +	Typically this is acquired from the sysfs badblocks file.
> +
> +-l::
> +--len::
> +	The number of badblocks to clear in size of 512 bytes
> increments.
> +

When a specified range is larger than a badblock range, the command
completes with no-op without any message.  I think it should either
fail with an error message or clear an inclusive badblock.

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
