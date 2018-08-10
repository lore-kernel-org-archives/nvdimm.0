Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4980F21BADAB6
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 16:20:52 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl: Add reconfigure-namespace command
Date: Fri, 10 Aug 2018 23:20:24 +0000
Message-ID: <1533943222.6054.32.camel@intel.com>
References: <20180808224045.16667-1-keith.busch@intel.com>
In-Reply-To: <20180808224045.16667-1-keith.busch@intel.com>
Content-Language: en-US
Content-ID: <0F98BA92CDC7CB439C9DE3BE4ED5C2A4@intel.com>
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
To: "Busch, Keith" <keith.busch@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2018-08-08 at 16:40 -0600, Keith Busch wrote:
> Namespace reconfiguration was the only utility 'verb' in ndctl that
> did not have its own command. This patch provides a new command,
> "reconfigure-namespace <namespace>".
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  Documentation/ndctl/Makefile.am                    |   1 +
>  Documentation/ndctl/ndctl-create-namespace.txt     |   1 +
>  .../ndctl/ndctl-reconfigure-namespace.txt          | 199 +++++++++++++++++++++
>  builtin.h                                          |   1 +
>  ndctl/action.h                                     |   1 +
>  ndctl/namespace.c                                  |  44 +++++
>  ndctl/ndctl.c                                      |   1 +
>  7 files changed, 248 insertions(+)
>  create mode 100644 Documentation/ndctl/ndctl-reconfigure-namespace.txt

This mostly looks good, just a couple of cleanup items below -

> 
> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> index a30b139..d1ec67c 100644
> --- a/Documentation/ndctl/Makefile.am
> +++ b/Documentation/ndctl/Makefile.am
> @@ -41,6 +41,7 @@ man1_MANS = \
>  	ndctl-enable-namespace.1 \
>  	ndctl-disable-namespace.1 \
>  	ndctl-create-namespace.1 \
> +	ndctl-reconfigure-namespace.1 \
>  	ndctl-destroy-namespace.1 \
>  	ndctl-check-namespace.1 \
>  	ndctl-inject-error.1 \
> diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
> index 343733d..9250a76 100644
> --- a/Documentation/ndctl/ndctl-create-namespace.txt
> +++ b/Documentation/ndctl/ndctl-create-namespace.txt
> @@ -219,5 +219,6 @@ linkndctl:ndctl-zero-labels[1],
>  linkndctl:ndctl-init-labels[1],
>  linkndctl:ndctl-disable-namespace[1],
>  linkndctl:ndctl-enable-namespace[1],
> +linkndctl:ndctl-reconfigure-namespace[1],
>  http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol]
>  https://nvdimm.wiki.kernel.org[Linux Persistent Memory Wiki]
> diff --git a/Documentation/ndctl/ndctl-reconfigure-namespace.txt b/Documentation/ndctl/ndctl-reconfigure-namespace.txt
> new file mode 100644
> index 0000000..dcd9fa8
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-reconfigure-namespace.txt
> @@ -0,0 +1,199 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +ndctl-reconfigure-namespace(1)
> +==============================
> +
> +NAME
> +----
> +ndctl-reconfigure-namespace - reconfigure a namespace
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl reconfigure-namespace' namespace [<options>]
> +
> +include::namespace-description.txt[]
> +
> +EXAMPLES
> +--------
> +
> +Convert namespace0.0 to mapping to 'mem'
> +[verse]
> +ndctl reconfigure-namespace namespace0.0 -f --map=mem
> +
> +Convert namespace0.0 size to 10G
> +[verse]
> +ndctl reconfigure-namespace namespace0.0 -f --size=10G
> +
> +OPTIONS
> +-------
> +-m::
> +--mode=::
> +	- "raw": expose the namespace capacity directly with

[..]

Instead of duplicating all this text, lets 'refactor' it into a common
namespace-create-options.txt file, and include it in both the reconfig
and create man pages.

> +
> +include::../copyright.txt[]
> +
> +SEE ALSO
> +--------
> +linkndctl:ndctl-zero-labels[1],
> +linkndctl:ndctl-init-labels[1],
> +linkndctl:ndctl-disable-namespace[1],
> +linkndctl:ndctl-enable-namespace[1],
> +linkndctl:ndctl-create-namespace[1],
> +http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol]
> +https://nvdimm.wiki.kernel.org[Linux Persistent Memory Wiki]
> diff --git a/builtin.h b/builtin.h
> index 675a6ce..0cfd96f 100644
> --- a/builtin.h
> +++ b/builtin.h
> @@ -23,6 +23,7 @@ struct cmd_struct {
>  int cmd_create_nfit(int argc, const char **argv, void *ctx);
>  int cmd_enable_namespace(int argc, const char **argv, void *ctx);
>  int cmd_create_namespace(int argc, const char **argv, void *ctx);
> +int cmd_reconfigure_namespace(int argc, const char **argv, void *ctx);
>  int cmd_destroy_namespace(int argc, const char **argv, void *ctx);
>  int cmd_disable_namespace(int argc, const char **argv, void *ctx);
>  int cmd_check_namespace(int argc, const char **argv, void *ctx);
> diff --git a/ndctl/action.h b/ndctl/action.h
> index 1ecad49..44e141e 100644
> --- a/ndctl/action.h
> +++ b/ndctl/action.h
> @@ -9,6 +9,7 @@ enum device_action {
>  	ACTION_ENABLE,
>  	ACTION_DISABLE,
>  	ACTION_CREATE,
> +	ACTION_RECONFIGURE,
>  	ACTION_DESTROY,
>  	ACTION_CHECK,
>  	ACTION_WAIT,
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 510553c..cd01a1f 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -115,6 +115,23 @@ OPT_STRING('a', "align", &param.align, "align", \
>  OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active"), \
>  OPT_BOOLEAN('L', "autolabel", &param.autolabel, "automatically initialize labels")
>  
> +#define RECONFIGURE_OPTIONS() \
> +OPT_STRING('u', "uuid", &param.uuid, "uuid", \
> +	"specify the uuid for the namespace (default: autogenerate)"), \
> +OPT_STRING('n', "name", &param.name, "name", \
> +	"specify an optional free form name for the namespace"), \
> +OPT_STRING('s', "size", &param.size, "size", \
> +	"specify the namespace size in bytes (default: available capacity)"), \
> +OPT_STRING('m', "mode", &param.mode, "operation-mode", \
> +	"specify a mode for the namespace, 'sector', 'fsdax', 'devdax' or 'raw'"), \
> +OPT_STRING('M', "map", &param.map, "memmap-location", \
> +	"specify 'mem' or 'dev' for the location of the memmap"), \
> +OPT_STRING('a', "align", &param.align, "align", \
> +	"specify the namespace alignment in bytes (default: 2M)"), \
> +OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active"), \
> +OPT_BOOLEAN('L', "autolabel", &param.autolabel, "automatically initialize labels")

Similarly, instead of copying these, lets create a common subset and
include it along with CREATE_ and RECONFIG_

> +
> +
>  #define CHECK_OPTIONS() \
>  OPT_BOOLEAN('R', "repair", &repair, "perform metadata repairs"), \
>  OPT_BOOLEAN('L', "rewrite-log", &logfix, "regenerate the log"), \
> @@ -138,6 +155,12 @@ static const struct option create_options[] = {
>  	OPT_END(),
>  };
>  
> +static const struct option reconfigure_options[] = {
> +	BASE_OPTIONS(),
> +	RECONFIGURE_OPTIONS(),
> +	OPT_END(),
> +};
> +
>  static const struct option check_options[] = {
>  	BASE_OPTIONS(),
>  	CHECK_OPTIONS(),
> @@ -270,6 +293,9 @@ static const char *parse_namespace_options(int argc, const char **argv,
>  	param.do_scan = argc == 1;
>          argc = parse_options(argc, argv, options, u, 0);
>  
> +	if (mode == ACTION_RECONFIGURE)
> +		param.reconfig = argv[0];
> +
>  	rc = set_defaults(mode);
>  
>  	if (argc == 0 && mode != ACTION_CREATE) {
> @@ -288,6 +314,9 @@ static const char *parse_namespace_options(int argc, const char **argv,
>  			case ACTION_CHECK:
>  				action_string = "check";
>  				break;
> +			case ACTION_RECONFIGURE:
> +				action_string = "reconfigure";
> +				break;
>  			default:
>  				action_string = "<>";
>  				break;
> @@ -1053,6 +1082,7 @@ static int do_xaction_namespace(const char *namespace,
>  						return rc;
>  					break;
>  				case ACTION_CREATE:
> +				case ACTION_RECONFIGURE:
>  					rc = namespace_reconfig(region, ndns);
>  					if (rc < 0)
>  						return rc;
> @@ -1114,6 +1144,20 @@ int cmd_enable_namespace(int argc, const char **argv, void *ctx)
>  	}
>  }
>  
> +int cmd_reconfigure_namespace(int argc, const char **argv, void *ctx)
> +{
> +	char *xable_usage = "ndctl reconfigure-namespace <namespace> [<options>]";
> +	char *namespace = parse_namespace_options(argc, argv,
> +			ACTION_RECONFIGURE, reconfigure_options, xable_usage);
> +	int reconfigured = do_xaction_namespace(namespace, ACTION_RECONFIGURE,
> +						ctx);
> +
> +	if (reconfigured < 1)
> +		fprintf(stderr, "failed to reconfigure namespace:%s %s\n",
> +			namespace, strerror(-reconfigured));
> +	return reconfigured;
> +}
> +
>  int cmd_create_namespace(int argc, const char **argv, void *ctx)
>  {
>  	char *xable_usage = "ndctl create-namespace [<options>]";
> diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
> index 73dabfa..b4d252c 100644
> --- a/ndctl/ndctl.c
> +++ b/ndctl/ndctl.c
> @@ -72,6 +72,7 @@ static struct cmd_struct commands[] = {
>  	{ "enable-namespace", cmd_enable_namespace },
>  	{ "disable-namespace", cmd_disable_namespace },
>  	{ "create-namespace", cmd_create_namespace },
> +	{ "reconfigure-namespace", cmd_reconfigure_namespace },
>  	{ "destroy-namespace", cmd_destroy_namespace },
>  	{ "check-namespace", cmd_check_namespace },
>  	{ "enable-region", cmd_enable_region },
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
