Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 410DB207E4E04
 for <linux-nvdimm@lists.01.org>; Wed, 23 May 2018 10:41:18 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id c203-v6so20269017oib.7
 for <linux-nvdimm@lists.01.org>; Wed, 23 May 2018 10:41:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180523173846.7923-1-vishal.l.verma@intel.com>
References: <20180523173846.7923-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 May 2018 10:41:17 -0700
Message-ID: <CAPcyv4hBJho6CgTb9QbwaFvQEUib9e6PzEq6Bmx6nmc80_egbA@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl,
 test: fix sector-mode.sh to work with label support
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 23, 2018 at 10:38 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The nfit_test.1 grew support for the label DSMs. Fix sector-mode.sh to
> emulate labelless mode by zeroing the labels at the start, and supplying
> --no-autolabel to create-namespace commands.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
