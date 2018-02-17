Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4865D220F33F8
 for <linux-nvdimm@lists.01.org>; Fri, 16 Feb 2018 16:08:23 -0800 (PST)
Received: by mail-ot0-x243.google.com with SMTP id w10so4204707ote.13
 for <linux-nvdimm@lists.01.org>; Fri, 16 Feb 2018 16:14:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151882591629.8048.11430473366131999791.stgit@djiang5-desk3.ch.intel.com>
References: <151882591629.8048.11430473366131999791.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Feb 2018 16:14:16 -0800
Message-ID: <CAPcyv4jLmj8s3-0tveTQWyoSW1p39vNS2_OiJer3k1ufMJb6pw@mail.gmail.com>
Subject: Re: [PATCH v5] ndctl: add option to list firmware information for a
 DIMM
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

On Fri, Feb 16, 2018 at 4:07 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding firmware output of firmware information when ndctl list -D -F is used.
> Components displayed are current firmware version, updated firmware version,
> and if a coldboot is required (firmware updated).
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Tested-by: Jeff Moyer <jmoyer@redhat.com>
> ---
> v5:
> - Changed next_version to updated version to be in sync with DSM spec.
> - Changed emission of "unknown" string to -1 for error versions.
>
> v4:
> - Remove output when updated_version is 0. That indicates no updated firmware.
>
> v3:
> - Fixed issue where it skips displaying rest of the details if there's no
>   firmware details.
>
> v2:
> - Added copyright
> - Added support for human readable option (hex) for versions
> - Removed check against CMD_CALL as it's not useful
>
>  Documentation/ndctl/ndctl-list.txt |   13 +++++
>  ndctl/Makefile.am                  |    1
>  ndctl/list.c                       |   13 +++++
>  ndctl/util/json-firmware.c         |   91 ++++++++++++++++++++++++++++++++++++
>  util/json.h                        |    2 +
>  5 files changed, 120 insertions(+)
>  create mode 100644 ndctl/util/json-firmware.c
>
> diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
> index fc07a71..85b87d4 100644
> --- a/Documentation/ndctl/ndctl-list.txt
> +++ b/Documentation/ndctl/ndctl-list.txt
> @@ -110,6 +110,19 @@ include::xable-region-options.txt[]
>    }
>  }
>
> +-F::
> +--firmware::
> +       Include dimm firmware info in the listing. For example:
> +[verse]
> +{
> +  "dev":"nmem0",
> +  "firmware":{
> +      "current_version":0,
> +      "next_version":1,
> +      "coldboot_required":true
> +  }

Sorry for the bikeshedding, but I think 'next_version' is more clear
than 'updated_version' and 'coldboot_required' should be
'need_powercycle'.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
