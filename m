Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1A75F1A1DFC
 for <linux-nvdimm@lists.01.org>; Mon, 13 Jun 2016 16:18:44 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id d132so127780565oig.1
 for <linux-nvdimm@lists.01.org>; Mon, 13 Jun 2016 16:18:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Date: Mon, 13 Jun 2016 16:18:18 -0700
Message-ID: <CAPcyv4jdM1phR=kGoP2-7tfsVvbNe2C6hHNS5TD28ALGZQQTSw@mail.gmail.com>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Thanks Toshi!

On Mon, Jun 13, 2016 at 3:21 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> This patch-set adds DAX support to device-mapper dm-linear devices
> used by LVM.  It works with LVM commands as follows:
>  - Creation of a logical volume with all DAX capable devices (such
>    as pmem) sets the logical volume DAX capable as well.
>  - Once a logical volume is set to DAX capable, the volume may not
>    be extended with non-DAX capable devices.

I don't mind this, but it seems a policy decision that the kernel does
not need to make.  A sufficiently sophisticated user could cope with
DAX being available at varying LBAs.  Would it be sufficient to move
this policy decision to userspace tooling?

> The direct_access interface is added to dm and dm-linear to map
> a request to a target device.

I had dm-linear and md-raid0 support on my list of things to look at,
did you have raid0 in your plans?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
