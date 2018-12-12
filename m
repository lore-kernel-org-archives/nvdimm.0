Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com
 [148.163.147.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 269522119681D
 for <linux-nvdimm@lists.01.org>; Wed, 12 Dec 2018 11:49:51 -0800 (PST)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: Snapshot target and DAX-capable devices
Date: Wed, 12 Dec 2018 19:49:25 +0000
Message-ID: <cdeadbe0b16244a07f2417902c1f46eb1141d96f.camel@hpe.com>
References: <20180828075025.GA17756@quack2.suse.cz>
 <20180828175630.GA1197@redhat.com> <20180830093028.GC1767@quack2.suse.cz>
 <20180830184907.GA14867@redhat.com>
 <x494lfbabwi.fsf@segfault.boston.devel.redhat.com>
 <alpine.LRH.2.02.1808301545200.30950@file01.intranet.prod.int.rdu2.redhat.com>
 <20180830233809.GH1572@dastard> <20180831094255.GB11622@quack2.suse.cz>
 <167a3303a01.11a848ab768799.5161498967766415143@zoho.com>
 <20181212161254.GA20790@infradead.org> <20181212175047.GA24962@redhat.com>
In-Reply-To: <20181212175047.GA24962@redhat.com>
Content-Language: en-US
Content-ID: <4214681ED56B6A43AED1CAB47BB5D7DE@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
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
To: "hch@infradead.org" <hch@infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "chengnt@lenovo.com" <chengnt@lenovo.com>, "david@fromorbit.com" <david@fromorbit.com>, "colyli@suse.de" <colyli@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "mpatocka@redhat.com" <mpatocka@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2018-12-12 at 12:50 -0500, Mike Snitzer wrote:
> On Wed, Dec 12 2018 at 11:12am -0500,
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > Does it really make sense to enhance dm-snapshot?  I thought all serious
> > users of snapshots had moved on to dm-thinp?
> 
> There are cases where dm-snapshot is still useful for people.  But those
> are very niche users.  I'm not opposed to others proposing enhancements
> for dm-snapshot in general but it is definitely not a priority (Google's
> dm-bow is an example of a case where dm-snapshot may get extended to
> fulfill google's needs).
> 
> But for this specific DAX case, I can only assume efforts to prop up
> dm-snapshot like this are born out of legacy use-cases.  The reality is
> getting DAX to work with dm-snapshot is pretty involved (due to mmap,
> etc).  This thread got into a lot of the details:
> https://www.redhat.com/archives/dm-devel/2018-August/msg00211.html
> 
> So any new attempt to reintroduce DAX support to dm-snapshot (or any
> more complex DM target) will have a very high bar.  One that requires
> much more extensive mm and block (interlock) prep work to make DAX
> safe.

Just to be clear, "reintroduce DAX support to dm-snapshot" is a bit
misleading because there wasn't such attempt before.  My original
hack/change in dm-snapshot was to support non-DAX use-cases to work with
DAX-capable devices.

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
