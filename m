Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE3DA20337377
 for <linux-nvdimm@lists.01.org>; Sat,  7 Jul 2018 13:05:36 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id y207-v6so29406688oie.13
 for <linux-nvdimm@lists.01.org>; Sat, 07 Jul 2018 13:05:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180629023050.29217-2-qi.fuli@jp.fujitsu.com>
References: <20180629023050.29217-1-qi.fuli@jp.fujitsu.com>
 <20180629023050.29217-2-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 7 Jul 2018 13:05:35 -0700
Message-ID: <CAPcyv4iJDSutMKeosdrEFikJw=MSGNMgAJP--bO9jwoQ2iaAOQ@mail.gmail.com>
Subject: Re: [PATCH v9 1/3] ndctl, monitor: add ndctl monitor
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
To: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 28, 2018 at 7:30 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> Ndctl monitor is used for monitoring the smart events of nvdimm DIMMs.
> When a smart event fires, monitor will output the notifications which
> include dimm health status and evnet informations to syslog or a
> logfile by setting [--logfile] option. The notifications follow json
> format and can be consumed by log collectors like Fluentd.
>
> The objects to monitor can be selected by setting [--dimm] [--region]
> [--namespace] [--bus] options and the event type can be filtered by
> setting [--dimm-event] option. These options support multiple
> space-separated arguments.
>
> Ndctl monitor can be forked as a daemon by using [--daemon] option,
> such as:
>    # ndctl monitor --daemon --logfile /var/log/ndctl/monitor.log
>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  builtin.h              |   1 +
>  ndctl/Makefile.am      |   3 +-
>  ndctl/lib/libndctl.sym |   1 +
>  ndctl/lib/smart.c      |  17 ++
>  ndctl/libndctl.h       |   6 +
>  ndctl/monitor.c        | 531 +++++++++++++++++++++++++++++++++++++++++
>  ndctl/ndctl.c          |   1 +
>  util/filter.h          |   9 +
>  8 files changed, 568 insertions(+), 1 deletion(-)
>  create mode 100644 ndctl/monitor.c
>
> diff --git a/builtin.h b/builtin.h
> index d3cc723..675a6ce 100644
> --- a/builtin.h
> +++ b/builtin.h
> @@ -39,6 +39,7 @@ int cmd_inject_error(int argc, const char **argv, void *ctx);
>  int cmd_wait_scrub(int argc, const char **argv, void *ctx);
>  int cmd_start_scrub(int argc, const char **argv, void *ctx);
>  int cmd_list(int argc, const char **argv, void *ctx);
> +int cmd_monitor(int argc, const char **argv, void *ctx);
>  #ifdef ENABLE_TEST
>  int cmd_test(int argc, const char **argv, void *ctx);
>  #endif
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index d22a379..7dbf223 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -16,7 +16,8 @@ ndctl_SOURCES = ndctl.c \
>                 util/json-smart.c \
>                 util/json-firmware.c \
>                 inject-error.c \
> -               inject-smart.c
> +               inject-smart.c \
> +               monitor.c
>
>  if ENABLE_DESTRUCTIVE
>  ndctl_SOURCES += ../test/blk_namespaces.c \
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index e939993..f64df56 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -366,4 +366,5 @@ global:
>         ndctl_namespace_inject_error2;
>         ndctl_namespace_uninject_error2;
>         ndctl_cmd_ars_stat_get_flag_overflow;
> +       ndctl_cmd_smart_get_event_flags;
>  } LIBNDCTL_15;
> diff --git a/ndctl/lib/smart.c b/ndctl/lib/smart.c
> index 0455252..90a65d0 100644
> --- a/ndctl/lib/smart.c
> +++ b/ndctl/lib/smart.c
> @@ -101,6 +101,23 @@ NDCTL_EXPORT unsigned int ndctl_cmd_smart_threshold_get_temperature(
>
>  smart_cmd_op(smart_threshold_get_supported_alarms, unsigned int, 0);
>
> +NDCTL_EXPORT unsigned int ndctl_cmd_smart_get_event_flags(struct ndctl_cmd *cmd)

My expectation for this ndctl_*_get_event_flags() api was to have it be:

    ndctl_dimm_get_event_flags()

...and with that in place get rid of the 'struct monitor_dimm' object.
Push everything to be retrieved through api calls against a 'struct
ndctl_dimm' object. In other words, the usage of 'struct ndctl_cmd'
should be hidden and all monitor operations should be done in terms of
'struct ndctl_dimm' helper calls.

This allows for other objects like regions and namespace to grow an
event flags api in the future:

   ndctl_namespace_get_event_flags()
   ndctl_region_get_event_flags()
   ndctl_bus_get_event_flags()

...where those objects don't have any relationship with a 'struct
ndctl_cmd', so neither should dimm event monitoring, at least not for
the library api that ndctl-monitor is using.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
