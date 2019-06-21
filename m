Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5DD32129F0EC
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 17:59:15 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id w79so3504859oif.10
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 17:59:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190607052558.15037-1-santosh@fossix.org>
In-Reply-To: <20190607052558.15037-1-santosh@fossix.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Jun 2019 17:59:03 -0700
Message-ID: <CAPcyv4h0dXXrw55H1f7QHz8RaLSsJAG5h9wXcB2fUtRCb4K3dA@mail.gmail.com>
Subject: Re: [ndctl PATCH] Enable ndctl tests for emulated pmem devices
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
To: Santosh Sivaraj <santosh@fossix.org>
Cc: harish@linux.ibm.com, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 6, 2019 at 10:26 PM Santosh Sivaraj <santosh@fossix.org> wrote:
>
> For QEMU emulated devices, nfit drivers need not be loaded, also the
> nfit_test, libnvdimm_test modules are not required. This patch adds a
> configure option to enable testing on qemu without nfit dependencies.

This looks useful, I only quibble with it being a compile time option.
I'd prefer an environment variable to allow this to be overridden at
test run time, perhaps "WITH_NFIT". You can have a compile time option
to set the WITH_NFIT default, but otherwise it would be useful to be
able to disable NFIT requiring tests even on x86.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
