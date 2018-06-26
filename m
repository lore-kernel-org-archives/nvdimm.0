Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x244.google.com (mail-ot0-x244.google.com
 [IPv6:2607:f8b0:4003:c0f::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6A8EB211F8871
 for <linux-nvdimm@lists.01.org>; Mon, 25 Jun 2018 21:43:08 -0700 (PDT)
Received: by mail-ot0-x244.google.com with SMTP id 92-v6so17599496otw.9
 for <linux-nvdimm@lists.01.org>; Mon, 25 Jun 2018 21:43:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180618082701.12326-3-qi.fuli@jp.fujitsu.com>
References: <20180618082701.12326-1-qi.fuli@jp.fujitsu.com>
 <20180618082701.12326-3-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Jun 2018 21:43:06 -0700
Message-ID: <CAPcyv4jwgsVxTFB5OdfUetcJ5xzLwM0=GCxn3E_ODYA8uHBMgA@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] ndctl, monitor: add main ndctl monitor
 configuration file
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

On Mon, Jun 18, 2018 at 1:27 AM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> This patch adds the main configuration file(/etc/ndctl/monitor.conf)
> of ndctl monitor. It contains the configuration directives that give
> ndctl monitor instructions. Users can change the configuration by
> editing this file or by using [--config-file=<file>] option to
> override this file. The changed value will work after resetart ndctl
> monitor service.

The monitor should also re-read the configuration file on SIGHUP. That
can be added in a follow-on patch.

>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  ndctl/Makefile.am  |   5 ++
>  ndctl/monitor.c    | 115 +++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/monitor.conf |  42 +++++++++++++++++
>  3 files changed, 162 insertions(+)
>  create mode 100644 ndctl/monitor.conf
>
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index 7dbf223..ae3d894 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -42,3 +42,8 @@ ndctl_SOURCES += ../test/libndctl.c \
>                  ../test/multi-pmem.c \
>                  ../test/core.c
>  endif
> +
> +monitor_config_file = monitor.conf
> +monitor_configdir = /etc/ndctl/
> +monitor_config_DATA = $(monitor_config_file)
> +EXTRA_DIST += $(monitor_config_file)
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 12aa499..8ac20ac 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -31,6 +31,7 @@ static enum log_destination {
>
>  static struct {
>         const char *logfile;
> +       const char *config_file;
>         const char *dimm_event;
>         bool daemon;
>  } monitor;
> @@ -71,6 +72,19 @@ static bool is_dir(char *filepath)
>         return false;
>  }
>
> +static void set_config(const char **arg, char *val)
> +{
> +       struct strbuf value = STRBUF_INIT;
> +       size_t arg_len = *arg ? strlen(*arg) : 0;
> +
> +       if (arg_len) {
> +               strbuf_add(&value, *arg, arg_len);
> +               strbuf_addstr(&value, " ");
> +       }
> +       strbuf_addstr(&value, val);
> +       *arg = strbuf_detach(&value, NULL);
> +}
> +
>  static void logreport(struct ndctl_ctx *ctx, int priority, const char *file,
>                 int line, const char *fn, const char *format, va_list args)
>  {
> @@ -449,6 +463,102 @@ out:
>         return 1;
>  }
>
> +static int read_config_file(struct ndctl_ctx *ctx, const char *prefix)
> +{

I think we should have this routine take a pointer to the 'param' and
'monitor' structures so that it is clear that it is initializing the
same parameters as the command line args. This also allows this
function to potentially be moved to a new source in the future.

> +       FILE *f;
> +       int line = 0;
> +       size_t len = 0;
> +       char *buf, *value;
> +       char *config_file = "/etc/ndctl/monitor.conf";
> +
> +       buf = (char *)malloc(BUF_SIZE);

Unnecessary (char *) cast.

> +       if (!buf) {
> +               fail("malloc read config-file buf error\n");
> +               goto out;
> +       }
> +       if (monitor.config_file) {
> +               fix_filename(prefix, (const char **)&monitor.config_file);
> +               config_file = (char *)monitor.config_file;
> +       }
> +
> +       f = fopen(config_file, "r");
> +       if (!f) {
> +               fail("config-file: %s cannot be opened\n", config_file);
> +               goto out;
> +       }
> +
> +       while (fgets(buf, BUF_SIZE, f)) {
> +               value = NULL;
> +               line++;
> +
> +               while (isspace(*buf))
> +                       buf++;
> +
> +               if (*buf == '#' || *buf == '\0')
> +                       continue;
> +
> +               value = strchr(buf, '=');
> +               if (!value) {
> +                       fail("config-file syntax error, skip line[%i]\n", line);
> +                       continue;
> +               }
> +
> +               value[0] = '\0';
> +               value++;
> +
> +               while (isspace(value[0]))
> +                       value++;
> +
> +               len = strlen(buf);
> +               if (len == 0)
> +                       continue;
> +               while (isspace(buf[len-1]))
> +                       len--;
> +               buf[len] = '\0';
> +
> +               len = strlen(value);
> +               if (len == 0)
> +                       continue;
> +               while (isspace(value[len-1]))
> +                       len--;
> +               value[len] = '\0';
> +
> +               if (len == 0)
> +                       continue;
> +
> +               if (strcmp(buf, "bus") == 0) {
> +                       set_config((const char **)&param.bus, value);

The cast is unnecessary, and I think we can clean this up further by
having the helper do the strcmp() and return the value. Something
like:

param.bus = parse_config("bus", value);

> +                       continue;
> +               }
> +               if (strcmp(buf, "dimm") == 0) {
> +                       set_config((const char **)&param.dimm, value);
> +                       continue;
> +               }
> +               if (strcmp(buf, "region") == 0) {
> +                       set_config((const char **)&param.region, value);
> +                       continue;
> +               }
> +               if (strcmp(buf, "namespace") == 0) {
> +                       set_config((const char **)&param.namespace, value);
> +                       continue;
> +               }
> +               if (strcmp(buf, "dimm-event") == 0) {
> +                       set_config((const char **)&monitor.dimm_event, value);
> +                       continue;
> +               }
> +               if (strcmp(buf, "logfile") == 0) {
> +                       if (monitor.logfile)
> +                               continue;
> +                       set_config((const char **)&monitor.logfile, value);
> +                       fix_filename(prefix, (const char **)&monitor.logfile);
> +               }
> +       }
> +       fclose(f);
> +       return 0;
> +out:
> +       return 1;
> +}
> +
>  int cmd_monitor(int argc, const char **argv, void *ctx)
>  {
>         int i;
> @@ -463,6 +573,8 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>                 OPT_FILENAME('l', "logfile", &monitor.logfile,
>                                 "file | syslog | stderr",
>                                 "where to output the monitor's notification"),
> +               OPT_FILENAME('c', "config-file", &monitor.config_file,
> +                               "config-file", "override the default config"),
>                 OPT_BOOLEAN('f', "daemon", &monitor.daemon,
>                                 "run ndctl monitor as a daemon"),
>                 OPT_STRING('D', "dimm-event", &monitor.dimm_event,
> @@ -488,6 +600,9 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>         ndctl_set_log_fn((struct ndctl_ctx *)ctx, logreport);
>         ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_INFO);
>
> +       if (read_config_file((struct ndctl_ctx *)ctx, prefix))
> +               goto out;
> +
>         if (monitor.logfile) {
>                 if (strcmp(monitor.logfile, "./stderr") == 0)
>                         log_destination = LOG_DESTINATION_STDERR;
> diff --git a/ndctl/monitor.conf b/ndctl/monitor.conf
> new file mode 100644
> index 0000000..590f1c4
> --- /dev/null
> +++ b/ndctl/monitor.conf
> @@ -0,0 +1,42 @@
> +# This is the main ndctl monitor configuration file. It contains the
> +# configuration directives that give ndctl monitor instructions.
> +# You can change the configuration of ndctl monitor by editing this
> +# file or by using [--config-file=<file>] option to override this one.
> +# The changed value will work after restart ndctl monitor service.
> +
> +# In this file, lines starting with a hash (#) are comments.
> +# The configurations shold follow <key> = <value> style.

*should

> +# Multiple space-seperated values are allowed, but except the following

*space-separated

> +# charecters: : # ? / \ % " '

*characters

Also, # is allowed, but as a comment character.

> +
> +# The dimms to monitor are filtered via dimm's name by setting key "dimm".
> +# If this value is different from the value of [--dimm=<value>] option,
> +# both of the values will work.
> +# dimm = all
> +
> +# The dimms to monitor are filtered via its parent bus by setting key "bus".
> +# If this value is different from the value of [--bus=<value>] option,
> +# both of the values will work.
> +# bus = all
> +
> +# The dimms to monitor are filtered via region by setting key "region".
> +# If this value is different from the value of [--region=<value>] option,
> +# both of the values will work.
> +# region = all
> +
> +# The dimms to monitor are filtered via namespace by setting key "namespace".
> +# If this value is different from the value of [--namespace=<value>] option,
> +# both of the values will work.
> +# namespace = all

In all of the above I think you should change "The dimms to monitor"
to "The objects to monitor", because we will monitor more than DIMMs
in the future.

> +
> +# The DIMM events to monitor are filtered via event type by setting key
> +# "dimm-event". If this value is different from the value of
> +# [--dimm-event=<value>] option, both of the values will work.
> +# dimm-event = all
> +
> +# Users can choose to output the notifications to syslog (logfile=syslog),
> +# stderr (logfile=stderr) or to write into a special file (logfile=<file>)
> +# by setting key "logfile".
> +# If this value is in conflict with the value of [--logfile=<value>] option,
> +# this value will be ignored.
> +# logfile = /var/log/ndctl/monitor.log
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
