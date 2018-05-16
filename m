Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 472B2203B85BD
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 19:52:26 -0700 (PDT)
Date: Tue, 15 May 2018 19:52:18 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [External]  Re: [RFC PATCH v1 0/6] use mm to manage NVDIMM
 (pmem) zone
Message-ID: <20180516025218.GA17352@bombadil.infradead.org>
References: <20180507184622.GB12361@bombadil.infradead.org>
 <CAPcyv4hBJN3npXwg3Ur32JSWtKvBUZh7F8W+Exx3BB-uKWwPag@mail.gmail.com>
 <x49a7tbi8r3.fsf@segfault.boston.devel.redhat.com>
 <HK2PR03MB1684659175EB0A11E75E9B61929A0@HK2PR03MB1684.apcprd03.prod.outlook.com>
 <20180508030959.GB16338@bombadil.infradead.org>
 <HK2PR03MB16841CBB549F40F86BB8D35C92990@HK2PR03MB1684.apcprd03.prod.outlook.com>
 <20180510162742.GA30442@bombadil.infradead.org>
 <HK2PR03MB1684B34F9D1DF18A8CDE18F292930@HK2PR03MB1684.apcprd03.prod.outlook.com>
 <20180515162003.GA26489@bombadil.infradead.org>
 <HK2PR03MB1684F8D2724BB8AF1FCCF02A92920@HK2PR03MB1684.apcprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <HK2PR03MB1684F8D2724BB8AF1FCCF02A92920@HK2PR03MB1684.apcprd03.prod.outlook.com>
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
Cc: Sasha Levin <alexander.levin@verizon.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, NingTing Cheng <chengnt@lenovo.com>, Ocean HY1 He <hehy1@lenovo.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "pasha.tatashin@oracle.com" <pasha.tatashin@oracle.com>, Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, Johannes Weiner <hannes@cmpxchg.org>, "colyli@suse.de" <colyli@suse.de>, Mel Gorman <mgorman@techsingularity.net>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 16, 2018 at 02:05:05AM +0000, Huaisheng HS1 Ye wrote:
> > From: Matthew Wilcox [mailto:willy@infradead.org]
> > Sent: Wednesday, May 16, 2018 12:20 AM> 
> > > > > > Then there's the problem of reconnecting the page cache (which is
> > > > > > pointed to by ephemeral data structures like inodes and dentries) to
> > > > > > the new inodes.
> > > > > Yes, it is not easy.
> > > >
> > > > Right ... and until we have that ability, there's no point in this patch.
> > > We are focusing to realize this ability.
> > 
> > But is it the right approach?  So far we have (I think) two parallel
> > activities.  The first is for local storage, using DAX to store files
> > directly on the pmem.  The second is a physical block cache for network
> > filesystems (both NAS and SAN).  You seem to be wanting to supplant the
> > second effort, but I think it's much harder to reconnect the logical cache
> > (ie the page cache) than it is the physical cache (ie the block cache).
> 
> Dear Matthew,
> 
> Thanks for correcting my idea with cache line.
> But I have questions about that, assuming NVDIMM works with pmem mode, even we
> used it as physical block cache, like dm-cache, there is potential risk with
> this cache line issue, because NVDIMMs are bytes-address storage, right?
> If system crash happens, that means CPU doesn't have opportunity to flush all dirty
> data from cache lines to NVDIMM, during copying data pointed by bio_vec.bv_page to
> NVDIMM. 
> I know there is btt which is used to guarantee sector atomic with block mode,
> but for pmem mode that will likely cause mix of new and old data in one page
> of NVDIMM.
> Correct me if anything wrong.

Right, we do have BTT.  I'm not sure how it's being used with the block
cache ... but the principle is the same; write the new data to a new
page and then update the metadata to point to the new page.

> Another question, if we used NVDIMMs as physical block cache for network filesystems,
> Does industry have existing implementation to bypass Page Cache similarly like DAX way,
> that is to say, directly storing data to NVDIMMs from userspace, rather than copying
> data from kernel space memory to NVDIMMs.

The important part about DAX is that the kernel gets entirely out of the
way and userspace takes care of handling flushing and synchronisation.
I'm not sure how that works with the block cache; for a network
filesystem, the filesystem needs to be in charge of deciding when and
how to write the buffered data back to the storage.

Dan, Vishal, perhaps you could jump in here; I'm not really sure where
this effort has got to.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
