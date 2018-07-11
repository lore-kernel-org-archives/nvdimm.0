Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 70D80203B99C2
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 10:14:04 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id 13-v6so50640511ois.1
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 10:14:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153132901164.57269.12329347241228490231.stgit@djiang5-desk3.ch.intel.com>
References: <153132901164.57269.12329347241228490231.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Jul 2018 10:14:03 -0700
Message-ID: <CAPcyv4jjj9DUgpPfX06jhGNKS5eCVhHV3LFNNGrUGbwisL3wWQ@mail.gmail.com>
Subject: Re: [PATCH] nfit: fix unchecked dereference in acpi_nfit_ctl
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

On Wed, Jul 11, 2018 at 10:10 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> Incremental patch to fix the unchecked dereference in acpi_nfit_ctl.
> Reported by Dan Carpenter:
>
> "acpi/nfit: fix cmd_rc for acpi_nfit_ctl to
> always return a value" from Jun 28, 2018, leads to the following
> Smatch complaint:
>
>     drivers/acpi/nfit/core.c:578 acpi_nfit_ctl()
>      warn: variable dereferenced before check 'cmd_rc' (see line 411)
>
> drivers/acpi/nfit/core.c
>    410
>    411          *cmd_rc = -EINVAL;
>                 ^^^^^^^^^^^^^^^^^^
> Patch adds unchecked dereference.

Looks good, when committing I would add:

Fixes: c1985cefd844 ("acpi/nfit: fix cmd_rc for acpi_nfit_ctl to
always return a value")

...and in the pull request to Linus note that this was the result of
testing in -next so he knows why there is a fresh commit on the
branch, and that the rest of the commits have survived -next with no
issues.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
