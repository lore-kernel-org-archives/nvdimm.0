Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A2F952222C238
 for <linux-nvdimm@lists.01.org>; Tue, 13 Feb 2018 12:46:33 -0800 (PST)
Received: by mail-oi0-x22d.google.com with SMTP id k15so14916192oib.1
 for <linux-nvdimm@lists.01.org>; Tue, 13 Feb 2018 12:52:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180213192204.GA13682@linux.intel.com>
References: <20180212230558.5546-1-ross.zwisler@linux.intel.com>
 <20180213145404.GB14657@lst.de> <20180213192204.GA13682@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Feb 2018 12:52:22 -0800
Message-ID: <CAPcyv4jgc0yhZ6mX4az4HJf79q=t0dNy5h=rXHyJYFWhR8Zatg@mail.gmail.com>
Subject: Re: [PATCH] loop: Fix lost writes caused by missing flag
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 13, 2018 at 11:22 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Tue, Feb 13, 2018 at 03:54:04PM +0100, Christoph Hellwig wrote:
>> Looks good:
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>
>> Can you wire up your test cases for blktests?
>
> Is blktests really the right place for this test?  This failure is highly
> dependent on the configuration of the filesystem that is holding the file that
> we are using for the loopback device.  It doesn't seem like blktests has
> support for mount options (dax), etc?
>
> Because of the interaction with the underlying filesystem this seems like a
> better fit with xfstests to me, but I don't know if we need to add tests there
> because we already have pretty good coverage of loopback device failures.
> That's how we found this - this bug causes all these tests to fail:
> xfs/074 xfs/078 xfs/216 xfs/217 xfs/250

The problem is that those tests don't configure the device in 4K
sector mode, so we're still missing a regression test. That seems to
be where blktests can come into play.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
