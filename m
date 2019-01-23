Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 051CA211B85C2
 for <linux-nvdimm@lists.01.org>; Wed, 23 Jan 2019 10:21:47 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id x202so2572613oif.13
 for <linux-nvdimm@lists.01.org>; Wed, 23 Jan 2019 10:21:47 -0800 (PST)
MIME-Version: 1.0
References: <154777861562.42557.12388414625709189905.stgit@djiang5-desk3.ch.intel.com>
 <154777911867.42557.1102870234536796036.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154777911867.42557.1102870234536796036.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Jan 2019 10:21:35 -0800
Message-ID: <CAPcyv4i456Adxv7eRxxC64xgrpWRWPUUa4d6Y54-4mTATLOEDQ@mail.gmail.com>
Subject: Re: [PATCH v9 03/13] ndctl: add passphrase update to ndctl
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 17, 2019 at 6:38 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Add API call for triggering sysfs knob to update the security for a DIMM
> in libndctl. Also add the ndctl "update-passphrase" to trigger the
> operation.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/Makefile.am                 |    4
>  Documentation/ndctl/ndctl-setup-passphrase.txt  |   34 ++
>  Documentation/ndctl/ndctl-update-passphrase.txt |   36 ++
>  configure.ac                                    |   14 +
>  ndctl.spec.in                                   |    2
>  ndctl/builtin.h                                 |    2
>  ndctl/dimm.c                                    |   68 +++-
>  ndctl/lib/Makefile.am                           |    8
>  ndctl/lib/dimm.c                                |   24 +
>  ndctl/lib/keys.c                                |  387 +++++++++++++++++++++++
>  ndctl/lib/libndctl.sym                          |    3
>  ndctl/libndctl.h                                |   31 ++
>  ndctl/ndctl.c                                   |    2
>  13 files changed, 603 insertions(+), 12 deletions(-)
>  create mode 100644 Documentation/ndctl/ndctl-setup-passphrase.txt
>  create mode 100644 Documentation/ndctl/ndctl-update-passphrase.txt
>  create mode 100644 ndctl/lib/keys.c
[..]
> diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
> index 712223fc..72b6f66c 100644
> --- a/ndctl/lib/dimm.c
> +++ b/ndctl/lib/dimm.c
> @@ -631,3 +631,27 @@ NDCTL_EXPORT enum ndctl_security_state ndctl_dimm_get_security(
[..]
> +NDCTL_EXPORT int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
[..]
> diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
> new file mode 100644
> index 00000000..1ae0ff02
> --- /dev/null
> +++ b/ndctl/lib/keys.c
> @@ -0,0 +1,387 @@
[..]
> +NDCTL_EXPORT int ndctl_dimm_enable_key(struct ndctl_dimm *dimm)
[..]
> +NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm)

So, a general comment. I'm having a hard time envisioning how these
apis and other exports further in the series make sense to a consumer
that is not ndctl/dimm.c? There's quite a bit of assumptions of built
around how the ndctl command uses the keys that makes these apis not
generically useful to anyone else.

Exporting ndctl_dimm_get_security() makes sense because that's
generic, all of these other exports seem specific to the ndctl
implementation / scheme. It would be great to eventually have an api
for 3rd party key management implementations, but I think that's a v65
(or later) concern and we should export as little as possible until it
is clear how a 3rd party implementation would consume the apis.

I think the only private detail of the dimm that needs to be exported
is the raw sysfs interactions. Everything else should be private to
the ndctl use case in something like ndctl/util/keys.c, not publicly
exported in ndctl/lib/keys.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
