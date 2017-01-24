Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22b.google.com (mail-ot0-x22b.google.com
 [IPv6:2607:f8b0:4003:c0f::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6644E81F03
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jan 2017 10:26:55 -0800 (PST)
Received: by mail-ot0-x22b.google.com with SMTP id 65so133800457otq.2
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jan 2017 10:26:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170124111248.GC20153@quack2.suse.cz>
References: <148521477073.31533.17781371321988910714.stgit@djiang5-desk3.ch.intel.com>
 <20170124111248.GC20153@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 24 Jan 2017 10:26:54 -0800
Message-ID: <CAPcyv4gW7cho=eE4BQZQ69J7ehREurP6CPbQX3z6eW7BUVT3Bw@mail.gmail.com>
Subject: Re: [PATCH 0/3] 1G transparent hugepage support for device dax
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
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, Linux MM <linux-mm@kvack.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jan Kara <jack@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 24, 2017 at 3:12 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 23-01-17 16:47:18, Dave Jiang wrote:
>> The following series implements support for 1G trasparent hugepage on
>> x86 for device dax. The bulk of the code was written by Mathew Wilcox
>> a while back supporting transparent 1G hugepage for fs DAX. I have
>> forward ported the relevant bits to 4.10-rc. The current submission has
>> only the necessary code to support device DAX.
>
> Well, you should really explain why do we want this functionality... Is
> anybody going to use it? Why would he want to and what will he gain by
> doing so? Because so far I haven't heard of a convincing usecase.
>

So the motivation and intended user of this functionality mirrors the
motivation and users of 1GB page support in hugetlbfs. Given expected
capacities of persistent memory devices an in-memory database may want
to reduce tlb pressure beyond what they can already achieve with 2MB
mappings of a device-dax file. We have customer feedback to that
effect as Willy mentioned in his previous version of these patches
[1].

[1]: https://lkml.org/lkml/2016/1/31/52
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
