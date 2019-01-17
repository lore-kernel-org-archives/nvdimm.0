Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 384DC211B6C2B
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 19:08:28 -0800 (PST)
Subject: Re: [PATCH v8 05/12] ndctl: add support for sanitize dimm
References: <154749627829.63704.2987015129166185725.stgit@djiang5-desk3.ch.intel.com>
 <154749642390.63704.15541084216631565368.stgit@djiang5-desk3.ch.intel.com>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <9f4a5a82-0eb3-e7c9-e1d1-0b7bff5c744d@oracle.com>
Date: Wed, 16 Jan 2019 19:08:23 -0800
MIME-Version: 1.0
In-Reply-To: <154749642390.63704.15541084216631565368.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Jiang <dave.jiang@intel.com>, vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi, Dave,

On 1/14/2019 12:07 PM, Dave Jiang wrote:
> Add support to secure erase to libndctl and also command line option
> of "sanitize-dimm" for ndctl. This will initiate the request to crypto
> erase a DIMM.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   Documentation/ndctl/Makefile.am             |    3 +-
>   Documentation/ndctl/ndctl-sanitize-dimm.txt |   38 ++++++++++++++++++++
>   ndctl/builtin.h                             |    1 +
>   ndctl/dimm.c                                |   52 +++++++++++++++++++++++++++
>   ndctl/lib/dimm.c                            |    8 ++++
>   ndctl/lib/keys.c                            |   21 +++++++++--
>   ndctl/lib/libndctl.sym                      |    2 +
>   ndctl/libndctl.h                            |    9 +++++
>   ndctl/ndctl.c                               |    1 +
>   9 files changed, 131 insertions(+), 4 deletions(-)
>   create mode 100644 Documentation/ndctl/ndctl-sanitize-dimm.txt
> 
> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> index a97f193d..bbea9674 100644
> --- a/Documentation/ndctl/Makefile.am
> +++ b/Documentation/ndctl/Makefile.am
> @@ -51,7 +51,8 @@ man1_MANS = \
>   	ndctl-enable-passphrase.1 \
>   	ndctl-update-passphrase.1 \
>   	ndctl-disable-passphrase.1 \
> -	ndctl-freeze-security.1
> +	ndctl-freeze-security.1 \
> +	ndctl-sanitize-dimm.1
>   
>   CLEANFILES = $(man1_MANS)
>   
> diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
> new file mode 100644
> index 00000000..79629964
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +ndctl-sanitize-dimm(1)
> +======================
> +
> +NAME
> +----
> +ndctl-sanitize-dimm - sanitize the data on the NVDIMM
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl sanitize' <dimm> [<options>]

Did you actually mean
   'ndctl sanitize-dimm' <dimm> [<options>]
?

thanks!
-jane

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
