Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 321C122571B57
 for <linux-nvdimm@lists.01.org>; Tue, 20 Mar 2018 14:51:56 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id y27-v6so2696194oix.10
 for <linux-nvdimm@lists.01.org>; Tue, 20 Mar 2018 14:58:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152158255868.52915.9362618183529367890.stgit@djiang5-desk3.ch.intel.com>
References: <152158255868.52915.9362618183529367890.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 20 Mar 2018 14:58:24 -0700
Message-ID: <CAPcyv4ivjLchpDCMCz54uSYB2LkFcqBQaw8zM3ro2QfXzhaS9w@mail.gmail.com>
Subject: Re: [PATCH v3] ndctl: Add support for get bus and region persistence
 domain
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

On Tue, Mar 20, 2018 at 2:50 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding helper functions to iterate through sysfs region persistence domain
> attribute. The region will display the domain with the most persistence for the
> region.  The bus will display the domain attribute with the least persistence
> amongst all the regions. ndctl_bus_get_persistence_domain() and
> ndctl_region_get_persistence_domain are exported. ndctl list will also display
> the region persistence domain as well.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>
> v3:
> - fixed up return types per Ross's comments
> - removed persistence_domain for bus and calculate on the fly per Dan's comment
>
> v2:
> - Simplied scanning of persistence domain from Ross's comments.
>
>  ndctl/lib/libndctl.c   |   85 ++++++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym |    2 +
>  ndctl/libndctl.h       |   11 ++++++
>  ndctl/list.c           |   16 +++++++++
>  4 files changed, 114 insertions(+)
[..]
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index f3a27411..84f441ef 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -115,6 +115,7 @@ int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus, int cmd);
>  unsigned int ndctl_bus_get_revision(struct ndctl_bus *bus);
>  unsigned int ndctl_bus_get_id(struct ndctl_bus *bus);
>  const char *ndctl_bus_get_provider(struct ndctl_bus *bus);
> +enum ndctl_persistence ndctl_bus_get_persistence_domain(struct ndctl_bus *bus);
>  int ndctl_bus_wait_probe(struct ndctl_bus *bus);
>  int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus);
>  unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus);
> @@ -305,6 +306,14 @@ struct badblock {
>         unsigned long long offset;
>         unsigned int len;
>  };
> +
> +enum ndctl_persistence {

Let's fully spell this out this type as "enum ndctl_persistence_domain"

> +       PERSISTENCE_NONE = 0,
> +       PERSISTENCE_MEM_CTRL,
> +       PERSISTENCE_CPU_CACHE,
> +       PERSISTENCE_UNKNOWN,
> +};

Just in case there might be additional theoretical persistence domains
in the future between cache and memory controller, or memory
controller and media lets pad some values into this definition.

I.e. something like:

       PERSISTENCE_NONE = 0,
       PERSISTENCE_MEM_CTRL = 10,
       PERSISTENCE_CPU_CACHE = 20,
       PERSISTENCE_UNKNOWN = INT_MAX,
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
