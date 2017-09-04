Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7932621E3EA6D
 for <linux-nvdimm@lists.01.org>; Mon,  4 Sep 2017 11:15:26 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id h70so9182503oic.1
 for <linux-nvdimm@lists.01.org>; Mon, 04 Sep 2017 11:18:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1504539273-44522-1-git-send-email-mengxu.gatech@gmail.com>
References: <1504539273-44522-1-git-send-email-mengxu.gatech@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 4 Sep 2017 11:18:13 -0700
Message-ID: <CAPcyv4i7UzNNc7_EyTxsO8jnFmmd7F3sULUCjnWgure-t1yj_g@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: move the check on nd_reserved2 to the endpoint
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
To: Meng Xu <mengxu.gatech@gmail.com>
Cc: Meng Xu <meng.xu@gatech.edu>, taesoo@gatech.edu, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, sanidhya@gatech.edu, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 4, 2017 at 8:34 AM, Meng Xu <mengxu.gatech@gmail.com> wrote:
> This patch delays the check of nd_reserved2 to the actual endpoint
> (acpi_nfit_ctl) that uses it, as a prevention of a potential
> double-fetch bug.
>
> Detailed discussion can be found at
> https://marc.info/?l=linux-kernel&m=150421938113092&w=2

Thanks for doing this, I went ahead and copied this discussion into
the patch and applied it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
