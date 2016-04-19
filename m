Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B7B381A220B
 for <linux-nvdimm@lists.01.org>; Tue, 19 Apr 2016 10:45:49 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id k142so16597903oib.1
 for <linux-nvdimm@lists.01.org>; Tue, 19 Apr 2016 10:45:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9f04df3b80c68dd6406cfee5ce11a2cd8ed33b64.1460936121.git.jerry.hoemann@hpe.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <9f04df3b80c68dd6406cfee5ce11a2cd8ed33b64.1460936121.git.jerry.hoemann@hpe.com>
Date: Tue, 19 Apr 2016 10:45:48 -0700
Message-ID: <CAPcyv4jiaoYnMi60ThWyeKVxj-3cWfd6ZgZq9Ot4Qfe4gXmvUQ@mail.gmail.com>
Subject: Re: [RFC v9 5/5] nvdimm: Add ioctl to return command mask.
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Apr 17, 2016 at 4:38 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> The pass thru calls return command mask.  Previously, bit zero
> wasn't part of command mask, but as it is now, this left commands_show
> displaying "unknown" for function zero.  Add an ioctl interface
> to return command mask.
>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---
>  drivers/nvdimm/bus.c       | 10 ++++++++--
>  include/uapi/linux/ndctl.h |  9 +++++++++
>  2 files changed, 17 insertions(+), 2 deletions(-)

Let's not add yet another ioctl for this... just add a 'dsm_mask'
attribute to the nfit_mem device in acpi_nfit_dimm_attributes.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
