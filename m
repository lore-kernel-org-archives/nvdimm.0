Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D335211F887C
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 08:08:34 -0700 (PDT)
Received: by mail-ot0-x243.google.com with SMTP id h6-v6so2574598otj.0
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 08:08:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180627052426.26020-2-qi.fuli@jp.fujitsu.com>
References: <20180627052426.26020-1-qi.fuli@jp.fujitsu.com>
 <20180627052426.26020-2-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Jun 2018 08:08:32 -0700
Message-ID: <CAPcyv4jPrEYbwORjjkQa8M+ryzp4sNY=tvhJbxiKFazQdcJOmQ@mail.gmail.com>
Subject: Re: [PATCH v8 1/3] ndctl, monitor: add ndctl monitor
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

On Tue, Jun 26, 2018 at 10:24 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
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
>  builtin.h         |   1 +
>  ndctl/Makefile.am |   3 +-
>  ndctl/monitor.c   | 508 ++++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/ndctl.c     |   1 +
>  4 files changed, 512 insertions(+), 1 deletion(-)
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
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> new file mode 100644
> index 0000000..d926a81
> --- /dev/null
> +++ b/ndctl/monitor.c
> @@ -0,0 +1,508 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2018, FUJITSU LIMITED. All rights reserved. */
> +
> +#include <stdio.h>
> +#include <json-c/json.h>
> +#include <libgen.h>
> +#include <dirent.h>
> +#include <util/log.h>
> +#include <util/json.h>
> +#include <util/filter.h>
> +#include <util/util.h>
> +#include <util/parse-options.h>
> +#include <util/strbuf.h>
> +#include <ndctl/lib/private.h>
> +#include <ndctl/libndctl.h>
> +#include <sys/stat.h>
> +#include <sys/epoll.h>
> +#define BUF_SIZE 2048
> +
> +#define DIMM_SPARES_REMAINING  (1 << 0)
> +#define DIMM_MEDIA_TEMPERATURE (1 << 1)
> +#define DIMM_CTRL_TEMPERATURE  (1 << 2)
> +#define DIMM_HEALTH_STATE      (1 << 3)
> +#define DIMM_UNCLEAN_SHUTDOWN  (1 << 4)
> +
> +static struct monitor {
> +       const char *logfile;
> +       const char *dimm_event;
> +       bool daemon;
> +} monitor;
> +
> +struct monitor_dimm {
> +       struct ndctl_dimm *dimm;
> +       int health_eventfd;
> +       unsigned int health;
> +       unsigned int event_flags;
> +       struct list_node list;
> +};
> +
> +struct monitor_filter_arg {
> +       struct list_head dimms;
> +       int maxfd_dimm;
> +       int num_dimm;
> +       unsigned long flags;
> +};
> +
> +struct util_filter_params param;
> +
> +static int did_fail;
> +
> +#define fail(fmt, ...) \
> +do { \
> +       did_fail = 1; \
> +       err((struct ndctl_ctx *)ctx, "ndctl-%s:%s:%d: " fmt, \
> +                       VERSION, __func__, __LINE__, ##__VA_ARGS__); \
> +} while (0)

It is odd that the monitor command emits errors in this format, but no
other ndctl uses scheme. Also. any print that includes source code
line numbers is debug in my opinion. Source code line numbers are
useful for developers not typical users. Let's make this a debug level
print and circle back later to see if we need a better common error
print format across all commands.

> +
> +static bool is_dir(char *filepath)
> +{
> +       DIR *dir = opendir(filepath);
> +       if (dir) {
> +               closedir(dir);
> +               return true;
> +       }
> +       return false;
> +}
> +
> +static void log_syslog(struct ndctl_ctx *ctx, int priority, const char *file,
> +               int line, const char *fn, const char *format, va_list args)
> +{
> +       char *buf;
> +
> +       buf = malloc(BUF_SIZE);
> +       if (!buf) {
> +               fail("malloc for log buffer failed\n");
> +               return;
> +       }
> +       vsnprintf(buf, BUF_SIZE, format, args);
> +       syslog(priority, "%s\n", buf);
> +
> +       free(buf);
> +       return;
> +}
> +
> +static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
> +               int line, const char *fn, const char *format, va_list args)
> +{
> +       FILE *f;
> +       char *buf, *log_dir;
> +
> +       buf = malloc(BUF_SIZE);
> +       if (!buf) {
> +               fail("malloc for log buffer failed\n");
> +               return;
> +       }
> +       vsnprintf(buf, BUF_SIZE, format, args);

You can replace malloc + vsnprintf with asprintf().

> +
> +       log_dir = dirname(strdup(monitor.logfile));
> +       if (!log_dir) {
> +               ndctl_set_log_fn(ctx, log_syslog);
> +               fail("strdup %s failed\n%s", monitor.logfile, buf);
> +               goto end;
> +       }
> +       if (!is_dir(log_dir)) {
> +               ndctl_set_log_fn(ctx, log_syslog);
> +               fail("dir: %s is required\n%s", log_dir, buf);
> +               goto end;
> +       }

This check is buggy, the directory could become a regular file between
is_dir() returning and fopen(). Why not just call fopen() directly and
skip this is_dir() check? It will fail properly if
dirname(monitor.logfile) is not a directory.

> +
> +       f = fopen(monitor.logfile, "a+");
> +       if (!f) {
> +               ndctl_set_log_fn(ctx, log_syslog);
> +               fail("open logfile %s failed\n%s", monitor.logfile, buf);
> +               goto end;
> +       }
> +       fprintf(f, "%s\n", buf);
> +       fclose(f);
> +end:
> +       if (log_dir)
> +               free(log_dir);
> +       if (buf)
> +               free(buf);
> +       return;
> +}
> +
> +static int get_monitor_dimm_data(struct monitor_dimm *mdimm)
> +{
> +       struct ndctl_cmd *cmd;
> +       unsigned int alarm_flags;
> +
> +       cmd = /(mdimm->dimm);
> +       if (!cmd)
> +               goto out;
> +
> +       if (ndctl_cmd_submit(cmd))
> +               goto out;
> +
> +       mdimm->health_eventfd = ndctl_dimm_get_health_eventfd(mdimm->dimm);
> +
> +       alarm_flags = ndctl_cmd_smart_get_alarm_flags(cmd);
> +       if (alarm_flags & ND_SMART_SPARE_TRIP)
> +               mdimm->event_flags |= DIMM_SPARES_REMAINING;
> +       if (alarm_flags & ND_SMART_MTEMP_TRIP)
> +               mdimm->event_flags |= DIMM_MEDIA_TEMPERATURE;
> +       if (alarm_flags & ND_SMART_CTEMP_TRIP)
> +               mdimm->event_flags |= DIMM_CTRL_TEMPERATURE;

Hmm, why are there no calls to
ndctl_cmd_smart_threshold_set_alarm_control() in this implementation?
If the user specified that they want DIMM_SPARES_REMAINING alarms then
the monitor should check if that alarm is supported
(ndctl_cmd_smart_threshold_get_supported_alarms()) and optionally
enable that alarm. Otherwise the monitor should report that the
requested event time / alarm is not supported.

> +
> +       mdimm->health = ndctl_cmd_smart_get_health(cmd);
> +
> +       if (ndctl_cmd_smart_get_shutdown_state(cmd))
> +               mdimm->event_flags |= DIMM_UNCLEAN_SHUTDOWN;
> +
> +       ndctl_cmd_unref(cmd);
> +       return 0;
> +out:
> +       if (cmd)
> +               ndctl_cmd_unref(cmd);
> +       return 1;
> +}
> +
> +static struct json_object *dimm_event_to_json(struct monitor_dimm *mdimm)
> +{
> +       struct json_object *jevent, *jobj;
> +       bool spares_flag, media_temp_flag, ctrl_temp_flag,
> +                       health_state_flag, unclean_shutdown_flag;
> +       struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(mdimm->dimm);
> +
> +       jevent = json_object_new_object();
> +       if (!jevent) {
> +               fail("\n");
> +               return NULL;
> +       }
> +
> +       spares_flag = !!(mdimm->event_flags & DIMM_SPARES_REMAINING);
> +       media_temp_flag = !!(mdimm->event_flags & DIMM_MEDIA_TEMPERATURE);
> +       ctrl_temp_flag = !!(mdimm->event_flags & DIMM_CTRL_TEMPERATURE);
> +       health_state_flag = !!(mdimm->event_flags & DIMM_HEALTH_STATE);
> +       unclean_shutdown_flag = !!(mdimm->event_flags & DIMM_UNCLEAN_SHUTDOWN);
> +
> +       jobj = json_object_new_boolean(spares_flag);
> +       if (jobj)
> +               json_object_object_add(jevent, "dimm-spares-remaining", jobj);

I think we should gate these new objects from being created if the
user did not ask for the specific event to be monitored.

> +
> +       jobj = json_object_new_boolean(media_temp_flag);
> +       if (jobj)
> +               json_object_object_add(jevent, "dimm-media-temperature", jobj);
> +
> +       jobj = json_object_new_boolean(ctrl_temp_flag);
> +       if (jobj)
> +               json_object_object_add(jevent,
> +                               "dimm-controller-temperature", jobj);
> +
> +       jobj = json_object_new_boolean(health_state_flag);
> +       if (jobj)
> +               json_object_object_add(jevent, "dimm-health-state", jobj);
> +
> +       jobj = json_object_new_boolean(unclean_shutdown_flag);
> +       if (jobj)
> +               json_object_object_add(jevent, "dimm-unclean-shutdown", jobj);
> +
> +       return jevent;
> +}
> +
> +static int notify_dimm_event(struct monitor_dimm *mdimm)
> +{
> +       struct json_object *jmsg, *jdimm, *jobj;
> +       struct timespec ts;
> +       char timestamp[32];
> +       struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(mdimm->dimm);
> +
> +       jmsg = json_object_new_object();
> +       if (!jmsg) {
> +               fail("\n");
> +               return -1;
> +       }
> +
> +       clock_gettime(CLOCK_REALTIME, &ts);
> +       sprintf(timestamp, "%10ld.%09ld", ts.tv_sec, ts.tv_nsec);
> +       jobj = json_object_new_string(timestamp);
> +       if (!jobj) {
> +               fail("\n");
> +               return -1;
> +       }
> +       json_object_object_add(jmsg, "timestamp", jobj);
> +
> +       jobj = json_object_new_int(getpid());
> +       if (!jobj) {
> +               fail("\n");
> +               return -1;
> +       }
> +       json_object_object_add(jmsg, "pid", jobj);
> +
> +       jobj = dimm_event_to_json(mdimm);
> +       if (!jobj) {
> +               fail("\n");
> +               return -1;
> +       }
> +       json_object_object_add(jmsg, "event", jobj);
> +
> +       jdimm = util_dimm_to_json(mdimm->dimm, 0);
> +       if (!jdimm) {
> +               fail("\n");
> +               return -1;
> +       }
> +       json_object_object_add(jmsg, "dimm", jdimm);
> +
> +       jobj = util_dimm_health_to_json(mdimm->dimm);
> +       if (!jobj) {
> +               fail("\n");
> +               return -1;
> +       }
> +       json_object_object_add(jdimm, "health", jobj);
> +
> +       notice(ctx, "%s",
> +               json_object_to_json_string_ext(jmsg, JSON_C_TO_STRING_PLAIN));
> +
> +       free(jobj);
> +       free(jdimm);
> +       free(jmsg);
> +       return 0;
> +}
> +
> +static struct monitor_dimm *util_dimm_event_filter(struct monitor_dimm *mdimm,
> +               const char *__ident)
> +{
> +       char *ident, *save;
> +       const char *name;
> +       struct monitor_dimm *__mdimm;
> +       struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(mdimm->dimm);
> +
> +       __mdimm = calloc(1, sizeof(struct monitor_dimm));
> +       if (!__mdimm) {
> +               fail("\n");
> +               return NULL;
> +       }

Why do we need a dynamic allocation? Can't this just live on the stack?

> +
> +       __mdimm->dimm = mdimm->dimm;
> +       if (get_monitor_dimm_data(__mdimm)) {
> +               fail("\n");
> +               goto out;
> +       }
> +       if (mdimm->health != __mdimm->health)
> +               __mdimm->event_flags |= DIMM_HEALTH_STATE;
> +
> +       if (!__ident)
> +               return __mdimm;
> +
> +       ident = strdup(__ident);
> +       if (!ident)
> +               goto out;
> +
> +       for (name = strtok_r(ident, " ", &save); name;
> +                       name = strtok_r(NULL, " ", &save)) {
> +               if (strcmp(name, "all") == 0)
> +                       break;
> +
> +               if (strcmp(name, "dimm-spares-remaining") == 0) {
> +                       if (__mdimm->event_flags & DIMM_SPARES_REMAINING)
> +                               break;
> +               } else if (strcmp(name, "dimm-media-temperature") == 0) {
> +                       if (__mdimm->event_flags & DIMM_MEDIA_TEMPERATURE)
> +                               break;
> +               } else if (strcmp(name, "dimm-controller-temperature") == 0) {
> +                       if (__mdimm->event_flags & DIMM_CTRL_TEMPERATURE)
> +                               break;
> +               } else if (strcmp(name, "dimm-health-state") == 0) {
> +                       if (__mdimm->event_flags & DIMM_HEALTH_STATE)
> +                               break;
> +               } else if (strcmp(name, "dimm-unclean-shutdown") == 0) {
> +                       if (__mdimm->event_flags & DIMM_UNCLEAN_SHUTDOWN)
> +                               break;

It seems like you need some extra data associated with each dimm.
Let's just add that to 'struct ndctl_dimm' and create a libndctl api
to set/retrieve it. Actually, these seems closely tied with the output
from the threshold commands, so I think this just wants a ndctl apis
like ndctl_{set,get}_event_flags() that manage the threshold alarms
and cache the result.

> +               }
> +       }
> +       free(ident);
> +
> +       if (name)
> +               return __mdimm;
> +out:
> +       free(__mdimm);
> +       return NULL;
> +}
> +
> +static bool filter_region(struct ndctl_region *region,
> +               struct util_filter_ctx *ctx)
> +{
> +       return true;
> +}
> +
> +static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *ctx)
> +{
> +       struct monitor_dimm *mdimm, *__mdimm;
> +       struct monitor_filter_arg *mfa = (struct monitor_filter_arg *)ctx->arg;

Rather than this cast, add monitor_filter_arg to the union in util_filter_ctx.

> +
> +       if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD))
> +               return;
> +
> +       if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART))
> +               return;
> +
> +       mdimm = calloc(1, sizeof(struct monitor_dimm));
> +       if (!mdimm)
> +               return;

Why do we need a dynamic allocation? Can't this just live on the
stack? This might also go away once we have this extra per-dimm data
properly pushed down into the library.

> +
> +       mdimm->dimm = dimm;
> +       if (get_monitor_dimm_data(mdimm))
> +               goto out;
> +
> +       if (mdimm->event_flags) {
> +               __mdimm = util_dimm_event_filter(mdimm, monitor.dimm_event);
> +               if (__mdimm) {
> +                       if (notify_dimm_event(__mdimm))
> +                               fail("notify dimm event failed\n");
> +                       free(__mdimm);
> +               }
> +       }
> +
> +       list_add_tail(&mfa->dimms, &mdimm->list);
> +       if (mdimm->health_eventfd > mfa->maxfd_dimm)
> +               mfa->maxfd_dimm = mdimm->health_eventfd;
> +       mfa->num_dimm++;
> +       return;
> +out:
> +       free(mdimm);
> +       return;
> +}
> +
> +static bool filter_bus(struct ndctl_bus *bus, struct util_filter_ctx *ctx)
> +{
> +       return true;
> +}
> +
> +static int monitor_event(struct ndctl_ctx *ctx,
> +               struct monitor_filter_arg *mfa)
> +{
> +       struct epoll_event ev, *events;
> +       int nfds, epollfd, i, rc;
> +       struct monitor_dimm *mdimm, *__mdimm;
> +       char buf;
> +
> +       events = calloc(mfa->num_dimm, sizeof(struct epoll_event));
> +       if (!events) {
> +               fail("malloc for events error\n");
> +               goto out;
> +       }
> +       epollfd = epoll_create1(0);
> +       if (epollfd == -1) {
> +               fail("epoll_create1 error\n");
> +               goto out;
> +       }
> +       list_for_each(&mfa->dimms, mdimm, list) {
> +               memset(&ev, 0, sizeof(ev));
> +               rc = pread(mdimm->health_eventfd, &buf, sizeof(buf), 0);
> +               if (rc < 0) {
> +                       fail("pread error\n");
> +                       goto out;
> +               }
> +               ev.data.ptr = mdimm;
> +               if (epoll_ctl(epollfd, EPOLL_CTL_ADD,
> +                               mdimm->health_eventfd, &ev) != 0) {
> +                       fail("epoll_ctl error\n");
> +                       goto out;
> +               }
> +       }
> +
> +       while (1) {
> +               did_fail = 0;
> +               nfds = epoll_wait(epollfd, events, mfa->num_dimm, -1);
> +               if (nfds <= 0) {
> +                       fail("epoll_wait error\n");
> +                       goto out;
> +               }
> +               for (i = 0; i < nfds; i++) {
> +                       mdimm = events[i].data.ptr;
> +                       __mdimm = util_dimm_event_filter(mdimm,
> +                                       monitor.dimm_event);
> +                       if (__mdimm) {
> +                               if (notify_dimm_event(__mdimm))
> +                                       fail("notify dimm event failed\n");
> +                               free(__mdimm);
> +                       }
> +                       rc = pread(mdimm->health_eventfd, &buf, sizeof(buf), 0);
> +                       if (rc < 0) {
> +                               fail("pread error\n");
> +                               goto out;
> +                       }
> +               }
> +               if (did_fail)
> +                       goto out;
> +       }
> +       return 0;
> +out:
> +       return 1;
> +}
> +
> +int cmd_monitor(int argc, const char **argv, void *ctx)
> +{
> +       int i;
> +       const struct option options[] = {
> +               OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
> +               OPT_STRING('r', "region", &param.region, "region-id",
> +                               "filter by region"),
> +               OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
> +                               "filter by dimm"),
> +               OPT_STRING('n', "namespace", &param.namespace,
> +                               "namespace-id", "filter by namespace id"),
> +               OPT_FILENAME('l', "logfile", &monitor.logfile, "file | syslog",
> +                               "where to output the monitor's notification"),
> +               OPT_BOOLEAN('f', "daemon", &monitor.daemon,
> +                               "run ndctl monitor as a daemon"),
> +               OPT_STRING('D', "dimm-event", &monitor.dimm_event,
> +                       "dimm-spares-remaining | dimm-media-temperature | dimm-controller-temperature | dimm-health-state | dimm-unclean-shutdown",
> +                       "filter by DIMM event type"),
> +               OPT_END(),
> +       };
> +       const char * const u[] = {
> +               "ndctl monitor [<options>]",
> +               NULL
> +       };
> +       const char *prefix = "./";
> +       struct util_filter_ctx fctx = { 0 };
> +       struct monitor_filter_arg mfa = { 0 };
> +
> +       argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
> +       for (i = 0; i < argc; i++) {
> +               error("unknown parameter \"%s\"\n", argv[i]);
> +       }
> +       if (argc)
> +               usage_with_options(u, options);
> +
> +       if (monitor.logfile && (strcmp(monitor.logfile, "./syslog") != 0))
> +               ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_file);
> +       else
> +               ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
> +       ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_NOTICE);
> +
> +       if (monitor.daemon) {
> +               if (daemon(0, 0) != 0) {
> +                       fail("daemon start failed\n");
> +                       goto out;
> +               }
> +               notice((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
> +       }
> +
> +       fctx.filter_bus = filter_bus;
> +       fctx.filter_dimm = filter_dimm;
> +       fctx.filter_region = filter_region;
> +       fctx.filter_namespace = NULL;
> +       fctx.arg = &mfa;
> +       list_head_init(&mfa.dimms);
> +       mfa.num_dimm = 0;
> +       mfa.maxfd_dimm = -1;
> +       mfa.flags = 0;
> +
> +       if (util_filter_walk(ctx, &fctx, &param))
> +               goto out;
> +
> +       if (!mfa.num_dimm) {
> +               fail("no dimms can be monitored\n");
> +               goto out;
> +       }
> +
> +       if (monitor_event(ctx, &mfa))
> +               goto out;
> +
> +       return 0;
> +out:
> +       return 1;
> +}
> diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
> index 7daadeb..73dabfa 100644
> --- a/ndctl/ndctl.c
> +++ b/ndctl/ndctl.c
> @@ -89,6 +89,7 @@ static struct cmd_struct commands[] = {
>         { "wait-scrub", cmd_wait_scrub },
>         { "start-scrub", cmd_start_scrub },
>         { "list", cmd_list },
> +       { "monitor", cmd_monitor},
>         { "help", cmd_help },
>         #ifdef ENABLE_TEST
>         { "test", cmd_test },
> --
> 2.17.1
>
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
