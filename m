Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x22f.google.com (mail-yb0-x22f.google.com
 [IPv6:2607:f8b0:4002:c09::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B01A209455FD
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jul 2017 09:40:59 -0700 (PDT)
Received: by mail-yb0-x22f.google.com with SMTP id 84so9162115ybe.0
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jul 2017 09:42:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170712154441.C680.E1E9C6FF@jp.fujitsu.com>
References: <20170712154441.C680.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Jul 2017 09:42:45 -0700
Message-ID: <CAPcyv4hx86g+GVj38HEH3Lb2XORQwCQwY=Oc+Ce90HCdCUm7OA@mail.gmail.com>
Subject: Re: [PATCH v3] ndctl list should show more hardware information
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 11, 2017 at 11:44 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> Hi,
>
> I made the v3 of output hardware id .
> If this patch is ok, please apply.
>
> --
> Change log
>
> v3 :  - rebased on human readable option patch.
>
>
> v2 :  - use json_object_new_int() for each data.
>       - check MAX value for each data.
>       - phys_id becomes unsigned short from signed short.
>
> ---
>    The current "id" data of dimm (ndctl list -D) shows the information
>    of DIMM module vendor or serial number.  However, I think it is not enough.
>
>    If a NVDIMM becomes broken, users need to know its physical place
>    rather than vendor or serial number to replace the NVDIMM.
>
>    There are 2 candidate of such information.
>      a) NFIT Device Handle (_ADR of the NVDIMM device)
>         This date includes node controller id and socket id.
>      b) NVDIMM Physical ID (Handle for the SMBIOS Memory Device (Type 17)).
>         The dmidecode can show this handle with more information like "Locator"
>         So, user can find the location of NVDIMM.
>
>    At first, I think _ADR is enough information.
>
>    However, when I talked with our firmware team about this requirement,
>    they said it may not be good data, because the node contoller ID is not
>    stable on our server due to "partitioning" feature.
>    (Our server can have plural partition on one box, and may have plural
>     node 0.)
>
>    So, I make the ndctl shows not only NFIT Device Handle but also
>    NVDIMM Physical ID. Then, user can find the location with dmidecode.
>
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

Looks good to me, applied and pushed out to the 'pending' branch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
