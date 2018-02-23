Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x22b.google.com (mail-lf0-x22b.google.com
 [IPv6:2a00:1450:4010:c07::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 65175222630CF
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 22:45:29 -0800 (PST)
Received: by mail-lf0-x22b.google.com with SMTP id t204so10903287lff.9
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 22:51:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151933257135.36856.6462188364046414070.stgit@djiang5-desk3.ch.intel.com>
References: <151933257135.36856.6462188364046414070.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Feb 2018 22:51:27 -0800
Message-ID: <CAPcyv4iCb_oH-M39tZHUJeOS__iQH6gKi8BfRKRHe9m+aEJHCQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ndctl: add more error outs to update firmware and
 enable verbose debug
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 22, 2018 at 12:49 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> update-firmware is missing verbose option for debug outputs. Also adding
> additional error outs to give better indication if something has failed
> and why.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

On second look, now that we are allowing multiple DIMMs to be updated
in one invocation, these runtime error messages should be of the form:

    "%s: message...\n", ndctl_dimm_get_devname(uctx->dimm)

...note the "\n", that seems to be missing on quite a few of these
error() calls, I missed that earlier.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
