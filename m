Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D0A220348624
 for <linux-nvdimm@lists.01.org>; Fri, 18 May 2018 15:10:06 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id l1-v6so8421905oii.1
 for <linux-nvdimm@lists.01.org>; Fri, 18 May 2018 15:10:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1805181755410.27649@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1803080824210.2819@file01.intranet.prod.int.rdu2.redhat.com>
 <20180308145153.GB23262@infradead.org>
 <CAPcyv4gBUt5NYK2Lx0dMZAnENeSgKm3KaUvY9kkqB+PNPyQu4w@mail.gmail.com>
 <20180518154454.GA4902@redhat.com>
 <CAPcyv4hAZVTE7T7q7YRN6QvxfVR64c3jBpCTu-rCvNAB1-OWSA@mail.gmail.com>
 <alpine.LRH.2.02.1805181514420.28860@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jecVBaJb5WeO3FdbJ8xabishbAccORoXN2pHKOvUc2qA@mail.gmail.com>
 <alpine.LRH.2.02.1805181755410.27649@file01.intranet.prod.int.rdu2.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 May 2018 15:10:04 -0700
Message-ID: <CAPcyv4iO-6QHSb58O3TVUgiZvQ5BBAq=_=yP1kW5oTHkjS3b3Q@mail.gmail.com>
Subject: Re: dm-writecache
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 18, 2018 at 3:00 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Fri, 18 May 2018, Dan Williams wrote:
>
>> >> ...and I wonder what the benefit is of the 16-byte case? I would
>> >> assume the bulk of the benefit is limited to the 4 and 8 byte copy
>> >> cases.
>> >
>> > dm-writecache uses 16-byte writes frequently, so it is needed for that.
>> >
>> > If we split 16-byte write to two 8-byte writes, it would degrade
>> > performance for architectures where memcpy_flushcache needs to flush the
>> > cache.
>>
>> My question was how measurable it is to special case 16-byte
>> transfers? I know Ingo is going to ask this question, so it would
>> speed things along if this patch included performance benefit numbers
>> for each special case in the changelog.
>
> I tested it some times ago - and the movnti instruction has 2% better
> throughput than the existing memcpy_flushcache function.
>
> It is doing one 16-byte write for every sector written and one 8-byte
> write for every sector clean-up. So, the overhead is measurable.

Awesome, include those measured numbers in the changelog for the next
spin of the patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
