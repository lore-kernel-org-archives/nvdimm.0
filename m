Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 19EA120965DCE
 for <linux-nvdimm@lists.01.org>; Wed,  9 May 2018 09:04:32 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id l22-v6so40762253otj.0
 for <linux-nvdimm@lists.01.org>; Wed, 09 May 2018 09:04:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180509204727.7ff38021@canb.auug.org.au>
References: <CAKMK7uHjA27K8y-kwYFyhLy3cSkJJw8Oe1gP=3hZXdfxcWAcNQ@mail.gmail.com>
 <20180502194632.GB18390@sasha-vm> <20180503020550.GP2714@sirena.org.uk>
 <20180503031000.GC29205@thunk.org>
 <0276fcda-0385-8f22-dbdb-e063f7ed8bbe@roeck-us.net>
 <20180503224217.GR2714@sirena.org.uk> <20180503230905.GA98604@atomide.com>
 <CAPDyKFrCKkRHwOh-7yfFbvMp+Ykhs7oXrDwhTShSPvUBvpn2ZQ@mail.gmail.com>
 <20180509084440.GW13402@sirena.org.uk>
 <CAKMK7uEWYmhA3owSeYM9tNA0tpMm5=4Yqda2j=VfMWi7i8ya8w@mail.gmail.com>
 <20180509090346.GY13402@sirena.org.uk>
 <20180509204727.7ff38021@canb.auug.org.au>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 May 2018 09:04:31 -0700
Message-ID: <CAPcyv4jtNXhMwCqpbKkHe5e-nDPK+2Wq=maFsB_SMSGyg7fw5w@mail.gmail.com>
Subject: Re: [Ksummit-discuss] bug-introducing patches
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "ksummit-discuss@lists.linuxfoundation.org" <ksummit-discuss@lists.linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>, "w@1wt.eu" <w@1wt.eu>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 9, 2018 at 3:47 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Wed, 9 May 2018 18:03:46 +0900 Mark Brown <broonie@kernel.org> wrote:
>>
>> On Wed, May 09, 2018 at 10:47:57AM +0200, Daniel Vetter wrote:
>> > On Wed, May 9, 2018 at 10:44 AM, Mark Brown <broonie@kernel.org> wrote:
>>
>> > > I think this is an excellent idea, copying in Stephen for his input.
>> > > I'm currently on holiday but unless someone convinces me it's a terrible
>> > > idea I'm willing to at least give it a go on a trial basis once I'm back
>> > > home.
>>
>> > Since Stephen merges all -fixes branches first, before merging all the
>> > -next branches, he already generates that as part of linux-next. All
>> > he'd need to do is push that intermediate state out to some
>> > linux-fixes branch for consumption by test bots.
>
> Good idea ... I will see what I can do.
>
>> True.  It's currently only those -fixes branches that people have asked
>> him to merge separately which isn't as big a proportion of trees as have
>> them (perhaps fortunately given people's enthusiasm for fixes branches
>> that don't merge cleanly with their development branches) so we'd also
>> need to encourage people to add them separately.
>
> I currently have 44 such fixes branches.  More welcome!

Please add:

    git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git
libnvdimm-fixes

We currently merge this into libnvdimm-for-next for -next coverage,
and resolve any conflicts vs new development. Do you want to see those
conflicts? Otherwise I would recommend only pulling libnvdimm-for-next
for -next and libnvdimm-fixes for this new -next-fixes effort.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
