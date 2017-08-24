Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 25EF021CFA608
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 08:29:38 -0700 (PDT)
Date: Thu, 24 Aug 2017 09:32:11 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3] ndctl: daxctl: Adding io option for daxctl
Message-ID: <20170824153211.GB25588@linux.intel.com>
References: <150351233700.34497.1207904417332702004.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150351233700.34497.1207904417332702004.stgit@djiang5-desk3.ch.intel.com>
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

On Wed, Aug 23, 2017 at 11:20:40AM -0700, Dave Jiang wrote:
> The daxctl io option allows I/Os to be performed between file descriptor to
> and from device dax files. It also provides a way to zero a device dax
> device.
> 
> i.e. daxctl io --input=/home/myfile --output=/dev/dax1.0
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> 
> v3:
> - Added support for size suffix suggested by Ross.
> - Fixed the checking of __do_io() return value >32bit problem.
> 
> v2:
> - Removed dependency on ndctl to match device and address other comments
> by Dan.
> 
>  Documentation/daxctl/Makefile.am   |    3 
>  Documentation/daxctl/daxctl-io.txt |   70 ++++
>  daxctl/Makefile.am                 |    5 
>  daxctl/daxctl.c                    |    2 
>  daxctl/io.c                        |  576 ++++++++++++++++++++++++++++++++++++
>  5 files changed, 654 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/daxctl/daxctl-io.txt
>  create mode 100644 daxctl/io.c
> 
> diff --git a/Documentation/daxctl/Makefile.am b/Documentation/daxctl/Makefile.am
> index 5913c94..032d48c 100644
> --- a/Documentation/daxctl/Makefile.am
> +++ b/Documentation/daxctl/Makefile.am
> @@ -16,7 +16,8 @@ asciidoc.conf: ../asciidoc.conf.in
>  
>  man1_MANS = \
>  	daxctl.1 \
> -	daxctl-list.1
> +	daxctl-list.1 \
> +	daxctl-io.1
>  
>  CLEANFILES = $(man1_MANS)
>  
> diff --git a/Documentation/daxctl/daxctl-io.txt b/Documentation/daxctl/daxctl-io.txt
> new file mode 100644
> index 0000000..a7acc9e
> --- /dev/null
> +++ b/Documentation/daxctl/daxctl-io.txt
> @@ -0,0 +1,70 @@
> +daxctl-io(1)
> +===========
> +
> +NAME
> +----
> +daxctl-io - Perform I/O on Device-DAX devices or zero a Device-DAX device.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'daxctl io' [<options>]
> +
> +There must be a Device-DAX device involved whether as the input or the output
> +device. Read from a Device-DAX device and write to a file descriptor, or
> +another Device-DAX device. Write to a Device-DAX device from a file descriptor
> +or another Device-DAX device.
> +
> +No length specified will default to input file/device length. If input is
> +a special char file then length will be the output file/device length.
> +
> +No input will default to stdin. No output will default to stdout.
> +
> +For a Device-DAX device, attempts to clear badblocks within range of writes
> +will be performed.
> +
> +EXAMPLE
> +-------
> +[verse]
> +# daxctl io --zero /dev/dax1.0
> +
> +# daxctl io --input=/dev/dax1.0 --output=/home/myfile --len=2097152 --seek=4096

Probably want to update the example above and the --len documentation below to
show usage of a suffix and to include info about what suffixes are supported.

> +
> +# cat /dev/zero | daxctl io --output=/dev/dax1.0
> +
> +# daxctl io --input=/dev/zero --output=/dev/dax1.0 --skip=4096
> +
> +OPTIONS
> +-------
> +-i::
> +--input=::
> +	Input device or file to read from.
> +
> +-o::
> +--output=::
> +	Output device or file to write to.
> +
> +-z::
> +--zero::
> +	Zero the output device for 'len' size. Or the entire device if no
> +	length was provided. The output device must be a Device DAX device.
> +
> +-l::
> +--len::
> +	The length in bytes to perform the I/O.
> +
> +-s::
> +--seek::
> +	The number of bytes to skip over on the output before performing a
> +	write.
> +
> +-k::
> +--skip::
> +	The number of bytes to skip over on the input before performing a read.
> +
> +COPYRIGHT
> +---------
> +Copyright (c) 2017, Intel Corporation. License GPLv2: GNU GPL
> +version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
> +you are free to change and redistribute it.  There is NO WARRANTY, to
> +the extent permitted by law.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
