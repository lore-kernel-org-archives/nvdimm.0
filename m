Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DEF21203BA4F8
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 12:30:41 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id v2-v6so26228338oif.3
 for <linux-nvdimm@lists.01.org>; Mon, 07 May 2018 12:30:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180507191857.GA15604@bombadil.infradead.org>
References: <1525704627-30114-1-git-send-email-yehs1@lenovo.com>
 <20180507184622.GB12361@bombadil.infradead.org>
 <CAPcyv4hBJN3npXwg3Ur32JSWtKvBUZh7F8W+Exx3BB-uKWwPag@mail.gmail.com>
 <20180507191857.GA15604@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 May 2018 12:30:40 -0700
Message-ID: <CAPcyv4g_Pua2+3FsEuCyLndX__Tbvk03J0WSc37u+kWvxthQ2Q@mail.gmail.com>
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>, Huaisheng Ye <yehs1@lenovo.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, chengnt@lenovo.com, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pasha.tatashin@oracle.com, Linux MM <linux-mm@kvack.org>, colyli@suse.de, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <alexander.levin@verizon.com>, Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 7, 2018 at 12:18 PM, Matthew Wilcox <willy@infradead.org> wrote:
> On Mon, May 07, 2018 at 11:57:10AM -0700, Dan Williams wrote:
>> I think adding yet one more mm-zone is the wrong direction. Instead,
>> what we have been considering is a mechanism to allow a device-dax
>> instance to be given back to the kernel as a distinct numa node
>> managed by the VM. It seems it times to dust off those patches.
>
> I was wondering how "safe" we think that ability is.  NV-DIMM pages
> (obviously) differ from normal pages by their non-volatility.  Do we
> want their contents from the previous boot to be observable?  If not,
> then we need the BIOS to clear them at boot-up, which means we would
> want no kernel changes at all; rather the BIOS should just describe
> those pages as if they were DRAM (after zeroing them).

Certainly the BIOS could do it, but the impetus for having a kernel
mechanism to do the same is for supporting the configuration
flexibility afforded by namespaces, or otherwise having the capability
when the BIOS does not offer it. However, you are right that there are
extra security implications when System-RAM is persisted, perhaps
requiring the capacity to be explicitly locked / unlocked could
address that concern?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
