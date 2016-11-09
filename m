Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x234.google.com (mail-it0-x234.google.com
 [IPv6:2607:f8b0:4001:c0b::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 047EE81CC4
 for <linux-nvdimm@lists.01.org>; Wed,  9 Nov 2016 15:47:36 -0800 (PST)
Received: by mail-it0-x234.google.com with SMTP id e187so45360186itc.0
 for <linux-nvdimm@lists.01.org>; Wed, 09 Nov 2016 15:47:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1478726177-21904-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1478726177-21904-1-git-send-email-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Nov 2016 15:47:38 -0800
Message-ID: <CAPcyv4gM=wRWiXUB7TG-hLiWU=1D-_U1PK8ttWMGCoM=wCC4mQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ndctl: add information about size suffixes to docs
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 9, 2016 at 1:16 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Add information about the supported size suffixes to the documentation for
> ndctl-create-namespace.  This prevents users from doing silly things like
> $((32*1024*1024*1024)) on the command line when running ndctl commands.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  Documentation/ndctl-create-namespace.txt | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/ndctl-create-namespace.txt b/Documentation/ndctl-create-namespace.txt
> index a2f5e5b..5b62b95 100644
> --- a/Documentation/ndctl-create-namespace.txt
> +++ b/Documentation/ndctl-create-namespace.txt
> @@ -79,8 +79,10 @@ OPTIONS
>  -s::
>  --size=::
>         For NVDIMM devices that support namespace labels, set the
> -       namespace size.  Otherwise it defaults to the maximum size
> -       specified by platform firmware.
> +       namespace size in bytes.  Otherwise it defaults to the maximum
> +       size specified by platform firmware.  This option supports the
> +       suffixes "k" or "K" for KiB, "m" or "M" for MiB, "g" or "G" for
> +       GiB and "t" or "T" for TiB.
>
>  -e::
>  --reconfig=::


Thanks Ross. Applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
