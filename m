Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x241.google.com (mail-wm0-x241.google.com
 [IPv6:2a00:1450:400c:c09::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 10B4D21A0BAA8
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 07:26:49 -0700 (PDT)
Received: by mail-wm0-x241.google.com with SMTP id v4so187394wmb.2
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 07:26:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149437264268.67960.7347964981686229026.stgit@djiang5-desk3.ch.intel.com>
References: <149437257526.67960.3751792583137095911.stgit@djiang5-desk3.ch.intel.com>
 <149437264268.67960.7347964981686229026.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 10 May 2017 07:26:46 -0700
Message-ID: <CAA9_cmctE-uX4BnswWc5emQgXObHu0iatmVxi1Ao_oiRU=Cwrg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ndctl: add list --media-errors support
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 9, 2017 at 4:31 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding option for ndctl list command to show badblocks for region and
> device. The device badblocks are calculated from the region badblocks.
> This allows the user to provide the proper badblock offset and length
> for clearing later on.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>
> v2: added fix to badblocks display from Toshi's testing result.
>
>  ndctl/list.c      |   17 ++++-
>  ndctl/namespace.c |    2 -
>  util/json.c       |  165 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  util/json.h       |    5 +-
>  4 files changed, 183 insertions(+), 6 deletions(-)
>
> diff --git a/ndctl/list.c b/ndctl/list.c
> index 536d333..264b613 100644
> --- a/ndctl/list.c
> +++ b/ndctl/list.c
> @@ -24,6 +24,7 @@ static struct {
>         bool idle;
>         bool health;
>         bool dax;
> +       bool media_errs;
>  } list;
>
>  static struct {
> @@ -99,7 +100,8 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
>                                                 jnamespaces);
>                 }
>
> -               jndns = util_namespace_to_json(ndns, list.idle, list.dax);
> +               jndns = util_namespace_to_json(ndns, list.idle, list.dax,
> +                               list.media_errs);
>                 if (!jndns) {
>                         fail("\n");
>                         continue;
> @@ -117,7 +119,8 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
>         return NULL;
>  }
>
> -static struct json_object *region_to_json(struct ndctl_region *region)
> +static struct json_object *region_to_json(struct ndctl_region *region,
> +               bool include_media_err)
>  {
>         struct json_object *jregion = json_object_new_object();
>         struct json_object *jobj, *jmappings = NULL;
> @@ -203,6 +206,12 @@ static struct json_object *region_to_json(struct ndctl_region *region)
>                 json_object_object_add(jregion, "state", jobj);
>         }
>
> +       if (include_media_err) {
> +               jobj = util_region_badblocks_to_json(region);
> +               if (jobj)
> +                       json_object_object_add(jregion, "badblocks", jobj);
> +       }
> +
>         list_namespaces(region, jregion, NULL, false);
>         return jregion;
>   err:
> @@ -240,6 +249,8 @@ int cmd_list(int argc, const char **argv, void *ctx)
>                 OPT_BOOLEAN('X', "device-dax", &list.dax,
>                                 "include device-dax info"),
>                 OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
> +               OPT_BOOLEAN('M', "media-errors", &list.media_errs,
> +                               "include media errors"),
>                 OPT_END(),
>         };
>         const char * const u[] = {
> @@ -404,7 +415,7 @@ int cmd_list(int argc, const char **argv, void *ctx)
>                                                         jregions);
>                         }
>
> -                       jregion = region_to_json(region);
> +                       jregion = region_to_json(region, list.media_errs);
>                         if (!jregion) {
>                                 fail("\n");
>                                 continue;
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 89b9b6a..6e150b1 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -392,7 +392,7 @@ static int setup_namespace(struct ndctl_region *region,
>                 error("%s: failed to enable\n",
>                                 ndctl_namespace_get_devname(ndns));
>         } else {
> -               struct json_object *jndns = util_namespace_to_json(ndns, 0, 1);
> +               struct json_object *jndns = util_namespace_to_json(ndns, 0, 1, 0);
>
>                 if (jndns)
>                         printf("%s\n", json_object_to_json_string_ext(jndns,
> diff --git a/util/json.c b/util/json.c
> index 07fd113..958ac51 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -233,8 +233,150 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
>         return NULL;
>  }
>
> +struct json_object *util_region_badblocks_to_json(struct ndctl_region *region)
> +{
> +       struct json_object *jbbs = NULL, *jbb_array, *jobj;

Just a naming quibble to follow the convention of the other json
helpers. The other json routines use  j<objectname> for the individual
instance and j<plural objectname> for the array. So that would be:

s/jbbs/jbb/
s/jbb_array/jbbs/

...and if we're fixing up naming lets also:

s/media_errs/media_errors/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
