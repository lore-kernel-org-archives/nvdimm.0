Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE242223CCEEC
 for <linux-nvdimm@lists.01.org>; Thu,  1 Feb 2018 17:01:30 -0800 (PST)
Received: by mail-oi0-x242.google.com with SMTP id j188so13463111oib.6
 for <linux-nvdimm@lists.01.org>; Thu, 01 Feb 2018 17:07:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180202004158.18834-1-vishal.l.verma@intel.com>
References: <20180202004158.18834-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 1 Feb 2018 17:07:07 -0800
Message-ID: <CAPcyv4hd0YoFyvgs+fzxAx_SFe4a7AyjCBfOzj--wyyU=L9Q_w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] libnvdimm/nfit_test: add firmware download
 emulation
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 1, 2018 at 4:41 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> From: Dave Jiang <dave.jiang@intel.com>
>
> Adding support in nfit_test for DSM v1.6 firmware update sequence. The test
> will simulate the flashing of firmware to the DIMM. A bogus version string
> will be returned as the test has no idea how to parse the firmware binary.
> Any bogus binary can be used to "update" as the actual binary is not copied
> into the kernel.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> [ vishal: also move smart calls into the nd_cmd_call block ]
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

This fixes the issue I was having with "make TESTS=libndctl check", applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
