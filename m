Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3390B2202E4AD
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 11:13:13 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id e9so3528898oii.0
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 11:19:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180313113308.2136-1-qi.fuli@jp.fujitsu.com>
References: <20180313113308.2136-1-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Mar 2018 11:19:35 -0700
Message-ID: <CAPcyv4jPghKyQ6AuVJ-R=fiKcQufzHs-DExzcyHTbshF-2bq1Q@mail.gmail.com>
Subject: Re: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
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

On Tue, Mar 13, 2018 at 4:33 AM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> This is the v4 patch for ndctl monitor daemon, a tiny daemon to monitor the
> smart events of nvdimm DIMMs. Users can run a monitor as a one-shot command
> or a daemon in background by using the [--daemon] option. DIMMs to monitor
> can be selected by [--dimm] [--bus] [--region] [--namespace] options.
> When a smart event fires, monitor daemon will log the notification which
> including dimm health status to syslog or a logfile by setting [--log] option.
> The notification follows json format and can be consumed by log collectors
> like Fluented.
>
> For example, a monitor daemon can be started by the following command:
> # ndctl monitor --dimm nmem1 --log /var/log/monitor.log --daemon daemon-name
>
> Then check the monitor daemon status by using systemd:
> # systemctl status ndctl-monitor@daemon-name.service
>
> To stop the monitor daemon by:
> # systemctl stop ndctl-monitor@daemon-name.service
>
> Also, a monitor daemon can be started by systemd:
> # systemctl start ndctl-monitor.service
> Which monitors all dimms.
>
> In this implemention, when a ndctl monitor starts with [--daemon] option, all
> the arguments will be saved into a temp file named as daemon-name and placed
> under /etc/sysconfig/ndctl/ directory. The temp file would be used as an
> EnvironmentFile by systemd, and it would be deleted automatically when the
> systemd service is stopped.

The monitors started by hand should be kept separate from the monitors
started by systemd. The default monitor started by systemd should get
its configuration from /etc/ndctl.conf, and we should otherwise have a
--conf-file option to the monitor to override the default
configuration. Any other monitors started outside of the systemd
should remain independent.

> Due to the deletion the following commands will not work.
> # systemctl enable ndctl-monitor@daemon-name.service
> # systemctl restart ndctl-monitor@daemon-name.service
>
> I am not sure whether these commands are needed for ndctl monitor daemon,
> your comments will be appreciated.

Both those commands are needed.

>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
>
> Change log since v3:
>  - Removing create-monitor, show-monitor, list-monitor, destroy-monitor
>  - Adding [--daemon] option to run ndctl monitor as a daemon
>  - Using systemd to manage ndctl monitor daemon
>  - Replacing filter_monitor_dimm() with filter_dimm()
>
> Change log since v2:
>  - Changing the interface of daemon to the ndctl command line
>  - Changing the name of daemon form "nvdimmd" to "monitor"
>  - Removing the config file, unit_file, nvdimmd dir
>  - Removing nvdimmd_test program
>  - Adding ndctl/monitor.c
>
> Change log since v1:
>  - Adding a config file(/etc/nvdimmd/nvdimmd.conf)
>  - Using struct log_ctx instead of syslog()
>     - Using log_syslog() to save the notify messages to syslog
>     - Using log_file() to save the notify messages to special file
>  - Adding LOG_NOTICE level to log_priority
>  - Using automake instead of Makefile
>  - Adding a new util file(nvdimmd/util.c) including helper functions
>    needed for nvdimm daemon
>  - Adding nvdimmd_test program
>
> ---
>  builtin.h                    |   1 +
>  ndctl/Makefile.am            |  13 +-
>  ndctl/monitor.c              | 411 +++++++++++++++++++++++++++++++++++++++++++
>  ndctl/ndctl-monitor.service  |   7 +
>  ndctl/ndctl-monitor@.service |   9 +
>  ndctl/ndctl.c                |   1 +
>  util/filter.c                |   5 +-
>  util/filter.h                |   3 +
>  util/parse-options.h         |   1 +
>  9 files changed, 448 insertions(+), 3 deletions(-)
>  create mode 100644 ndctl/monitor.c
>  create mode 100644 ndctl/ndctl-monitor.service
>  create mode 100644 ndctl/ndctl-monitor@.service
>
> diff --git a/builtin.h b/builtin.h
> index b24fc99..4b908f0 100644
> --- a/builtin.h
> +++ b/builtin.h
> @@ -36,6 +36,7 @@ int cmd_write_labels(int argc, const char **argv, void *ctx);
>  int cmd_init_labels(int argc, const char **argv, void *ctx);
>  int cmd_check_labels(int argc, const char **argv, void *ctx);
>  int cmd_inject_error(int argc, const char **argv, void *ctx);
> +int cmd_monitor(int argc, const char **argv, void *ctx);
>  int cmd_list(int argc, const char **argv, void *ctx);
>  #ifdef ENABLE_TEST
>  int cmd_test(int argc, const char **argv, void *ctx);
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index e0db97b..e364ef9 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -16,7 +16,8 @@ ndctl_SOURCES = ndctl.c \
>                 util/json-firmware.c \
>                 inject-error.c \
>                 update.c \
> -               inject-smart.c
> +               inject-smart.c \
> +               monitor.c
>
>  if ENABLE_DESTRUCTIVE
>  ndctl_SOURCES += ../test/blk_namespaces.c \
> @@ -41,3 +42,13 @@ ndctl_SOURCES += ../test/libndctl.c \
>                  ../test/multi-pmem.c \
>                  ../test/core.c
>  endif
> +
> +unitfiles =\
> +       ndctl-monitor.service \
> +       ndctl-monitor@.service
> +
> +unitdir = /usr/lib/systemd/system/

This directory needs to be configurable as not all distributions are
guaranteed to put their unit files there.

See the "Installing systemd Service Files" section here:

    https://www.freedesktop.org/software/systemd/man/daemon.html

...for some sample code to have autotools probe for the proper directory.

> +
> +unit_DATA = $(unitfiles)
> +
> +EXTRA_DIST = $(unitfiles)
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> new file mode 100644
> index 0000000..2164f27
> --- /dev/null
> +++ b/ndctl/monitor.c
> @@ -0,0 +1,411 @@
> +/*
> + * Copyright (c) 2018, FUJITSU LIMITED. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU Lesser General Public License,
> + * version 2.1, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT ANY
> + * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
> + * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for
> + * more details.
> + */
> +#include <stdio.h>
> +#include <json-c/json.h>
> +#include <signal.h>
> +#include <libgen.h>
> +#include <dirent.h>
> +#include <util/parse-options.h>
> +#include <util/log.h>
> +#include <util/json.h>
> +#include <util/filter.h>
> +#include <ndctl/lib/private.h>
> +#include <ndctl/libndctl.h>
> +#include <sys/stat.h>
> +#define NUM_MAX_DIMM 1024
> +#define BUF_SIZE 4096
> +
> +struct monitor_dimm {
> +       struct ndctl_dimm *dimm;
> +       int health_eventfd;
> +       struct list_node list;
> +};
> +
> +struct monitor_filter_arg {
> +       struct list_head mdimm;
> +       int maxfd;
> +       fd_set fds;
> +       int num_dimm;
> +       unsigned long flags;
> +};
> +
> +struct util_filter_params param;
> +
> +static char *conf_dir = "/etc/sysconfig/ndctl/";
> +static char *def_log_dir = "/var/log/ndctl/";
> +
> +static char *concat(char *str1, char *str2)
> +{
> +       char *result = malloc(strlen(str1) + strlen(str2) + 1);
> +       strcpy(result, str1);
> +       strcat(result, str2);
> +       return result;
> +}
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
> +static int recur_mkdir(char *filepath, mode_t mode)
> +{
> +       char *p;
> +       char *buf = (char *)malloc(strlen(filepath) + 4);
> +
> +       strcpy(buf, filepath);
> +       for (p = strchr(buf + 1, '/'); p; p = strchr(p + 1, '/')) {
> +               *p = '\0';
> +               if (!is_dir(buf)) {
> +                       if (mkdir(buf, mode) < 0) {
> +                               free(buf);
> +                               return -1;
> +                       }
> +               }
> +               *p = '/';
> +       }
> +
> +       free(buf);
> +       return 0;
> +}
> +
> +static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
> +       int line, const char *fn, const char *format, va_list args)
> +{
> +       FILE *f;
> +       char *log_name, *log_dir, *buf;
> +       char *errmsg = (char *)malloc(BUF_SIZE);
> +       char *tail = "/";
> +
> +       log_dir = dirname(strdup(param.log));
> +       log_name = basename(strdup(param.log));
> +       if (strcmp(log_dir, ".") == 0)
> +               log_dir = def_log_dir;
> +       else
> +               log_dir = concat(log_dir, tail);
> +       if (log_dir[0] != '/')
> +               log_dir = concat(def_log_dir, log_dir);
> +       log_name = concat(log_dir, log_name);
> +
> +       if (!is_dir(log_dir)) {
> +               if (recur_mkdir(log_dir, 0744) != 0) {
> +                       sprintf(errmsg, "cannot create dir: %s", log_dir);
> +                       goto out;
> +               }
> +       }
> +
> +       f = fopen(log_name, "a+");
> +       if (!f) {
> +               sprintf(errmsg, "open %s failed", log_name);
> +               goto out;
> +       }
> +
> +       buf = (char *)malloc(BUF_SIZE);
> +       if (!buf) {
> +               sprintf(errmsg, "cannot get memory for log_file");
> +               goto out;
> +       }
> +       vsnprintf(buf, BUF_SIZE, format, args);
> +       fprintf(f, "%s\n", buf);
> +       free(buf);
> +       fclose(f);
> +       return;
> +out:
> +       syslog(LOG_ERR, "%s\n", errmsg);
> +       if (!param.fork)
> +               error("%s\n", errmsg);
> +       free(errmsg);
> +       exit(EXIT_FAILURE);
> +}
> +
> +static void log_syslog(struct ndctl_ctx *ctx, int priority, const char *file,
> +       int line, const char *fn, const char *format, va_list args)
> +{
> +       char *buf = (char *)malloc(BUF_SIZE);
> +       vsnprintf(buf, BUF_SIZE, format, args);
> +       syslog(priority, "%s", buf);
> +       free(buf);
> +}

This seems to be reinventing setting up a log file that I'm sure we
could borrow or link to...

ndctl borrows heavily from git, and git does logging in it's daemon.c,
I'd be happier if you copied that.

> +
> +#define fail(fmt, ...) \
> +do { \
> +       err(ctx, "ndctl-%s:%s:%d: " fmt, \
> +                               VERSION, __func__, __LINE__, ##__VA_ARGS__); \
> +       if (!param.fork) \
> +               fprintf(stderr, "ndctl-%s:%s:%d: " fmt, \
> +                               VERSION, __func__, __LINE__, ##__VA_ARGS__); \
> +} while (0)
> +
> +static int notify_json_msg(struct ndctl_ctx *ctx, struct ndctl_dimm *dimm)
> +{
> +       time_t c_time;
> +       char date[32];
> +       struct json_object *jmsg, *jdatetime, *jpid, *jdimm, *jhealth;
> +
> +       jmsg = json_object_new_object();
> +       if (!jmsg) {
> +               fail("\n");
> +               return -1;
> +       }
> +
> +       c_time = time(NULL);
> +       strftime(date, sizeof(date), "%Y-%m-%d %H:%M:%S", localtime(&c_time));

Is this a standard date format? I'd expect miliseconds since the epoch
or iso-8601 format?

> +       jdatetime = json_object_new_string(date);
> +       if (!jdatetime) {
> +               fail("\n");
> +               return -1;
> +       }
> +       json_object_object_add(jmsg, "datetime", jdatetime);
> +
> +       jpid = json_object_new_int((int)getpid());
> +       if (!jpid) {
> +               fail("\n");
> +               return -1;
> +       }
> +       json_object_object_add(jmsg, "pid", jpid);
> +
> +       jdimm = util_dimm_to_json(dimm, 0);
> +       if (!dimm) {
> +               fail("\n");
> +               return -1;
> +       }
> +       json_object_object_add(jmsg, "dimm", jdimm);
> +
> +       jhealth = util_dimm_health_to_json(dimm);
> +       if (!jhealth) {
> +               fail("\n");
> +               return -1;
> +       }
> +       json_object_object_add(jdimm, "health", jhealth);
> +
> +       notice(ctx, "%s",
> +               json_object_to_json_string_ext(jmsg, JSON_C_TO_STRING_PLAIN));
> +       if (!param.fork)
> +               printf("%s\n", json_object_to_json_string_ext(jmsg,
> +                               JSON_C_TO_STRING_PRETTY));
> +       return 0;
> +}
> +
> +static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *ctx)
> +{
> +       struct monitor_filter_arg *mfa = (struct monitor_filter_arg *)ctx->arg;
> +       int fd;
> +       char buf[BUF_SIZE];
> +
> +       if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD))
> +               return;
> +
> +       struct monitor_dimm *m_dimm = malloc(sizeof(*m_dimm));
> +       m_dimm->dimm = dimm;
> +       fd = ndctl_dimm_get_health_eventfd(dimm);
> +       pread(fd, buf, sizeof(buf), 0);
> +       m_dimm->health_eventfd = fd;
> +       list_add_tail(&mfa->mdimm, &m_dimm->list);
> +       FD_SET(fd, &mfa->fds);
> +       if (fd > mfa->maxfd)
> +               mfa->maxfd = fd;
> +       mfa->num_dimm++;
> +}
> +
> +static int monitor_smart_event(struct ndctl_ctx *ctx)
> +{
> +       struct util_filter_ctx fctx = { 0 };
> +       struct monitor_filter_arg mfa = { 0 };
> +       int rc;
> +       char buf[BUF_SIZE];
> +       char *errmsg = (char *)malloc(BUF_SIZE);
> +
> +       fctx.filter_dimm = filter_dimm;
> +       fctx.arg = &mfa;
> +       mfa.flags = 0;
> +       list_head_init(&mfa.mdimm);
> +       FD_ZERO(&mfa.fds);
> +
> +       rc = util_filter_walk(ctx, &fctx, &param);
> +       if (rc)
> +               goto out;
> +       if (mfa.num_dimm == 0) {
> +               errmsg = "no monitor dimms can be found";
> +               goto out;
> +       }
> +
> +       while(1){
> +               rc = select(mfa.maxfd + 1, NULL, NULL, &mfa.fds, NULL);
> +               if (rc < 1) {
> +                       errmsg = "select error";
> +                       if (rc == 0)
> +                               dbg(ctx, "select unexpected timeout\n");
> +                       else
> +                               dbg(ctx, "select %s\n", strerror(errno));
> +                       goto out;
> +               }
> +               struct monitor_dimm *m_dimm;
> +               list_for_each(&mfa.mdimm, m_dimm, list) {
> +                       if (!FD_ISSET(m_dimm->health_eventfd, &mfa.fds)) {
> +                               FD_SET(m_dimm->health_eventfd, &mfa.fds);
> +                               continue;
> +                       }
> +                       if (notify_json_msg(ctx, m_dimm->dimm) != 0)
> +                               goto out;
> +                       pread(m_dimm->health_eventfd, buf, sizeof(buf), 0);
> +               }
> +       }

This does not seem to be prepared to handle eventfds that are not
associated with DIMMs. I'd rather this was based on epoll so we can
directly recall the ndctl object when the event fires rather than
needing to loop through all the objects again and compare fds.

> +       return 0;
> +out:
> +       if (errmsg) {
> +               if (!param.fork)
> +                       error("%s\n", errmsg);
> +               err(ctx, "%s\n", errmsg);
> +       }
> +       return 1;
> +}
> +
> +static int create_confile(char *conf_path)
> +{
> +       FILE *f;
> +       char *buf;
> +
> +       if (!is_dir(conf_dir)) {
> +               if (recur_mkdir(conf_dir, 0744) != 0) {
> +                       error("cannot create dir: %s\n", conf_dir);
> +                       goto out;
> +               }
> +       }
> +
> +       f = fopen(conf_path, "w");
> +       if (!f) {
> +               error("open %s failed\n", conf_path);
> +               goto out;
> +       }
> +
> +       buf = (char *)malloc(BUF_SIZE);
> +       if (!buf) {
> +               error("cannot get memory for daemon config file\n");
> +               goto out;
> +       }
> +       strcpy(buf, "OPTIONS=-f");
> +       if (param.bus) {
> +               strcat(buf, " -b ");
> +               strcat(buf, param.bus);
> +       }
> +       if (param.dimm) {
> +               strcat(buf, " -d ");
> +               strcat(buf, param.dimm);
> +       }
> +       if (param.namespace) {
> +               strcat(buf, " -n ");
> +               strcat(buf, param.namespace);
> +       }
> +       if (param.region) {
> +               strcat(buf, " -r ");
> +               strcat(buf, param.region);
> +       }
> +       if (param.log) {
> +               strcat(buf, " -l ");
> +               strcat(buf, param.log);
> +       }
> +       fprintf(f, "%s", buf);
> +       fclose(f);
> +       free(buf);
> +       return 0;
> +out:
> +       return 1;
> +}

As mentioned earlier we shouldn't be creating a configuration file, it
should be using a pre-existing configuration file in the systemd case.

> +
> +static bool is_monitor_exist(void)
> +{
> +       char *conf_path = strdup(param.daemon);
> +       conf_path = concat(conf_dir, conf_path);
> +       FILE *f = fopen(conf_path, "r");
> +       if (f) {
> +               fclose(f);
> +               return true;
> +       }
> +       return false;
> +}
> +
> +int cmd_monitor(int argc, const char **argv, void *ctx)
> +{
> +       const struct option options[] = {
> +               OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
> +               OPT_STRING('r', "region", &param.region, "region-id",
> +                               "filter by region"),
> +               OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
> +                               "filter by dimm"),
> +               OPT_STRING('n', "namespace", &param.namespace,
> +                               "namespace-id", "filter by namespace id"),
> +               OPT_STRING('l', "log", &param.log, "log name",
> +                               "monitor logfile"),
> +               OPT_STRING('D',"daemon", &param.daemon, "daemon-name",
> +                               "run ndctl monitor as a daemon"),
> +               OPT_BOOLEAN_HID('f', &param.fork),
> +               OPT_END(),
> +       };
> +       const char * const u[] = {
> +               "ndctl monitor [<options>]",
> +               NULL
> +       };
> +       argc = parse_options(argc, argv, options, u, 0);
> +       for (int i = 0; i < argc; i++) {
> +               error("unknown parameter \"%s\"\n", argv[i]);
> +               goto out;
> +       }
> +       if (argc)
> +               usage_with_options(u, options);
> +
> +       if (param.daemon) {
> +               if (is_monitor_exist()) {
> +                       error("monitor %s is exist\n", param.daemon);
> +                       goto out;
> +               }
> +               char *conf_path = strdup(param.daemon);
> +               conf_path = concat(conf_dir, conf_path);
> +               if (create_confile(conf_path) != 0)
> +                       goto out;
> +               char *sys_cmd = (char *)malloc(BUF_SIZE);
> +               sprintf(sys_cmd, "systemctl start ndctl-monitor@%s.service",
> +                               param.daemon);
> +               if (system(sys_cmd) != 0) {
> +                       free(sys_cmd);
> +                       remove(conf_path);
> +                       goto out;
> +               }
> +               free(sys_cmd);
> +               return 0;
> +       }
> +
> +       if (param.fork) {
> +               if (daemon(0, 0) != 0) {
> +                       err((struct ndctl_ctx*)ctx, "daemon start failed\n");
> +                       goto out;
> +               }
> +       }
> +
> +       ndctl_set_log_priority((struct ndctl_ctx*)ctx, LOG_NOTICE);
> +
> +       if (!param.log || strcmp(param.log, "syslog") == 0)
> +               ndctl_set_log_fn((struct ndctl_ctx*)ctx, log_syslog);
> +       else
> +               ndctl_set_log_fn((struct ndctl_ctx*)ctx, log_file);
> +
> +       if (monitor_smart_event((struct ndctl_ctx*)ctx) != 0)
> +               goto out;
> +
> +       return 0;
> +out:
> +       return 1;
> +}
> diff --git a/ndctl/ndctl-monitor.service b/ndctl/ndctl-monitor.service
> new file mode 100644
> index 0000000..2f1417b
> --- /dev/null
> +++ b/ndctl/ndctl-monitor.service
> @@ -0,0 +1,7 @@
> +[Unit]
> +Description=Ndctl Monitor Daemon
> +
> +[Service]
> +Type=forking
> +ExecStart=/usr/bin/ndctl monitor -f
> +ExecStop=/usr/bin/kill ${MAINPID}
> diff --git a/ndctl/ndctl-monitor@.service b/ndctl/ndctl-monitor@.service
> new file mode 100644
> index 0000000..91c85d9
> --- /dev/null
> +++ b/ndctl/ndctl-monitor@.service
> @@ -0,0 +1,9 @@
> +[Unit]
> +Description=Ndctl Monitor Daemon
> +
> +[Service]
> +Type=forking
> +EnvironmentFile=/etc/sysconfig/ndctl/%i
> +ExecStart=/usr/bin/ndctl monitor $OPTIONS
> +ExecStop=/usr/bin/kill ${MAINPID}
> +ExecStopPost=/usr/bin/rm /etc/sysconfig/ndctl/%i
> diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
> index d3c6db1..8938621 100644
> --- a/ndctl/ndctl.c
> +++ b/ndctl/ndctl.c
> @@ -86,6 +86,7 @@ static struct cmd_struct commands[] = {
>         { "inject-error", cmd_inject_error },
>         { "update-firmware", cmd_update_firmware },
>         { "inject-smart", cmd_inject_smart },
> +       { "monitor", cmd_monitor },
>         { "list", cmd_list },
>         { "help", cmd_help },
>         #ifdef ENABLE_TEST
> diff --git a/util/filter.c b/util/filter.c
> index b0b7fdf..fba2197 100644
> --- a/util/filter.c
> +++ b/util/filter.c
> @@ -315,7 +315,7 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
>                                 || !util_bus_filter_by_namespace(bus, param->namespace))
>                         continue;
>
> -               if (!fctx->filter_bus(bus, fctx))
> +               if (fctx->filter_bus && !fctx->filter_bus(bus, fctx))
>                         continue;
>
>                 ndctl_dimm_foreach(bus, dimm) {
> @@ -345,7 +345,8 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
>                         if (type && ndctl_region_get_type(region) != type)
>                                 continue;
>
> -                       if (!fctx->filter_region(region, fctx))
> +                       if (fctx->filter_region &&
> +                                       !fctx->filter_region(region, fctx))

No, I don't agree with these change. The filter_bus() and
filter_region() callbacks are mandatory because, like list, you need
to be prepared to handle dimms underneath the bus, and namespaces
underneath a region.

>                                 continue;
>
>                         ndctl_namespace_foreach(region, ndns) {
> diff --git a/util/filter.h b/util/filter.h
> index aea5a71..82f3b0d 100644
> --- a/util/filter.h
> +++ b/util/filter.h
> @@ -77,6 +77,9 @@ struct util_filter_params {
>         const char *dimm;
>         const char *mode;
>         const char *namespace;
> +       const char *log;
> +       const char *daemon;
> +       bool fork;

'log', 'daemon', and 'fork' are not util_filter_params, those should
be kept local to monitor.c. This is similar to the --human option to
"ndctl list". That isn't passed to util_filter_walk() it's handled
locally in list.c.

>  };
>
>  struct ndctl_ctx;
> diff --git a/util/parse-options.h b/util/parse-options.h
> index 6fd6b24..2262c42 100644
> --- a/util/parse-options.h
> +++ b/util/parse-options.h
> @@ -123,6 +123,7 @@ struct option {
>  #define OPT_GROUP(h)                { .type = OPTION_GROUP, .help = (h) }
>  #define OPT_BIT(s, l, v, h, b)      { .type = OPTION_BIT, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h), .defval = (b) }
>  #define OPT_BOOLEAN(s, l, v, h)     { .type = OPTION_BOOLEAN, .short_name = (s), .long_name = (l), .value = check_vtype(v, bool *), .help = (h) }
> +#define OPT_BOOLEAN_HID(s, v)       { .type = OPTION_BOOLEAN, .short_name = (s), .value = check_vtype(v, bool *), .flags = PARSE_OPT_HIDDEN}

What is this for?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
