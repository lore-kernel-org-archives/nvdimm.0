Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A404E211B1115
 for <linux-nvdimm@lists.01.org>; Tue, 29 Jan 2019 18:35:51 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v10 02/12] ndctl: add passphrase update to ndctl
Date: Wed, 30 Jan 2019 02:35:49 +0000
Message-ID: <1dc0a1788da54574257299d78006ab209639dc71.camel@intel.com>
References: <154837084784.37086.4597479371733088393.stgit@djiang5-desk3.ch.intel.com>
 <154837123565.37086.2456954752128201392.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154837123565.37086.2456954752128201392.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <5CBCDB28EA28F64D9683A1F61BDC1E2C@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2019-01-24 at 16:07 -0700, Dave Jiang wrote:
> Add API call for triggering sysfs knob to update the security for a DIMM
> in libndctl. Also add the ndctl "update-passphrase" to trigger the
> operation.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/Makefile.am                 |    5 
>  Documentation/ndctl/ndctl-setup-passphrase.txt  |   47 ++
>  Documentation/ndctl/ndctl-update-passphrase.txt |   51 +++
>  configure.ac                                    |   17 +
>  ndctl.spec.in                                   |    2 
>  ndctl/Makefile.am                               |    5 
>  ndctl/builtin.h                                 |    2 
>  ndctl/dimm.c                                    |   83 ++++
>  ndctl/lib/Makefile.am                           |    4 
>  ndctl/lib/dimm.c                                |   24 +
>  ndctl/lib/libndctl.sym                          |    1 
>  ndctl/libndctl.h                                |    9 
>  ndctl/ndctl.c                                   |    2 
>  ndctl/util/keys.c                               |  460 +++++++++++++++++++++++
>  ndctl/util/keys.h                               |   29 +
>  15 files changed, 729 insertions(+), 12 deletions(-)
>  create mode 100644 Documentation/ndctl/ndctl-setup-passphrase.txt
>  create mode 100644 Documentation/ndctl/ndctl-update-passphrase.txt
>  create mode 100644 ndctl/util/keys.c
>  create mode 100644 ndctl/util/keys.h
> 
> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> index 7e17f206..79b12f8b 100644
> --- a/Documentation/ndctl/Makefile.am
> +++ b/Documentation/ndctl/Makefile.am
> @@ -47,7 +47,9 @@ man1_MANS = \
>  	ndctl-inject-smart.1 \
>  	ndctl-update-firmware.1 \
>  	ndctl-list.1 \
> -	ndctl-monitor.1
> +	ndctl-monitor.1 \
> +	ndctl-setup-passphrase.1 \
> +	ndctl-update-passphrase.1
>  
>  CLEANFILES = $(man1_MANS)
>  
> @@ -56,6 +58,7 @@ attrs.adoc: $(srcdir)/Makefile.am
>  	$(AM_V_GEN) cat <<- EOF >$@
>  		:ndctl_monitorconfdir: $(ndctl_monitorconfdir)
>  		:ndctl_monitorconf: $(ndctl_monitorconf)
> +		:ndctl_keysdir: $(ndctl_keysdir)
>  		EOF
>  
>  XML_DEPS = \
> diff --git a/Documentation/ndctl/ndctl-setup-passphrase.txt b/Documentation/ndctl/ndctl-setup-passphrase.txt
> new file mode 100644
> index 00000000..1594f110
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-setup-passphrase.txt
> @@ -0,0 +1,47 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +include::attrs.adoc[]
> +
> +ndctl-setup-passphrase(1)
> +=========================
> +
> +NAME
> +----
> +ndctl-setup-passphrase - setup and enable the security passphrase for an NVDIMM
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl setup-passphrase' <nmem0> [<nmem1>..<nmemN>] -k <key_handle> [<options>]
> +
> +DESCRIPTION
> +-----------
> +Enable the security passphrase for one or more NVDIMMs.
> +
> +Prerequisite for command to succeed:

Prerequisites

> +1. The master key has already been loaded into the user key ring.

It might be helpful to have a blurb here about how a user can do this,
or where to look for further information.

> +2. ndctl install-encrypt-key has been executed successfully.

I don't think in this series, 'install-encrypt-key' exists anymore, in
fact, isn't this the very command it is talking about? (in which case
no point in listing it in the prerequisites?)

If this does end up reducing to just one prerequisite, then maybe
convert the list into a paragraph.

> +
> +The encrypted key blobs will be created by ndctl in {ndctl_keysdir} directory
> +with the file name of "nvdimm_<dimm unique id>_<hostname>.blob"

Not a huge deal, and you can choose to ignore this, but maybe wherever
this string is present in the documentation, replace it with:

    "nvdimm_<dimm-unique-id>_<hostname>.blob"

Just so that there aren't odd looking spaces in a filename that in
reality won't have those spaces.

> +
> +The command will fail if the nvdimm key is already in the user key ring and/or
> +the key blob already resides in {ndctl_keysdir}.
> +
> +OPTIONS
> +-------
> +<dimm>::
> +include::xable-dimm-options.txt[]
> +
> +-k::
> +--key_handle=::
> +	The encryption key (master) key handle, used for sealing the DIMM
> +	encrypted keys. The format is <key type>:<key description>.
> +	i.e. trusted:nvdimm-master
> +	This key is expected to be loaded in the kernel's user keyring.
> +
> +-v::
> +--verbose::
> +        Emit debug messages for the namespace check process.

This looks stale, we're not checking the namespace :)

> +
> +include::../copyright.txt[]
> diff --git a/Documentation/ndctl/ndctl-update-passphrase.txt b/Documentation/ndctl/ndctl-update-passphrase.txt
> new file mode 100644
> index 00000000..05573968
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-update-passphrase.txt
> @@ -0,0 +1,51 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +include::attrs.adoc[]
> +
> +ndctl-update-passphrase(1)
> +==========================
> +
> +NAME
> +----
> +ndctl-update-passphrase - update the security passphrase for an NVDIMM
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl update-passphrase' <nmem0> [<nmem1>..<nmemN>] [<options>]
> +
> +DESCRIPTION
> +-----------
> +Update the security passphrase for one or more NVDIMMs.
> +Prerequisite for command to succeed:
> +1. The master key has already been loaded into the user key ring.
> +2. ndctl install-encrypt-key has been executed successfully.

Same comment as above, maybe in this case the name just needs to be
updated.

> +3. setup-passphrase has successfully been executed previously on the NVDIMM
> +   or NVDIMM has been successfully unlocked by the kernel.

The formatting in this both this list and above in the setup-passphrase 
man page isn't quite right. This bit renders as:

   Update the security passphrase for one or more NVDIMMs. Prerequisite for command to succeed: 1.
   The master key has already been loaded into the user key ring. 2. ndctl install-encrypt-key has
   been executed successfully. 3. setup-passphrase has successfully been executed previously on
   the NVDIMM
      or NVDIMM has been successfully unlocked by the kernel.

Might need more line breaks or spaces at the start to make it render
correctly.

> +
> +The updated key blobs will be created by ndctl in {ndctl_keysdir} directory
> +with the file name of "nvdimm_<dimm unique id>_<hostname>.blob".
> +
> +OPTIONS
> +-------
> +<dimm>::
> +include::xable-dimm-options.txt[]
> +
> +-k::
> +--key_handle=::
> +	The new encryption key (master) key handle, used for sealing the DIMM

This doesn't read right. Maybe all of "master key" should have been in
parenthesis? Or the second 'key' is extraneous? (This applies to the
above man page as well).

> +	encrypted keys. The format is <key type>:<key description>.

Did you mean DIMM's encrypted keys? Or did you mean "used for sealing
(encrypting) the DIMM's keys? And is there one key that will be sealed,
or multiple?

> +	i.e. trusted:nvdimm-master
> +	This key is expected to be loaded in the kernel's user keyring.
> +	This parameter is optional. If none provided, ndctl will determine

If not provided

> +	the current key handle from the encrypted key for the NVDIMM.
> +
> +-v::
> +--verbose::
> +        Emit debug messages for the namespace check process.

Same staleness as above.

> +
> +include::../copyright.txt[]
> +
> +SEE ALSO:
> +---------
> +linkndctl:ndctl-setup-passphrase[1]
>  

[..]

> 
> diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
> index b01594e0..5cb5fa4f 100644
> --- a/ndctl/ndctl.c
> +++ b/ndctl/ndctl.c
> @@ -88,6 +88,8 @@ static struct cmd_struct commands[] = {
>  	{ "inject-smart", { cmd_inject_smart } },
>  	{ "wait-scrub", { cmd_wait_scrub } },
>  	{ "start-scrub", { cmd_start_scrub } },
> +	{ "setup-passphrase", { cmd_passphrase_setup } },
> +	{ "update-passphrase", { cmd_passphrase_update } },

There is a bit of inconsistency in the naming here - if the command is
setup-passphrase, the function should also be cmd_setup_passphrase.

>  	{ "list", { cmd_list } },
>  	{ "monitor", { cmd_monitor } },
>  	{ "help", { cmd_help } },
> diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
> new file mode 100644
> index 00000000..1592ff09
> --- /dev/null
> +++ b/ndctl/util/keys.c
> @@ -0,0 +1,460 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2018 Intel Corporation. All rights reserved. */

2019 - could stand to update this anywhere else in this series, if
applicable.



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
