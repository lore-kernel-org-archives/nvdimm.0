Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 156072119FF45
 for <linux-nvdimm@lists.01.org>; Wed,  9 Jan 2019 14:09:01 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v7 07/12] ndctl: setup modprobe rules
Date: Wed, 9 Jan 2019 22:08:59 +0000
Message-ID: <7ebf9a9d1300f4294ed178405aaeb495d37937ac.camel@intel.com>
References: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
 <154705647045.23227.7733373111052687524.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154705647045.23227.7733373111052687524.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <911473BB5EF19843B581EB39C10C2C37@intel.com>
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


On Wed, 2019-01-09 at 10:54 -0700, Dave Jiang wrote:
> Adding reference config file for modprobe.d in order to trigger the
> reference script that will inject keys associated with the nvdimms
> into
> the kernel user ring for unlock.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Makefile.am                  |   10 ++++++++++
>  contrib/ndctl-loadkeys.sh    |   25 +++++++++++++++++++++++++
>  contrib/nvdimm_modprobe.conf |    1 +
>  3 files changed, 36 insertions(+)
>  create mode 100755 contrib/ndctl-loadkeys.sh
>  create mode 100644 contrib/nvdimm_modprobe.conf
> 
> diff --git a/Makefile.am b/Makefile.am
> index e0c463a3..5a3f03aa 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -42,6 +42,16 @@ bashcompletiondir = $(BASH_COMPLETION_DIR)
>  dist_bashcompletion_DATA = contrib/ndctl
>  endif
>  
> +load_key_file = contrib/ndctl-loadkeys.sh
> +load_keydir = $(sysconfdir)/ndctl/
> +load_key_DATA = $(load_key_file)
> +EXTRA_DIST += $(load_key_file)
> +
> +modprobe_file = contrib/nvdimm_modprobe.conf
> +modprobedir = $(sysconfdir)/modprobe.d/
> +modprobe_DATA = $(modprobe_file)
> +EXTRA_DIST += $(modprobe_file)
> +

We're installing these files via the Makefile, but I think the spec is
missing them? Presumably the spec should also install them in the same
way?

>  noinst_LIBRARIES = libccan.a
>  libccan_a_SOURCES = \
>  	ccan/str/str.h \
> diff --git a/contrib/ndctl-loadkeys.sh b/contrib/ndctl-loadkeys.sh
> new file mode 100755
> index 00000000..bc2c94df
> --- /dev/null
> +++ b/contrib/ndctl-loadkeys.sh
> @@ -0,0 +1,25 @@
> +#!/bin/bash -Ex

I didn't catch this before, but this script doesn't need -E since we're
not setting up a trap.
If anything use -e, the regular version.
I'm also not sure -x is needed - it is just an example script right? I 
don't feel strongly about it either way, if having the extra debug here
might be helpful we can keep it.

> +
> +# This script assumes a single master key for all DIMMs
> +
> +key_path=/etc/ndctl/keys
> +tpmh_path="$key_path"/tpm.handle
> +key_type=""
> +tpm_handle=""
> +id=""
> +
> +if [ -f $tpmh_path ]; then
> +	key_type=trusted
> +	tpm_handle="keyhandle=$(cat $tpmh_path)"
> +else
> +	key_type=user
> +fi
> +
> +if ! keyctl search @u "$key_type" nvdimm-master; then
> +	keyctl add "$key_type" nvdimm-master "load $(cat
> $key_path/nvdimm-master.blob) $tpm_handle" @u > /dev/null
> +fi
> +
> +for file in "$key_path"/nvdimm_*; do
> +	id="$(cut -d'_' -f2 <<< "${file##*/}")"
> +	keyctl add encrypted nvdimm:"$id" "load $(cat "$file")" @u
> +done
> diff --git a/contrib/nvdimm_modprobe.conf
> b/contrib/nvdimm_modprobe.conf
> new file mode 100644
> index 00000000..b113d8d7
> --- /dev/null
> +++ b/contrib/nvdimm_modprobe.conf
> @@ -0,0 +1 @@
> +install libnvdimm /usr/sbin/ndctl-loadkeys.sh ; /sbin/modprobe --
> ignore-install libnvdimm $CMDLINE_OPTS

I'm not familiar with how modprobe.conf works, but is it looking for
ndctl-loadkeys.sh in /usr/sbin? If so are we installing it there? The
lines above in the Makefile seem to have it going into /etc/ndctl ?

> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
