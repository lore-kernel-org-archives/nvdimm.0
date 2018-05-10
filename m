Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D2B620965DFD
 for <linux-nvdimm@lists.01.org>; Thu, 10 May 2018 16:19:36 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id k17-v6so3259336oih.5
 for <linux-nvdimm@lists.01.org>; Thu, 10 May 2018 16:19:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180510161242.0f9f97686a9c0a47f07eef4e@linux-foundation.org>
References: <20180503192430.7582-1-ross.zwisler@linux.intel.com>
 <20180508174424.GA12638@linux.intel.com>
 <20180510154844.dc4e4c7471a885b73ed50576@linux-foundation.org>
 <CAPcyv4hy40dRr81aO7mr5LhC4L=es6NXE_kDCO2+USGXovGDiQ@mail.gmail.com>
 <20180510161242.0f9f97686a9c0a47f07eef4e@linux-foundation.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 May 2018 16:19:34 -0700
Message-ID: <CAPcyv4jpxLarYA3UmWdCu54MR-eYZJO9j22h7_VR27Bkaejkdw@mail.gmail.com>
Subject: Re: [PATCH 0/5] fix radix tree multi-order iteration race
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 10, 2018 at 4:12 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 10 May 2018 15:54:53 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
>
>> > - The Fixes: tag
>> > - The Reported-by
>>
>> Those were there.
>>
>> > - Jan's reviewed-by
>>
>> Right, Jan's came after I pushed it for -next soaking, but I updated it.
>>
>> > - the cc:stable tag
>>
>> That was there too, not sure where you were looking.
>
> git show 4272afac65e0debacae7eb6af4591e31ba89dcad

That was the unit test suite patch, see the following actual fix:

7fa96cd88dbc: before Jan's reviewed-by

ce376ed6b706: after
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
