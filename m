Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x22f.google.com (mail-ua0-x22f.google.com
 [IPv6:2607:f8b0:400c:c08::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A616721CE7490
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 08:45:03 -0700 (PDT)
Received: by mail-ua0-x22f.google.com with SMTP id k43so8854121uaf.3
 for <linux-nvdimm@lists.01.org>; Fri, 04 Aug 2017 08:47:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804060747.GA4218@linux-x5ow.site>
References: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
 <150153988620.49768.12914164179718467335.stgit@djiang5-desk3.ch.intel.com>
 <mqdy3r3zqpy.fsf@linux-x5ow.site>
 <CAPcyv4hvY4swcyijRaSR8QpMEv1w=g52udpW7F9Qs-1oS0bskQ@mail.gmail.com>
 <20170803080615.GB4333@linux-x5ow.site>
 <CAPcyv4ibnZ8xPLyL3AUUvZrhyU7-dT9hk5aA-eF=E3cxYinATw@mail.gmail.com>
 <2dc39cda-ba3f-7b5f-6f96-69ee4fd71a25@intel.com>
 <CAPcyv4joibpPF1LhoMVnPjSwqDkrp4FzzPojbaFiZ9KOs=+fuw@mail.gmail.com>
 <20170804060747.GA4218@linux-x5ow.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 4 Aug 2017 08:47:14 -0700
Message-ID: <CAPcyv4jbYR87n6cLCAfK+sD+qHgSs5iEZUSK_beDsUCOVaDvMQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] libnvdimm: add DMA support for pmem blk-mq
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Koul, Vinod" <vinod.koul@intel.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 3, 2017 at 11:07 PM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Thu, Aug 03, 2017 at 09:15:12AM -0700, Dan Williams wrote:
>> > I can put in a tunable knob like Johannes suggested and leave the
>> > default for that to what it is currently. And we can adjust as necessary
>> > as we do more testing.
>>
>> That's the problem, we need a multi-dimensional knob. It's not just
>> transfer-size that effects total delivered bandwidth.
>
> If Dan opposes it so much, I'm OK with no tunable. I'm just expressing my
> concern that we get reports like this [1] one here as a result.

Sorry if I came off harsh. In that report from Mel he's showing a slow
down in a representative workload not just a canned bandwidth
benchmark. I'm worried that tuning for a single dimension on an fio
run doesn't actually improve throughput delivered to an application.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
