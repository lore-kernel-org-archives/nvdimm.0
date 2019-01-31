Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E38B211BB8AC
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 16:52:45 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v10 03/12] ndctl: add disable security support
Date: Thu, 31 Jan 2019 00:52:43 +0000
Message-ID: <f840356be61ba6d8701f7b0d6c0f069778baf5c7.camel@intel.com>
References: <154837084784.37086.4597479371733088393.stgit@djiang5-desk3.ch.intel.com>
 <154837124124.37086.11776825409363769095.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154837124124.37086.11776825409363769095.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <E6F54346B5D43546A22AC96BC719B626@intel.com>
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
> Add support for disable security to libndctl and also command line option
> of "disable-passphrase" for ndctl. This provides a way to disable security
> on the nvdimm.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/Makefile.am                 |    3 ++-
>  Documentation/ndctl/ndctl-remove-passphrase.txt |   26 ++++++++++++++++++++++
>  ndctl/builtin.h                                 |    1 +
>  ndctl/dimm.c                                    |   23 ++++++++++++++++++++
>  ndctl/lib/dimm.c                                |    9 ++++++++
>  ndctl/lib/libndctl.sym                          |    1 +
>  ndctl/libndctl.h                                |    1 +
>  ndctl/ndctl.c                                   |    1 +
>  ndctl/util/keys.c                               |   27 +++++++++++++++++++++++
>  ndctl/util/keys.h                               |    6 +++++
>  10 files changed, 97 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ndctl/ndctl-remove-passphrase.txt

[..]

> diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
> index 5cb5fa4f..9f4ab234 100644
> --- a/ndctl/ndctl.c
> +++ b/ndctl/ndctl.c
> @@ -90,6 +90,7 @@ static struct cmd_struct commands[] = {
>  	{ "start-scrub", { cmd_start_scrub } },
>  	{ "setup-passphrase", { cmd_passphrase_setup } },
>  	{ "update-passphrase", { cmd_passphrase_update } },
> +	{ "remove-passphrase", { cmd_passphrase_remove } },

Same comment as patch 2 about s/passphrase_remove/remove_passphrase/
here. I think the remaining new commands in this series do this
correctly, i.e. *-verb-object for command names and function names.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
