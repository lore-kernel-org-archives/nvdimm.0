Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 851AC21107172
 for <linux-nvdimm@lists.01.org>; Tue,  4 Sep 2018 08:57:48 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id l82-v6so7635678oih.11
 for <linux-nvdimm@lists.01.org>; Tue, 04 Sep 2018 08:57:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1536058062-18894-1-git-send-email-oceanhehy@gmail.com>
References: <1536058062-18894-1-git-send-email-oceanhehy@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 4 Sep 2018 08:57:47 -0700
Message-ID: <CAPcyv4iVYjbs_ds9tL4rceH5cSck=D-AkkejFh+rHXdY25nGfw@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm, region_devs: stop NDD_ALIASING bit test if
 one test pass
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
To: Ocean He <oceanhehy@gmail.com>
Cc: Ocean He <hehy1@lenovo.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 4, 2018 at 3:47 AM, Ocean He <oceanhehy@gmail.com> wrote:
> From: Ocean He <hehy1@lenovo.com>
>
> There is no need to finish entire loop to execute NDD_ALIASING bit test
> against every nvdimm->flags.

Of course there is. I see nothing stopping someone mixing an NVDIMM
that supports labels with one that doesn't. If anything I think we
need fixes to make sure this operates correctly to force disable
BLK-mode capactiy when the PMEM capacity is interleaved with a
label-less NVDIMM.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
