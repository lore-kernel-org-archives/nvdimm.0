Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7E3E21E47D56
 for <linux-nvdimm@lists.01.org>; Wed, 23 Aug 2017 09:44:45 -0700 (PDT)
Date: Wed, 23 Aug 2017 10:47:14 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2] ndctl: daxctl: Adding io option for daxctl
Message-ID: <20170823164714.GC25999@linux.intel.com>
References: <150344672033.39111.1745886872895468624.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150344672033.39111.1745886872895468624.stgit@djiang5-desk3.ch.intel.com>
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

On Tue, Aug 22, 2017 at 05:06:15PM -0700, Dave Jiang wrote:
> The daxctl io option allows I/Os to be performed between file descriptor to
> and from device dax files. It also provides a way to zero a device dax
> device.
> 
> i.e. daxctl io --input=/home/myfile --output=/dev/dax1.0
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> 
> v2:
> - Removed dependency on ndctl to match device and address other comments
> by Dan.
> 
>  Documentation/daxctl/Makefile.am   |    3 +-
>  Documentation/daxctl/daxctl-io.txt |   70 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 72 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/daxctl/daxctl-io.txt
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

Do you have plans to add support for suffixes so people don't have to do
--len=2097152 or --len=$((2*1024*1024))?

It looks like even DD supports suffixes:

$ dd if=/dev/urandom of=/tmp/random bs=4k count=1
1+0 records in
1+0 records out
4096 bytes (4.1 kB, 4.0 KiB) copied, 0.000180118 s, 22.7 MB/s

from the man page:

N and BYTES may be followed by the following multiplicative suffixes: c =1, w
=2, b =512, kB =1000, K =1024, MB =1000*1000, M =1024*1024, xM =M GB
=1000*1000*1000, G =1024*1024*1024, and so on for T, P, E, Z, Y.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
