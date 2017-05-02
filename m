Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9875021A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 17:16:08 -0700 (PDT)
Received: from G2W6309.americas.hpqcorp.net (g2w6309.austin.hp.com
 [16.197.64.51])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2354.austin.hpe.com (Postfix) with ESMTPS id D26564B
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 00:16:07 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4] ndctl: add clear error support for ndctl
Date: Tue, 2 May 2017 00:16:05 +0000
Message-ID: <1493684163.30303.36.camel@hpe.com>
References: <149368138628.53639.13278265267164943868.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149368138628.53639.13278265267164943868.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <B3E0820177473043A098053944BA288C@NAMPRD84.PROD.OUTLOOK.COM>
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

On Mon, 2017-05-01 at 16:33 -0700, Dave Jiang wrote:
 :
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
> increments. The 
> +	length must fit within the badblocks range. If the length
> exceeds the
> +	badblock range or is 0, the command will fail.

Actually, I am seeing '-l 0' works just like '-l 1'.

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
