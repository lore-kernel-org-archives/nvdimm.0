Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE25421A0482A
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 10:57:57 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id g125so4424567oib.12
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 11:01:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150774466038.55191.18214496952092405741.stgit@djiang5-desk3.ch.intel.com>
References: <150774466038.55191.18214496952092405741.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 11:01:26 -0700
Message-ID: <CAPcyv4jFXmmFriwc5+o0qjx7OoASijHAm3TRPBbF_yVdD2BOGw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: add smart payload fields added in DSM 1.6
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
Cc: "Balcer, Piotr" <piotr.balcer@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 11, 2017 at 10:57 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> NVDIMM DSM interface v1.6 added additional smart health fields. Updating the
> smart payload data structure accordingly.

I'll also add a note when I merge this that the only reason we are
maintaining this structure in the kernel is in case we want to
translate 3rd party SMART payload formats into the ND_IOCTL_SMART
format. Outside of that we could just delete this since ndctl is
already doing that translation.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
