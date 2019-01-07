Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E20C9211AD36A
 for <linux-nvdimm@lists.01.org>; Mon,  7 Jan 2019 14:02:07 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2 2/2] ndctl, monitor: refactor read_config_file
Date: Mon, 7 Jan 2019 22:02:05 +0000
Message-ID: <36bf7c7710c583cfb91d7c80f2f9aee8993d1b52.camel@intel.com>
References: <20190107083833.25941-1-qi.fuli@jp.fujitsu.com>
 <20190107083833.25941-3-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20190107083833.25941-3-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <4657E3A0BEA7E748A94F756AAEB4156D@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>


On Mon, 2019-01-07 at 17:38 +0900, QI Fuli wrote:
> This patch is used for refactoring read_config_file by replacing the
> open coded implementation with ccan/ciniparser library.
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  ndctl/Makefile.am  |   1 +
>  ndctl/monitor.c    | 115 ++++++++++++---------------------------------
>  ndctl/monitor.conf |   2 +
>  3 files changed, 32 insertions(+), 86 deletions(-)
> 
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index ff01e06..2f00b65 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -28,6 +28,7 @@ ndctl_LDADD =\
>  	lib/libndctl.la \
>  	../daxctl/lib/libdaxctl.la \
>  	../libutil.a \
> +	../libccan.a \
>  	$(UUID_LIBS) \
>  	$(KMOD_LIBS) \
>  	$(JSON_LIBS)
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 233f2bb..8499fd4 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c

[..]

> +	dictionary *dic;
> +
> +	dic = ciniparser_load(config_file);
> +	if (!dic)
> +		return -errno;
> +
> +	parse_config(&param.bus,
> +			ciniparser_getstring(dic, "monitor:bus", NULL));
> +	parse_config(&param.dimm,
> +			ciniparser_getstring(dic, "monitor:dimm", NULL));
> +	parse_config(&param.region,
> +			ciniparser_getstring(dic, "monitor:region", NULL));
> +	parse_config(&param.namespace,
> +			ciniparser_getstring(dic, "monitor:namespace", NULL));
> +	parse_config(&monitor.dimm_event,
> +			ciniparser_getstring(dic, "monitor:dimm-event", NULL));

Since the default return is always NULL in the above calls, we can use
the more concise form, ciniparser_getstr() -

	#define ciniparser_getstr(d, k)  ciniparser_getstring(d, k, NULL)


> +	if (monitor.log)
>  		goto out;

[..]
 
> diff --git a/ndctl/monitor.conf b/ndctl/monitor.conf
> index 934e2c0..edcf8e2 100644
> --- a/ndctl/monitor.conf
> +++ b/ndctl/monitor.conf
> @@ -9,6 +9,8 @@
>  # Multiple space-separated values are allowed, but except the following
>  # characters: : ? / \ % " ' $ & ! * { } [ ] ( ) = < > @

Is this character restriction still true?

>  
> +[monitor]
> +
>  # The objects to monitor are filtered via dimm's name by setting key "dimm".
>  # If this value is different from the value of [--dimm=<value>] option,
>  # both of the values will work.

With Dan's recent reworks changing the build-time define to reflect an
'ndctl-wide' config, and with the introduction of ini style sections, I
think this change merits a little more thought.

The addition of the [monitor] section breaks any existing configs -
which is fine, I don't expect we will break thousands, or even tens, of
existing deployments out in the wild :)

That being said, if we are breaking old config files, we can take this
chance to rethink and restructure configuration a bit. Here is my
proposal.

- Rename monitor.conf to ndctl.conf, it will be a global ndctl-wide
config file that all commands can refer to.

- Define sections only for command-specific options, but have a [core]
section for options that apply to several different commands. For
example core:region and core:bus will specify the region and bus to
always operate on by default. In contrast, monitor:dimm-event and
monitor:log will be in the [monitor] section, and will always be
monitor specific.

- You can still have multiple monitor processes started each using a
distinct config. The way this can work is that the 'global' ndctl
config file will be read first, and will always apply (default
/etc/ndctl/ndctl.conf, configurable at compile time). Any 'local'
config supplied using the config-file option to monitor will override
any field that it changes over the global config. This way the local
configs for monitor don't need to duplicate any truly common core
information (say bus, for example), but still have the option to
override them if needed. This follows the user experience git provides
with ~/.gitconfig vs. repo local config.

- Existing commands can then be taught to respect the core config
options, and even grow their own specific sections, but all that can be
part of a longer term effort. Putting in the foundations for that now
can allow us to convert individual commands as needed. For now monitor
will be the first and only user of this override hierarchy. I suspect
there will be some refactoring of option parsing in different commands,
but we probably shouldn't attempt that until a second user of the
config framework shows up, and then it is their responsibility :)

With the 5.0-rc1 kernel out, we're overdue for an ndctl-64 release, I
should be able to do that this week, but I'm thinking with the wider
config reworks, this is really a ndctl-65 item.


Thanks,
	-Vishal

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
