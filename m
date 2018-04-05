Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 54304226FAA61
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 15:17:19 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id 71-v6so23845107oie.12
 for <linux-nvdimm@lists.01.org>; Thu, 05 Apr 2018 15:17:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180405080118.GA32396@infradead.org>
References: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4hZfNOG15guKE0Lq=QoFr8DZerEH=1=OjnrEY2trPXNcw@mail.gmail.com>
 <20180405072317.GA2855@infradead.org>
 <CAPcyv4jn2DHu9HGH=XPr9VHP0gyENFKEiXr=w5hO2UR_tRWc0A@mail.gmail.com>
 <20180405080118.GA32396@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 5 Apr 2018 15:17:17 -0700
Message-ID: <CAPcyv4i3iVyQN+uCOihR9+qpk9AcVUB1YJLjDJ-DQv3afuJxYw@mail.gmail.com>
Subject: Re: [PATCH] dax: adding fsync/msync support for device DAX
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 5, 2018 at 1:01 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Apr 05, 2018 at 12:56:02AM -0700, Dan Williams wrote:
>> Yes, I think it is unfortunate that the failure mode is exposed to
>> software at all. The problem is that ADR is a platform feature that
>> depends on power supply requirements external to the NVDIMM device. An
>> SSD is different. It is a self contained system that can arrange for
>> the whole device to fail if the internal energy source fails and
>> otherwise hide this detail from software. My personal take, a system
>> designer that can specify and qualify an entire stack of components
>> can certainly opt-out of advertising the flush capability to the OS
>> because, like the SSD vendor, they control the integrated solution. A
>> platform vendor that allows off the shelf power supplies would in my
>> opinion be remiss not to give the OS the option to mitigate the
>> quality of some random power supply. It then follow that if the OS has
>> the ability to mitigate ADR failure it should be through a common
>> interface between fsdax and devdax.
>
> That means IFF ADR can fail like this we can't treat it as stable
> storage and we must not support MAP_SYNC or equivalent device dax
> behavior, period.

Makes sense, we won't pursue *sync() support on device-dax it doesn't fit.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
