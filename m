Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FBFF2096AEF4
 for <linux-nvdimm@lists.01.org>; Fri, 18 May 2018 13:15:01 -0700 (PDT)
Received: by mail-ot0-x241.google.com with SMTP id t1-v6so10525803oth.8
 for <linux-nvdimm@lists.01.org>; Fri, 18 May 2018 13:15:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1805181514420.28860@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1803080824210.2819@file01.intranet.prod.int.rdu2.redhat.com>
 <20180308145153.GB23262@infradead.org>
 <CAPcyv4gBUt5NYK2Lx0dMZAnENeSgKm3KaUvY9kkqB+PNPyQu4w@mail.gmail.com>
 <20180518154454.GA4902@redhat.com>
 <CAPcyv4hAZVTE7T7q7YRN6QvxfVR64c3jBpCTu-rCvNAB1-OWSA@mail.gmail.com>
 <alpine.LRH.2.02.1805181514420.28860@file01.intranet.prod.int.rdu2.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 May 2018 13:14:59 -0700
Message-ID: <CAPcyv4jecVBaJb5WeO3FdbJ8xabishbAccORoXN2pHKOvUc2qA@mail.gmail.com>
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

On Fri, May 18, 2018 at 1:12 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Fri, 18 May 2018, Dan Williams wrote:
>
>> On Fri, May 18, 2018 at 8:44 AM, Mike Snitzer <snitzer@redhat.com> wrote:
>> > On Thu, Mar 08 2018 at 12:08pm -0500,
>> > Dan Williams <dan.j.williams@intel.com> wrote:
>> >
>> >> Mikulas sent this useful enhancement to the memcpy_flushcache API:
>> >>
>> >>     https://patchwork.kernel.org/patch/10217655/
>> >>
>> >> ...it's in my queue to either push through -tip or add it to the next
>> >> libnvdimm pull request for 4.17-rc1.
>> >
>> > Hi Dan,
>> >
>> > Seems this never actually went upstream.  I've staged it in
>> > linux-dm.git's "for-next" for the time being:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.18&id=a7e96990b5ff6206fefdc5bfe74396bb880f7e48
>> >
>> > But do you intend to pick it up for 4.18 inclusion?  If so I'll drop
>> > it.. would just hate for it to get dropped on the floor by getting lost
>> > in the shuffle between trees.
>> >
>> > Please avise, thanks!
>> > Mike
>>
>> Thanks for picking it up! I was hoping to resend it to get acks from
>> x86 folks, and then yes it fell through the cracks in my patch
>> tracking.
>>
>> Now that I look at it again I don't think we need this hunk:
>>
>> void memcpy_page_flushcache(char *to, struct page *page, size_t offset,
>> size_t len)
>> {
>> char *from = kmap_atomic(page);
>> - memcpy_flushcache(to, from + offset, len);
>> + __memcpy_flushcache(to, from + offset, len);
>> kunmap_atomic(from);
>> }
>
> Yes - this is not needed.
>
>> ...and I wonder what the benefit is of the 16-byte case? I would
>> assume the bulk of the benefit is limited to the 4 and 8 byte copy
>> cases.
>
> dm-writecache uses 16-byte writes frequently, so it is needed for that.
>
> If we split 16-byte write to two 8-byte writes, it would degrade
> performance for architectures where memcpy_flushcache needs to flush the
> cache.

My question was how measurable it is to special case 16-byte
transfers? I know Ingo is going to ask this question, so it would
speed things along if this patch included performance benefit numbers
for each special case in the changelog.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
