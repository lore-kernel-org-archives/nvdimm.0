Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8743E203B85B9
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 19:48:59 -0700 (PDT)
Received: by mail-ot0-x243.google.com with SMTP id l12-v6so2686068oth.6
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 19:48:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <HK2PR03MB1684F8D2724BB8AF1FCCF02A92920@HK2PR03MB1684.apcprd03.prod.outlook.com>
References: <1525704627-30114-1-git-send-email-yehs1@lenovo.com>
 <20180507184622.GB12361@bombadil.infradead.org>
 <CAPcyv4hBJN3npXwg3Ur32JSWtKvBUZh7F8W+Exx3BB-uKWwPag@mail.gmail.com>
 <x49a7tbi8r3.fsf@segfault.boston.devel.redhat.com>
 <HK2PR03MB1684659175EB0A11E75E9B61929A0@HK2PR03MB1684.apcprd03.prod.outlook.com>
 <20180508030959.GB16338@bombadil.infradead.org>
 <HK2PR03MB16841CBB549F40F86BB8D35C92990@HK2PR03MB1684.apcprd03.prod.outlook.com>
 <20180510162742.GA30442@bombadil.infradead.org>
 <HK2PR03MB1684B34F9D1DF18A8CDE18F292930@HK2PR03MB1684.apcprd03.prod.outlook.com>
 <20180515162003.GA26489@bombadil.infradead.org>
 <HK2PR03MB1684F8D2724BB8AF1FCCF02A92920@HK2PR03MB1684.apcprd03.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 May 2018 19:48:57 -0700
Message-ID: <CAPcyv4hFzzF-jZd3-3vLNbB6SHD1Z5+wuRqgiuubnztAEzsSJQ@mail.gmail.com>
Subject: Re: [External] Re: [RFC PATCH v1 0/6] use mm to manage NVDIMM (pmem)
 zone
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
To: Huaisheng HS1 Ye <yehs1@lenovo.com>
Cc: Sasha Levin <alexander.levin@verizon.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, NingTing Cheng <chengnt@lenovo.com>, Ocean HY1 He <hehy1@lenovo.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, "pasha.tatashin@oracle.com" <pasha.tatashin@oracle.com>, Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, "colyli@suse.de" <colyli@suse.de>, Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 15, 2018 at 7:05 PM, Huaisheng HS1 Ye <yehs1@lenovo.com> wrote:
>> From: Matthew Wilcox [mailto:willy@infradead.org]
>> Sent: Wednesday, May 16, 2018 12:20 AM>
>> > > > > Then there's the problem of reconnecting the page cache (which is
>> > > > > pointed to by ephemeral data structures like inodes and dentries) to
>> > > > > the new inodes.
>> > > > Yes, it is not easy.
>> > >
>> > > Right ... and until we have that ability, there's no point in this patch.
>> > We are focusing to realize this ability.
>>
>> But is it the right approach?  So far we have (I think) two parallel
>> activities.  The first is for local storage, using DAX to store files
>> directly on the pmem.  The second is a physical block cache for network
>> filesystems (both NAS and SAN).  You seem to be wanting to supplant the
>> second effort, but I think it's much harder to reconnect the logical cache
>> (ie the page cache) than it is the physical cache (ie the block cache).
>
> Dear Matthew,
>
> Thanks for correcting my idea with cache line.
> But I have questions about that, assuming NVDIMM works with pmem mode, even we
> used it as physical block cache, like dm-cache, there is potential risk with
> this cache line issue, because NVDIMMs are bytes-address storage, right?

No, there is no risk if the cache is designed properly. The pmem
driver will not report that the I/O is complete until the entire
payload of the data write has made it to persistent memory. The cache
driver will not report that the write succeeded until the pmem driver
completes the I/O. There is no risk to losing power while the pmem
driver is operating because the cache will recover to it's last
acknowledged stable state, i.e. it will roll back / undo the
incomplete write.

> If system crash happens, that means CPU doesn't have opportunity to flush all dirty
> data from cache lines to NVDIMM, during copying data pointed by bio_vec.bv_page to
> NVDIMM.
> I know there is btt which is used to guarantee sector atomic with block mode,
> but for pmem mode that will likely cause mix of new and old data in one page
> of NVDIMM.
> Correct me if anything wrong.

dm-cache is performing similar metadata management as the btt driver
to ensure safe forward progress of the cache state relative to power
loss or system-crash.

> Another question, if we used NVDIMMs as physical block cache for network filesystems,
> Does industry have existing implementation to bypass Page Cache similarly like DAX way,
> that is to say, directly storing data to NVDIMMs from userspace, rather than copying
> data from kernel space memory to NVDIMMs.

Any caching solution with associated metadata requires coordination
with the kernel, so it is not possible for the kernel to stay
completely out of the way. Especially when we're talking about a cache
in front of the network there is not much room for DAX to offer
improved performance because we need the kernel to takeover on all
write-persist operations to update cache metadata.

So, I'm still struggling to see why dm-cache is not a suitable
solution for this case. It seems suitable if it is updated to allow
direct dma-access to the pmem cache pages from the backing device
storage / networking driver.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
