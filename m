Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 91D1F22590E02
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 21:08:51 -0700 (PDT)
Received: by mail-ot0-x243.google.com with SMTP id h55-v6so19924165ote.9
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 21:08:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180417001907.GB25048@bombadil.infradead.org>
References: <20180414155059.GA18015@jordon-HP-15-Notebook-PC>
 <CAPcyv4g+Gdc2tJ1qrM5Xn9vtARw-ZqFXaMbiaBKJJsYDtSNBig@mail.gmail.com>
 <20180417001421.GH22870@thunk.org>
 <20180417001907.GB25048@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Apr 2018 21:08:50 -0700
Message-ID: <CAPcyv4jYbmEEWYEhn8epDVQL=L7_cx3g7F5MNAqq6P7hTpJoOg@mail.gmail.com>
Subject: Re: [PATCH] dax: Change return type to vm_fault_t
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, Souptick Joarder <jrdr.linux@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 16, 2018 at 5:19 PM, Matthew Wilcox <willy@infradead.org> wrote:
> On Mon, Apr 16, 2018 at 08:14:22PM -0400, Theodore Y. Ts'o wrote:
>> On Mon, Apr 16, 2018 at 09:14:48AM -0700, Dan Williams wrote:
>> > Ugh, so this change to vmf_insert_mixed() went upstream without fixing
>> > the users? This changelog is now misleading as it does not mention
>> > that is now an urgent standalone fix. On first read I assumed this was
>> > part of a wider effort for 4.18.
>>
>> Why is this an urgent fix?  I thought all the return type change was
>> did something completely innocuous that would not cause any real
>> difference.
>
> Keep reading the thread; Dan is mistaken.

Yes, false alarm, sorry. But we at least got a better changelog for the trouble.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
