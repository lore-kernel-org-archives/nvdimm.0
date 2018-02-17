Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A8B321CF1CE8
 for <linux-nvdimm@lists.01.org>; Fri, 16 Feb 2018 17:17:33 -0800 (PST)
Received: by mail-oi0-x231.google.com with SMTP id 23so3607462oip.12
 for <linux-nvdimm@lists.01.org>; Fri, 16 Feb 2018 17:23:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43c35229-30ac-8151-371f-3f7015497ebb@jp.fujitsu.com>
References: <20180209080225.5137-1-qi.fuli@jp.fujitsu.com>
 <20180209080225.5137-3-qi.fuli@jp.fujitsu.com>
 <CAPcyv4i=XAsM2OuGgmqdrBJZVhAtPNJFGFdk=HiFAoUB6Re=Gw@mail.gmail.com>
 <1518483296.4324.12.camel@intel.com>
 <43c35229-30ac-8151-371f-3f7015497ebb@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Feb 2018 17:23:27 -0800
Message-ID: <CAPcyv4hqviz5zeZwJoO5-S--2p4PJFbcioXhrz_ZwVwpUir0og@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] ndctl: monitor: add ndctl create-monitor
 command
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
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 14, 2018 at 9:51 PM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
>
>>> Hi Qi,
>>>
>>> This is getting closer to where I want to see this go, but still some
>>> architecture details to incorporate. I mentioned on the cover letter
>>> that systemd can handle starting, stopping, and show the status of
>>> the
>>> monitor. The other detail to incorporate is that monitor events can
>>> come DIMMs, but also namespaces, regions, and the bus.
>>>
>>> The event list I have collected to date is:
>>>
>>> dimm-spares-remaining
>>> dimm-media-temperature
>>> dimm-controller-temperature
>>> dimm-health-state
>>> dimm-unclean-shutdown
>>> dimm-detected
>>> namespace-media-error
>>> namespace-detected
>>> region-media-error
>>> region-detected
>>> bus-media-error
>>> bus-address-range-scrub-complete
>>> bus-detected
>
> By referring to dimm_listen() in smart-listen.c, I understand how to monitor
> events
> come DIMMs. I have checked the ndctl, but I could not find how to monitor
> events
> come namespaces, region and bus. Could you please mention more?
>>>
>>> ...and I think all of those should be separate options, probably
>>> something like the following, but I'd Vishal to comment if this
>>> scheme
>>> can be handled with the bash tab-completion implementation:
>>>
>>>     ndctl monitor --dimm-events=spares-remaining,media-temperature
>>> --namespace-events=all --regions-events --bus=ACPI.NFIT
>>
>> Yes I think we should be able to extend bash completion for a comma
>> separated list of arguments.
>>
>>> ...where an empty --<object>-events option is equivalent to
>>> --<object>-events=all. Also, similar to "ndctl list" specifying
>>> specific buses, namespaces, etc causes the monitor to filter the
>>> objects based on those properties.
>>>
>>> Since "ndctl list" already has this filtering implemented I'd like to
>>> see it refactored and shared between the 2 implementations rather
>>> than
>>> duplicated as is done in this patch. In other words rework cmd_list()
>>> into a generic nvdimm object walking routine with callback functions
>>> to 'list' or 'monitor' a given object that matches the filter.
>>>
>>> Let me know if the above makes sense. I'm thinking the 'ndctl list'
>>> refactoring might be something I need to handle.
>
> Yes, I agree with refactoring ndctl_list and add a structure shared between
> ndctl list and ndctl monitor.
> But I prefer to use tokens rather than callback functions.
>
> I also think the option should support multiple parameters likes:
>  ndclt monitor --dimm nmem1,nmem2 --region region1,region2
>
> The parameters from the same option can be stored in a list_node.
>
> #define filter_node(field) \
> struct filter_##field##_node { \
>         const char *name; \
>         struct list_node list; \
> };
>
> filter_node(bus);
> filter_node(dimm);
> filter_node(region);
> filter_node(namespace);
>
> struct ndctl_filter {
>         struct list_head filter_bus;
>         struct list_head filter_dimm;
>         struct list_head filter_region;
>         struct list_head filter_namespace;
> } nf;
>
> Make the tokens like follows:
>
> #define list_util_field_filter(field) \
> list_for_each(&nf.filter_##field, filter_##field##_node, list) { \
>         if (util_##field##_filter(field, filter_##field##_node->name)) { \
>                 flag = true; \
>                 break; \
>         } \
> }
>
> #define list_util_bus_filter_by_field(field) \
> list_for_each(&nf.filter_##field, filter_##field##_node, list) { \
>         if (util_bus_filter_by_##field(bus, filter_##field##_node->name)) {
> \
>                 flag = true; \
>                 break; \
>         } \
> }
>
> #define list_util_dimm_filter_by_field(field) \
> list_for_each(&nf.filter_##field, filter_##field##_node, list) { \
>         if (util_dimm_filter_by_##field(dimm, filter_##field##_node->name))
> { \
>                 flag = true; \
>                 break; \
>         } \
> }
>
> Here is how to use the tokens:
>
> ndctl_bus_foreach(ctx, bus) {
>         struct filter_bus_node *filter_bus_node;
>         list_util_field_filter(bus);
>         if (!flag) {
>                 struct filter_region_node *filter_region_node;
>                 list_util_bus_filter_by_field(region);
>         }
>         if (!flag) {
>                 struct filter_namespace_node *filter_namespace_node;
>                 list_util_bus_filter_by_field(namespace);
>         }
>         if (!flag)
>                 continue;
>         ndctl_dimm_foreach(bus, dimm) {
>         flag = false;
>         struct filter_dimm_node *filter_dimm_node;
>                 list_util_field_filter(dimm);
>                 if (!flag) {
>                         struct filter_region_node *filter_region_node;
>                         list_util_dimm_filter_by_field(region);
>                 }
>                 if (!flag) {
>                         struct filter_namespace_node *filter_namespace_node;
>                         list_util_dimm_filter_by_field(namespace);
>                 }
>                 if (!flag)
>                         continue;
>     }
> }
>
> To make sure the util_ndctl_filter() goes right, I would like you give some
> comments?

I think the multi-layer macros makes the code difficult to read, and
I'm not seeing how it handles the case where we're building up a
combined json record representing the entire bus, i.e. "ndctl list
-BRND". I'd rather re-write "ndctl list" in terms of this filter
structure:

struct ndctl_filter_ops {
        int (*match_bus)(struct ndctl_bus *bus, void **ctx, unsigned
long flags);
        int (*match_dimm)(struct ndctl_bus *dimm, void *ctx, unsigned
long flags);
        int (*match_region)(struct ndctl_bus *region, void **ctx,
unsigned long flags);
        int (*match_namespace)(struct ndctl_bus *namespace, void *ctx,
unsigned long flags);
};

...where the match routine is only populated if that device is
selected and it passes filter specific context via the "ctx" variable.
In the case of "ndctl list" that might be the "jbus" container json
object being returned from ->match_bus() and then passed to
->match_dimm() to hold "jdimm" instances. Note that ->match_dimm() and
->match_namespace() only take context as input because those objects
don't have any children.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
