Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5AADF2252649A
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 14:27:59 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id x9-v6so20622454oig.7
 for <linux-nvdimm@lists.01.org>; Wed, 04 Apr 2018 14:27:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180404212340.GA12737@outlook.office365.com>
References: <152246898837.36038.26895928842345061.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180404212340.GA12737@outlook.office365.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 4 Apr 2018 14:27:57 -0700
Message-ID: <CAPcyv4jknruAmkPEVx0X6Bd3uRs_FYdPf-W-5cDO1Z+kaG5+uw@mail.gmail.com>
Subject: Re: [v8, 11/18] mm, dax: enable filesystems to trigger dev_pagemap
 ->page_free callbacks
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
To: Andrei Vagin <avagin@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 4, 2018 at 2:23 PM, Andrei Vagin <avagin@virtuozzo.com> wrote:
> Hi Dan,
>
> I catch the following bug on the linux-next 20180404. git bisect brought me to this commit:

Yes, I will be yanking this functionality out of -next shortly and try
again for v4.18.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
