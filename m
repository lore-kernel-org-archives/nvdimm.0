Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22a.google.com (mail-yw0-x22a.google.com
 [IPv6:2607:f8b0:4002:c05::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4ED3120958969
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 10:21:49 -0700 (PDT)
Received: by mail-yw0-x22a.google.com with SMTP id v193so29824287ywg.2
 for <linux-nvdimm@lists.01.org>; Wed, 05 Jul 2017 10:23:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170705181250.8D09.E1E9C6FF@jp.fujitsu.com>
References: <20170705181250.8D09.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 5 Jul 2017 10:23:27 -0700
Message-ID: <CAPcyv4jGTAB7CEWADPWMB5a7kjA=52BfOj6WYQG-WrrRAC88qQ@mail.gmail.com>
Subject: Re: [RFC/PATCH] ndctl list should show more hardware information
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

On Wed, Jul 5, 2017 at 2:12 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> Hello,
>
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
>    This is the first trial patch. So any comments are welcome.

This looks ok to me. The only change I would request is to not assume
that all NVDIMMs have this NFIT-specific data available.

>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> ---
> diff --git a/util/json.c b/util/json.c
> index b718d74..749a358 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -68,6 +68,9 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
>  {
>         struct json_object *jdimm = json_object_new_object();
>         const char *id = ndctl_dimm_get_unique_id(dimm);
> +       unsigned int handle = ndctl_dimm_get_handle(dimm);
> +       short phys_id = ndctl_dimm_get_phys_id(dimm);
> +       char buf[11];
>         struct json_object *jobj;
>
>         if (!jdimm)
> @@ -85,6 +88,18 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
>                 json_object_object_add(jdimm, "id", jobj);
>         }
>
> +       snprintf(buf, 11, "0x%08x", handle);
> +       jobj = json_object_new_string(buf);
> +       if (!jobj)
> +               goto err;
> +       json_object_object_add(jdimm, "handle", jobj);

For example, this should be in a "if (handle < UINIT_MAX)" branch...

> +
> +       snprintf(buf, 7, "0x%04x", phys_id );
> +       jobj = json_object_new_string(buf);
> +       if (!jobj)
> +               goto err;
> +       json_object_object_add(jdimm, "phys_id", jobj);
> +

..., and this should be in a "if (phys < USHORT_MAX)" branch.

Lastly, I think these should be json_object_new_int() types since they
are numbers not strings.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
