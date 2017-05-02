Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22c.google.com (mail-io0-x22c.google.com
 [IPv6:2607:f8b0:4001:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0BBC521A13484
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 11:51:14 -0700 (PDT)
Received: by mail-io0-x22c.google.com with SMTP id r16so170463098ioi.2
 for <linux-nvdimm@lists.01.org>; Tue, 02 May 2017 11:51:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170502184309.GA11414@omniknight.lm.intel.com>
References: <149368138628.53639.13278265267164943868.stgit@djiang5-desk3.ch.intel.com>
 <1493684163.30303.36.camel@hpe.com>
 <dc1d6252-9c8c-5298-2823-2609db70ceb6@intel.com>
 <1493743683.30303.38.camel@hpe.com>
 <20170502184309.GA11414@omniknight.lm.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 May 2017 11:51:12 -0700
Message-ID: <CAPcyv4iuWkhua8U-7go_gA4Sydrs77DFqisFAUhaYQVm__tOrg@mail.gmail.com>
Subject: Re: [PATCH v4] ndctl: add clear error support for ndctl
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 2, 2017 at 11:43 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> On 05/02, Kani, Toshimitsu wrote:
>> On Tue, 2017-05-02 at 09:18 -0700, Dave Jiang wrote:
>> > > +-l::
>> > > > +--len::
>> > > > +The number of badblocks to clear in size of 512 bytes
>> > > > increments. The
>> > > > +length must fit within the badblocks range. If the length
>> > > > exceeds the
>> > > > +badblock range or is 0, the command will fail.
>> > >
>> > > Actually, I am seeing '-l 0' works just like '-l 1'.
>> >
>> > Oh now I remembered that Vishal requested that no length does 1 block
>> > clear. Do you want me to correct documentation or behavior?
>>
>> What is the reason behind of his request?
>
> Ah, so my intention/reasoning was if someone does a simple:
>   ndctl clear-error -s 'X'
> without providing a -l argument, it should dimply clear that one block.
> However I wouldn't think -l0 should clear one block, we should either
> error out, or treat it as a dry-run (perhaps this could be an indirect
> way to check if a certain block is in the badblocks list?)
>
> Anyway, I'm not too attached to the "should work without providing a -l"
> thing, and we can make -l mandatory again if that makes most sense.

I like that no "-l" option is equivalent to "-l 1". "-l 0" should be
an error. I don't think we need a test or dry-run option if we just
have an interface to list all the error offsets relative to the given
device.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
