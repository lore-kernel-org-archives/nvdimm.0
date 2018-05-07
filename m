Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1917520961094
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 12:29:57 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id y15-v6so26230757oia.13
 for <linux-nvdimm@lists.01.org>; Mon, 07 May 2018 12:29:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x491seni7tu.fsf@segfault.boston.devel.redhat.com>
References: <1525704627-30114-1-git-send-email-yehs1@lenovo.com>
 <20180507184622.GB12361@bombadil.infradead.org>
 <CAPcyv4hBJN3npXwg3Ur32JSWtKvBUZh7F8W+Exx3BB-uKWwPag@mail.gmail.com>
 <x49a7tbi8r3.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hekYsXFy1PHg7zMyoWtj1pYVfnANfrhpk-+Hr_NBV=BQ@mail.gmail.com>
 <x491seni7tu.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 May 2018 12:29:55 -0700
Message-ID: <CAPcyv4gbnqv4=mKPyiDskGKE9HveN6S9rzSmYGQ7QjCPg6W0cQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/6] use mm to manage NVDIMM (pmem) zone
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Sasha Levin <alexander.levin@verizon.com>, Michal Hocko <mhocko@suse.com>, Huaisheng Ye <yehs1@lenovo.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, chengnt@lenovo.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, pasha.tatashin@oracle.com, Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, colyli@suse.de, Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 7, 2018 at 12:28 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
[..]
>>> What's the use case?
>>
>> Use NVDIMMs as System-RAM given their potentially higher capacity than
>> DDR. The expectation in that case is that data is forfeit (not
>> persisted) after a crash. Any persistent use case would need to go
>> through the pmem driver, filesystem-dax or device-dax.
>
> OK, but that sounds different from what was being proposed, here.  I'll
> quote from above:
>
>>>>>> But for the critical pages, which we hope them could be recovered
>                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>>> from power fail or system crash, we make them to be persistent by
>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>>> storing them to NVM zone.
>
> Hence my confusion.

Yes, now mine too, I overlooked that.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
