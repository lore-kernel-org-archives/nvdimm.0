Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E413F21EA35BA
 for <linux-nvdimm@lists.01.org>; Wed,  6 Sep 2017 22:52:22 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id h70so53297568oic.1
 for <linux-nvdimm@lists.01.org>; Wed, 06 Sep 2017 22:55:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170907140854.7F80.E1E9C6FF@jp.fujitsu.com>
References: <20170907140049.7F71.E1E9C6FF@jp.fujitsu.com>
 <20170907140854.7F80.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 6 Sep 2017 22:55:11 -0700
Message-ID: <CAPcyv4ij8qDZUH+p5_TyoYHX5EzLBaSA1hSkF63xjrZthF4=MQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v5 5/5] ndctl: show bad dimm's name by ndctl list
 command.
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

On Wed, Sep 6, 2017 at 10:08 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> Show dimm's name which has badblock by ndctl list command.
> This patch uses translate SPA interface to get bad dimm info.
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> ---
>  util/json.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>
> diff --git a/util/json.c b/util/json.c
> index 98165b7..639f0ff 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -366,6 +366,15 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
>         return NULL;
>  }
>
> +static struct ndctl_dimm *badblock_to_dimm(struct ndctl_region *region,
> +               unsigned long long spa)
> +{
> +       struct ndctl_bus *bus;
> +
> +       bus = ndctl_region_get_bus(region);
> +       return ndctl_bus_get_dimm_by_physical_address(bus, spa);
> +}
> +
>  struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
>                 unsigned int *bb_count, unsigned long flags)
>  {
> @@ -381,6 +390,18 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
>
>         ndctl_region_badblock_foreach(region, bb) {
>                 if (flags & UTIL_JSON_MEDIA_ERRORS) {
> +                       struct ndctl_dimm *dimm = NULL;
> +                       unsigned long long spa;
> +
> +                       /* get start address of region */
> +                       spa = ndctl_region_get_resource(region);
> +                       if (spa == ULONG_MAX)
> +                               goto err_array;
> +
> +                       /* get address of bad block */
> +                       spa += bb->offset << 9;
> +                       dimm = badblock_to_dimm(region, spa);

Ok the libndctl pieces are looking good, but I have question about
this. We only return the first DIMM that has the error... what if the
length of the record causes us to span more than one dimm?

> +
>                         jbb = json_object_new_object();
>                         if (!jbb)
>                                 goto err_array;
> @@ -395,6 +416,12 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
>                                 goto err;
>                         json_object_object_add(jbb, "length", jobj);
>
> +                       if (dimm) {
> +                               jobj = json_object_new_string(ndctl_dimm_get_devname(dimm));

We probably need to make this an array of DIMMs and call badblock() to
DIMM for every 512 byte block in the range.

> +                               if (!jobj)
> +                                       goto err;
> +                               json_object_object_add(jbb, "dimm", jobj);
> +                       }
>                         json_object_array_add(jbbs, jbb);
>                 }
>
> @@ -436,6 +463,7 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
>
>         ndctl_region_badblock_foreach(region, bb) {
>                 unsigned long long bb_begin, bb_end, begin, end;
> +               struct ndctl_dimm *dimm = NULL;
>
>                 bb_begin = region_begin + (bb->offset << 9);
>                 bb_end = bb_begin + (bb->len << 9) - 1;
> @@ -456,6 +484,8 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
>                 offset = (begin - dev_begin) >> 9;
>                 len = (end - begin + 1) >> 9;
>
> +               dimm = badblock_to_dimm(region, begin);
> +
>                 if (flags & UTIL_JSON_MEDIA_ERRORS) {
>                         /* add to json */
>                         jbb = json_object_new_object();
> @@ -472,6 +502,13 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
>                                 goto err;
>                         json_object_object_add(jbb, "length", jobj);
>
> +                       if (dimm) {
> +                               jobj = json_object_new_string(ndctl_dimm_get_devname(dimm));

Since this will eventually be the same code as above lets turn it into
a common badblocks_to_jdimms() helper that returns a json array.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
