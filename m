Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3396D21B02845
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 14:32:29 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v12 2/5] ndctl, monitor: add main ndctl monitor
 configuration file
Date: Fri, 13 Jul 2018 21:32:16 +0000
Message-ID: <1531517533.7574.152.camel@intel.com>
References: <20180713155403.30020-1-qi.fuli@jp.fujitsu.com>
 <20180713155403.30020-3-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180713155403.30020-3-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <57C19919247DD841B422BA42A3D31673@intel.com>
MIME-Version: 1.0
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Cc: "tokunaga.keiich@jp.fujitsu.com" <tokunaga.keiich@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Sat, 2018-07-14 at 00:54 +0900, QI Fuli wrote:
> This patch adds the main configuration file(/etc/ndctl/monitor.conf)
> of ndctl monitor. It contains the configuration directives that give
> ndctl monitor instructions. Users can change the configuration by
> editing this file or using [--config-file] option to override this
> file. The changed value will work after restart ndctl monitor service.
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  ndctl.spec.in      |   1 +
>  ndctl/Makefile.am  |   5 +++
>  ndctl/monitor.c    | 110 +++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/monitor.conf |  41 +++++++++++++++++
>  4 files changed, 157 insertions(+)
>  create mode 100644 ndctl/monitor.conf
> 
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index e2c879c..42760fa 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -141,6 +141,7 @@ make check
>  %{_includedir}/ndctl/
>  %{_libdir}/libndctl.so
>  %{_libdir}/pkgconfig/libndctl.pc
> +%{_sysconfdir}/ndctl/monitor.conf
>  
>  %files -n DAX_DNAME
>  %defattr(-,root,root)
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index 083609a..4d0cccc 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -42,3 +42,8 @@ ndctl_SOURCES += ../test/libndctl.c \
>  		 ../test/core.c \
>  		 test.c
>  endif
> +
> +monitor_config_file = monitor.conf
> +monitor_configdir = /etc/ndctl/

This path can't be hard coded - we need to pass it in from autoconf via
a variable. Also see below in monitor.c.

> +monitor_config_DATA = $(monitor_config_file)
> +EXTRA_DIST += $(monitor_config_file)
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index caf8c3d..0b0f8f8 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -19,6 +19,7 @@
>  
>  static struct monitor {
>  	const char *log;
> +	const char *config_file;
>  	const char *dimm_event;
>  	bool daemon;
>  	bool human;
> @@ -454,6 +455,109 @@ dimm_event_all:
>  	return 0;
>  }
>  
> +static void parse_config(const char **arg, char *key, char *val, char *ident)
> +{
> +	struct strbuf value = STRBUF_INIT;
> +	size_t arg_len = *arg ? strlen(*arg) : 0;
> +
> +	if (!ident || !key || (strcmp(ident, key) != 0))
> +		return;
> +
> +	if (arg_len) {
> +		strbuf_add(&value, *arg, arg_len);
> +		strbuf_addstr(&value, " ");
> +	}
> +	strbuf_addstr(&value, val);
> +	*arg = strbuf_detach(&value, NULL);
> +}
> +
> +static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
> +		struct util_filter_params *_param)
> +{
> +	FILE *f;
> +	int line = 0;
> +	size_t len = 0;
> +	char *buf, *value, *config_file;
> +	const char *def_config_file = "/etc/ndctl/monitor.conf";

Here too, the path needs to come via the same autoconf define as above.

> +
> +	if (_monitor->config_file)
> +		config_file = strdup(_monitor->config_file);
> +	else
> +		config_file = strdup(def_config_file);
> +	if (!config_file) {
> +		fail("strdup default config file failed\n");
> +		goto out;
> +	}
> +
> +	buf = malloc(BUF_SIZE);
> +	if (!buf) {
> +		fail("malloc read config-file buf error\n");
> +		goto out;
> +	}
> +
> +	f = fopen(config_file, "r");
> +	if (!f) {
> +		fail("config-file: %s cannot be opened\n", config_file);
> +		goto out;
> +	}
> +
> +	while (fgets(buf, BUF_SIZE, f)) {
> +		value = NULL;
> +		line++;
> +
> +		while (isspace(*buf))
> +			buf++;
> +
> +		if (*buf == '#' || *buf == '\0')
> +			continue;
> +
> +		value = strchr(buf, '=');
> +		if (!value) {
> +			fail("config-file syntax error, skip line[%i]\n", line);
> +			continue;
> +		}
> +
> +		value[0] = '\0';
> +		value++;
> +
> +		while (isspace(value[0]))
> +			value++;
> +
> +		len = strlen(buf);
> +		if (len == 0)
> +			continue;
> +		while (isspace(buf[len-1]))
> +			len--;
> +		buf[len] = '\0';
> +
> +		len = strlen(value);
> +		if (len == 0)
> +			continue;
> +		while (isspace(value[len-1]))
> +			len--;
> +		value[len] = '\0';
> +
> +		if (len == 0)
> +			continue;
> +
> +		parse_config(&_param->bus, "bus", value, buf);
> +		parse_config(&_param->dimm, "dimm", value, buf);
> +		parse_config(&_param->region, "region", value, buf);
> +		parse_config(&_param->namespace, "namespace", value, buf);
> +		parse_config(&_monitor->dimm_event, "dimm-event", value, buf);
> +
> +		if (!_monitor->log)
> +			parse_config(&_monitor->log, "log", value, buf);
> +	}
> +	fclose(f);
> +	free(config_file);
> +	return 0;
> +out:
> +	if (config_file)
> +		free(config_file);
> +	return 1;
> +}
> +
>  int cmd_monitor(int argc, const char **argv, void *ctx)
>  {
>  	const struct option options[] = {
> @@ -469,6 +573,8 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  		OPT_FILENAME('l', "log", &monitor.log,
>  				"<file> | syslog | standard",
>  				"where to output the monitor's notification"),
> +		OPT_FILENAME('c', "config-file", &monitor.config_file,
> +				"config-file", "override the default config"),
>  		OPT_BOOLEAN('x', "daemon", &monitor.daemon,
>  				"run ndctl monitor as a daemon"),
>  		OPT_BOOLEAN('u', "human", &monitor.human,
> @@ -494,7 +600,11 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  	ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_standard);
>  	ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_NOTICE);
>  
> +	if (read_config_file((struct ndctl_ctx *)ctx, &monitor, &param))
> +		goto out;
> +
>  	if (monitor.log) {
> +		fix_filename(prefix, (const char **)&monitor.log);
>  		if (strcmp(monitor.log, "./syslog") == 0)
>  			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
>  		else if (strcmp(monitor.log, "./standard") != 0)
> diff --git a/ndctl/monitor.conf b/ndctl/monitor.conf
> new file mode 100644
> index 0000000..857aadf
> --- /dev/null
> +++ b/ndctl/monitor.conf
> @@ -0,0 +1,41 @@
> +# This is the main ndctl monitor configuration file. It contains the
> +# configuration directives that give ndctl monitor instructions.
> +# You can change the configuration of ndctl monitor by editing this
> +# file or using [--config-file=<file>] option to override this one.
> +# The changed value will work after restart ndctl monitor service.
> +
> +# In this file, lines starting with a hash (#) are comments.
> +# The configurations should follow <key> = <value> style.
> +# Multiple space-separated values are allowed, but except the following
> +# characters: : ? / \ % " ' $ & ! * { } [ ] ( ) = < > @
> +
> +# The objects to monitor are filtered via dimm's name by setting key "dimm".
> +# If this value is different from the value of [--dimm=<value>] option,
> +# both of the values will work.
> +# dimm = all
> +
> +# The objects to monitor are filtered via its parent bus by setting key "bus".
> +# If this value is different from the value of [--bus=<value>] option,
> +# both of the values will work.
> +# bus = all
> +
> +# The objects to monitor are filtered via region by setting key "region".
> +# If this value is different from the value of [--region=<value>] option,
> +# both of the values will work.
> +# region = all
> +
> +# The objects to monitor are filtered via namespace by setting key "namespace".
> +# If this value is different from the value of [--namespace=<value>] option,
> +# both of the values will work.
> +# namespace = all
> +
> +# The DIMM events to monitor are filtered via event type by setting key
> +# "dimm-event". If this value is different from the value of
> +# [--dimm-event=<value>] option, both of the values will work.
> +# dimm-event = all
> +
> +# Users can choose to output the notifications to syslog (log=syslog),
> +# to standard output (log=standard) or to write into a special file (log=<file>)
> +# by setting key "log". If this value is in conflict with the value of
> +# [--log=<value>] option, this value will be ignored.
> +# log = /var/log/ndctl/monitor.log
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
