Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7EC972034C8A6
 for <linux-nvdimm@lists.01.org>; Fri, 27 Apr 2018 12:25:32 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id l22-v6so3255470otj.0
 for <linux-nvdimm@lists.01.org>; Fri, 27 Apr 2018 12:25:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152485312055.47995.12642343910789705739.stgit@djiang5-desk3.ch.intel.com>
References: <152485300486.47995.7487206758776476576.stgit@djiang5-desk3.ch.intel.com>
 <152485312055.47995.12642343910789705739.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 27 Apr 2018 12:25:31 -0700
Message-ID: <CAPcyv4g240gwbHX4-JJUNeuzVy0T4Dz5Ykh=SQf7JyAuWCf5qA@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] ndctl: convert namespace actions to use
 util_filter_walk()
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 27, 2018 at 11:18 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> util_filter_walk() does the looping through of busses and regions. Removing
> duplicate code in namespace ops and provide filter functions so we can
> utilize util_filter_walk() and share common code.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/namespace.c |  164 ++++++++++++++++++++++++++++++-----------------------
>  test/btt-check.sh |    2 -
>  util/filter.c     |    5 +-
>  util/filter.h     |    8 +++
>  4 files changed, 105 insertions(+), 74 deletions(-)
>
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index e61f500c..404d6761 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -983,14 +983,92 @@ static int namespace_reconfig(struct ndctl_region *region,
>  int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
>                 bool repair, bool logfix);
>
> +static bool filter_bus(struct ndctl_bus *bus, struct util_filter_ctx *ctx)
> +{
> +       return true;
> +}
> +
> +static bool filter_region(struct ndctl_region *region,
> +               struct util_filter_ctx *ctx)
> +{
> +       struct nsaction_filter_arg *nfa = ctx->nsaction;
> +       int rc = 0;
> +       bool out = true;
> +
> +       if (nfa->action == ACTION_CREATE && !nfa->namespace) {
> +               if (nfa->rc == 1)
> +                       return false;
> +
> +               rc = namespace_create(region);
> +               if (rc != -EAGAIN) {
> +                       if (rc == 0)
> +                               rc = 1;
> +                       /* don't proceed in the filter loop */
> +                       out = false;
> +               }
> +               nfa->rc = rc;
> +       }
> +
> +       return out;
> +}
> +
> +static void filter_namespace(struct ndctl_namespace *ndns,
> +               struct util_filter_ctx *ctx)
> +{
> +       struct ndctl_region *region = ndctl_namespace_get_region(ndns);
> +       struct nsaction_filter_arg *nfa = ctx->nsaction;
> +       const char *ndns_name;
> +       int rc;
> +
> +       /* we have an error, don't do anything else */
> +       if (nfa->rc < 0)
> +               return;

Why do we need to stop here? This seems like a behavior regression.

For example:

    ndctl disable-namespace all

Should continue to disable subsequent namespaces even if a previous
namespace attempt fails.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
