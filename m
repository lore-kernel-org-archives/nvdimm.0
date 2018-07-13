Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5BD2209831C7
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 11:58:30 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v12 1/5] ndctl, monitor: add a new command - monitor
Date: Fri, 13 Jul 2018 18:58:12 +0000
Message-ID: <1531508290.7574.138.camel@intel.com>
References: <20180713155403.30020-1-qi.fuli@jp.fujitsu.com>
 <20180713155403.30020-2-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180713155403.30020-2-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <BA300A0E00CD054099F7CB819F08B5E4@intel.com>
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

Hi Qi,

On Sat, 2018-07-14 at 00:53 +0900, QI Fuli wrote:
> Ndctl monitor is used for monitoring the smart events of NVDIMMs.
> When a smart event fires, monitor will output the notifications which
> include dimm health status and event information to syslog, standard
> output or a file by setting [--log] option. The notifications follow
> json format and can be consumed by log collectors like Fluentd.
> 
> The objects to monitor can be selected by setting [--dimm] [--region]
> [--namespace] [--bus] options and the event type can be filtered by
> setting [--dimm-event] option. These options support multiple
> space-separated arguments.
> 
> Ndctl monitor can be forked as a daemon by using [--daemon] option,
> such as:
>    # ndctl monitor --daemon --log /var/log/ndctl/monitor.log
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  builtin.h              |   1 +
>  ndctl/Makefile.am      |   3 +-
>  ndctl/lib/libndctl.c   |  82 +++++++
>  ndctl/lib/libndctl.sym |   4 +
>  ndctl/libndctl.h       |  10 +
>  ndctl/monitor.c        | 539 +++++++++++++++++++++++++++++++++++++++++
>  ndctl/ndctl.c          |   1 +
>  util/filter.h          |   9 +
>  8 files changed, 648 insertions(+), 1 deletion(-)
>  create mode 100644 ndctl/monitor.c
> 

[..]

> +
> +#define fail(fmt, ...) \
> +do { \
> +	did_fail = 1; \
> +	dbg(ctx, "ndctl-%s:%s:%d: " fmt, \
> +			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
> +} while (0)
> +
> +static void log_syslog(struct ndctl_ctx *ctx, int priority, const char *file,
> +		int line, const char *fn, const char *format, va_list args)
> +{
> +	char *buf;
> +
> +	if (vasprintf(&buf, format, args) < 0) {
> +		fail("vasprintf error\n");
> +		return;
> +	}
> +	syslog(priority, "%s\n", buf);

I think from each of the log functions, we should remove the '\n'.
Currently, this results in an extra newline for error messages like
unsupported dimms. For consistency, the newline is always added at the
'top level' when the string is being composed. All functions that pass
through or handle the string later shouldn't add newlines.

It is ok for the error messages in this function to have newlines, like
in the "vasprintf error" case.

> +
> +	free(buf);
> +	return;
> +}
> +
> +static void log_standard(struct ndctl_ctx *ctx, int priority, const char *file,
> +		int line, const char *fn, const char *format, va_list args)
> +{
> +	char *buf;
> +
> +	if (vasprintf(&buf, format, args) < 0) {
> +		fail("vasprintf error\n");
> +		return;
> +	}
> +
> +	if (priority == 6)
> +		fprintf(stdout, "%s\n", buf);
> +	else
> +		fprintf(stderr, "%s\n", buf);

Same as above for both fprintf statements.

> +
> +	free(buf);
> +	return;
> +}
> +
> +static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
> +		int line, const char *fn, const char *format, va_list args)
> +{
> +	FILE *f;
> +	char *buf;
> +
> +	if (vasprintf(&buf, format, args) < 0) {
> +		fail("vasprintf error\n");
> +		return;
> +	}
> +
> +	f = fopen(monitor.log, "a+");
> +	if (!f) {
> +		ndctl_set_log_fn(ctx, log_syslog);
> +		fail("open logfile %s failed\n%s", monitor.log, buf);
> +		goto end;
> +	}
> +	fprintf(f, "%s\n", buf);

Same as above.

> +	fflush(f);
> +	fclose(f);
> +end:
> +	free(buf);
> +	return;
> +}
> +

[..]

> +
> +static int notify_dimm_event(struct monitor_dimm *mdimm)
> +{
> +	struct json_object *jmsg, *jdimm, *jobj;
> +	struct timespec ts;
> +	char timestamp[32];
> +	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(mdimm->dimm);
> +
> +	jmsg = json_object_new_object();
> +	if (!jmsg) {
> +		fail("\n");
> +		return -1;
> +	}
> +
> +	clock_gettime(CLOCK_REALTIME, &ts);
> +	sprintf(timestamp, "%10ld.%09ld", ts.tv_sec, ts.tv_nsec);
> +	jobj = json_object_new_string(timestamp);
> +	if (!jobj) {
> +		fail("\n");
> +		return -1;
> +	}
> +	json_object_object_add(jmsg, "timestamp", jobj);
> +
> +	jobj = json_object_new_int(getpid());
> +	if (!jobj) {
> +		fail("\n");
> +		return -1;
> +	}
> +	json_object_object_add(jmsg, "pid", jobj);
> +
> +	jobj = dimm_event_to_json(mdimm);
> +	if (!jobj) {
> +		fail("\n");
> +		return -1;
> +	}
> +	json_object_object_add(jmsg, "event", jobj);
> +
> +	jdimm = util_dimm_to_json(mdimm->dimm, 0);
> +	if (!jdimm) {
> +		fail("\n");
> +		return -1;
> +	}
> +	json_object_object_add(jmsg, "dimm", jdimm);
> +
> +	jobj = util_dimm_health_to_json(mdimm->dimm);
> +	if (!jobj) {
> +		fail("\n");
> +		return -1;
> +	}
> +	json_object_object_add(jdimm, "health", jobj);
> +
> +	if (monitor.human)
> +		notice(ctx, "%s", json_object_to_json_string_ext(jmsg,
> +						JSON_C_TO_STRING_PRETTY));
> +	else
> +		notice(ctx, "%s", json_object_to_json_string_ext(jmsg,
> +						JSON_C_TO_STRING_PLAIN));

And since the log functions no longer add newlines, these notice()
strings should have a newline.

> +
> +	free(jobj);
> +	free(jdimm);
> +	free(jmsg);
> +	return 0;
> +}
> +

[..]

> +int cmd_monitor(int argc, const char **argv, void *ctx)
> +{
> +	const struct option options[] = {
> +		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
> +		OPT_STRING('r', "region", &param.region, "region-id",
> +				"filter by region"),
> +		OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
> +				"filter by dimm"),
> +		OPT_STRING('n', "namespace", &param.namespace,
> +				"namespace-id", "filter by namespace id"),
> +		OPT_STRING('D', "dimm-event", &monitor.dimm_event,
> +			"name of event type", "filter by DIMM event type"),
> +		OPT_FILENAME('l', "log", &monitor.log,
> +				"<file> | syslog | standard",
> +				"where to output the monitor's notification"),
> +		OPT_BOOLEAN('x', "daemon", &monitor.daemon,
> +				"run ndctl monitor as a daemon"),
> +		OPT_BOOLEAN('u', "human", &monitor.human,
> +				"use human friendly output formats"),
> +		OPT_END(),
> +	};
> +	const char * const u[] = {
> +		"ndctl monitor [<options>]",
> +		NULL
> +	};
> +	const char *prefix = "./";
> +	struct util_filter_ctx fctx = { 0 };
> +	struct monitor_filter_arg mfa = { 0 };
> +	int i;
> +
> +	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
> +	for (i = 0; i < argc; i++) {
> +		error("unknown parameter \"%s\"\n", argv[i]);
> +	}
> +	if (argc)
> +		usage_with_options(u, options);
> +
> +	ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_standard);
> +	ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_NOTICE);
> +
> +	if (monitor.log) {

I think you were trying to special case the option of ./syslog and
./standard so that they are treated as files (but I'm not sure that's
needed?)

> +		if (strcmp(monitor.log, "./syslog") == 0)
> +			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);

I think this is broken as we need 'syslog' to select log_syslog, and
not './syslog'

> +		else if (strcmp(monitor.log, "./standard") != 0)
> +			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_file);

I think the flow we want here is:

	/* default to log_standard */
	ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_standard);
	ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_NOTICE);

	if (monitor.log) {
		/*
		 * we have to add a './' prefix to the comparisons
		 * as fix_filename adds it to monitor.log for us
		 */
		if (strncmp(monitor.log, "./syslog", 8) == 0)
			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
		else if (strncmp(monitor.log, "./standard", 10) == 0)
			; /* default, already set */
		else
			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_file);
	}

The final log_file case should be a catch-all for anything supplied
that is not exactly 'syslog' or 'standard'. Note that I used strncmp
instead of strcmp to match exactly.

This does mean that if someone supplies "./syslog" intending to write
to a file called syslog in the current directory, it will instead log
to syslog. But I think that is fine, it can be documented as  a quirk
of the option parsing code (parse_options_prefix adds the './' prefix
via fix_filename for OPTION_FILENAME). If they do want a file called
'syslog' or 'standard' they can specify it as an absolute path
(starting with '/'), and fix_filename won't touch it.

> +	}
> +
> +	if (monitor.daemon) {
> +		if (daemon(0, 0) != 0) {
> +			err((struct ndctl_ctx *)ctx, "daemon start failed\n");
> +			goto out;
> +		}
> +		notice((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
> +	}
> +
> +	if (parse_monitor_event(&monitor))
> +		goto out;
> +
> +	fctx.filter_bus = filter_bus;
> +	fctx.filter_dimm = filter_dimm;
> +	fctx.filter_region = filter_region;
> +	fctx.filter_namespace = NULL;
> +	fctx.arg = &mfa;
> +	list_head_init(&mfa.dimms);
> +	mfa.num_dimm = 0;
> +	mfa.maxfd_dimm = -1;
> +	mfa.flags = 0;
> +
> +	if (util_filter_walk(ctx, &fctx, &param))
> +		goto out;
> +
> +	if (!mfa.num_dimm) {
> +		err((struct ndctl_ctx *)ctx, "no dimms to monitor\n");
> +		goto out;
> +	}
> +
> +	if (monitor_event(ctx, &mfa))
> +		goto out;
> +
> +	return 0;
> +out:
> +	return 1;
> +}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
