Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 88DD821B02845
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 14:11:31 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id 14-v6so17368854oie.3
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 14:11:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180626204649.7665-1-keith.busch@intel.com>
References: <20180626204649.7665-1-keith.busch@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Jun 2018 14:11:30 -0700
Message-ID: <CAPcyv4gaGsufzXc9KNaTnrHJU+Mf+eQtFW=7ENmMdGNh9LNK4A@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/2] ndctl: Add 'list' verbose options
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
To: Keith Busch <keith.busch@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 26, 2018 at 1:46 PM, Keith Busch <keith.busch@intel.com> wrote:
> The informational and miscellaneous flag options are becoming more
> numerous, and can be difficult to remember what can be listed. Rather
> than add more flags to suppress and show some of the less pertinent
> information, this patch adds a 'verbose' option that increases the detail
> of information displayed.
>
> The verbose option can be repeated multiple times to increase the
> detail. There are currently three levels of verbose, and repeating more
> than that has the same behavior as level three.
>
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  ndctl/list.c | 25 ++++++++++++++++++++++++-
>  util/json.c  | 33 +++++++++++++++++++--------------
>  util/json.h  |  1 +
>  3 files changed, 44 insertions(+), 15 deletions(-)
>
> diff --git a/ndctl/list.c b/ndctl/list.c
> index 6cf7c39..98e5b3d 100644
> --- a/ndctl/list.c
> +++ b/ndctl/list.c
> @@ -36,6 +36,7 @@ static struct {
>         bool media_errors;
>         bool human;
>         bool firmware;
> +       int verbose;
>  } list;
>
>  static unsigned long listopts_to_flags(void)
> @@ -50,6 +51,8 @@ static unsigned long listopts_to_flags(void)
>                 flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
>         if (list.human)
>                 flags |= UTIL_JSON_HUMAN;
> +       if (list.verbose)
> +               flags |= UTIL_JSON_VERBOSE;
>         return flags;
>  }
>
> @@ -112,7 +115,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
>         numa = ndctl_region_get_numa_node(region);
>         if (numa >= 0) {
>                 jobj = json_object_new_int(numa);
> -               if (jobj)
> +               if (jobj && flags & UTIL_JSON_VERBOSE)
>                         json_object_object_add(jregion, "numa_node", jobj);
>         }
>
> @@ -444,6 +447,8 @@ int cmd_list(int argc, const char **argv, void *ctx)
>                                 "include media errors"),
>                 OPT_BOOLEAN('u', "human", &list.human,
>                                 "use human friendly number formats "),
> +               OPT_INCR('v', "verbose", &list.verbose,
> +                               "increase output detail"),
>                 OPT_END(),
>         };
>         const char * const u[] = {
> @@ -468,6 +473,24 @@ int cmd_list(int argc, const char **argv, void *ctx)
>                         param.mode = "dax";
>         }
>
> +       switch (list.verbose) {
> +       default:
> +       case 3:
> +               list.idle = true;
> +               list.firmware = true;
> +       case 2:
> +               list.buses = true;
> +               list.regions = true;
> +       case 1:
> +               list.dimms = true;
> +               list.health = true;

This turns on listing DIMMs even if --dimms was not specified on the
command line. I was thinking not until level 2 do we start turning on
more device objects beyond what is specified. For example "ndctl list
-v" is the same as "ndctl list" that lists namespaces by default.
However it goes further to turn on extra / namespace-relative data
like 'raw_uuid' and 'sector_size' but also data like "--media-errors"
and "--dax". Then it follows commands like "ndctl list -Dv" list the
DIMMs and turns on optional fields like 'handle' and 'phys_id' in
addition to "--health" information.

> +               list.media_errors = true;
> +               list.namespaces = true;
> +               list.dax = true;
> +       case 0:
> +               break;
> +       }
> +
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
