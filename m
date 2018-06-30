Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 19D34202E5465
 for <linux-nvdimm@lists.01.org>; Sat, 30 Jun 2018 11:12:13 -0700 (PDT)
Received: by mail-ot0-x241.google.com with SMTP id w22-v6so13315349otk.5
 for <linux-nvdimm@lists.01.org>; Sat, 30 Jun 2018 11:12:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E32237E966C2@g01jpexmbkw01>
References: <0DEDF3B159719A448A49EF0E7B11E32237E966C2@g01jpexmbkw01>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 30 Jun 2018 11:12:12 -0700
Message-ID: <CAPcyv4h7c8JU8=-H=ebWkA9Nww+gDOzptve9w42Os15yPC-YsQ@mail.gmail.com>
Subject: Re: Question about ndctl unit tests
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
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: "Mizuma, Masayoshi" <m.mizuma@jp.fujitsu.com>, "Gotou, Yasunori  <y-goto@jp.fujitsu.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jun 30, 2018 at 1:07 AM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
> Hi,
>
>
>
> When I ran the unit tests, I found "libndctl" and "dsm-fail" cannot pass the
> test.

Yes, sorry, we recently reworked some tests. Grab our work-in-progress
kernel branch here:

    git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git
libnvdimm-pending

This will move to nvdimm/nvdimm.git libnvdimm-for-next in the coming
weeks for 4.19.

You'll also want to grab:

    https://patchwork.kernel.org/patch/10495297/

...for the error handling tests. This will appear on
github.com/pmem/ndctl master soon.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
